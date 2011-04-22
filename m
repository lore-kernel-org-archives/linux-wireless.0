Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35963 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1DVGDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 02:03:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 23:02:34 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 5/5] ath9k: Add power save wrappers and modularize hw_pll handler
Date: Fri, 22 Apr 2011 11:32:12 +0530
Message-ID: <1303452132-5436-5-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
References: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should protect hw_pll handler with power save wrappers and
also modularize hw_pll handler properly for better readability.

Also add a debug message to track chip resets on pll hang condition.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |   36 ++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 289c03e..dfea703 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -673,7 +673,7 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
+u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 {
 	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 	udelay(100);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 29a745c..6a028bd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -932,7 +932,7 @@ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
-unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
+u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
 void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fa80e13..475009b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -624,23 +624,37 @@ out:
 	ath9k_ps_restore(sc);
 }
 
+static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
+{
+	static int count;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (pll_sqsum >= 0x40000) {
+		count++;
+		if (count == 3) {
+			/* Rx is hung for more than 500ms. Reset it */
+			ath_dbg(common, ATH_DBG_RESET,
+				"Possible RX hang, resetting");
+			ath_reset(sc, true);
+			count = 0;
+		}
+	} else
+		count = 0;
+}
+
 void ath_hw_pll_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
 					    hw_pll_work.work);
-	static int count;
+	u32 pll_sqsum;
 
 	if (AR_SREV_9485(sc->sc_ah)) {
-		if (ar9003_get_pll_sqsum_dvc(sc->sc_ah) >= 0x40000) {
-			count++;
 
-			if (count == 3) {
-				/* Rx is hung for more than 500ms. Reset it */
-				ath_reset(sc, true);
-				count = 0;
-			}
-		} else
-			count = 0;
+		ath9k_ps_wakeup(sc);
+		pll_sqsum = ar9003_get_pll_sqsum_dvc(sc->sc_ah);
+		ath9k_ps_restore(sc);
+
+		ath_hw_pll_rx_hang_check(sc, pll_sqsum);
 
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
 	}
-- 
1.7.0.4

