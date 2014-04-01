Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43422 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaDAR5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 13:57:50 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/1] ath10k:  reset firmware if tx-flush hangs.
Date: Tue,  1 Apr 2014 10:56:58 -0700
Message-Id: <1396375018-21671-1-git-send-email-greearb@candelatech.com> (sfid-20140401_195754_570689_C26E0C13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Seems to be no other way to recover this error.

Print out some before and after counters for both the
driver and for the firmware.  If we time-out two flushes
in a row, and are not currently restarting, then restart
the NIC.

Plz do not apply this...I think the firmware is not always
to blame..need to figure out why...but this has some decent
debugging code to help track it down...

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  8 ++++
 drivers/net/wireless/ath/ath10k/htc.c    |  2 +
 drivers/net/wireless/ath/ath10k/htt.c    |  4 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  2 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |  2 +
 drivers/net/wireless/ath/ath10k/mac.c    | 76 ++++++++++++++++++++++++++++++--
 6 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e80b2f1..55cd06f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -345,6 +345,7 @@ struct ath10k {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
+	u8 tx_flush_failed; /* failure case counter */
 
 	u32 chip_id;
 	u32 target_version;
@@ -378,6 +379,13 @@ struct ath10k {
 	struct ath10k_htc htc;
 	struct ath10k_htt htt;
 
+	/* Stats to help debug tx hang issues */
+	u64 htc_send_tot;
+	u64 htc_tx;
+	u64 htc_tx_compl;
+	u64 htc_mgt_tx;
+	u64 htc_mgt_compl;
+
 	struct ath10k_hw_params {
 		u32 id;
 		const char *name;
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index bca5c41..e4fe04d 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -191,6 +191,8 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	if (ret)
 		goto err_unmap;
 
+	htc->ar->htc_send_tot++;
+
 	return 0;
 
 err_unmap:
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 69697af5..67d8e47 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -56,6 +56,10 @@ int ath10k_htt_attach(struct ath10k *ar)
 	htt->ar = ar;
 	htt->max_throughput_mbps = 800;
 
+	/* Clear some htc related counters */
+	ar->htc_send_tot = ar->htc_tx = ar->htc_tx_compl = ar->htc_mgt_tx = 0;
+	ar->htc_mgt_compl = 0;
+
 	/*
 	 * Connect to HTC service.
 	 * This has to be done before calling ath10k_htt_rx_attach,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index abe5665..928bca2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1421,6 +1421,7 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 		msdu_id = resp->data_tx_completion.msdus[i];
 		tx_done.msdu_id = __le16_to_cpu(msdu_id);
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		ar->htc_tx_compl++;
 	}
 }
 
@@ -1484,6 +1485,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 
 		spin_lock_bh(&htt->tx_lock);
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		ar->htc_mgt_compl++;
 		spin_unlock_bh(&htt->tx_lock);
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 22a4542..db0c04d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -364,6 +364,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (res)
 		goto err_unmap_msdu;
 
+	htt->ar->htc_mgt_tx++;
 	return 0;
 
 err_unmap_msdu:
@@ -521,6 +522,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (res)
 		goto err_unmap_msdu;
 
+	htt->ar->htc_tx++;
 	return 0;
 
 err_unmap_msdu:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d19022d..e4f9754 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3636,6 +3636,14 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	struct ath10k *ar = hw->priv;
 	bool skip;
 	int ret;
+	s32 hw_queued;
+	s32 hw_reaped;
+	int num_pending_tx;
+	u64 htc_send_tot;
+	u64 htc_tx;
+	u64 htc_tx_compl;
+	u64 htc_mgt_tx;
+	u64 htc_mgt_compl;
 
 	/* mac80211 doesn't care if we really xmit queued frames or not
 	 * we'll collect those frames either way if we stop/delete vdevs */
@@ -3647,6 +3655,19 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	if (ar->state == ATH10K_STATE_WEDGED)
 		goto skip;
 
+	/* Refresh firmware stats to aid debugging */
+	ath10k_refresh_peer_stats(ar);
+
+	hw_queued = ar->debug.target_stats.hw_queued;
+	hw_reaped = ar->debug.target_stats.hw_reaped;
+	num_pending_tx = ar->htt.num_pending_tx;
+
+	htc_send_tot = ar->htc_send_tot;
+	htc_tx = ar->htc_tx;
+	htc_tx_compl = ar->htc_tx_compl;
+	htc_mgt_tx = ar->htc_mgt_tx;
+	htc_mgt_compl = ar->htc_mgt_compl;
+
 	ret = wait_event_timeout(ar->htt.empty_tx_wq, ({
 			bool empty;
 
@@ -3659,9 +3680,58 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 			(empty || skip);
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 
-	if (ret <= 0 || skip)
-		ath10k_warn("failed to flush transmit queue (skip %i ar-state %i): %i\n",
-			    skip, ar->state, ret);
+	if (ret <= 0 || skip) {
+		int i;
+		/* Refresh firmware stats to aid debugging */
+		ath10k_refresh_peer_stats(ar);
+
+		ath10k_err("failed to flush transmit queue (skip %i ar-state %i pending_tx %i  pre-pending-tx: %i): %i\n",
+			   skip, ar->state, ar->htt.num_pending_tx,
+			   num_pending_tx, ret);
+		ath10k_err("pre: htc-send-tot: %llu  htt-tx %llu  tx-compl %llu  mgt-tx %llu  mgt-compl %llu\n",
+			   htc_send_tot, htc_tx, htc_tx_compl,
+			   htc_mgt_tx, htc_mgt_compl);
+		ath10k_err("post: htc-send-tot: %llu  htt-tx %llu  tx-compl %llu  mgt-tx %llu  mgt-compl %llu\n",
+			   ar->htc_send_tot, ar->htc_tx, ar->htc_tx_compl,
+			   ar->htc_mgt_tx, ar->htc_mgt_compl);
+		ath10k_err("pre: hw-queued: %d  hw-reaped: %d\n",
+			   hw_queued, hw_reaped);
+		ath10k_err("post: hw-queued: %d  hw-reaped: %d\n",
+			   ar->debug.target_stats.hw_queued,
+			   ar->debug.target_stats.hw_reaped);
+
+		for (i = 0; i < ar->htt.max_num_pending_tx; i++) {
+			int q;
+
+			if (!ar->htt.pending_tx[i])
+				continue;
+
+			ath10k_err("stuck-skb: %p len %d tx-id %d\n",
+				   ar->htt.pending_tx[i],
+				   ar->htt.pending_tx[i]->len, i);
+			/* Only print skb contents if debug data is
+			 * enabled.
+			 */
+			if (!(ath10k_debug_mask & ATH10K_DBG_DATA))
+				continue;
+			for (q = 0; q < ar->htt.pending_tx[i]->len; q++) {
+				printk("%02hx ",
+				       ar->htt.pending_tx[i]->data[q]);
+				if (((q + 1) & 0x1f) == 0x1f)
+					printk("\n");
+			}
+		}
+		if ((++ar->tx_flush_failed > 1) &&
+		    (ar->state != ATH10K_STATE_RESTARTING)) {
+			/* This does not appear recoverable, attempt reset. */
+			ath10k_err("failed to flush transmit queue %d times, attempting hardware reset.\n",
+				ar->tx_flush_failed);
+			ar->tx_flush_failed = 0;
+			queue_work(ar->workqueue, &ar->restart_work);
+		}
+	} else {
+		ar->tx_flush_failed = 0;
+	}
 
 skip:
 	mutex_unlock(&ar->conf_mutex);
-- 
1.7.11.7

