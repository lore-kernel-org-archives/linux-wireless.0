Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2INNOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 09:14:09 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: update hw_timer_enabled to false when we stop generic timers
Date: Fri, 14 Sep 2012 18:43:58 +0530
Message-ID: <1347628438-17220-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120914_151415_901200_C47D05AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Update the 'hw_timer_enabled' to 'false' wherever we are stopping
hardware generic timers, excecpt the case where we start them
again immediately.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 45f2422..8aeb4a2 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -314,8 +314,10 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
 	/* make sure duty cycle timer is also stopped when resuming */
-	if (btcoex->hw_timer_enabled)
+	if (btcoex->hw_timer_enabled) {
 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+		btcoex->hw_timer_enabled = false;
+	}
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
@@ -336,18 +338,20 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 
 	del_timer_sync(&btcoex->period_timer);
 
-	if (btcoex->hw_timer_enabled)
+	if (btcoex->hw_timer_enabled) {
 		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
-
-	btcoex->hw_timer_enabled = false;
+		btcoex->hw_timer_enabled = false;
+	}
 }
 
 void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	if (btcoex->hw_timer_enabled)
+	if (btcoex->hw_timer_enabled) {
 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+		btcoex->hw_timer_enabled = false;
+	}
 }
 
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
-- 
1.7.0.4

