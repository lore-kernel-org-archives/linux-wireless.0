Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50223 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0KCAg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 20:36:56 -0400
Message-ID: <4CD0AEA3.8060805@openwrt.org>
Date: Wed, 03 Nov 2010 01:36:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.37] ath9k: check old power mode before clearing cycle
 counters
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_ps_wakeup() clears the cycle counters after waking up the
hardware using ath9k_hw_setpower, however if power save is disabled,
then the counters will contain useful data, which then gets discarded.
Fix this by checking the old power mode before discarding any data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -94,11 +94,13 @@ void ath9k_ps_wakeup(struct ath_softc *s
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	unsigned long flags;
+	enum ath9k_power_mode power_mode;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
+	power_mode = sc->sc_ah->power_mode;
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 
 	/*
@@ -106,10 +108,12 @@ void ath9k_ps_wakeup(struct ath_softc *s
 	 * useful data. Better clear them now so that they don't mess up
 	 * survey data results.
 	 */
-	spin_lock(&common->cc_lock);
-	ath_hw_cycle_counters_update(common);
-	memset(&common->cc_survey, 0, sizeof(common->cc_survey));
-	spin_unlock(&common->cc_lock);
+	if (power_mode != ATH9K_PM_AWAKE) {
+		spin_lock(&common->cc_lock);
+		ath_hw_cycle_counters_update(common);
+		memset(&common->cc_survey, 0, sizeof(common->cc_survey));
+		spin_unlock(&common->cc_lock);
+	}
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
