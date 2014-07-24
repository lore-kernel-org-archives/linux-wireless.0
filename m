Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33939 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934120AbaGXIXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 04:23:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: disable 40MHz support in case of 20MHz AP
Date: Thu, 24 Jul 2014 11:20:05 +0300
Message-Id: <1406190005-18611-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140724_102348_365277_0069399C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If the AP only advertises support for 20MHz (in the
ht operation ie), disable 40MHz and VHT.

This can improve interoperability with APs that
don't like stations exceeding their own
advertised capabilities.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1137ceb..4aa1f1e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -149,6 +149,7 @@ static u32
 ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_supported_band *sband,
 			     struct ieee80211_channel *channel,
+			     const struct ieee80211_ht_cap *ht_cap,
 			     const struct ieee80211_ht_operation *ht_oper,
 			     const struct ieee80211_vht_operation *vht_oper,
 			     struct cfg80211_chan_def *chandef, bool tracking)
@@ -162,13 +163,19 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	chandef->center_freq1 = channel->center_freq;
 	chandef->center_freq2 = 0;
 
-	if (!ht_oper || !sband->ht_cap.ht_supported) {
+	if (!ht_cap || !ht_oper || !sband->ht_cap.ht_supported) {
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
 
 	chandef->width = NL80211_CHAN_WIDTH_20;
 
+	if (!(ht_cap->cap_info &
+	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
+		ret = IEEE80211_STA_DISABLE_40MHZ | IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
 	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
 						  channel->band);
 	/* check that channel matches the right operating channel */
@@ -328,6 +335,7 @@ out:
 
 static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 			       struct sta_info *sta,
+			       const struct ieee80211_ht_cap *ht_cap,
 			       const struct ieee80211_ht_operation *ht_oper,
 			       const struct ieee80211_vht_operation *vht_oper,
 			       const u8 *bssid, u32 *changed)
@@ -367,8 +375,9 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[chan->band];
 
 	/* calculate new channel (type) based on HT/VHT operation IEs */
-	flags = ieee80211_determine_chantype(sdata, sband, chan, ht_oper,
-					     vht_oper, &chandef, true);
+	flags = ieee80211_determine_chantype(sdata, sband, chan,
+					     ht_cap, ht_oper, vht_oper,
+					     &chandef, true);
 
 	/*
 	 * Downgrade the new channel if we associated with restricted
@@ -3187,7 +3196,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 
-	if (ieee80211_config_bw(sdata, sta, elems.ht_operation,
+	if (ieee80211_config_bw(sdata, sta,
+				elems.ht_cap_elem, elems.ht_operation,
 				elems.vht_operation, bssid, &changed)) {
 		mutex_unlock(&local->sta_mtx);
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
@@ -3821,6 +3831,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	const struct ieee80211_ht_cap *ht_cap = NULL;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
 	const struct ieee80211_vht_operation *vht_oper = NULL;
 	struct ieee80211_supported_band *sband;
@@ -3837,14 +3848,17 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
 	    sband->ht_cap.ht_supported) {
-		const u8 *ht_oper_ie, *ht_cap;
+		const u8 *ht_oper_ie, *ht_cap_ie;
 
 		ht_oper_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_OPERATION);
 		if (ht_oper_ie && ht_oper_ie[1] >= sizeof(*ht_oper))
 			ht_oper = (void *)(ht_oper_ie + 2);
 
-		ht_cap = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_CAPABILITY);
-		if (!ht_cap || ht_cap[1] < sizeof(struct ieee80211_ht_cap)) {
+		ht_cap_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_CAPABILITY);
+		if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap))
+			ht_cap = (void *)(ht_cap_ie + 2);
+
+		if (!ht_cap) {
 			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 			ht_oper = NULL;
 		}
@@ -3875,7 +3889,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
-						     ht_oper, vht_oper,
+						     ht_cap, ht_oper, vht_oper,
 						     &chandef, false);
 
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
-- 
1.9.1

