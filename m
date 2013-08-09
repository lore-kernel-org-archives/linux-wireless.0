Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35711 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608Ab3HIOgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 10:36:05 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 3/6] mac80211: move ibss presp generation in own function
Date: Fri,  9 Aug 2013 16:35:17 +0200
Message-Id: <1376058920-17779-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130809_163638_899471_05E926E4)
In-Reply-To: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel Switch will later require to generate beacons without setting
them immediately. Therefore split the presp generation in an own
function. Splitting the original very long function might be a good idea
anyway.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c |  185 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 109 insertions(+), 76 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e08387c..29f1a7b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -34,13 +34,12 @@
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
-
-static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				      const u8 *bssid, const int beacon_int,
-				      struct ieee80211_channel *chan,
-				      const u32 basic_rates,
-				      const u16 capability, u64 tsf,
-				      bool creator)
+static struct beacon_data *
+ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
+			   const int beacon_int, const u32 basic_rates,
+			   const u16 capability, u64 tsf,
+			   struct cfg80211_chan_def *chandef,
+			   bool *have_higher_than_11mbit)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -48,70 +47,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
-	struct cfg80211_bss *bss;
-	u32 bss_change, rate_flags, rates = 0, rates_added = 0;
-	struct cfg80211_chan_def chandef;
-	enum nl80211_bss_scan_width scan_width;
-	bool have_higher_than_11mbit = false;
+	u32 rate_flags, rates = 0, rates_added = 0;
 	struct beacon_data *presp;
 	int frame_len;
 	int shift;
 
-	sdata_assert_lock(sdata);
-
-	/* Reset own TSF to allow time synchronization work. */
-	drv_reset_tsf(local, sdata);
-
-	if (!ether_addr_equal(ifibss->bssid, bssid))
-		sta_info_flush(sdata);
-
-	/* if merging, indicate to driver that we leave the old IBSS */
-	if (sdata->vif.bss_conf.ibss_joined) {
-		sdata->vif.bss_conf.ibss_joined = false;
-		sdata->vif.bss_conf.ibss_creator = false;
-		sdata->vif.bss_conf.enable_beacon = false;
-		netif_carrier_off(sdata->dev);
-		ieee80211_bss_info_change_notify(sdata,
-						 BSS_CHANGED_IBSS |
-						 BSS_CHANGED_BEACON_ENABLED);
-	}
-
-	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&sdata->wdev.mtx));
-	rcu_assign_pointer(ifibss->presp, NULL);
-	if (presp)
-		kfree_rcu(presp, rcu_head);
-
-	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
-
-	chandef = ifibss->chandef;
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
-		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
-		    chandef.width == NL80211_CHAN_WIDTH_10 ||
-		    chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
-		    chandef.width == NL80211_CHAN_WIDTH_20) {
-			sdata_info(sdata,
-				   "Failed to join IBSS, beacons forbidden\n");
-			return;
-		}
-		chandef.width = NL80211_CHAN_WIDTH_20;
-		chandef.center_freq1 = chan->center_freq;
-	}
-
-	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, &chandef,
-				      ifibss->fixed_channel ?
-					IEEE80211_CHANCTX_SHARED :
-					IEEE80211_CHANCTX_EXCLUSIVE)) {
-		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
-		return;
-	}
-
-	memcpy(ifibss->bssid, bssid, ETH_ALEN);
-
-	sband = local->hw.wiphy->bands[chan->band];
-	shift = ieee80211_vif_get_shift(&sdata->vif);
-
 	/* Build IBSS probe response */
 	frame_len = sizeof(struct ieee80211_hdr_3addr) +
 		    12 /* struct ieee80211_mgmt.u.beacon */ +
@@ -125,7 +65,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		    ifibss->ie_len;
 	presp = kzalloc(sizeof(*presp) + frame_len, GFP_KERNEL);
 	if (!presp)
-		return;
+		return NULL;
 
 	presp->head = (void *)(presp + 1);
 
@@ -146,12 +86,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
 	pos += ifibss->ssid_len;
 
-	rate_flags = ieee80211_chandef_rate_flags(&chandef);
+	sband = local->hw.wiphy->bands[chandef->chan->band];
+	rate_flags = ieee80211_chandef_rate_flags(chandef);
+	shift = ieee80211_chandef_get_shift(chandef);
+	rates_n = 0;
+	if (have_higher_than_11mbit)
+		*have_higher_than_11mbit = false;
+
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
 			continue;
