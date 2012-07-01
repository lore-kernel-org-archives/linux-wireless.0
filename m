Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15593 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2GAOXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 10:23:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v3 4/5] ath9k: fix power consumption on network sleep when BTCOEX is enabled
Date: Sun, 1 Jul 2012 19:53:54 +0530
Message-ID: <1341152635-4840-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120701_162315_564365_3B13B59F)
In-Reply-To: <1341152635-4840-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1341152635-4840-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip is waken up for every 45ms in btcoex timer cycle to
for sharing the radio between BT and WLAN. Whenever the wlan
interface is in network sleep mode, do not schedule hw timers.
This could reduce power consumption on idle associated state.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
 drivers/net/wireless/ath/ath9k/gpio.c  | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c  |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fe39eb4..79840d6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -481,6 +481,7 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
+void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc);
 #else
 static inline int ath9k_init_btcoex(struct ath_softc *sc)
 {
@@ -504,6 +505,9 @@ static inline u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc,
 {
 	return 0;
 }
+static inline void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
+{
+}
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 /********************/
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 9ae6a4d..640f2ed 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -194,6 +194,14 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_mci_profile *mci = &btcoex->mci;
 	u32 timer_period;
 	bool is_btscan;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+		goto skip_hw_wakeup;
+	}
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	ath9k_ps_wakeup(sc);
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
@@ -232,6 +240,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	}
 
 	ath9k_ps_restore(sc);
+skip_hw_wakeup:
 	timer_period = btcoex->btcoex_period;
 	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
 }
@@ -327,6 +336,13 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	btcoex->hw_timer_enabled = false;
 }
 
+void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
+{
+	struct ath_btcoex *btcoex = &sc->btcoex;
+
+	ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+}
+
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6ce0128..06a3d1c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -130,6 +130,8 @@ void ath9k_ps_restore(struct ath_softc *sc)
 				     PS_WAIT_FOR_PSPOLL_DATA |
 				     PS_WAIT_FOR_TX_ACK))) {
 		mode = ATH9K_PM_NETWORK_SLEEP;
+		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
+			ath9k_btcoex_stop_gen_timer(sc);
 	} else {
 		goto unlock;
 	}
-- 
1.7.11.1

