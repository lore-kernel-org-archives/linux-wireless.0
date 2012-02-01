Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab2BAQJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.3] iwlwifi: don't mess up QoS counters with non-QoS frames
Date: Wed,  1 Feb 2012 07:01:32 -0800
Message-Id: <1328108492-15979-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120201_170912_785253_C32A2C7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In my AMPDU rework, I rely on the sequence numbers of frames. But
I didn't check that the frame has a valid tid before updating the
tracking counters. As a result, the Tx queues were stalled. People
who hit this bug saw that we simply didn't let any data out.

This bug was introduced in 3.3.

This patch fixes that and checks that the frame is a QoS frame before
looking at its tid and changing the counters.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |   12 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d9d758e..940be23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -91,6 +91,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
+		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
 		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 		else
@@ -808,6 +809,8 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 	u32 status = le16_to_cpu(tx_resp->status.status);
 	int i;
 
+	WARN_ON(tid == IWL_TID_NON_QOS);
+
 	if (agg->wait_for_ba)
 		IWL_DEBUG_TX_REPLY(priv,
 			"got tx response w/o block-ack\n");
@@ -1035,10 +1038,13 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		}
 
 		__skb_queue_head_init(&skbs);
-		priv->tid_data[sta_id][tid].next_reclaimed = next_reclaimed;
 
-		IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d",
-					  next_reclaimed);
+		if (tid != IWL_TID_NON_QOS) {
+			priv->tid_data[sta_id][tid].next_reclaimed =
+				next_reclaimed;
+			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d",
+						  next_reclaimed);
+		}
 
 		/*we can free until ssn % q.n_bd not inclusive */
 		WARN_ON(iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b4779c2..c20618d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -815,6 +815,7 @@ struct iwl_qosparam_cmd {
 
 #define	IWL_INVALID_STATION 	255
 #define IWL_MAX_TID_COUNT	8
+#define IWL_TID_NON_QOS IWL_MAX_TID_COUNT
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 836caf9..f5cb5d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1554,6 +1554,7 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 	txq->time_stamp = jiffies;
 
 	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
+		     tid != IWL_TID_NON_QOS &&
 		     txq_id != trans_pcie->agg_txq[sta_id][tid])) {
 		/*
 		 * FIXME: this is a uCode bug which need to be addressed,
-- 
1.7.0.4

