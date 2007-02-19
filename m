Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54731 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965109AbXBSWjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:20 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/12] d80211: Fix concurrency issues in ieee80211_sta.c
Message-Id: <20070219223949.BC8D9484A9@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:49 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This fixes most concurrency issues in ieee80211_sta.c and partially
prevents scans from running over an association in progress and vice versa.
This is achieved by forcing all potentially racy code to run from a
workqueue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211.c       |    4 +
 net/d80211/ieee80211_i.h     |    9 ++
 net/d80211/ieee80211_iface.c |    5 +
 net/d80211/ieee80211_sta.c   |  199 ++++++++++++++++++++++++++++++------------
 4 files changed, 159 insertions(+), 58 deletions(-)

da5fe6c969d76187b3ceeda46e4dc527d73ebae6
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index a0c367c..03d4028 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2179,7 +2179,9 @@ void ieee80211_if_shutdown(struct net_de
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
-		cancel_delayed_work(&sdata->u.sta.work);
+		del_timer_sync(&sdata->u.sta.timer);
+		flush_scheduled_work();
+		skb_queue_purge(&sdata->u.sta.skb_queue);
 		if (!local->ops->hw_scan &&
 		    local->scan_dev == sdata->dev) {
 			local->sta_scanning = 0;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index bb8fc83..61bcdf0 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -242,7 +242,8 @@ struct ieee80211_if_sta {
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
 		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
 	} state;
-	struct delayed_work work;
+	struct timer_list timer;
+	struct work_struct work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
@@ -267,6 +268,11 @@ struct ieee80211_if_sta {
 	unsigned int create_ibss:1;
 	unsigned int mixed_cell:1;
 	unsigned int wmm_enabled:1;
+#define IEEE80211_STA_REQ_SCAN 0
+#define IEEE80211_STA_REQ_AUTH 1
+#define IEEE80211_STA_REQ_RUN  2
+	unsigned long request;
+	struct sk_buff_head skb_queue;
 
 	int key_mgmt;
 	unsigned long last_probe;
@@ -660,6 +666,7 @@ int ieee80211_set_compression(struct iee
 			      struct net_device *dev, struct sta_info *sta);
 int ieee80211_init_client(struct net_device *dev);
 /* ieee80211_sta.c */
+void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
 void ieee80211_sta_scan_work(struct work_struct *work);
 void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
diff --git a/net/d80211/ieee80211_iface.c b/net/d80211/ieee80211_iface.c
index 342ad2a..939e289 100644
--- a/net/d80211/ieee80211_iface.c
+++ b/net/d80211/ieee80211_iface.c
@@ -185,7 +185,10 @@ void ieee80211_if_set_type(struct net_de
 		struct ieee80211_if_sta *ifsta;
 
 		ifsta = &sdata->u.sta;
-		INIT_DELAYED_WORK(&ifsta->work, ieee80211_sta_work);
+		INIT_WORK(&ifsta->work, ieee80211_sta_work);
+		setup_timer(&ifsta->timer, ieee80211_sta_timer,
+			    (unsigned long) ifsta);
+		skb_queue_head_init(&ifsta->skb_queue);
 
 		ifsta->capab = WLAN_CAPABILITY_ESS;
 		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 0e45a65..66e81d7 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -64,6 +64,10 @@ static void ieee80211_rx_bss_put(struct 
 static int ieee80211_sta_find_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta);
 static int ieee80211_sta_wep_configured(struct net_device *dev);
+static int ieee80211_sta_start_scan(struct net_device *dev,
+				    u8 *ssid, size_t ssid_len);
+static void ieee80211_sta_reset_auth(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta);
 
 
 /* Parsed Information Elements */
@@ -466,7 +470,7 @@ static void ieee80211_authenticate(struc
 
 	ieee80211_send_auth(dev, ifsta, 1, NULL, 0, 0);
 
-	schedule_delayed_work(&ifsta->work, IEEE80211_AUTH_TIMEOUT);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
 
@@ -694,7 +698,7 @@ static void ieee80211_associate(struct n
 
 	ieee80211_send_assoc(dev, ifsta);
 
-	schedule_delayed_work(&ifsta->work, IEEE80211_ASSOC_TIMEOUT);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
 
 
@@ -752,10 +756,10 @@ static void ieee80211_associated(struct 
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL + 30 * HZ);
 	} else {
-		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
 	}
 }
@@ -846,8 +850,7 @@ static void ieee80211_auth_completed(str
 static void ieee80211_auth_challenge(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
-				     size_t len,
-				     struct ieee80211_rx_status *rx_status)
+				     size_t len)
 {
 	u8 *pos;
 	struct ieee802_11_elems elems;
@@ -873,8 +876,7 @@ static void ieee80211_auth_challenge(str
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
-				   size_t len,
-				   struct ieee80211_rx_status *rx_status)
+				   size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u16 auth_alg, auth_transaction, status_code;
@@ -993,8 +995,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		if (ifsta->auth_transaction == 4)
 			ieee80211_auth_completed(dev, ifsta);
 		else
-			ieee80211_auth_challenge(dev, ifsta, mgmt, len,
-						 rx_status);
+			ieee80211_auth_challenge(dev, ifsta, mgmt, len);
 		break;
 	}
 }
@@ -1003,8 +1004,7 @@ static void ieee80211_rx_mgmt_auth(struc
 static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
-				     size_t len,
-				     struct ieee80211_rx_status *rx_status)
+				     size_t len)
 {
 	u16 reason_code;
 
@@ -1037,7 +1037,7 @@ static void ieee80211_rx_mgmt_deauth(str
 	    ifsta->state == IEEE80211_ASSOCIATE ||
 	    ifsta->state == IEEE80211_ASSOCIATED) {
 		ifsta->state = IEEE80211_AUTHENTICATE;
-		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
@@ -1049,8 +1049,7 @@ static void ieee80211_rx_mgmt_deauth(str
 static void ieee80211_rx_mgmt_disassoc(struct net_device *dev,
 				       struct ieee80211_if_sta *ifsta,
 				       struct ieee80211_mgmt *mgmt,
-				       size_t len,
-				       struct ieee80211_rx_status *rx_status)
+				       size_t len)
 {
 	u16 reason_code;
 
@@ -1080,7 +1079,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 
 	if (ifsta->state == IEEE80211_ASSOCIATED) {
 		ifsta->state = IEEE80211_ASSOCIATE;
-		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
@@ -1092,7 +1091,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 struct ieee80211_if_sta *ifsta,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
-					 struct ieee80211_rx_status *rx_status,
 					 int reassoc)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
@@ -1735,6 +1733,47 @@ void ieee80211_sta_rx_mgmt(struct net_de
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
+	case IEEE80211_STYPE_PROBE_RESP:
+	case IEEE80211_STYPE_BEACON:
+		memcpy(skb->cb, rx_status, sizeof(*rx_status));
+	case IEEE80211_STYPE_AUTH:
+	case IEEE80211_STYPE_ASSOC_RESP:
+	case IEEE80211_STYPE_REASSOC_RESP:
+	case IEEE80211_STYPE_DEAUTH:
+	case IEEE80211_STYPE_DISASSOC:
+		skb_queue_tail(&ifsta->skb_queue, skb);
+		schedule_work(&ifsta->work);
+		return;
+	default:
+		printk(KERN_DEBUG "%s: received unknown management frame - "
+		       "stype=%d\n", dev->name,
+		       (fc & IEEE80211_FCTL_STYPE) >> 4);
+		break;
+	}
+
+ fail:
+	kfree_skb(skb);
+}
+
+
+static void ieee80211_sta_rx_queued_mgmt(struct net_device *dev,
+					 struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_mgmt *mgmt;
+	u16 fc;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifsta = &sdata->u.sta;
+
+	rx_status = (struct ieee80211_rx_status *) skb->cb;
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	fc = le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_REQ:
 		ieee80211_rx_mgmt_probe_req(dev, ifsta, mgmt, skb->len,
 					    rx_status);
 		break;
@@ -1745,33 +1784,23 @@ void ieee80211_sta_rx_mgmt(struct net_de
 		ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len, rx_status);
 		break;
 	case IEEE80211_STYPE_AUTH:
-		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len,
-					     rx_status, 0);
+		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 0);
 		break;
 	case IEEE80211_STYPE_REASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len,
-					     rx_status, 1);
+		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 1);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
-		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len,
-					 rx_status);
+		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_DISASSOC:
-		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len,
-					   rx_status);
-		break;
-	default:
-		printk(KERN_DEBUG "%s: received unknown management frame - "
-		       "stype=%d\n", dev->name,
-		       (fc & IEEE80211_FCTL_STYPE) >> 4);
+		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
 		break;
 	}
 