-		if (sband->bitrates[i].bitrate > 110)
-			have_higher_than_11mbit = true;
+		if (sband->bitrates[i].bitrate > 110 &&
+		    have_higher_than_11mbit)
+			*have_higher_than_11mbit = true;
 
 		rates |= BIT(i);
 		rates_n++;
@@ -178,7 +125,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (sband->band == IEEE80211_BAND_2GHZ) {
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
+		*pos++ = ieee80211_frequency_to_channel(
+				chandef->chan->center_freq);
 	}
 
 	*pos++ = WLAN_EID_IBSS_PARAMS;
@@ -210,9 +158,9 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* add HT capability and information IEs */
-	if (chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
-	    chandef.width != NL80211_CHAN_WIDTH_5 &&
-	    chandef.width != NL80211_CHAN_WIDTH_10 &&
+	if (chandef->width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    chandef->width != NL80211_CHAN_WIDTH_5 &&
+	    chandef->width != NL80211_CHAN_WIDTH_10 &&
 	    sband->ht_cap.ht_supported) {
 		struct ieee80211_sta_ht_cap ht_cap;
 
@@ -226,7 +174,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 &chandef, 0);
+						 chandef, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
@@ -243,9 +191,94 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	presp->head_len = pos - presp->head;
 	if (WARN_ON(presp->head_len > frame_len))
+		goto error;
+
+	return presp;
+error:
+	kfree(presp);
+	return NULL;
+}
+
+static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				      const u8 *bssid, const int beacon_int,
+				      struct ieee80211_channel *chan,
+				      const u32 basic_rates,
+				      const u16 capability, u64 tsf,
+				      bool creator)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_mgmt *mgmt;
+	struct cfg80211_bss *bss;
+	u32 bss_change;
+	struct cfg80211_chan_def chandef;
+	struct beacon_data *presp;
+	enum nl80211_bss_scan_width scan_width;
+	bool have_higher_than_11mbit;
+
+	sdata_assert_lock(sdata);
+
+	/* Reset own TSF to allow time synchronization work. */
+	drv_reset_tsf(local, sdata);
+
+	if (!ether_addr_equal(ifibss->bssid, bssid))
+		sta_info_flush(sdata);
+
+	/* if merging, indicate to driver that we leave the old IBSS */
+	if (sdata->vif.bss_conf.ibss_joined) {
+		sdata->vif.bss_conf.ibss_joined = false;
+		sdata->vif.bss_conf.ibss_creator = false;
+		sdata->vif.bss_conf.enable_beacon = false;
+		netif_carrier_off(sdata->dev);
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_IBSS |
+						 BSS_CHANGED_BEACON_ENABLED);
+	}
+
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&sdata->wdev.mtx));
+	rcu_assign_pointer(ifibss->presp, NULL);
+	if (presp)
+		kfree_rcu(presp, rcu_head);
+
+	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
+
+	chandef = ifibss->chandef;
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
+		    chandef.width == NL80211_CHAN_WIDTH_10 ||
+		    chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+		    chandef.width == NL80211_CHAN_WIDTH_20) {
+			sdata_info(sdata,
+				   "Failed to join IBSS, beacons forbidden\n");
+			return;
+		}
+		chandef.width = NL80211_CHAN_WIDTH_20;
+		chandef.center_freq1 = chan->center_freq;
+	}
+
+	ieee80211_vif_release_channel(sdata);
+	if (ieee80211_vif_use_channel(sdata, &chandef,
+				      ifibss->fixed_channel ?
+					IEEE80211_CHANCTX_SHARED :
+					IEEE80211_CHANCTX_EXCLUSIVE)) {
+		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
+		return;
+	}
+
+	memcpy(ifibss->bssid, bssid, ETH_ALEN);
+
+	sband = local->hw.wiphy->bands[chan->band];
+
+	presp = ieee80211_ibss_build_presp(sdata, beacon_int, basic_rates,
+					   capability, tsf, &chandef,
+					   &have_higher_than_11mbit);
+	if (!presp)
 		return;
 
 	rcu_assign_pointer(ifibss->presp, presp);
+	mgmt = (void *)presp->head;
 
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
-- 
1.7.10.4

