Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46998 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab3IRMnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:43:33 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/5] ath10k: cleanup HTT TX functions
Date: Wed, 18 Sep 2013 14:43:21 +0200
Message-ID: <1379508202-9660-5-git-send-email-michal.kazior@tieto.com> (sfid-20130918_144337_089032_91426F53)
In-Reply-To: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
References: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a saner goto scheme for failure handling. Also
group operations more sensibly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c |  141 ++++++++++++++----------------
 1 file changed, 68 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 06946d2..5e738d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -315,30 +315,30 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
-		return res;
+		goto err;
 
 	len += sizeof(cmd->hdr);
 	len += sizeof(cmd->mgmt_tx);
 
-	txdesc = ath10k_htc_alloc_skb(len);
-	if (!txdesc) {
-		res = -ENOMEM;
-		goto err;
-	}
-
 	spin_lock_bh(&htt->tx_lock);
-	msdu_id = ath10k_htt_tx_alloc_msdu_id(htt);
-	if (msdu_id < 0) {
+	res = ath10k_htt_tx_alloc_msdu_id(htt);
+	if (res < 0) {
 		spin_unlock_bh(&htt->tx_lock);
-		res = msdu_id;
-		goto err;
+		goto err_tx_dec;
 	}
+	msdu_id = res;
 	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
+	txdesc = ath10k_htc_alloc_skb(len);
+	if (!txdesc) {
+		res = -ENOMEM;
+		goto err_free_msdu_id;
+	}
+
 	res = ath10k_skb_map(dev, msdu);
 	if (res)
-		goto err;
+		goto err_free_txdesc;
 
 	skb_put(txdesc, len);
 	cmd = (struct htt_cmd *)txdesc->data;
@@ -352,22 +352,22 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
-		goto err;
+		goto err_unmap_msdu;
 
 	return 0;
 
-err:
+err_unmap_msdu:
 	ath10k_skb_unmap(dev, msdu);
-
-	if (txdesc)
-		dev_kfree_skb_any(txdesc);
-	if (msdu_id >= 0) {
-		spin_lock_bh(&htt->tx_lock);
-		htt->pending_tx[msdu_id] = NULL;
-		ath10k_htt_tx_free_msdu_id(htt, msdu_id);
-		spin_unlock_bh(&htt->tx_lock);
-	}
+err_free_txdesc:
+	dev_kfree_skb_any(txdesc);
+err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
+	htt->pending_tx[msdu_id] = NULL;
+	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
+err_tx_dec:
 	ath10k_htt_tx_dec_pending(htt);
+err:
 	return res;
 }
 
@@ -379,6 +379,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct sk_buff *txdesc = NULL;
 	struct sk_buff *txfrag = NULL;
+	bool use_frags;
 	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
 	u8 tid;
 	int prefetch_len, desc_len, frag_len;
@@ -390,7 +391,17 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
-		return res;
+		goto err;
+
+	spin_lock_bh(&htt->tx_lock);
+	res = ath10k_htt_tx_alloc_msdu_id(htt);
+	if (res < 0) {
+		spin_unlock_bh(&htt->tx_lock);
+		goto err_tx_dec;
+	}
+	msdu_id = res;
+	htt->pending_tx[msdu_id] = msdu;
+	spin_unlock_bh(&htt->tx_lock);
 
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
@@ -401,46 +412,34 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	txdesc = ath10k_htc_alloc_skb(desc_len);
 	if (!txdesc) {
 		res = -ENOMEM;
-		goto err;
+		goto err_free_msdu_id;
 	}
 
 	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
 	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
 	 * fragment list host driver specifies directly frame pointer. */
