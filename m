Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35922 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750954AbdI2MDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 08:03:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 15:03:02 +0300
Message-Id: <20170929120305.20551-3-luca@coelho.fi> (sfid-20170929_140323_317377_C1E9C574)
In-Reply-To: <20170929120305.20551-1-luca@coelho.fi>
References: <20170929120305.20551-1-luca@coelho.fi>
Subject: [PATCH 2/5] iwlwifi: stop dbgc recording before stopping DMA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Today we stop the device and the DMA without stopping the dbgc
recording before. This causes host crashes when the DMA
rate is high.

Stop dbgc recording when clearing the fw debug configuration
to fix this.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6afc7a799892..f5dd7d83cd0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1086,7 +1086,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 
 	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		/* stop recording */
-		iwl_set_bits_prph(fwrt->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+		iwl_fw_dbg_stop_recording(fwrt);
 
 		iwl_fw_error_dump(fwrt);
 
@@ -1104,10 +1104,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		u32 in_sample = iwl_read_prph(fwrt->trans, DBGC_IN_SAMPLE);
 		u32 out_ctrl = iwl_read_prph(fwrt->trans, DBGC_OUT_CTRL);
 
-		/* stop recording */
-		iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, 0);
-		udelay(100);
-		iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, 0);
+		iwl_fw_dbg_stop_recording(fwrt);
 		/* wait before we collect the data till the DBGC stop */
 		udelay(500);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 0f810ea89d31..9c889a32fe24 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -68,6 +68,8 @@
 #include <linux/workqueue.h>
 #include <net/cfg80211.h>
 #include "runtime.h"
+#include "iwl-prph.h"
+#include "iwl-io.h"
 #include "file.h"
 #include "error-dump.h"
 
@@ -194,8 +196,21 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
 
+static inline void iwl_fw_dbg_stop_recording(struct iwl_fw_runtime *fwrt)
+{
+	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_set_bits_prph(fwrt->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	} else {
+		iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, 0);
+		udelay(100);
+		iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, 0);
+	}
+}
+
 static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
 {
+	iwl_fw_dbg_stop_recording(fwrt);
+
 	fwrt->dump.conf = FW_DBG_INVALID;
 }
 
-- 
2.14.1
