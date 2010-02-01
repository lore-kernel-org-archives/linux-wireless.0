Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50763 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab0BAErO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 23:47:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2010 20:47:14 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19302.24837.154697.822430@gargle.gargle.HOWL>
Date: Mon, 1 Feb 2010 10:35:09 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix PAE frame handling
In-Reply-To: <4B65F735.1020509@openwrt.org>
References: <4B65F735.1020509@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> ath9k's tx handling code contains a special case for PAE frames, which
> looks like it was intended to be improving reliability by excluding
> them from aggregates.
> What it actually did is the opposite: By assigning a faulty sequence
> number, yet still keeping it as a qos-frame, it caused bogus packet
> reordering, which broke WPA rekeying.
> The special case handling is completely unnecessary, so this patch
> removes it.

Sending PAE frames as part of an aggregate broke crypto with several APs.
Assigning the correct seq. number should work, no ?

Something like the patch below. Can you check if it fixes your issue ?
Though, removing the seq. number mess in the driver would be great. :D


diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a6893cf..cb6d982 100644
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
