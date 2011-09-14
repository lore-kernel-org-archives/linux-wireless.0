Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58756 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab1INTYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 08/12] ath9k_hw: remove the old tx descriptor API
Date: Wed, 14 Sep 2011 21:24:23 +0200
Message-Id: <1316028267-34187-8-git-send-email-nbd@openwrt.org> (sfid-20110914_212445_849129_D19D1E17)
In-Reply-To: <1316028267-34187-7-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |  176 -----------------------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  203 ---------------------------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   58 --------
 drivers/net/wireless/ath/ath9k/hw.h         |   22 ---
 drivers/net/wireless/ath/ath9k/mac.c        |   12 --
 drivers/net/wireless/ath/ath9k/mac.h        |    1 -
 6 files changed, 0 insertions(+), 472 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index cb86c95..f7d8e51 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -270,35 +270,6 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 		| SM(i->rtscts_rate, AR_RTSCTSRate);
 }
 
-static void ar9002_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
-				  bool is_firstseg, bool is_lastseg,
-				  const void *ds0, dma_addr_t buf_addr,
-				  unsigned int qcu)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_data = buf_addr;
-
-	if (is_firstseg) {
-		ads->ds_ctl1 |= seglen | (is_lastseg ? 0 : AR_TxMore);
-	} else if (is_lastseg) {
-		ads->ds_ctl0 = 0;
-		ads->ds_ctl1 = seglen;
-		ads->ds_ctl2 = AR5416DESC_CONST(ds0)->ds_ctl2;
-		ads->ds_ctl3 = AR5416DESC_CONST(ds0)->ds_ctl3;
-	} else {
-		ads->ds_ctl0 = 0;
-		ads->ds_ctl1 = seglen | AR_TxMore;
-		ads->ds_ctl2 = 0;
-		ads->ds_ctl3 = 0;
-	}
-	ads->ds_txstatus0 = ads->ds_txstatus1 = 0;
-	ads->ds_txstatus2 = ads->ds_txstatus3 = 0;
-	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
-	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
-	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
-}
-
 static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
@@ -371,145 +342,6 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	return 0;
 }
 
