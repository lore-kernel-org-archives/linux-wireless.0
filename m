Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39990 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbcI0NBj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 09:01:39 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v4] ath10k: Cleanup calling ath10k_htt_rx_h_unchain
Date: Tue, 27 Sep 2016 18:31:40 +0530
Message-ID: <1474981300-15945-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160927_150143_078938_12A94E3E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

'ath10k_htt_rx_h_unchain' is need to be called only if the return
value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this
change makes it more explicit and avoids doing a skb_peek, fetching
rx descriptor pointer, checking rx msdu decap format for the case of
ret = 0 (unchained msdus). Found this change during code walk through,
not sure if this addresses any issue.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7ae9349..e51dace 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1459,8 +1459,7 @@ static int ath10k_unchain_msdu(struct sk_buff_head *amsdu)
 }
 
 static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
-				    struct sk_buff_head *amsdu,
-				    bool chained)
+				    struct sk_buff_head *amsdu)
 {
 	struct sk_buff *first;
 	struct htt_rx_desc *rxd;
@@ -1471,9 +1470,6 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 	decap = MS(__le32_to_cpu(rxd->msdu_start.common.info1),
 		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
-	if (!chained)
-		return;
-
 	/* FIXME: Current unchaining logic can only handle simple case of raw
 	 * msdu chaining. If decapping is other than raw the chaining may be
 	 * more complex and this isn't handled by the current code. Don't even
@@ -1550,7 +1546,11 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	}
 
 	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
-	ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
+
+	/* only for ret = 1 indicates chained msdus */
+	if (ret > 0)
+		ath10k_htt_rx_h_unchain(ar, &amsdu);
+
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
-- 
1.9.1
