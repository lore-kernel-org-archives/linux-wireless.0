Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32395 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZHGEOx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:14:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:14:54 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43597.209733.7507@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/12] ath9k: Cleanup function return types
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |    5 +----
 drivers/net/wireless/ath/ath9k/hw.c     |    4 +---
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c    |   17 ++++-------------
 drivers/net/wireless/ath/ath9k/mac.h    |    8 ++++----
 5 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 4cb64a0..86b13d1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -35,7 +35,6 @@ static void ath9k_hw_analog_shift_rmw(struct ath_hw *ah,
 
 static inline u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
 {
-
 	if (fbin == AR5416_BCHAN_UNUSED)
 		return fbin;
 
@@ -95,7 +94,7 @@ static inline bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 	return sc->bus_ops->eeprom_read(ah, off, data);
 }
 
-static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
+static inline void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 					   u8 *pVpdList, u16 numIntercepts,
 					   u8 *pRetVpdList)
 {
@@ -120,8 +119,6 @@ static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 		pRetVpdList[i] = (u8) k;
 		currPwr += 2;
 	}
-
-	return true;
 }
 
 static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 71a3bcc..6514dc7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4019,14 +4019,12 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 	ath9k_ps_restore(ah->ah_sc);
 }
 
-bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
+void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 {
 	if (setting)
 		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
 	else
 		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
-
-	return true;
 }
 
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d4aaf4f..e83e900 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -601,7 +601,7 @@ void ath9k_hw_write_associd(struct ath_softc *sc);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
-bool ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
+void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
 void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 6f923e3..800bfab 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -40,20 +40,15 @@ u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
 	return REG_READ(ah, AR_QTXDP(q));
 }
 
-bool ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
+void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
-
-	return true;
 }
 
-bool ath9k_hw_txstart(struct ath_hw *ah, u32 q)
+void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "Enable TXE on queue: %u\n", q);
-
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
-
-	return true;
 }
 
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
@@ -178,7 +173,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 #undef ATH9K_TIME_QUANTUM
 }
 
-bool ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
+void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
 			 bool lastSeg, const struct ath_desc *ds0)
 {
@@ -202,8 +197,6 @@ bool ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
-
-	return true;
 }
 
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
@@ -888,7 +881,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	return 0;
 }
 
-bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
+void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -901,8 +894,6 @@ bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_rxstatus8 &= ~AR_RxDone;
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		memset(&(ads->u), 0, sizeof(ads->u));
-
-	return true;
 }
 
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 1176bce..7b39822 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -628,12 +628,12 @@ struct ath9k_channel;
 struct ath_rate_table;
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
-bool ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
-bool ath9k_hw_txstart(struct ath_hw *ah, u32 q);
+void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
+void ath9k_hw_txstart(struct ath_hw *ah, u32 q);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
-bool ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
+void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
 			 bool lastSeg, const struct ath_desc *ds0);
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds);
@@ -668,7 +668,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q);
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q);
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			u32 pa, struct ath_desc *nds, u64 tsf);
-bool ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
+void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags);
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
-- 
1.6.4