-static void ar9002_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
-				    u32 pktLen, enum ath9k_pkt_type type,
-				    u32 txPower, u8 keyIx,
-				    enum ath9k_key_type keyType, u32 flags)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	if (txPower > 63)
-		txPower = 63;
-
-	ads->ds_ctl0 = (pktLen & AR_FrameLen)
-		| (flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
-		| SM(txPower, AR_XmitPower)
-		| (flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
-		| (flags & ATH9K_TXDESC_INTREQ ? AR_TxIntrReq : 0)
-		| (keyIx != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0);
-
-	ads->ds_ctl1 =
-		(keyIx != ATH9K_TXKEYIX_INVALID ? SM(keyIx, AR_DestIdx) : 0)
-		| SM(type, AR_FrameType)
-		| (flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
-		| (flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
-		| (flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
-
-	ads->ds_ctl6 = SM(keyType, AR_EncrType);
-
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
-		ads->ds_ctl8 = 0;
-		ads->ds_ctl9 = 0;
-		ads->ds_ctl10 = 0;
-		ads->ds_ctl11 = 0;
-	}
-}
-
-static void ar9002_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	if (val)
-		ads->ds_ctl0 |= AR_ClrDestMask;
-	else
-		ads->ds_ctl0 &= ~AR_ClrDestMask;
-}
-
-static void ar9002_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
-					  void *lastds,
-					  u32 durUpdateEn, u32 rtsctsRate,
-					  u32 rtsctsDuration,
-					  struct ath9k_11n_rate_series series[],
-					  u32 nseries, u32 flags)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-	struct ar5416_desc *last_ads = AR5416DESC(lastds);
-	u32 ds_ctl0;
-
-	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
-		ds_ctl0 = ads->ds_ctl0;
-
-		if (flags & ATH9K_TXDESC_RTSENA) {
-			ds_ctl0 &= ~AR_CTSEnable;
-			ds_ctl0 |= AR_RTSEnable;
-		} else {
-			ds_ctl0 &= ~AR_RTSEnable;
-			ds_ctl0 |= AR_CTSEnable;
-		}
-
-		ads->ds_ctl0 = ds_ctl0;
-	} else {
-		ads->ds_ctl0 =
-			(ads->ds_ctl0 & ~(AR_RTSEnable | AR_CTSEnable));
-	}
-
-	ads->ds_ctl2 = set11nTries(series, 0)
-		| set11nTries(series, 1)
-		| set11nTries(series, 2)
-		| set11nTries(series, 3)
-		| (durUpdateEn ? AR_DurUpdateEna : 0)
-		| SM(0, AR_BurstDur);
-
-	ads->ds_ctl3 = set11nRate(series, 0)
-		| set11nRate(series, 1)
-		| set11nRate(series, 2)
-		| set11nRate(series, 3);
-
-	ads->ds_ctl4 = set11nPktDurRTSCTS(series, 0)
-		| set11nPktDurRTSCTS(series, 1);
-
-	ads->ds_ctl5 = set11nPktDurRTSCTS(series, 2)
-		| set11nPktDurRTSCTS(series, 3);
-
-	ads->ds_ctl7 = set11nRateFlags(series, 0)
-		| set11nRateFlags(series, 1)
-		| set11nRateFlags(series, 2)
-		| set11nRateFlags(series, 3)
-		| SM(rtsctsRate, AR_RTSCTSRate);
-	last_ads->ds_ctl2 = ads->ds_ctl2;
-	last_ads->ds_ctl3 = ads->ds_ctl3;
-}
-
-static void ar9002_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
-					u32 aggrLen)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_ctl1 |= (AR_IsAggr | AR_MoreAggr);
-	ads->ds_ctl6 &= ~AR_AggrLen;
-	ads->ds_ctl6 |= SM(aggrLen, AR_AggrLen);
-}
-
-static void ar9002_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
-					 u32 numDelims)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-	unsigned int ctl6;
-
-	ads->ds_ctl1 |= (AR_IsAggr | AR_MoreAggr);
-
-	ctl6 = ads->ds_ctl6;
-	ctl6 &= ~AR_PadDelim;
-	ctl6 |= SM(numDelims, AR_PadDelim);
-	ads->ds_ctl6 = ctl6;
-}
-
-static void ar9002_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_ctl1 |= AR_IsAggr;
-	ads->ds_ctl1 &= ~AR_MoreAggr;
-	ads->ds_ctl6 &= ~AR_PadDelim;
-}
-
-static void ar9002_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
-}
-
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
@@ -534,13 +366,5 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->set_desc_link = ar9002_hw_set_desc_link;
 	ops->get_isr = ar9002_hw_get_isr;
 	ops->set_txdesc = ar9002_set_txdesc;
-	ops->fill_txdesc = ar9002_hw_fill_txdesc;
 	ops->proc_txdesc = ar9002_hw_proc_txdesc;
