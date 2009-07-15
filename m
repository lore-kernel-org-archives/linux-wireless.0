Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 9/9] ath9k: serialize ath9k_ps_{wakeup,restore} calls
Date: Tue, 14 Jul 2009 20:17:15 -0400
Message-Id: <1247617035-15402-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

These functions are changing the power mode of the chip, but this may
have unpredictable effects, if another code are trying to set the power
mode via 'ath9k_hw_setpower' in the same time from another context.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c    |   42 ++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8b38c0a..1576812 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -576,7 +576,7 @@ struct ath_softc {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	u8 splitmic;
-	atomic_t ps_usecount;
+	unsigned long ps_usecount;
 	enum ath9k_int imask;
 	enum ath9k_ht_extprotspacing ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index df278fd..b9d1a13 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2777,23 +2777,39 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 
 void ath9k_ps_wakeup(struct ath_softc *sc)
 {
-	if (atomic_inc_return(&sc->ps_usecount) == 1)
-		if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
-			sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-		}
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (++sc->ps_usecount != 1)
+		goto unlock;
+
+	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
+		sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
+		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
+	}
+
+ unlock:
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
 void ath9k_ps_restore(struct ath_softc *sc)
 {
-	if (atomic_dec_and_test(&sc->ps_usecount))
-		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
-		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-				      SC_OP_WAIT_FOR_CAB |
-				      SC_OP_WAIT_FOR_PSPOLL_DATA |
-				      SC_OP_WAIT_FOR_TX_ACK)))
-			ath9k_hw_setpower(sc->sc_ah,
-					  sc->sc_ah->restore_mode);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (--sc->ps_usecount != 0)
+		goto unlock;
+
+	if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
+		!(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+				SC_OP_WAIT_FOR_CAB |
+				SC_OP_WAIT_FOR_PSPOLL_DATA |
+				SC_OP_WAIT_FOR_TX_ACK)))
+		ath9k_hw_setpower_nolock(sc->sc_ah,
+				      sc->sc_ah->restore_mode);
+
+ unlock:
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
 /*
-- 
1.6.0.6

