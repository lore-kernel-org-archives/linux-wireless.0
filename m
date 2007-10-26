Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3285 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765572AbXJZVGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:06:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: store SSID in sta_bss_list
Date: Fri, 26 Oct 2007 17:04:32 -0400
Message-Id: <11934326813245-git-send-email-linville@tuxdriver.com> (sfid-20071026_220627_734296_AD5995B4)
In-Reply-To: <11934326812028-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Some AP equipment "in the wild" services multiple SSIDs using the
same BSSID.  This patch changes the key of sta_bss_list to include
the SSID as well as the BSSID and the channel so as to prevent one
SSID from eclipsing another SSID with the same BSSID.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   54 +++++++++++++++++++++++++----------------
 1 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 1991daa..e78b51e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -12,7 +12,6 @@
  */
 
 /* TODO:
- * BSS table: use <BSSID,SSID> as the key to support multi-SSID APs
  * order BSS list by RSSI(?) ("quality of AP")
  * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
  *    SSID)
@@ -61,7 +60,8 @@
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel);
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+		     u8 *ssid, u8 ssid_len);
 static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_find_ibss(struct net_device *dev,
@@ -403,7 +403,8 @@ static void ieee80211_set_associated(struct net_device *dev,
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel);
+					   local->hw.conf.channel,
+					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
 				ieee80211_handle_erp_ie(dev, bss->erp_value);
@@ -545,7 +546,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME |
 			WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
@@ -705,7 +707,8 @@ static int ieee80211_privacy_mismatch(struct net_device *dev,
 	    ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel);
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+				   ifsta->ssid, ifsta->ssid_len);
 	if (!bss)
 		return 0;
 
@@ -1215,7 +1218,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		struct ieee80211_sta_bss *bss
 			= ieee80211_rx_bss_get(dev, ifsta->bssid,
-					       local->hw.conf.channel);
+					       local->hw.conf.channel,
+					       ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			bss->erp_value = elems.erp_info[0];
 			bss->has_erp_value = 1;
@@ -1246,7 +1250,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel);
+					   local->hw.conf.channel,
+					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
@@ -1327,7 +1332,8 @@ static void __ieee80211_rx_bss_hash_del(struct net_device *dev,
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel)
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel,
+		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1339,6 +1345,10 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel)
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
 	bss->channel = channel;
+	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
+		memcpy(bss->ssid, ssid, ssid_len);
+		bss->ssid_len = ssid_len;
+	}
 
 	spin_lock_bh(&local->sta_bss_lock);
 	/* TODO: order by RSSI? */
@@ -1350,7 +1360,8 @@ ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel)
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel)
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
@@ -1358,8 +1369,10 @@ ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel)
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
-		if (memcmp(bss->bssid, bssid, ETH_ALEN) == 0 &&
-		    bss->channel == channel) {
+		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
+		    bss->channel == channel &&
+		    bss->ssid_len == ssid_len &&
+		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
 			atomic_inc(&bss->users);
 			break;
 		}
@@ -1527,9 +1540,11 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	else
 		channel = rx_status->channel;
 
-	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, channel);
+	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, channel,
+				   elems.ssid, elems.ssid_len);
 	if (!bss) {
-		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, channel);
+		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, channel,
+					   elems.ssid, elems.ssid_len);
 		if (!bss)
 			return;
 	} else {
@@ -1555,10 +1570,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
-	if (elems.ssid && elems.ssid_len <= IEEE80211_MAX_SSID_LEN) {
-		memcpy(bss->ssid, elems.ssid, elems.ssid_len);
-		bss->ssid_len = elems.ssid_len;
-	}
 
 	bss->supp_rates_len = 0;
 	if (elems.supp_rates) {
@@ -2339,7 +2350,7 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_hw_mode *mode;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
@@ -2361,11 +2372,11 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID " MAC_FMT "\n",
 	       dev->name, MAC_ARG(bssid));
 
-	bss = ieee80211_rx_bss_add(dev, bssid, local->hw.conf.channel);
+	bss = ieee80211_rx_bss_add(dev, bssid, local->hw.conf.channel,
+				   sdata->u.sta.ssid, sdata->u.sta.ssid_len);
 	if (!bss)
 		return -ENOMEM;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	mode = local->oper_hw_mode;
 
 	if (local->hw.conf.beacon_int == 0)
@@ -2431,7 +2442,8 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
 	       MAC_FMT "\n", MAC_ARG(bssid), MAC_ARG(ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel))) {
+	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel,
+					ifsta->ssid, ifsta->ssid_len))) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID " MAC_FMT
 		       " based on configured SSID\n",
 		       dev->name, MAC_ARG(bssid));
-- 
1.5.2.4

