Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbYCECKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/11] iwlwifi: extract iwl-csr.h
Date: Tue,  4 Mar 2008 18:09:28 -0800
Message-Id: <1204682972-26004-8-git-send-email-reinette.chatre@intel.com> (sfid-20080305_022345_365324_BAF6DC20)
In-Reply-To: <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch extract CSR Register definition into separate
header files as most of the definition are commons to both
3945 and 4965.

Definitions specific for 3945 and 4965 are properly prefixed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |  135 -----------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   18 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |  131 ----------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h      |  217 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 +-
 9 files changed, 236 insertions(+), 283 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-csr.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 6693767..269224b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -321,141 +321,6 @@ struct iwl3945_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/*=== CSR (control and status registers) ===*/
-#define CSR_BASE    (0x000)
-
-#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
-#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
-#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
-#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
-#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
-#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
-#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
-#define CSR_GP_CNTRL            (CSR_BASE+0x024)
-
-/*
- * Hardware revision info
- * Bit fields:
- * 31-8:  Reserved
- *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
- *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
- *  1-0:  "Dash" value, as in A-1, etc.
- */
-#define CSR_HW_REV              (CSR_BASE+0x028)
-
-/* EEPROM reads */
-#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
-#define CSR_EEPROM_GP           (CSR_BASE+0x030)
-#define CSR_GP_UCODE		(CSR_BASE+0x044)
-#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
-#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
-#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
-#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
-
-/* Analog phase-lock-loop configuration (3945 only)
- * Set bit 24. */
-#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
-
-/* Bits for CSR_HW_IF_CONFIG_REG */
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
-#define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
-#define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
-
-/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
- * acknowledged (reset) by host writing "1" to flagged bits. */
-#define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-#define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
-#define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
-#define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
-#define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
-#define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
-#define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
-#define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
-
-#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
-				 CSR_INT_BIT_HW_ERR  | \
-				 CSR_INT_BIT_FH_TX   | \
-				 CSR_INT_BIT_SW_ERR  | \
-				 CSR_INT_BIT_RF_KILL | \
-				 CSR_INT_BIT_SW_RX   | \
-				 CSR_INT_BIT_WAKEUP  | \
-				 CSR_INT_BIT_ALIVE)
-
-/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
-#define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
-#define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL2  (1 << 18) /* Rx channel 2 (3945 only) */
-#define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
-#define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL6  (1 << 6)  /* Tx channel 6 (3945 only) */
-#define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
-#define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
-
-#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR_FH_INT_BIT_RX_CHNL2 | \
-				 CSR_FH_INT_BIT_RX_CHNL1 | \
-				 CSR_FH_INT_BIT_RX_CHNL0)
-
-#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL6 | \
-				 CSR_FH_INT_BIT_TX_CHNL1 | \
-				 CSR_FH_INT_BIT_TX_CHNL0)
-
-
-/* RESET */
-#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
-#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
-#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
-#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
-#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
-
-/* GP (general purpose) CONTROL */
-#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
-#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
-#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
-
-#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
-
-#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
-#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
-
-
-/* EEPROM REG */
-#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
-#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
-
-/* EEPROM GP */
-#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
-#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
-#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
-
-/* UCODE DRV GP */
-#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
-#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
-#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
-#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
-
-/* GPIO */
-#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
-#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
-#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
-
-/* GI Chicken Bits */
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
-
-/* CSR_ANA_PLL_CFG */
-#define CSR_ANA_PLL_CFG_SH		(0x00880300)
-
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 63e832c..0fca356 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1154,19 +1154,19 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
 		IWL_DEBUG_INFO("RTP type \n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
-		IWL_DEBUG_INFO("ALM-MB type\n");
+		IWL_DEBUG_INFO("3945 RADIO-MB type\n");
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB);
+			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MB);
 	} else {
-		IWL_DEBUG_INFO("ALM-MM type\n");
+		IWL_DEBUG_INFO("3945 RADIO-MM type\n");
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM);
+			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom.sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC);
+			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
 
@@ -1174,24 +1174,24 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom.board_revision);
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
+			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom.board_revision);
 		iwl3945_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
-			      CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
+			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	}
 
 	if (priv->eeprom.almgor_m_version <= 1) {
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
+			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
 		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
 			       priv->eeprom.almgor_m_version);
 	} else {
 		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
 			       priv->eeprom.almgor_m_version);
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
+			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d281e42..1701e0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -40,8 +40,9 @@
 extern struct pci_device_id iwl3945_hw_card_ids[];
 
 #define DRV_NAME	"iwl3945"
