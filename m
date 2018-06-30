Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52194 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752639AbeF3NYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:24:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:30 +0300
Message-Id: <20180630132330.14928-16-luca@coelho.fi> (sfid-20180630_152414_393628_4513C59A)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 15/15] iwlwifi: pcie: support 2k rx buffers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

The smallest rb size supported today is 4k rx buffers.
22560 devices use 2k rxb's, so allow using 2k buffers.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h    | 8 +++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h        | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          | 3 +++
 7 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 650214ff0a1c..38fcc6a9d421 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1787,7 +1787,8 @@ MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
 module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size, int, 0444);
 MODULE_PARM_DESC(amsdu_size,
-		 "amsdu size 0: 12K for multi Rx queue devices, 4K for other devices 1:4K 2:8K 3:12K (default 0)");
+		 "amsdu size 0: 12K for multi Rx queue devices, 2K for 22560 devices, "
+		 "4K for other devices 1:4K 2:8K 3:12K 4: 2K (default 0)");
 module_param_named(fw_restart, iwlwifi_mod_params.fw_restart, bool, 0444);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index 777f5df8a0c6..a4c96215933b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,9 +19,7 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
+ * along with this program;
  *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
@@ -33,6 +32,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -767,7 +767,7 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
 	if ((cfg->mq_rx_supported &&
-	     iwlwifi_mod_params.amsdu_size != IWL_AMSDU_4K) ||
+	     iwlwifi_mod_params.amsdu_size == IWL_AMSDU_DEF) ||
 	     iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 5dd848cb9d20..97072cf75bca 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -17,9 +18,7 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
+ * along with this program;
  *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
@@ -31,6 +30,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -90,6 +90,8 @@ enum iwl_amsdu_size {
 	IWL_AMSDU_4K = 1,
 	IWL_AMSDU_8K = 2,
 	IWL_AMSDU_12K = 3,
+	/* Add 2K at the end to avoid breaking current API */
+	IWL_AMSDU_2K = 4,
 };
 
 enum iwl_uapsd_disable {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 7bb0360d6807..b4c3a957c102 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -430,6 +430,13 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		else
 			vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
 		break;
+	case IWL_AMSDU_2K:
+		if (cfg->mq_rx_supported)
+			vht_cap->cap |=
+				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+		else
+			WARN(1, "RB size of 2K is not supported by this device\n");
+		break;
 	case IWL_AMSDU_4K:
 		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 1b9c627ee34d..4229992073b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -350,6 +350,8 @@ static inline int
 iwl_trans_get_rb_size_order(enum iwl_amsdu_size rb_size)
 {
 	switch (rb_size) {
+	case IWL_AMSDU_2K:
+		return get_order(2 * 1024);
 	case IWL_AMSDU_4K:
 		return get_order(4 * 1024);
 	case IWL_AMSDU_8K:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5d9b9306ea1c..d966262e0819 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -704,7 +704,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	}
 
 	/* the hardware splits the A-MSDU */
-	if (mvm->cfg->mq_rx_supported)
+	if (mvm->trans->cfg->device_family >=
+	    IWL_DEVICE_FAMILY_22560)
+		trans_cfg.rx_buf_size = IWL_AMSDU_2K;
+	else if (mvm->cfg->mq_rx_supported)
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 
 	trans->wide_cmd_header = true;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8cd0c3dac0ab..f509e55f27b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -858,6 +858,9 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	int i;
 
 	switch (trans_pcie->rx_buf_size) {
+	case IWL_AMSDU_2K:
+		rb_size = RFH_RXF_DMA_RB_SIZE_2K;
+		break;
 	case IWL_AMSDU_4K:
 		rb_size = RFH_RXF_DMA_RB_SIZE_4K;
 		break;
-- 
2.18.0
