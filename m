Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYHDIDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:55 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/10] iwlwifi: add level for debugging host command
Date: Mon,  4 Aug 2008 16:00:45 +0800
Message-Id: <1217836848-24288-8-git-send-email-yi.zhu@intel.com> (sfid-20080804_100401_758389_129A0520)
In-Reply-To: <1217836848-24288-7-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Esti Kummer <ester.kummer@intel.com>

This patch adds another level for debugging host command. This adds an
option to suppress the debug prints for sensitivity and link quality
commands.

Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-hcmd.c  |   14 ++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-tx.c    |   26 ++++++++++++++++++++------
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index d2daa17..e548d67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -110,11 +110,12 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
  *
  */
 
-#define IWL_DL_INFO          (1 << 0)
-#define IWL_DL_MAC80211      (1 << 1)
-#define IWL_DL_HOST_COMMAND  (1 << 2)
-#define IWL_DL_STATE         (1 << 3)
+#define IWL_DL_INFO		(1 << 0)
+#define IWL_DL_MAC80211		(1 << 1)
+#define IWL_DL_HCMD		(1 << 2)
+#define IWL_DL_STATE		(1 << 3)
 #define IWL_DL_MACDUMP		(1 << 4)
+#define IWL_DL_HCMD_DUMP	(1 << 5)
 #define IWL_DL_RADIO         (1 << 7)
 #define IWL_DL_POWER         (1 << 8)
 #define IWL_DL_TEMP          (1 << 9)
@@ -162,7 +163,8 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
 #define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
 #define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
+#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HCMD, f, ## a)
+#define IWL_DEBUG_HC_DUMP(f, a...) IWL_DEBUG(IWL_DL_HCMD_DUMP, f, ## a)
 #define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
 #define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
 #define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 6512834..c0c6154 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -121,8 +121,18 @@ static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 		return 1;
 	}
 
-	IWL_DEBUG_HC("back from %s (0x%08X)\n",
-			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	switch (cmd->hdr.cmd) {
+	case REPLY_TX_LINK_QUALITY_CMD:
+	case SENSITIVITY_CMD:
+		IWL_DEBUG_HC_DUMP("back from %s (0x%08X)\n",
+				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+				break;
+	default:
+		IWL_DEBUG_HC("back from %s (0x%08X)\n",
+				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+	}
+#endif
 
 	/* Let iwl_tx_complete free the response skb */
 	return 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 86225d2..9eb2bfe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1065,12 +1065,26 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	phys_addr += offsetof(struct iwl_cmd, hdr);
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
-	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
-		     "%d bytes at %d[%d]:%d\n",
-		     get_cmd_string(out_cmd->hdr.cmd),
-		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
-		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
-
+#ifdef CONFIG_IWLWIFI_DEBUG
+	switch (out_cmd->hdr.cmd) {
+	case REPLY_TX_LINK_QUALITY_CMD:
+	case SENSITIVITY_CMD:
+		IWL_DEBUG_HC_DUMP("Sending command %s (#%x), seq: 0x%04X, "
+				"%d bytes at %d[%d]:%d\n",
+				get_cmd_string(out_cmd->hdr.cmd),
+				out_cmd->hdr.cmd,
+				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
+				q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
+				break;
+	default:
+		IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
+				"%d bytes at %d[%d]:%d\n",
+				get_cmd_string(out_cmd->hdr.cmd),
+				out_cmd->hdr.cmd,
+				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
+				q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
+	}
+#endif
 	txq->need_update = 1;
 
 	/* Set up entry in queue's byte count circular buffer */
-- 
1.5.3.6

