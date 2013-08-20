Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60505 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3HTEjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 00:39:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Enable PLL fix only for AR9340/AR9330
Date: Tue, 20 Aug 2013 10:05:59 +0530
Message-Id: <1376973359-4072-1-git-send-email-sujith@msujith.org> (sfid-20130820_063946_251023_4036FE92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The PLL hang workaround is required only for AR9330 and
AR9340. This issue was first observed on an AP121 and the WAR
is enabled for AR9340 also (DB120 etc.), since it uses a PLL
design identical to AR9330. This is not required for AR9485 and AR9550.

Various bugs have been reported regarding this:

https://bugzilla.redhat.com/show_bug.cgi?id=997217
https://bugzilla.redhat.com/show_bug.cgi?id=994648

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ac9f18f..e4f6590 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -173,8 +173,7 @@ static void ath_restart_work(struct ath_softc *sc)
 {
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9485(sc->sc_ah) ||
-	    AR_SREV_9550(sc->sc_ah))
+	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9330(sc->sc_ah))
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
 
-- 
1.8.3.4

