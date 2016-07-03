Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60822 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbcGCTtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:47 +0300
Message-Id: <1467575332-32112-8-git-send-email-luca@coelho.fi> (sfid-20160703_214922_239408_520D7662)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 08/13] iwlwifi: pcie: workaround HW shadow registers bug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Integrated 9000 devices have a bug with shadow registers
value retention.
If driver writes RBD registers while MAC is asleep the
values are stored in shadow registers to be copied whenever
MAC wakes up.
However, in 9000 devices a MAC wakeup is not triggered
and when the bus powers down due to inactivity the shadow
values and dirty bits are lost.
Turn on the chicken-bits that cause MAC wakeup for RX-related
values as well when the device is in D0.
When the device is in low power mode turn the RX wakeup chicken
bits off since driver is idle and this W/A is not needed.
Remove previous W/A which was ineffective.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  4 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  6 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 27 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  4 ++++
 6 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 3ac298f..5c1e71f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -178,6 +178,7 @@ const struct iwl_cfg iwl5165_2ac_cfg = {
 		.nvm_ver = IWL9000_NVM_VERSION,
 		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+		.integrated = true,
 };
 
 MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 4a0af7d..57b14f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -319,6 +319,7 @@ struct iwl_pwr_tx_backoff {
  * @mq_rx_supported: multi-queue rx support
  * @vht_mu_mimo_supported: VHT MU-MIMO support
  * @rf_id: need to read rf_id to determine the firmware image
+ * @integrated: discrete or integrated
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -362,7 +363,8 @@ struct iwl_cfg {
 	    apmg_not_supported:1,
 	    mq_rx_supported:1,
 	    vht_mu_mimo_supported:1,
-	    rf_id:1;
+	    rf_id:1,
+	    integrated:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index b5291344..871ad02 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -145,8 +145,10 @@
 
 #define CSR_LED_REG             (CSR_BASE+0x094)
 #define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
-#define CSR_MAC_SHADOW_REG_CTRL	(CSR_BASE+0x0A8) /* 6000 and up */
-
+#define CSR_MAC_SHADOW_REG_CTRL		(CSR_BASE + 0x0A8) /* 6000 and up */
+#define CSR_MAC_SHADOW_REG_CTRL_RX_WAKE	BIT(20)
+#define CSR_MAC_SHADOW_REG_CTL2		(CSR_BASE + 0x0AC)
+#define CSR_MAC_SHADOW_REG_CTL2_RX_WAKE	0xFFFF
 
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index de6974f..482836e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -673,4 +673,6 @@ static inline int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans);
 int iwl_pci_fw_enter_d0i3(struct iwl_trans *trans);
 
+void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable);
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 0a4a3c5..f1e309d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -211,12 +211,8 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	if (trans->cfg->mq_rx_supported)
 		iwl_write32(trans, RFH_Q_FRBDCB_WIDX_TRG(rxq->id),
 			    rxq->write_actual);
-	/*
-	 * write to FH_RSCSR_CHNL0_WPTR register even in MQ as a W/A to
-	 * hardware shadow registers bug - writing to RFH_Q_FRBDCB_WIDX will
-	 * not wake the NIC.
-	 */
-	iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
+	else
+		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 }
 
 static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
@@ -764,6 +760,23 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
+void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable)
+{
+	/*
+	 * Turn on the chicken-bits that cause MAC wakeup for RX-related
+	 * values.
+	 * This costs some power, but needed for W/A 9000 integrated A-step
+	 * bug where shadow registers are not in the retention list and their
+	 * value is lost when NIC powers down
+	 */
+	if (trans->cfg->integrated) {
+		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
+			    CSR_MAC_SHADOW_REG_CTRL_RX_WAKE);
+		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTL2,
+			    CSR_MAC_SHADOW_REG_CTL2_RX_WAKE);
+	}
+}
+
 static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -849,6 +862,8 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+
+	iwl_pcie_enable_rx_wake(trans, true);
 }
 
 static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f603d78..33fd217 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1286,6 +1286,8 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test,
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
+	iwl_pcie_enable_rx_wake(trans, false);
+
 	if (reset) {
 		/*
 		 * reset TX queues -- some of their registers reset during S3
@@ -1311,6 +1313,8 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return 0;
 	}
 
+	iwl_pcie_enable_rx_wake(trans, true);
+
 	/*
 	 * Also enables interrupts - none will happen as the device doesn't
 	 * know we're waking it up, only when the opmode actually tells it
-- 
2.8.1

