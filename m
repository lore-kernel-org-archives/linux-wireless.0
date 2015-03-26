Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36022 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbCZJ75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 05:59:57 -0400
Received: by labe2 with SMTP id e2so41087008lab.3
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 02:59:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: clear htt.freq
Date: Thu, 26 Mar 2015 09:57:07 +0000
Message-Id: <1427363827-24125-1-git-send-email-michal.kazior@tieto.com> (sfid-20150326_110001_559898_4D58CBC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If htt.freq isn't cleared and contains garbage fw
may discard tx packets. Prevent this from
happening by clearing htt.freq properly.

Possible manifestation of the problem could be not
being able to send auth request/response frames on
firmware with HTT >= 3.4 (when freq param was
introduced), e.g. on qca6174.

Fixes: 8d6d36243610 ("ath10k: fix offchan reliability")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9b8313dcb888..36a244187b9c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2927,6 +2927,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ath10k_dbg(ar, ATH10K_DBG_MAC, "IEEE80211_TX_CTL_NO_CCK_RATE\n");
 
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
+	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 
-- 
2.1.4

