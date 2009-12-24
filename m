Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZLXB2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:28:06 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>
Subject: [PATCH 3/5] ath9k: fix suspend by waking device prior to stop
Date: Wed, 23 Dec 2009 20:28:04 -0500
Message-Id: <1261618084-13065-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

ath9k: fix suspend by waking device prior to stop

Ensure the device is awake prior to trying to tell hardware
to stop it. Impact of not doing this is we can likely leave
the device in an undefined state likely causing issues with
suspend and resume. This patch ensures harware is where it
should be prior to suspend.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3f5b887..1464ded 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return; /* another wiphy still in use */
 	}
 
+	/* Ensure HW is awake when we try to shut it down. */
+	ath9k_ps_wakeup(sc);
+
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -2524,6 +2527,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
+	ath9k_ps_restore(sc);
+
+	/* Finally, put the chip in FULL SLEEP mode */
 	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
-- 
1.6.3.3

