Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BHR2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:28:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 13/14] mac80211: move ieee80211_determine_chantype function
Date: Fri,  8 Feb 2013 18:25:43 +0100
Message-Id: <1360344344-15742-14-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183644_935222_B1E1CD04)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The next patch will need it further up in the file, so
move it unchanged now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 390 ++++++++++++++++++++++++++--------------------------
 1 file changed, 195 insertions(+), 195 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8af59f8..3ca390f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -174,6 +174,201 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
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
+		ret = IEEE80211_STA_DISABLE_VHT | IEEE80211_STA_DISABLE_40MHZ;
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
 static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta,
 				  struct ieee80211_ht_operation *ht_oper,
@@ -3305,201 +3500,6 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 	return 0;
 }
 
-static u32 chandef_downgrade(struct cfg80211_chan_def *c)
-{
-	u32 ret;
-	int tmp;
-
-	switch (c->width) {
-	case NL80211_CHAN_WIDTH_20:
-		c->width = NL80211_CHAN_WIDTH_20_NOHT;
-		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		c->width = NL80211_CHAN_WIDTH_20;
-		c->center_freq1 = c->chan->center_freq;
-		ret = IEEE80211_STA_DISABLE_40MHZ |
-		      IEEE80211_STA_DISABLE_VHT;
-		break;
-	case NL80211_CHAN_WIDTH_80:
-		tmp = (30 + c->chan->center_freq - c->center_freq1)/20;
-		/* n_P40 */
-		tmp /= 2;
-		/* freq_P40 */
-		c->center_freq1 = c->center_freq1 - 20 + 40 * tmp;
-		c->width = NL80211_CHAN_WIDTH_40;
-		ret = IEEE80211_STA_DISABLE_VHT;
-		break;
-	case NL80211_CHAN_WIDTH_80P80:
-		c->center_freq2 = 0;
-		c->width = NL80211_CHAN_WIDTH_80;
-		ret = IEEE80211_STA_DISABLE_80P80MHZ |
-		      IEEE80211_STA_DISABLE_160MHZ;
-		break;
-	case NL80211_CHAN_WIDTH_160:
-		/* n_P20 */
-		tmp = (70 + c->chan->center_freq - c->center_freq1)/20;
-		/* n_P80 */
-		tmp /= 4;
-		c->center_freq1 = c->center_freq1 - 40 + 80 * tmp;
-		c->width = NL80211_CHAN_WIDTH_80;
-		ret = IEEE80211_STA_DISABLE_80P80MHZ |
-		      IEEE80211_STA_DISABLE_160MHZ;
-		break;
-	default:
-	case NL80211_CHAN_WIDTH_20_NOHT:
-		WARN_ON_ONCE(1);
-		c->width = NL80211_CHAN_WIDTH_20_NOHT;
-		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
-		break;
-	}
-
-	WARN_ON_ONCE(!cfg80211_chandef_valid(c));
-
-	return ret;
-}
-
-static u32
-ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_supported_band *sband,
-			     struct ieee80211_channel *channel,
-			     const struct ieee80211_ht_operation *ht_oper,
-			     const struct ieee80211_vht_operation *vht_oper,
-			     struct cfg80211_chan_def *chandef)
-{
-	struct cfg80211_chan_def vht_chandef;
-	u32 ht_cfreq, ret;
-
-	chandef->chan = channel;
-	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
-	chandef->center_freq1 = channel->center_freq;
-	chandef->center_freq2 = 0;
-
-	if (!ht_oper || !sband->ht_cap.ht_supported) {
-		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	chandef->width = NL80211_CHAN_WIDTH_20;
-
-	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
-						  channel->band);
-	/* check that channel matches the right operating channel */
-	if (channel->center_freq != ht_cfreq) {
-		/*
-		 * It's possible that some APs are confused here;
-		 * Netgear WNDR3700 sometimes reports 4 higher than
-		 * the actual channel in association responses, but
-		 * since we look at probe response/beacon data here
-		 * it should be OK.
-		 */
-		sdata_info(sdata,
-			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
-			   channel->center_freq, ht_cfreq,
-			   ht_oper->primary_chan, channel->band);
-		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	/* check 40 MHz support, if we have it */
-	if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			chandef->width = NL80211_CHAN_WIDTH_40;
-			chandef->center_freq1 += 10;
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			chandef->width = NL80211_CHAN_WIDTH_40;
-			chandef->center_freq1 -= 10;
-			break;
-		}
-	} else {
-		/* 40 MHz (and 80 MHz) must be supported for VHT */
-		ret = IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	if (!vht_oper || !sband->vht_cap.vht_supported) {
-		ret = IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	vht_chandef.chan = channel;
-	vht_chandef.center_freq1 =
-		ieee80211_channel_to_frequency(vht_oper->center_freq_seg1_idx,
-					       channel->band);
-	vht_chandef.center_freq2 = 0;
-
-	if (vht_oper->center_freq_seg2_idx)
-		vht_chandef.center_freq2 =
-			ieee80211_channel_to_frequency(
-				vht_oper->center_freq_seg2_idx,
-				channel->band);
-
-	switch (vht_oper->chan_width) {
-	case IEEE80211_VHT_CHANWIDTH_USE_HT:
-		vht_chandef.width = chandef->width;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_80MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_80;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_160MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_160;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
-		break;
-	default:
-		sdata_info(sdata,
-			   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
-			   vht_oper->chan_width);
-		ret = IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	if (!cfg80211_chandef_valid(&vht_chandef)) {
-		sdata_info(sdata,
-			   "AP VHT information is invalid, disable VHT\n");
-		ret = IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	if (cfg80211_chandef_identical(chandef, &vht_chandef)) {
-		ret = 0;
-		goto out;
-	}
-
-	if (!cfg80211_chandef_compatible(chandef, &vht_chandef)) {
-		sdata_info(sdata,
-			   "AP VHT information doesn't match HT, disable VHT\n");
-		ret = IEEE80211_STA_DISABLE_VHT;
-		goto out;
-	}
-
-	*chandef = vht_chandef;
-
-	ret = 0;
-
-	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-					IEEE80211_CHAN_DISABLED)) {
-		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
-			ret = IEEE80211_STA_DISABLE_HT |
-			      IEEE80211_STA_DISABLE_VHT;
-			goto out;
-		}
-
-		ret = chandef_downgrade(chandef);
-	}
-
-	if (chandef->width != vht_chandef.width)
-		sdata_info(sdata,
-			   "local regulatory prevented using AP HT/VHT configuration, downgraded\n");
-
-out:
-	WARN_ON_ONCE(!cfg80211_chandef_valid(chandef));
-	return ret;
-}
-
 static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss)
 {
-- 
1.8.0

