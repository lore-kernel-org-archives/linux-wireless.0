Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2KZOYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:24:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: support VHT association
Date: Mon, 26 Nov 2012 15:25:14 +0100
Message-Id: <1353939915-25121-3-git-send-email-johannes@sipsolutions.net> (sfid-20121126_152458_941910_27814150)
In-Reply-To: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Determine the VHT channel from the AP's VHT operation IE
(if present) and configure the hardware to that channel
if it is supported. If channel contexts cause a channel
to not be usable, try a smaller bandwidth.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |  15 ++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/mlme.c        | 370 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 315 insertions(+), 72 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f9c5a78..8f690e5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1213,6 +1213,21 @@ struct ieee80211_vht_cap {
 } __packed;
 
 /**
+ * enum ieee80211_vht_chanwidth - VHT channel width
+ * @IEEE80211_VHT_CHANWIDTH_USE_HT: use the HT operation IE to
+ *	determine the channel width (20 or 40 MHz)
+ * @IEEE80211_VHT_CHANWIDTH_80MHZ: 80 MHz bandwidth
+ * @IEEE80211_VHT_CHANWIDTH_160MHZ: 160 MHz bandwidth
+ * @IEEE80211_VHT_CHANWIDTH_80P80MHZ: 80+80 MHz bandwidth
+ */
+enum ieee80211_vht_chanwidth {
+	IEEE80211_VHT_CHANWIDTH_USE_HT		= 0,
+	IEEE80211_VHT_CHANWIDTH_80MHZ		= 1,
+	IEEE80211_VHT_CHANWIDTH_160MHZ		= 2,
+	IEEE80211_VHT_CHANWIDTH_80P80MHZ	= 3,
+};
+
+/**
  * struct ieee80211_vht_operation - VHT operation IE
  *
  * This structure is the "VHT operation element" as
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0a8f83d..8d8bf71 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -371,6 +371,8 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 	IEEE80211_STA_DISABLE_40MHZ	= BIT(10),
 	IEEE80211_STA_DISABLE_VHT	= BIT(11),
+	IEEE80211_STA_DISABLE_80P80MHZ	= BIT(12),
+	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2a4f78..e15977f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -354,6 +354,16 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	/* determine capability flags */
 	cap = vht_cap.cap;
 
+	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_80P80MHZ) {
+		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+		cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+	}
+
+	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_160MHZ) {
+		cap &= ~IEEE80211_VHT_CAP_SHORT_GI_160;
+		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+	}
+
 	/* reserve and fill IE */
 	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
@@ -543,6 +553,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		offset = noffset;
 	}
 
+	if (WARN_ON_ONCE((ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
+			 !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT)))
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
 				    sband, chan, sdata->smps_mode);
@@ -3183,23 +3197,272 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 	return 0;
 }
 
