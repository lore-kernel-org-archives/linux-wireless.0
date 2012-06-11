Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2FKGtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:49:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 9/9] ath9k: keep btcoex period in milliseconds
Date: Mon, 11 Jun 2012 12:19:37 +0530
Message-ID: <1339397377-3374-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_084936_220627_E751030F)
In-Reply-To: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

btcoex periord is converted into micro seconds during initialization
and converted back to milli seconds while starting timer. As MCI code
handles btcoex period in msec, lets keep the btcoex timer in msec and
convert them into other form whenever needed.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/mci.c  |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index af6d273..00ff5ab 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -232,7 +232,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	}
 
 	ath9k_ps_restore(sc);
-	timer_period = btcoex->btcoex_period / 1000;
+	timer_period = btcoex->btcoex_period;
 	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
 }
 
@@ -267,10 +267,10 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
-	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) * 1000 *
 		btcoex->btcoex_period / 100;
-	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
+	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) * 1000 *
 				   btcoex->btcoex_period / 100;
 
 	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 2ea5e93..92d61cc 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -182,8 +182,7 @@ skip_tuning:
 	if (btcoex->duty_cycle > ATH_MCI_MAX_DUTY_CYCLE)
 		btcoex->duty_cycle = ATH_MCI_MAX_DUTY_CYCLE;
 
-	btcoex->btcoex_period *= 1000;
-	btcoex->btcoex_no_stomp =  btcoex->btcoex_period *
+	btcoex->btcoex_no_stomp =  btcoex->btcoex_period * 1000 *
 		(100 - btcoex->duty_cycle) / 100;
 
 	ath9k_hw_btcoex_enable(sc->sc_ah);
-- 
1.7.10.4

