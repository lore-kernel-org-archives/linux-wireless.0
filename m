Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35913 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbcFTGTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 02:19:55 -0400
Received: by mail-pa0-f46.google.com with SMTP id wo6so11346331pac.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2016 23:19:55 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/6] wcn36xx: Correct DXE chip version differentiation
Date: Sun, 19 Jun 2016 23:19:46 -0700
Message-Id: <1466403588-7041-4-git-send-email-bjorn.andersson@linaro.org> (sfid-20160620_082025_063794_C1E7176F)
In-Reply-To: <1466403588-7041-1-git-send-email-bjorn.andersson@linaro.org>
References: <1466403588-7041-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CCU block in WCNSS is configured for appropriate routing of
interrupts from the DXE to the application cpu, this is not dependant on
the iris version (wcn3660 vs wcn3680), but rather if the SoC has a riva
or pronto built in.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c     | 11 ++++++-----
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  5 ++---
 drivers/net/wireless/ath/wcn36xx/main.c    | 16 ++--------------
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  5 +----
 4 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index a8ff45400982..231fd022f0f5 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -702,12 +702,13 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	reg_data = WCN36XX_DXE_REG_RESET;
 	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_REG_CSR_RESET, reg_data);
 
-	/* Setting interrupt path */
-	reg_data = WCN36XX_DXE_CCU_INT;
-	if (wcn->chip_version == WCN36XX_CHIP_3680)
-		wcn36xx_ccu_write_register(wcn, WCN36XX_DXE_REG_CCU_INT_3680, reg_data);
+	/* Select channels for rx avail and xfer done interrupts... */
+	reg_data = (WCN36XX_DXE_INT_CH3_MASK | WCN36XX_DXE_INT_CH1_MASK) << 16 |
+		    WCN36XX_DXE_INT_CH0_MASK | WCN36XX_DXE_INT_CH4_MASK;
+	if (wcn->is_pronto)
+		wcn36xx_ccu_write_register(wcn, WCN36XX_CCU_DXE_INT_SELECT_PRONTO, reg_data);
 	else
-		wcn36xx_ccu_write_register(wcn, WCN36XX_DXE_REG_CCU_INT_3660, reg_data);
+		wcn36xx_ccu_write_register(wcn, WCN36XX_CCU_DXE_INT_SELECT_RIVA, reg_data);
 
 	/***************************************/
 	/* Init descriptors for TX LOW channel */
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index 012b59f4f91b..c012e807753b 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -30,9 +30,8 @@ H2H_TEST_RX_TX = DMA2
 /* DXE registers */
 #define WCN36XX_DXE_MEM_REG			0
 
-#define WCN36XX_DXE_CCU_INT			0xA0011
-#define WCN36XX_DXE_REG_CCU_INT_3660		0x310
-#define WCN36XX_DXE_REG_CCU_INT_3680		0x10dc
+#define WCN36XX_CCU_DXE_INT_SELECT_RIVA		0x310
+#define WCN36XX_CCU_DXE_INT_SELECT_PRONTO	0x10dc
 
 /* TODO This must calculated properly but not hardcoded */
 #define WCN36XX_DXE_CTRL_TX_L			0x328a44
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 8146eeba4458..e1d59da2ad20 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -261,17 +261,6 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
 	}
 }
 
-static void wcn36xx_detect_chip_version(struct wcn36xx *wcn)
-{
-	if (get_feat_caps(wcn->fw_feat_caps, DOT11AC)) {
-		wcn36xx_info("Chip is 3680\n");
-		wcn->chip_version = WCN36XX_CHIP_3680;
-	} else {
-		wcn36xx_info("Chip is 3660\n");
-		wcn->chip_version = WCN36XX_CHIP_3660;
-	}
-}
-
 static int wcn36xx_start(struct ieee80211_hw *hw)
 {
 	struct wcn36xx *wcn = hw->priv;
@@ -326,9 +315,6 @@ static int wcn36xx_start(struct ieee80211_hw *hw)
 			wcn36xx_feat_caps_info(wcn);
 	}
 
-	wcn36xx_detect_chip_version(wcn);
-	wcn36xx_smd_update_cfg(wcn, WCN36XX_HAL_CFG_ENABLE_MC_ADDR_LIST, 1);
-
 	/* DMA channel initialization */
 	ret = wcn36xx_dxe_init(wcn);
 	if (ret) {
@@ -1095,6 +1081,8 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 		return -EINVAL;
 	}
 
+	wcn->is_pronto = !!of_device_is_compatible(mmio_node, "qcom,pronto");
+
 	/* Map the CCU memory */
 	index = of_property_match_string(mmio_node, "reg-names", "ccu");
 	wcn->ccu_base = of_iomap(mmio_node, index);
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 845f2446a1b5..22242d18e1fe 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -193,7 +193,7 @@ struct wcn36xx {
 	u8			fw_minor;
 	u8			fw_major;
 	u32			fw_feat_caps[WCN36XX_HAL_CAPS_SIZE];
-	u32			chip_version;
+	bool			is_pronto;
 
 	/* extra byte for the NULL termination */
 	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
@@ -242,9 +242,6 @@ struct wcn36xx {
 
 };
 
-#define WCN36XX_CHIP_3660	0
-#define WCN36XX_CHIP_3680	1
-
 static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
 					 u8 major,
 					 u8 minor,
-- 
2.5.0

