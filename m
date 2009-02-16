Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55942 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZBPH5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 02:57:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 23:57:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18841.7024.68079.715862@gargle.gargle.HOWL> (sfid-20090216_085715_239219_4D3AEE2E)
Date: Mon, 16 Feb 2009 13:23:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/4] ath9k: Fix HW wait timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX and calibration have different timeout requirements.
This patch fixes it by changing the HW wait routine
to accept a timeout value.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c |    6 ++++--
 drivers/net/wireless/ath9k/hw.c    |   17 ++++++++++-------
 drivers/net/wireless/ath9k/hw.h    |    4 ++--
 drivers/net/wireless/ath9k/mac.c   |   28 +++++++++++++++++++++++-----
 drivers/net/wireless/ath9k/pci.c   |    3 ++-
 drivers/net/wireless/ath9k/recv.c  |    1 -
 6 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index e5abe65..93c6e1f 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -893,7 +893,8 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 			  AR_PHY_AGC_CONTROL_CAL);
 
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
-				   AR_PHY_AGC_CONTROL_CAL, 0)) {
+				   AR_PHY_AGC_CONTROL_CAL, 0,
+				   AH_WAIT_TIMEOUT)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"offset calibration failed to complete in 1ms; "
 				"noisy environment?\n");
@@ -910,7 +911,8 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_CAL);
 
-	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL, 0)) {
+	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+			   0, AH_WAIT_TIMEOUT)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"offset calibration failed to complete in 1ms; "
 			"noisy environment?\n");
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 1c02358..eeee5b8 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -84,11 +84,13 @@ static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val)
+bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 {
 	int i;
 
-	for (i = 0; i < (AH_TIMEOUT / AH_TIME_QUANTUM); i++) {
+	BUG_ON(timeout < AH_TIME_QUANTUM);
+
+	for (i = 0; i < (timeout / AH_TIME_QUANTUM); i++) {
 		if ((REG_READ(ah, reg) & mask) == val)
 			return true;
 
@@ -96,8 +98,8 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val)
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-		"timeout on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
-		reg, REG_READ(ah, reg), mask, val);
+		"timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
+		timeout, reg, REG_READ(ah, reg), mask, val);
 
 	return false;
 }
@@ -1516,7 +1518,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	udelay(50);
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
-	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0)) {
+	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"RTC stuck in MAC reset\n");
 		return false;
@@ -1545,7 +1547,8 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	if (!ath9k_hw_wait(ah,
 			   AR_RTC_STATUS,
 			   AR_RTC_STATUS_M,
-			   AR_RTC_STATUS_ON)) {
+			   AR_RTC_STATUS_ON,
+			   AH_WAIT_TIMEOUT)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "RTC not waking up\n");
 		return false;
 	}
@@ -1640,7 +1643,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
-			   AR_PHY_RFBUS_GRANT_EN)) {
+			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			"Could not kill baseband RX\n");
 		return false;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 08469d9..ddab3b7 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -93,7 +93,7 @@
 #define ATH9K_NUM_QUEUES            10
 
 #define MAX_RATE_POWER              63
-#define AH_TIMEOUT                  100000
+#define AH_WAIT_TIMEOUT             100000 /* (us) */
 #define AH_TIME_QUANTUM             10
 #define AR_KEYTABLE_SIZE            128
 #define POWER_UP_TIME               200000
@@ -612,7 +612,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			       u8 *antenna_cfgd);
 
 /* General Operation */
-bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val);
+bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
 bool ath9k_get_channel_edges(struct ath_hw *ah, u16 flags, u16 *low, u16 *high);
 u16 ath9k_hw_computetxtime(struct ath_hw *ah, struct ath_rate_table *rates,
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index f32c622..a6c2042 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -886,7 +886,8 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 		REG_SET_BIT(ah, AR_DIAG_SW,
 			    (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
-		if (!ath9k_hw_wait(ah, AR_OBS_BUS_1, AR_OBS_BUS_1_RX_STATE, 0)) {
+		if (!ath9k_hw_wait(ah, AR_OBS_BUS_1, AR_OBS_BUS_1_RX_STATE,
+				   0, AH_WAIT_TIMEOUT)) {
 			REG_CLR_BIT(ah, AR_DIAG_SW,
 				    (AR_DIAG_RX_DIS |
 				     AR_DIAG_RX_ABORT));
@@ -933,15 +934,32 @@ void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
+#define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
+#define AH_RX_TIME_QUANTUM     100     /* usec */
+
+	int i;
+
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 
-	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0)) {
+	/* Wait for rx enable bit to go low */
+	for (i = AH_RX_STOP_DMA_TIMEOUT / AH_TIME_QUANTUM; i != 0; i--) {
+		if ((REG_READ(ah, AR_CR) & AR_CR_RXE) == 0)
+			break;
+		udelay(AH_TIME_QUANTUM);
+	}
+
+	if (i == 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-			"dma failed to stop in 10ms\n"
-			"AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
-			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
+			"dma failed to stop in %d ms "
+			"AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
+			AH_RX_STOP_DMA_TIMEOUT / 1000,
+			REG_READ(ah, AR_CR),
+			REG_READ(ah, AR_DIAG_SW));
 		return false;
 	} else {
 		return true;
 	}
+
+#undef AH_RX_TIME_QUANTUM
+#undef AH_RX_STOP_DMA_TIMEOUT
 }
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index c28afe4..a70f954 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -63,7 +63,8 @@ static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 	if (!ath9k_hw_wait(ah,
 			   AR_EEPROM_STATUS_DATA,
 			   AR_EEPROM_STATUS_DATA_BUSY |
-			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0)) {
+			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0,
+			   AH_WAIT_TIMEOUT)) {
 		return false;
 	}
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 08f676a..28ad1d5 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -427,7 +427,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
-	mdelay(3); /* 3ms is long enough for 1 frame */
 	sc->rx.rxlink = NULL;
 
 	return stopped;
-- 
1.6.1

