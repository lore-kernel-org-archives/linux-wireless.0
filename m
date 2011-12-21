Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57703 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752593Ab1LUHr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 02:47:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: remove redundant band config code
Date: Tue, 20 Dec 2011 23:47:20 -0800
Message-Id: <1324453642-1920-1-git-send-email-bzhao@marvell.com> (sfid-20111221_084730_508141_5F8D746E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

struct mwifiex_ds_band_cfg and mwifiex_set_radio_band_cfg() routine
are unnecessary. It can be done with simple equivalant code.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   49 ++++++++++++------------
 drivers/net/wireless/mwifiex/ioctl.h     |    7 ---
 drivers/net/wireless/mwifiex/main.h      |    2 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |   61 ------------------------------
 4 files changed, 24 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 787dbe2..64bf640 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -331,37 +331,38 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		       enum nl80211_channel_type channel_type)
 {
 	struct mwifiex_chan_freq_power cfp;
-	struct mwifiex_ds_band_cfg band_cfg;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (chan) {
-		memset(&band_cfg, 0, sizeof(band_cfg));
 		/* Set appropriate bands */
 		if (chan->band == IEEE80211_BAND_2GHZ)
 			config_bands = BAND_B | BAND_G | BAND_GN;
 		else
 			config_bands = BAND_AN | BAND_A;
-		if (priv->bss_mode == NL80211_IFTYPE_STATION
-		    || priv->bss_mode == NL80211_IFTYPE_UNSPECIFIED) {
-			band_cfg.config_bands = config_bands;
-		} else if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-			band_cfg.config_bands = config_bands;
-			band_cfg.adhoc_start_band = config_bands;
-		}
 
-		band_cfg.sec_chan_offset =
+		if (!((config_bands | adapter->fw_bands) &
+						~adapter->fw_bands)) {
+			adapter->config_bands = config_bands;
+			if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
+				adapter->adhoc_start_band = config_bands;
+				if ((config_bands & BAND_GN) ||
+						(config_bands & BAND_AN))
+					adapter->adhoc_11n_enabled = true;
+				else
+					adapter->adhoc_11n_enabled = false;
+			}
+		}
+		adapter->chan_offset =
 			mwifiex_cfg80211_channel_type_to_mwifiex_channels
 			(channel_type);
 
-		if (mwifiex_set_radio_band_cfg(priv, &band_cfg))
-			return -EFAULT;
-
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
 	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
-		"mode %d\n", config_bands, band_cfg.sec_chan_offset,
+		"mode %d\n", config_bands, adapter->chan_offset,
 		priv->bss_mode);
 	if (!chan)
 		return 0;
@@ -697,9 +698,9 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 				const u8 *peer,
 				const struct cfg80211_bitrate_mask *mask)
 {
-	struct mwifiex_ds_band_cfg band_cfg;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int index = 0, mode = 0, i;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	/* Currently only 2.4GHz is supported */
 	for (i = 0; i < mwifiex_band_2ghz.n_bitrates; i++) {
@@ -721,16 +722,14 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 			mode |=  BAND_B;
 	}
 
-	memset(&band_cfg, 0, sizeof(band_cfg));
-	band_cfg.config_bands = mode;
-
-	if (priv->bss_mode == NL80211_IFTYPE_ADHOC)
-		band_cfg.adhoc_start_band = mode;
-
-	band_cfg.sec_chan_offset = NO_SEC_CHANNEL;
-
-	if (mwifiex_set_radio_band_cfg(priv, &band_cfg))
-		return -EFAULT;
+	if (!((mode | adapter->fw_bands) & ~adapter->fw_bands)) {
+		adapter->config_bands = mode;
+		if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
+			adapter->adhoc_start_band = mode;
+			adapter->adhoc_11n_enabled = false;
+		}
+	}
+	adapter->chan_offset = NO_SEC_CHANNEL;
 
 	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
 				(mode & BAND_B) ? "b" : "",
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index e0b68e7..eb76b7b 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -66,13 +66,6 @@ enum {
 #define SEC_CHANNEL_ABOVE            1
 #define SEC_CHANNEL_BELOW            3
 
-struct mwifiex_ds_band_cfg {
-	u32 config_bands;
-	u32 adhoc_start_band;
-	u32 adhoc_channel;
-	u32 sec_chan_offset;
-};
-
 enum {
 	ADHOC_IDLE,
 	ADHOC_STARTED,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9207fc6..d659650 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -954,8 +954,6 @@ int mwifiex_main_process(struct mwifiex_adapter *);
 
 int mwifiex_bss_set_channel(struct mwifiex_private *,
 			    struct mwifiex_chan_freq_power *cfp);
-int mwifiex_set_radio_band_cfg(struct mwifiex_private *,
-			 struct mwifiex_ds_band_cfg *);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 6d990c7..e40196d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -472,67 +472,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 }
 
 /*
- * The function sets band configurations.
- *
- * it performs extra checks to make sure the Ad-Hoc
- * band and channel are compatible. Otherwise it returns an error.
- *
- */
-int mwifiex_set_radio_band_cfg(struct mwifiex_private *priv,
-			       struct mwifiex_ds_band_cfg *radio_cfg)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 infra_band, adhoc_band;
-	u32 adhoc_channel;
-
-	infra_band = (u8) radio_cfg->config_bands;
-	adhoc_band = (u8) radio_cfg->adhoc_start_band;
-	adhoc_channel = radio_cfg->adhoc_channel;
-
-	/* SET Infra band */
-	if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands)
-		return -1;
-
-	adapter->config_bands = infra_band;
-
-	/* SET Ad-hoc Band */
-	if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands)
-		return -1;
-
-	if (adhoc_band)
-		adapter->adhoc_start_band = adhoc_band;
-	adapter->chan_offset = (u8) radio_cfg->sec_chan_offset;
-	/*
-	 * If no adhoc_channel is supplied verify if the existing adhoc
-	 * channel compiles with new adhoc_band
-	 */
-	if (!adhoc_channel) {
-		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-		     (priv, adapter->adhoc_start_band,
-		     priv->adhoc_channel)) {
-			/* Pass back the default channel */
-			radio_cfg->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
-			if ((adapter->adhoc_start_band & BAND_A)
-			    || (adapter->adhoc_start_band & BAND_AN))
-				radio_cfg->adhoc_channel =
-					DEFAULT_AD_HOC_CHANNEL_A;
-		}
-	} else {	/* Retrurn error if adhoc_band and
-			   adhoc_channel combination is invalid */
-		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-		    (priv, adapter->adhoc_start_band, (u16) adhoc_channel))
-			return -1;
-		priv->adhoc_channel = (u8) adhoc_channel;
-	}
-	if ((adhoc_band & BAND_GN) || (adhoc_band & BAND_AN))
-		adapter->adhoc_11n_enabled = true;
-	else
-		adapter->adhoc_11n_enabled = false;
-
-	return 0;
-}
-
-/*
  * The function disables auto deep sleep mode.
  */
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
-- 
1.7.0.2

