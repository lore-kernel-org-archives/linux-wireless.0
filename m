Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2EXDyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 23:54:35 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45242.971216.81533@gargle.gargle.HOWL> (sfid-20120524_055439_127174_2D12A951)
Date: Thu, 24 May 2012 09:23:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/22] ath9k: Handle fatal interrupts properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a fatal interrupt is received or it is detected that the baseband
has hung, the chip has to be reset immediately.  Otherwise, we end up
processing spurious interrupts. Ensure that we bail out properly in
the ISR when the reset work hasn't completed yet.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   14 ++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a277cf6..70504b7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -593,6 +593,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_SCAN                BIT(6)
 #define SC_OP_ANI_RUN                BIT(7)
 #define SC_OP_PRIM_STA_VIF           BIT(8)
+#define SC_OP_HW_RESET               BIT(9)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
@@ -631,6 +632,7 @@ struct ath_softc {
 	spinlock_t sc_serial_rw;
 	spinlock_t sc_pm_lock;
 	spinlock_t sc_pcu_lock;
+	spinlock_t sc_bb_lock;
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9dfce1a..d1d016c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -549,6 +549,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
+	spin_lock_init(&sc->sc_bb_lock);
 	mutex_init(&sc->mutex);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	spin_lock_init(&sc->nodes_lock);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3f79923..672aefe 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -270,6 +270,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	unsigned long flags;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -310,6 +311,10 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	ieee80211_wake_queues(sc->hw);
 
+	spin_lock_irqsave(&sc->sc_bb_lock, flags);
+	sc->sc_flags &= ~SC_OP_HW_RESET;
+	spin_unlock_irqrestore(&sc->sc_bb_lock, flags);
+
 	return true;
 }
 
@@ -692,6 +697,9 @@ void ath9k_tasklet(unsigned long data)
 
 		RESET_STAT_INC(sc, type);
 #endif
+		spin_lock(&sc->sc_bb_lock);
+		sc->sc_flags |= SC_OP_HW_RESET;
+		spin_unlock(&sc->sc_bb_lock);
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		goto out;
 	}
@@ -768,6 +776,12 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return IRQ_NONE;
 
+	spin_lock(&sc->sc_bb_lock);
+	if (sc->sc_flags & SC_OP_HW_RESET) {
+		spin_unlock(&sc->sc_bb_lock);
+		return IRQ_NONE;
+	}
+	spin_unlock(&sc->sc_bb_lock);
 
 	/* shared irq, not for us */
 
-- 
1.7.10.2

