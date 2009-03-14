Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13271 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZCNOd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 10:33:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 07:33:27 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Keep LED on in idle state after association
Date: Sat, 14 Mar 2009 19:59:41 +0530
Message-ID: <1237040981-4391-1-git-send-email-vasanth@atheros.com> (sfid-20090314_153331_979990_502BA7CE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8db75f6..b14c4d9 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -940,18 +940,25 @@ static void ath_led_blink_work(struct work_struct *work)
 
 	if (!(sc->sc_flags & SC_OP_LED_ASSOCIATED))
 		return;
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
-			  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
+
+	if ((sc->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
+	    (sc->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+	else
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+				  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
 
 	queue_delayed_work(sc->hw->workqueue, &sc->ath_led_blink_work,
 			   (sc->sc_flags & SC_OP_LED_ON) ?
 			   msecs_to_jiffies(sc->led_off_duration) :
 			   msecs_to_jiffies(sc->led_on_duration));
 
-	sc->led_on_duration =
-			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25);
-	sc->led_off_duration =
-			max((ATH_LED_OFF_DURATION_IDLE - sc->led_off_cnt), 10);
+	sc->led_on_duration = sc->led_on_cnt ?
+			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25) :
+			ATH_LED_ON_DURATION_IDLE;
+	sc->led_off_duration = sc->led_off_cnt ?
+			max((ATH_LED_OFF_DURATION_IDLE - sc->led_off_cnt), 10) :
+			ATH_LED_OFF_DURATION_IDLE;
 	sc->led_on_cnt = sc->led_off_cnt = 0;
 	if (sc->sc_flags & SC_OP_LED_ON)
 		sc->sc_flags &= ~SC_OP_LED_ON;
-- 
1.5.5.1

