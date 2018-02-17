Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59280 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751049AbeBQIeG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:06 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:50 +0200
Message-Id: <20180217083354.31160-6-luca@coelho.fi> (sfid-20180217_093421_282011_DFCA85B6)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 5/9] iwlwifi: avoid collecting firmware dump if not loaded
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Trying to collect firmware debug data while firmware
is not loaded causes various errors (e.g. failing NIC access).
This causes even a bigger issue if at that time the
HW radio is off.
In that case, when later turning the radio on, the Driver
fails to read the HW (registers contain garbage values).
(It may be that the CSR_GP_CNTRL_REG_FLAG_RFKILL_WAKE_L1A_EN
bit is cleared on faulty NIC access - since the same behavior
was seen in HW RFKILL toggling before setting that bit.)

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      | 13 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h      |  3 +++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     |  8 ++++++++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 67aefc8fc9ac..7bd704a3e640 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -942,7 +944,6 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 out:
 	iwl_fw_free_dump_desc(fwrt);
-	fwrt->dump.trig = NULL;
 	clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
 	IWL_DEBUG_INFO(fwrt, "WRT dump done\n");
 }
@@ -1112,6 +1113,14 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 	    fwrt->ops->dump_start(fwrt->ops_ctx))
 		return;
 
+	if (fwrt->ops && fwrt->ops->fw_running &&
+	    !fwrt->ops->fw_running(fwrt->ops_ctx)) {
+		IWL_ERR(fwrt, "Firmware not running - cannot dump error\n");
+		iwl_fw_free_dump_desc(fwrt);
+		clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
+		goto out;
+	}
+
 	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		/* stop recording */
 		iwl_fw_dbg_stop_recording(fwrt);
@@ -1145,7 +1154,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 			iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, out_ctrl);
 		}
 	}
-
+out:
 	if (fwrt->ops && fwrt->ops->dump_end)
 		fwrt->ops->dump_end(fwrt->ops_ctx);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 223fb77a3aa9..72259bff9922 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -91,6 +93,7 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 	if (fwrt->dump.desc != &iwl_dump_desc_assert)
 		kfree(fwrt->dump.desc);
 	fwrt->dump.desc = NULL;
+	fwrt->dump.trig = NULL;
 }
 
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index f3197f7c13b6..3fb940ebd74a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -26,6 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -68,6 +70,7 @@
 struct iwl_fw_runtime_ops {
 	int (*dump_start)(void *ctx);
 	void (*dump_end)(void *ctx);
+	bool (*fw_running)(void *ctx);
 };
 
 #define MAX_NUM_LMAC 2
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index a7892c1254a2..9c436d8d001d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +36,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1281,9 +1283,6 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 {
 	int ret;
 
-	if (!iwl_mvm_firmware_running(mvm))
-		return -EIO;
-
 	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_WRITE);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6bb347bf0d6e..ab7fb5aad984 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +36,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -552,9 +554,15 @@ static void iwl_mvm_fwrt_dump_end(void *ctx)
 	iwl_mvm_unref(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
 }
 
+static bool iwl_mvm_fwrt_fw_running(void *ctx)
+{
+	return iwl_mvm_firmware_running(ctx);
+}
+
 static const struct iwl_fw_runtime_ops iwl_mvm_fwrt_ops = {
 	.dump_start = iwl_mvm_fwrt_dump_start,
 	.dump_end = iwl_mvm_fwrt_dump_end,
+	.fw_running = iwl_mvm_fwrt_fw_running,
 };
 
 static struct iwl_op_mode *
-- 
2.15.1
