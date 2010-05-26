Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35449 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0EZSHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:07:09 -0400
Received: by pwi7 with SMTP id 7so319453pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:07:08 -0700 (PDT)
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linville@tuxdriver.com
Cc: arnd@arndnet.de, linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH][RESEND] ath9k: Fix ath_print in xmit for hardware reset.
Date: Wed, 26 May 2010 11:00:04 -0700
Message-Id: <1274896804-19441-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_print in xmit.c should say "Reseting hardware"
instead of Resetting HAL!(since HAL is being fazed out).
dmesg shows:
[ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3db1917..09cb13c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		int r;
 
 		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to stop TxDMA. Reset HAL!\n");
+			  "Failed to stop TX DMA. Resetting hardware!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
-- 
1.6.5.GIT

