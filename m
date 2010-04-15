Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 84/97] ath9k_hw: Fill descriptor abstrations for AR9003
Date: Thu, 15 Apr 2010 17:39:29 -0400
Message-Id: <1271367582-992-85-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  234 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |   20 +++
 drivers/net/wireless/ath/ath9k/mac.h        |    7 +-
 3 files changed, 254 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index cb93d23..1a8c1ba 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -168,23 +168,169 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
+static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
+{
+	int checksum;
+
+	checksum = ads->info + ads->link
+		+ ads->data0 + ads->ctl3
+		+ ads->data1 + ads->ctl5
+		+ ads->data2 + ads->ctl7
+		+ ads->data3 + ads->ctl9;
+
+	return ((checksum & 0xffff) + (checksum >> 16)) & AR_TxPtrChkSum;
+}
+
 static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
 				  bool is_firstseg, bool is_lastseg,
 				  const void *ds0, dma_addr_t buf_addr,
 				  unsigned int qcu)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+	unsigned int descid = 0;
+
+	ads->info = (ATHEROS_VENDOR_ID << AR_DescId_S) |
+				     (1 << AR_TxRxDesc_S) |
+				     (1 << AR_CtrlStat_S) |
+				     (qcu << AR_TxQcuNum_S) | 0x17;
+
+	ads->data0 = buf_addr;
+	ads->data1 = 0;
+	ads->data2 = 0;
+	ads->data3 = 0;
+
+	ads->ctl3 = (seglen << AR_BufLen_S);
+	ads->ctl3 &= AR_BufLen;
+
+	/* Fill in pointer checksum and descriptor id */
+	ads->ctl10 = ar9003_calc_ptr_chksum(ads);
+	ads->ctl10 |= (descid << AR_TxDescId_S);
+
+	if (is_firstseg) {
+		ads->ctl12 |= (is_lastseg ? 0 : AR_TxMore);
+	} else if (is_lastseg) {
+		ads->ctl11 = 0;
+		ads->ctl12 = 0;
+		ads->ctl13 = AR9003TXC_CONST(ds0)->ctl13;
+		ads->ctl14 = AR9003TXC_CONST(ds0)->ctl14;
+	} else {
+		/* XXX Intermediate descriptor in a multi-descriptor frame.*/
+		ads->ctl11 = 0;
+		ads->ctl12 = AR_TxMore;
+		ads->ctl13 = 0;
+		ads->ctl14 = 0;
+	}
 }
 
 static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
+	struct ar9003_txs *ads;
+
+	ads = &ah->ts_ring[ah->ts_tail];
+
+	if ((ads->status8 & AR_TxDone) == 0)
+		return -EINPROGRESS;
+
+	ah->ts_tail = (ah->ts_tail + 1) % ah->ts_size;
+
+	if ((MS(ads->ds_info, AR_DescId) != ATHEROS_VENDOR_ID) ||
+	    (MS(ads->ds_info, AR_TxRxDesc) != 1)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_XMIT,
+			  "Tx Descriptor error %x\n", ads->ds_info);
+		memset(ads, 0, sizeof(*ads));
+		return -EIO;
+	}
+
+	ts->qid = MS(ads->ds_info, AR_TxQcuNum);
+	ts->desc_id = MS(ads->status1, AR_TxDescId);
+	ts->ts_seqnum = MS(ads->status8, AR_SeqNum);
+	ts->ts_tstamp = ads->status4;
+	ts->ts_status = 0;
+	ts->ts_flags  = 0;
+
+	if (ads->status3 & AR_ExcessiveRetries)
+		ts->ts_status |= ATH9K_TXERR_XRETRY;
+	if (ads->status3 & AR_Filtered)
+		ts->ts_status |= ATH9K_TXERR_FILT;
+	if (ads->status3 & AR_FIFOUnderrun) {
+		ts->ts_status |= ATH9K_TXERR_FIFO;
+		ath9k_hw_updatetxtriglevel(ah, true);
+	}
+	if (ads->status8 & AR_TxOpExceeded)
+		ts->ts_status |= ATH9K_TXERR_XTXOP;
+	if (ads->status3 & AR_TxTimerExpired)
+		ts->ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
+
+	if (ads->status3 & AR_DescCfgErr)
+		ts->ts_flags |= ATH9K_TX_DESC_CFG_ERR;
+	if (ads->status3 & AR_TxDataUnderrun) {
+		ts->ts_flags |= ATH9K_TX_DATA_UNDERRUN;
+		ath9k_hw_updatetxtriglevel(ah, true);
+	}
+	if (ads->status3 & AR_TxDelimUnderrun) {
+		ts->ts_flags |= ATH9K_TX_DELIM_UNDERRUN;
+		ath9k_hw_updatetxtriglevel(ah, true);
+	}
+	if (ads->status2 & AR_TxBaStatus) {
+		ts->ts_flags |= ATH9K_TX_BA;
+		ts->ba_low = ads->status5;
+		ts->ba_high = ads->status6;
+	}
+
+	ts->ts_rateindex = MS(ads->status8, AR_FinalTxIdx);
+
+	ts->ts_rssi = MS(ads->status7, AR_TxRSSICombined);
+	ts->ts_rssi_ctl0 = MS(ads->status2, AR_TxRSSIAnt00);
+	ts->ts_rssi_ctl1 = MS(ads->status2, AR_TxRSSIAnt01);
+	ts->ts_rssi_ctl2 = MS(ads->status2, AR_TxRSSIAnt02);
+	ts->ts_rssi_ext0 = MS(ads->status7, AR_TxRSSIAnt10);
+	ts->ts_rssi_ext1 = MS(ads->status7, AR_TxRSSIAnt11);
+	ts->ts_rssi_ext2 = MS(ads->status7, AR_TxRSSIAnt12);
+	ts->ts_shortretry = MS(ads->status3, AR_RTSFailCnt);
+	ts->ts_longretry = MS(ads->status3, AR_DataFailCnt);
+	ts->ts_virtcol = MS(ads->status3, AR_VirtRetryCnt);
+	ts->ts_antenna = 0;
+
+	ts->tid = MS(ads->status8, AR_TxTid);
+
+	memset(ads, 0, sizeof(*ads));
+
 	return 0;
 }
