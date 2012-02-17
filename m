Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2BQUXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/26] iwlwifi: change args to ucode routines
Date: Fri, 17 Feb 2012 11:13:41 -0800
Message-Id: <1329506034-1394-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212441_534705_B2316F15)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Change the prameters to the ucode (de)allocate routines to iwl_nic as
they are not transport operations.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   65 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-wifi.h  |    2 +
 4 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 12803d3..ff22c4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1316,7 +1316,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	/*This will stop the queues, move the device to low power state */
 	iwl_trans_stop_device(trans(priv));
 
-	iwl_dealloc_ucode(trans(priv));
+	iwl_dealloc_ucode(nic(priv));
 
 	iwl_eeprom_free(priv->shrd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 913df93..7ea5f77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -396,8 +396,6 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 /*****************************************************
 * Utils functions
 ******************************************************/
-void iwl_dealloc_ucode(struct iwl_trans *trans);
-
 int iwl_send_calib_results(struct iwl_trans *trans);
 int iwl_calib_set(struct iwl_trans *trans,
 		  const struct iwl_calib_hdr *cmd, int len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 36039eb..26ead61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -82,30 +82,29 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
  *
  ******************************************************************************/
 
-static void iwl_free_fw_desc(struct iwl_trans *trans, struct fw_desc *desc)
+static void iwl_free_fw_desc(struct iwl_nic *nic, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(trans->dev, desc->len,
+		dma_free_coherent(trans(nic)->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
 }
 
-static void iwl_free_fw_img(struct iwl_trans *trans, struct fw_img *img)
+static void iwl_free_fw_img(struct iwl_nic *nic, struct fw_img *img)
 {
-	iwl_free_fw_desc(trans, &img->code);
-	iwl_free_fw_desc(trans, &img->data);
+	iwl_free_fw_desc(nic, &img->code);
+	iwl_free_fw_desc(nic, &img->data);
 }
 
-void iwl_dealloc_ucode(struct iwl_trans *trans)
+void iwl_dealloc_ucode(struct iwl_nic *nic)
 {
-	struct iwl_nic *nic = nic(trans);
-	iwl_free_fw_img(trans, &nic->fw.ucode_rt);
-	iwl_free_fw_img(trans, &nic->fw.ucode_init);
-	iwl_free_fw_img(trans, &nic->fw.ucode_wowlan);
+	iwl_free_fw_img(nic, &nic->fw.ucode_rt);
+	iwl_free_fw_img(nic, &nic->fw.ucode_init);
+	iwl_free_fw_img(nic, &nic->fw.ucode_wowlan);
 }
 
-static int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
+static int iwl_alloc_fw_desc(struct iwl_nic *nic, struct fw_desc *desc,
 		      const void *data, size_t len)
 {
 	if (!len) {
@@ -113,7 +112,7 @@ static int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(trans->dev, len,
+	desc->v_addr = dma_alloc_coherent(trans(nic)->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
@@ -398,15 +397,16 @@ static int iwl_alive_notify(struct iwl_trans *trans)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_trans *trans,
+static int iwl_verify_inst_sparse(struct iwl_nic *nic,
 				      struct fw_desc *fw_desc)
 {
+	struct iwl_trans *trans = trans(nic);
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 i;
 
-	IWL_DEBUG_FW(trans, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(nic, "ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
@@ -422,16 +422,17 @@ static int iwl_verify_inst_sparse(struct iwl_trans *trans,
 	return 0;
 }
 
-static void iwl_print_mismatch_inst(struct iwl_trans *trans,
+static void iwl_print_mismatch_inst(struct iwl_nic *nic,
 				    struct fw_desc *fw_desc)
 {
+	struct iwl_trans *trans = trans(nic);
 	__le32 *image = (__le32 *)fw_desc->v_addr;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 offs;
 	int errors = 0;
 
-	IWL_DEBUG_FW(trans, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(nic, "ucode inst image size is %u\n", len);
 
 	iwl_write_direct32(trans, HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
@@ -442,7 +443,7 @@ static void iwl_print_mismatch_inst(struct iwl_trans *trans,
 		/* read data comes through single port, auto-incr addr */
 		val = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(trans, "uCode INST section at "
+			IWL_ERR(nic, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
 				offs, val, le32_to_cpu(*image));
 			errors++;
@@ -454,24 +455,24 @@ static void iwl_print_mismatch_inst(struct iwl_trans *trans,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_trans *trans,
+static int iwl_verify_ucode(struct iwl_nic *nic,
 			    enum iwl_ucode_type ucode_type)
 {
-	struct fw_img *img = iwl_get_ucode_image(nic(trans), ucode_type);
+	struct fw_img *img = iwl_get_ucode_image(nic, ucode_type);
 
 	if (!img) {
-		IWL_ERR(trans, "Invalid ucode requested (%d)\n", ucode_type);
+		IWL_ERR(nic, "Invalid ucode requested (%d)\n", ucode_type);
 		return -EINVAL;
 	}
 
-	if (!iwl_verify_inst_sparse(trans, &img->code)) {
-		IWL_DEBUG_FW(trans, "uCode is good in inst SRAM\n");
+	if (!iwl_verify_inst_sparse(nic, &img->code)) {
+		IWL_DEBUG_FW(nic, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
-	IWL_ERR(trans, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
+	IWL_ERR(nic, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(trans, &img->code);
+	iwl_print_mismatch_inst(nic, &img->code);
 	return -EIO;
 }
 
@@ -619,7 +620,7 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 	 * skip it for WoWLAN.
 	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(trans, ucode_type);
+		ret = iwl_verify_ucode(nic(trans), ucode_type);
 		if (ret) {
 			trans->shrd->ucode_type = old_type;
 			return ret;
@@ -1164,20 +1165,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(trans(priv), &nic(priv)->fw.ucode_rt.code,
+	if (iwl_alloc_fw_desc(nic(priv), &nic(priv)->fw.ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(trans(priv), &nic(priv)->fw.ucode_rt.data,
+	if (iwl_alloc_fw_desc(nic(priv), &nic(priv)->fw.ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(trans(priv),
+		if (iwl_alloc_fw_desc(nic(priv),
 				      &nic(priv)->fw.ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(trans(priv),
+		if (iwl_alloc_fw_desc(nic(priv),
 				      &nic(priv)->fw.ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
@@ -1185,12 +1186,12 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(trans(priv),
+		if (iwl_alloc_fw_desc(nic(priv),
 				      &nic(priv)->fw.ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(trans(priv),
+		if (iwl_alloc_fw_desc(nic(priv),
 				      &nic(priv)->fw.ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
@@ -1286,7 +1287,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
  err_pci_alloc:
 	IWL_ERR(priv, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode(trans(priv));
+	iwl_dealloc_ucode(nic(priv));
  out_unbind:
 	complete(&nic->request_firmware_complete);
 	device_release_driver(trans(priv)->dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index a34708d..392f111 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -95,6 +95,8 @@ struct iwl_nic {
 };
 
 
+void iwl_dealloc_ucode(struct iwl_nic *nic);
+
 int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_trans *trans);
 int iwl_init_alive_start(struct iwl_trans *trans);
-- 
1.7.0.4

