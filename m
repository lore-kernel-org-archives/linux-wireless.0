Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58754 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1INTYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 09/12] ath9k: optimize ath9k_ps_restore
Date: Wed, 14 Sep 2011 21:24:24 +0200
Message-Id: <1316028267-34187-9-git-send-email-nbd@openwrt.org> (sfid-20110914_212444_202143_1B0DADDB)
In-Reply-To: <1316028267-34187-8-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_hw_cycle_counters_update only needs to be called if the power state
changes. Most of the time this does not happen, even when ps_usecount
goes down to 0.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a75810a..a16f539 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -111,24 +111,29 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 void ath9k_ps_restore(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	enum ath9k_power_mode mode;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	spin_lock(&common->cc_lock);
-	ath_hw_cycle_counters_update(common);
-	spin_unlock(&common->cc_lock);
-
 	if (sc->ps_idle)
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+		mode = ATH9K_PM_FULL_SLEEP;
 	else if (sc->ps_enabled &&
 		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 			      PS_WAIT_FOR_CAB |
 			      PS_WAIT_FOR_PSPOLL_DATA |
 			      PS_WAIT_FOR_TX_ACK)))
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+		mode = ATH9K_PM_NETWORK_SLEEP;
+	else
+		goto unlock;
+
+	spin_lock(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	spin_unlock(&common->cc_lock);
+
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-- 
1.7.3.2

