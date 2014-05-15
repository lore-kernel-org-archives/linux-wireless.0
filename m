Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44884 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaEORFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:25 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4579253wib.7
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:24 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/24] iwlwifi: allow dynamic configuration of internal memory
Date: Thu, 15 May 2014 20:04:36 +0300
Message-Id: <1400173481-9047-19-git-send-email-egrumbach@gmail.com> (sfid-20140515_192147_443469_0081B43A)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

New transport need to configure internal memory based on
the data in the (enlarged) alive notification from the
firmware. Add a transport API for this.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h    |  5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans.h | 13 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c    | 11 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  1 +
 4 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 6fea27c..d5ed150 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -196,6 +196,11 @@ struct fw_img {
 	bool is_dual_cpus;
 };
 
+struct iwl_sf_region {
+	u32 addr;
+	u32 size;
+};
+
 /* uCode version contains 4 values: Major/Minor/API/Serial */
 #define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
 #define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c57d366..34d49e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -473,6 +473,8 @@ struct iwl_trans_ops {
 	void (*op_mode_leave)(struct iwl_trans *iwl_trans);
 	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw,
 			bool run_in_rfkill);
+	int (*update_sf)(struct iwl_trans *trans,
+			 struct iwl_sf_region *st_fwrd_space);
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
 	void (*stop_device)(struct iwl_trans *trans);
 
@@ -636,6 +638,17 @@ static inline int iwl_trans_start_fw(struct iwl_trans *trans,
 	return trans->ops->start_fw(trans, fw, run_in_rfkill);
 }
 
+static inline int iwl_trans_update_sf(struct iwl_trans *trans,
+				      struct iwl_sf_region *st_fwrd_space)
+{
+	might_sleep();
+
+	if (trans->ops->update_sf)
+		return trans->ops->update_sf(trans, st_fwrd_space);
+
+	return 0;
+}
+
 static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 {
 	might_sleep();
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 2cb7265..883e702 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -137,6 +137,8 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 		alive_data->scd_base_addr = le32_to_cpu(palive2->scd_base_ptr);
 		mvm->umac_error_event_table =
 			le32_to_cpu(palive2->error_info_addr);
+		mvm->sf_space.addr = le32_to_cpu(palive2->st_fwrd_addr);
+		mvm->sf_space.size = le32_to_cpu(palive2->st_fwrd_size);
 
 		alive_data->valid = le16_to_cpu(palive2->status) ==
 				    IWL_ALIVE_STATUS_OK;
@@ -180,6 +182,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	int ret, i;
 	enum iwl_ucode_type old_type = mvm->cur_ucode;
 	static const u8 alive_cmd[] = { MVM_ALIVE };
+	struct iwl_sf_region st_fwrd_space;
 
 	fw = iwl_get_ucode_image(mvm, ucode_type);
 	if (WARN_ON(!fw))
@@ -215,6 +218,14 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	/*
+	 * update the sdio allocation according to the pointer we get in the
+	 * alive notification.
+	 */
+	st_fwrd_space.addr = mvm->sf_space.addr;
+	st_fwrd_space.size = mvm->sf_space.size;
+	ret = iwl_trans_update_sf(mvm->trans, &st_fwrd_space);
+
 	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a7d27fb..5d2effb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -490,6 +490,7 @@ struct iwl_mvm {
 	u32 log_event_table;
 	u32 umac_error_event_table;
 	bool support_umac_log;
+	struct iwl_sf_region sf_space;
 
 	u32 ampdu_ref;
 
-- 
1.8.3.2

