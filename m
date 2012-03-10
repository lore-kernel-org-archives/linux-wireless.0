Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2CJU71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlwifi: abstract out missing SEQ_RX_FRAME workaround
Date: Sat, 10 Mar 2012 13:00:07 -0800
Message-Id: <1331413215-10027-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_215957_119930_94269D57)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Mohammed Shafi ran into [1] the SEQ_RX_FRAME workaround
warning with a statistics notification, this means we
can't just remove it as we'd hoped.

Abstract it out so that the higher layer can configure
this as a kind of "filter" in the transport.

[1] http://mid.gmane.org/CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com

Reported-by: Mohammed Shafi <shafi.wireless@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   10 +++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   29 ++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    7 +++++
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    9 ++++++
 5 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 28422c0..5ef1585 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1186,6 +1186,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	u16 num_mac;
 	u32 ucode_flags;
 	struct iwl_trans_config trans_cfg;
+	static const u8 no_reclaim_cmds[] = {
+		REPLY_RX_PHY_CMD,
+		REPLY_RX,
+		REPLY_RX_MPDU_CMD,
+		REPLY_COMPRESSED_BA,
+		STATISTICS_NOTIFICATION,
+		REPLY_TX,
+	};
 
 	/************************
 	 * 1. Allocating HW data
@@ -1211,6 +1219,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 * to know about.
 	 */
 	trans_cfg.op_mode = op_mode;
+	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
+	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 
 	ucode_flags = fw->ucode_capa.flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 6796559..1c2fe87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -291,6 +291,8 @@ struct iwl_trans_pcie {
 	wait_queue_head_t ucode_write_waitq;
 	unsigned long status;
 	u8 cmd_queue;
+	u8 n_no_reclaim_cmds;
+	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 9bc3c73..8bec0e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -395,13 +395,17 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	 *   there is no command buffer to reclaim.
 	 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 	 *   but apparently a few don't get set; catch them here. */
-	reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-		  (pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-		  (pkt->hdr.cmd != REPLY_RX) &&
-		  (pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
-		  (pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-		  (pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
-		  (pkt->hdr.cmd != REPLY_TX);
+	reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME);
+	if (reclaim) {
+		int i;
+
+		for (i = 0; i < trans_pcie->n_no_reclaim_cmds; i++) {
+			if (trans_pcie->no_reclaim_cmds[i] == pkt->hdr.cmd) {
+				reclaim = false;
+				break;
+			}
+		}
+	}
 
 	sequence = le16_to_cpu(pkt->hdr.sequence);
 	index = SEQ_TO_INDEX(sequence);
@@ -412,17 +416,6 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	else
 		cmd = NULL;
 
-	/* warn if this is cmd response / notification and the uCode
-	 * didn't set the SEQ_RX_FRAME for a frame that is
-	 * uCode-originated
-	 * If you saw this code after the second half of 2012, then
-	 * please remove it
-	 */
-	WARN(pkt->hdr.cmd != REPLY_TX && reclaim == false &&
-	     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
-	     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
-	     get_cmd_string(pkt->hdr.cmd));
-
 	err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 14b0361..4900dfa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1626,6 +1626,13 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->cmd_queue = trans_cfg->cmd_queue;
+	if (WARN_ON(trans_cfg->n_no_reclaim_cmds > MAX_NO_RECLAIM_CMDS))
+		trans_pcie->n_no_reclaim_cmds = 0;
+	else
+		trans_pcie->n_no_reclaim_cmds = trans_cfg->n_no_reclaim_cmds;
+	if (trans_pcie->n_no_reclaim_cmds)
+		memcpy(trans_pcie->no_reclaim_cmds, trans_cfg->no_reclaim_cmds,
+		       trans_pcie->n_no_reclaim_cmds * sizeof(u8));
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7d1990c..95f3faf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -274,6 +274,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 	return p;
 }
 
+#define MAX_NO_RECLAIM_CMDS	6
+
 /**
  * struct iwl_trans_config - transport configuration
  *
@@ -281,10 +283,17 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	Must be set before any other call.
  * @cmd_queue: the index of the command queue.
  *	Must be set before start_fw.
+ * @no_reclaim_cmds: Some devices erroneously don't set the
+ *	SEQ_RX_FRAME bit on some notifications, this is the
+ *	list of such notifications to filter. Max length is
+ *	%MAX_NO_RECLAIM_CMDS.
+ * @n_no_reclaim_cmds: # of commands in list
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
 	u8 cmd_queue;
+	const u8 *no_reclaim_cmds;
+	int n_no_reclaim_cmds;
 };
 
 /**
-- 
1.7.0.4

