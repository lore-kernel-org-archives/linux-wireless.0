Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41803 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZGXP1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:27:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: fix race with IEEE80211_CONF_PS checks
Date: Fri, 24 Jul 2009 17:27:21 +0200
Message-Id: <1248449242-27629-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a small window where the mac80211 changes the IEEE80211_CONF_PS
flag, and then informs the driver about the change. We have a race
condition if we are checking the flag in the same time. Avoid it by
introducing a local variable, and using that instead of checking the
IEEE80211_CONF_PS flag directly.

This fix the problem reported by Luis:
http://article.gmane.org/gmane.linux.kernel.wireless.general/34363

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |   17 +++++++----------
 drivers/net/wireless/ath/ath9k/hw.h    |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |    8 ++++----
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 751885a..9fe0ee3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -576,6 +576,7 @@ struct ath_softc {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	u8 splitmic;
+	bool ps_enabled;
 	unsigned long ps_usecount;
 	enum ath9k_int imask;
 	enum ath9k_ht_extprotspacing ht_extprotspacing;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 605803a..f80b8ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2783,10 +2783,8 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
-		sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
+	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
 		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
-	}
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
@@ -2800,13 +2798,12 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
-		!(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-				SC_OP_WAIT_FOR_CAB |
-				SC_OP_WAIT_FOR_PSPOLL_DATA |
-				SC_OP_WAIT_FOR_TX_ACK)))
-		ath9k_hw_setpower_nolock(sc->sc_ah,
-				      sc->sc_ah->restore_mode);
+	if (sc->ps_enabled &&
+	    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+			      SC_OP_WAIT_FOR_CAB |
+			      SC_OP_WAIT_FOR_PSPOLL_DATA |
+			      SC_OP_WAIT_FOR_TX_ACK)))
+		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 28bffdb..82e646c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -417,7 +417,6 @@ struct ath_hw {
 
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
-	enum ath9k_power_mode restore_mode;
 
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 	struct ar5416Stats stats;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3436295..d0b1e60 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -499,8 +499,7 @@ static void ath9k_tasklet(unsigned long data)
 	if (status & ATH9K_INT_TX)
 		ath_tx_tasklet(sc);
 
-	if ((status & ATH9K_INT_TSFOOR) &&
-	    (sc->hw->conf.flags & IEEE80211_CONF_PS)) {
+	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
 		/*
 		 * TSF sync does not look correct; remain awake to sync with
 		 * the next Beacon.
@@ -2003,7 +2002,7 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	if (sc->hw->conf.flags & IEEE80211_CONF_PS) {
+	if (sc->ps_enabled) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		/*
 		 * mac80211 does not set PM field for normal data frames, so we
@@ -2291,8 +2290,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				}
 				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+			sc->ps_enabled = true;
 		} else {
+			sc->ps_enabled = false;
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
-- 
1.5.3.2

