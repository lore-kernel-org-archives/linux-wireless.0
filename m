Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbcAaLHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:07:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/31] iwlwifi: mvm: allow to disable beacon filtering for AP/GO interface
Date: Sun, 31 Jan 2016 13:06:26 +0200
Message-Id: <1454238386-27032-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_424309_D76F74D1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

When in AP mode we need to filter in beacons from other APs to update HT
operation mode. As a power optimization the beacons are filtered out when
there are no associated stations. As a result, when there are no
associated stations, we will not update the HT operation mode until a
station connects.
Add a debugfs parameter that allows to disable this optimization.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 1 +
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 005cc09..c529e53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1548,6 +1548,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 				 mvm->debugfs_dir,
 				 &mvm->scan_iter_notif_enabled))
 		goto err;
+	if (!debugfs_create_bool("drop_bcn_ap_mode", S_IRUSR | S_IWUSR,
+				 mvm->debugfs_dir, &mvm->drop_bcn_ap_mode))
+		goto err;
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 62927f5..535134d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -744,7 +744,7 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		 * wake-ups.
 		 */
 		cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
-		if (mvmvif->ap_assoc_sta_count) {
+		if (mvmvif->ap_assoc_sta_count || !mvm->drop_bcn_ap_mode) {
 			cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
 			IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
 		} else {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 747f7eb..ebe37bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -859,6 +859,12 @@ struct iwl_mvm {
 
 	u32 ciphers[6];
 	struct iwl_mvm_tof_data tof_data;
+
+	/*
+	 * Drop beacons from other APs in AP mode when there are no connected
+	 * clients.
+	 */
+	bool drop_bcn_ap_mode;
 };
 
 /* Extract MVM priv from op_mode and _hw */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 325ff8a..09a94a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -492,6 +492,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	}
 	mvm->sf_state = SF_UNINIT;
 	mvm->cur_ucode = IWL_UCODE_INIT;
+	mvm->drop_bcn_ap_mode = true;
 
 	mutex_init(&mvm->mutex);
 	mutex_init(&mvm->d0i3_suspend_mutex);
-- 
2.5.0

