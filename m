Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11815 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2JJISU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 04:18:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: perform ani cycle in idle state
Date: Wed, 10 Oct 2012 13:48:02 +0530
Message-ID: <1349857082-19255-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121010_101826_850145_7678A375)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of now the ANI cycle is only be executed when chip is awake.
On idle state case, the station wakes up from network sleep for
beacon reception. Since most of the time, ANI cycle is not syncing
with beacon reception, it was ignored. Approx 5 mins once, the
calibration was performed. This coule affect the connection stability
if the station is idle for long. Even though the OFDM and CCK phy
error rates are too high, ANI is unable to tune its immunity level
as quick enough due to rare execution.

Here the experiment shows that OFDM and CCK were stick with default level
on higher phy error rate.

listenTime=44 OFDM:3 errs=121977/s CCK:2 errs=440818/s ofdm_turn=1

After this change, ANI calibration was exectued for every 10 seconds
if it was ignored. The below result shows improvements and immunity
levels were adopted quick enough.

listenTime=557 OFDM:4 errs=752/s CCK:4 errs=125/s ofdm_turn=0

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 ++
 drivers/net/wireless/ath/ath9k/hw.h    |  1 +
 drivers/net/wireless/ath/ath9k/link.c  | 12 +++++++++++-
 drivers/net/wireless/ath/ath9k/main.c  |  3 ++-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dfe6a47..77c2c16 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -437,6 +437,7 @@ void ath9k_set_beacon(struct ath_softc *sc);
 #define ATH_LONG_CALINTERVAL_INT  1000    /* 1000 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
+#define ATH_ANI_MAX_SKIP_COUNT  10
 
 #define ATH_PAPRD_TIMEOUT	100 /* msecs */
 #define ATH_PLL_WORK_INTERVAL   100
@@ -642,6 +643,7 @@ enum sc_op_flags {
 #define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
+#define PS_WAIT_FOR_ANI           BIT(5)
 
 struct ath_rate_table;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dbc1b7a..1d4f5f1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -834,6 +834,7 @@ struct ath_hw {
 	int coarse_low[5];
 	int firpwr[5];
 	enum ath9k_ani_cmd ani_function;
+	u32 ani_skip_count;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex_hw btcoex_hw;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7b88b9c..223b969 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -350,8 +350,18 @@ void ath_ani_calibrate(unsigned long data)
 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
 	/* Only calibrate if awake */
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
+	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
+		if (++ah->ani_skip_count >= ATH_ANI_MAX_SKIP_COUNT) {
+			spin_lock_irqsave(&sc->sc_pm_lock, flags);
+			sc->ps_flags |= PS_WAIT_FOR_ANI;
+			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+		}
 		goto set_timer;
+	}
+	ah->ani_skip_count = 0;
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	sc->ps_flags &= ~PS_WAIT_FOR_ANI;
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	ath9k_ps_wakeup(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dd45edf..2da62be 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -131,7 +131,8 @@ void ath9k_ps_restore(struct ath_softc *sc)
 		   !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 				     PS_WAIT_FOR_CAB |
 				     PS_WAIT_FOR_PSPOLL_DATA |
-				     PS_WAIT_FOR_TX_ACK))) {
+				     PS_WAIT_FOR_TX_ACK |
+				     PS_WAIT_FOR_ANI))) {
 		mode = ATH9K_PM_NETWORK_SLEEP;
 		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
 			ath9k_btcoex_stop_gen_timer(sc);
-- 
1.7.12.2

