Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15107 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758921AbYGNXHv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 19:07:51 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: add direct probe before association
Date: Tue, 15 Jul 2008 02:07:45 +0300
Message-Id: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com> (sfid-20080715_010756_182862_0CB9522F)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a direct probe request as first step in the association
flow. Motivation of this step is to make sure that the bss information
we have is up to date, since last scan could have been done a while ago.
beacons do not fully answer this need as there are potential differences
between them and probe responses (e.g. WMM parameter element)

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |   17 ++++++-----
 net/mac80211/mlme.c        |   67 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cc499cc..154c6ca 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -305,10 +305,10 @@ struct ieee80211_if_sta {
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	enum {
-		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
-		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
-		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
-		IEEE80211_MESH_UP
+		IEEE80211_DISABLED, IEEE80211_DIRECT_PROBE,
+		IEEE80211_AUTHENTICATE, IEEE80211_ASSOCIATE,
+		IEEE80211_ASSOCIATED, IEEE80211_IBSS_SEARCH,
+		IEEE80211_IBSS_JOINED, IEEE80211_MESH_UP
 	} state;
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
@@ -352,16 +352,17 @@ struct ieee80211_if_sta {
 
 	struct sk_buff_head skb_queue;
 
-	int auth_tries, assoc_tries;
+	int direct_probe_tries, auth_tries, assoc_tries;
 
 	unsigned long request;
 
 	unsigned long last_probe;
 
 	unsigned int flags;
-#define IEEE80211_STA_REQ_SCAN 0
-#define IEEE80211_STA_REQ_AUTH 1
-#define IEEE80211_STA_REQ_RUN  2
+#define IEEE80211_STA_REQ_SCAN		0
+#define IEEE80211_STA_REQ_DIRECT_PROBE	1
+#define IEEE80211_STA_REQ_AUTH		2
+#define IEEE80211_STA_REQ_RUN		3
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
 #define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a44a580..b2403dc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -597,8 +597,11 @@ static void ieee80211_set_associated(struct net_device *dev,
 static void ieee80211_set_disassoc(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta, int deauth)
 {
-	if (deauth)
+	if (deauth) {
+		ifsta->direct_probe_tries = 0;
 		ifsta->auth_tries = 0;
+	}
+
 	ifsta->assoc_tries = 0;
 	ieee80211_set_associated(dev, ifsta, 0);
 }
@@ -662,6 +665,32 @@ static void ieee80211_send_auth(struct net_device *dev,
 	ieee80211_sta_tx(dev, skb, encrypt);
 }
 
+static void ieee80211_direct_probe(struct net_device *dev,
+				   struct ieee80211_if_sta *ifsta)
+{
+	DECLARE_MAC_BUF(mac);
+
+	ifsta->direct_probe_tries++;
+	if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
+		printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
+		       dev->name, print_mac(mac, ifsta->bssid));
+		ifsta->state = IEEE80211_DISABLED;
+		return;
+	}
+
+	printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
+			dev->name, print_mac(mac, ifsta->bssid),
+			ifsta->direct_probe_tries);
+
+	ifsta->state = IEEE80211_DIRECT_PROBE;
+
+	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
+
+	ieee80211_send_probe_req(dev, ifsta->bssid,
+				 ifsta->ssid, ifsta->ssid_len);
+
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
+}
 
 static void ieee80211_authenticate(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta)
@@ -1960,7 +1989,7 @@ static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
 	if (ifsta->state == IEEE80211_AUTHENTICATE ||
 	    ifsta->state == IEEE80211_ASSOCIATE ||
 	    ifsta->state == IEEE80211_ASSOCIATED) {
-		ifsta->state = IEEE80211_AUTHENTICATE;
+		ifsta->state = IEEE80211_DIRECT_PROBE;
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
@@ -2891,6 +2920,8 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 {
 	size_t baselen;
 	struct ieee802_11_elems elems;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
@@ -2900,6 +2931,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 				&elems);
 
 	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 0);
+
+	/* direct probe is part of the association flow */
+	if (test_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request) &&
+	   !memcmp(mgmt->da, dev->dev_addr, ETH_ALEN)) {
+		clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
+		printk(KERN_DEBUG "%s direct probe responded\n", dev->name);
+		ieee80211_authenticate(dev, ifsta);
+	}
 }
 
 
@@ -3360,7 +3399,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		mesh_path_start_discovery(dev);
 #endif
 
-	if (ifsta->state != IEEE80211_AUTHENTICATE &&
+	if (ifsta->state != IEEE80211_DIRECT_PROBE &&
+	    ifsta->state != IEEE80211_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
 		if (ifsta->scan_ssid_len)
@@ -3380,6 +3420,9 @@ void ieee80211_sta_work(struct work_struct *work)
 	switch (ifsta->state) {
 	case IEEE80211_DISABLED:
 		break;
+	case IEEE80211_DIRECT_PROBE:
+		ieee80211_direct_probe(dev, ifsta);
+		break;
 	case IEEE80211_AUTHENTICATE:
 		ieee80211_authenticate(dev, ifsta);
 		break;
@@ -3438,6 +3481,7 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,
 		ifsta->auth_alg = WLAN_AUTH_OPEN;
 	ifsta->auth_transaction = -1;
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
+	ifsta->direct_probe_tries = 0;
 	ifsta->auth_tries = ifsta->assoc_tries = 0;
 	netif_carrier_off(dev);
 }
@@ -3541,20 +3585,17 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_sta_def_wmm_params(dev, selected, 0);
 		ieee80211_rx_bss_put(local, selected);
-		ifsta->state = IEEE80211_AUTHENTICATE;
+		ifsta->state = IEEE80211_DIRECT_PROBE;
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
-		if (ifsta->state != IEEE80211_AUTHENTICATE) {
-			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_sta_start_scan(dev, NULL, 0);
-			else
-				ieee80211_sta_start_scan(dev, ifsta->ssid,
+		if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
+			ieee80211_sta_start_scan(dev, NULL, 0);
+		else
+			ieee80211_sta_start_scan(dev, ifsta->ssid,
 							 ifsta->ssid_len);
-			ifsta->state = IEEE80211_AUTHENTICATE;
-			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		} else
-			ifsta->state = IEEE80211_DISABLED;
+		ifsta->state = IEEE80211_DIRECT_PROBE;
+		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
 	}
 	return -1;
 }
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

