Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48639 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaKXOLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:11:09 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12426001wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:11:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: fix offchan reliability
Date: Mon, 24 Nov 2014 14:58:31 +0100
Message-Id: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com> (sfid-20141124_151115_533867_E71328BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware revisions don't need peer creation
when doing offchannel tx. Earlier revisions would
queue and never release frames without a peer.

This prevent new firmware revisions from stopping
replenishing wmi-htc tx credits and improves
reliability of offchannel tx which would sometimes
silently fail.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/htt.h    |  4 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  7 ++++---
 drivers/net/wireless/ath/ath10k/mac.c    | 29 +++++++++++++++++++++++------
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..c510785 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -83,6 +83,7 @@ struct ath10k_skb_cb {
 
 	struct {
 		u8 tid;
+		u16 freq;
 		bool is_offchan;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 15c58e8..17ca6ac 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -126,6 +126,7 @@ enum htt_data_tx_ext_tid {
  *                  (HL hosts manage queues on the host )
  *       more_in_batch: only for HL hosts. indicates if more packets are
  *                      pending. this allows target to wait and aggregate
+ *       freq: 0 means home channel of given vdev. intended for offchannel
  */
 struct htt_data_tx_desc {
 	u8 flags0; /* %HTT_DATA_TX_DESC_FLAGS0_ */
@@ -133,7 +134,8 @@ struct htt_data_tx_desc {
 	__le16 len;
 	__le16 id;
 	__le32 frags_paddr;
-	__le32 peerid;
+	__le16 peerid;
+	__le16 freq;
 	u8 prefetch[0]; /* start of frame, for FW classification engine */
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5b7e42f..4bc51d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -554,13 +554,14 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.txbuf->cmd_tx.len = __cpu_to_le16(msdu->len);
 	skb_cb->htt.txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
 	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
-	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le32(HTT_INVALID_PEERID);
+	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le16(HTT_INVALID_PEERID);
+	skb_cb->htt.txbuf->cmd_tx.freq = __cpu_to_le16(skb_cb->htt.freq);
 
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu\n",
+		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu freq %hu\n",
 		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
-		   (u32)skb_cb->paddr, vdev_id, tid);
+		   (u32)skb_cb->paddr, vdev_id, tid, skb_cb->htt.freq);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
 	trace_ath10k_tx_hdr(ar, msdu->data, msdu->len);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1245ac8..8deae4d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1997,6 +1997,18 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 	}
 }
 
+static bool ath10k_mac_need_offchan_tx_work(struct ath10k *ar)
+{
+	/* FIXME: Not really sure since when the behaviour changed. At some
+	 * point new firmware stopped requiring creation of peer entries for
+	 * offchannel tx (and actually creating them causes issues with wmi-htc
+	 * tx credit replenishment and reliability). Assuming it's at least 3.4
+	 * because that's when the `freq` was introduced to TX_FRM HTT command.
+	 */
+	return !(ar->htt.target_version_major >= 3 &&
+		 ar->htt.target_version_minor >= 4);
+}
+
 static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -2341,16 +2353,21 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		spin_lock_bh(&ar->data_lock);
-		ATH10K_SKB_CB(skb)->htt.is_offchan = true;
+		ATH10K_SKB_CB(skb)->htt.freq = ar->scan.roc_freq;
 		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
 		spin_unlock_bh(&ar->data_lock);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
-			   skb);
+		if (ath10k_mac_need_offchan_tx_work(ar)) {
+			ATH10K_SKB_CB(skb)->htt.freq = 0;
+			ATH10K_SKB_CB(skb)->htt.is_offchan = true;
 
-		skb_queue_tail(&ar->offchan_tx_queue, skb);
-		ieee80211_queue_work(hw, &ar->offchan_tx_work);
-		return;
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
+				   skb);
+
+			skb_queue_tail(&ar->offchan_tx_queue, skb);
+			ieee80211_queue_work(hw, &ar->offchan_tx_work);
+			return;
+		}
 	}
 
 	ath10k_tx_htt(ar, skb);
-- 
1.8.5.3

