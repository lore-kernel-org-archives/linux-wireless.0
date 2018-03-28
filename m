Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37160 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752831AbeC1TyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 15:54:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 22:54:20 +0300
Message-Id: <20180328195420.24737-1-luca@coelho.fi> (sfid-20180328_215428_606695_C3C65E35)
In-Reply-To: <20180328195253.24380-1-luca@coelho.fi>
References: <20180328195253.24380-1-luca@coelho.fi>
Subject: [PATCH v2 14/14] iwlwifi: wrt: add fw force restart via triggers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

We can set triggers that cause a debug data collection when something
of interest happens (e.g. when too many probes are lost conscutively).
Normally, this triggers don't cause the FW to be restarted, but in
some cases that may be desired, so we recover from the problem.  To
support this, add a flag that indicates that the FW should be
restarted when the trigger fires.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c  |  6 ++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d27a43ea0d7c..fa283285fcbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1008,6 +1008,12 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_dump_desc *desc;
 
+	if (trigger && trigger->flags & IWL_FW_DBG_FORCE_RESTART) {
+		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", trig);
+		iwl_force_nmi(fwrt->trans);
+		return 0;
+	}
+
 	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
 	if (!desc)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 2bea95bf4fc9..9b2805e1e3b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -620,6 +620,14 @@ enum iwl_fw_dbg_trigger_mode {
 	IWL_FW_DBG_TRIGGER_MONITOR_ONLY = BIT(2),
 };
 
+/**
+ * enum iwl_fw_dbg_trigger_flags - the flags supported by wrt triggers
+ * @IWL_FW_DBG_FORCE_RESTART: force a firmware restart
+ */
+enum iwl_fw_dbg_trigger_flags {
+	IWL_FW_DBG_FORCE_RESTART = BIT(0),
+};
+
 /**
  * enum iwl_fw_dbg_trigger_vif_type - define the VIF type for a trigger
  * @IWL_FW_DBG_CONF_VIF_ANY: any vif type
@@ -656,6 +664,7 @@ enum iwl_fw_dbg_trigger_vif_type {
  * @occurrences: number of occurrences. 0 means the trigger will never fire.
  * @trig_dis_ms: the time, in milliseconds, after an occurrence of this
  *	trigger in which another occurrence should be ignored.
+ * @flags: &enum iwl_fw_dbg_trigger_flags
  */
 struct iwl_fw_dbg_trigger_tlv {
 	__le32 id;
@@ -666,7 +675,8 @@ struct iwl_fw_dbg_trigger_tlv {
 	u8 start_conf_id;
 	__le16 occurrences;
 	__le16 trig_dis_ms;
-	__le16 reserved[3];
+	u8 flags;
+	u8 reserved[5];
 
 	u8 data[0];
 } __packed;
-- 
2.16.2
