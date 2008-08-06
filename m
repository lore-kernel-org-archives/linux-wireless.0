Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230AbYHFLWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 07:22:07 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1 V2] mac80211: cleanup mlme state namespace
Date: Wed,  6 Aug 2008 14:22:01 +0300
Message-Id: <1218021721-1369-1-git-send-email-tomas.winkler@intel.com> (sfid-20080806_132214_627921_581435C1)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch move add STA_MLME to station mlme state defines.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---

One rename of IEEE80211_MESH_UP -> IEEE80211_STA_MLME_MESH_UP was missing 

 net/mac80211/ieee80211_i.h |   34 +++++++++++++-------
 net/mac80211/main.c        |    2 +-
 net/mac80211/mlme.c        |   72 ++++++++++++++++++++++----------------------
 net/mac80211/wext.c        |    4 +-
 4 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ec59345..d19f67e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -300,17 +300,33 @@ struct mesh_config {
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
+/* flags for  MLME request*/
+#define IEEE80211_STA_REQ_SCAN 0
+#define IEEE80211_STA_REQ_AUTH 1
+#define IEEE80211_STA_REQ_RUN  2
+
+/* flags used for setting mlme state */
+enum ieee80211_sta_mlme_state {
+	IEEE80211_STA_MLME_DISABLED,
+	IEEE80211_STA_MLME_AUTHENTICATE,
+	IEEE80211_STA_MLME_ASSOCIATE,
+	IEEE80211_STA_MLME_ASSOCIATED,
+	IEEE80211_STA_MLME_IBSS_SEARCH,
+	IEEE80211_STA_MLME_IBSS_JOINED,
+	IEEE80211_STA_MLME_MESH_UP
+};
+
+/* bitfield of allowed auth algs */
+#define IEEE80211_AUTH_ALG_OPEN BIT(0)
+#define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
+#define IEEE80211_AUTH_ALG_LEAP BIT(2)
+
 struct ieee80211_if_sta {
 	struct timer_list timer;
 	struct work_struct work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	enum {
-		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
-		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
-		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
-		IEEE80211_MESH_UP
-	} state;
+	enum ieee80211_sta_mlme_state state;
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
@@ -360,13 +376,7 @@ struct ieee80211_if_sta {
 	unsigned long last_probe;
 
 	unsigned int flags;
-#define IEEE80211_STA_REQ_SCAN 0
-#define IEEE80211_STA_REQ_AUTH 1
-#define IEEE80211_STA_REQ_RUN  2
 
-#define IEEE80211_AUTH_ALG_OPEN BIT(0)
-#define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
-#define IEEE80211_AUTH_ALG_LEAP BIT(2)
 	unsigned int auth_algs; /* bitfield of allowed auth algs */
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0c02c47..372fcd4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -497,7 +497,7 @@ static int ieee80211_stop(struct net_device *dev)
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
-		sdata->u.sta.state = IEEE80211_DISABLED;
+		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.sta.timer);
 		/*
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e1d11c9..5426df1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -669,11 +669,11 @@ static void ieee80211_authenticate(struct net_device *dev,
 		printk(KERN_DEBUG "%s: authentication with AP %s"
 		       " timed out\n",
 		       dev->name, print_mac(mac, ifsta->bssid));
-		ifsta->state = IEEE80211_DISABLED;
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
 
-	ifsta->state = IEEE80211_AUTHENTICATE;
+	ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 	printk(KERN_DEBUG "%s: authenticate with AP %s\n",
 	       dev->name, print_mac(mac, ifsta->bssid));
 
@@ -1010,17 +1010,17 @@ static void ieee80211_associate(struct net_device *dev,
 		printk(KERN_DEBUG "%s: association with AP %s"
 		       " timed out\n",
 		       dev->name, print_mac(mac, ifsta->bssid));
-		ifsta->state = IEEE80211_DISABLED;
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
 
-	ifsta->state = IEEE80211_ASSOCIATE;
+	ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
 	printk(KERN_DEBUG "%s: associate with AP %s\n",
 	       dev->name, print_mac(mac, ifsta->bssid));
 	if (ieee80211_privacy_mismatch(dev, ifsta)) {
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", dev->name);
-		ifsta->state = IEEE80211_DISABLED;
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
 
@@ -1043,7 +1043,7 @@ static void ieee80211_associated(struct net_device *dev,
 	 * for better APs. */
 	/* TODO: remove expired BSSes */
 
-	ifsta->state = IEEE80211_ASSOCIATED;
+	ifsta->state = IEEE80211_STA_MLME_ASSOCIATED;
 
 	rcu_read_lock();
 
@@ -1086,7 +1086,7 @@ static void ieee80211_associated(struct net_device *dev,
 		sta_info_destroy(sta);
 
 	if (disassoc) {
-		ifsta->state = IEEE80211_DISABLED;
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_set_associated(dev, ifsta, 0);
 	} else {
 		mod_timer(&ifsta->timer, jiffies +
@@ -1851,7 +1851,7 @@ static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 	u16 auth_alg, auth_transaction, status_code;
 	DECLARE_MAC_BUF(mac);
 
-	if (ifsta->state != IEEE80211_AUTHENTICATE &&
+	if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return;
 
@@ -1955,10 +1955,10 @@ static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
 	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
 		printk(KERN_DEBUG "%s: deauthenticated\n", dev->name);
 
-	if (ifsta->state == IEEE80211_AUTHENTICATE ||
-	    ifsta->state == IEEE80211_ASSOCIATE ||
-	    ifsta->state == IEEE80211_ASSOCIATED) {
-		ifsta->state = IEEE80211_AUTHENTICATE;
+	if (ifsta->state == IEEE80211_STA_MLME_AUTHENTICATE ||
+	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATE ||
+	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
+		ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
@@ -1987,8 +1987,8 @@ static void ieee80211_rx_mgmt_disassoc(struct net_device *dev,
 	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
 		printk(KERN_DEBUG "%s: disassociated\n", dev->name);
 
-	if (ifsta->state == IEEE80211_ASSOCIATED) {
-		ifsta->state = IEEE80211_ASSOCIATE;
+	if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
+		ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
@@ -2019,7 +2019,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
 
-	if (ifsta->state != IEEE80211_ASSOCIATE)
+	if (ifsta->state != IEEE80211_STA_MLME_ASSOCIATE)
 		return;
 
 	if (len < 24 + 6)
@@ -2506,7 +2506,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 
 	ieee80211_sta_def_wmm_params(dev, bss, 1);
 
-	ifsta->state = IEEE80211_IBSS_JOINED;
+	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
 	memset(&wrqu, 0, sizeof(wrqu));
@@ -2983,7 +2983,7 @@ static void ieee80211_rx_mgmt_probe_req(struct net_device *dev,
 #endif
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS ||
-	    ifsta->state != IEEE80211_IBSS_JOINED ||
+	    ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED ||
 	    len < 24 + 2 || !ifsta->probe_resp)
 		return;
 
@@ -3310,7 +3310,7 @@ void ieee80211_start_mesh(struct net_device *dev)
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
-	ifsta->state = IEEE80211_MESH_UP;
+	ifsta->state = IEEE80211_STA_MLME_MESH_UP;
 	ieee80211_sta_timer((unsigned long)sdata);
 	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 }
@@ -3359,8 +3359,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		mesh_path_start_discovery(dev);
 #endif
 
-	if (ifsta->state != IEEE80211_AUTHENTICATE &&
-	    ifsta->state != IEEE80211_ASSOCIATE &&
+	if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
+	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
 		if (ifsta->scan_ssid_len)
 			ieee80211_sta_start_scan(dev, ifsta->scan_ssid, ifsta->scan_ssid_len);
@@ -3377,25 +3377,25 @@ void ieee80211_sta_work(struct work_struct *work)
 		return;
 
 	switch (ifsta->state) {
-	case IEEE80211_DISABLED:
+	case IEEE80211_STA_MLME_DISABLED:
 		break;
-	case IEEE80211_AUTHENTICATE:
+	case IEEE80211_STA_MLME_AUTHENTICATE:
 		ieee80211_authenticate(dev, ifsta);
 		break;
-	case IEEE80211_ASSOCIATE:
+	case IEEE80211_STA_MLME_ASSOCIATE:
 		ieee80211_associate(dev, ifsta);
 		break;
-	case IEEE80211_ASSOCIATED:
+	case IEEE80211_STA_MLME_ASSOCIATED:
 		ieee80211_associated(dev, ifsta);
 		break;
-	case IEEE80211_IBSS_SEARCH:
+	case IEEE80211_STA_MLME_IBSS_SEARCH:
 		ieee80211_sta_find_ibss(dev, ifsta);
 		break;
-	case IEEE80211_IBSS_JOINED:
+	case IEEE80211_STA_MLME_IBSS_JOINED:
 		ieee80211_sta_merge_ibss(dev, ifsta);
 		break;
 #ifdef CONFIG_MAC80211_MESH
-	case IEEE80211_MESH_UP:
+	case IEEE80211_STA_MLME_MESH_UP:
 		ieee80211_mesh_housekeeping(dev, ifsta);
 		break;
 #endif
@@ -3540,20 +3540,20 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_sta_def_wmm_params(dev, selected, 0);
 		ieee80211_rx_bss_put(local, selected);
-		ifsta->state = IEEE80211_AUTHENTICATE;
+		ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
-		if (ifsta->state != IEEE80211_AUTHENTICATE) {
+		if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE) {
 			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
 				ieee80211_sta_start_scan(dev, NULL, 0);
 			else
 				ieee80211_sta_start_scan(dev, ifsta->ssid,
 							 ifsta->ssid_len);
-			ifsta->state = IEEE80211_AUTHENTICATE;
+			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 		} else
-			ifsta->state = IEEE80211_DISABLED;
+			ifsta->state = IEEE80211_STA_MLME_DISABLED;
 	}
 	return -1;
 }
@@ -3692,7 +3692,7 @@ dont_join:
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
 	/* Selected IBSS not found in current scan results - try to scan */
-	if (ifsta->state == IEEE80211_IBSS_JOINED &&
+	if (ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED &&
 	    !ieee80211_sta_active_ibss(dev)) {
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_IBSS_MERGE_INTERVAL);
@@ -3702,7 +3702,7 @@ dont_join:
 		       "join\n", dev->name);
 		return ieee80211_sta_req_scan(dev, ifsta->ssid,
 					      ifsta->ssid_len);
-	} else if (ifsta->state != IEEE80211_IBSS_JOINED) {
+	} else if (ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
 		if (time_after(jiffies, ifsta->ibss_join_req +
@@ -3722,7 +3722,7 @@ dont_join:
 			interval = IEEE80211_SCAN_INTERVAL_SLOW;
 		}
 
-		ifsta->state = IEEE80211_IBSS_SEARCH;
+		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
 		mod_timer(&ifsta->timer, jiffies + interval);
 		return 0;
 	}
@@ -3770,7 +3770,7 @@ int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
 	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
 		ifsta->ibss_join_req = jiffies;
-		ifsta->state = IEEE80211_IBSS_SEARCH;
+		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
 		return ieee80211_sta_find_ibss(dev, ifsta);
 	}
 
@@ -3920,7 +3920,7 @@ done:
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
-		    (!(ifsta->state == IEEE80211_IBSS_JOINED) &&
+		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
 	}
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 34fa8ed..4de14a5 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -539,8 +539,8 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		if (sdata->u.sta.state == IEEE80211_ASSOCIATED ||
-		    sdata->u.sta.state == IEEE80211_IBSS_JOINED) {
+		if (sdata->u.sta.state == IEEE80211_STA_MLME_ASSOCIATED ||
+		    sdata->u.sta.state == IEEE80211_STA_MLME_IBSS_JOINED) {
 			ap_addr->sa_family = ARPHRD_ETHER;
 			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
 			return 0;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

