Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43044 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755650AbeFOME3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 08:04:29 -0400
Received: by mail-lf0-f65.google.com with SMTP id n15-v6so14255045lfn.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2018 05:04:28 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] ath10k: fix bug in masking of TID value
Date: Fri, 15 Jun 2018 14:01:53 +0200
Message-Id: <20180615120153.4677-1-erik.stromdahl@gmail.com> (sfid-20180615_140433_237575_B4A21080)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although the TID mask is 0xf, the modulus operation does still not
produce identical results as the bitwise and operator.

If the TID is 15, the modulus operation will "convert" it to 0, whereas
the bitwise and will keep it as 15.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 89157c5b5e5f..be5b52aaffa6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1056,7 +1056,7 @@ static u8 ath10k_htt_tx_get_tid(struct sk_buff *skb, bool is_eth)
 	if (!is_eth && ieee80211_is_mgmt(hdr->frame_control))
 		return HTT_DATA_TX_EXT_TID_MGMT;
 	else if (cb->flags & ATH10K_SKB_F_QOS)
-		return skb->priority % IEEE80211_QOS_CTL_TID_MASK;
+		return skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	else
 		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
 }
-- 
2.17.0
