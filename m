Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYHGWuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 18:50:52 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/2] mac80211: add direct probe before association
Date: Fri,  8 Aug 2008 01:50:47 +0300
Message-Id: <1218149447-28968-2-git-send-email-tomas.winkler@intel.com> (sfid-20080808_005105_043872_33425A84)
In-Reply-To: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com>
References: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds a direct probe request as first step in the association
flow if data we have is not up to date. Motivation of this step is to make
sure that the bss information we have is correct, since last scan could
have been done a while ago, and beacons do not fully answer this need as
there are potential differences between them and probe responses (e.g.
WMM parameter element)

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |    9 +++--
 net/mac80211/mlme.c        |   79 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f71785e..8a82fdc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -108,7 +108,7 @@ struct ieee80211_sta_bss {
 	u64 timestamp;
 	int beacon_int;
 
-	bool probe_resp;
+	unsigned long last_probe_resp;
 	unsigned long last_update;
 
 	/* during assocation, we save an ERP value from a probe response so
@@ -302,12 +302,14 @@ struct mesh_config {
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
 /* flags for  MLME request*/
 #define IEEE80211_STA_REQ_SCAN 0
-#define IEEE80211_STA_REQ_AUTH 1
-#define IEEE80211_STA_REQ_RUN  2
+#define IEEE80211_STA_REQ_DIRECT_PROBE 1
+#define IEEE80211_STA_REQ_AUTH 2
+#define IEEE80211_STA_REQ_RUN  3
 
 /* flags used for setting mlme state */
 enum ieee80211_sta_mlme_state {
 	IEEE80211_STA_MLME_DISABLED,
+ 	IEEE80211_STA_MLME_DIRECT_PROBE,
 	IEEE80211_STA_MLME_AUTHENTICATE,
 	IEEE80211_STA_MLME_ASSOCIATE,
 	IEEE80211_STA_MLME_ASSOCIATED,
@@ -370,6 +372,7 @@ struct ieee80211_if_sta {
 	struct sk_buff_head skb_queue;
 
 	int assoc_scan_tries; /* number of scans done pre-association */
+	int direct_probe_tries; /* retries for direct probes */
 	int auth_tries; /* retries for auth req */
 	int assoc_tries; /* retries for assoc req */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5276c73..934fd7a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -598,8 +598,10 @@ static void ieee80211_set_associated(struct net_device *dev,
 static void ieee80211_set_disassoc(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta, int deauth)
 {
-	if (deauth)
+	if (deauth) {
+ 		ifsta->direct_probe_tries = 0;
 		ifsta->auth_tries = 0;
+	}
 	ifsta->assoc_scan_tries = 0;
 	ifsta->assoc_tries = 0;
 	ieee80211_set_associated(dev, ifsta, 0);
@@ -660,6 +662,36 @@ static void ieee80211_send_auth(struct net_device *dev,
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
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		return;
+	}
+
+	printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
+			dev->name, print_mac(mac, ifsta->bssid),
+			ifsta->direct_probe_tries);
+
+	ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+
+	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
+
+	/* Direct probe is sent to broadcast address as some APs
+	 * will not answer to direct packet in unassociated state.
+	 */
+	ieee80211_send_probe_req(dev, NULL,
+				 ifsta->ssid, ifsta->ssid_len);
+
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
+}
+
 
 static void ieee80211_authenticate(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta)
@@ -1960,7 +1992,7 @@ static void ieee80211_rx_mgmt_deauth(struct net_device *dev,
 	if (ifsta->state == IEEE80211_STA_MLME_AUTHENTICATE ||
 	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATE ||
 	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
-		ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+		ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
@@ -2559,8 +2591,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
 				  struct ieee80211_rx_status *rx_status,
-				  struct ieee802_11_elems *elems,
-				  int beacon)
+				  struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int freq, clen;
@@ -2569,6 +2600,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u64 beacon_timestamp, rx_timestamp;
 	struct ieee80211_channel *channel;
+	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -2728,15 +2760,14 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	bss->signal = rx_status->signal;
 	bss->noise = rx_status->noise;
 	bss->qual = rx_status->qual;
-	if (!beacon && !bss->probe_resp)
-		bss->probe_resp = true;
-
+ 	if (!beacon)
+ 		bss->last_probe_resp = jiffies;
 	/*
 	 * In STA mode, the remaining parameters should not be overridden
 	 * by beacons because they're not necessarily accurate there.
 	 */
 	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    bss->probe_resp && beacon) {
+ 	    bss->last_probe_resp && beacon) {
 		ieee80211_rx_bss_put(local, bss);
 		return;
 	}
@@ -2891,6 +2922,8 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 {
 	size_t baselen;
 	struct ieee802_11_elems elems;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
@@ -2899,7 +2932,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 				&elems);
 
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 0);
+	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems);
+
+	/* direct probe may be part of the association flow */
+	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
+							&ifsta->request)) {
+		printk(KERN_DEBUG "%s direct probe responded\n", dev->name);
+		ieee80211_authenticate(dev, ifsta);
+	}
 }
 
 
@@ -2923,7 +2963,7 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 1);
+	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
@@ -3361,7 +3401,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		mesh_path_start_discovery(dev);
 #endif
 
-	if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
+	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
+	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
 		if (ifsta->scan_ssid_len)
@@ -3381,6 +3422,9 @@ void ieee80211_sta_work(struct work_struct *work)
 	switch (ifsta->state) {
 	case IEEE80211_STA_MLME_DISABLED:
 		break;
+	case IEEE80211_STA_MLME_DIRECT_PROBE:
+		ieee80211_direct_probe(dev, ifsta);
+		break;
 	case IEEE80211_STA_MLME_AUTHENTICATE:
 		ieee80211_authenticate(dev, ifsta);
 		break;
@@ -3440,6 +3484,7 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,
 	ifsta->auth_transaction = -1;
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 	ifsta->assoc_scan_tries = 0;
+	ifsta->direct_probe_tries = 0;
 	ifsta->auth_tries = 0;
 	ifsta->assoc_tries = 0;
 	netif_carrier_off(dev);
@@ -3543,8 +3588,18 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_sta_def_wmm_params(dev, selected, 0);
+
+ 		/* Send out direct probe if no probe resp was received or
+ 		 * the one we have is outdated
+ 		 */
+ 		if (!selected->last_probe_resp ||
+ 		    time_after(jiffies, selected->last_probe_resp
+ 					+ IEEE80211_SCAN_RESULT_EXPIRE))
+ 			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+ 		else
+ 			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+
 		ieee80211_rx_bss_put(local, selected);
-		ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

