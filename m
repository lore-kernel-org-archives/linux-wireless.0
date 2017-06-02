Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751147AbdFBL1P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:43 +0300
Message-Id: <20170602112553.2466-16-luca@coelho.fi> (sfid-20170602_132719_631257_6936690A)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: disentangle binding command versions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The comments/size of the different binding commands get lost
in documentation, so introduce two different command structs
that can be used there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index a4567d5206e2..4c5f38e50caa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -997,6 +997,26 @@ struct iwl_time_event_notif {
 /* Bindings and Time Quota */
 
 /**
+ * struct iwl_binding_cmd_v1 - configuring bindings
+ * ( BINDING_CONTEXT_CMD = 0x2b )
+ * @id_and_color: ID and color of the relevant Binding,
+ *	&enum iwl_mvm_id_and_color
+ * @action: action to perform, one of FW_CTXT_ACTION_*
+ * @macs: array of MAC id and colors which belong to the binding,
+ *	&enum iwl_mvm_id_and_color
+ * @phy: PHY id and color which belongs to the binding,
+ *	&enum iwl_mvm_id_and_color
+ */
+struct iwl_binding_cmd_v1 {
+	/* COMMON_INDEX_HDR_API_S_VER_1 */
+	__le32 id_and_color;
+	__le32 action;
+	/* BINDING_DATA_API_S_VER_1 */
+	__le32 macs[MAX_MACS_IN_BINDING];
+	__le32 phy;
+} __packed; /* BINDING_CMD_API_S_VER_1 */
+
+/**
  * struct iwl_binding_cmd - configuring bindings
  * ( BINDING_CONTEXT_CMD = 0x2b )
  * @id_and_color: ID and color of the relevant Binding,
@@ -1015,11 +1035,10 @@ struct iwl_binding_cmd {
 	/* BINDING_DATA_API_S_VER_1 */
 	__le32 macs[MAX_MACS_IN_BINDING];
 	__le32 phy;
-	/* BINDING_CMD_API_S_VER_1 */
 	__le32 lmac_id;
 } __packed; /* BINDING_CMD_API_S_VER_2 */
 
-#define IWL_BINDING_CMD_SIZE_V1	offsetof(struct iwl_binding_cmd, lmac_id)
+#define IWL_BINDING_CMD_SIZE_V1	sizeof(struct iwl_binding_cmd_v1)
 #define IWL_LMAC_24G_INDEX		0
 #define IWL_LMAC_5G_INDEX		1
 
-- 
2.11.0
