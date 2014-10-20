Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35221 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaJTNyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:20 -0400
Received: by mail-lb0-f179.google.com with SMTP id l4so3908207lbv.38
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:19 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/9] ath10k: fix rx buffer tracing
Date: Mon, 20 Oct 2014 15:40:33 +0200
Message-Id: <1413812438-14640-5-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155426_345971_091BB79D)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tracing function was called before buffers were
unmapped from DMA.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ca466ce..a7d29c8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -291,9 +291,6 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
 	htt->rx_ring.fill_cnt--;
 
-	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
-				     skb_tailroom(msdu));
-
 	return msdu;
 }
 
@@ -339,6 +336,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx pop: ",
 				msdu->data, msdu->len + skb_tailroom(msdu));
+		trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
+					     skb_tailroom(msdu));
 
 		rx_desc = (struct htt_rx_desc *)msdu->data;
 
@@ -438,6 +437,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL,
 					"htt rx chained: ", next->data,
 					next->len + skb_tailroom(next));
+			trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
+						     skb_tailroom(msdu));
 
 			skb_trim(next, 0);
 			skb_put(next, min(msdu_len, HTT_RX_BUF_SIZE));
-- 
1.8.5.3

