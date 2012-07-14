Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50287 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757268Ab2GNDMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 23:12:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: improvement in cfg80211 set_bitrate_mask handler
Date: Fri, 13 Jul 2012 20:09:33 -0700
Message-Id: <1342235373-27613-5-git-send-email-bzhao@marvell.com> (sfid-20120714_051242_274189_518CA868)
In-Reply-To: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
References: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch configures data rates to firmware using bitrate mask
provided by cfg80211.

Earlier we used to only update band information in this handler
which will be used later for ibss network. Due to recent
modifications in ibss join code we don't need to do that.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   61 ++++++++++++++-----------------
 drivers/net/wireless/mwifiex/main.h     |    1 -
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ed3b8b2..657841d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -753,8 +753,8 @@ static const u32 mwifiex_cipher_suites[] = {
 /*
  * CFG802.11 operation handler for setting bit rates.
  *
- * Function selects legacy bang B/G/BG from corresponding bitrates selection.
- * Currently only 2.4GHz band is supported.
+ * Function configures data rates to firmware using bitrate mask
+ * provided by cfg80211.
  */
 static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 				struct net_device *dev,
@@ -762,43 +762,36 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 				const struct cfg80211_bitrate_mask *mask)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int index = 0, mode = 0, i;
-	struct mwifiex_adapter *adapter = priv->adapter;
+	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
+	enum ieee80211_band band;
 
-	/* Currently only 2.4GHz is supported */
-	for (i = 0; i < mwifiex_band_2ghz.n_bitrates; i++) {
-		/*
-		 * Rates below 6 Mbps in the table are CCK rates; 802.11b
-		 * and from 6 they are OFDM; 802.11G
-		 */
-		if (mwifiex_rates[i].bitrate == 60) {
-			index = 1 << i;
-			break;
-		}
+	if (!priv->media_connected) {
+		dev_err(priv->adapter->dev,
+			"Can not set Tx data rate in disconnected state\n");
+		return -EINVAL;
 	}
 
-	if (mask->control[IEEE80211_BAND_2GHZ].legacy < index) {
-		mode = BAND_B;
-	} else {
-		mode = BAND_G;
-		if (mask->control[IEEE80211_BAND_2GHZ].legacy % index)
-			mode |=  BAND_B;
-	}
+	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 
-	if (!((mode | adapter->fw_bands) & ~adapter->fw_bands)) {
-		adapter->config_bands = mode;
-		if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-			adapter->adhoc_start_band = mode;
-			adapter->adhoc_11n_enabled = false;
-		}
-	}
-	adapter->sec_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-	adapter->channel_type = NL80211_CHAN_NO_HT;
+	memset(bitmap_rates, 0, sizeof(bitmap_rates));
 
-	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
-		    (mode & BAND_B) ? "b" : "", (mode & BAND_G) ? "g" : "");
+	/* Fill HR/DSSS rates. */
+	if (band == IEEE80211_BAND_2GHZ)
+		bitmap_rates[0] = mask->control[band].legacy & 0x000f;
 
-	return 0;
+	/* Fill OFDM rates */
+	if (band == IEEE80211_BAND_2GHZ)
+		bitmap_rates[1] = (mask->control[band].legacy & 0x0ff0) >> 4;
+	else
+		bitmap_rates[1] = mask->control[band].legacy;
+
+	/* Fill MCS rates */
+	bitmap_rates[2] = mask->control[band].mcs[0];
+	if (priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2)
+		bitmap_rates[2] |= mask->control[band].mcs[1] << 8;
+
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
+				     HostCmd_ACT_GEN_SET, 0, bitmap_rates);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 34705f5..e7c2a82 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -678,7 +678,6 @@ struct mwifiex_adapter {
 	u8 hw_dev_mcs_support;
 	u8 adhoc_11n_enabled;
 	u8 sec_chan_offset;
-	enum nl80211_channel_type channel_type;
 	struct mwifiex_dbg dbg;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
-- 
1.7.0.2

