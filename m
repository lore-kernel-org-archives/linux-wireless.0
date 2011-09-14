Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58755 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab1INTYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 06/12] ath9k_hw: add a new API for setting tx descriptors
Date: Wed, 14 Sep 2011 21:24:21 +0200
Message-Id: <1316028267-34187-6-git-send-email-nbd@openwrt.org> (sfid-20110914_212454_373521_CB4DA112)
In-Reply-To: <1316028267-34187-5-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using lots of different functions with long argument lists,
pull all the necessary information from one struct. This makes the code
easier to read and eliminates the need for copying data between multiple
linked descriptors.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |  101 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  127 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +
 drivers/net/wireless/ath/ath9k/mac.h        |   40 ++++++++-
 5 files changed, 275 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 33deb0d..cb86c95 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -170,6 +170,106 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
+static void
+ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
+{
+	struct ar5416_desc *ads = AR5416DESC(ds);
+	u32 ctl1, ctl6;
+
+	ads->ds_txstatus0 = ads->ds_txstatus1 = 0;
+	ads->ds_txstatus2 = ads->ds_txstatus3 = 0;
+	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
+	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
+	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
+
+	ACCESS_ONCE(ads->ds_link) = i->link;
+	ACCESS_ONCE(ads->ds_data) = i->buf_addr[0];
+
+	ctl1 = i->buf_len[0] | (i->is_last ? 0 : AR_TxMore);
+	ctl6 = SM(i->keytype, AR_EncrType);
+
+	if (AR_SREV_9285(ah)) {
+		ads->ds_ctl8 = 0;
+		ads->ds_ctl9 = 0;
+		ads->ds_ctl10 = 0;
+		ads->ds_ctl11 = 0;
+	}
+
+	if ((i->is_first || i->is_last) &&
+	    i->aggr != AGGR_BUF_MIDDLE && i->aggr != AGGR_BUF_LAST) {
+		ACCESS_ONCE(ads->ds_ctl2) = set11nTries(i->rates, 0)
+			| set11nTries(i->rates, 1)
+			| set11nTries(i->rates, 2)
+			| set11nTries(i->rates, 3)
+			| (i->dur_update ? AR_DurUpdateEna : 0)
+			| SM(0, AR_BurstDur);
+
+		ACCESS_ONCE(ads->ds_ctl3) = set11nRate(i->rates, 0)
+			| set11nRate(i->rates, 1)
+			| set11nRate(i->rates, 2)
+			| set11nRate(i->rates, 3);
+	} else {
+		ACCESS_ONCE(ads->ds_ctl2) = 0;
+		ACCESS_ONCE(ads->ds_ctl3) = 0;
+	}
+
+	if (!i->is_first) {
+		ACCESS_ONCE(ads->ds_ctl0) = 0;
+		ACCESS_ONCE(ads->ds_ctl1) = ctl1;
+		ACCESS_ONCE(ads->ds_ctl6) = ctl6;
+		return;
+	}
+
+	ctl1 |= (i->keyix != ATH9K_TXKEYIX_INVALID ? SM(i->keyix, AR_DestIdx) : 0)
+		| SM(i->type, AR_FrameType)
+		| (i->flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
+		| (i->flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
+		| (i->flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
+
+	switch (i->aggr) {
+	case AGGR_BUF_FIRST:
+		ctl6 |= SM(i->aggr_len, AR_AggrLen);
+		/* fall through */
+	case AGGR_BUF_MIDDLE:
+		ctl1 |= AR_IsAggr | AR_MoreAggr;
+		ctl6 |= SM(i->ndelim, AR_PadDelim);
+		break;
+	case AGGR_BUF_LAST:
+		ctl1 |= AR_IsAggr;
+		break;
+	case AGGR_BUF_NONE:
+		break;
+	}
+
+	ACCESS_ONCE(ads->ds_ctl0) = (i->pkt_len & AR_FrameLen)
+		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
+		| SM(i->txpower, AR_XmitPower)
+		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
+		| (i->flags & ATH9K_TXDESC_INTREQ ? AR_TxIntrReq : 0)
+		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
+		| (i->flags & ATH9K_TXDESC_CLRDMASK ? AR_ClrDestMask : 0)
+		| (i->flags & ATH9K_TXDESC_RTSENA ? AR_RTSEnable :
+		   (i->flags & ATH9K_TXDESC_CTSENA ? AR_CTSEnable : 0));
+
+	ACCESS_ONCE(ads->ds_ctl1) = ctl1;
+	ACCESS_ONCE(ads->ds_ctl6) = ctl6;
+
+	if (i->aggr == AGGR_BUF_MIDDLE || i->aggr == AGGR_BUF_LAST)
+		return;
+
+	ACCESS_ONCE(ads->ds_ctl4) = set11nPktDurRTSCTS(i->rates, 0)
+		| set11nPktDurRTSCTS(i->rates, 1);
+
+	ACCESS_ONCE(ads->ds_ctl5) = set11nPktDurRTSCTS(i->rates, 2)
+		| set11nPktDurRTSCTS(i->rates, 3);
+
+	ACCESS_ONCE(ads->ds_ctl7) = set11nRateFlags(i->rates, 0)
+		| set11nRateFlags(i->rates, 1)
+		| set11nRateFlags(i->rates, 2)
+		| set11nRateFlags(i->rates, 3)
+		| SM(i->rtscts_rate, AR_RTSCTSRate);
+}
+
 static void ar9002_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
 				  bool is_firstseg, bool is_lastseg,
 				  const void *ds0, dma_addr_t buf_addr,
@@ -433,6 +533,7 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->rx_enable = ar9002_hw_rx_enable;
 	ops->set_desc_link = ar9002_hw_set_desc_link;
 	ops->get_isr = ar9002_hw_get_isr;
+	ops->set_txdesc = ar9002_set_txdesc;
 	ops->fill_txdesc = ar9002_hw_fill_txdesc;
 	ops->proc_txdesc = ar9002_hw_proc_txdesc;
 	ops->set11n_txdesc = ar9002_hw_set11n_txdesc;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index c3179d9..e3382d5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -21,6 +21,132 @@ static void ar9003_hw_rx_enable(struct ath_hw *hw)
 	REG_WRITE(hw, AR_CR, 0);
 }
 
+static void
+ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
+{
+	struct ar9003_txc *ads = ds;
+	int checksum = 0;
+	u32 val, ctl12, ctl17;
+
+	val = (ATHEROS_VENDOR_ID << AR_DescId_S) |
+	      (1 << AR_TxRxDesc_S) |
+	      (1 << AR_CtrlStat_S) |
+	      (i->qcu << AR_TxQcuNum_S) | 0x17;
+
+	checksum += val;
+	ACCESS_ONCE(ads->info) = val;
+
+	checksum += i->link;
+	ACCESS_ONCE(ads->link) = i->link;
+
+	checksum += i->buf_addr[0];
+	ACCESS_ONCE(ads->data0) = i->buf_addr[0];
+	checksum += i->buf_addr[1];
+	ACCESS_ONCE(ads->data1) = i->buf_addr[1];
+	checksum += i->buf_addr[2];
+	ACCESS_ONCE(ads->data2) = i->buf_addr[2];
+	checksum += i->buf_addr[3];
+	ACCESS_ONCE(ads->data3) = i->buf_addr[3];
+
+	checksum += (val = (i->buf_len[0] << AR_BufLen_S) & AR_BufLen);
+	ACCESS_ONCE(ads->ctl3) = val;
+	checksum += (val = (i->buf_len[1] << AR_BufLen_S) & AR_BufLen);
+	ACCESS_ONCE(ads->ctl5) = val;
+	checksum += (val = (i->buf_len[2] << AR_BufLen_S) & AR_BufLen);
+	ACCESS_ONCE(ads->ctl7) = val;
+	checksum += (val = (i->buf_len[3] << AR_BufLen_S) & AR_BufLen);
+	ACCESS_ONCE(ads->ctl9) = val;
+
+	checksum = (u16) (((checksum & 0xffff) + (checksum >> 16)) & 0xffff);
+	ACCESS_ONCE(ads->ctl10) = checksum;
+
+	if (i->is_first || i->is_last) {
+		ACCESS_ONCE(ads->ctl13) = set11nTries(i->rates, 0)
+			| set11nTries(i->rates, 1)
+			| set11nTries(i->rates, 2)
+			| set11nTries(i->rates, 3)
+			| (i->dur_update ? AR_DurUpdateEna : 0)
+			| SM(0, AR_BurstDur);
+
+		ACCESS_ONCE(ads->ctl14) = set11nRate(i->rates, 0)
+			| set11nRate(i->rates, 1)
+			| set11nRate(i->rates, 2)
+			| set11nRate(i->rates, 3);
+	} else {
+		ACCESS_ONCE(ads->ctl13) = 0;
+		ACCESS_ONCE(ads->ctl14) = 0;
+	}
+
+	ads->ctl20 = 0;
+	ads->ctl21 = 0;
+	ads->ctl22 = 0;
+
+	ctl17 = SM(i->keytype, AR_EncrType);
+	if (!i->is_first) {
+		ACCESS_ONCE(ads->ctl11) = 0;
+		ACCESS_ONCE(ads->ctl12) = i->is_last ? 0 : AR_TxMore;
+		ACCESS_ONCE(ads->ctl15) = 0;
+		ACCESS_ONCE(ads->ctl16) = 0;
+		ACCESS_ONCE(ads->ctl17) = ctl17;
+		ACCESS_ONCE(ads->ctl18) = 0;
+		ACCESS_ONCE(ads->ctl19) = 0;
+		return;
+	}
+
+	ACCESS_ONCE(ads->ctl11) = (i->pkt_len & AR_FrameLen)
+		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
+		| SM(i->txpower, AR_XmitPower)
+		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
+		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
+		| (i->flags & ATH9K_TXDESC_LOWRXCHAIN ? AR_LowRxChain : 0)
+		| (i->flags & ATH9K_TXDESC_CLRDMASK ? AR_ClrDestMask : 0)
+		| (i->flags & ATH9K_TXDESC_RTSENA ? AR_RTSEnable :
+		   (i->flags & ATH9K_TXDESC_CTSENA ? AR_CTSEnable : 0));
+
+	ctl12 = (i->keyix != ATH9K_TXKEYIX_INVALID ?
+		 SM(i->keyix, AR_DestIdx) : 0)
+		| SM(i->type, AR_FrameType)
+		| (i->flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
+		| (i->flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
+		| (i->flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
+
+	ctl17 |= (i->flags & ATH9K_TXDESC_LDPC ? AR_LDPC : 0);
+	switch (i->aggr) {
+	case AGGR_BUF_FIRST:
+		ctl17 |= SM(i->aggr_len, AR_AggrLen);
+		/* fall through */
+	case AGGR_BUF_MIDDLE:
+		ctl12 |= AR_IsAggr | AR_MoreAggr;
+		ctl17 |= SM(i->ndelim, AR_PadDelim);
+		break;
+	case AGGR_BUF_LAST:
+		ctl12 |= AR_IsAggr;
+		break;
+	case AGGR_BUF_NONE:
+		break;
+	}
+
+	val = (i->flags & ATH9K_TXDESC_PAPRD) >> ATH9K_TXDESC_PAPRD_S;
+	ctl12 |= SM(val, AR_PAPRDChainMask);
+
+	ACCESS_ONCE(ads->ctl12) = ctl12;
+	ACCESS_ONCE(ads->ctl17) = ctl17;
+
+	ACCESS_ONCE(ads->ctl15) = set11nPktDurRTSCTS(i->rates, 0)
+		| set11nPktDurRTSCTS(i->rates, 1);
+
+	ACCESS_ONCE(ads->ctl16) = set11nPktDurRTSCTS(i->rates, 2)
+		| set11nPktDurRTSCTS(i->rates, 3);
+
+	ACCESS_ONCE(ads->ctl18) = set11nRateFlags(i->rates, 0)
+		| set11nRateFlags(i->rates, 1)
+		| set11nRateFlags(i->rates, 2)
+		| set11nRateFlags(i->rates, 3)
+		| SM(i->rtscts_rate, AR_RTSCTSRate);
+
+	ACCESS_ONCE(ads->ctl19) = AR_Not_Sounding;
+}
+
 static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
 {
 	int checksum;
@@ -471,6 +597,7 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->rx_enable = ar9003_hw_rx_enable;
 	ops->set_desc_link = ar9003_hw_set_desc_link;
 	ops->get_isr = ar9003_hw_get_isr;
+	ops->set_txdesc = ar9003_set_txdesc;
 	ops->fill_txdesc = ar9003_hw_fill_txdesc;
 	ops->proc_txdesc = ar9003_hw_proc_txdesc;
 	ops->set11n_txdesc = ar9003_hw_set11n_txdesc;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index dd9003e..5310f96 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -54,6 +54,12 @@ static inline bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 	return ath9k_hw_ops(ah)->get_isr(ah, masked);
 }
 
+static inline void ath9k_hw_set_txdesc(struct ath_hw *ah, void *ds,
+				       struct ath_tx_info *i)
+{
+	return ath9k_hw_ops(ah)->set_txdesc(ah, ds, i);
+}
+
 static inline void ath9k_hw_filltxdesc(struct ath_hw *ah, void *ds, u32 seglen,
 				  bool is_firstseg, bool is_lastseg,
 				  const void *ds0, dma_addr_t buf_addr,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c8af86c..bea7883 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -615,6 +615,8 @@ struct ath_hw_ops {
 			  u8 rxchainmask,
 			  bool longcal);
 	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked);
+	void (*set_txdesc)(struct ath_hw *ah, void *ds,
+			   struct ath_tx_info *i);
 	void (*fill_txdesc)(struct ath_hw *ah, void *ds, u32 seglen,
 			    bool is_firstseg, bool is_is_lastseg,
 			    const void *ds0, dma_addr_t buf_addr,
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index acb83bf..2a3af33 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -263,7 +263,11 @@ struct ath_desc {
 #define ATH9K_TXDESC_VMF		0x0100
 #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
 #define ATH9K_TXDESC_LOWRXCHAIN		0x0400
-#define ATH9K_TXDESC_LDPC		0x00010000
+#define ATH9K_TXDESC_LDPC		0x0800
+#define ATH9K_TXDESC_CLRDMASK		0x1000
+
+#define ATH9K_TXDESC_PAPRD		0x70000
+#define ATH9K_TXDESC_PAPRD_S		16
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 
@@ -659,6 +663,13 @@ struct ath9k_11n_rate_series {
 	u32 RateFlags;
 };
 
+enum aggr_type {
+	AGGR_BUF_NONE,
+	AGGR_BUF_FIRST,
+	AGGR_BUF_MIDDLE,
+	AGGR_BUF_LAST,
+};
+
 enum ath9k_key_type {
 	ATH9K_KEY_TYPE_CLEAR,
 	ATH9K_KEY_TYPE_WEP,
@@ -666,6 +677,33 @@ enum ath9k_key_type {
 	ATH9K_KEY_TYPE_TKIP,
 };
 
+struct ath_tx_info {
+	u8 qcu;
+
+	bool is_first;
+	bool is_last;
+
+	enum aggr_type aggr;
+	u8 ndelim;
+	u16 aggr_len;
+
+	dma_addr_t link;
+	int pkt_len;
+	u32 flags;
+
+	dma_addr_t buf_addr[4];
+	int buf_len[4];
+
+	struct ath9k_11n_rate_series rates[4];
+	u8 rtscts_rate;
+	bool dur_update;
+
+	enum ath9k_pkt_type type;
+	enum ath9k_key_type keytype;
+	u8 keyix;
+	u8 txpower;
+};
+
 struct ath_hw;
 struct ath9k_channel;
 enum ath9k_int;
-- 
1.7.3.2

