Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38368 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3EFElY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 00:41:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix beacon reconfiguration
Date: Mon,  6 May 2013 10:09:03 +0530
Message-Id: <1367815143-7913-1-git-send-email-sujith@msujith.org> (sfid-20130506_064129_218723_EF92E300)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a reset or a channel-change happens, for managed mode,
the HW beacon timers have to be programmed after the TSF has
been synchronized. This is handled via the sync flags.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c4fc3d1..a18414b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -227,13 +227,13 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
 			goto work;
 
-		ath9k_set_beacon(sc);
-
 		if (ah->opmode == NL80211_IFTYPE_STATION &&
 		    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
 			spin_lock_irqsave(&sc->sc_pm_lock, flags);
 			sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+		} else {
+			ath9k_set_beacon(sc);
 		}
 	work:
 		ath_restart_work(sc);
-- 
1.8.2.2

