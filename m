Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36920 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbCAGUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:16 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEd-002K5A-VD
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath9k: Remove useless return value check
Date: Sun,  1 Mar 2015 11:53:44 +0530
Message-Id: <1425191029-13667-2-git-send-email-sujith@msujith.org> (sfid-20150301_072031_660902_FD8E3EAB)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath_init_btcoex_timer() always returns 0, so
checking for error conditions is not required.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index da344b2..78695b5 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -271,7 +271,7 @@ static void ath_btcoex_no_stomp_timer(unsigned long arg)
 	ath9k_ps_restore(sc);
 }
 
-static int ath_init_btcoex_timer(struct ath_softc *sc)
+static void ath_init_btcoex_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
@@ -287,8 +287,6 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 			(unsigned long) sc);
 
 	spin_lock_init(&btcoex->btcoex_lock);
-
-	return 0;
 }
 
 /*
@@ -409,9 +407,8 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
 		ath9k_hw_btcoex_init_3wire(sc->sc_ah);
-		r = ath_init_btcoex_timer(sc);
-		if (r)
-			return -1;
+		ath_init_btcoex_timer(sc);
+
 		txq = sc->tx.txq_map[IEEE80211_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-- 
2.3.0