- fail:
-	dev_kfree_skb(skb);
+	kfree_skb(skb);
 }
 
 
@@ -1844,7 +1873,7 @@ static void ieee80211_sta_expire(struct 
 static void ieee80211_sta_merge_ibss(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)
 {
-	schedule_delayed_work(&ifsta->work, IEEE80211_IBSS_MERGE_INTERVAL);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
 	ieee80211_sta_expire(dev);
 	if (ieee80211_sta_active_ibss(dev))
@@ -1856,16 +1885,32 @@ static void ieee80211_sta_merge_ibss(str
 }
 
 
+void ieee80211_sta_timer(unsigned long data)
+{
+	struct ieee80211_if_sta *ifsta = (struct ieee80211_if_sta *) data;
+	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
+	schedule_work(&ifsta->work);
+}
+
+
 void ieee80211_sta_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.sta.work.work);
+		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
 	struct net_device *dev = sdata->dev;
+	struct ieee80211_local *local = dev->ieee80211_ptr;
 	struct ieee80211_if_sta *ifsta;
+	struct sk_buff *skb;
 
 	if (!netif_running(dev))
 		return;
 
+	/* TODO: scan_dev check should be removed once scan_completed wakes
+	 * every STA interface */
+	if (local->sta_scanning &&
+	    local->scan_dev == dev)
+		return;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type != IEEE80211_IF_TYPE_STA &&
 	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
@@ -1875,6 +1920,22 @@ void ieee80211_sta_work(struct work_stru
 	}
 	ifsta = &sdata->u.sta;
 
+	while ((skb = skb_dequeue(&ifsta->skb_queue)))
+		ieee80211_sta_rx_queued_mgmt(dev, skb);
+
+	if (ifsta->state != IEEE80211_AUTHENTICATE &&
+	    ifsta->state != IEEE80211_ASSOCIATE &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
+		ieee80211_sta_start_scan(dev, NULL, 0);
+		return;
+	}
+
+	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
+		ifsta->state = IEEE80211_AUTHENTICATE;
+		ieee80211_sta_reset_auth(dev, ifsta);
+	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
+		return;
+
 	switch (ifsta->state) {
 	case IEEE80211_DISABLED:
 		break;
@@ -1909,14 +1970,10 @@ void ieee80211_sta_work(struct work_stru
 }
 
 
-static void ieee80211_sta_new_auth(struct net_device *dev,
-				   struct ieee80211_if_sta *ifsta)
+static void ieee80211_sta_reset_auth(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->type != IEEE80211_IF_TYPE_STA)
-		return;
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
@@ -1938,7 +1995,19 @@ static void ieee80211_sta_new_auth(struc
 	       ifsta->auth_alg);
 	ifsta->auth_transaction = -1;
 	ifsta->associated = ifsta->auth_tries = ifsta->assoc_tries = 0;
-	ieee80211_authenticate(dev, ifsta);
+}
+
+
+static void ieee80211_sta_new_auth(struct net_device *dev,
+				   struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->type != IEEE80211_IF_TYPE_STA)
+		return;
+
+	set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+	schedule_work(&ifsta->work);
 }
 
 
