Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0KJSBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/16] iwlagn: enabel shadow register
Date: Wed, 10 Nov 2010 09:56:50 -0800
Message-Id: <1289411810-23093-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 6000 series devices and up, enable automatic update MAC's register
for better power usage in PSP mode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    3 ++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 +++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-csr.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   45 +++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   49 ++++++++++++++++-----------
 6 files changed, 69 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 21ac281..c7ff1bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -487,6 +487,7 @@ static struct iwl_base_params iwl6000_base_params = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.shadow_reg_enable = true,
 };
 
 static struct iwl_base_params iwl6050_base_params = {
@@ -510,6 +511,7 @@ static struct iwl_base_params iwl6050_base_params = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.shadow_reg_enable = true,
 };
 static struct iwl_base_params iwl6000_coex_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
@@ -532,6 +534,7 @@ static struct iwl_base_params iwl6000_coex_base_params = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.shadow_reg_enable = true,
 };
 
 static struct iwl_ht_params iwl6000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 740591f..42e7eee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -750,6 +750,12 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	} else
 		iwlagn_txq_ctx_reset(priv);
 
+	if (priv->cfg->base_params->shadow_reg_enable) {
+		/* enable shadow regs in HW */
+		iwl_set_bit(priv, CSR_MAC_SHADOW_REG_CTRL,
+			0x800FFFFF);
+	}
+
 	set_bit(STATUS_INIT, &priv->status);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8f3cc23..d604826 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -290,6 +290,7 @@ struct iwl_mod_params {
  *	sensitivity calibration operation
  * @chain_noise_calib_by_driver: driver has the capability to perform
  *	chain noise calibration operation
+ * @shadow_reg_enable: HW shadhow register bit
 */
 struct iwl_base_params {
 	int eeprom_size;
@@ -320,6 +321,7 @@ struct iwl_base_params {
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
+	const bool shadow_reg_enable;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 2aa15ab..b80bf7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -132,6 +132,8 @@
 
 #define CSR_LED_REG             (CSR_BASE+0x094)
 #define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
+#define CSR_MAC_SHADOW_REG_CTRL	(CSR_BASE+0x0A8) /* 6000 and up */
+
 
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index baca4cc..87a6fd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -134,28 +134,37 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 	if (q->need_update == 0)
 		goto exit_unlock;
 
-	/* If power-saving is in use, make sure device is awake */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO(priv, "Rx queue requesting wakeup, GP1 = 0x%x\n",
-				      reg);
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			goto exit_unlock;
-		}
-
-		q->write_actual = (q->write & ~0x7);
-		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write_actual);
-
-	/* Else device is assumed to be awake */
-	} else {
+	if (priv->cfg->base_params->shadow_reg_enable) {
+		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
 		iwl_write32(priv, rx_wrt_ptr_reg, q->write_actual);
-	}
+	} else {
+		/* If power-saving is in use, make sure device is awake */
+		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+
+			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+				IWL_DEBUG_INFO(priv,
+					"Rx queue requesting wakeup,"
+					" GP1 = 0x%x\n", reg);
+				iwl_set_bit(priv, CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+				goto exit_unlock;
+			}
 
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(priv, rx_wrt_ptr_reg,
+					q->write_actual);
+
+		/* Else device is assumed to be awake */
+		} else {
+			/* Device expects a multiple of 8 */
+			q->write_actual = (q->write & ~0x7);
+			iwl_write_direct32(priv, rx_wrt_ptr_reg,
+				q->write_actual);
+		}
+	}
 	q->need_update = 0;
 
  exit_unlock:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7261ee4..feaa367 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -49,30 +49,39 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	if (txq->need_update == 0)
 		return;
 
-	/* if we're trying to save power */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		/* wake up nic if it's powered down ...
-		 * uCode will wake up, and interrupt us again, so next
-		 * time we'll skip this part. */
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO(priv, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
-				      txq_id, reg);
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			return;
-		}
-
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
-				     txq->q.write_ptr | (txq_id << 8));
-
-	/* else not in power-save mode, uCode will never sleep when we're
-	 * trying to tx (during RFKILL, we're not trying to tx). */
-	} else
+	if (priv->cfg->base_params->shadow_reg_enable) {
+		/* shadow register enabled */
 		iwl_write32(priv, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
+	} else {
+		/* if we're trying to save power */
+		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+			/* wake up nic if it's powered down ...
+			 * uCode will wake up, and interrupt us again, so next
+			 * time we'll skip this part. */
+			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+
+			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+				IWL_DEBUG_INFO(priv,
+					"Tx queue %d requesting wakeup,"
+					" GP1 = 0x%x\n", txq_id, reg);
+				iwl_set_bit(priv, CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+				return;
+			}
+
+			iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+				     txq->q.write_ptr | (txq_id << 8));
 
+		/*
+		 * else not in power-save mode,
+		 * uCode will never sleep when we're
+		 * trying to tx (during RFKILL, we're not trying to tx).
+		 */
+		} else
+			iwl_write32(priv, HBUS_TARG_WRPTR,
+				    txq->q.write_ptr | (txq_id << 8));
+	}
 	txq->need_update = 0;
 }
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
-- 
1.7.0.4

