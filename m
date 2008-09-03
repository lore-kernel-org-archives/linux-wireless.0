Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21506 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbYICDbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 32/39] iwlwifi: fix host command header according the HW spec
Date: Wed,  3 Sep 2008 11:26:52 +0800
Message-Id: <1220412419-15404-33-git-send-email-yi.zhu@intel.com> (sfid-20080903_055044_432776_3E54F32B)
In-Reply-To: <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch aligns definition of host command with the spec. The
inaccuracies weren't critical though.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   20 ++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index fbd8cc1..8d04e96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -163,6 +163,13 @@ enum {
 /* iwl_cmd_header flags value */
 #define IWL_CMD_FAILED_MSK 0x40
 
+#define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
+#define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
+#define SEQ_TO_INDEX(s)	((s) & 0xff)
+#define INDEX_TO_SEQ(i)	((i) & 0xff)
+#define SEQ_HUGE_FRAME	__constant_cpu_to_le16(0x4000)
+#define SEQ_RX_FRAME	__constant_cpu_to_le16(0x8000)
+
 /**
  * struct iwl_cmd_header
  *
@@ -171,7 +178,7 @@ enum {
  */
 struct iwl_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
-	u8 flags;	/* IWL_CMD_* */
+	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
 	/*
 	 * The driver sets up the sequence number to values of its chosing.
 	 * uCode does not use this value, but passes it back to the driver
@@ -187,11 +194,12 @@ struct iwl_cmd_header {
 	 *
 	 * The Linux driver uses the following format:
 	 *
-	 *  0:7    index/position within Tx queue
-	 *  8:13   Tx queue selection
-	 * 14:14   driver sets this to indicate command is in the 'huge'
-	 *         storage at the end of the command buffers, i.e. scan cmd
-	 * 15:15   uCode sets this in uCode-originated response/notification
+	 *  0:7		tfd index - position within TX queue
+	 *  8:12	TX queue id
+	 *  13		reserved
+	 *  14		huge - driver sets this to indicate command is in the
+	 *  		'huge' storage at the end of the command buffers
+	 *  15		unsolicited RX or uCode-originated notification
 	 */
 	__le16 sequence;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8daeafd..7934f56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -225,12 +225,6 @@ struct iwl_frame {
 	struct list_head list;
 };
 
-#define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
-#define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
-#define SEQ_TO_INDEX(x) ((u8)(x & 0xff))
-#define INDEX_TO_SEQ(x) ((u8)(x & 0xff))
-#define SEQ_HUGE_FRAME  (0x4000)
-#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 68567fa..4b4a2bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1064,7 +1064,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
+		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 	len = (idx == TFD_CMD_SLOTS) ?
 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
 	phys_addr = pci_map_single(priv->pci_dev, out_cmd, len,
@@ -1199,8 +1199,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	int huge = sequence & SEQ_HUGE_FRAME;
 	int cmd_index;
+	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct iwl_cmd *cmd;
 
 	/* If a Tx command is being handled and it isn't in the actual
-- 
1.5.3.6

