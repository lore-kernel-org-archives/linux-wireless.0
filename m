Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:55055 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaBLTFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:08 -0500
Received: by mail-we0-f170.google.com with SMTP id w62so6489307wes.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:05 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 6/9] wcn36xx: Add support for 3680
Date: Wed, 12 Feb 2014 19:04:45 +0000
Message-Id: <1392231888-2191-6-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200523_979738_5526AFAD)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

3680 has a few registers on other addresses.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c     | 10 +++++++++-
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  4 ++--
 drivers/net/wireless/ath/wcn36xx/main.c    | 28 +++++++++++++++++++++-------
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  4 ++++
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index ee25786..73f12f1 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -44,6 +44,14 @@ static void wcn36xx_dxe_write_register(struct wcn36xx *wcn, int addr, int data)
 	writel(data, wcn->mmio + addr);
 }
 
+#define wcn36xx_dxe_write_register_x(wcn, reg, reg_data)		 \
+do {									 \
+	if (wcn->chip_version == WCN36XX_CHIP_3680)			 \
+		wcn36xx_dxe_write_register(wcn, reg ## _3680, reg_data); \
+	else								 \
+		wcn36xx_dxe_write_register(wcn, reg ## _3660, reg_data); \
+} while (0)								 \
+
 static void wcn36xx_dxe_read_register(struct wcn36xx *wcn, int addr, int *data)
 {
 	*data = readl(wcn->mmio + addr);
@@ -680,7 +688,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 
 	/* Setting interrupt path */
 	reg_data = WCN36XX_DXE_CCU_INT;
-	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_REG_CCU_INT, reg_data);
+	wcn36xx_dxe_write_register_x(wcn, WCN36XX_DXE_REG_CCU_INT, reg_data);
 
 	/***************************************/
 	/* Init descriptors for TX LOW channel */
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index c88562f..35ee7e9 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -28,11 +28,11 @@ H2H_TEST_RX_TX = DMA2
 */
 
 /* DXE registers */
-#define WCN36XX_DXE_MEM_BASE			0x03000000
 #define WCN36XX_DXE_MEM_REG			0x202000
 
 #define WCN36XX_DXE_CCU_INT			0xA0011
-#define WCN36XX_DXE_REG_CCU_INT			0x200b10
+#define WCN36XX_DXE_REG_CCU_INT_3660		0x200b10
+#define WCN36XX_DXE_REG_CCU_INT_3680		0x2050dc
 
 /* TODO This must calculated properly but not hardcoded */
 #define WCN36XX_DXE_CTRL_TX_L			0x328a44
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 95fd5c6..dca21ee 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -221,6 +221,17 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
 	}
 }
 
+static void wcn36xx_detect_chip_version(struct wcn36xx *wcn)
+{
+	if (get_feat_caps(wcn->fw_feat_caps, DOT11AC)) {
+		wcn36xx_info("Chip is 3680\n");
+		wcn->chip_version = WCN36XX_CHIP_3680;
+	} else {
+		wcn36xx_info("Chip is 3660\n");
+		wcn->chip_version = WCN36XX_CHIP_3660;
+	}
+}
+
 static int wcn36xx_start(struct ieee80211_hw *hw)
 {
 	struct wcn36xx *wcn = hw->priv;
@@ -267,6 +278,16 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 		goto out_free_smd_buf;
 	}
 
+	if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
+		ret = wcn36xx_smd_feature_caps_exchange(wcn);
+		if (ret)
+			wcn36xx_warn("Exchange feature caps failed\n");
+		else
+			wcn36xx_feat_caps_info(wcn);
+	}
+
+	wcn36xx_detect_chip_version(wcn);
+
 	/* DMA channel initialization */
 	ret = wcn36xx_dxe_init(wcn);
 	if (ret) {
@@ -276,13 +297,6 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 
 	wcn36xx_debugfs_init(wcn);
 
-	if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
-		ret = wcn36xx_smd_feature_caps_exchange(wcn);
-		if (ret)
-			wcn36xx_warn("Exchange feature caps failed\n");
-		else
-			wcn36xx_feat_caps_info(wcn);
-	}
 	INIT_LIST_HEAD(&wcn->vif_list);
 	return 0;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 0c5413f..b4dc85b 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -178,6 +178,7 @@ struct wcn36xx {
 	u8			fw_minor;
 	u8			fw_major;
 	u32			fw_feat_caps[WCN36XX_HAL_CAPS_SIZE];
+	u32			chip_version;
 
 	/* extra byte for the NULL termination */
 	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
@@ -225,6 +226,9 @@ struct wcn36xx {
 
 };
 
+#define WCN36XX_CHIP_3660	0
+#define WCN36XX_CHIP_3680	1
+
 static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
 					 u8 major,
 					 u8 minor,
-- 
1.8.3.2