+
 static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
-			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
-			    u32 keyIx, enum ath9k_key_type keyType, u32 flags)
+		u32 pktlen, enum ath9k_pkt_type type, u32 txpower,
+		u32 keyIx, enum ath9k_key_type keyType, u32 flags)
 {
-
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+
+	txpower += ah->txpower_indexoffset;
+	if (txpower > 63)
+		txpower = 63;
+
+	ads->ctl11 = (pktlen & AR_FrameLen)
+		| (flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
+		| SM(txpower, AR_XmitPower)
+		| (flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
+		| (flags & ATH9K_TXDESC_CLRDMASK ? AR_ClrDestMask : 0)
+		| (keyIx != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
+		| (flags & ATH9K_TXDESC_LOWRXCHAIN ? AR_LowRxChain : 0);
+
+	ads->ctl12 =
+		(keyIx != ATH9K_TXKEYIX_INVALID ? SM(keyIx, AR_DestIdx) : 0)
+		| SM(type, AR_FrameType)
+		| (flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
+		| (flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
+		| (flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
+
+	ads->ctl17 = SM(keyType, AR_EncrType);
+	ads->ctl18 = 0;
+	ads->ctl19 = AR_Not_Sounding;
+
+	ads->ctl20 = 0;
+	ads->ctl21 = 0;
+	ads->ctl22 = 0;
 }
 
 static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
@@ -194,41 +340,119 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 					  struct ath9k_11n_rate_series series[],
 					  u32 nseries, u32 flags)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+	struct ar9003_txc *last_ads = (struct ar9003_txc *) lastds;
+	u_int32_t ctl11;
+
+	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
+		ctl11 = ads->ctl11;
+
+		if (flags & ATH9K_TXDESC_RTSENA) {
+			ctl11 &= ~AR_CTSEnable;
+			ctl11 |= AR_RTSEnable;
+		} else {
+			ctl11 &= ~AR_RTSEnable;
+			ctl11 |= AR_CTSEnable;
+		}
+
+		ads->ctl11 = ctl11;
+	} else {
+		ads->ctl11 = (ads->ctl11 & ~(AR_RTSEnable | AR_CTSEnable));
+	}
 
+	ads->ctl13 = set11nTries(series, 0)
+		|  set11nTries(series, 1)
+		|  set11nTries(series, 2)
+		|  set11nTries(series, 3)
+		|  (durUpdateEn ? AR_DurUpdateEna : 0)
+		|  SM(0, AR_BurstDur);
+
+	ads->ctl14 = set11nRate(series, 0)
+		|  set11nRate(series, 1)
+		|  set11nRate(series, 2)
+		|  set11nRate(series, 3);
+
+	ads->ctl15 = set11nPktDurRTSCTS(series, 0)
+		|  set11nPktDurRTSCTS(series, 1);
+
+	ads->ctl16 = set11nPktDurRTSCTS(series, 2)
+		|  set11nPktDurRTSCTS(series, 3);
+
+	ads->ctl18 = set11nRateFlags(series, 0)
+		|  set11nRateFlags(series, 1)
+		|  set11nRateFlags(series, 2)
+		|  set11nRateFlags(series, 3)
+		| SM(rtsctsRate, AR_RTSCTSRate);
+	ads->ctl19 = AR_Not_Sounding;
+
+	last_ads->ctl13 = ads->ctl13;
+	last_ads->ctl14 = ads->ctl14;
 }
 
 static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
 					u32 aggrLen)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+
+	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
 
+	ads->ctl17 &= ~AR_AggrLen;
+	ads->ctl17 |= SM(aggrLen, AR_AggrLen);
 }
 
 static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
 					 u32 numDelims)
 {
-
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+	unsigned int ctl17;
+
+	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
+
+	/*
+	 * We use a stack variable to manipulate ctl6 to reduce uncached
+	 * read modify, modfiy, write.
+	 */
+	ctl17 = ads->ctl17;
+	ctl17 &= ~AR_PadDelim;
+	ctl17 |= SM(numDelims, AR_PadDelim);
+	ads->ctl17 = ctl17;
 }
 
 static void ar9003_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