-#include "iwl-3945-hw.h"
+#include "iwl-csr.h"
 #include "iwl-prph.h"
+#include "iwl-3945-hw.h"
 #include "iwl-3945-debug.h"
 
 /* Default noise level to report when noise measurement is not available.
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index cc72621..7e8cc99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -410,137 +410,6 @@ struct iwl4965_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/*=== CSR (control and status registers) ===*/
-#define CSR_BASE    (0x000)
-
-#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
-#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
-#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
-#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
-#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
-#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
-#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
-#define CSR_GP_CNTRL            (CSR_BASE+0x024)
-
-/*
- * Hardware revision info
- * Bit fields:
- * 31-8:  Reserved
- *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
- *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
- *  1-0:  "Dash" value, as in A-1, etc.
- *
- * NOTE:  Revision step affects calculation of CCK txpower for 4965.
- */
-#define CSR_HW_REV              (CSR_BASE+0x028)
-
-/* EEPROM reads */
-#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
-#define CSR_EEPROM_GP           (CSR_BASE+0x030)
-#define CSR_GP_UCODE		(CSR_BASE+0x044)
-#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
-#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
-#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
-#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
-
-/*
- * Indicates hardware rev, to determine CCK backoff for txpower calculation.
- * Bit fields:
- *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
- */
-#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
-
-/* Hardware interface configuration bits */
-#define CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R	(0x00000010)
-#define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
-#define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
-#define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM (0x00200000)
-
-/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
- * acknowledged (reset) by host writing "1" to flagged bits. */
-#define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-#define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
-#define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
-#define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
-#define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
-#define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
-#define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
-#define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
-
-#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
-				 CSR_INT_BIT_HW_ERR  | \
-				 CSR_INT_BIT_FH_TX   | \
-				 CSR_INT_BIT_SW_ERR  | \
-				 CSR_INT_BIT_RF_KILL | \
-				 CSR_INT_BIT_SW_RX   | \
-				 CSR_INT_BIT_WAKEUP  | \
-				 CSR_INT_BIT_ALIVE)
-
-/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
-#define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
-#define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
-#define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
-#define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
-
-#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR_FH_INT_BIT_RX_CHNL1 | \
-				 CSR_FH_INT_BIT_RX_CHNL0)
-
-#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
-				 CSR_FH_INT_BIT_TX_CHNL0)
-
-
-/* RESET */
-#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
-#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
-#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
-#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
-#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
-
-/* GP (general purpose) CONTROL */
-#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
-#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
-#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
-
-#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
-
-#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
-#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
-
-
-/* EEPROM REG */
-#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
-#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
-
-/* EEPROM GP */
-#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
-#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
-#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
-
-/* UCODE DRV GP */
-#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
-#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
-#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
-#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
-
-/* GPIO */
-#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
-#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
-#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
-
-/* GI Chicken Bits */
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
-
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 05ad5a9..2da1533 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -604,9 +604,9 @@ int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
 	/* set CSR_HW_CONFIG_REG for uCode use */
 
 	iwl4965_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R |
-			CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-			CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+			CSR49_HW_IF_CONFIG_REG_BIT_4965_R |
+			CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+			CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	rc = iwl4965_grab_nic_access(priv);
 	if (rc < 0) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 5c60512..a782c45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -41,6 +41,7 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 
 #define DRV_NAME        "iwl4965"
 #include "iwl-4965-hw.h"
