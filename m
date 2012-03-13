Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:56870 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752437Ab2CMCfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/15] mwifiex: merge functions to derive cfp by chan & freq in one
Date: Mon, 12 Mar 2012 19:35:10 -0700
Message-Id: <1331606116-32745-4-git-send-email-bzhao@marvell.com> (sfid-20120313_033541_603461_97180512)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

There exist different functions with very long names
to derive the channel frequency and power tripplet
based on band and channel/freq.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfp.c       |   86 ++++++++++-------------------
 drivers/net/wireless/mwifiex/join.c      |    9 ++--
 drivers/net/wireless/mwifiex/main.h      |    9 +---
 drivers/net/wireless/mwifiex/scan.c      |   11 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c |   13 ++---
 5 files changed, 46 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 1782a77..7541d9a 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -169,59 +169,18 @@ u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 
 /*
  * This function locates the Channel-Frequency-Power triplet based upon
- * band and channel parameters.
+ * band and channel/frequency parameters.
  */
 struct mwifiex_chan_freq_power *
-mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
-						  *priv, u8 band, u16 channel)
+mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
 {
 	struct mwifiex_chan_freq_power *cfp = NULL;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
+	struct ieee80211_channel *ch = NULL;
 	int i;
 
-	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
-		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
-	else
-		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
-
-	if (!sband) {
-		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
-				" & channel %d\n", __func__, band, channel);
+	if (!channel && !freq)
 		return cfp;
-	}
-
-	for (i = 0; i < sband->n_channels; i++) {
-		ch = &sband->channels[i];
-		if (((ch->hw_value == channel) ||
-			(channel == FIRST_VALID_CHANNEL))
-			&& !(ch->flags & IEEE80211_CHAN_DISABLED)) {
-			priv->cfp.channel = channel;
-			priv->cfp.freq = ch->center_freq;
-			priv->cfp.max_tx_power = ch->max_power;
-			cfp = &priv->cfp;
-			break;
-		}
-	}
-	if (i == sband->n_channels)
-		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
-				" & channel %d\n", __func__, band, channel);
-
-	return cfp;
-}
-
-/*
- * This function locates the Channel-Frequency-Power triplet based upon
- * band and frequency parameters.
- */
-struct mwifiex_chan_freq_power *
-mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
-					       u8 band, u32 freq)
-{
-	struct mwifiex_chan_freq_power *cfp = NULL;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	int i;
 
 	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -229,25 +188,40 @@ mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
 		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband) {
-		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
-				" & freq %d\n", __func__, band, freq);
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d\n",
+			__func__, band);
 		return cfp;
 	}
 
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
-		if ((ch->center_freq == freq) &&
-			!(ch->flags & IEEE80211_CHAN_DISABLED)) {
-			priv->cfp.channel = ch->hw_value;
-			priv->cfp.freq = freq;
-			priv->cfp.max_tx_power = ch->max_power;
-			cfp = &priv->cfp;
-			break;
+
+		if (ch->flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		if (freq) {
+			if (ch->center_freq == freq)
+				break;
+		} else {
+			/* find by valid channel*/
+			if (ch->hw_value == channel ||
+			    channel == FIRST_VALID_CHANNEL)
+				break;
 		}
 	}
-	if (i == sband->n_channels)
+	if (i == sband->n_channels) {
 		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
-				" & freq %d\n", __func__, band, freq);
+			" & channel=%d freq=%d\n", __func__, band, channel,
+			freq);
+	} else {
+		if (!ch)
+			return cfp;
+
+		priv->cfp.channel = ch->hw_value;
+		priv->cfp.freq = ch->center_freq;
+		priv->cfp.max_tx_power = ch->max_power;
+		cfp = &priv->cfp;
+	}
 
 	return cfp;
 }
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index bce9991..803275f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -777,12 +777,11 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	adhoc_start->phy_param_set.ds_param_set.element_id = DS_PARA_IE_ID;
 	adhoc_start->phy_param_set.ds_param_set.len = DS_PARA_IE_LEN;
 
