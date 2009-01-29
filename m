Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44759 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZA2MZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 07:25:02 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 04:25:02 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix LED blink pattern
Date: Thu, 29 Jan 2009 17:52:19 +0530
Message-ID: <1233231739-4402-1-git-send-email-vasanth@atheros.com> (sfid-20090129_132514_255822_F951E9A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   10 +++++++
 drivers/net/wireless/ath9k/main.c |   52 ++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 29251f8..9a7bb1b 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -600,6 +600,8 @@ struct ath_ani {
 /********************/
 
 #define ATH_LED_PIN	1
+#define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
+#define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
 
 enum ath_led_type {
 	ATH_LED_RADIO,
@@ -677,6 +679,7 @@ enum PROT_MODE {
 #define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
 #define SC_OP_WAIT_FOR_BEACON	BIT(14)
+#define SC_OP_LED_ON		BIT(15)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
@@ -725,10 +728,17 @@ struct ath_softc {
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
 	struct ath_rate_table *cur_rate_table;
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+
 	struct ath_led radio_led;
 	struct ath_led assoc_led;
 	struct ath_led tx_led;
 	struct ath_led rx_led;
+	struct delayed_work ath_led_blink_work;
+	int led_on_duration;
+	int led_off_duration;
+	int led_on_cnt;
+	int led_off_cnt;
+
 	struct ath_rfkill rf_kill;
 	struct ath_ani sc_ani;
 	struct ath9k_node_stats sc_halstats;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 91f7a7b..e98f2d7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -935,6 +935,32 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 /*	 LED functions		*/
 /********************************/
 
+static void ath_led_blink_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    ath_led_blink_work.work);
+
+	if (!(sc->sc_flags & SC_OP_LED_ASSOCIATED))
+		return;
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+			  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
+
+	queue_delayed_work(sc->hw->workqueue, &sc->ath_led_blink_work,
+			   (sc->sc_flags & SC_OP_LED_ON) ?
+			   msecs_to_jiffies(sc->led_off_duration) :
+			   msecs_to_jiffies(sc->led_on_duration));
+
+	sc->led_on_duration =
+			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25);
+	sc->led_off_duration =
+			max((ATH_LED_OFF_DURATION_IDLE - sc->led_off_cnt), 10);
+	sc->led_on_cnt = sc->led_off_cnt = 0;
+	if (sc->sc_flags & SC_OP_LED_ON)
+		sc->sc_flags &= ~SC_OP_LED_ON;
+	else
+		sc->sc_flags |= SC_OP_LED_ON;
+}
+
 static void ath_led_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness)
 {
@@ -944,16 +970,27 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 	switch (brightness) {
 	case LED_OFF:
 		if (led->led_type == ATH_LED_ASSOC ||
-		    led->led_type == ATH_LED_RADIO)
+		    led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+				(led->led_type == ATH_LED_RADIO));
 			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
-				(led->led_type == ATH_LED_RADIO) ? 1 :
-				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
+			if (led->led_type == ATH_LED_RADIO)
+				sc->sc_flags &= ~SC_OP_LED_ON;
+		} else {
+			sc->led_off_cnt++;
+		}
 		break;
 	case LED_FULL:
-		if (led->led_type == ATH_LED_ASSOC)
+		if (led->led_type == ATH_LED_ASSOC) {
 			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+			queue_delayed_work(sc->hw->workqueue,
+					   &sc->ath_led_blink_work, 0);
+		} else if (led->led_type == ATH_LED_RADIO) {
+			ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+			sc->sc_flags |= SC_OP_LED_ON;
+		} else {
+			sc->led_on_cnt++;
+		}
 		break;
 	default:
 		break;
@@ -989,6 +1026,7 @@ static void ath_unregister_led(struct ath_led *led)
 
 static void ath_deinit_leds(struct ath_softc *sc)
 {
+	cancel_delayed_work_sync(&sc->ath_led_blink_work);
 	ath_unregister_led(&sc->assoc_led);
 	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
 	ath_unregister_led(&sc->tx_led);
@@ -1008,6 +1046,8 @@ static void ath_init_leds(struct ath_softc *sc)
 	/* LED off, active low */
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
+	INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
+
 	trigger = ieee80211_get_radio_led_name(sc->hw);
 	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
 		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
-- 
1.5.5.1

