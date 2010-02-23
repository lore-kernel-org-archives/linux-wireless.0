Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16842 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab0BWXDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 18:03:46 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: increase command buffer size
Date: Tue, 23 Feb 2010 15:02:40 -0800
Message-Id: <1266966160-1863-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Increase the buffer size for commands with "huge"
bit set. This has been recently observed for 6050 cards where
for even with huge bit set few commands were not properly allocated
memory with the command overwriting the buffer allocated for it.
Also add a check to see if command size exceeds the
maximum allowable size.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This patch is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e915075..cfd6c84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2612,6 +2612,7 @@ struct iwl_ssid_ie {
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH			cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
+#define IWL_MAX_CMD_SIZE 4096
 #define IWL_MAX_PROBE_REQUEST		200
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 8f40715..066491f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -366,7 +366,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	for (i = 0; i < actual_slots; i++) {
 		/* only happens for cmd queue */
 		if (i == slots_num)
-			len += IWL_MAX_SCAN_SIZE;
+			len = IWL_MAX_CMD_SIZE;
 
 		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
 		if (!txq->cmd[i])
@@ -1027,9 +1027,12 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	/* If any of the command structures end up being larger than
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
-	 * we will need to increase the size of the TFD entries */
+	 * we will need to increase the size of the TFD entries
+	 * Also, check to see if command buffer should not exceed the size
+	 * of device_cmd and max_cmd_size. */
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->flags & CMD_SIZE_HUGE));
+	BUG_ON(fix_size > IWL_MAX_CMD_SIZE);
 
 	if (iwl_is_rfkill(priv) || iwl_is_ctkill(priv)) {
 		IWL_WARN(priv, "Not sending command - %s KILL\n",
@@ -1073,8 +1076,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 	len = sizeof(struct iwl_device_cmd);
-	len += (idx == TFD_CMD_SLOTS) ?  IWL_MAX_SCAN_SIZE : 0;
-
+	if (idx == TFD_CMD_SLOTS)
+		len = IWL_MAX_CMD_SIZE;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
-- 
1.6.3.3

