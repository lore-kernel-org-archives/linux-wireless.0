Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40866 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752156AbdG1OYK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:19 +0300
Message-Id: <20170728142337.19183-7-luca@coelho.fi> (sfid-20170728_162416_438930_38588A71)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 06/24] iwlwifi: fw api: fix various kernel-doc warnings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h | 22 +++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  3 ++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h b/drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h
index fd97cccaedb8..ea4a3f04a83a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h
@@ -112,15 +112,24 @@ static inline u32 iwl_cmd_id(u8 opcode, u8 groupid, u8 version)
 #define IWL_ALWAYS_LONG_GROUP	1
 
 /**
- * struct iwl_cmd_header
+ * struct iwl_cmd_header - (short) command header format
  *
  * This header format appears in the beginning of each command sent from the
  * driver, and each response/notification received from uCode.
  */
 struct iwl_cmd_header {
-	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
+	/**
+	 * @cmd: Command ID: REPLY_RXON, etc.
+	 */
+	u8 cmd;
+	/**
+	 * @group_id: group ID, for commands with groups
+	 */
 	u8 group_id;
-	/*
+	/**
+	 * @sequence:
+	 * Sequence number for the command.
+	 *
 	 * The driver sets up the sequence number to values of its choosing.
 	 * uCode does not use this value, but passes it back to the driver
 	 * when sending the response to each driver-originated command, so
@@ -150,6 +159,13 @@ struct iwl_cmd_header {
  * driver, and each response/notification received from uCode.
  * this is the wide version that contains more information about the command
  * like length, version and command type
+ *
+ * @cmd: command ID, like in &struct iwl_cmd_header
+ * @group_id: group ID, like in &struct iwl_cmd_header
+ * @sequence: sequence, like in &struct iwl_cmd_header
+ * @length: length of the command
+ * @reserved: reserved
+ * @version: command version
  */
 struct iwl_cmd_header_wide {
 	u8 cmd;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
index 7e7ebe82729b..805e161641aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
@@ -112,7 +112,7 @@ enum iwl_mvm_tx_fifo {
 };
 
 /**
- * iwl_tx_queue_cfg_actions - TXQ config options
+ * enum iwl_tx_queue_cfg_actions - TXQ config options
  * @TX_QUEUE_CFG_ENABLE_QUEUE: enable a queue
  * @TX_QUEUE_CFG_TFD_SHORT_FORMAT: use short TFD format
  */
@@ -145,6 +145,7 @@ struct iwl_tx_queue_cfg_cmd {
  * @queue_number: queue number assigned to this RA -TID
  * @flags: set on failure
  * @write_pointer: initial value for write pointer
+ * @reserved: reserved
  */
 struct iwl_tx_queue_cfg_rsp {
 	__le16 queue_number;
-- 
2.13.2
