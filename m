Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZIJHKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:17 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/7] ath9k: move ath9k_ps_wakeup() and ath9k_ps_restore() to main.c
Date: Thu, 10 Sep 2009 03:10:14 -0400
Message-Id: <1252566619-30390-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are driver core helpers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   36 +--------------------------------
 drivers/net/wireless/ath/ath9k/hw.h   |    6 +++-
 drivers/net/wireless/ath/ath9k/main.c |   33 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d9a6026..bba8cc2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2914,8 +2914,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 	return true;
 }
 
-static bool ath9k_hw_setpower_nolock(struct ath_hw *ah,
-				     enum ath9k_power_mode mode)
+bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
 	int status = true, setChip = true;
 	static const char *modes[] = {
@@ -2964,39 +2963,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	return ret;
 }
 
-void ath9k_ps_wakeup(struct ath_softc *sc)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->sc_pm_lock, flags);
-	if (++sc->ps_usecount != 1)
-		goto unlock;
-
-	ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
-
- unlock:
-	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-}
-
-void ath9k_ps_restore(struct ath_softc *sc)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->sc_pm_lock, flags);
-	if (--sc->ps_usecount != 0)
-		goto unlock;
-
-	if (sc->ps_enabled &&
-	    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-			      SC_OP_WAIT_FOR_CAB |
-			      SC_OP_WAIT_FOR_PSPOLL_DATA |
-			      SC_OP_WAIT_FOR_TX_ACK)))
-		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
-
- unlock:
-	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-}
-
 /*
  * Helper for ASPM support.
  *
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2f3bf1a..730ae9e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -652,8 +652,10 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
-bool ath9k_hw_setpower(struct ath_hw *ah,
-		       enum ath9k_power_mode mode);
+
+bool ath9k_hw_setpower_nolock(struct ath_hw *ah, enum ath9k_power_mode mode);
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
+
 void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
 
 /* Interrupt Handling */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index df09176..4055246 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -243,6 +243,39 @@ static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
 	return channel;
 }
 
+void ath9k_ps_wakeup(struct ath_softc *sc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (++sc->ps_usecount != 1)
+		goto unlock;
+
+	ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
+
+ unlock:
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+}
+
+void ath9k_ps_restore(struct ath_softc *sc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (--sc->ps_usecount != 0)
+		goto unlock;
+
+	if (sc->ps_enabled &&
+	    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+			      SC_OP_WAIT_FOR_CAB |
+			      SC_OP_WAIT_FOR_PSPOLL_DATA |
+			      SC_OP_WAIT_FOR_TX_ACK)))
+		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+
+ unlock:
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+}
+
 /*
  * Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
-- 
1.6.3.3

