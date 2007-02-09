Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:56506 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946115AbXBIF30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 00:29:26 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] d80211: Fix concurrency issues in ieee80211_sta.c
Date: Fri, 9 Feb 2007 00:28:52 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702090002.29841.flamingice@sourmilk.net>
In-Reply-To: <200702090002.29841.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6818027.0r2M7n0Ms4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702090028.56793.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6818027.0r2M7n0Ms4
Content-Type: multipart/mixed;
  boundary="Boundary-01=_UaAzFmmO6xZJa6U"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_UaAzFmmO6xZJa6U
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 February 2007 00:02, Michael Wu wrote:
> @@ -4023,7 +4025,7 @@ void ieee80211_rx_irqsafe(struct ieee802
>
>  	skb->dev =3D local->mdev;
>  	/* copy status into skb->cb for use by tasklet */
> -	memcpy(skb->cb, status, sizeof(struct ieee80211_rx_status));
> +	memcpy(skb->cb, status, sizeof(*status));
>  	skb->pkt_type =3D ieee80211_rx_msg;
>  	skb_queue_tail(&local->skb_queue, skb);
>  	tasklet_schedule(&local->tasklet);
Opps.. that was suppose to be part of the previous patch. Fixed patches=20
attached which just merge that chunk into the previous patch.

=2DMichael Wu

--Boundary-01=_UaAzFmmO6xZJa6U
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="workqueue-sync"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="workqueue-sync"

d80211: Fix concurrency issues in ieee80211_sta.c

=46rom: Michael Wu <flamingice@sourmilk.net>

This fixes most concurrency issues in ieee80211_sta.c and partially
prevents scans from running over an association in progress and vice versa.
This is achieved by forcing all potentially racy code to run from a
workqueue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211.c       |    4 +
 net/d80211/ieee80211_i.h     |    9 ++
 net/d80211/ieee80211_iface.c |    5 +
 net/d80211/ieee80211_sta.c   |  202 ++++++++++++++++++++++++++++++--------=
=2D---
 4 files changed, 161 insertions(+), 59 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 2fb66b3..055e8a2 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2179,7 +2179,9 @@ void ieee80211_if_shutdown(struct net_de
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state =3D IEEE80211_DISABLED;
=2D		cancel_delayed_work(&sdata->u.sta.work);
+		del_timer_sync(&sdata->u.sta.timer);
+		flush_scheduled_work();
+		skb_queue_purge(&sdata->u.sta.skb_queue);
 		if (!local->ops->hw_scan &&
 		    local->scan_dev =3D=3D sdata->dev) {
 			local->sta_scanning =3D 0;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index bb8fc83..9307882 100644
=2D-- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -242,7 +242,8 @@ struct ieee80211_if_sta {
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
 		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
 	} state;
=2D	struct delayed_work work;
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
+	struct sk_buff_head skb_queue;=09
=20
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
=2D-- a/net/d80211/ieee80211_iface.c
+++ b/net/d80211/ieee80211_iface.c
@@ -185,7 +185,10 @@ void ieee80211_if_set_type(struct net_de
 		struct ieee80211_if_sta *ifsta;
=20
 		ifsta =3D &sdata->u.sta;
=2D		INIT_DELAYED_WORK(&ifsta->work, ieee80211_sta_work);
+		INIT_WORK(&ifsta->work, ieee80211_sta_work);
+		setup_timer(&ifsta->timer, ieee80211_sta_timer,
+			    (unsigned long) ifsta);
+		skb_queue_head_init(&ifsta->skb_queue);
=20
 		ifsta->capab =3D WLAN_CAPABILITY_ESS;
 		ifsta->auth_algs =3D IEEE80211_AUTH_ALG_OPEN |
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 0e45a65..7b6a76b 100644
=2D-- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -64,6 +64,10 @@ static void ieee80211_rx_bss_put(struct
 static int ieee80211_sta_find_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta);
 static int ieee80211_sta_wep_configured(struct net_device *dev);
+static int ieee80211_sta_start_scan(struct net_device *dev,
+				    u8 *ssid, size_t ssid_len);
+static void ieee80211_sta_reset_auth(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta);
=20
=20
 /* Parsed Information Elements */
@@ -466,7 +470,7 @@ static void ieee80211_authenticate(struc
=20
 	ieee80211_send_auth(dev, ifsta, 1, NULL, 0, 0);
=20
=2D	schedule_delayed_work(&ifsta->work, IEEE80211_AUTH_TIMEOUT);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
=20
=20
@@ -694,7 +698,7 @@ static void ieee80211_associate(struct n
=20
 	ieee80211_send_assoc(dev, ifsta);
=20
=2D	schedule_delayed_work(&ifsta->work, IEEE80211_ASSOC_TIMEOUT);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
=20
=20
@@ -752,10 +756,10 @@ static void ieee80211_associated(struct
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 		wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
 		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
=2D		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +=20
 				      IEEE80211_MONITORING_INTERVAL + 30 * HZ);
 	} else {
=2D		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +=20
 				      IEEE80211_MONITORING_INTERVAL);
 	}
 }
@@ -846,8 +850,7 @@ static void ieee80211_auth_completed(str
 static void ieee80211_auth_challenge(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
=2D				     size_t len,
=2D				     struct ieee80211_rx_status *rx_status)
+				     size_t len)
 {
 	u8 *pos;
 	struct ieee802_11_elems elems;
@@ -873,8 +876,7 @@ static void ieee80211_auth_challenge(str
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
=2D				   size_t len,
=2D				   struct ieee80211_rx_status *rx_status)
+				   size_t len)
 {
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	u16 auth_alg, auth_transaction, status_code;
@@ -993,8 +995,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		if (ifsta->auth_transaction =3D=3D 4)
 			ieee80211_auth_completed(dev, ifsta);
 		else
=2D			ieee80211_auth_challenge(dev, ifsta, mgmt, len,
=2D						 rx_status);
+			ieee80211_auth_challenge(dev, ifsta, mgmt, len);
 		break;
 	}
 }
@@ -1003,8 +1004,7 @@ static void ieee80211_rx_mgmt_auth(struc
 static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
=2D				     size_t len,
=2D				     struct ieee80211_rx_status *rx_status)
+				     size_t len)
 {
 	u16 reason_code;
=20
@@ -1037,7 +1037,7 @@ static void ieee80211_rx_mgmt_deauth(str
 	    ifsta->state =3D=3D IEEE80211_ASSOCIATE ||
 	    ifsta->state =3D=3D IEEE80211_ASSOCIATED) {
 		ifsta->state =3D IEEE80211_AUTHENTICATE;
=2D		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
=20
@@ -1049,8 +1049,7 @@ static void ieee80211_rx_mgmt_deauth(str
 static void ieee80211_rx_mgmt_disassoc(struct net_device *dev,
 				       struct ieee80211_if_sta *ifsta,
 				       struct ieee80211_mgmt *mgmt,
=2D				       size_t len,
=2D				       struct ieee80211_rx_status *rx_status)
+				       size_t len)
 {
 	u16 reason_code;
=20
@@ -1080,7 +1079,7 @@ static void ieee80211_rx_mgmt_disassoc(s
=20
 	if (ifsta->state =3D=3D IEEE80211_ASSOCIATED) {
 		ifsta->state =3D IEEE80211_ASSOCIATE;
=2D		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
=20
@@ -1092,7 +1091,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 struct ieee80211_if_sta *ifsta,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
=2D					 struct ieee80211_rx_status *rx_status,
 					 int reassoc)
 {
 	struct ieee80211_local *local =3D dev->ieee80211_ptr;
@@ -1735,6 +1733,47 @@ void ieee80211_sta_rx_mgmt(struct net_de
=20
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
+	case IEEE80211_STYPE_PROBE_RESP:
+	case IEEE80211_STYPE_BEACON:
+	case IEEE80211_STYPE_AUTH:
+	case IEEE80211_STYPE_ASSOC_RESP:
+	case IEEE80211_STYPE_REASSOC_RESP:
+	case IEEE80211_STYPE_DEAUTH:
+	case IEEE80211_STYPE_DISASSOC:
+		memcpy(skb->cb, rx_status, sizeof(*rx_status));
+		skb_queue_tail(&ifsta->skb_queue, skb);
+		schedule_work(&ifsta->work);
+		return;
+	default:
+		printk(KERN_DEBUG "%s: received unknown management frame - "
+		       "stype=3D%d\n", dev->name,
+		       (fc & IEEE80211_FCTL_STYPE) >> 4);
+		break;
+	}
+
+ fail:
+	dev_kfree_skb(skb);
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
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	ifsta =3D &sdata->u.sta;
+
+	rx_status =3D (struct ieee80211_rx_status *) skb->cb;
+	mgmt =3D (struct ieee80211_mgmt *) skb->data;
+	fc =3D le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_REQ:
 		ieee80211_rx_mgmt_probe_req(dev, ifsta, mgmt, skb->len,
 					    rx_status);
 		break;
@@ -1745,33 +1784,21 @@ void ieee80211_sta_rx_mgmt(struct net_de
 		ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len, rx_status);
 		break;
 	case IEEE80211_STYPE_AUTH:
=2D		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len, rx_status);
+		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
=2D		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len,
=2D					     rx_status, 0);
+		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 0);
 		break;
 	case IEEE80211_STYPE_REASSOC_RESP:
=2D		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len,
=2D					     rx_status, 1);
+		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 1);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
=2D		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len,
=2D					 rx_status);
+		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_DISASSOC:
=2D		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len,
=2D					   rx_status);
=2D		break;
=2D	default:
=2D		printk(KERN_DEBUG "%s: received unknown management frame - "
=2D		       "stype=3D%d\n", dev->name,
=2D		       (fc & IEEE80211_FCTL_STYPE) >> 4);
+		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
 		break;
 	}
