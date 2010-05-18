Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19733 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0ERB5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 21:57:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 18:57:54 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Fix power save with auto sleeping
Date: Mon, 17 May 2010 18:57:55 -0700
Message-ID: <1274147876-9228-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
References: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx should not be disabed/disabled when hw supports auto sleeping.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 893b552..53e9c8f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1296,7 +1296,8 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		 * completed and if needed, also for RX of buffered frames.
 		 */
 		ath9k_ps_wakeup(sc);
-		ath9k_hw_setrxabort(sc->sc_ah, 0);
+		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+			ath9k_hw_setrxabort(sc->sc_ah, 0);
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
 			ath_print(common, ATH_DBG_PS,
 				  "Sending PS-Poll to pick a buffered frame\n");
@@ -1560,8 +1561,8 @@ void ath9k_enable_ps(struct ath_softc *sc)
 			ah->imask |= ATH9K_INT_TIM_TIMER;
 			ath9k_hw_set_interrupts(ah, ah->imask);
 		}
+		ath9k_hw_setrxabort(ah, 1);
 	}
-	ath9k_hw_setrxabort(ah, 1);
 }
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
-- 
1.7.0.4

