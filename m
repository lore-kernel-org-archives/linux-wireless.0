Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54194 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZDMQa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:30:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:30:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26545.651518.817037@gargle.gargle.HOWL> (sfid-20090413_183059_188965_3A1FADAC)
Date: Mon, 13 Apr 2009 21:56:25 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/11] ath9k: Handle ASPM properly for RFKILL
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radio enable/disable have to handle ASPM state properly.
This patch fixes it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b6a7ea..1a9bf7e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1089,10 +1089,10 @@ void ath_radio_enable(struct ath_softc *sc)
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	spin_lock_bh(&sc->sc_resetlock);
+	ath9k_hw_configpcipowersave(ah, 0);
 
+	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
-
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) ",
@@ -1154,6 +1154,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
+	ath9k_hw_configpcipowersave(ah, 1);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 	ath9k_ps_restore(sc);
 }
-- 
1.6.2.2

