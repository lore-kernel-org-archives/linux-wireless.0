Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12433 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2HaOgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 10:36:21 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: update hw_timer_enabled to false when we stop generic timers
Date: Fri, 31 Aug 2012 20:06:12 +0530
Message-ID: <1346423772-9253-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120831_163625_683989_337376E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Update the 'hw_timer_enabled' to 'false' wherever we are stopping
hardware generic timers, excecpt the case where we start them
again immediately. I will just test the case the generic hardware
timer is stopped again and again even though they had been already
stopped.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index bacdb8f..9e3471c 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -309,8 +309,10 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
 	/* make sure duty cycle timer is also stopped when resuming */
-	if (btcoex->hw_timer_enabled)
+	if (btcoex->hw_timer_enabled) {
 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+		btcoex->hw_timer_enabled = false;
+	}
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
@@ -341,7 +343,10 @@ void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+	if (btcoex->hw_timer_enabled)
+		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+
+	btcoex->hw_timer_enabled = false;
 }
 
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
-- 
1.7.0.4

