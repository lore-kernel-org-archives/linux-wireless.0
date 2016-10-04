Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26140 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752297AbcJDPuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:50:14 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: Cleanup calling ath10k_htt_rx_h_unchain
Date: Tue, 4 Oct 2016 21:19:59 +0530
Message-ID: <1475596199-4563-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161004_175017_683984_70CAF2E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

'ath10k_htt_rx_h_unchain' needs to be called only if the return
value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this
change makes it more explicit and avoids doing a skb_peek, fetching
rx descriptor pointer, checking rx msdu decap format for the case of
ret = 0 (unchained msdus). Found this change during code walk through,
not sure if this addresses any issue.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[v2 rebased over top of master tree]

 drivers/net/wireless/ath/ath10k/htt_rx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0b4c156..285b235 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1463,8 +1463,7 @@ static int ath10k_unchain_msdu(struct sk_buff_head *amsdu)
 }
 
 static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
-				    struct sk_buff_head *amsdu,
-				    bool chained)
+				    struct sk_buff_head *amsdu)
 {
 	struct sk_buff *first;
 	struct htt_rx_desc *rxd;
@@ -1475,9 +1474,6 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 	decap = MS(__le32_to_cpu(rxd->msdu_start.common.info1),
 		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
-	if (!chained)
-		return;
-
 	/* FIXME: Current unchaining logic can only handle simple case of raw
 	 * msdu chaining. If decapping is other than raw the chaining may be
 	 * more complex and this isn't handled by the current code. Don't even
@@ -1555,7 +1551,11 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 
 	num_msdus = skb_queue_len(&amsdu);
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
1.7.9.5
