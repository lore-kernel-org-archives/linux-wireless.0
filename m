Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab1CYObj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/12] iwlagn: remove reference to 3945 and 4965
Date: Fri, 25 Mar 2011 07:14:15 -0700
Message-Id: <1301062456-17249-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, remove the unused reference to 3945 and 4965

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   39 +++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-csr.h    |   39 ++++++-----------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    2 -
 3 files changed, 23 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bd980a2..9251c68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -409,7 +409,7 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
  * Tell nic where to find circular buffer of Tx Frame Descriptors for
  * given Tx queue, and enable the DMA channel used for that queue.
  *
- * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
+ * supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
  * channels supported in hardware.
  */
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
@@ -986,7 +986,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 			iwl_write32(priv, CSR_FH_INT_STATUS,
-					CSR49_FH_INT_RX_MASK);
+					CSR_FH_INT_RX_MASK);
 		}
 		if (inta & CSR_INT_BIT_RX_PERIODIC) {
 			handled |= CSR_INT_BIT_RX_PERIODIC;
@@ -1024,7 +1024,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(priv, CSR_FH_INT_STATUS, CSR49_FH_INT_TX_MASK);
+		iwl_write32(priv, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
 		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
 		priv->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
@@ -1259,28 +1259,19 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 
 	switch (api_ver) {
 	default:
-		/*
-		 * 4965 doesn't revision the firmware file format
-		 * along with the API version, it always uses v1
-		 * file format.
-		 */
-		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) !=
-				CSR_HW_REV_TYPE_4965) {
-			hdr_size = 28;
-			if (ucode_raw->size < hdr_size) {
-				IWL_ERR(priv, "File size too small!\n");
-				return -EINVAL;
-			}
-			pieces->build = le32_to_cpu(ucode->u.v2.build);
-			pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
-			pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
-			pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
-			pieces->init_data_size = le32_to_cpu(ucode->u.v2.init_data_size);
-			pieces->boot_size = le32_to_cpu(ucode->u.v2.boot_size);
-			src = ucode->u.v2.data;
-			break;
+		hdr_size = 28;
+		if (ucode_raw->size < hdr_size) {
+			IWL_ERR(priv, "File size too small!\n");
+			return -EINVAL;
 		}
-		/* fall through for 4965 */
+		pieces->build = le32_to_cpu(ucode->u.v2.build);
+		pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
+		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
+		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
+		pieces->init_data_size = le32_to_cpu(ucode->u.v2.init_data_size);
+		pieces->boot_size = le32_to_cpu(ucode->u.v2.boot_size);
+		src = ucode->u.v2.data;
+		break;
 	case 0:
 	case 1:
 	case 2:
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index f52bc04..1123319 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -155,18 +155,10 @@
 #define CSR_DBG_LINK_PWR_MGMT_REG	(CSR_BASE+0x250)
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
-#define CSR49_HW_IF_CONFIG_REG_BIT_4965_R	(0x00000010)
 #define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
 #define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI 	(0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
 
-#define CSR39_HW_IF_CONFIG_REG_BIT_3945_MB         (0x00000100)
-#define CSR39_HW_IF_CONFIG_REG_BIT_3945_MM         (0x00000200)
-#define CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
-#define CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
-#define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
-#define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
-
 #define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A	(0x00080000)
 #define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM	(0x00200000)
 #define CSR_HW_IF_CONFIG_REG_BIT_NIC_READY	(0x00400000) /* PCI_OWN_SEM */
@@ -186,7 +178,7 @@
 #define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
 #define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
 #define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses */
 #define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
 #define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
 
@@ -202,29 +194,17 @@
 /* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
 #define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
 #define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
-#define CSR39_FH_INT_BIT_RX_CHNL2  (1 << 18) /* Rx channel 2 (3945 only) */
 #define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
 #define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
-#define CSR39_FH_INT_BIT_TX_CHNL6  (1 << 6)  /* Tx channel 6 (3945 only) */
 #define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
 #define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
 
-#define CSR39_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR39_FH_INT_BIT_RX_CHNL2 | \
-				 CSR_FH_INT_BIT_RX_CHNL1 | \
-				 CSR_FH_INT_BIT_RX_CHNL0)
-
-
-#define CSR39_FH_INT_TX_MASK	(CSR39_FH_INT_BIT_TX_CHNL6 | \
-				 CSR_FH_INT_BIT_TX_CHNL1 | \
-				 CSR_FH_INT_BIT_TX_CHNL0)
-
-#define CSR49_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR_FH_INT_BIT_RX_CHNL1 | \
-				 CSR_FH_INT_BIT_RX_CHNL0)
+#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
+				CSR_FH_INT_BIT_RX_CHNL1 | \
+				CSR_FH_INT_BIT_RX_CHNL0)
 
-#define CSR49_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
-				 CSR_FH_INT_BIT_TX_CHNL0)
+#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
+				CSR_FH_INT_BIT_TX_CHNL0)
 
 /* GPIO */
 #define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
@@ -268,7 +248,7 @@
  *         Indicates MAC (ucode processor, etc.) is powered up and can run.
  *         Internal resources are accessible.
  *         NOTE:  This does not indicate that the processor is actually running.
- *         NOTE:  This does not indicate that 4965 or 3945 has completed
+ *         NOTE:  This does not indicate that device has completed
  *                init or post-power-down restore of internal SRAM memory.
  *                Use CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP as indication that
  *                SRAM is restored and uCode is in normal operation mode.
@@ -291,8 +271,6 @@
 
 /* HW REV */
 #define CSR_HW_REV_TYPE_MSK            (0x00001F0)
-#define CSR_HW_REV_TYPE_3945           (0x00000D0)
-#define CSR_HW_REV_TYPE_4965           (0x0000000)
 #define CSR_HW_REV_TYPE_5300           (0x0000020)
 #define CSR_HW_REV_TYPE_5350           (0x0000030)
 #define CSR_HW_REV_TYPE_5100           (0x0000050)
@@ -363,7 +341,7 @@
  *     0:  MAC_SLEEP
  *         uCode sets this when preparing a power-saving power-down.
  *         uCode resets this when power-up is complete and SRAM is sane.
- *         NOTE:  3945/4965 saves internal SRAM data to host when powering down,
+ *         NOTE:  device saves internal SRAM data to host when powering down,
  *                and must restore this data after powering back up.
  *                MAC_SLEEP is the best indication that restore is complete.
  *                Later devices (5xxx/6xxx/1xxx) use non-volatile SRAM, and
@@ -394,7 +372,6 @@
 #define CSR_LED_REG_TRUN_OFF (0x38)
 
 /* ANA_PLL */
-#define CSR39_ANA_PLL_CFG_VAL        (0x01000000)
 #define CSR50_ANA_PLL_CFG_VAL        (0x00880300)
 
 /* HPET MEM debug */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 833194a..c831a0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -198,8 +198,6 @@ static int iwlcore_get_nvm_type(struct iwl_priv *priv)
 	case CSR_HW_REV_TYPE_NONE:
 		IWL_ERR(priv, "Unknown hardware type\n");
 		return -ENOENT;
-	case CSR_HW_REV_TYPE_3945:
-	case CSR_HW_REV_TYPE_4965:
 	case CSR_HW_REV_TYPE_5300:
 	case CSR_HW_REV_TYPE_5350:
 	case CSR_HW_REV_TYPE_5100:
-- 
1.7.0.4