-	ops->set11n_txdesc = ar9002_hw_set11n_txdesc;
-	ops->set11n_ratescenario = ar9002_hw_set11n_ratescenario;
-	ops->set11n_aggr_first = ar9002_hw_set11n_aggr_first;
-	ops->set11n_aggr_middle = ar9002_hw_set11n_aggr_middle;
-	ops->set11n_aggr_last = ar9002_hw_set11n_aggr_last;
-	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
-	ops->set_clrdmask = ar9002_hw_set_clrdmask;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index e3382d5..6cabc85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -311,46 +311,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
-static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
-				  bool is_firstseg, bool is_lastseg,
-				  const void *ds0, dma_addr_t buf_addr,
-				  unsigned int qcu)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-	unsigned int descid = 0;
-
-	ads->info = (ATHEROS_VENDOR_ID << AR_DescId_S) |
-				     (1 << AR_TxRxDesc_S) |
-				     (1 << AR_CtrlStat_S) |
-				     (qcu << AR_TxQcuNum_S) | 0x17;
-
-	ads->data0 = buf_addr;
-	ads->data1 = 0;
-	ads->data2 = 0;
-	ads->data3 = 0;
-
-	ads->ctl3 = (seglen << AR_BufLen_S);
-	ads->ctl3 &= AR_BufLen;
-
-	/* Fill in pointer checksum and descriptor id */
-	ads->ctl10 = (descid << AR_TxDescId_S);
-
-	if (is_firstseg) {
-		ads->ctl12 |= (is_lastseg ? 0 : AR_TxMore);
-	} else if (is_lastseg) {
-		ads->ctl11 = 0;
-		ads->ctl12 = 0;
-		ads->ctl13 = AR9003TXC_CONST(ds0)->ctl13;
-		ads->ctl14 = AR9003TXC_CONST(ds0)->ctl14;
-	} else {
-		/* XXX Intermediate descriptor in a multi-descriptor frame.*/
-		ads->ctl11 = 0;
-		ads->ctl12 = AR_TxMore;
-		ads->ctl13 = 0;
-		ads->ctl14 = 0;
-	}
-}
-
 static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
@@ -435,161 +395,6 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	return 0;
 }
 
-static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
-		u32 pktlen, enum ath9k_pkt_type type, u32 txpower,
-		u8 keyIx, enum ath9k_key_type keyType, u32 flags)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	if (txpower > ah->txpower_limit)
-		txpower = ah->txpower_limit;
-
-	if (txpower > 63)
-		txpower = 63;
-
-	ads->ctl11 = (pktlen & AR_FrameLen)
-		| (flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
-		| SM(txpower, AR_XmitPower)
-		| (flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
-		| (keyIx != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
-		| (flags & ATH9K_TXDESC_LOWRXCHAIN ? AR_LowRxChain : 0);
-
-	ads->ctl12 =
-		(keyIx != ATH9K_TXKEYIX_INVALID ? SM(keyIx, AR_DestIdx) : 0)
-		| SM(type, AR_FrameType)
-		| (flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
-		| (flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
-		| (flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
-
-	ads->ctl17 = SM(keyType, AR_EncrType) |
-		     (flags & ATH9K_TXDESC_LDPC ? AR_LDPC : 0);
-	ads->ctl18 = 0;
-	ads->ctl19 = AR_Not_Sounding;
-
-	ads->ctl20 = 0;
-	ads->ctl21 = 0;
-	ads->ctl22 = 0;
-}
-
-static void ar9003_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	if (val)
-		ads->ctl11 |= AR_ClrDestMask;
-	else
-		ads->ctl11 &= ~AR_ClrDestMask;
-}
-
-static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
-					  void *lastds,
-					  u32 durUpdateEn, u32 rtsctsRate,
-					  u32 rtsctsDuration,
-					  struct ath9k_11n_rate_series series[],
-					  u32 nseries, u32 flags)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-	struct ar9003_txc *last_ads = (struct ar9003_txc *) lastds;
-	u_int32_t ctl11;
-
-	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
-		ctl11 = ads->ctl11;
-
-		if (flags & ATH9K_TXDESC_RTSENA) {
-			ctl11 &= ~AR_CTSEnable;
-			ctl11 |= AR_RTSEnable;
-		} else {
-			ctl11 &= ~AR_RTSEnable;
-			ctl11 |= AR_CTSEnable;
-		}
-
-		ads->ctl11 = ctl11;
-	} else {
-		ads->ctl11 = (ads->ctl11 & ~(AR_RTSEnable | AR_CTSEnable));
-	}
-
-	ads->ctl13 = set11nTries(series, 0)
-		|  set11nTries(series, 1)
-		|  set11nTries(series, 2)
-		|  set11nTries(series, 3)
-		|  (durUpdateEn ? AR_DurUpdateEna : 0)
-		|  SM(0, AR_BurstDur);
-
-	ads->ctl14 = set11nRate(series, 0)
-		|  set11nRate(series, 1)
-		|  set11nRate(series, 2)
-		|  set11nRate(series, 3);
-
-	ads->ctl15 = set11nPktDurRTSCTS(series, 0)
-		|  set11nPktDurRTSCTS(series, 1);
-
-	ads->ctl16 = set11nPktDurRTSCTS(series, 2)
-		|  set11nPktDurRTSCTS(series, 3);
-
-	ads->ctl18 = set11nRateFlags(series, 0)
-		|  set11nRateFlags(series, 1)
-		|  set11nRateFlags(series, 2)
-		|  set11nRateFlags(series, 3)
-		| SM(rtsctsRate, AR_RTSCTSRate);
-	ads->ctl19 = AR_Not_Sounding;
-
-	last_ads->ctl13 = ads->ctl13;
-	last_ads->ctl14 = ads->ctl14;
-}
-
-static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
-					u32 aggrLen)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
-
-	ads->ctl17 &= ~AR_AggrLen;
-	ads->ctl17 |= SM(aggrLen, AR_AggrLen);
-}
-
-static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
-					 u32 numDelims)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-	unsigned int ctl17;
-
-	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
-
-	/*
-	 * We use a stack variable to manipulate ctl6 to reduce uncached
-	 * read modify, modfiy, write.
-	 */
-	ctl17 = ads->ctl17;
-	ctl17 &= ~AR_PadDelim;
-	ctl17 |= SM(numDelims, AR_PadDelim);
-	ads->ctl17 = ctl17;
-}
-
-static void ar9003_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	ads->ctl12 |= AR_IsAggr;
-	ads->ctl12 &= ~AR_MoreAggr;
-	ads->ctl17 &= ~AR_PadDelim;
-}
-
-static void ar9003_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	ads->ctl12 &= (~AR_IsAggr & ~AR_MoreAggr);
-}
-
-void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains)
-{
-	struct ar9003_txc *ads = ds;
-
-	ads->ctl12 |= SM(chains, AR_PAPRDChainMask);
-}
-EXPORT_SYMBOL(ar9003_hw_set_paprd_txdesc);
-
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
@@ -598,15 +403,7 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->set_desc_link = ar9003_hw_set_desc_link;
 	ops->get_isr = ar9003_hw_get_isr;
 	ops->set_txdesc = ar9003_set_txdesc;
