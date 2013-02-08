Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BHR2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:28:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 14/14] mac80211: properly track HT/VHT operation changes
Date: Fri,  8 Feb 2013 18:25:44 +0100
Message-Id: <1360344344-15742-15-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183812_452599_890EF4AF)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A while ago, I made the mac80211 station code never change
the channel type after association. This solved a number of
issues but is ultimately wrong, we should react if the AP
changes the HT operation IE and switches bandwidth. One of
the issues is that we associate as HT40 capable, but if the
AP ever switches to 40 MHz we won't be able to receive such
frames because we never set our channel to 40 MHz.

This addresses this and VHT operation changes. If there's a
change that is incompatible with our setup, e.g. if the AP
decides to change the channel entirely (and for some reason
we still hear the beacon) we'll just disconnect.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 211 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 143 insertions(+), 68 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3ca390f..38b38ef 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -114,6 +114,9 @@ enum rx_mgmt_action {
 
 	/* caller must call cfg80211_send_assoc_timeout() */
 	RX_MGMT_CFG80211_ASSOC_TIMEOUT,
+
+	/* used when a processed beacon causes a deauth */
+	RX_MGMT_CFG80211_TX_DEAUTH,
 };
 
 /* utils */
@@ -234,7 +237,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_channel *channel,
 			     const struct ieee80211_ht_operation *ht_oper,
 			     const struct ieee80211_vht_operation *vht_oper,
-			     struct cfg80211_chan_def *chandef)
+			     struct cfg80211_chan_def *chandef, bool verbose)
 {
 	struct cfg80211_chan_def vht_chandef;
 	u32 ht_cfreq, ret;
@@ -262,10 +265,11 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		 * since we look at probe response/beacon data here
 		 * it should be OK.
 		 */
-		sdata_info(sdata,
-			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
-			   channel->center_freq, ht_cfreq,
-			   ht_oper->primary_chan, channel->band);
+		if (verbose)
+			sdata_info(sdata,
+				   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
+				   channel->center_freq, ht_cfreq,
+				   ht_oper->primary_chan, channel->band);
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
@@ -319,16 +323,18 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
 		break;
 	default:
-		sdata_info(sdata,
-			   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
-			   vht_oper->chan_width);
+		if (verbose)
+			sdata_info(sdata,
+				   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
+				   vht_oper->chan_width);
 		ret = IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
 
 	if (!cfg80211_chandef_valid(&vht_chandef)) {
-		sdata_info(sdata,
-			   "AP VHT information is invalid, disable VHT\n");
+		if (verbose)
+			sdata_info(sdata,
+				   "AP VHT information is invalid, disable VHT\n");
 		ret = IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
@@ -339,8 +345,9 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!cfg80211_chandef_compatible(chandef, &vht_chandef)) {
-		sdata_info(sdata,
-			   "AP VHT information doesn't match HT, disable VHT\n");
+		if (verbose)
+			sdata_info(sdata,
+				   "AP VHT information doesn't match HT, disable VHT\n");
 		ret = IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
@@ -360,7 +367,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		ret = chandef_downgrade(chandef);
 	}
 
-	if (chandef->width != vht_chandef.width)
+	if (chandef->width != vht_chandef.width && verbose)
 		sdata_info(sdata,
 			   "local regulatory prevented using AP HT/VHT configuration, downgraded\n");
 
@@ -369,66 +376,100 @@ out:
 	return ret;
 }
 
-static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
-				  struct sta_info *sta,
-				  struct ieee80211_ht_operation *ht_oper,
-				  const u8 *bssid, bool reconfig)
+static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
+			       struct sta_info *sta,
+			       const struct ieee80211_ht_operation *ht_oper,
+			       const struct ieee80211_vht_operation *vht_oper,
+			       const u8 *bssid, u32 *changed)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	u32 changed = 0;
+	struct cfg80211_chan_def chandef;
 	u16 ht_opmode;
-	bool disable_40 = false;
+	u32 flags;
+	enum ieee80211_sta_rx_bandwidth new_sta_bw;
+	int ret;
 
-	if (WARN_ON_ONCE(!sta))
+	if (!ht_oper)
 		return 0;
 