-	if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-			(priv, adapter->adhoc_start_band, (u16)
-				priv->adhoc_channel)) {
+	if (!mwifiex_get_cfp(priv, adapter->adhoc_start_band,
+			     (u16) priv->adhoc_channel, 0)) {
 		struct mwifiex_chan_freq_power *cfp;
-		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-				adapter->adhoc_start_band, FIRST_VALID_CHANNEL);
+		cfp = mwifiex_get_cfp(priv, adapter->adhoc_start_band,
+				      FIRST_VALID_CHANNEL, 0);
 		if (cfp)
 			priv->adhoc_channel = (u8) cfp->channel;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 58748b1..c0df48f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -771,13 +771,8 @@ int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
 int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd);
-struct mwifiex_chan_freq_power *
-			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
-						struct mwifiex_private *priv,
-						u8 band, u16 channel);
-struct mwifiex_chan_freq_power *mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
-						struct mwifiex_private *priv,
-						u8 band, u32 freq);
+struct mwifiex_chan_freq_power *mwifiex_get_cfp(struct mwifiex_private *priv,
+						u8 band, u16 channel, u32 freq);
 u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
 							u8 ht_info);
 u32 mwifiex_find_freq_from_band_chan(u8, u8);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index fd0302f..0a0c289 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1434,8 +1434,8 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 	if (!bss_desc)
 		return -1;
 
-	if ((mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-			(u8) bss_desc->bss_band, (u16) bss_desc->channel))) {
+	if ((mwifiex_get_cfp(priv, (u8) bss_desc->bss_band,
+			     (u16) bss_desc->channel, 0))) {
 		switch (priv->bss_mode) {
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
@@ -1625,7 +1625,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		s32 rssi;
 		const u8 *ie_buf;
 		size_t ie_len;
-		int channel = -1;
+		u16 channel = 0;
 		u64 network_tsf = 0;
 		u16 beacon_size = 0;
 		u32 curr_bcn_bytes;
@@ -1723,7 +1723,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					&tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
 					sizeof(network_tsf));
 
-		if (channel != -1) {
+		if (channel) {
 			struct ieee80211_channel *chan;
 			u8 band;
 
@@ -1736,8 +1736,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 						& (BIT(0) | BIT(1)));
 			}
 
-			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
-						priv, (u8)band, (u16)channel);
+			cfp = mwifiex_get_cfp(priv, band, channel, 0);
 
 			freq = cfp ? cfp->freq : 0;
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0ae1209..a3d79f4 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -529,11 +529,10 @@ int mwifiex_bss_set_channel(struct mwifiex_private *priv,
 		adapter->adhoc_start_band = BAND_G | BAND_B;
 	if (chan->channel) {
 		if (chan->channel <= MAX_CHANNEL_BAND_BG)
-			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-					(priv, 0, (u16) chan->channel);
+			cfp = mwifiex_get_cfp(priv, 0, (u16) chan->channel, 0);
 		if (!cfp) {
-			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-					(priv, BAND_A, (u16) chan->channel);
+			cfp = mwifiex_get_cfp(priv, BAND_A,
+					      (u16) chan->channel, 0);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band = BAND_A
@@ -544,11 +543,9 @@ int mwifiex_bss_set_channel(struct mwifiex_private *priv,
 		}
 	} else {
 		if (chan->freq <= MAX_FREQUENCY_BAND_BG)
-			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
-							priv, 0, chan->freq);
+			cfp = mwifiex_get_cfp(priv, 0, 0, chan->freq);
 		if (!cfp) {
-			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211
-						  (priv, BAND_A, chan->freq);
+			cfp = mwifiex_get_cfp(priv, BAND_A, 0, chan->freq);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band = BAND_A
-- 
1.7.0.2

