Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52243 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZFUPrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 11:47:48 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] ath9k: serialize ath9k_ps_{wakeup,restore} calls
Date: Sun, 21 Jun 2009 17:47:48 +0200
Message-Id: <1245599268-2441-3-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
References: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 9865452..23b5586 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -561,7 +561,7 @@ struct ath_softc {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	u8 splitmic;
-	atomic_t ps_usecount;
+	unsigned long ps_usecount;
 	enum ath9k_int imask;
 	enum ath9k_ht_extprotspacing ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index acf5256..b321209 100644
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
1.5.3.2

