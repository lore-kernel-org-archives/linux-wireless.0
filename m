Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23160 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZLNJYN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 04:24:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 01:24:13 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.1260.299617.483145@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 14:57:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] ath9k: Fix TX queue draining
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When TX DMA termination has failed, the HW has to be reset
completely. Doing a fast channel change in this case is insufficient.
Also, change the debug level of a couple of messages to FATAL.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 71b84d9..efc420c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -186,7 +186,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				ath_print(common, ATH_DBG_QUEUE,
+				ath_print(common, ATH_DBG_FATAL,
 					  "Failed to stop TX DMA in 100 "
 					  "msec after killing last frame\n");
 				break;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c56f4ac..298156b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1108,11 +1108,11 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	if (npend) {
 		int r;
 
-		ath_print(common, ATH_DBG_XMIT,
+		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
+		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
-- 
1.6.5.6

