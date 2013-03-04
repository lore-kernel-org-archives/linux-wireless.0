Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3CDOA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/11] iwlwifi: rename IWL_MAX_CMD_TFDS to IWL_MAX_CMD_TBS_PER_TFD
Date: Mon,  4 Mar 2013 15:00:42 +0100
Message-Id: <1362405651-26456-2-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150059_039277_723E79FE)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The IWL_MAX_CMD_TFDS name for this constant is wrong, the
constant really indicates how many TBs we can use in the
driver for a single command TFD, rename the constant and
also add a comment explaining it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |  2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 12 ++++++++----
 drivers/net/wireless/iwlwifi/pcie/tx.c      | 12 ++++++------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 10f0179..81aa91f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -363,7 +363,7 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 		__entry->flags = cmd->flags;
 		memcpy(__get_dynamic_array(hcmd), hdr, sizeof(*hdr));
 
-		for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 			if (!cmd->len[i])
 				continue;
 			memcpy((u8 *)__get_dynamic_array(hcmd) + offset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8c7bec6..058947f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -217,7 +217,11 @@ struct iwl_device_cmd {
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
 
-#define IWL_MAX_CMD_TFDS	2
+/*
+ * number of transfer buffers (fragments) per transmit frame descriptor;
+ * this is just the driver's idea, the hardware supports 20
+ */
+#define IWL_MAX_CMD_TBS_PER_TFD	2
 
 /**
  * struct iwl_hcmd_dataflag - flag for each one of the chunks of the command
@@ -254,15 +258,15 @@ enum iwl_hcmd_dataflag {
  * @id: id of the host command
  */
 struct iwl_host_cmd {
-	const void *data[IWL_MAX_CMD_TFDS];
+	const void *data[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_rx_packet *resp_pkt;
 	unsigned long _rx_page_addr;
 	u32 _rx_page_order;
 	int handler_status;
 
 	u32 flags;
-	u16 len[IWL_MAX_CMD_TFDS];
-	u8 dataflags[IWL_MAX_CMD_TFDS];
+	u16 len[IWL_MAX_CMD_TBS_PER_TFD];
+	u8 dataflags[IWL_MAX_CMD_TBS_PER_TFD];
 	u8 id;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 975492f..ff80a7e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1146,16 +1146,16 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	bool had_nocopy = false;
 	int i;
 	u32 cmd_pos;
-	const u8 *cmddata[IWL_MAX_CMD_TFDS];
-	u16 cmdlen[IWL_MAX_CMD_TFDS];
+	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
+	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
 
 	/* need one for the header if the first is NOCOPY */
-	BUILD_BUG_ON(IWL_MAX_CMD_TFDS > IWL_NUM_OF_TBS - 1);
+	BUILD_BUG_ON(IWL_MAX_CMD_TBS_PER_TFD > IWL_NUM_OF_TBS - 1);
 
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 		cmddata[i] = cmd->data[i];
 		cmdlen[i] = cmd->len[i];
 
@@ -1250,7 +1250,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	/* and copy the data that needs to be copied */
 	cmd_pos = offsetof(struct iwl_device_cmd, payload);
 	copy_size = sizeof(out_cmd->hdr);
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 		int copy = 0;
 
 		if (!cmd->len)
@@ -1319,7 +1319,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	iwl_pcie_txq_build_tfd(trans, txq, phys_addr, copy_size, 1);
 
 	/* map the remaining (adjusted) nocopy/dup fragments */
-	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+	for (i = 0; i < IWL_MAX_CMD_TBS_PER_TFD; i++) {
 		const void *data = cmddata[i];
 
 		if (!cmdlen[i])
-- 
1.8.0

