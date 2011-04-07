Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59133 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1DGSNV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 14:13:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Kyungwan.Nam@Atheros.com
Subject: [PATCH 2.6.39] ath9k_hw: fix stopping rx DMA during resets
Date: Thu,  7 Apr 2011 20:13:15 +0200
Message-Id: <1302199995-49948-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During PHY errors, the MAC can sometimes fail to enter an idle state on older
hardware (before AR9380) after an rx stop has been requested.

This typically shows up in the kernel log with messages like these:

ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:504 ath_stoprecv+0xcc/0xf0 [ath9k]()
Call Trace:
[<8023f0e8>] dump_stack+0x8/0x34
[<80075050>] warn_slowpath_common+0x78/0xa4
[<80075094>] warn_slowpath_null+0x18/0x24
[<80d66d60>] ath_stoprecv+0xcc/0xf0 [ath9k]
[<80d642cc>] ath_set_channel+0xbc/0x270 [ath9k]
[<80d65254>] ath_radio_disable+0x4a4/0x7fc [ath9k]

When this happens, the state that the MAC enters is easy to identify and
does not result in bogus DMA traffic, however to ensure a working state
after a channel change, the hardware should still be reset.

This patch adds detection for this specific MAC state, after which the above
warnings completely disappear in my tests.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
Cc: Kyungwan Nam <Kyungwan.Nam@Atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    5 ++++-
 drivers/net/wireless/ath/ath9k/mac.c  |   20 +++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/mac.h  |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1b5bd13..701d429 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1244,6 +1244,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
+	bool reset = false;
 	int i, r;
 
 	ah->txchainmask = common->tx_chainmask;
@@ -1251,11 +1252,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if ((common->bus_ops->ath_bus_type != ATH_USB) && !ah->chip_fullsleep) {
 		ath9k_hw_abortpcurecv(ah);
-		if (!ath9k_hw_stopdmarecv(ah)) {
+		if (!ath9k_hw_stopdmarecv(ah, &reset)) {
 			ath_dbg(common, ATH_DBG_XMIT,
 				"Failed to stop receive dma\n");
 			bChannelChange = false;
 		}
+		if (reset)
+			bChannelChange = false;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 6f431cb..0a0e1dd 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -710,18 +710,36 @@ void ath9k_hw_abortpcurecv(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_abortpcurecv);
 
-bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
+bool ath9k_hw_stopdmarecv(struct ath_hw *ah, bool *reset)
 {
 #define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
 	struct ath_common *common = ath9k_hw_common(ah);
+	u32 mac_status, last_mac_status = 0;
 	int i;
 
+	/* Enable access to the DMA observation bus */
+	REG_WRITE(ah, AR_MACMISC,
+		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
+		   (AR_MACMISC_MISC_OBS_BUS_1 <<
+		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
+
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 
 	/* Wait for rx enable bit to go low */
 	for (i = AH_RX_STOP_DMA_TIMEOUT / AH_TIME_QUANTUM; i != 0; i--) {
 		if ((REG_READ(ah, AR_CR) & AR_CR_RXE) == 0)
 			break;
+
+		if (!AR_SREV_9300_20_OR_LATER(ah)) {
+			mac_status = REG_READ(ah, AR_DMADBG_7) & 0x7f0;
+			if (mac_status == 0x1c0 && mac_status == last_mac_status) {
+				*reset = true;
+				break;
+			}
+
+			last_mac_status = mac_status;
+		}
+
 		udelay(AH_TIME_QUANTUM);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index b2b2ff8..c2a5938 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -695,7 +695,7 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
 void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_abortpcurecv(struct ath_hw *ah);
-bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
+bool ath9k_hw_stopdmarecv(struct ath_hw *ah, bool *reset);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
 /* Interrupt Handling */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index dfe2253..26b5183 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -483,12 +483,12 @@ start_recv:
 bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	bool stopped;
+	bool stopped, reset = false;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
-	stopped = ath9k_hw_stopdmarecv(ah);
+	stopped = ath9k_hw_stopdmarecv(ah, &reset);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_edma_stop_recv(sc);
@@ -503,7 +503,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 			"confusing the DMA engine when we start RX up\n");
 		ATH_DBG_WARN_ON_ONCE(!stopped);
 	}
-	return stopped;
+	return stopped || reset;
 }
 
 void ath_flushrecv(struct ath_softc *sc)
-- 
1.7.3.2

