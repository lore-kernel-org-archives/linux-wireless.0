Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205Ab1LPQh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/24] iwlwifi: add debug in Tx path in AGG flow
Date: Fri, 16 Dec 2011 07:37:21 -0800
Message-Id: <1324049849-831-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173826_160478_17812EC2)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow us to catch bad cases in which the packets aren't in
the right place on the ring.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 5085dae..bd29568 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -408,6 +408,7 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 				int txq_id, u32 index)
 {
+	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d", txq_id, index & 0xff);
 	iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
 	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index cfa0bf6..409faea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1063,6 +1063,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	bool is_agg = false;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
+	u16 __maybe_unused wifi_seq;
 
 	/*
 	 * Send this frame after DTIM -- there's a special queue
@@ -1093,6 +1094,18 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
+	/* In AGG mode, the index in the ring must correspond to the WiFi
+	 * sequence number. This is a HW requirements to help the SCD to parse
+	 * the BA.
+	 * Check here that the packets are in the right place on the ring.
+	 */
+#ifdef CONFIG_IWLWIFI_DEBUG
+	wifi_seq = SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+	WARN_ONCE(is_agg && ((wifi_seq & 0xff) != q->write_ptr),
+		  "Q: %d WiFi Seq %d tfdNum %d",
+		  txq_id, wifi_seq, q->write_ptr);
+#endif
+
 	/* Set up driver data for this TFD */
 	txq->skbs[q->write_ptr] = skb;
 	txq->cmd[q->write_ptr] = dev_cmd;
-- 
1.7.0.4

