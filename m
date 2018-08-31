Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45626 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727611AbeHaODL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:01 +0300
Message-Id: <20180831095614.14099-4-luca@coelho.fi> (sfid-20180831_115635_219504_06A719CD)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 03/16] iwlwifi: fw: stop and start debugging using host command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In new devices, access to periphery is forbidden. Send instead
host command to start and stop debugging.

Memory allocation is written in context info, but in case we
need to update it there is a dedicated command. Add definitions,
currently unused, of the new command.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/debug.h | 32 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 46 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  2 +-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 6 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
index 106782341544..dc1fa377087a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -336,6 +338,9 @@ struct iwl_dbg_mem_access_rsp {
 #define CONT_REC_COMMAND_SIZE	80
 #define ENABLE_CONT_RECORDING	0x15
 #define DISABLE_CONT_RECORDING	0x16
+#define BUFFER_ALLOCATION	0x27
+#define START_DEBUG_RECORDING	0x29
+#define STOP_DEBUG_RECORDING	0x2A
 
 /*
  * struct iwl_continuous_record_mode - recording mode
@@ -353,4 +358,31 @@ struct iwl_continuous_record_cmd {
 		sizeof(struct iwl_continuous_record_mode)];
 } __packed;
 
+/* maximum fragments to be allocated per target of allocationId */
+#define IWL_BUFFER_LOCATION_MAX_FRAGS	2
+
+/**
+ * struct iwl_fragment_data single fragment structure
+ * @address: 64bit start address
+ * @size: size in bytes
+ */
+struct iwl_fragment_data {
+	__le64 address;
+	__le32 size;
+} __packed; /* FRAGMENT_STRUCTURE_API_S_VER_1 */
+
+/**
+ * struct iwl_buffer_allocation_cmd - buffer allocation command structure
+ * @allocation_id: id of the allocation
+ * @buffer_location: location of the buffer
+ * @num_frags: number of fragments
+ * @fragments: memory fragments
+ */
+struct iwl_buffer_allocation_cmd {
+	__le32 allocation_id;
+	__le32 buffer_location;
+	__le32 num_frags;
+	struct iwl_fragment_data fragments[IWL_BUFFER_LOCATION_MAX_FRAGS];
+} __packed; /* BUFFER_ALLOCATION_CMD_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_debug_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index b0da16f3f474..cebc9e99961e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1163,7 +1163,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		goto out;
 	}
 
-	iwl_fw_dbg_stop_recording(fwrt->trans, &params);
+	iwl_fw_dbg_stop_recording(fwrt, &params);
 
 	iwl_fw_error_dump(fwrt);
 
@@ -1172,7 +1172,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 	    fwrt->fw->dbg_dest_tlv) {
 		/* wait before we collect the data till the DBGC stop */
 		udelay(500);
-		iwl_fw_dbg_restart_recording(fwrt->trans, &params);
+		iwl_fw_dbg_restart_recording(fwrt, &params);
 	}
 out:
 	if (fwrt->ops && fwrt->ops->dump_end)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 878758b6c7ae..3c89230fae6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -71,6 +71,7 @@
 #include "iwl-io.h"
 #include "file.h"
 #include "error-dump.h"
+#include "api/commands.h"
 
 /**
  * struct iwl_fw_dump_desc - describes the dump
@@ -206,9 +207,26 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
 
+static int iwl_fw_dbg_start_stop_hcmd(struct iwl_fw_runtime *fwrt, bool start)
+{
+	struct iwl_continuous_record_cmd cont_rec = {};
+	struct iwl_host_cmd hcmd = {
+		.id = LDBG_CONFIG_CMD,
+		.flags = CMD_ASYNC,
+		.data[0] = &cont_rec,
+		.len[0] = sizeof(cont_rec),
+	};
+
+	cont_rec.record_mode.enable_recording = start ?
+		cpu_to_le16(START_DEBUG_RECORDING) :
+		cpu_to_le16(STOP_DEBUG_RECORDING);
+
+	return iwl_trans_send_cmd(fwrt->trans, &hcmd);
+}
+
 static inline void
-iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
-			  struct iwl_fw_dbg_params *params)
+_iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
+			   struct iwl_fw_dbg_params *params)
 {
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
@@ -226,8 +244,18 @@ iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 }
 
 static inline void
-iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
-			     struct iwl_fw_dbg_params *params)
+iwl_fw_dbg_stop_recording(struct iwl_fw_runtime *fwrt,
+			  struct iwl_fw_dbg_params *params)
+{
+	if (fwrt->trans->cfg->device_family < IWL_DEVICE_FAMILY_22560)
+		_iwl_fw_dbg_stop_recording(fwrt->trans, params);
+	else
+		iwl_fw_dbg_start_stop_hcmd(fwrt, false);
+}
+
+static inline void
+_iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
+			      struct iwl_fw_dbg_params *params)
 {
 	if (WARN_ON(!params))
 		return;
@@ -243,6 +271,16 @@ iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 	}
 }
 
+static inline void
+iwl_fw_dbg_restart_recording(struct iwl_fw_runtime *fwrt,
+			     struct iwl_fw_dbg_params *params)
+{
+	if (fwrt->trans->cfg->device_family < IWL_DEVICE_FAMILY_22560)
+		_iwl_fw_dbg_restart_recording(fwrt->trans, params);
+	else
+		iwl_fw_dbg_start_stop_hcmd(fwrt, true);
+}
+
 static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
 {
 	fwrt->dump.conf = FW_DBG_INVALID;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 5305342439b2..b09446697c46 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1042,7 +1042,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	 * the recording automatically before entering D3.  This can
 	 * be removed once the FW starts doing that.
 	 */
-	iwl_fw_dbg_stop_recording(mvm->fwrt.trans, NULL);
+	_iwl_fw_dbg_stop_recording(mvm->fwrt.trans, NULL);
 
 	/* must be last -- this switches firmware state */
 	ret = iwl_mvm_send_cmd(mvm, &d3_cfg_cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index b5902c74e5d0..77f3610e5ca9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -165,7 +165,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	iwl_fw_dbg_stop_recording(trans, NULL);
+	_iwl_fw_dbg_stop_recording(trans, NULL);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 5ecd5c8d0f02..1012d71bad6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1243,7 +1243,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = true;
 
 	/* Stop dbgc before stopping device */
-	iwl_fw_dbg_stop_recording(trans, NULL);
+	_iwl_fw_dbg_stop_recording(trans, NULL);
 
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
-- 
2.18.0
