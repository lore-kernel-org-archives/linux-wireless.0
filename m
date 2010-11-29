Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56229 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0K2P2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:28:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 07:27:51 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Properly use unlikely check macro
Date: Mon, 29 Nov 2010 20:57:57 +0530
Message-ID: <1291044477-2317-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

AUTOSLEEP feature is enabled only AR9003 and later chips.So unlikely
macro should be used only to check whether auto-sleep feature is enabled

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 262c815..751ee1b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1743,10 +1743,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		}
 
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if (unlikely(ath9k_check_auto_sleep(sc) ||
-			     (sc->ps_flags & (PS_WAIT_FOR_BEACON |
+		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					      PS_WAIT_FOR_CAB |
-					      PS_WAIT_FOR_PSPOLL_DATA))))
+					      PS_WAIT_FOR_PSPOLL_DATA)) ||
+				unlikely(ath9k_hw_check_auto_sleep(sc)))
 			ath_rx_ps(sc, skb);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-- 
1.7.0.4

