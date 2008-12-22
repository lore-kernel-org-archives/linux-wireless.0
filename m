Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48951 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbYLVOqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 09:46:07 -0500
Date: Mon, 22 Dec 2008 16:45:54 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Revert fix to TX status reporting for retries and
	MCS index
Message-ID: <20081222144554.GA16264@jm.kir.nu> (sfid-20081222_154617_864505_C2A50E07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reverts commit 17a0d0d402b9ea64c1097ef61b63250b7506669f
because that change ended up breaking ath9k rate control. While the
MCS index reporting to mac80211 was indeed fixed by the patch, it did
not take into account that the ath9k rate control algorithm was
updating private tables based on this index and the index comes
through the rate control API call, i.e., based on mac80211 TX status
call. In addition, it looks like the "fix" to remove +1 from TX status
'count' field was not correct based on ieee80211_tx_status()
implementation that counts the total of count values, but starting
from -1, not 0.

The TX status reporting for frames using MCS needs to be fixed
somehow, but it does not look like there is any easy fix for the ath9k
rate control algorithm, so the best option now seems to be to revert the
change and bring it back once the rate control code is cleaned up to
handle this better.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2008-12-22 16:29:29.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2008-12-22 16:29:33.000000000 +0200
@@ -126,15 +126,7 @@ static void ath_tx_complete(struct ath_s
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	tx_info->status.rates[0].count = tx_status->retries;
-	if (tx_info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
-		/* Change idx from internal table index to MCS index */
-		int idx = tx_info->status.rates[0].idx;
-		struct ath_rate_table *rate_table = sc->cur_rate_table;
-		if (idx >= 0 && idx < rate_table->rate_cnt)
-			tx_info->status.rates[0].idx =
-				rate_table->info[idx].ratecode & 0x7f;
-	}
+	tx_info->status.rates[0].count = tx_status->retries + 1;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	padsize = hdrlen & 3;

-- 
Jouni Malinen                                            PGP id EFC895FA
