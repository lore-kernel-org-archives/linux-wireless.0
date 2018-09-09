Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48038 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbeIIO0h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:54 +0300
Message-Id: <20180909093656.10194-15-luca@coelho.fi> (sfid-20180909_113735_029095_A0FC87C7)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: configure power scheme to balanced for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

As a temporary stage in the 22560 devices bring up, we disabled
power save, to avoid bugs related to that domain.
Now we would like to use power save so enable the balanced mode,
and allow configuring the mode via module parameter.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d728b854be95..0599d323cbeb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -720,10 +720,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		trans_cfg.rx_buf_size = rb_size_default;
 	}
 
-	/* TODO: remove when balanced power mode is fw supported */
-	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-		iwlmvm_mod_params.power_scheme = IWL_POWER_SCHEME_CAM;
-
 	trans->wide_cmd_header = true;
 	trans_cfg.bc_table_dword =
 		mvm->trans->cfg->device_family < IWL_DEVICE_FAMILY_22560;
-- 
2.18.0
