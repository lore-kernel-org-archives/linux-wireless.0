Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51253 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752331Ab1LUHrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 02:47:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix issues in band configuration code
Date: Tue, 20 Dec 2011 23:47:22 -0800
Message-Id: <1324453642-1920-3-git-send-email-bzhao@marvell.com> (sfid-20111221_084741_520627_4881ED20)
In-Reply-To: <1324453642-1920-1-git-send-email-bzhao@marvell.com>
References: <1324453642-1920-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently due to following issues in the code even if device is
configured in B only, G only or BG mode using iw bitrates command,
ibss is getting created in BGN mode.

1) mwifiex_channels_to_cfg80211_channel_type() routine gives channel
type as NL80211_CHAN_HT20 for non-HT channel as well, because driver
doesn't store HT information provided by stack for the channel.
This issue is fixed by maintaining channel type information in
'adapter->channel_type'.
2) Band configuration is unnecessarily overwritten with BGN/AN while
setting channel.

This patch makes sure that "adapter->config_bands" correctly gets
modified while setting channel.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   49 ++++++++++++-------------------
 drivers/net/wireless/mwifiex/main.h     |    1 +
 2 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0723f61..c3b6c46 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -48,30 +48,6 @@ mwifiex_cfg80211_channel_type_to_sec_chan_offset(enum nl80211_channel_type
 }
 
 /*
- * This function maps the driver channel type into nl802.11 channel type.
- *
- * The mapping is as follows -
- *      IEEE80211_HT_PARAM_CHA_SEC_NONE    -> NL80211_CHAN_HT20
- *      IEEE80211_HT_PARAM_CHA_SEC_ABOVE   -> NL80211_CHAN_HT40PLUS
- *      IEEE80211_HT_PARAM_CHA_SEC_BELOW   -> NL80211_CHAN_HT40MINUS
- *      Others                             -> NL80211_CHAN_HT20
- */
-static enum nl80211_channel_type
-mwifiex_channels_to_cfg80211_channel_type(int channel_type)
-{
-	switch (channel_type) {
-	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		return NL80211_CHAN_HT20;
-	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		return NL80211_CHAN_HT40PLUS;
-	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		return NL80211_CHAN_HT40MINUS;
-	default:
-		return NL80211_CHAN_HT20;
-	}
-}
-
-/*
  * This function checks whether WEP is set.
  */
 static int
@@ -337,10 +313,22 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 
 	if (chan) {
 		/* Set appropriate bands */
-		if (chan->band == IEEE80211_BAND_2GHZ)
-			config_bands = BAND_B | BAND_G | BAND_GN;
-		else
-			config_bands = BAND_AN | BAND_A;
+		if (chan->band == IEEE80211_BAND_2GHZ) {
+			if (channel_type == NL80211_CHAN_NO_HT)
+				if (priv->adapter->config_bands == BAND_B ||
+					  priv->adapter->config_bands == BAND_G)
+					config_bands =
+						priv->adapter->config_bands;
+				else
+					config_bands = BAND_B | BAND_G;
+			else
+				config_bands = BAND_B | BAND_G | BAND_GN;
+		} else {
+			if (channel_type == NL80211_CHAN_NO_HT)
+				config_bands = BAND_A;
+			else
+				config_bands = BAND_AN | BAND_A;
+		}
 
 		if (!((config_bands | adapter->fw_bands) &
 						~adapter->fw_bands)) {
@@ -357,6 +345,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		adapter->sec_chan_offset =
 			mwifiex_cfg80211_channel_type_to_sec_chan_offset
 			(channel_type);
+		adapter->channel_type = channel_type;
 
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
@@ -730,6 +719,7 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 		}
 	}
 	adapter->sec_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	adapter->channel_type = NL80211_CHAN_NO_HT;
 
 	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
 				(mode & BAND_B) ? "b" : "",
@@ -849,8 +839,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 
 	if (channel)
 		ret = mwifiex_set_rf_channel(priv, channel,
-				mwifiex_channels_to_cfg80211_channel_type
-				(priv->adapter->sec_chan_offset));
+						priv->adapter->channel_type);
 
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2287643..3186aa4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -641,6 +641,7 @@ struct mwifiex_adapter {
 	u8 hw_dev_mcs_support;
 	u8 adhoc_11n_enabled;
 	u8 sec_chan_offset;
+	enum nl80211_channel_type channel_type;
 	struct mwifiex_dbg dbg;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
-- 
1.7.0.2