+static u32 chandef_downgrade(struct cfg80211_chan_def *c)
+{
+	u32 ret;
+	int tmp;
+
+	switch (c->width) {
+	case NL80211_CHAN_WIDTH_20:
+		c->width = NL80211_CHAN_WIDTH_20_NOHT;
+		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		c->width = NL80211_CHAN_WIDTH_20;
+		c->center_freq1 = c->chan->center_freq;
+		ret = IEEE80211_STA_DISABLE_40MHZ |
+		      IEEE80211_STA_DISABLE_VHT;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		tmp = (30 + c->chan->center_freq - c->center_freq1)/20;
+		/* n_P40 */
+		tmp /= 2;
+		/* freq_P40 */
+		c->center_freq1 = c->center_freq1 - 20 + 40 * tmp;
+		c->width = NL80211_CHAN_WIDTH_40;
+		ret = IEEE80211_STA_DISABLE_VHT;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		c->center_freq2 = 0;
+		c->width = NL80211_CHAN_WIDTH_80;
+		ret = IEEE80211_STA_DISABLE_80P80MHZ |
+		      IEEE80211_STA_DISABLE_160MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		/* n_P20 */
+		tmp = (70 + c->chan->center_freq - c->center_freq1)/20;
+		/* n_P80 */
+		tmp /= 4;
+		c->center_freq1 = c->center_freq1 - 40 + 80 * tmp;
+		c->width = NL80211_CHAN_WIDTH_80;
+		ret = IEEE80211_STA_DISABLE_80P80MHZ |
+		      IEEE80211_STA_DISABLE_160MHZ;
+		break;
+	default:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		WARN_ON_ONCE(1);
+		c->width = NL80211_CHAN_WIDTH_20_NOHT;
+		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
+		break;
+	}
+
+	WARN_ON_ONCE(!cfg80211_chandef_valid(c));
+
+	return ret;
+}
+
+static u32
+ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_supported_band *sband,
+			     struct ieee80211_channel *channel,
+			     const struct ieee80211_ht_operation *ht_oper,
+			     const struct ieee80211_vht_operation *vht_oper,
+			     struct cfg80211_chan_def *chandef)
+{
+	struct cfg80211_chan_def vht_chandef;
+	u32 ht_cfreq, ret;
+
+	chandef->chan = channel;
+	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+	chandef->center_freq1 = channel->center_freq;
+	chandef->center_freq2 = 0;
+
+	if (!ht_oper || !sband->ht_cap.ht_supported) {
+		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	chandef->width = NL80211_CHAN_WIDTH_20;
+
+	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
+						  channel->band);
+	/* check that channel matches the right operating channel */
+	if (channel->center_freq != ht_cfreq) {
+		/*
+		 * It's possible that some APs are confused here;
+		 * Netgear WNDR3700 sometimes reports 4 higher than
+		 * the actual channel in association responses, but
+		 * since we look at probe response/beacon data here
+		 * it should be OK.
+		 */
+		sdata_info(sdata,
+			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
+			   channel->center_freq, ht_cfreq,
+			   ht_oper->primary_chan, channel->band);
+		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	/* check 40 MHz support, if we have it */
+	if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			chandef->width = NL80211_CHAN_WIDTH_40;
+			chandef->center_freq1 += 10;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			chandef->width = NL80211_CHAN_WIDTH_40;
+			chandef->center_freq1 -= 10;
+			break;
+		}
+	} else {
+		/* 40 MHz (and 80 MHz) must be supported for VHT */
+		ret = IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	if (!vht_oper || !sband->vht_cap.vht_supported) {
+		ret = IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	vht_chandef.chan = channel;
+	vht_chandef.center_freq1 =
+		ieee80211_channel_to_frequency(vht_oper->center_freq_seg1_idx,
+					       channel->band);
+	vht_chandef.center_freq2 = 0;
+
+	if (vht_oper->center_freq_seg2_idx)
+		vht_chandef.center_freq2 =
+			ieee80211_channel_to_frequency(
+				vht_oper->center_freq_seg2_idx,
+				channel->band);
+
+	switch (vht_oper->chan_width) {
+	case IEEE80211_VHT_CHANWIDTH_USE_HT:
+		vht_chandef.width = chandef->width;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80MHZ:
+		vht_chandef.width = NL80211_CHAN_WIDTH_80;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		vht_chandef.width = NL80211_CHAN_WIDTH_160;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
+		break;
+	default:
+		sdata_info(sdata,
+			   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
+			   vht_oper->chan_width);
+		ret = IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	if (!cfg80211_chandef_valid(&vht_chandef)) {
+		sdata_info(sdata,
+			   "AP VHT information is invalid, disable VHT\n");
+		ret = IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	if (cfg80211_chandef_identical(chandef, &vht_chandef)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!cfg80211_chandef_compatible(chandef, &vht_chandef)) {
+		sdata_info(sdata,
+			   "AP VHT information doesn't match HT, disable VHT\n");
+		ret = IEEE80211_STA_DISABLE_VHT;
+		goto out;
+	}
+
+	*chandef = vht_chandef;
+
+	ret = 0;
+
+	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
+					IEEE80211_CHAN_DISABLED)) {
+		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
+			ret = IEEE80211_STA_DISABLE_HT |
+			      IEEE80211_STA_DISABLE_VHT;
+			goto out;
+		}
+
+		ret = chandef_downgrade(chandef);
+	}
+
+	if (chandef->width != vht_chandef.width)
+		sdata_info(sdata,
+			   "local regulatory prevented using AP HT/VHT configuration, downgraded\n");
+
+out:
+	WARN_ON_ONCE(!cfg80211_chandef_valid(chandef));
+	return ret;
+}
+
+static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_bss *cbss)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	const u8 *ht_cap_ie, *vht_cap_ie;
+	const struct ieee80211_ht_cap *ht_cap;
+	const struct ieee80211_vht_cap *vht_cap;
+	u8 chains = 1;
+
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT)
+		return chains;
+
+	ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
+				     cbss->information_elements,
+				     cbss->len_information_elements);
+	if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap)) {
+		ht_cap = (void *)(ht_cap_ie + 2);
+		chains = ieee80211_mcs_to_chains(&ht_cap->mcs);
+		/*
+		 * TODO: use "Tx Maximum Number Spatial Streams Supported" and
+		 *	 "Tx Unequal Modulation Supported" fields.
+		 */
+		
+	}
+
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
+		return chains;
+
+
+	vht_cap_ie = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY,
+				      cbss->information_elements,
+				      cbss->len_information_elements);
+	if (vht_cap_ie && vht_cap_ie[1] >= sizeof(*vht_cap)) {
+		u8 nss;
+		u16 tx_mcs_map;
+
+		vht_cap = (void *)(vht_cap_ie + 2);
+		tx_mcs_map = le16_to_cpu(vht_cap->supp_mcs.tx_mcs_map);
+		for (nss = 8; nss > 0; nss--) {
+			if (((tx_mcs_map >> (2 * (nss - 1))) & 3) !=
+					IEEE80211_VHT_MCS_NOT_SUPPORTED)
+				break;
+		}
+		/* TODO: use "Tx Highest Supported Long GI Data Rate" field? */
+		chains = max(chains, nss);
+	}
+
+	return chains;
+}
+
 static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_bss *cbss)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int ht_cfreq;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-	const u8 *ht_oper_ie;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