+	ads->ctl12 |= AR_IsAggr;
+	ads->ctl12 &= ~AR_MoreAggr;
+	ads->ctl17 &= ~AR_PadDelim;
 }
 
 static void ar9003_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
+	ads->ctl12 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
 
 static void ar9003_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
 					   u32 burstDuration)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+
+	ads->ctl13 &= ~AR_BurstDur;
+	ads->ctl13 |= SM(burstDuration, AR_BurstDur);
 
 }
 
 static void ar9003_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
-					    u32 vmf)
+					     u32 vmf)
 {
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
+	if (vmf)
+		ads->ctl11 |=  AR_VirtMoreFrag;
+	else
+		ads->ctl11 &= ~AR_VirtMoreFrag;
 }
 
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index ef79996..f17558b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -20,7 +20,25 @@
 #define AR_DescId	0xffff0000
 #define AR_DescId_S	16
 #define AR_CtrlStat	0x00004000
+#define AR_CtrlStat_S	14
 #define AR_TxRxDesc	0x00008000
+#define AR_TxRxDesc_S	15
+#define AR_TxQcuNum	0x00000f00
+#define AR_TxQcuNum_S	8
+
+#define AR_BufLen	0x0fff0000
+#define AR_BufLen_S	16
+
+#define AR_TxDescId	0xffff0000
+#define AR_TxDescId_S	16
+#define AR_TxPtrChkSum	0x0000ffff
+
+#define AR_TxTid	0xf0000000
+#define AR_TxTid_S	28
+
+#define AR_LowRxChain	0x00004000
+
+#define AR_Not_Sounding	0x20000000
 
 #define MAP_ISR_S2_CST          6
 #define MAP_ISR_S2_GTT          6
@@ -30,6 +48,8 @@
 #define MAP_ISR_S2_DTIM         7
 #define MAP_ISR_S2_TSFOOR       4
 
+#define AR9003TXC_CONST(_ds) ((const struct ar9003_txc *) _ds)
+
 struct ar9003_rxs {
 	u32 ds_info;
 	u32 status1;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index eb430c4..b591dc2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -116,7 +116,10 @@ struct ath_tx_status {
 	int8_t ts_rssi_ext0;
 	int8_t ts_rssi_ext1;
 	int8_t ts_rssi_ext2;
-	u8 pad[3];
+	u8 qid;
+	u16 desc_id;
+	u8 tid;
+	u8 pad[2];
 	u32 ba_low;
 	u32 ba_high;
 	u32 evm0;
@@ -260,7 +263,7 @@ struct ath_desc {
 #define ATH9K_TXDESC_EXT_AND_CTL	0x0080
 #define ATH9K_TXDESC_VMF		0x0100
 #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
-#define ATH9K_TXDESC_CAB		0x0400
+#define ATH9K_TXDESC_LOWRXCHAIN		0x0400
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 
-- 
1.6.3.3

