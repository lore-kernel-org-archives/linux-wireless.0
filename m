Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34542 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbKRF7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 00:59:39 -0500
Received: by lbbcs9 with SMTP id cs9so18395282lbb.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 21:59:38 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 7/9] ath10k: fix tx header parsing
Date: Wed, 18 Nov 2015 06:59:21 +0100
Message-Id: <1447826363-16818-8-git-send-email-michal.kazior@tieto.com> (sfid-20151118_065945_776968_93FF0A20)
In-Reply-To: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
 <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames are not guaranteed to be 802.11 frames in
ath10k_htt_tx() and the tx completion handler.
In some cases, like TDLS, they can be Ethernet.
Hence checking, e.g. frame_control could yield
bogus results and behavior.

Fortunately this wasn't a real problem so far
because there's no FW/HW combination to encounter
this problem.

However it is good to fix this in advance.

Fixes: 75d85fd9993c ("ath10k: introduce basic tdls functionality")
Fixes: eebc67fef3ee ("ath10k: fix pmf for wmi-tlv on qca6174")
Fixes: 7b7da0a02192 ("ath10k: drop probe responses when too many are queued")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * introduced

 drivers/net/wireless/ath/ath10k/core.h | 1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 3 +++
 drivers/net/wireless/ath/ath10k/txrx.c | 8 ++------
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6b9b37329621..6bbd95477325 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -85,6 +85,7 @@ enum ath10k_skb_flags {
 	ATH10K_SKB_F_NO_HWCRYPT = BIT(0),
 	ATH10K_SKB_F_DTIM_ZERO = BIT(1),
 	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
+	ATH10K_SKB_F_MGMT = BIT(3),
 };
 
 struct ath10k_skb_cb {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 38c241596965..fd36200e5396 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3689,6 +3689,9 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
 		skb_cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
 
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		skb_cb->flags |= ATH10K_SKB_F_MGMT;
+
 	skb_cb->htt.tid = ath10k_tx_h_get_tid(hdr);
 	skb_cb->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 9e14c04ac89f..fbfb608e48ab 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -57,8 +57,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ieee80211_tx_info *info;
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
 	bool limit_mgmt_desc = false;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
@@ -81,10 +79,9 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr *)msdu->data;
-	fc = hdr->frame_control;
+	skb_cb = ATH10K_SKB_CB(msdu);
 
-	if (unlikely(ieee80211_is_mgmt(fc)) &&
+	if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
 	    ar->hw_params.max_probe_resp_desc_thres)
 		limit_mgmt_desc = true;
 
@@ -94,7 +91,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-	skb_cb = ATH10K_SKB_CB(msdu);
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
-- 
2.1.4

