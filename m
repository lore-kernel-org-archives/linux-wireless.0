Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35728 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbeAQKOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 05:14:11 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, stijn@linux-ipv6.be
Subject: [PATCH] ath9k: discard undersized packets
Date: Wed, 17 Jan 2018 11:14:05 +0100
Message-Id: <20180117101405.16700-1-nbd@nbd.name> (sfid-20180117_111415_581150_38C2EF19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the hardware will push small packets that trigger a WARN_ON
in mac80211. Discard them early to avoid this issue.

Reported-by: Stijn Tintel <stijn@linux-ipv6.be>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2197aee2bb72..a8ac42c96d71 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -826,9 +826,9 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	sc->rx.discard_next = false;
 
 	/*
-	 * Discard zero-length packets.
+	 * Discard zero-length packets and packets smaller than an ACK
 	 */
-	if (!rx_stats->rs_datalen) {
+	if (rx_stats->rs_datalen < 10) {
 		RX_STAT_INC(rx_len_err);
 		goto corrupt;
 	}
-- 
2.14.2
