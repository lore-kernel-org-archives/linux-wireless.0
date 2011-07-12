Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40421 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1GLC7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 22:59:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add cfg80211 handler for set_bitrate_mask
Date: Mon, 11 Jul 2011 20:04:44 -0700
Message-Id: <1310439884-26523-1-git-send-email-bzhao@marvell.com> (sfid-20110712_045916_766618_55CCD0D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Currently, setting only legacy bitrates on 2.4GHz band
are supported. Mode 802.11b/g/bg is enabled based on
bitrates selection. If only CCK bitrates selected then
802.11b mode is enabled. If only OFDM bitrates are
selected then 802.11g mode is enabled. For both: CCK
and OFDM rates 802.11bg mixed mode is enabled.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   54 +++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4487d93..352d2c5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -672,6 +672,59 @@ static const u32 mwifiex_cipher_suites[] = {
 };
 
 /*
+ * CFG802.11 operation handler for setting bit rates.
+ *
+ * Function selects legacy bang B/G/BG from corresponding bitrates selection.
+ * Currently only 2.4GHz band is supported.
+ */
+static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
+				struct net_device *dev,
+				const u8 *peer,
+				const struct cfg80211_bitrate_mask *mask)
+{
+	struct mwifiex_ds_band_cfg band_cfg;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int index = 0, mode = 0, i;
+
+	/* Currently only 2.4GHz is supported */
+	for (i = 0; i < mwifiex_band_2ghz.n_bitrates; i++) {
+		/*
+		 * Rates below 6 Mbps in the table are CCK rates; 802.11b
+		 * and from 6 they are OFDM; 802.11G
+		 */
+		if (mwifiex_rates[i].bitrate == 60) {
+			index = 1 << i;
+			break;
+		}
+	}
+
+	if (mask->control[IEEE80211_BAND_2GHZ].legacy < index) {
+		mode = BAND_B;
+	} else {
+		mode = BAND_G;
+		if (mask->control[IEEE80211_BAND_2GHZ].legacy % index)
+			mode |=  BAND_B;
+	}
+
+	memset(&band_cfg, 0, sizeof(band_cfg));
+	band_cfg.config_bands = mode;
+
+	if (priv->bss_mode == NL80211_IFTYPE_ADHOC)
+		band_cfg.adhoc_start_band = mode;
+
+	band_cfg.sec_chan_offset = NO_SEC_CHANNEL;
+
+	if (mwifiex_set_radio_band_cfg(priv, &band_cfg))
+		return -EFAULT;
+
+	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
+				(mode & BAND_B) ? "b" : "",
+				(mode & BAND_G) ? "g" : "");
+
+	return 0;
+}
+
+/*
  * CFG802.11 operation handler for disconnection request.
  *
  * This function does not work when there is already a disconnection
@@ -1225,6 +1278,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_default_key = mwifiex_cfg80211_set_default_key,
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
+	.set_bitrate_mask = mwifiex_cfg80211_set_bitrate_mask,
 };
 
 /*
-- 
1.7.0.2

