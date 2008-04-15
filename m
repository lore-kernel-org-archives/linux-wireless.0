Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYDOEQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/12] iwlwifi: generalize iwlwifi init flow
Date: Mon, 14 Apr 2008 21:16:03 -0700
Message-Id: <1208232974-3828-2-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051622_583700_672B33F7)
In-Reply-To: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch creates handlers to support
iwlwifi init flow for multiple HWs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  149 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   11 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  179 +++------------------------
 3 files changed, 174 insertions(+), 165 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 472ca3d..822169e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -114,6 +114,151 @@ static const u16 default_tid_to_tx_fifo[] = {
 
 #endif	/*CONFIG_IWL4965_HT */
 
+/* check contents of special bootstrap uCode SRAM */
+static int iwl4965_verify_bsm(struct iwl_priv *priv)
+{
+	__le32 *image = priv->ucode_boot.v_addr;
+	u32 len = priv->ucode_boot.len;
+	u32 reg;
+	u32 val;
+
+	IWL_DEBUG_INFO("Begin verify bsm\n");
+
+	/* verify BSM SRAM contents */
+	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
+	for (reg = BSM_SRAM_LOWER_BOUND;
+	     reg < BSM_SRAM_LOWER_BOUND + len;
+	     reg += sizeof(u32), image++) {
+		val = iwl_read_prph(priv, reg);
+		if (val != le32_to_cpu(*image)) {
+			IWL_ERROR("BSM uCode verification failed at "
+				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
+				  BSM_SRAM_LOWER_BOUND,
+				  reg - BSM_SRAM_LOWER_BOUND, len,
+				  val, le32_to_cpu(*image));
+			return -EIO;
+		}
+	}
+
+	IWL_DEBUG_INFO("BSM bootstrap uCode image OK\n");
+
+	return 0;
+}
+
+/**
+ * iwl4965_load_bsm - Load bootstrap instructions
+ *
+ * BSM operation:
+ *
+ * The Bootstrap State Machine (BSM) stores a short bootstrap uCode program
+ * in special SRAM that does not power down during RFKILL.  When powering back
+ * up after power-saving sleeps (or during initial uCode load), the BSM loads
+ * the bootstrap program into the on-board processor, and starts it.
+ *
+ * The bootstrap program loads (via DMA) instructions and data for a new
+ * program from host DRAM locations indicated by the host driver in the
+ * BSM_DRAM_* registers.  Once the new program is loaded, it starts
+ * automatically.
+ *
+ * When initializing the NIC, the host driver points the BSM to the
+ * "initialize" uCode image.  This uCode sets up some internal data, then
+ * notifies host via "initialize alive" that it is complete.
+ *
+ * The host then replaces the BSM_DRAM_* pointer values to point to the
+ * normal runtime uCode instructions and a backup uCode data cache buffer
+ * (filled initially with starting data values for the on-board processor),
+ * then triggers the "initialize" uCode to load and launch the runtime uCode,
+ * which begins normal operation.
+ *
+ * When doing a power-save shutdown, runtime uCode saves data SRAM into
+ * the backup data cache in DRAM before SRAM is powered down.
+ *
+ * When powering back up, the BSM loads the bootstrap program.  This reloads
+ * the runtime uCode instructions and the backup data cache into SRAM,
+ * and re-launches the runtime uCode from where it left off.
+ */
+static int iwl4965_load_bsm(struct iwl_priv *priv)
+{
+	__le32 *image = priv->ucode_boot.v_addr;
+	u32 len = priv->ucode_boot.len;
+	dma_addr_t pinst;
+	dma_addr_t pdata;
+	u32 inst_len;
+	u32 data_len;
+	int i;
+	u32 done;
+	u32 reg_offset;
+	int ret;
+
+	IWL_DEBUG_INFO("Begin load bsm\n");
+
+	/* make sure bootstrap program is no larger than BSM's SRAM size */
+	if (len > IWL_MAX_BSM_SIZE)
+		return -EINVAL;
+
+	/* Tell bootstrap uCode where to find the "Initialize" uCode
+	 *   in host DRAM ... host DRAM physical address bits 35:4 for 4965.
+	 * NOTE:  iwl4965_initialize_alive_start() will replace these values,
+	 *        after the "initialize" uCode has run, to point to
+	 *        runtime/protocol instructions and backup data cache. */
+	pinst = priv->ucode_init.p_addr >> 4;
+	pdata = priv->ucode_init_data.p_addr >> 4;
+	inst_len = priv->ucode_init.len;
+	data_len = priv->ucode_init_data.len;
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
+	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+
+	/* Fill BSM memory with bootstrap instructions */
+	for (reg_offset = BSM_SRAM_LOWER_BOUND;
+	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
+	     reg_offset += sizeof(u32), image++)
+		_iwl_write_prph(priv, reg_offset, le32_to_cpu(*image));
+
+	ret = iwl4965_verify_bsm(priv);
+	if (ret) {
+		iwl_release_nic_access(priv);
+		return ret;
+	}
+
+	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG, RTC_INST_LOWER_BOUND);
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+
+	/* Load bootstrap code into instruction SRAM now,
+	 *   to prepare to load "initialize" uCode */
+	iwl_write_prph(priv, BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START);
+
+	/* Wait for load of bootstrap uCode to finish */
+	for (i = 0; i < 100; i++) {
+		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
+		if (!(done & BSM_WR_CTRL_REG_BIT_START))
+			break;
+		udelay(10);
+	}
+	if (i < 100)
+		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
+	else {
+		IWL_ERROR("BSM write did not complete!\n");
+		return -EIO;
+	}
+
+	/* Enable future boot loads whenever power management unit triggers it
+	 *   (e.g. when powering back up after power-save shutdown) */
+	iwl_write_prph(priv, BSM_WR_CTRL_REG, BSM_WR_CTRL_REG_BIT_START_EN);
+
+	iwl_release_nic_access(priv);
+
+	return 0;
+}
+
 static int iwl4965_init_drv(struct iwl_priv *priv)
 {
 	int ret;
@@ -4789,6 +4934,10 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 
 static struct iwl_lib_ops iwl4965_lib = {
 	.init_drv = iwl4965_init_drv,
+	.hw_nic_init = iwl4965_hw_nic_init,
+	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
+	.alive_notify = iwl4965_alive_notify,
+	.load_ucode = iwl4965_load_bsm,
 	.eeprom_ops = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6d82376..889fdba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,9 +89,18 @@ struct iwl_hcmd_utils_ops {
 struct iwl_lib_ops {
 	/* iwlwifi driver (priv) init */
 	int (*init_drv)(struct iwl_priv *priv);
+	/* nic init */
+	int (*hw_nic_init)(struct iwl_priv *priv);
+	/* alive notification */
+	int (*alive_notify)(struct iwl_priv *priv);
+	/* check validity of rtc data address */
+	int (*is_valid_rtc_data_addr)(u32 addr);
+	/* 1st ucode load */
+	int (*load_ucode)(struct iwl_priv *priv);
+	/* rfkill */
+	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
-	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
 };
 
 struct iwl_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 06e44da..ecc9cba 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4305,7 +4305,7 @@ static void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 
 	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
-	if (!iwl4965_hw_valid_rtc_data_addr(base)) {
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
@@ -4400,7 +4400,7 @@ static void iwl4965_dump_nic_event_log(struct iwl_priv *priv)
 	u32 size;       /* # entries that we'll print */
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (!iwl4965_hw_valid_rtc_data_addr(base)) {
+	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
@@ -5175,156 +5175,6 @@ static int iwl4965_verify_ucode(struct iwl_priv *priv)
 	return rc;
 }
 
-
-/* check contents of special bootstrap uCode SRAM */
-static int iwl4965_verify_bsm(struct iwl_priv *priv)
-{
-	__le32 *image = priv->ucode_boot.v_addr;
-	u32 len = priv->ucode_boot.len;
-	u32 reg;
-	u32 val;
-
-	IWL_DEBUG_INFO("Begin verify bsm\n");
-
-	/* verify BSM SRAM contents */
-	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
-	for (reg = BSM_SRAM_LOWER_BOUND;
-	     reg < BSM_SRAM_LOWER_BOUND + len;
-	     reg += sizeof(u32), image ++) {
-		val = iwl_read_prph(priv, reg);
-		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("BSM uCode verification failed at "
-				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
-				  BSM_SRAM_LOWER_BOUND,
-				  reg - BSM_SRAM_LOWER_BOUND, len,
-				  val, le32_to_cpu(*image));
-			return -EIO;
-		}
-	}
-
-	IWL_DEBUG_INFO("BSM bootstrap uCode image OK\n");
-
-	return 0;
-}
-
-/**
- * iwl4965_load_bsm - Load bootstrap instructions
- *
- * BSM operation:
- *
- * The Bootstrap State Machine (BSM) stores a short bootstrap uCode program
- * in special SRAM that does not power down during RFKILL.  When powering back
- * up after power-saving sleeps (or during initial uCode load), the BSM loads
- * the bootstrap program into the on-board processor, and starts it.
- *
- * The bootstrap program loads (via DMA) instructions and data for a new
- * program from host DRAM locations indicated by the host driver in the
- * BSM_DRAM_* registers.  Once the new program is loaded, it starts
- * automatically.
- *
- * When initializing the NIC, the host driver points the BSM to the
- * "initialize" uCode image.  This uCode sets up some internal data, then
- * notifies host via "initialize alive" that it is complete.
- *
- * The host then replaces the BSM_DRAM_* pointer values to point to the
- * normal runtime uCode instructions and a backup uCode data cache buffer
- * (filled initially with starting data values for the on-board processor),
- * then triggers the "initialize" uCode to load and launch the runtime uCode,
- * which begins normal operation.
- *
- * When doing a power-save shutdown, runtime uCode saves data SRAM into
- * the backup data cache in DRAM before SRAM is powered down.
- *
- * When powering back up, the BSM loads the bootstrap program.  This reloads
- * the runtime uCode instructions and the backup data cache into SRAM,
- * and re-launches the runtime uCode from where it left off.
- */
-static int iwl4965_load_bsm(struct iwl_priv *priv)
-{
-	__le32 *image = priv->ucode_boot.v_addr;
-	u32 len = priv->ucode_boot.len;
-	dma_addr_t pinst;
-	dma_addr_t pdata;
-	u32 inst_len;
-	u32 data_len;
-	int rc;
-	int i;
-	u32 done;
-	u32 reg_offset;
-
-	IWL_DEBUG_INFO("Begin load bsm\n");
-
-	/* make sure bootstrap program is no larger than BSM's SRAM size */
-	if (len > IWL_MAX_BSM_SIZE)
-		return -EINVAL;
-
-	/* Tell bootstrap uCode where to find the "Initialize" uCode
-	 *   in host DRAM ... host DRAM physical address bits 35:4 for 4965.
-	 * NOTE:  iwl4965_initialize_alive_start() will replace these values,
-	 *        after the "initialize" uCode has run, to point to
-	 *        runtime/protocol instructions and backup data cache. */
-	pinst = priv->ucode_init.p_addr >> 4;
-	pdata = priv->ucode_init_data.p_addr >> 4;
-	inst_len = priv->ucode_init.len;
-	data_len = priv->ucode_init_data.len;
-
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
-	iwl_write_prph(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_prph(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
-
-	/* Fill BSM memory with bootstrap instructions */
-	for (reg_offset = BSM_SRAM_LOWER_BOUND;
-	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
-	     reg_offset += sizeof(u32), image++)
-		_iwl_write_prph(priv, reg_offset,
-					  le32_to_cpu(*image));
-
-	rc = iwl4965_verify_bsm(priv);
-	if (rc) {
-		iwl_release_nic_access(priv);
-		return rc;
-	}
-
-	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
-				 RTC_INST_LOWER_BOUND);
-	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
-
-	/* Load bootstrap code into instruction SRAM now,
-	 *   to prepare to load "initialize" uCode */
-	iwl_write_prph(priv, BSM_WR_CTRL_REG,
-		BSM_WR_CTRL_REG_BIT_START);
-
-	/* Wait for load of bootstrap uCode to finish */
-	for (i = 0; i < 100; i++) {
-		done = iwl_read_prph(priv, BSM_WR_CTRL_REG);
-		if (!(done & BSM_WR_CTRL_REG_BIT_START))
-			break;
-		udelay(10);
-	}
-	if (i < 100)
-		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
-	else {
-		IWL_ERROR("BSM write did not complete!\n");
-		return -EIO;
-	}
-
-	/* Enable future boot loads whenever power management unit triggers it
-	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl_write_prph(priv, BSM_WR_CTRL_REG,
-		BSM_WR_CTRL_REG_BIT_START_EN);
-
-	iwl_release_nic_access(priv);
-
-	return 0;
-}
-
 static void iwl4965_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
@@ -5634,7 +5484,7 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
  */
 static void iwl4965_alive_start(struct iwl_priv *priv)
 {
-	int rc = 0;
+	int ret = 0;
 
 	IWL_DEBUG_INFO("Runtime Alive received.\n");
 
@@ -5657,10 +5507,10 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 
 	iwlcore_clear_stations_table(priv);
 
-	rc = iwl4965_alive_notify(priv);
-	if (rc) {
+	ret = priv->cfg->ops->lib->alive_notify(priv);
+	if (ret) {
 		IWL_WARNING("Could not complete ALIVE transition [ntf]: %d\n",
-			    rc);
+			    ret);
 		goto restart;
 	}
 
@@ -5835,7 +5685,8 @@ static void iwl4965_down(struct iwl_priv *priv)
 
 static int __iwl4965_up(struct iwl_priv *priv)
 {
-	int rc, i;
+	int i;
+	int ret;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARNING("Exit pending; will not bring the NIC up\n");
@@ -5870,10 +5721,10 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	iwl_rfkill_set_hw_state(priv);
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	rc = iwl4965_hw_nic_init(priv);
-	if (rc) {
-		IWL_ERROR("Unable to int nic\n");
-		return rc;
+	ret = priv->cfg->ops->lib->hw_nic_init(priv);
+	if (ret) {
+		IWL_ERROR("Unable to init nic\n");
+		return ret;
 	}
 
 	/* make sure rfkill handshake bits are cleared */
@@ -5906,10 +5757,10 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		rc = iwl4965_load_bsm(priv);
+		ret = priv->cfg->ops->lib->load_ucode(priv);
 
-		if (rc) {
-			IWL_ERROR("Unable to set up bootstrap uCode: %d\n", rc);
+		if (ret) {
+			IWL_ERROR("Unable to set up bootstrap uCode: %d\n", ret);
 			continue;
 		}
 
-- 
1.5.3.4

