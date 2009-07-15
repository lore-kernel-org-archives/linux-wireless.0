Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 7/9] ath9k: serialize ath9k_hw_setpower calls
Date: Tue, 14 Jul 2009 20:17:13 -0400
Message-Id: <1247617035-15402-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Because ath9k_setpower is called from various contexts, we have to
protect it against concurrent calls.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 20bf4a7..b37eb59 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -559,6 +559,7 @@ struct ath_softc {
 	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
 	spinlock_t ani_lock;
+	spinlock_t sc_pm_lock;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a115c8c..6740a6b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2728,7 +2728,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 	return true;
 }
 
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+static bool ath9k_hw_setpower_nolock(struct ath_hw *ah,
+				     enum ath9k_power_mode mode)
 {
 	int status = true, setChip = true;
 	static const char *modes[] = {
@@ -2762,6 +2763,18 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	return status;
 }
 
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ah->ah_sc->sc_pm_lock, flags);
+	ret = ath9k_hw_setpower_nolock(ah, mode);
+	spin_unlock_irqrestore(&ah->ah_sc->sc_pm_lock, flags);
+
+	return ret;
+}
+
 /*
  * Helper for ASPM support.
  *
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 90cecce..d14f8c9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1316,6 +1316,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->ani_lock);
+	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
-- 
1.6.0.6

