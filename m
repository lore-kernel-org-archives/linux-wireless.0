Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbYEWCLw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: setup correctly L1 L0S pi link values
Date: Fri, 23 May 2008 10:09:15 +0800
Message-Id: <1211508569-3163-38-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_900805_57BF5CA4)
In-Reply-To: <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch setups L1 L0S pci link values.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   18 ++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   19 ++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-csr.h     |    6 +++++-
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ee55b28..fc11833 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -100,9 +100,14 @@
 
 #include "iwl-commands.h"
 
-#define PCI_LINK_CTRL      0x0F0
+/* PCI registers */
+#define PCI_LINK_CTRL      0x0F0	/* 1 byte */
 #define PCI_POWER_SOURCE   0x0C8
 #define PCI_REG_WUM8       0x0E8
+
+/* PCI register values */
+#define PCI_LINK_VAL_L0S_EN	0x01
+#define PCI_LINK_VAL_L1_EN	0x02
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
 #define TFD_QUEUE_SIZE_MAX      (256)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 547287c..02d3dc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -500,6 +500,10 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
+	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+
 	/* set "initialization complete" bit to move adapter
 	 * D0U* --> D0A* state */
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
@@ -518,11 +522,12 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 		goto out;
 
 	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_CTRL_REG,
-			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
+	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
+						APMG_CLK_VAL_BSM_CLK_RQT);
 
 	udelay(20);
 
+	/* disable L1-Active */
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
@@ -550,8 +555,13 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 
 	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
 
-	/* disable L1 entry -- workaround for pre-B1 */
-	pci_write_config_byte(priv->pci_dev, PCI_LINK_CTRL, val_link & ~0x02);
+	/* L1 is enabled by BIOS */
+	if ((val_link & PCI_LINK_VAL_L1_EN) == PCI_LINK_VAL_L1_EN)
+		/* diable L0S disabled L1A enabled */
+		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
+	else
+		/* L0S enabled L1A disabled */
+		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0355ccd..b1c5045 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -63,6 +63,10 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
+	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+
 	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	/* set "initialization complete" bit to move adapter
@@ -83,13 +87,13 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 		return ret;
 
 	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_EN_REG,
-			APMG_CLK_VAL_DMA_CLK_RQT);
+	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 
 	udelay(20);
 
+	/* disable L1-Active */
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 	iwl_release_nic_access(priv);
 
@@ -106,8 +110,13 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 
 	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
 
-	/* disable L1 entry -- workaround for pre-B1 */
-	pci_write_config_byte(priv->pci_dev, PCI_LINK_CTRL, val_link & ~0x02);
+	/* L1 is enabled by BIOS */
+	if ((val_link & PCI_LINK_VAL_L1_EN) == PCI_LINK_VAL_L1_EN)
+		/* diable L0S disabled L1A enabled */
+		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
+	else
+		/* L0S enabled L1A disabled */
+		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 9d6e5d2..545ed69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -87,13 +87,14 @@
 /* EEPROM reads */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
+#define CSR_GIO_REG		(CSR_BASE+0x03C)
 #define CSR_GP_UCODE		(CSR_BASE+0x044)
 #define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
 #define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 #define CSR_LED_REG             (CSR_BASE+0x094)
+#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
 /* Analog phase-lock-loop configuration  */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
@@ -213,6 +214,9 @@
 #define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
 #define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
 
+/* CSR GIO */
+#define CSR_GIO_REG_VAL_L0S_ENABLED	(0x00000002)
+
 /* UCODE DRV GP */
 #define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
 #define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
-- 
1.5.3.6

