Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:58465 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3KSUwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:20 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so6084863wes.24
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:19 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/7] iwlwifi: pcie: refactor a bit the interrupt coalescing
Date: Tue, 19 Nov 2013 22:52:01 +0200
Message-Id: <1384894326-24676-2-git-send-email-egrumbach@gmail.com> (sfid-20131119_215225_160684_352711B9)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We changed the timeout for the interrupt coealescing for
calibration, but that wasn't effective since we changed
that value back before loading the firmware. Since
calibrations are notification from firmware and not Rx
packets, this doesn't change anyway - the firmware will
fire an interrupt straight away regardless of the interrupt
coalescing value.
Also, a HW issue has been discovered in 7000 devices series.
The work around is to disable the new interrupt coalescing
timeout feature - do this by setting bit 31 in
CSR_INT_COALESCING.
This has been fixed in 7265 which means that we can't rely
on the device family and must have a hint in the iwl_cfg
structure.

Cc: stable@vger.kernel.org [3.10+]
Fixes: 99cd47142399 ("iwlwifi: add 7000 series device configuration")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |    3 +++
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    5 +----
 drivers/net/wireless/iwlwifi/pcie/rx.c    |    4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c |    3 ---
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 85879db..2ea4b11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -130,6 +130,7 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
@@ -140,6 +141,7 @@ const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.high_temp = true,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7260_2n_cfg = {
@@ -149,6 +151,7 @@ const struct iwl_cfg iwl7260_2n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7260_n_cfg = {
@@ -158,6 +161,7 @@ const struct iwl_cfg iwl7260_n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_2ac_cfg = {
@@ -167,6 +171,7 @@ const struct iwl_cfg iwl3160_2ac_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_2n_cfg = {
@@ -176,6 +181,7 @@ const struct iwl_cfg iwl3160_2n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl3160_n_cfg = {
@@ -185,6 +191,7 @@ const struct iwl_cfg iwl3160_n_cfg = {
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
 	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+	.host_interrupt_operation_mode = true,
 };
 
 const struct iwl_cfg iwl7265_2ac_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 18f232e..6801c7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -207,6 +207,8 @@ struct iwl_eeprom_params {
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
  * @high_temp: Is this NIC is designated to be in high temperature.
+ * @host_interrupt_operation_mode: device needs host interrupt operation
+ *	mode set
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -235,6 +237,7 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
+	const bool host_interrupt_operation_mode;
 	bool high_temp;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 54a4fdc..da4eca8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -495,14 +495,11 @@ enum secure_load_status_reg {
  * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
  *
  * default interrupt coalescing timer is 64 x 32 = 2048 usecs
- * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
  */
 #define IWL_HOST_INT_TIMEOUT_MAX	(0xFF)
 #define IWL_HOST_INT_TIMEOUT_DEF	(0x40)
 #define IWL_HOST_INT_TIMEOUT_MIN	(0x0)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
-#define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
+#define IWL_HOST_INT_OPER_MODE		BIT(31)
 
 /*****************************************************************************
  *                        7000/3000 series SHR DTS addresses                 *
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 3f237b4..83d28bc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -489,6 +489,10 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+
+	/* W/A for interrupt coalescing bug in 7260 and 3160 */
+	if (trans->cfg->host_interrupt_operation_mode)
+		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
 static void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5d9337b..cde9c16 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -279,9 +279,6 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_pcie_apm_init(trans);
 
-	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
-
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	iwl_pcie_set_pwr(trans, false);
-- 
1.7.9.5

