Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33501 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0LGPLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:11:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:10:54 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v2] ath9k: Properly use unlikely check macro
Date: Tue, 7 Dec 2010 20:40:58 +0530
Message-ID: <1291734658-3311-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

AUTOSLEEP feature is enabled only for AR9271 and AR9003 version
chipsets.So unlikely macro should be used only to check whether
auto-sleep feature is enabled

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 262c815..46020ce 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1743,10 +1743,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		}
 
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if (unlikely(ath9k_check_auto_sleep(sc) ||
-			     (sc->ps_flags & (PS_WAIT_FOR_BEACON |
+
+		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					      PS_WAIT_FOR_CAB |
-					      PS_WAIT_FOR_PSPOLL_DATA))))
+					      PS_WAIT_FOR_PSPOLL_DATA)) ||
+					unlikely(ath9k_check_auto_sleep(sc)))
 			ath_rx_ps(sc, skb);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-- 
1.7.0.4

