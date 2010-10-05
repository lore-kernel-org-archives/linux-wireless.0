Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11508 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab0JEPGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 11:06:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 08:06:41 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/2] ath9k: Introduce a wrapper for power save disable.
Date: Tue, 5 Oct 2010 20:36:41 +0530
Message-ID: <1286291201-18052-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1286291201-18052-1-git-send-email-senthilkumar@atheros.com>
References: <1286291201-18052-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   40 ++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ccb2bf0..2d1ff14 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1505,13 +1505,32 @@ static void ath9k_enable_ps(struct ath_softc *sc)
 	}
 }
 
+static void ath9k_disable_ps(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	sc->ps_enabled = false;
+	ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		ath9k_hw_setrxabort(ah, 0);
+		sc->ps_flags &= ~(PS_WAIT_FOR_BEACON |
+				  PS_WAIT_FOR_CAB |
+				  PS_WAIT_FOR_PSPOLL_DATA |
+				  PS_WAIT_FOR_TX_ACK);
+		if (ah->imask & ATH9K_INT_TIM_TIMER) {
+			ah->imask &= ~ATH9K_INT_TIM_TIMER;
+			ath9k_hw_set_interrupts(ah, ah->imask);
+		}
+	}
+
+}
+
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ath_hw *ah = sc->sc_ah;
 	bool disable_radio;
 
 	mutex_lock(&sc->mutex);
@@ -1560,23 +1579,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
 		if (conf->flags & IEEE80211_CONF_PS)
 			ath9k_enable_ps(sc);
-		else {
-			sc->ps_enabled = false;
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-			if (!(ah->caps.hw_caps &
-			      ATH9K_HW_CAP_AUTOSLEEP)) {
-				ath9k_hw_setrxabort(sc->sc_ah, 0);
-				sc->ps_flags &= ~(PS_WAIT_FOR_BEACON |
-						  PS_WAIT_FOR_CAB |
-						  PS_WAIT_FOR_PSPOLL_DATA |
-						  PS_WAIT_FOR_TX_ACK);
-				if (ah->imask & ATH9K_INT_TIM_TIMER) {
-					ah->imask &= ~ATH9K_INT_TIM_TIMER;
-					ath9k_hw_set_interrupts(sc->sc_ah,
-							ah->imask);
-				}
-			}
-		}
+		else
+			ath9k_disable_ps(sc);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 	}
 
-- 
1.7.2.1