-	ops->fill_txdesc = ar9003_hw_fill_txdesc;
 	ops->proc_txdesc = ar9003_hw_proc_txdesc;
-	ops->set11n_txdesc = ar9003_hw_set11n_txdesc;
-	ops->set11n_ratescenario = ar9003_hw_set11n_ratescenario;
-	ops->set11n_aggr_first = ar9003_hw_set11n_aggr_first;
-	ops->set11n_aggr_middle = ar9003_hw_set11n_aggr_middle;
-	ops->set11n_aggr_last = ar9003_hw_set11n_aggr_last;
-	ops->clr11n_aggr = ar9003_hw_clr11n_aggr;
-	ops->set_clrdmask = ar9003_hw_set_clrdmask;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 5310f96..41f4bf3 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -60,70 +60,12 @@ static inline void ath9k_hw_set_txdesc(struct ath_hw *ah, void *ds,
 	return ath9k_hw_ops(ah)->set_txdesc(ah, ds, i);
 }
 
-static inline void ath9k_hw_filltxdesc(struct ath_hw *ah, void *ds, u32 seglen,
-				  bool is_firstseg, bool is_lastseg,
-				  const void *ds0, dma_addr_t buf_addr,
-				  unsigned int qcu)
-{
-	ath9k_hw_ops(ah)->fill_txdesc(ah, ds, seglen, is_firstseg, is_lastseg,
-				      ds0, buf_addr, qcu);
-}
-
 static inline int ath9k_hw_txprocdesc(struct ath_hw *ah, void *ds,
 				      struct ath_tx_status *ts)
 {
 	return ath9k_hw_ops(ah)->proc_txdesc(ah, ds, ts);
 }
 
