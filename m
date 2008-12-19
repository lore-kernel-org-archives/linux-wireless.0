Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYLSCpj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:39 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 37/43] iwl3945: add load ucode op
Date: Fri, 19 Dec 2008 10:37:37 +0800
Message-Id: <1229654263-21454-38-git-send-email-yi.zhu@intel.com> (sfid-20081219_034629_320031_6BCCFE91)
In-Reply-To: <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch adds 3945 iwl_lib_ops->load_ucode to the driver.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  159 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  152 +-------------------------
 2 files changed, 160 insertions(+), 151 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 84f8612..433be63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2507,12 +2507,170 @@ void iwl3945_hw_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->thermal_periodic);
 }
 
+/* check contents of special bootstrap uCode SRAM */
+static int iwl3945_verify_bsm(struct iwl_priv *priv)
+ {
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
+			IWL_ERR(priv, "BSM uCode verification failed at "
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
+ /**
+  * iwl3945_load_bsm - Load bootstrap instructions
+  *
+  * BSM operation:
+  *
+  * The Bootstrap State Machine (BSM) stores a short bootstrap uCode program
+  * in special SRAM that does not power down during RFKILL.  When powering back
+  * up after power-saving sleeps (or during initial uCode load), the BSM loads
+  * the bootstrap program into the on-board processor, and starts it.
+  *
+  * The bootstrap program loads (via DMA) instructions and data for a new
+  * program from host DRAM locations indicated by the host driver in the
+  * BSM_DRAM_* registers.  Once the new program is loaded, it starts
+  * automatically.
+  *
+  * When initializing the NIC, the host driver points the BSM to the
+  * "initialize" uCode image.  This uCode sets up some internal data, then
+  * notifies host via "initialize alive" that it is complete.
+  *
+  * The host then replaces the BSM_DRAM_* pointer values to point to the
+  * normal runtime uCode instructions and a backup uCode data cache buffer
+  * (filled initially with starting data values for the on-board processor),
+  * then triggers the "initialize" uCode to load and launch the runtime uCode,
+  * which begins normal operation.
+  *
+  * When doing a power-save shutdown, runtime uCode saves data SRAM into
+  * the backup data cache in DRAM before SRAM is powered down.
+  *
+  * When powering back up, the BSM loads the bootstrap program.  This reloads
+  * the runtime uCode instructions and the backup data cache into SRAM,
+  * and re-launches the runtime uCode from where it left off.
+  */
+static int iwl3945_load_bsm(struct iwl_priv *priv)
+{
+	__le32 *image = priv->ucode_boot.v_addr;
+	u32 len = priv->ucode_boot.len;
+	dma_addr_t pinst;
+	dma_addr_t pdata;
+	u32 inst_len;
+	u32 data_len;
+	int rc;
+	int i;
+	u32 done;
+	u32 reg_offset;
+
+	IWL_DEBUG_INFO("Begin load bsm\n");
+
+	/* make sure bootstrap program is no larger than BSM's SRAM size */
+	if (len > IWL39_MAX_BSM_SIZE)
+		return -EINVAL;
+
+	/* Tell bootstrap uCode where to find the "Initialize" uCode
+	*   in host DRAM ... host DRAM physical address bits 31:0 for 3945.
+	* NOTE:  iwl3945_initialize_alive_start() will replace these values,
+	*        after the "initialize" uCode has run, to point to
+	*        runtime/protocol instructions and backup data cache. */
+	pinst = priv->ucode_init.p_addr;
+	pdata = priv->ucode_init_data.p_addr;
+	inst_len = priv->ucode_init.len;
+	data_len = priv->ucode_init_data.len;
+
+	rc = iwl_grab_nic_access(priv);
+	if (rc)
+		return rc;
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
+		_iwl_write_prph(priv, reg_offset,
+					  le32_to_cpu(*image));
+
+	rc = iwl3945_verify_bsm(priv);
+	if (rc) {
+		iwl_release_nic_access(priv);
+		return rc;
+	}
+
+	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
+	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
+				 IWL39_RTC_INST_LOWER_BOUND);
+	iwl_write_prph(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+
+	/* Load bootstrap code into instruction SRAM now,
+	 *   to prepare to load "initialize" uCode */
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
+		BSM_WR_CTRL_REG_BIT_START);
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
+		IWL_ERR(priv, "BSM write did not complete!\n");
+		return -EIO;
+	}
+
+	/* Enable future boot loads whenever power management unit triggers it
+	 *   (e.g. when powering back up after power-save shutdown) */
+	iwl_write_prph(priv, BSM_WR_CTRL_REG,
+		BSM_WR_CTRL_REG_BIT_START_EN);
+
+	iwl_release_nic_access(priv);
+
+	return 0;
+}
+
+static struct iwl_lib_ops iwl3945_lib = {
+	.load_ucode = iwl3945_load_bsm,
+};
+
+static struct iwl_ops iwl3945_ops = {
+	.lib = &iwl3945_lib,
+};
+
 static struct iwl_cfg iwl3945_bg_cfg = {
 	.name = "3945BG",
 	.fw_name_pre = IWL3945_FW_PRE,
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
+	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params
 };
 
@@ -2522,6 +2680,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a8e17c5..9b7fe5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4934,156 +4934,6 @@ static int iwl3945_verify_ucode(struct iwl_priv *priv)
 	return rc;
 }
 
-
-/* check contents of special bootstrap uCode SRAM */
-static int iwl3945_verify_bsm(struct iwl_priv *priv)
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
-	     reg += sizeof(u32), image++) {
-		val = iwl_read_prph(priv, reg);
-		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(priv, "BSM uCode verification failed at "
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
- * iwl3945_load_bsm - Load bootstrap instructions
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
-static int iwl3945_load_bsm(struct iwl_priv *priv)
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
-	if (len > IWL39_MAX_BSM_SIZE)
-		return -EINVAL;
-
-	/* Tell bootstrap uCode where to find the "Initialize" uCode
-	 *   in host DRAM ... host DRAM physical address bits 31:0 for 3945.
-	 * NOTE:  iwl3945_initialize_alive_start() will replace these values,
-	 *        after the "initialize" uCode has run, to point to
-	 *        runtime/protocol instructions and backup data cache. */
-	pinst = priv->ucode_init.p_addr;
-	pdata = priv->ucode_init_data.p_addr;
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
-	rc = iwl3945_verify_bsm(priv);
-	if (rc) {
-		iwl_release_nic_access(priv);
-		return rc;
-	}
-
-	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl_write_prph(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_prph(priv, BSM_WR_MEM_DST_REG,
-				 IWL39_RTC_INST_LOWER_BOUND);
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
-		IWL_ERR(priv, "BSM write did not complete!\n");
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
 static void iwl3945_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
@@ -5724,7 +5574,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		rc = iwl3945_load_bsm(priv);
+		priv->cfg->ops->lib->load_ucode(priv);
 
 		if (rc) {
 			IWL_ERR(priv,
-- 
1.5.3.6

