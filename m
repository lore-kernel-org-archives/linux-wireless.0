Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751277AbdKYPfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:34 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:10 +0200
Message-Id: <20171125153510.25359-7-luca@coelho.fi> (sfid-20171125_163542_119286_D8C22E45)
In-Reply-To: <20171125153510.25359-1-luca@coelho.fi>
References: <20171125153510.25359-1-luca@coelho.fi>
Subject: [PATCH 6/6] iwlwifi: fix access to prph when transport is stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When getting HW rfkill we get stop_device being called from
two paths.
One path is the IRQ calling stop device, and updating op
mode and stack.
As a result, cfg80211 is running rfkill sync work that shuts
down all devices (second path).
In the second path, we eventually get to iwl_mvm_stop_device
which calls iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording,
that access periphery registers.
The device may be stopped at this point from the first path,
which will result with a failure to access those registers.
Simply checking for the trans status is insufficient, since
the race will still exist, only minimized.
Instead, move the stop from iwl_fw_dump_conf_clear (which is
getting called only from stop path) to the transport stop
device function, where the access is always safe.
This has the added value, of actually stopping dbgc before
stopping device even when the stop is initiated from the
transport.

Fixes: 1efc3843a4ee ("iwlwifi: stop dbgc recording before stopping DMA")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          | 2 --
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 9 +++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 9c889a32fe24..223fb77a3aa9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -209,8 +209,6 @@ static inline void iwl_fw_dbg_stop_recording(struct iwl_fw_runtime *fwrt)
 
 static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
 {
-	iwl_fw_dbg_stop_recording(fwrt);
-
 	fwrt->dump.conf = FW_DBG_INVALID;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index c59f4581e972..ac05fd1e74c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -49,6 +49,7 @@
  *
  *****************************************************************************/
 #include "iwl-trans.h"
+#include "iwl-prph.h"
 #include "iwl-context-info.h"
 #include "internal.h"
 
@@ -156,6 +157,11 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 
 	trans_pcie->is_down = true;
 
+	/* Stop dbgc before stopping device */
+	iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
+	udelay(100);
+	iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3dee95e6a475..4541c86881d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1227,6 +1227,15 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 
 	trans_pcie->is_down = true;
 
+	/* Stop dbgc before stopping device */
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	} else {
+		iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
+		udelay(100);
+		iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+	}
+
 	/* tell the device to stop sending interrupts */
 	iwl_disable_interrupts(trans);
 
-- 
2.15.0
