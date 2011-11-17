Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42374 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754659Ab1KQElK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 23:41:10 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tristan Xu <xurf@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support for Marvell sd8797 device
Date: Wed, 16 Nov 2011 20:40:35 -0800
Message-Id: <1321504835-11172-1-git-send-email-bzhao@marvell.com> (sfid-20111117_054128_433758_D75C6670)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch supports Marvell chipset 88W8797 (Avastar) with
SDIO interface.

The corresponding firmware image file is located at:
"mrvl/sd8797_uapsta.bin"

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Tristan Xu <xurf@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/Kconfig       |    4 +-
 drivers/net/wireless/mwifiex/cfp.c         |   38 +++++++++++++++++++---------
 drivers/net/wireless/mwifiex/fw.h          |    1 +
 drivers/net/wireless/mwifiex/main.h        |    3 +-
 drivers/net/wireless/mwifiex/sdio.c        |   17 +++++++++++-
 drivers/net/wireless/mwifiex/sdio.h        |    1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    4 +-
 8 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 8f2797a..2a078ce 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -10,12 +10,12 @@ config MWIFIEX
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8787"
+	tristate "Marvell WiFi-Ex Driver for SD8787/SD8797"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8787 chipset with SDIO interface.
+	  8787/8797 chipsets with SDIO interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index f2e6de0..1782a77 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -75,18 +75,32 @@ static u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
  * This function maps an index in supported rates table into
  * the corresponding data rate.
  */
-u32 mwifiex_index_to_data_rate(u8 index, u8 ht_info)
+u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
+							u8 ht_info)
 {
-	u16 mcs_rate[4][8] = {
-		{0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e}
-	,			/* LG 40M */
-	{0x1e, 0x3c, 0x5a, 0x78, 0xb4, 0xf0, 0x10e, 0x12c}
-	,			/* SG 40M */
-	{0x0d, 0x1a, 0x27, 0x34, 0x4e, 0x68, 0x75, 0x82}
-	,			/* LG 20M */
-	{0x0e, 0x1c, 0x2b, 0x39, 0x56, 0x73, 0x82, 0x90}
-	};			/* SG 20M */
-
+	/*
+	 * For every mcs_rate line, the first 8 bytes are for stream 1x1,
+	 * and all 16 bytes are for stream 2x2.
+	 */
+	u16  mcs_rate[4][16] = {
+		/* LGI 40M */
+		{ 0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e,
+		  0x36, 0x6c, 0xa2, 0xd8, 0x144, 0x1b0, 0x1e6, 0x21c },
+
+		/* SGI 40M */
+		{ 0x1e, 0x3c, 0x5a, 0x78, 0xb4, 0xf0, 0x10e, 0x12c,
+		  0x3c, 0x78, 0xb4, 0xf0, 0x168, 0x1e0, 0x21c, 0x258 },
+
+		/* LGI 20M */
+		{ 0x0d, 0x1a, 0x27, 0x34, 0x4e, 0x68, 0x75, 0x82,
+		  0x1a, 0x34, 0x4e, 0x68, 0x9c, 0xd0, 0xea, 0x104 },
+
+		/* SGI 20M */
+		{ 0x0e, 0x1c, 0x2b, 0x39, 0x56, 0x73, 0x82, 0x90,
+		  0x1c, 0x39, 0x56, 0x73, 0xad, 0xe7, 0x104, 0x120 }
+	};
+	u32 mcs_num_supp =
+		(priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2) ? 16 : 8;
 	u32 rate;
 
 	if (ht_info & BIT(0)) {
@@ -95,7 +109,7 @@ u32 mwifiex_index_to_data_rate(u8 index, u8 ht_info)
 				rate = 0x0D;	/* MCS 32 SGI rate */
 			else
 				rate = 0x0C;	/* MCS 32 LGI rate */
-		} else if (index < 8) {
+		} else if (index < mcs_num_supp) {
 			if (ht_info & BIT(1)) {
 				if (ht_info & BIT(2))
 					/* SGI, 40M */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 35cb29c..62b8639 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -165,6 +165,7 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
 #define SETHT_MCS32(x) (x[4] |= 1)
+#define HT_STREAM_2X2	0x22
 
 #define SET_SECONDARYCHAN(RadioType, SECCHAN) (RadioType |= (SECCHAN << 4))
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 30f138b..3861a61 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -775,7 +775,8 @@ struct mwifiex_chan_freq_power *
 struct mwifiex_chan_freq_power *mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
 						struct mwifiex_private *priv,
 						u8 band, u32 freq);
-u32 mwifiex_index_to_data_rate(u8 index, u8 ht_info);
+u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
+							u8 ht_info);
 u32 mwifiex_find_freq_from_band_chan(u8, u8);
 int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
 				u8 **buffer);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index ffaf3f3..702452b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -256,10 +256,13 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 /* Device ID for SD8787 */
 #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
+/* Device ID for SD8797 */
+#define SDIO_DEVICE_ID_MARVELL_8797   (0x9129)
 
 /* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8797)},
 	{},
 };
 
@@ -1573,7 +1576,16 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	sdio_set_drvdata(func, card);
 
 	adapter->dev = &func->dev;
-	strcpy(adapter->fw_name, SD8787_DEFAULT_FW_NAME);
+
+	switch (func->device) {
+	case SDIO_DEVICE_ID_MARVELL_8797:
+		strcpy(adapter->fw_name, SD8797_DEFAULT_FW_NAME);
+		break;
+	case SDIO_DEVICE_ID_MARVELL_8787:
+	default:
+		strcpy(adapter->fw_name, SD8787_DEFAULT_FW_NAME);
+		break;
+	}
 
 	return 0;
 
@@ -1774,4 +1786,5 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell WiFi-Ex SDIO Driver version " SDIO_VERSION);
 MODULE_VERSION(SDIO_VERSION);
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
+MODULE_FIRMWARE(SD8787_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 3f71180..a3fb322 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -29,6 +29,7 @@
 #include "main.h"
 
 #define SD8787_DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
+#define SD8797_DEFAULT_FW_NAME "mrvl/sd8797_uapsta.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 7a16b0c..e812db8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -508,7 +508,7 @@ static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 	priv->tx_htinfo = resp->params.tx_rate.ht_info;
 	if (!priv->is_data_rate_auto)
 		priv->data_rate =
-			mwifiex_index_to_data_rate(priv->tx_rate,
+			mwifiex_index_to_data_rate(priv, priv->tx_rate,
 						   priv->tx_htinfo);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index ea4a29b..4b6f553 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -832,8 +832,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 
 	if (!ret) {
 		if (rate->is_rate_auto)
-			rate->rate = mwifiex_index_to_data_rate(priv->tx_rate,
-							priv->tx_htinfo);
+			rate->rate = mwifiex_index_to_data_rate(priv,
+					priv->tx_rate, priv->tx_htinfo);
 		else
 			rate->rate = priv->data_rate;
 	} else {
-- 
1.7.0.2

