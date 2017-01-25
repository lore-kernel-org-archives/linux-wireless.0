Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33756 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbdAYQg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 11:36:57 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/4] ath9k: check for deaf rx path state
Date: Wed, 25 Jan 2017 17:36:53 +0100
Message-Id: <20170125163654.66431-3-nbd@nbd.name> (sfid-20170125_173708_458186_A6171922)
In-Reply-To: <20170125163654.66431-1-nbd@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various chips occasionally run into a state where the tx path still
appears to be working normally, but the rx path is deaf.

There is no known register signature to check for this state explicitly,
so use the lack of rx interrupts as an indicator.

This detection is prone to false positives, since a device could also
simply be in an environment where there are no frames on the air.
However, in this case doing a reset should be harmless since it's
obviously not interrupting any real activity. To avoid confusion, call
the reset counters in this case "Rx path inactive" instead of something
like "Rx path deaf", since it may not be an indication of a real
hardware failure.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/debug.c |  1 +
 drivers/net/wireless/ath/ath9k/debug.h |  1 +
 drivers/net/wireless/ath/ath9k/link.c  | 16 +++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c  |  2 ++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b2fa44adc60e..a396c99ee84d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1027,6 +1027,7 @@ struct ath_softc {
 
 	u8 gtt_cnt;
 	u32 intrstatus;
+	u32 rx_active;
 	u16 ps_flags; /* PS_* */
 	bool ps_enabled;
 	bool ps_idle;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 43930c336987..a42402413659 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -763,6 +763,7 @@ static int read_file_reset(struct seq_file *file, void *data)
 		[RESET_TYPE_BEACON_STUCK] = "Stuck Beacon",
 		[RESET_TYPE_MCI] = "MCI Reset",
 		[RESET_TYPE_CALIBRATION] = "Calibration error",
+		[RESET_TYPE_RX_INACTIVE] = "Rx path inactive",
 		[RESET_TX_DMA_ERROR] = "Tx DMA stop error",
 		[RESET_RX_DMA_ERROR] = "Rx DMA stop error",
 	};
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 249f8141cd00..a40c84e8d0b6 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -50,6 +50,7 @@ enum ath_reset_type {
 	RESET_TYPE_BEACON_STUCK,
 	RESET_TYPE_MCI,
 	RESET_TYPE_CALIBRATION,
+	RESET_TYPE_RX_INACTIVE,
 	RESET_TX_DMA_ERROR,
 	RESET_RX_DMA_ERROR,
 	__RESET_TYPE_MAX
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 27c50562dc47..b9d92aae00c2 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -53,13 +53,27 @@ static bool ath_tx_complete_check(struct ath_softc *sc)
 
 }
 
+static bool ath_rx_active_check(struct ath_softc *sc)
+{
+	if (sc->rx_active) {
+		sc->rx_active = 0;
+		return true;
+	}
+
+	ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
+		"rx path inactive, resetting the chip\n");
+	ath9k_queue_reset(sc, RESET_TYPE_RX_INACTIVE);
+	return false;
+}
+
 void ath_hw_check_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
 					    hw_check_work.work);
 
 	if (!ath_hw_check(sc) ||
-	    !ath_tx_complete_check(sc))
+	    !ath_tx_complete_check(sc) ||
+	    !ath_rx_active_check(sc))
 		return;
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->hw_check_work,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0345d6ec564f..985b1cade4a4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -269,6 +269,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	}
 
 	sc->gtt_cnt = 0;
+	sc->rx_active = 1;
 
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
@@ -452,6 +453,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_rx_tasklet(sc, 0, true);
 
 		ath_rx_tasklet(sc, 0, false);
+		sc->rx_active = 1;
 	}
 
 	if (status & ATH9K_INT_TX) {
-- 
2.11.0
