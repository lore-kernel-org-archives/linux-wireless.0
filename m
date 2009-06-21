Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52225 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFUPrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 11:47:47 -0400
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
Subject: [PATCH 1/3] ath9k: serialize ath9k_hw_setpower calls
Date: Sun, 21 Jun 2009 17:47:46 +0200
Message-Id: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 7425a1f..902dfed 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -544,6 +544,7 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
+	spinlock_t sc_pm_lock;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 34935a8..7ade05e 100644
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
index 66a6c1f..3cb4831 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1311,6 +1311,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
+	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
-- 
1.5.3.2

