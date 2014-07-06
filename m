Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:38039 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaGFJg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:27 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so3154433wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/40] iwlwifi: mvm: don't collect logs in the interrupt thread
Date: Sun,  6 Jul 2014 12:35:39 +0300
Message-Id: <1404639376-3792-3-git-send-email-egrumbach@gmail.com> (sfid-20140706_113631_225722_A4DFF48E)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of reading all the data in the context of the
interrupt thread, collect the data in the restart flow
before the actual restart takes place so that the device
still has all the information.
Remove iwl_mvm_fw_error_sram_dump and move its content to
iwl_mvm_fw_error_dump.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  3 ---
 drivers/net/wireless/iwlwifi/mvm/ops.c   | 31 ++++++++++++-------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c | 22 ----------------------
 3 files changed, 12 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f7e54a5..4cc6788 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -595,8 +595,6 @@ struct iwl_mvm {
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
 	void *fw_error_dump;
-	void *fw_error_sram;
-	u32 fw_error_sram_len;
 	u32 *fw_error_rxf;
 	u32 fw_error_rxf_len;
 
@@ -734,7 +732,6 @@ u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
-void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm);
 void iwl_mvm_fw_error_rxf_dump(struct iwl_mvm *mvm);
 #endif
 u8 first_antenna(u8 mask);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7bb763f..889374d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -550,7 +550,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	kfree(mvm->scan_cmd);
 	vfree(mvm->fw_error_dump);
-	kfree(mvm->fw_error_sram);
 	kfree(mvm->fw_error_rxf);
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
@@ -828,6 +827,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
+	const struct fw_img *img;
+	u32 sram_len, sram_ofs;
 	u32 file_len;
 	u32 trans_len;
 
@@ -836,9 +837,13 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (mvm->fw_error_dump)
 		return;
 
+	img = &mvm->fw->img[mvm->cur_ucode];
+	sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
+	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
+
 	file_len = sizeof(*dump_file) +
 		   sizeof(*dump_data) * 3 +
-		   mvm->fw_error_sram_len +
+		   sram_len +
 		   mvm->fw_error_rxf_len +
 		   sizeof(*dump_info);
 
@@ -870,6 +875,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	strncpy(dump_info->bus_human_readable, mvm->dev->bus->name,
 		sizeof(dump_info->bus_human_readable));
 
+	iwl_mvm_fw_error_rxf_dump(mvm);
+
 	dump_data = iwl_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
 	dump_data->len = cpu_to_le32(mvm->fw_error_rxf_len);
@@ -877,23 +884,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	dump_data = iwl_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SRAM);
-	dump_data->len = cpu_to_le32(mvm->fw_error_sram_len);
-
-	/*
-	 * No need for lock since at the stage the FW isn't loaded. So it
-	 * can't assert - we are the only one who can possibly be accessing
-	 * mvm->fw_error_sram right now.
-	 */
-	memcpy(dump_data->data, mvm->fw_error_sram, mvm->fw_error_sram_len);
+	dump_data->len = cpu_to_le32(sram_len);
+	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_data->data,
+				 sram_len);
 
 	kfree(mvm->fw_error_rxf);
 	mvm->fw_error_rxf = NULL;
 	mvm->fw_error_rxf_len = 0;
 
-	kfree(mvm->fw_error_sram);
-	mvm->fw_error_sram = NULL;
-	mvm->fw_error_sram_len = 0;
-
 	if (trans_len) {
 		void *buf = iwl_fw_error_next_data(dump_data);
 		u32 real_trans_len = iwl_trans_dump_data(mvm->trans, buf,
@@ -911,11 +909,6 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_dump_nic_error_log(mvm);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_mvm_fw_error_sram_dump(mvm);
-	iwl_mvm_fw_error_rxf_dump(mvm);
-#endif
-
 	iwl_mvm_nic_restart(mvm);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index aa9fc77..15db97c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -520,28 +520,6 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
-{
-	const struct fw_img *img;
-	u32 ofs, sram_len;
-	void *sram;
-
-	if (!mvm->ucode_loaded || mvm->fw_error_sram || mvm->fw_error_dump)
-		return;
-
-	img = &mvm->fw->img[mvm->cur_ucode];
-	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-	sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
-
-	sram = kzalloc(sram_len, GFP_ATOMIC);
-	if (!sram)
-		return;
-
-	iwl_trans_read_mem_bytes(mvm->trans, ofs, sram, sram_len);
-	mvm->fw_error_sram = sram;
-	mvm->fw_error_sram_len = sram_len;
-}
-
 void iwl_mvm_fw_error_rxf_dump(struct iwl_mvm *mvm)
 {
 	int i, reg_val;
-- 
1.8.3.2

