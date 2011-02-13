Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMR5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:34 -0500
Received: by mail-iy0-f174.google.com with SMTP id 8so4089435iyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:34 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize latency
Date: Sun, 13 Feb 2011 09:56:41 -0800
Message-Id: <1297619803-2832-5-git-send-email-njs@pobox.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We maintain several ring buffers that queue up packets for the
hardware to transmit. These buffers can be quite large, and the
quality of wireless connections can vary greatly; as a result, it can
be that a full queue might take multiple seconds to drain.

For instance, if there is a high-bandwidth outgoing flow, like a large
file upload, then it will completely fill the tx queues. Once the
queues are full, then any other outgoing packets -- like those sent
when a user clicks on an HTTP link, or types into an SSH session --
will have to wait at the end of the line, and will not actually be
transmitted until multiple seconds have passed.  This results in a
suboptimal level of interactive response.

So we really don't want to allow too many packets to get queued up. On
the other hand, we do want to queue up *some* packets, to maintain
throughput -- and the queue size that maintains interactivity for a
degraded 1 Mb/s connection might not be so great for some
super-fancy 802.11n 600 Mb/s connection.

This patch estimates how long it takes the hardware to transmit one
packet (by comparing each packet's queue residency time to the number
of packets it had to wait behind), and then further smooths these
estimates with an EWMA. Then, it uses the estimated packet
transmission time to choose the maximum queue size that will still
produce reasonably bounded queue residency times, given current
conditions.

Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 6 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f2e9e59..d52bcb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -288,6 +288,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
+		iwl_tx_queue_update_high_mark(txq, txq->q.read_ptr);
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb);
 		tx_info->skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 921876d..06347e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -655,6 +655,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb = skb;
 	txq->txb[q->write_ptr].ctx = ctx;
+	getrawmonotonic(&txq->txb[q->write_ptr].enqueue_time);
+	txq->txb[q->write_ptr].enqueue_depth = iwl_queue_space_used(q) + 1;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[q->write_ptr];
@@ -1215,6 +1217,7 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr != index;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
+		iwl_tx_queue_update_high_mark(txq, txq->q.read_ptr);
 		tx_info = &txq->txb[txq->q.read_ptr];
 		iwlagn_tx_status(priv, tx_info,
 				 txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0ec170..b97a6dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -532,6 +532,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
 void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id);
+void iwl_tx_queue_update_high_mark(struct iwl_tx_queue *txq, int index);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
 void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dc6dd5f..3b421fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -38,6 +38,7 @@
 #include <linux/leds.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/time.h>
+#include <linux/average.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-csr.h"
@@ -137,12 +138,22 @@ struct iwl_queue {
 	u32 id;
 	atomic_t high_mark;    /* high watermark -- don't queue more than this
 				* many entries */
+	struct ewma ns_per_packet; /* tracks how long it takes each packet
+				    * to be transmitted, in nanoseconds */
 };
 
+/* We attempt to find a setting for high_mark (which is measured in packets)
+ * so that no packet spends longer than this (measured in wall clock time)
+ * waiting around in the transmit queue:
+ */
+#define IWL_TX_HIGH_MARK_IN_NSEC (2 * NSEC_PER_MSEC)
+
 /* One for each TFD */
 struct iwl_tx_info {
 	struct sk_buff *skb;
 	struct iwl_rxon_context *ctx;
+	struct timespec enqueue_time;
+	int enqueue_depth;
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ce62981..07fac3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -266,6 +266,8 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	if (q->n_window - atomic_read(&q->high_mark) < 2)
 		atomic_set(&q->high_mark, q->n_window - 2);
 
+	ewma_init(&q->ns_per_packet, 1, 8);
+
 	q->write_ptr = q->read_ptr = 0;
 
 	return 0;
@@ -410,6 +412,30 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 }
 EXPORT_SYMBOL(iwl_tx_queue_reset);
 
+void iwl_tx_queue_update_high_mark(struct iwl_tx_queue *txq, int index)
+{
+	struct iwl_queue *q = &txq->q;
+	struct timespec now, diff;
+	int enqueue_depth = txq->txb[index].enqueue_depth;
+	int this_ns_per_packet, avg_ns_per_packet;
+	int new_high_mark;
+
+	getrawmonotonic(&now);
+	diff = timespec_sub(now, txq->txb[index].enqueue_time);
+	this_ns_per_packet = (NSEC_PER_SEC / enqueue_depth) * diff.tv_sec;
+	this_ns_per_packet += diff.tv_nsec / enqueue_depth;
+	/* Just some sanity checks for paranoia's sake */
+	if (this_ns_per_packet < 0 && this_ns_per_packet > NSEC_PER_SEC)
+		return;
+	ewma_add(&q->ns_per_packet, this_ns_per_packet);
+	avg_ns_per_packet = ewma_read(&q->ns_per_packet);
+	new_high_mark = IWL_TX_HIGH_MARK_IN_NSEC / avg_ns_per_packet;
+	new_high_mark = clamp(new_high_mark, 2, q->n_window - 2);
+	atomic_set(&q->high_mark, new_high_mark);
+}
+EXPORT_SYMBOL(iwl_tx_queue_update_high_mark);
+
+
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d0aa01c..a2ae4ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -548,6 +548,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb = skb;
 	txq->txb[q->write_ptr].ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	getrawmonotonic(&txq->txb[q->write_ptr].enqueue_time);
+	txq->txb[q->write_ptr].enqueue_depth = iwl_queue_space_used(q) + 1;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
-- 
1.7.1

