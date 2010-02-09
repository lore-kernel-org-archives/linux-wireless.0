Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34021 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0BIESq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 23:18:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 20:18:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19312.58988.209439.469789@gargle.gargle.HOWL>
Date: Tue, 9 Feb 2010 10:07:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <nbd@openwrt.org>
Subject: [PATCH] ath9k: Fix sequence numbers for PAE frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, PAE frames are not assigned proper sequence numbers.
Since sending PAE frames as part of aggregates breaks
crupto with several APs, they are sent as normal MPDUs.
Fix the seqeuence number issue by updating the frame with the
internal sequence number.

Tested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f5cbbcb..47294f9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1610,7 +1610,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_frmlen -= padsize;
 	}
 
-	if (conf_is_ht(&hw->conf) && !is_pae(skb))
+	if (conf_is_ht(&hw->conf))
 		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
@@ -1696,7 +1696,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			goto tx_done;
 		}
 
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && !is_pae(skb)) {
 			/*
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.
-- 
1.6.6.1