-static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
-					  u32 pktLen, enum ath9k_pkt_type type,
-					  u32 txPower, u32 keyIx,
-					  enum ath9k_key_type keyType,
-					  u32 flags)
-{
-	ath9k_hw_ops(ah)->set11n_txdesc(ah, ds, pktLen, type, txPower, keyIx,
-				      keyType, flags);
-}
-
-static inline void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
-					void *lastds,
-					u32 durUpdateEn, u32 rtsctsRate,
-					u32 rtsctsDuration,
-					struct ath9k_11n_rate_series series[],
-					u32 nseries, u32 flags)
-{
-	ath9k_hw_ops(ah)->set11n_ratescenario(ah, ds, lastds, durUpdateEn,
-					    rtsctsRate, rtsctsDuration, series,
-					    nseries, flags);
-}
-
-static inline void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
-					u32 aggrLen)
-{
-	ath9k_hw_ops(ah)->set11n_aggr_first(ah, ds, aggrLen);
-}
-
-static inline void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
-					       u32 numDelims)
-{
-	ath9k_hw_ops(ah)->set11n_aggr_middle(ah, ds, numDelims);
-}
-
-static inline void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
-{
-	ath9k_hw_ops(ah)->set11n_aggr_last(ah, ds);
-}
-
-static inline void ath9k_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
-{
-	ath9k_hw_ops(ah)->clr11n_aggr(ah, ds);
-}
-
-static inline void ath9k_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
-{
-	ath9k_hw_ops(ah)->set_clrdmask(ah, ds, val);
-}
-
 static inline void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 		struct ath_hw_antcomb_conf *antconf)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index bea7883..1444292 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -617,30 +617,8 @@ struct ath_hw_ops {
 	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked);
 	void (*set_txdesc)(struct ath_hw *ah, void *ds,
 			   struct ath_tx_info *i);
-	void (*fill_txdesc)(struct ath_hw *ah, void *ds, u32 seglen,
-			    bool is_firstseg, bool is_is_lastseg,
-			    const void *ds0, dma_addr_t buf_addr,
-			    unsigned int qcu);
 	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
 			   struct ath_tx_status *ts);
-	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
-			      u32 pktLen, enum ath9k_pkt_type type,
-			      u32 txPower, u8 keyIx,
-			      enum ath9k_key_type keyType,
-			      u32 flags);
-	void (*set11n_ratescenario)(struct ath_hw *ah, void *ds,
-				void *lastds,
-				u32 durUpdateEn, u32 rtsctsRate,
-				u32 rtsctsDuration,
-				struct ath9k_11n_rate_series series[],
-				u32 nseries, u32 flags);
-	void (*set11n_aggr_first)(struct ath_hw *ah, void *ds,
-				  u32 aggrLen);
-	void (*set11n_aggr_middle)(struct ath_hw *ah, void *ds,
-				   u32 numDelims);
-	void (*set11n_aggr_last)(struct ath_hw *ah, void *ds);
-	void (*clr11n_aggr)(struct ath_hw *ah, void *ds);
-	void (*set_clrdmask)(struct ath_hw *ah, void *ds, bool val);
 	void (*antdiv_comb_conf_get)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 7ce9b32..786587a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -62,18 +62,6 @@ void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_txstart);
 
-void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_txstatus0 = ads->ds_txstatus1 = 0;
-	ads->ds_txstatus2 = ads->ds_txstatus3 = 0;
-	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
-	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
-	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
-}
-EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
-
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 {
 	u32 npend;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 2a3af33..25f2c9a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -711,7 +711,6 @@ enum ath9k_int;
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q);
-void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q);
-- 
1.7.3.2

