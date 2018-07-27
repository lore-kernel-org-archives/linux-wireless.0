Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38680 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730852AbeG0OK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:34 +0300
Message-Id: <20180727124838.25910-13-luca@coelho.fi> (sfid-20180727_144912_420050_202FAF0B)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: hard code power save mode to CAM for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Balanced power save mode isn't supported in the fw for 22560 devices
yet.  Configure the power save mode to CAM until it gets implemented.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0efd2a36e6c4..0e26619fb330 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -709,10 +709,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	}
 
 	/* the hardware splits the A-MSDU */
-	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
 		trans_cfg.rx_buf_size = IWL_AMSDU_2K;
-	else if (mvm->cfg->mq_rx_supported)
+		/* TODO: remove when balanced power mode is fw supported */
+		iwlmvm_mod_params.power_scheme = IWL_POWER_SCHEME_CAM;
+	} else if (mvm->cfg->mq_rx_supported) {
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+	}
 
 	trans->wide_cmd_header = true;
 	trans_cfg.bc_table_dword =
-- 
2.18.0
