Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33379 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbKJNNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 08:13:10 -0500
Received: by lbbkw15 with SMTP id kw15so113665469lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2015 05:13:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 5/9] ath10k: remove freq from skb_cb
Date: Tue, 10 Nov 2015 14:10:51 +0100
Message-Id: <1447161055-2283-6-git-send-email-michal.kazior@tieto.com> (sfid-20151110_141350_105230_F5445B03)
In-Reply-To: <1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
 <1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was wasteful to keep it in the struct.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   | 1 -
 drivers/net/wireless/ath/ath10k/htt_tx.c | 9 +++++++--
 drivers/net/wireless/ath/ath10k/mac.c    | 5 +----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 344849dd93c8..3706b0d235ca 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -88,7 +88,6 @@ struct ath10k_skb_cb {
 
 	struct {
 		u8 tid;
-		u16 freq;
 		bool nohwcrypt;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index e9ab0c9075c2..51c40d52bbe9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -538,6 +538,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
 	struct htt_data_tx_desc_frag *frags;
@@ -547,6 +548,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	int res;
 	u8 flags0 = 0;
 	u16 msdu_id, flags1 = 0;
+	u16 freq = 0;
 	u32 frags_paddr = 0;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
 	bool limit_mgmt_desc = false;
@@ -598,6 +600,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 		goto err_free_msdu_id;
 	}
 
+	if (unlikely(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN))
+		freq = ar->scan.roc_freq;
+
 	switch (txmode) {
 	case ATH10K_HW_TXRX_RAW:
 	case ATH10K_HW_TXRX_NATIVE_WIFI:
@@ -687,13 +692,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	skb_cb->htt.txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
 	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
 	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le16(HTT_INVALID_PEERID);
-	skb_cb->htt.txbuf->cmd_tx.freq = __cpu_to_le16(skb_cb->htt.freq);
+	skb_cb->htt.txbuf->cmd_tx.freq = __cpu_to_le16(freq);
 
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu freq %hu\n",
 		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
-		   (u32)skb_cb->paddr, vdev_id, tid, skb_cb->htt.freq);
+		   (u32)skb_cb->paddr, vdev_id, tid, freq);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
 			msdu->data, msdu->len);
 	trace_ath10k_tx_hdr(ar, msdu->data, msdu->len);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f7e4fba63b44..3abd684ccd1b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3524,6 +3524,7 @@ void __ath10k_scan_finish(struct ath10k *ar)
 	case ATH10K_SCAN_STARTING:
 		ar->scan.state = ATH10K_SCAN_IDLE;
 		ar->scan_channel = NULL;
+		ar->scan.roc_freq = 0;
 		ath10k_offchan_tx_purge(ar);
 		cancel_delayed_work(&ar->scan.timeout);
 		complete_all(&ar->scan.completed);
@@ -3679,7 +3680,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 
-	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
@@ -3704,13 +3704,10 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		spin_lock_bh(&ar->data_lock);
-		ATH10K_SKB_CB(skb)->htt.freq = ar->scan.roc_freq;
 		ATH10K_SKB_CB(skb)->vdev_id = ar->scan.vdev_id;
 		spin_unlock_bh(&ar->data_lock);
 
 		if (ath10k_mac_need_offchan_tx_work(ar)) {
-			ATH10K_SKB_CB(skb)->htt.freq = 0;
-
 			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
 				   skb);
 
-- 
2.1.4