+	const struct ieee80211_vht_operation *vht_oper = NULL;
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
+	int ret;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
-	ifmgd->flags &= ~IEEE80211_STA_DISABLE_40MHZ;
+	ifmgd->flags &= ~(IEEE80211_STA_DISABLE_40MHZ |
+			  IEEE80211_STA_DISABLE_80P80MHZ |
+			  IEEE80211_STA_DISABLE_160MHZ);
+
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
+	    sband->ht_cap.ht_supported) {
+		const u8 *ht_oper_ie;
 
-	if (sband->ht_cap.ht_supported) {
 		ht_oper_ie = cfg80211_find_ie(WLAN_EID_HT_OPERATION,
 					      cbss->information_elements,
 					      cbss->len_information_elements);
@@ -3207,82 +3470,45 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 			ht_oper = (void *)(ht_oper_ie + 2);
 	}
 
-	if (ht_oper) {
-		ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
-							  cbss->channel->band);
-		/* check that channel matches the right operating channel */
-		if (cbss->channel->center_freq != ht_cfreq) {
-			/*
-			 * It's possible that some APs are confused here;
-			 * Netgear WNDR3700 sometimes reports 4 higher than
-			 * the actual channel in association responses, but
-			 * since we look at probe response/beacon data here
-			 * it should be OK.
-			 */
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
+	    sband->vht_cap.vht_supported) {
+		const u8 *vht_oper_ie;
+
+		vht_oper_ie = cfg80211_find_ie(WLAN_EID_VHT_OPERATION,
+					       cbss->information_elements,
+					       cbss->len_information_elements);
+		if (vht_oper_ie && vht_oper_ie[1] >= sizeof(*vht_oper))
+			vht_oper = (void *)(vht_oper_ie + 2);
+		if (vht_oper && !ht_oper) {
+			vht_oper = NULL;
 			sdata_info(sdata,
-				   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
-				   cbss->channel->center_freq,
-				   ht_cfreq, ht_oper->primary_chan,
-				   cbss->channel->band);
-			ht_oper = NULL;
+				   "AP advertised VHT without HT, disabling both\n");
+			sdata->flags |= IEEE80211_STA_DISABLE_HT;
+			sdata->flags |= IEEE80211_STA_DISABLE_VHT;
 		}
 	}
 
-	if (ht_oper) {
-		/*
-		 * cfg80211 already verified that the channel itself can
-		 * be used, but it didn't check that we can do the right
-		 * HT type, so do that here as well. If HT40 isn't allowed
-		 * on this channel, disable 40 MHz operation.
-		 */
-		const u8 *ht_cap_ie;
-		const struct ieee80211_ht_cap *ht_cap;
-		u8 chains = 1;
-
-		channel_type = NL80211_CHAN_HT20;
-
-		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-			switch (ht_oper->ht_param &
-					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				if (cbss->channel->flags &
-						IEEE80211_CHAN_NO_HT40PLUS)
-					ifmgd->flags |=
-						IEEE80211_STA_DISABLE_40MHZ;
-				else
-					channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				if (cbss->channel->flags &
-						IEEE80211_CHAN_NO_HT40MINUS)
-					ifmgd->flags |=
-						IEEE80211_STA_DISABLE_40MHZ;
-				else
-					channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
-		}
+	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
+						     cbss->channel,
+						     ht_oper, vht_oper,
+						     &chandef);
 
-		ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
-					     cbss->information_elements,
-					     cbss->len_information_elements);
-		if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap)) {
-			ht_cap = (void *)(ht_cap_ie + 2);
-			chains = ieee80211_mcs_to_chains(&ht_cap->mcs);
-		}
-		sdata->needed_rx_chains = min(chains, local->rx_chains);
-	} else {
-		sdata->needed_rx_chains = 1;
-		sdata->u.mgd.flags |= IEEE80211_STA_DISABLE_HT;
-	}
+	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
+				      local->rx_chains);
 
 	/* will change later if needed */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 
-	ieee80211_vif_release_channel(sdata);
-	cfg80211_chandef_create(&chandef, cbss->channel, channel_type);
-	return ieee80211_vif_use_channel(sdata, &chandef,
-					 IEEE80211_CHANCTX_SHARED);
+	/*
+	 * If this fails (possibly due to channel context sharing
+	 * on incompatible channels, e.g. 80+80 and 160 sharing the
+	 * same control channel) try to use a smaller bandwidth.
+	 */
+	ret = ieee80211_vif_use_channel(sdata, &chandef,
+					IEEE80211_CHANCTX_SHARED);
+	while (ret && chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
+		ifmgd->flags |= chandef_downgrade(&chandef);
+	return ret;
 }
 
 static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