+#include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-4965-debug.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
new file mode 100644
index 0000000..276ba28
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -0,0 +1,217 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+/*=== CSR (control and status registers) ===*/
+#define CSR_BASE    (0x000)
+
+#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
+#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
+#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
+#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
+#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
+#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
+#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
+#define CSR_GP_CNTRL            (CSR_BASE+0x024)
+
+/*
+ * Hardware revision info
+ * Bit fields:
+ * 31-8:  Reserved
+ *  7-4:  Type of device:  0x0 = 4965, 0xd = 3945
+ *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
+ *  1-0:  "Dash" value, as in A-1, etc.
+ *
+ * NOTE:  Revision step affects calculation of CCK txpower for 4965.
+ */
+#define CSR_HW_REV              (CSR_BASE+0x028)
+
+/* EEPROM reads */
+#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
+#define CSR_EEPROM_GP           (CSR_BASE+0x030)
+#define CSR_GP_UCODE		(CSR_BASE+0x044)
+#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
+#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
+#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
+#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
+#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
+
+/* Analog phase-lock-loop configuration (3945 only)
+ * Set bit 24. */
+#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
+/*
+ * Indicates hardware rev, to determine CCK backoff for txpower calculation.
+ * Bit fields:
+ *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
+ */
+#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
+
+/* Bits for CSR_HW_IF_CONFIG_REG */
+#define CSR49_HW_IF_CONFIG_REG_BIT_4965_R	(0x00000010)
+#define CSR49_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
+#define CSR49_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
+#define CSR49_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+
+#define CSR39_HW_IF_CONFIG_REG_BIT_3945_MB         (0x00000100)
+#define CSR39_HW_IF_CONFIG_REG_BIT_3945_MM         (0x00000200)
+#define CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
+#define CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
+#define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
+#define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
+
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
+
+/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
+ * acknowledged (reset) by host writing "1" to flagged bits. */
+#define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
+#define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
+#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
+#define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
+#define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
+#define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
+#define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
+#define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
+#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
+#define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
+
+#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
+				 CSR_INT_BIT_HW_ERR  | \
+				 CSR_INT_BIT_FH_TX   | \
+				 CSR_INT_BIT_SW_ERR  | \
+				 CSR_INT_BIT_RF_KILL | \
+				 CSR_INT_BIT_SW_RX   | \
+				 CSR_INT_BIT_WAKEUP  | \
+				 CSR_INT_BIT_ALIVE)
+
+/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
+#define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
+#define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
+#define CSR39_FH_INT_BIT_RX_CHNL2  (1 << 18) /* Rx channel 2 (3945 only) */
+#define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
+#define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
+#define CSR39_FH_INT_BIT_TX_CHNL6  (1 << 6)  /* Tx channel 6 (3945 only) */
+#define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
+#define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
+
+#define CSR39_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
+				 CSR39_FH_INT_BIT_RX_CHNL2 | \
+				 CSR_FH_INT_BIT_RX_CHNL1 | \
+				 CSR_FH_INT_BIT_RX_CHNL0)
+
+
+#define CSR39_FH_INT_TX_MASK	(CSR39_FH_INT_BIT_TX_CHNL6 | \
+				 CSR_FH_INT_BIT_TX_CHNL1 | \
+				 CSR_FH_INT_BIT_TX_CHNL0)
+
+#define CSR49_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
+				 CSR_FH_INT_BIT_RX_CHNL1 | \
+				 CSR_FH_INT_BIT_RX_CHNL0)
+
+#define CSR49_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
+				 CSR_FH_INT_BIT_TX_CHNL0)
+
+
+/* RESET */
+#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
+#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
+#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
+#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
+#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
+
+/* GP (general purpose) CONTROL */
+#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
+#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
+#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
+
+#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
+
+#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
+#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
+
+
+/* EEPROM REG */
+#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
+#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
+
+/* EEPROM GP */
+#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
+#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
+#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
+
+/* UCODE DRV GP */
+#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
+#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
+#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
+#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
+
+/* GPIO */
+#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
+#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
+#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
+
+/* GI Chicken Bits */
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7a72048..cc71bdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4570,9 +4570,9 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	 * atomic, make sure that inta covers all the interrupts that
 	 * we've discovered, even if FH interrupt came in just after
 	 * reading CSR_INT. */
-	if (inta_fh & CSR_FH_INT_RX_MASK)
+	if (inta_fh & CSR39_FH_INT_RX_MASK)
 		inta |= CSR_INT_BIT_FH_RX;
-	if (inta_fh & CSR_FH_INT_TX_MASK)
+	if (inta_fh & CSR39_FH_INT_TX_MASK)
 		inta |= CSR_INT_BIT_FH_TX;
 
 	/* Now service all interrupt bits discovered above. */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f273395..0c60f59 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4918,9 +4918,9 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	 * atomic, make sure that inta covers all the interrupts that
 	 * we've discovered, even if FH interrupt came in just after
 	 * reading CSR_INT. */
-	if (inta_fh & CSR_FH_INT_RX_MASK)
+	if (inta_fh & CSR49_FH_INT_RX_MASK)
 		inta |= CSR_INT_BIT_FH_RX;
-	if (inta_fh & CSR_FH_INT_TX_MASK)
+	if (inta_fh & CSR49_FH_INT_TX_MASK)
 		inta |= CSR_INT_BIT_FH_TX;
 
 	/* Now service all interrupt bits discovered above. */
-- 
1.5.3.4

