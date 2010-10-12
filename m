Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51176 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab0JLMDD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:03:03 -0400
Message-ID: <4CB44E6D.1050306@openwrt.org>
Date: Tue, 12 Oct 2010 14:02:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: do not track cycle counter updates in powersave mode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the chip is in powersave mode, the cycle counter updates do not
contain useful values. While the chip is in full sleep, the rx_clear
signal stays high, indicating a busy medium.
To ensure sane values, update cycle counters before going into
powersave, and clear them right after switching back to awake.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -122,6 +122,7 @@ bool ath9k_setpower(struct ath_softc *sc
 
 void ath9k_ps_wakeup(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
@@ -130,18 +131,33 @@ void ath9k_ps_wakeup(struct ath_softc *s
 
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 
+	/*
+	 * While the hardware is asleep, the cycle counters contain no
+	 * useful data. Better clear them now so that they don't mess up
+	 * survey data results.
+	 */
+	spin_lock(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	memset(&common->cc_survey, 0, sizeof(common->cc_survey));
+	spin_unlock(&common->cc_lock);
+
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
 void ath9k_ps_restore(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
+	spin_lock(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	spin_unlock(&common->cc_lock);
+
 	if (sc->ps_idle)
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
 	else if (sc->ps_enabled &&
@@ -197,7 +213,8 @@ static void ath_update_survey_stats(stru
 	struct ath_cycle_counters *cc = &common->cc_survey;
 	unsigned int div = common->clockrate * 1000;
 
-	ath_hw_cycle_counters_update(common);
+	if (ah->power_mode == ATH9K_PM_AWAKE)
+		ath_hw_cycle_counters_update(common);
 
 	if (cc->cycles > 0) {
 		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
