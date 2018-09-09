Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726722AbeIIO0N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:46 +0300
Message-Id: <20180909093656.10194-7-luca@coelho.fi> (sfid-20180909_113712_298937_7FBF9F8E)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: mvm: do not override amsdu size user settings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Since AMSDUs are not de-aggregated by HW in monitor mode,
we still need the option for setting large RBs (up to 12K).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index e2463e8e486b..d728b854be95 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -584,6 +584,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	};
 	int err, scan_size;
 	u32 min_backoff;
+	enum iwl_amsdu_size rb_size_default;
 
 	/*
 	 * We use IWL_MVM_STATION_COUNT to check the validity of the station
@@ -694,8 +695,16 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.op_mode = op_mode;
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
+
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		rb_size_default = IWL_AMSDU_2K;
+	else
+		rb_size_default = IWL_AMSDU_4K;
+
 	switch (iwlwifi_mod_params.amsdu_size) {
 	case IWL_AMSDU_DEF:
+		trans_cfg.rx_buf_size = rb_size_default;
+		break;
 	case IWL_AMSDU_4K:
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 		break;
@@ -708,17 +717,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	default:
 		pr_err("%s: Unsupported amsdu_size: %d\n", KBUILD_MODNAME,
 		       iwlwifi_mod_params.amsdu_size);
-		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+		trans_cfg.rx_buf_size = rb_size_default;
 	}
 
-	/* the hardware splits the A-MSDU */
-	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		trans_cfg.rx_buf_size = IWL_AMSDU_2K;
-		/* TODO: remove when balanced power mode is fw supported */
+	/* TODO: remove when balanced power mode is fw supported */
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 		iwlmvm_mod_params.power_scheme = IWL_POWER_SCHEME_CAM;
-	} else if (mvm->cfg->mq_rx_supported) {
-		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
-	}
 
 	trans->wide_cmd_header = true;
 	trans_cfg.bc_table_dword =
-- 
2.18.0
