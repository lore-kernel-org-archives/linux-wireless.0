Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52729 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcBEPnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 10:43:14 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@qti.qualcomm.com>,
	<kvalo@qca.qualcomm.com>
Subject: [PATCH 1/2] ath10k: fix pktlog in QCA99X0
Date: Fri, 5 Feb 2016 21:12:48 +0530
Message-ID: <1454686969-5740-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160205_164317_271624_E372B487)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we are providing wrong payload data of pktlog to trace points.
Data we receive from FW through copy engine 8 contains pktlog data alone.
We don't need to parse anything in driver before handing it to trace
points.

Fixes: afb0bf7f530b ("ath10k: add support for pktlog in QCA99X0")
Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3079434..1ff04d4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2143,11 +2143,7 @@ EXPORT_SYMBOL(ath10k_htt_t2h_msg_handler);
 void ath10k_htt_rx_pktlog_completion_handler(struct ath10k *ar,
 					     struct sk_buff *skb)
 {
-	struct ath10k_pktlog_10_4_hdr *hdr =
-		(struct ath10k_pktlog_10_4_hdr *)skb->data;
-
-	trace_ath10k_htt_pktlog(ar, hdr->payload,
-				sizeof(*hdr) + __le16_to_cpu(hdr->size));
+	trace_ath10k_htt_pktlog(ar, skb->data, skb->len);
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ath10k_htt_rx_pktlog_completion_handler);
-- 
1.9.1

