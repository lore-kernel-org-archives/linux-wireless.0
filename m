Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:12533 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZC3I4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 04:56:46 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2347225rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 01:56:45 -0700 (PDT)
Date: Mon, 30 Mar 2009 14:17:00 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: No need to abort Rx path when autosleep is enabled.
Message-ID: <20090330084659.GB12822@myhost.users.atheros.com> (sfid-20090330_105650_777461_CE89E0A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For chipsets supporting autosleep feature, there is no need to abort
Rx engine since they are capable of automatically going back to sleep
after receiving a packet.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 13d4e67..2aaa378 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2326,26 +2326,33 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ath_hw *ah = sc->sc_ah;
 
 	mutex_lock(&sc->mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
-			if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
-				sc->imask |= ATH9K_INT_TIM_TIMER;
-				ath9k_hw_set_interrupts(sc->sc_ah,
-						sc->imask);
+			if (!(ah->caps.hw_caps &
+			      ATH9K_HW_CAP_AUTOSLEEP)) {
+				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
+					sc->imask |= ATH9K_INT_TIM_TIMER;
+					ath9k_hw_set_interrupts(sc->sc_ah,
+							sc->imask);
+				}
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
-			ath9k_hw_setrxabort(sc->sc_ah, 1);
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 		} else {
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-			ath9k_hw_setrxabort(sc->sc_ah, 0);
-			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
-			if (sc->imask & ATH9K_INT_TIM_TIMER) {
-				sc->imask &= ~ATH9K_INT_TIM_TIMER;
-				ath9k_hw_set_interrupts(sc->sc_ah,
-						sc->imask);
+			if (!(ah->caps.hw_caps &
+			      ATH9K_HW_CAP_AUTOSLEEP)) {
+				ath9k_hw_setrxabort(sc->sc_ah, 0);
+				sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+				if (sc->imask & ATH9K_INT_TIM_TIMER) {
+					sc->imask &= ~ATH9K_INT_TIM_TIMER;
+					ath9k_hw_set_interrupts(sc->sc_ah,
+							sc->imask);
+				}
 			}
 		}
 	}
-- 
1.6.0.1

