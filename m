Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3GZI2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>
Subject: [PATCH 06/30] iwlwifi: mvm: sram hex dump on NIC error
Date: Fri, 26 Jul 2013 10:28:23 +0200
Message-Id: <1374827327-3464-7-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102906_081894_68CB4314)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add sram dump on NIC error for debug improvement.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/utils.c | 23 +++++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d40d7db..3aaecbc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -524,6 +524,7 @@ int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
 					enum ieee80211_band band);
 u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx);
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
+void iwl_mvm_dump_sram(struct iwl_mvm *mvm);
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index af79a14..0a4eb27 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -678,6 +678,8 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	iwl_mvm_dump_nic_error_log(mvm);
+	if (!iwlwifi_mod_params.restart_fw)
+		iwl_mvm_dump_sram(mvm);
 
 	iwl_mvm_nic_restart(mvm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 1e13328..a9c3574 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -453,6 +453,29 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "0x%08X | flow_handler\n", table.flow_handler);
 }
 
+void iwl_mvm_dump_sram(struct iwl_mvm *mvm)
+{
+	const struct fw_img *img;
+	int ofs, len = 0;
+	u8 *buf;
+
+	if (!mvm->ucode_loaded)
+		return;
+
+	img = &mvm->fw->img[mvm->cur_ucode];
+	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
+	len = img->sec[IWL_UCODE_SECTION_DATA].len;
+
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	iwl_trans_read_mem_bytes(mvm->trans, ofs, buf, len);
+	iwl_print_hex_error(mvm->trans, buf, len);
+
+	kfree(buf);
+}
+
 /**
  * iwl_mvm_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
-- 
1.8.0

