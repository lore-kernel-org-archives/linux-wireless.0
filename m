Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:34445 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757123Ab2GNDMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 23:12:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: add support to use basic rates in ibss join request
Date: Fri, 13 Jul 2012 20:09:32 -0700
Message-Id: <1342235373-27613-4-git-send-email-bzhao@marvell.com> (sfid-20120714_051243_737415_F93E6508)
In-Reply-To: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
References: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In mwifiex_set_rf_channel() ibss specific flags were unnecessarily
getting modified for infra and AP mode. This patch removes
mwifiex_set_rf_channel() function and adds equivalant code in infra,
ibss and AP path.

For ibss, now we are chosing band based on channel type and basic
rates provided in ibss join request. We can start ibss network in
A only, B only, G only, BG, BGN, AN mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  182 ++++++++++++++++++-------------
 drivers/net/wireless/mwifiex/init.c     |    1 -
 2 files changed, 108 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7d68c2b..ed3b8b2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -48,10 +48,9 @@ static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
  *      Others                 -> IEEE80211_HT_PARAM_CHA_SEC_NONE
  */
 static u8
-mwifiex_cfg80211_channel_type_to_sec_chan_offset(enum nl80211_channel_type
-						 channel_type)
+mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type)
 {
-	switch (channel_type) {
+	switch (chan_type) {
 	case NL80211_CHAN_NO_HT:
 	case NL80211_CHAN_HT20:
 		return IEEE80211_HT_PARAM_CHA_SEC_NONE;
@@ -339,68 +338,6 @@ static int mwifiex_reg_notifier(struct wiphy *wiphy,
 }
 
 /*
- * This function sets the RF channel.
- *
- * This function creates multiple IOCTL requests, populates them accordingly
- * and issues them to set the band/channel and frequency.
- */
-static int
-mwifiex_set_rf_channel(struct mwifiex_private *priv,
-		       struct ieee80211_channel *chan,
-		       enum nl80211_channel_type channel_type)
-{
-	u32 config_bands = 0;
-	struct wiphy *wiphy = priv->wdev->wiphy;
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	if (chan) {
-		/* Set appropriate bands */
-		if (chan->band == IEEE80211_BAND_2GHZ) {
-			if (channel_type == NL80211_CHAN_NO_HT)
-				if (priv->adapter->config_bands == BAND_B ||
-				    priv->adapter->config_bands == BAND_G)
-					config_bands =
-						priv->adapter->config_bands;
-				else
-					config_bands = BAND_B | BAND_G;
-			else
-				config_bands = BAND_B | BAND_G | BAND_GN;
-		} else {
-			if (channel_type == NL80211_CHAN_NO_HT)
-				config_bands = BAND_A;
-			else
-				config_bands = BAND_AN | BAND_A;
-		}
-
-		if (!((config_bands | adapter->fw_bands) &
-						~adapter->fw_bands)) {
-			adapter->config_bands = config_bands;
-			if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-				adapter->adhoc_start_band = config_bands;
-				if ((config_bands & BAND_GN) ||
-				    (config_bands & BAND_AN))
-					adapter->adhoc_11n_enabled = true;
-				else
-					adapter->adhoc_11n_enabled = false;
-			}
-		}
-		adapter->sec_chan_offset =
-			mwifiex_cfg80211_channel_type_to_sec_chan_offset
-			(channel_type);
-		adapter->channel_type = channel_type;
-		priv->adhoc_channel =
-			ieee80211_frequency_to_channel(chan->center_freq);
-
-		mwifiex_send_domain_info_cmd_fw(wiphy);
-	}
-
-	wiphy_dbg(wiphy, "info: setting band %d, chan offset %d, mode %d\n",
-		  config_bands, adapter->sec_chan_offset, priv->bss_mode);
-
-	return 0;
-}
-
-/*
  * This function sets the fragmentation threshold.
  *
  * The fragmentation threshold value must lie between MWIFIEX_FRAG_MIN_VALUE
@@ -996,6 +933,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 {
 	struct mwifiex_uap_bss_param *bss_cfg;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	u8 config_bands = 0;
 
 	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP)
 		return -1;
@@ -1036,13 +974,25 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	    (u8)ieee80211_frequency_to_channel(params->channel->center_freq);
 	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
 
-	if (mwifiex_set_rf_channel(priv, params->channel,
-				   params->channel_type)) {
-		kfree(bss_cfg);
-		wiphy_err(wiphy, "Failed to set band config information!\n");
-		return -1;
+	/* Set appropriate bands */
+	if (params->channel->band == IEEE80211_BAND_2GHZ) {
+		if (params->channel_type == NL80211_CHAN_NO_HT)
+			config_bands = BAND_B | BAND_G;
+		else
+			config_bands = BAND_B | BAND_G | BAND_GN;
+	} else {
+		if (params->channel_type == NL80211_CHAN_NO_HT)
+			config_bands = BAND_A;
+		else
+			config_bands = BAND_AN | BAND_A;
 	}
 
+	if (!((config_bands | priv->adapter->fw_bands) &
+	      ~priv->adapter->fw_bands))
+		priv->adapter->config_bands = config_bands;
+
+	mwifiex_send_domain_info_cmd_fw(wiphy);
+
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
 		wiphy_err(wiphy, "Failed to parse secuirty parameters!\n");
@@ -1176,7 +1126,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	struct cfg80211_ssid req_ssid;
 	int ret, auth_type = 0;
 	struct cfg80211_bss *bss = NULL;
-	u8 is_scanning_required = 0;
+	u8 is_scanning_required = 0, config_bands = 0;
 
 	memset(&req_ssid, 0, sizeof(struct cfg80211_ssid));
 
@@ -1195,9 +1145,19 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* disconnect before try to associate */
 	mwifiex_deauthenticate(priv, NULL);
 
-	if (channel)
-		ret = mwifiex_set_rf_channel(priv, channel,
-						priv->adapter->channel_type);
+	if (channel) {
+		if (mode == NL80211_IFTYPE_STATION) {
+			if (channel->band == IEEE80211_BAND_2GHZ)
+				config_bands = BAND_B | BAND_G | BAND_GN;
+			else
+				config_bands = BAND_A | BAND_AN;
+
+			if (!((config_bands | priv->adapter->fw_bands) &
+			      ~priv->adapter->fw_bands))
+				priv->adapter->config_bands = config_bands;
+		}
+		mwifiex_send_domain_info_cmd_fw(priv->wdev->wiphy);
+	}
 
 	/* As this is new association, clear locally stored
 	 * keys and security related flags */
@@ -1362,6 +1322,76 @@ done:
 }
 
 /*
+ * This function sets following parameters for ibss network.
+ *  -  channel
+ *  -  start band
+ *  -  11n flag
+ *  -  secondary channel offset
+ */
+static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
+				   struct cfg80211_ibss_params *params)
+{
+	struct wiphy *wiphy = priv->wdev->wiphy;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int index = 0, i;
+	u8 config_bands = 0;
+
+	if (params->channel->band == IEEE80211_BAND_2GHZ) {
+		if (!params->basic_rates) {
+			config_bands = BAND_B | BAND_G;
+		} else {
+			for (i = 0; i < mwifiex_band_2ghz.n_bitrates; i++) {
+				/*
+				 * Rates below 6 Mbps in the table are CCK
+				 * rates; 802.11b and from 6 they are OFDM;
+				 * 802.11G
+				 */
+				if (mwifiex_rates[i].bitrate == 60) {
+					index = 1 << i;
+					break;
+				}
+			}
+
+			if (params->basic_rates < index) {
+				config_bands = BAND_B;
+			} else {
+				config_bands = BAND_G;
+				if (params->basic_rates % index)
+					config_bands |= BAND_B;
+			}
+		}
+
+		if (params->channel_type != NL80211_CHAN_NO_HT)
+			config_bands |= BAND_GN;
+	} else {
+		if (params->channel_type == NL80211_CHAN_NO_HT)
+			config_bands = BAND_A;
+		else
+			config_bands = BAND_AN | BAND_A;
+	}
+
+	if (!((config_bands | adapter->fw_bands) & ~adapter->fw_bands)) {
+		adapter->config_bands = config_bands;
+		adapter->adhoc_start_band = config_bands;
+
+		if ((config_bands & BAND_GN) || (config_bands & BAND_AN))
+			adapter->adhoc_11n_enabled = true;
+		else
+			adapter->adhoc_11n_enabled = false;
+	}
+
+	adapter->sec_chan_offset =
+		mwifiex_chan_type_to_sec_chan_offset(params->channel_type);
+	priv->adhoc_channel =
+		ieee80211_frequency_to_channel(params->channel->center_freq);
+
+	wiphy_dbg(wiphy, "info: set ibss band %d, chan %d, chan offset %d\n",
+		  config_bands, priv->adhoc_channel, adapter->sec_chan_offset);
+
+	return 0;
+}
+
+/*
  * CFG802.11 operation handler to join an IBSS.
  *
  * This function does not work in any mode other than Ad-Hoc, or if
@@ -1383,6 +1413,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
 		  (char *) params->ssid, params->bssid);
 
+	mwifiex_set_ibss_params(priv, params);
+
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
 				     params->bssid, priv->bss_mode,
 				     params->channel, NULL, params->privacy);
@@ -1808,6 +1840,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->available_antennas_tx = BIT(adapter->number_of_antenna) - 1;
 	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
 
+	wiphy->features = NL80211_FEATURE_HT_IBSS;
+
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b543a4d..21fdc6c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -344,7 +344,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->adhoc_awake_period = 0;
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
-	adapter->channel_type = NL80211_CHAN_HT20;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
 }
 
-- 
1.7.0.2

