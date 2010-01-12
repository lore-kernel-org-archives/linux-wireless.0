Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58838 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0ALMse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:48:34 -0500
Date: Tue, 12 Jan 2010 13:48:32 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/17] mwl8k: add 5 GHz band channels and rates
Message-ID: <20100112124832.GX1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a17111f..13dded4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -144,6 +144,9 @@ struct mwl8k_priv {
 	struct ieee80211_supported_band band_24;
 	struct ieee80211_channel channels_24[14];
 	struct ieee80211_rate rates_24[14];
+	struct ieee80211_supported_band band_50;
+	struct ieee80211_channel channels_50[4];
+	struct ieee80211_rate rates_50[9];
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -252,6 +255,25 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 	{ .bitrate = 720, .hw_value = 144, },
 };
 
+static const struct ieee80211_channel mwl8k_channels_50[] = {
+	{ .center_freq = 5180, .hw_value = 36, },
+	{ .center_freq = 5200, .hw_value = 40, },
+	{ .center_freq = 5220, .hw_value = 44, },
+	{ .center_freq = 5240, .hw_value = 48, },
+};
+
+static const struct ieee80211_rate mwl8k_rates_50[] = {
+	{ .bitrate = 60, .hw_value = 12, },
+	{ .bitrate = 90, .hw_value = 18, },
+	{ .bitrate = 120, .hw_value = 24, },
+	{ .bitrate = 180, .hw_value = 36, },
+	{ .bitrate = 240, .hw_value = 48, },
+	{ .bitrate = 360, .hw_value = 72, },
+	{ .bitrate = 480, .hw_value = 96, },
+	{ .bitrate = 540, .hw_value = 108, },
+	{ .bitrate = 720, .hw_value = 144, },
+};
+
 /* Set or get info from Firmware */
 #define MWL8K_CMD_SET			0x0001
 #define MWL8K_CMD_GET			0x0000
@@ -1579,6 +1601,25 @@ static void mwl8k_setup_2ghz_band(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
 }
 
+static void mwl8k_setup_5ghz_band(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	BUILD_BUG_ON(sizeof(priv->channels_50) != sizeof(mwl8k_channels_50));
+	memcpy(priv->channels_50, mwl8k_channels_50, sizeof(mwl8k_channels_50));
+
+	BUILD_BUG_ON(sizeof(priv->rates_50) != sizeof(mwl8k_rates_50));
+	memcpy(priv->rates_50, mwl8k_rates_50, sizeof(mwl8k_rates_50));
+
+	priv->band_50.band = IEEE80211_BAND_5GHZ;
+	priv->band_50.channels = priv->channels_50;
+	priv->band_50.n_channels = ARRAY_SIZE(mwl8k_channels_50);
+	priv->band_50.bitrates = priv->rates_50;
+	priv->band_50.n_bitrates = ARRAY_SIZE(mwl8k_rates_50);
+
+	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->band_50;
+}
+
 /*
  * CMD_GET_HW_SPEC (STA version).
  */
-- 
1.5.6.4
