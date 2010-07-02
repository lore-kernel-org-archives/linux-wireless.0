Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab0GBSoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] iwlwifi: tx fifo queue flush command
Date: Fri,  2 Jul 2010 11:45:35 -0700
Message-Id: <1278096340-2546-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add host command and structure for tx fifo queue flush

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   34 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 +
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a304f77..b28cb4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -97,6 +97,7 @@ enum {
 	REPLY_ADD_STA = 0x18,
 	REPLY_REMOVE_STA = 0x19,
 	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
+	REPLY_TXFIFO_FLUSH = 0x1e,
 
 	/* Security */
 	REPLY_WEPKEY = 0x20,
@@ -1209,6 +1210,39 @@ struct iwl_rem_sta_cmd {
 	u8 reserved2[2];
 } __attribute__ ((packed));
 
+#define IWL_TX_FIFO_BK_MSK		cpu_to_le32(BIT(0))
+#define IWL_TX_FIFO_BE_MSK		cpu_to_le32(BIT(1))
+#define IWL_TX_FIFO_VI_MSK		cpu_to_le32(BIT(2))
+#define IWL_TX_FIFO_VO_MSK		cpu_to_le32(BIT(3))
+#define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
+
+/*
+ * REPLY_TXFIFO_FLUSH = 0x1e(command and response)
+ *
+ * When using full FIFO flush this command checks the scheduler HW block WR/RD
+ * pointers to check if all the frames were transferred by DMA into the
+ * relevant TX FIFO queue. Only when the DMA is finished and the queue is
+ * empty the command can finish.
+ * This command is used to flush the TXFIFO from transmit commands, it may
+ * operate on single or multiple queues, the command queue can't be flushed by
+ * this command. The command response is returned when all the queue flush
+ * operations are done. Each TX command flushed return response with the FLUSH
+ * status set in the TX response status. When FIFO flush operation is used,
+ * the flush operation ends when both the scheduler DMA done and TXFIFO empty
+ * are set.
+ *
+ * @fifo_control: bit mask for which queues to flush
+ * @flush_control: flush controls
+ *	0: Dump single MSDU
+ *	1: Dump multiple MSDU according to PS, INVALID STA, TTL, TID disable.
+ *	2: Dump all FIFO
+ */
+struct iwl_txfifo_flush_cmd {
+	__le32 fifo_control;
+	__le16 flush_control;
+	__le16 reserved;
+} __attribute__ ((packed));
+
 /*
  * REPLY_WEP_KEY = 0x20
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 51f89e7..258d059 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -49,6 +49,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_ADD_STA);
 		IWL_CMD(REPLY_REMOVE_STA);
 		IWL_CMD(REPLY_REMOVE_ALL_STA);
+		IWL_CMD(REPLY_TXFIFO_FLUSH);
 		IWL_CMD(REPLY_WEPKEY);
 		IWL_CMD(REPLY_3945_RX);
 		IWL_CMD(REPLY_TX);
-- 
1.7.0.4