@@ -2123,7 +2192,7 @@ static int ieee80211_sta_join_ibss(struc
 	}
 
 	ifsta->state = IEEE80211_IBSS_JOINED;
-	schedule_delayed_work(&ifsta->work, IEEE80211_IBSS_MERGE_INTERVAL);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
 	ieee80211_rx_bss_put(dev, bss);
 
@@ -2240,7 +2309,7 @@ #endif /* CONFIG_D80211_IBSS_DEBUG */
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (ifsta->state == IEEE80211_IBSS_JOINED &&
 	    !ieee80211_sta_active_ibss(dev)) {
-		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_IBSS_MERGE_INTERVAL);
 	} else if (time_after(jiffies, local->last_scan_completed +
 			      IEEE80211_SCAN_INTERVAL)) {
@@ -2269,7 +2338,7 @@ #endif /* CONFIG_D80211_IBSS_DEBUG */
 		}
 
 		ifsta->state = IEEE80211_IBSS_SEARCH;
-		schedule_delayed_work(&ifsta->work, interval);
+		mod_timer(&ifsta->timer, jiffies + interval);
 		return 0;
 	}
 
@@ -2432,8 +2501,9 @@ void ieee80211_scan_completed(struct iee
 	union iwreq_data wrqu;
 
 	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
-	local->sta_scanning = 0;
 	local->last_scan_completed = jiffies;
+	wmb();
+	local->sta_scanning = 0;
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
@@ -2444,7 +2514,9 @@ void ieee80211_scan_completed(struct iee
 		    (!ifsta->state == IEEE80211_IBSS_JOINED &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
-	}
+	/* TODO: need to wake every sta interface */
+	} else if (sdata->type == IEEE80211_IF_TYPE_STA)
+		ieee80211_sta_timer((unsigned long)&sdata->u.sta);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
@@ -2533,16 +2605,13 @@ #endif
 		break;
 	}
 
-	if (local->sta_scanning) {
-		if (next_delay)
-			schedule_delayed_work(&local->scan_work, next_delay);
-		else
-			schedule_work(&local->scan_work.work);
-	}
+	if (local->sta_scanning)
+		schedule_delayed_work(&local->scan_work, next_delay);
 }
 
 
-int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len)
+static int ieee80211_sta_start_scan(struct net_device *dev,
+				    u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
 
@@ -2603,12 +2672,32 @@ int ieee80211_sta_req_scan(struct net_de
 					 list);
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
-	schedule_work(&local->scan_work.work);
+	schedule_delayed_work(&local->scan_work, 0);
 
 	return 0;
 }
 
 
+int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = dev->ieee80211_ptr;
+
+	if (sdata->type != IEEE80211_IF_TYPE_STA)
+		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
+
+	if (local->sta_scanning) {
+		if (local->scan_dev == dev)
+			return 0;
+		return -EBUSY;
+	}
+
+	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
+	schedule_work(&ifsta->work);
+	return 0;
+}
+
 static char *
 ieee80211_sta_scan_result(struct net_device *dev,
 			  struct ieee80211_sta_bss *bss,
-- 
1.3.0

