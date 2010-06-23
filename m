Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62929 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0FWGif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 02:38:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 23:38:35 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix the LED behaviour in idle unassociated state.
Date: Wed, 23 Jun 2010 12:08:29 +0530
Message-ID: <1277275109-4662-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LED should be ON when the radio is put into FULL SLEEP mode during the idle
unassociated state.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5af2596..c908657 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -829,9 +829,14 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	ieee80211_stop_queues(hw);
 
-	/* Disable LED */
-	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
-	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
+	/*
+	 * Keep the LED on when the radio is disabled
+	 * during idle unassociated state.
+	 */
+	if (!sc->ps_idle) {
+		ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
+	}
 
 	/* Disable interrupts */
 	ath9k_hw_set_interrupts(ah, 0);
-- 
1.7.1