-	if (htt->target_version_major < 3 ||
-	    !ieee80211_is_mgmt(hdr->frame_control)) {
+	use_frags = htt->target_version_major < 3 ||
+		    !ieee80211_is_mgmt(hdr->frame_control);
+
+	if (use_frags) {
 		txfrag = dev_alloc_skb(frag_len);
 		if (!txfrag) {
 			res = -ENOMEM;
-			goto err;
+			goto err_free_txdesc;
 		}
 	}
 
 	if (!IS_ALIGNED((unsigned long)txdesc->data, 4)) {
 		ath10k_warn("htt alignment check failed. dropping packet.\n");
 		res = -EIO;
-		goto err;
+		goto err_free_txfrag;
 	}
 
-	spin_lock_bh(&htt->tx_lock);
-	msdu_id = ath10k_htt_tx_alloc_msdu_id(htt);
-	if (msdu_id < 0) {
-		spin_unlock_bh(&htt->tx_lock);
-		res = msdu_id;
-		goto err;
-	}
-	htt->pending_tx[msdu_id] = msdu;
-	spin_unlock_bh(&htt->tx_lock);
-
 	res = ath10k_skb_map(dev, msdu);
 	if (res)
-		goto err;
+		goto err_free_txfrag;
 
-	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
-	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
-	 * fragment list host driver specifies directly frame pointer. */
-	if (htt->target_version_major < 3 ||
-	    !ieee80211_is_mgmt(hdr->frame_control)) {
+	if (use_frags) {
 		/* tx fragment list must be terminated with zero-entry */
 		skb_put(txfrag, frag_len);
 		tx_frags = (struct htt_data_tx_desc_frag *)txfrag->data;
@@ -451,7 +450,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 		res = ath10k_skb_map(dev, txfrag);
 		if (res)
-			goto err;
+			goto err_unmap_msdu;
 
 		ath10k_dbg(ATH10K_DBG_HTT, "txfrag 0x%llx\n",
 			   (unsigned long long) ATH10K_SKB_CB(txfrag)->paddr);
@@ -476,15 +475,11 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 	flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
 
-	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
-	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
-	 * fragment list host driver specifies directly frame pointer. */
-	if (htt->target_version_major >= 3 &&
-	    ieee80211_is_mgmt(hdr->frame_control))
-		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
+	if (use_frags)
+		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
 			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 	else
-		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
+		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
 			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 
 	flags1  = 0;
@@ -493,14 +488,10 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 
-	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
-	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
-	 * fragment list host driver specifies directly frame pointer. */
-	if (htt->target_version_major >= 3 &&
-	    ieee80211_is_mgmt(hdr->frame_control))
-		frags_paddr = ATH10K_SKB_CB(msdu)->paddr;
-	else
+	if (use_frags)
 		frags_paddr = ATH10K_SKB_CB(txfrag)->paddr;
+	else
+		frags_paddr = ATH10K_SKB_CB(msdu)->paddr;
 
 	cmd->hdr.msg_type        = HTT_H2T_MSG_TYPE_TX_FRM;
 	cmd->data_tx.flags0      = flags0;
@@ -514,23 +505,27 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
-		goto err;
+		goto err_restore;
 
 	return 0;
-err:
-	if (txfrag)
+
+err_restore:
+	if (use_frags)
 		ath10k_skb_unmap(dev, txfrag);
-	if (txdesc)
-		dev_kfree_skb_any(txdesc);
-	if (txfrag)
+err_unmap_msdu:
+	ath10k_skb_unmap(dev, msdu);
+err_free_txfrag:
+	if (use_frags)
 		dev_kfree_skb_any(txfrag);
-	if (msdu_id >= 0) {
-		spin_lock_bh(&htt->tx_lock);
-		htt->pending_tx[msdu_id] = NULL;
-		ath10k_htt_tx_free_msdu_id(htt, msdu_id);
-		spin_unlock_bh(&htt->tx_lock);
-	}
+err_free_txdesc:
+	dev_kfree_skb_any(txdesc);
+err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
+	htt->pending_tx[msdu_id] = NULL;
+	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
+err_tx_dec:
 	ath10k_htt_tx_dec_pending(htt);
-	ath10k_skb_unmap(dev, msdu);
+err:
 	return res;
 }
-- 
1.7.9.5