+	if (WARN_ON_ONCE(!sta))
+		return -EINVAL;
+
 	chan = sdata->vif.bss_conf.chandef.chan;
 	sband = local->hw.wiphy->bands[chan->band];
 
-	switch (sdata->vif.bss_conf.chandef.width) {
+	flags = ieee80211_determine_chantype(sdata, sband, chan, ht_oper,
+					     vht_oper, &chandef, false);
+
+	if (flags != (ifmgd->flags & (IEEE80211_STA_DISABLE_HT |
+				      IEEE80211_STA_DISABLE_VHT |
+				      IEEE80211_STA_DISABLE_40MHZ |
+				      IEEE80211_STA_DISABLE_80P80MHZ |
+				      IEEE80211_STA_DISABLE_160MHZ)) ||
+	    !cfg80211_chandef_valid(&chandef)) {
+		sdata_info(sdata,
+			   "AP %pM changed bandwidth in a way we can't support - disconnect\n",
+			   ifmgd->bssid);
+		return -EINVAL;
+	}
+
+	if (cfg80211_chandef_identical(&chandef, &sdata->vif.bss_conf.chandef))
+		return 0;
+
+	switch (chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		new_sta_bw = IEEE80211_STA_RX_BW_20;
+		break;
 	case NL80211_CHAN_WIDTH_40:
-		if (chan->center_freq >
-				sdata->vif.bss_conf.chandef.center_freq1 &&
-		    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
-			disable_40 = true;
-		if (chan->center_freq <
-				sdata->vif.bss_conf.chandef.center_freq1 &&
-		    chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-			disable_40 = true;
+		new_sta_bw = IEEE80211_STA_RX_BW_40;
 		break;
-	default:
+	case NL80211_CHAN_WIDTH_80:
+		new_sta_bw = IEEE80211_STA_RX_BW_80;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		new_sta_bw = IEEE80211_STA_RX_BW_160;
 		break;
+	default:
+		return -EINVAL;
 	}
 
-	/* This can change during the lifetime of the BSS */
-	if (!(ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
-		disable_40 = true;
+	if (new_sta_bw > sta->vht_opmode_bandwidth)
+		new_sta_bw = sta->vht_opmode_bandwidth;
 
-	if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-		disable_40 = true;
+	if (new_sta_bw < sta->sta.bandwidth) {
+		sta->sta.bandwidth = new_sta_bw;
+		rate_control_rate_update(local, sband, sta,
+					 IEEE80211_RC_BW_CHANGED);
+	}
 
-	if (disable_40 != (sta->sta.bandwidth < IEEE80211_STA_RX_BW_40)) {
-		if (disable_40)
-			sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
-		else
-			sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
+	ret = ieee80211_vif_change_bandwidth(sdata, &chandef, changed);
+	if (ret) {
+		sdata_info(sdata,
+			   "AP %pM changed bandwidth to incompatible one - disconnect\n",
+			   ifmgd->bssid);
+		return ret;
+	}
 
-		if (reconfig)
-			rate_control_rate_update(local, sband, sta,
-						 IEEE80211_RC_BW_CHANGED);
+	if (new_sta_bw > sta->sta.bandwidth) {
+		sta->sta.bandwidth = new_sta_bw;
+		rate_control_rate_update(local, sband, sta,
+					 IEEE80211_RC_BW_CHANGED);
 	}
 
 	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (!reconfig || (sdata->vif.bss_conf.ht_operation_mode != ht_opmode)) {
-		changed |= BSS_CHANGED_HT;
+	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
+		*changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 	}
 
-	return changed;
+	return 0;
 }
 
 /* frame sending functions */
@@ -2360,6 +2401,24 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->aid = aid;
 
+	/*
+	 * We previously checked these in the beacon/probe response, so
+	 * they should be present here. This is just a safety net.
+	 */
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
+	    (!elems.wmm_param || !elems.ht_cap_elem || !elems.ht_operation)) {
+		sdata_info(sdata,
+			   "HT AP is missing WMM params or HT capability/operation in AssocResp\n");
+		return false;
+	}
+
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
+	    (!elems.vht_cap_elem || !elems.vht_operation)) {
+		sdata_info(sdata,
+			   "VHT AP is missing VHT capability/operation in AssocResp\n");
+		return false;
+	}
+
 	mutex_lock(&sdata->local->sta_mtx);
 	/*
 	 * station info was already allocated and inserted before
@@ -2373,6 +2432,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
 
+	/* Set up internal HT/VHT capabilities */
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems.ht_cap_elem, sta);
@@ -2381,11 +2441,12 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    elems.vht_cap_elem, sta);
 
-	if (elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
-		changed |= ieee80211_config_ht_tx(sdata, sta,
-						  elems.ht_operation,
-						  cbss->bssid, false);
+	/*
+	 * Some APs, e.g. Netgear WNDR3700, report invalid HT operation data
+	 * in their association response, so ignore that data for our own
+	 * configuration. If it changed since the last beacon, we'll get the
+	 * next beacon and update then.
+	 */
 
 	rate_control_rate_init(sta);
 
@@ -2669,10 +2730,10 @@ static const u64 care_about_ies =
 	(1ULL << WLAN_EID_HT_CAPABILITY) |
 	(1ULL << WLAN_EID_HT_OPERATION);
 
-static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgmt *mgmt,
-				     size_t len,
-				     struct ieee80211_rx_status *rx_status)
+static enum rx_mgmt_action
+ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_mgmt *mgmt, size_t len,
+			 u8 *deauth_buf, struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
@@ -2693,18 +2754,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
 	if (baselen > len)
-		return;
+		return RX_MGMT_NONE;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (!chanctx_conf) {
 		rcu_read_unlock();
-		return;
+		return RX_MGMT_NONE;
 	}
 
 	if (rx_status->freq != chanctx_conf->def.chan->center_freq) {
 		rcu_read_unlock();
-		return;
+		return RX_MGMT_NONE;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -2731,12 +2792,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
-		return;
+		return RX_MGMT_NONE;
 	}
 
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return;
+		return RX_MGMT_NONE;
 	bssid = ifmgd->associated->bssid;
 
 	/* Track average RSSI from the Beacon frames of the current AP */
@@ -2874,7 +2935,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
-		return;
+		return RX_MGMT_NONE;
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
@@ -2923,11 +2984,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 
-	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
-		changed |= ieee80211_config_ht_tx(sdata, sta,
-						  elems.ht_operation,
-						  bssid, true);
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT)
+		elems.ht_operation = NULL;
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
+		elems.vht_operation = NULL;
+	if (ieee80211_config_bw(sdata, sta, elems.ht_operation,
+				elems.vht_operation, bssid, &changed)) {
+		mutex_unlock(&local->sta_mtx);
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_DEAUTH_LEAVING,
+				       true, deauth_buf);
+		return RX_MGMT_CFG80211_TX_DEAUTH;
+	}
 
 	if (sta && elems.vht_opmode)
 		ieee80211_vht_handle_opmode(sdata, sta, *elems.vht_opmode,
@@ -2943,6 +3011,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 						       elems.pwr_constr_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+
+	return RX_MGMT_NONE;
 }
 
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
@@ -2953,6 +3023,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgmt *mgmt;
 	struct cfg80211_bss *bss = NULL;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
+	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	u16 fc;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
@@ -2963,7 +3034,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_BEACON:
-		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
+		rma = ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+					       deauth_buf, rx_status);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
 		ieee80211_rx_mgmt_probe_resp(sdata, skb);
@@ -3015,6 +3087,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	case RX_MGMT_CFG80211_ASSOC_TIMEOUT:
 		cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
 		break;
+	case RX_MGMT_CFG80211_TX_DEAUTH:
+		cfg80211_send_deauth(sdata->dev, deauth_buf, sizeof(deauth_buf));
+		break;
 	default:
 		WARN(1, "unexpected: %d", rma);
 	}
@@ -3604,7 +3679,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
 						     ht_oper, vht_oper,
-						     &chandef);
+						     &chandef, true);
 
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
 				      local->rx_chains);
-- 
1.8.0