=2D
=2D fail:
=2D	dev_kfree_skb(skb);
 }
=20
=20
@@ -1844,7 +1871,7 @@ static void ieee80211_sta_expire(struct
 static void ieee80211_sta_merge_ibss(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)
 {
=2D	schedule_delayed_work(&ifsta->work, IEEE80211_IBSS_MERGE_INTERVAL);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
=20
 	ieee80211_sta_expire(dev);
 	if (ieee80211_sta_active_ibss(dev))
@@ -1856,16 +1883,32 @@ static void ieee80211_sta_merge_ibss(str
 }
=20
=20
+void ieee80211_sta_timer(unsigned long data)
+{
+	struct ieee80211_if_sta *ifsta =3D (struct ieee80211_if_sta *) data;
+	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
+	schedule_work(&ifsta->work);
+}
+
+
 void ieee80211_sta_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =3D
=2D		container_of(work, struct ieee80211_sub_if_data, u.sta.work.work);
+		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
 	struct net_device *dev =3D sdata->dev;
+	struct ieee80211_local *local =3D dev->ieee80211_ptr;
 	struct ieee80211_if_sta *ifsta;
+	struct sk_buff *skb;
=20
 	if (!netif_running(dev))
 		return;
=20
+	/* TODO: scan_dev check should be removed once scan_completed wakes
+	 * every STA interface */
+	if (local->sta_scanning &&
+	    local->scan_dev =3D=3D dev)
+		return;
+
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type !=3D IEEE80211_IF_TYPE_STA &&
 	    sdata->type !=3D IEEE80211_IF_TYPE_IBSS) {
@@ -1875,6 +1918,22 @@ void ieee80211_sta_work(struct work_stru
 	}
 	ifsta =3D &sdata->u.sta;
=20
+	while ((skb =3D skb_dequeue(&ifsta->skb_queue)))
+		ieee80211_sta_rx_queued_mgmt(dev, skb);
+
+	if (ifsta->state !=3D IEEE80211_AUTHENTICATE &&
+	    ifsta->state !=3D IEEE80211_ASSOCIATE &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
+		ieee80211_sta_start_scan(dev, NULL, 0);
+		return;
+	}
+
+	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
+		ifsta->state =3D IEEE80211_AUTHENTICATE;
+		ieee80211_sta_reset_auth(dev, ifsta);
+	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
+		return;
+
 	switch (ifsta->state) {
 	case IEEE80211_DISABLED:
 		break;
@@ -1909,14 +1968,10 @@ void ieee80211_sta_work(struct work_stru
 }
=20
=20
=2Dstatic void ieee80211_sta_new_auth(struct net_device *dev,
=2D				   struct ieee80211_if_sta *ifsta)
+static void ieee80211_sta_reset_auth(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local =3D dev->ieee80211_ptr;
=2D	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=2D
=2D	if (sdata->type !=3D IEEE80211_IF_TYPE_STA)
=2D		return;
=20
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
@@ -1938,7 +1993,19 @@ static void ieee80211_sta_new_auth(struc
 	       ifsta->auth_alg);
 	ifsta->auth_transaction =3D -1;
 	ifsta->associated =3D ifsta->auth_tries =3D ifsta->assoc_tries =3D 0;
=2D	ieee80211_authenticate(dev, ifsta);
+}
+
+
+static void ieee80211_sta_new_auth(struct net_device *dev,
+				   struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->type !=3D IEEE80211_IF_TYPE_STA)
+		return;
+
+	set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+	schedule_work(&ifsta->work);
 }
=20
=20
@@ -2123,7 +2190,7 @@ static int ieee80211_sta_join_ibss(struc
 	}
=20
 	ifsta->state =3D IEEE80211_IBSS_JOINED;
=2D	schedule_delayed_work(&ifsta->work, IEEE80211_IBSS_MERGE_INTERVAL);
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
=20
 	ieee80211_rx_bss_put(dev, bss);
=20
@@ -2240,7 +2307,7 @@ static int ieee80211_sta_find_ibss(struc
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (ifsta->state =3D=3D IEEE80211_IBSS_JOINED &&
 	    !ieee80211_sta_active_ibss(dev)) {
=2D		schedule_delayed_work(&ifsta->work,
+		mod_timer(&ifsta->timer, jiffies +=20
 				      IEEE80211_IBSS_MERGE_INTERVAL);
 	} else if (time_after(jiffies, local->last_scan_completed +
 			      IEEE80211_SCAN_INTERVAL)) {
@@ -2269,7 +2336,7 @@ static int ieee80211_sta_find_ibss(struc
 		}
=20
 		ifsta->state =3D IEEE80211_IBSS_SEARCH;
=2D		schedule_delayed_work(&ifsta->work, interval);
+		mod_timer(&ifsta->timer, jiffies + interval);
 		return 0;
 	}
=20
@@ -2432,8 +2499,9 @@ void ieee80211_scan_completed(struct iee
 	union iwreq_data wrqu;
=20
 	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
=2D	local->sta_scanning =3D 0;
 	local->last_scan_completed =3D jiffies;
+	wmb();
+	local->sta_scanning =3D 0;
=20
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
@@ -2444,7 +2512,9 @@ void ieee80211_scan_completed(struct iee
 		    (!ifsta->state =3D=3D IEEE80211_IBSS_JOINED &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
=2D	}
+	/* TODO: need to wake every sta interface */
+	} else if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
+		ieee80211_sta_timer((unsigned long)&sdata->u.sta);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
=20
@@ -2533,16 +2603,13 @@ void ieee80211_sta_scan_work(struct work
 		break;
 	}
=20
=2D	if (local->sta_scanning) {
=2D		if (next_delay)
=2D			schedule_delayed_work(&local->scan_work, next_delay);
=2D		else
=2D			schedule_work(&local->scan_work.work);
=2D	}
+	if (local->sta_scanning)
+		schedule_delayed_work(&local->scan_work, next_delay);
 }
=20
=20
=2Dint ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid=
_len)
+static int ieee80211_sta_start_scan(struct net_device *dev,
+				    u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local =3D dev->ieee80211_ptr;
=20
@@ -2603,12 +2670,35 @@ int ieee80211_sta_req_scan(struct net_de
 					 list);
 	local->scan_channel_idx =3D 0;
 	local->scan_dev =3D dev;
=2D	schedule_work(&local->scan_work.work);
+	schedule_delayed_work(&local->scan_work, 0);
=20
 	return 0;
 }
=20
=20
+int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_l=
en)
+{
+	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
+	struct ieee80211_local *local =3D dev->ieee80211_ptr;
+
+	if (sdata->type !=3D IEEE80211_IF_TYPE_STA)
+		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
+
+	if (local->sta_scanning) {
+		if (local->scan_dev =3D=3D dev)
+			return 0;
+		return -EBUSY;
+	}
+
+	if (time_after(local->last_scan_completed + HZ, jiffies))
+		return -EAGAIN;
+
+	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
+	schedule_work(&ifsta->work);
+	return 0;
+}
+
 static char *
 ieee80211_sta_scan_result(struct net_device *dev,
 			  struct ieee80211_sta_bss *bss,

--Boundary-01=_UaAzFmmO6xZJa6U
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="kill-hosttime"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kill-hosttime"

d80211: remove hosttime from ieee80211_rx_status

=46rom: Michael Wu <flamingice@sourmilk.net>

Nobody fills hosttime in ieee80211_rx_status. Removing it allows
ieee80211_rx_status to fit in skb->cb.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/d80211.h   |    1 -
 net/d80211/ieee80211.c |   25 +++++--------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 326def5..0b7b963 100644
=2D-- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -225,7 +225,6 @@ struct ieee80211_tx_control {
  * (the subset supported by hardware) to the 802.11 code with each received
  * frame. */
 struct ieee80211_rx_status {
=2D        u64 hosttime;
 	u64 mactime;
         int freq; /* receive frequency in Mhz */
         int channel;
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index bbcefa9..2fb66b3 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2627,7 +2627,7 @@ ieee80211_fill_frame_info(struct ieee802
                 struct timespec ts;
 		struct ieee80211_rate *rate;
=20
=2D                jiffies_to_timespec(status->hosttime, &ts);
+		jiffies_to_timespec(jiffies, &ts);
 		fi->hosttime =3D cpu_to_be64((u64) ts.tv_sec * 1000000 +
 					   ts.tv_nsec / 1000);
 		fi->mactime =3D cpu_to_be64(status->mactime);
@@ -4019,25 +4019,11 @@ static void ieee80211_stat_refresh(unsig
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_rx_status *status)
 {
=2D	struct ieee80211_rx_status *saved;
 	struct ieee80211_local *local =3D hw_to_local(hw);
=20
 	skb->dev =3D local->mdev;
=2D	saved =3D kmalloc(sizeof(struct ieee80211_rx_status), GFP_ATOMIC);
=2D	if (unlikely(!saved)) {
=2D		if (net_ratelimit())
=2D			printk(KERN_WARNING "%s: Not enough memory, "
=2D			       "dropping packet", skb->dev->name);
=2D		/* should be dev_kfree_skb_irq, but due to this function being
=2D		 * named _irqsafe instead of just _irq we can't be sure that
=2D		 * people won't call it from non-irq contexts */
=2D		dev_kfree_skb_any(skb);
=2D		return;
=2D	}
=2D	memcpy(saved, status, sizeof(struct ieee80211_rx_status));
=2D	/* copy pointer to saved status into skb->cb for use by tasklet */
=2D	memcpy(skb->cb, &saved, sizeof(saved));
=2D
+	/* copy status into skb->cb for use by tasklet */
+	memcpy(skb->cb, status, sizeof(*status));
 	skb->pkt_type =3D ieee80211_rx_msg;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
@@ -4096,13 +4082,12 @@ static void ieee80211_tasklet_handler(un
 	       (skb =3D skb_dequeue(&local->skb_queue_unreliable))) {
                 switch (skb->pkt_type) {
 		case ieee80211_rx_msg:
=2D			/* get pointer to saved status out of skb->cb */
=2D			memcpy(&rx_status, skb->cb, sizeof(rx_status));
+			/* status is in skb->cb */
+			rx_status =3D (struct ieee80211_rx_status *) skb->cb;
 			/* Clear skb->type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type =3D 0;
 			__ieee80211_rx(local_to_hw(local), skb, rx_status);
=2D			kfree(rx_status);
 			break;
 		case ieee80211_tx_status_msg:
 			/* get pointer to saved status out of skb->cb */

--Boundary-01=_UaAzFmmO6xZJa6U--

--nextPart6818027.0r2M7n0Ms4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFzAaYT3Oqt9AH4aERApjLAJ0ZN8CYV2VpRTN7zbRClHPCq0rNZQCgi2zW
tlAbgVs3d57/RzQDAHbFMZU=
=XD+S
-----END PGP SIGNATURE-----

--nextPart6818027.0r2M7n0Ms4--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
