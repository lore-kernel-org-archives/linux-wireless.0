Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25308 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0KJMYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:24:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:24:09 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 5/5] ath9k_hw: Add support for Tx beamforming.
Date: Wed, 10 Nov 2010 17:53:49 +0530
Message-ID: <1289391829-8577-5-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-4-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-3-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-4-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize Tx beamforming capabilities, related registers and set
descriptors for sounding frames.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile      |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c  |   80 ++++++-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h  |   22 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h  |   11 +
 drivers/net/wireless/ath/ath9k/ar9003_txbf.c |  359 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_txbf.h |   87 +++++++
 drivers/net/wireless/ath/ath9k/hw.c          |    3 +
 drivers/net/wireless/ath/ath9k/hw.h          |   56 ++++
 drivers/net/wireless/ath/ath9k/mac.h         |   48 ++++-
 drivers/net/wireless/ath/ath9k/reg.h         |  119 +++++++++-
 10 files changed, 782 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_txbf.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_txbf.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index aca0162..3f4a6e6 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -33,7 +33,8 @@ ath9k_hw-y:=	\
 		ar9002_mac.o \
 		ar9003_mac.o \
 		ar9003_eeprom.o \
-		ar9003_paprd.o
+		ar9003_paprd.o \
+		ar9003_txbf.o
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 10c812e..66795c9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -15,6 +15,7 @@
  */
 #include "hw.h"
 #include "ar9003_mac.h"
+#include "ar9003_phy.h"
 
 static void ar9003_hw_rx_enable(struct ath_hw *hw)
 {
@@ -302,6 +303,22 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_longretry = MS(status, AR_DataFailCnt);
 	ts->ts_virtcol = MS(status, AR_VirtRetryCnt);
 
+	ts->ts_txbfstatus = 0;
+	if (ads->status8 & AR_TxBF_BW_Mismatch)
+		ts->ts_txbfstatus |= AR_BW_Mismatch;
+
+	if (ads->status8 & AR_TxBF_Stream_Miss)
+		ts->ts_txbfstatus |= AR_Stream_Miss;
+
+	if (ads->status8 & AR_TxBF_Dest_Miss)
+		ts->ts_txbfstatus |= AR_Dest_Miss;
+
+	if (ads->status8 & AR_TxBF_Expired)
+		ts->ts_txbfstatus |= AR_Expired;
+
+	if (ts->ts_txbfstatus)
+		ts->ts_flags |= ATH9K_TX_BF_ERR;
+
 	status = ACCESS_ONCE(ads->status7);
 	ts->ts_rssi = MS(status, AR_TxRSSICombined);
 	ts->ts_rssi_ext0 = MS(status, AR_TxRSSIAnt10);
@@ -360,7 +377,7 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 {
 	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 	struct ar9003_txc *last_ads = (struct ar9003_txc *) lastds;
-	u_int32_t ctl11;
+	u32 ctl11, steerflag, tmp;
 
 	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
 		ctl11 = ads->ctl11;
@@ -378,6 +395,48 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 		ads->ctl11 = (ads->ctl11 & ~(AR_RTSEnable | AR_CTSEnable));
 	}
 
+	if (flags & (ATH9K_TXDESC_TXBF_SOUND | ATH9K_TXDESC_TXBF_STAG_SOUND)) {
+		steerflag = set11n_txbf_flags(series, 0)
+			|  set11n_txbf_flags(series, 1)
+			|  set11n_txbf_flags(series, 2)
+			|  set11n_txbf_flags(series, 3);
+
+		if (steerflag != 0) {
+			if (ads->ctl17 & AR_LDPC) {
+				if (not_two_stream_rate(series[0].Rate)) {
+					steerflag = set11n_txbf_flags(series, 0);
+					if (not_two_stream_rate(series[1].Rate))
+						steerflag |=
+						 set11n_txbf_flags(series, 1);
+
+					if (not_two_stream_rate(series[2].Rate))
+						steerflag |=
+						 set11n_txbf_flags(series, 2);
+
+					if (not_two_stream_rate(series[3].Rate))
+						steerflag |=
+						 set11n_txbf_flags(series, 3);
+
+				} else
+					ads->ctl17 &=  ~(AR_LDPC);
+			}
+			ads->ctl11 |= steerflag;
+		}
+	}
+	if (flags & ATH9K_TXDESC_CAL) {
+		tmp = REG_READ(ah, AR_PHY_PERCHAIN_CSD);
+		tmp |= SM(8, AR_PHY_PERCHAIN_CSD_chn1_2chains);
+		tmp |= SM(4, AR_PHY_PERCHAIN_CSD_chn1_3chains);
+		tmp |= SM(8, AR_PHY_PERCHAIN_CSD_chn2_3chains);
+		REG_WRITE(ah, AR_PHY_PERCHAIN_CSD, tmp);
+	} else {
+		tmp = REG_READ(ah, AR_PHY_PERCHAIN_CSD);
+		tmp |= SM(2, AR_PHY_PERCHAIN_CSD_chn1_2chains);
+		tmp |= SM(2, AR_PHY_PERCHAIN_CSD_chn1_3chains);
+		tmp |= SM(4, AR_PHY_PERCHAIN_CSD_chn2_3chains);
+		REG_WRITE(ah, AR_PHY_PERCHAIN_CSD, tmp);
+	}
+
 	ads->ctl13 = set11nTries(series, 0)
 		|  set11nTries(series, 1)
 		|  set11nTries(series, 2)
@@ -401,7 +460,16 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 		|  set11nRateFlags(series, 2)
 		|  set11nRateFlags(series, 3)
 		| SM(rtsctsRate, AR_RTSCTSRate);
-	ads->ctl19 = AR_Not_Sounding;
+
+	if (flags & (ATH9K_TXDESC_TXBF_SOUND | ATH9K_TXDESC_TXBF_STAG_SOUND)) {
+		ar9003_set_11n_txbf_sounding(ah, ds, series,
+				MS(flags, ATH9K_TXDESC_CEC),
+				   (ATH9K_TXDESC_TXBF_SOUND |
+				    ATH9K_TXDESC_TXBF_STAG_SOUND));
+	} else {
+		/* set not sounding for normal frame */
+		ads->ctl19 = AR_Not_Sounding;
+	}
 
 	last_ads->ctl13 = ads->ctl13;
 	last_ads->ctl14 = ads->ctl14;
@@ -517,6 +585,7 @@ void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
 }
 EXPORT_SYMBOL(ath9k_hw_addrxbuf_edma);
 
+
 int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 				 void *buf_addr)
 {
@@ -566,6 +635,13 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_flags  = (rxsp->status4 & AR_GI) ? ATH9K_RX_GI : 0;
 	rxs->rs_flags  |= (rxsp->status4 & AR_2040) ? ATH9K_RX_2040 : 0;
 
+	rxs->rx_hw_upload_data = (rxsp->status2 & AR_HwUploadData) ? 1 : 0;
+	rxs->rx_not_sounding = (rxsp->status4 & AR_RxNotSounding) ? 1 : 0;
+	rxs->rx_Ness = MS(rxsp->status4, AR_RxNess);
+	rxs->rx_hw_upload_data_valid = (rxsp->status4 & AR_HwUploadDataValid)
+					? 1 : 0;
+	rxs->rx_hw_upload_data_type = MS(rxsp->status11, AR_HwUploadDataType);
+
 	rxs->evm0 = rxsp->status6;
 	rxs->evm1 = rxsp->status7;
 	rxs->evm2 = rxsp->status8;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index 45cc7e8..dd547aa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -36,6 +36,17 @@
 #define AR_LowRxChain	0x00004000
 
 #define AR_Not_Sounding	0x20000000
+#define AR_NESS                         0xc0000000
+#define AR_NESS_S                       30
+
+#define AR_NESS1                        0xc0000000
+#define AR_NESS1_S                      30
+
+#define AR_NESS2                        0xc0000000
+#define AR_NESS2_S                      30
+
+#define AR_NESS3                        0xc0000000
+#define AR_NESS3_S                      30
 
 /* ctl 12 */
 #define AR_PAPRDChainMask	0x00000e00
@@ -51,7 +62,18 @@
 #define MAP_ISR_S2_BB_WATCHDOG  6
 
 #define AR9003TXC_CONST(_ds) ((const struct ar9003_txc *) _ds)
+#define set11n_txbf_flags(_series, _index) \
+	((_series)[_index].RateFlags & ATH9K_RATESERIES_TXBF ? \
+	 AR_TxBf##_index : 0)
+
+#define not_two_stream_rate(_rate) (((_rate) > 0x8f) || ((_rate) < 0x88))
 
+#define set11n_txbf_LDPC(_series) \
+	(((not_two_stream_rate((_series)[0].Rate) && \
+	 (not_two_stream_rate((_series)[1].Rate) || (!(_series)[1].Tries)) \
+	 && (not_two_stream_rate((_series)[2].Rate) || (!(_series)[2].Tries)) \
+	&& (not_two_stream_rate((_series)[3].Rate) || (!(_series)[3].Tries)))) \
+	? AR_LDPC : 0)
 struct ar9003_rxs {
 	u32 ds_info;
 	u32 status1;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 3394dfe..a1fada3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -101,6 +101,8 @@
  */
 #define AR_PHY_TIMING2_USE_FORCE_PPM    0x00001000
 #define AR_PHY_TIMING2_FORCE_PPM_VAL    0x00000fff
+#define AR_PHY_TIMING2_HT_Fine_Timing_EN    0x80000000
+
 #define AR_PHY_TIMING3_DSC_MAN      0xFFFE0000
 #define AR_PHY_TIMING3_DSC_MAN_S    17
 #define AR_PHY_TIMING3_DSC_EXP      0x0001E000
@@ -188,6 +190,12 @@
 #define AR_PHY_RADAR_DC_PWR_THRESH_S    15
 #define AR_PHY_RADAR_LB_DC_CAP          0x7f800000
 #define AR_PHY_RADAR_LB_DC_CAP_S        23
+#define AR_PHY_PERCHAIN_CSD_chn1_2chains    0x0000001f
+#define AR_PHY_PERCHAIN_CSD_chn1_2chains_S  0
+#define AR_PHY_PERCHAIN_CSD_chn1_3chains    0x000003e0
+#define AR_PHY_PERCHAIN_CSD_chn1_3chains_S  5
+#define AR_PHY_PERCHAIN_CSD_chn2_3chains    0x00007c00
+#define AR_PHY_PERCHAIN_CSD_chn2_3chains_S  10
 #define AR_PHY_FIND_SIG_LOW_FIRSTEP_LOW (0x3f << 6)
 #define AR_PHY_FIND_SIG_LOW_FIRSTEP_LOW_S   6
 #define AR_PHY_FIND_SIG_LOW_FIRPWR      (0x7f << 12)
@@ -432,6 +440,9 @@
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A                       0x3FF
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A_S                     0
 
+#define AR_PHY_ENABLE_FLT_SVD                       0x00001000
+#define AR_PHY_ENABLE_FLT_SVD_S                     12
+
 #define AR_PHY_TEST              (AR_SM_BASE + 0x160)
 
 #define AR_PHY_TEST_BBB_OBS_SEL       0x780000
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_txbf.c b/drivers/net/wireless/ath/ath9k/ar9003_txbf.c
new file mode 100644
index 0000000..94a5133
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_txbf.c
@@ -0,0 +1,359 @@
+/*
+ * Copyright (c) 2008-2010, Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "hw.h"
+#include "ar9003_txbf.h"
+#include "ar9003_phy.h"
+#include "ar9003_mac.h"
+/* number of carrier mappings under different bandwidth and grouping, ex:
+ * bw = 1 (40M), Ng=0 (no group), number of carrier = 114*/
+static u8 const Ns[NUM_OF_BW][NUM_OF_Ng] = {
+	{56, 30, 16},
+	{114, 58, 30}
+};
+static u8 const Valid_bits[MAX_BITS_PER_SYMBOL] = {
+	0x1, 0x3, 0x7, 0xf, 0x1f, 0x3f, 0x7f, 0xff
+};
+static u8 Num_bits_on[NUM_OF_CHAINMASK] = {
+	0 /* 000 */ ,
+	1 /* 001 */ ,
+	1 /* 010 */ ,
+	2 /* 011 */ ,
+	1 /* 100 */ ,
+	2 /* 101 */ ,
+	2 /* 110 */ ,
+	3			/* 111 */
+};
+
+u8 ar9003_get_ntx(struct ath_hw *ah)
+{
+	return Num_bits_on[ah->txchainmask];
+}
+
+u8 ar9003_get_nrx(struct ath_hw *ah)
+{
+	return Num_bits_on[ah->rxchainmask];
+}
+
+void ar9003_set_hw_cv_timeout(struct ath_hw *ah, bool opt)
+{
+	/* if true use H/W settings to update cv timeout values */
+	if (opt)
+		ah->ah_txbf_hw_cvtimeout = ah->config.ath_hw_cvtimeout;
+
+	REG_WRITE(ah, AR_TXBF_TIMER,
+		  (ah->ah_txbf_hw_cvtimeout << AR_TXBF_TIMER_ATIMEOUT_S) |
+		  (ah->ah_txbf_hw_cvtimeout << AR_TXBF_TIMER_TIMEOUT_S));
+}
+
+void ar9003_init_txbf(struct ath_hw *ah)
+{
+	u32 tmp;
+	u8 txbf_ctl;
+
+	/* set default settings for TxBF */
+	REG_WRITE(ah, AR_TXBF,
+		  /* size of codebook entry set to psi 3bits, phi 6bits */
+		  (AR_TXBF_PSI_4_PHI_6 << AR_TXBF_CB_TX_S) |
+
+		  /* set Number of bit_to 8 bits */
+		  (AR_TXBF_NUMBEROFBIT_8 << AR_TXBF_NB_TX_S) |
+
+		  /* NG_RPT_TX set t0 No_GROUP */
+		  (AR_TXBF_No_GROUP << AR_TXBF_NG_RPT_TX_S) |
+
+		  /* TXBF_NG_CVCACHE set to 16 clients */
+		  (AR_TXBF_SIXTEEN_CLIENTS << AR_TXBF_NG_CVCACHE_S) |
+
+		  /* set weighting method to max power */
+		  (SM(AR_TXBF_MAX_POWER, AR_TXBF_TXCV_BFWEIGHT_METHOD)));
+	/* when ah_txbf_hw_cvtimeout = 0, use setting values */
+	if (ah->ah_txbf_hw_cvtimeout == 0)
+		ar9003_set_hw_cv_timeout(ah, true);
+	else
+		ar9003_set_hw_cv_timeout(ah, false);
+
+	/*
+	 * Set CEC to 2 stream for self_gen.
+	 * Set spacing to 8 us.
+	 * Initial selfgen Minimum MPDU.
+	 */
+	tmp = REG_READ(ah, AR_SELFGEN);
+	tmp |= SM(AR_SELFGEN_CEC_TWO_SPACETIMESTREAM, AR_CEC);
+	tmp |= SM(AR_SELFGEN_MMSS_EIGHT_us, AR_MMSS);
+	REG_WRITE(ah, AR_SELFGEN, tmp);
+
+	/*  set inital basic rate for all rate */
+	REG_WRITE(ah, AR_BASIC_SET, ALL_RATE);
+
+	/* enable HT fine timing */
+	tmp = REG_READ(ah, AR_PHY_TIMING2);
+	tmp |= AR_PHY_TIMING2_HT_Fine_Timing_EN;
+	REG_WRITE(ah, AR_PHY_TIMING2, tmp);
+
+	/* enable description decouple */
+	tmp = REG_READ(ah, AR_PCU_MISC_MODE2);
+	tmp |= AR_DECOUPLE_DECRYPTION;
+	REG_WRITE(ah, AR_PCU_MISC_MODE2, tmp);
+
+	/* enable restart */
+	tmp = REG_READ(ah, AR_PHY_RESTART);
+	tmp |= AR_PHY_RESTART_ENA;
+	REG_WRITE(ah, AR_PHY_RESTART, tmp);
+
+	/* enable flt SVD */
+	tmp = REG_READ(ah, AR_PHY_SEARCH_START_DELAY);
+
+	tmp |= AR_PHY_ENABLE_FLT_SVD;
+	REG_WRITE(ah, AR_PHY_SEARCH_START_DELAY, tmp);
+	txbf_ctl = ah->config.ath_hw_txbf_ctl;
+
+	tmp = REG_READ(ah, AR_H_XFER_TIMEOUT);
+	tmp |= AR_EXBF_IMMDIATE_RESP;
+	tmp &= ~(AR_EXBF_NOACK_NO_RPT);
+
+	/* enable immediate report */
+	REG_WRITE(ah, AR_H_XFER_TIMEOUT, tmp);
+}
+
+int ar9003_get_ness(struct ath_hw *ah, u8 code_rate, u8 cec)
+{
+	u8 ndltf = 0, ness = 0, ntx;
+
+	ntx = ar9003_get_ntx(ah);
+
+	/* cec+1 remote cap's for channel estimation in stream. */
+	/* limit by remote's cap */
+	if (ntx > (cec + 2))
+		ntx = cec + 2;
+
+	if (code_rate < MIN_TWO_STREAM_RATE)
+		ndltf = 1;
+	else if (code_rate < MIN_THREE_STREAM_RATE)
+		ndltf = 2;
+	else
+		ndltf = 4;
+
+	/* NESS is used for setting neltf and NTX =<NDLTF + NELTF, NDLTF
+	 * is 2^(stream-1), if NTX < NDLTF, NESS=0, other NESS = NTX-NDLTF */
+	if (code_rate >= MIN_HT_RATE) {	/* HT rate */
+		if (ntx > ndltf)
+			ness = ntx - ndltf;
+	}
+
+	return ness;
+}
+
+/*
+ * function: ar9003_set_11n_txbf_sounding
+ * purpose:  Set sounding frame
+ * inputs:
+ *           series: rate series of sounding frame
+ *           cec: Channel Estimation Capability . Extract from subfields
+ *               of the Transmit Beamforming Capabilities field of remote.
+ *           opt: control flag of current frame
+ */
+void
+ar9003_set_11n_txbf_sounding(struct ath_hw *ah,
+			     void *ds,
+			     struct ath9k_11n_rate_series series[],
+			     u8 cec, u16 opt)
+{
+	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
+	u8 ness = 0, ness1 = 0, ness2 = 0, ness3 = 0;
+
+	ads->ctl19 &= (~AR_Not_Sounding);	/*set sounding frame */
+	if (opt & ATH9K_TXDESC_TXBF_STAG_SOUND) {
+		ness = ar9003_get_ness(ah, series[0].Rate, cec);
+		ness1 = ar9003_get_ness(ah, series[1].Rate, cec);
+		ness2 = ar9003_get_ness(ah, series[2].Rate, cec);
+		ness3 = ar9003_get_ness(ah, series[3].Rate, cec);
+	}
+
+	ads->ctl19 |= SM(ness, AR_NESS);
+	ads->ctl20 |= SM(ness1, AR_NESS1);
+	ads->ctl21 |= SM(ness2, AR_NESS2);
+	ads->ctl22 |= SM(ness3, AR_NESS3);
+
+	/* disable other series that don't support sounding at legacy rate */
+	if (series[1].Rate < MIN_HT_RATE) {
+		ads->ctl13 &=
+		    ~(AR_XmitDataTries1 | AR_XmitDataTries2 |
+		      AR_XmitDataTries3);
+	} else if (series[2].Rate < MIN_HT_RATE)
+		ads->ctl13 &= ~(AR_XmitDataTries2 | AR_XmitDataTries3);
+	else if (series[3].Rate < MIN_HT_RATE)
+		ads->ctl13 &= ~(AR_XmitDataTries3);
+}
+
+/* search CV cache address according to key index */
+static u16 ar9003_txbf_lru_search(struct ath_hw *ah, u8 key_idx)
+{
+	u32 tmp = 0;
+	u16 cv_cache_idx = 0;
+
+	/* make sure LRU search is initially disabled */
+	REG_WRITE(ah, AR_TXBF_SW, 0);
+	tmp = (SM(key_idx, AR_DEST_IDX) | AR_LRU_EN);
+
+	/* enable LRU search */
+	REG_WRITE(ah, AR_TXBF_SW, tmp);
+
+	/* wait for LRU search to finish */
+	do {
+		tmp = REG_READ(ah, AR_TXBF_SW);
+	} while ((tmp & AR_LRU_ACK) != 1);
+	cv_cache_idx = MS(tmp, AR_LRU_ADDR);
+
+	/* disable LRU search */
+	REG_WRITE(ah, AR_TXBF_SW, 0);
+	return cv_cache_idx;
+}
+
+void ar9003_fill_txbf_capabilities(struct ath_hw *ah)
+{
+	struct ieee80211_txbf_caps *txbf = &ah->txbf_caps;
+	u32 val;
+	u8 txbf_ctl;
+
+	memset(txbf, 0, sizeof(struct ieee80211_txbf_caps));
+
+	/* CEC for osprey is always 1 (2 stream) */
+	txbf->channel_estimation_cap = 1;
+
+	/* For calibration, always 2 (3 stream) for osprey */
+	txbf->csi_max_rows_bfer = 2;
+
+	/*
+	 * Compressed Steering Number of Beamformer Antennas Supported is
+	 * limited by local's antenna
+	 */
+	txbf->comp_bfer_antennas = ar9003_get_ntx(ah) - 1;
+
+	/*
+	 * Compressed Steering Number of Beamformer Antennas Supported
+	 * is limited by local's antenna
+	 */
+	txbf->noncomp_bfer_antennas = ar9003_get_ntx(ah) - 1;
+
+	/* NOT SUPPORT CSI */
+	txbf->csi_bfer_antennas = 0;
+
+	/* 1, 2, 4 group is supported */
+	txbf->minimal_grouping = ALL_GROUP;
+
+	/* Explicit compressed Beamforming Feedback Capable */
+	txbf->explicit_comp_bf |= Delay_Rpt;
+
+	/*TxBFCtl_Comp_ExBF_Immediately_Rpt)*/
+	txbf->explicit_comp_bf |= Immediately_Rpt;
+
+	/* Explicit non-Compressed Beamforming Feedback Capable */
+	txbf->explicit_noncomp_bf |= Delay_Rpt;
+
+	txbf->explicit_noncomp_bf |= Immediately_Rpt;
+
+	/* not support csi feekback */
+	txbf->explicit_csi_feedback = 0;
+
+	/* Explicit compressed Steering Capable from settings */
+	txbf->explicit_comp_steering = 1;
+
+	/* Explicit Non-compressed Steering Capable from settings */
+	txbf->explicit_noncomp_steering = 1;
+
+	/* not support CSI */
+	txbf->explicit_csi_txbf_capable = false;
+
+	/* not support imbf and calibration */
+	txbf->calibration = No_CALIBRATION;
+	txbf->implicit_txbf_capable = false;
+	txbf->implicit_rx_capable = false;
+
+	/* not support NDP */
+	txbf->tx_ndp_capable = false;
+	txbf->rx_ndp_capable = false;
+
+	/* support stagger sounding. */
+	txbf->tx_staggered_sounding = true;
+	txbf->rx_staggered_sounding = true;
+
+	/* set immediately or delay report to H/W */
+	val = REG_READ(ah, AR_H_XFER_TIMEOUT);
+	txbf_ctl = ah->config.ath_hw_txbf_ctl;
+
+	val |= AR_EXBF_IMMDIATE_RESP;
+	val &= ~(AR_EXBF_NOACK_NO_RPT);
+	/* enable immediately report */
+	REG_WRITE(ah, AR_H_XFER_TIMEOUT, val);
+}
+EXPORT_SYMBOL(ar9003_fill_txbf_capabilities);
+
+struct ieee80211_txbf_caps ar9003_get_txbf_capabilities(struct ath_hw *ah)
+{
+	return ah->txbf_caps;
+}
+EXPORT_SYMBOL(ar9003_get_txbf_capabilities);
+
+/*
+ * ar9003_txbf_set_key is used to set TXBF related field in key cache.
+ */
+void ar9003_txbf_set_key(struct ath_hw *ah,
+			 u16 entry,
+			 u8 rx_staggered_sounding,
+			 u8 channel_estimation_cap, u8 mmss)
+{
+	u32 tmp, txbf;
+
+	/* 1 for 2 stream, 0 for 1 stream, should add 1 for H/W */
+	channel_estimation_cap += 1;
+	txbf = (SM(rx_staggered_sounding, AR_KEYTABLE_STAGGED) |
+		SM(channel_estimation_cap, AR_KEYTABLE_CEC) |
+		SM(mmss, AR_KEYTABLE_MMSS));
+	tmp = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
+	if (txbf !=
+	    (tmp & (AR_KEYTABLE_STAGGED | AR_KEYTABLE_CEC | AR_KEYTABLE_MMSS)))
+		/* update key cache for txbf */
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), tmp | txbf);
+}
+
+u32 ar9003_read_cv_cache(struct ath_hw *ah, u32 addr)
+{
+	u32 tmp, value;
+
+	REG_WRITE(ah, addr, AR_CVCACHE_RD_EN);
+
+	do {
+		tmp = REG_READ(ah, AR_TXBF_SW);
+	} while ((tmp & AR_LRU_RD_ACK) == 0);
+	value = REG_READ(ah, addr);
+	tmp &= ~(AR_LRU_RD_ACK);
+	REG_WRITE(ah, AR_TXBF_SW, tmp);
+	return value & AR_CVCACHE_DATA;
+}
+
+void ar9003_txbf_get_cv_cache_nr(struct ath_hw *ah, u16 key_idx, u8 * nr)
+{
+	u32 idx, value;
+	u8 nr_idx;
+
+	/* get current CV cache addess offset from key index */
+	idx = ar9003_txbf_lru_search(ah, key_idx);
+
+	/* read the cvcache header */
+	value = ar9003_read_cv_cache(ah, AR_CVCACHE(idx));
+	nr_idx = MS(value, AR_CVCACHE_Nr_IDX);
+	*nr = nr_idx + 1;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_txbf.h b/drivers/net/wireless/ath/ath9k/ar9003_txbf.h
new file mode 100644
index 0000000..1b6f5f8
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_txbf.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2008-2010, Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _ATH_AR9000_TxBF_CAL_H_
+#define _ATH_AR9300_TxBF_CAL_H_
+
+#define debugKa     0
+#define debugRC     0
+#define debugWinRC  0
+
+#define NUM_OF_BW   2   /* two bandwidth used for mapping:20M,40M */
+#define NUM_OF_Ng   3   /* three group define used for mapping :Ng=0,Ng=1,Ng=2*/
+
+#define MAX_BITS_PER_SYMBOL 8
+
+#define NUM_OF_CHAINMASK (1 << AR9300_MAX_CHAINS)
+
+#define BITS_PER_BYTE       8
+#define BITS_PER_COMPLEX_SYMBOL (2 * BITS_PER_SYMBOL)
+#define BITS_PER_SYMBOL      10
+
+#define MAX_STREAMS 3
+#define MAX_PILOTS  6
+#define EVM_MIN     -128
+
+#define Tone_40M	114
+#define Tone_20M	56
+#define NUM_ITER	8
+
+#define Nb_phin		(10-1)
+#define Nb_coridc	(12-1)
+#define Nb_sin		(8-1)
+#define	Nb_ph		5
+#define	Nb_psi		4
+#define	NUM_ITER_V	6
+
+#define Nb_MHINV	13
+#define EVM_TH		10
+#define rc_max		6000
+#define rc_min		100
+
+#define BW_40M      1
+#define BW_20M_low  2
+#define BW_20M_up   3
+
+
+/* MIMO control field related bit definiton */
+
+#define AR_Nc_idx       0x0003  /* Nc Index*/
+#define AR_Nc_idx_S     0
+#define AR_Nr_idx       0x000c  /* Nr Index*/
+#define AR_Nr_idx_S     2
+#define AR_bandwith     0x0010  /* MIMO Control Channel Width*/
+#define AR_bandwith_S   4
+#define AR_Ng           0x0060  /* Grouping*/
+#define AR_Ng_S         5
+#define AR_Nb           0x0180  /* Coeffiecient Size*/
+#define AR_Nb_S         7
+#define AR_CI           0x0600  /* Codebook Information*/
+#define AR_CI_S         9
+#define CAL_GAIN        0
+#define Smooth          1
+
+/* constant for TXBF IE */
+#define ALL_GROUP       3
+#define No_CALIBRATION  0
+#define INIT_RESP_CAL   3
+
+/* constant for rate code */
+#define MIN_THREE_STREAM_RATE   0x90
+#define MIN_TWO_STREAM_RATE     0x88
+#define MIN_HT_RATE             0x80
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5fb1bf3..9597cc3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1425,6 +1425,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ar9003_init_txbf(ah);
+
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_hw_restore_chainmask(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8bebc3e..670a5ca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -238,6 +238,29 @@ struct ath9k_ops_config {
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
 	u16 ani_poll_interval; /* ANI poll interval in ms */
+	u8    ath_hw_cvtimeout;
+	u8    ath_hw_txbf_ctl;
+#define TxBFCtl_ImBF                        0x01
+#define TxBFCtl_ImBF_S                      0
+#define TxBFCtl_Non_ExBF                    0x02
+#define TxBFCtl_Non_ExBF_S                  1
+#define TxBFCtl_Comp_ExBF                   0x04
+#define TxBFCtl_Comp_ExBF_S                 2
+#define TxBFCtl_ImBF_FB                     0x08
+#define TxBFCtl_ImBF_FB_S                   3
+#define TxBFCtl_Non_ExBF_Immediately_Rpt    0x10
+#define TxBFCtl_Non_ExBF_Immediately_Rpt_S  4
+#define TxBFCtl_Comp_ExBF_Immediately_Rpt   0x20
+#define TxBFCtl_Comp_ExBF_Immediately_Rpt_S 5
+
+#define TxBFCtl_Non_ExBF_delay_Rpt          0x40
+#define TxBFCtl_Non_ExBF_delay_Rpt_S        6
+#define TxBFCtl_Comp_ExBF_delay_Rpt         0x80
+#define TxBFCtl_Comp_ExBF_delay_Rpt_S       7
+
+#define Delay_Rpt                   1
+#define Immediately_Rpt             2
+
 };
 
 enum ath9k_int {
@@ -603,6 +626,28 @@ struct ath_nf_limits {
 	s16 nominal;
 };
 
+struct hal_txbf_caps {
+	u8 channel_estimation_cap;
+	u8 csi_max_rows_bfer;
+	u8 comp_bfer_antennas;
+	u8 noncomp_bfer_antennas;
+	u8 csi_bfer_antennas;
+	u8 minimal_grouping;
+	u8 explicit_comp_bf;
+	u8 explicit_noncomp_bf;
+	u8 explicit_csi_feedback;
+	u8 explicit_comp_steering;
+	u8 explicit_noncomp_steering;
+	u8 explicit_csi_txbf_capable;
+	u8 calibration;
+	u8 implicit_txbf_capable;
+	u8 tx_ndp_capable;
+	u8 rx_ndp_capable;
+	u8 tx_staggered_sounding;
+	u8 rx_staggered_sounding;
+	u8 implicit_rx_capable;
+};
+
 struct ath_hw {
 	struct ieee80211_hw *hw;
 	struct ath_common common;
@@ -736,10 +781,12 @@ struct ath_hw {
 	/* Bluetooth coexistance */
 	struct ath_btcoex_hw btcoex_hw;
 
+	struct ieee80211_txbf_caps txbf_caps;
 	u32 intr_txqs;
 	u8 txchainmask;
 	u8 rxchainmask;
 
+	bool ah_txbf_hw_cvtimeout;
 	u32 originalGain[22];
 	int initPDADC;
 	int PDADCdelta;
@@ -955,6 +1002,15 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
+extern void ar9003_init_txbf(struct ath_hw *ah);
+extern void ar9003_set_11n_txbf_sounding(struct ath_hw *ah,
+		void *ds, struct ath9k_11n_rate_series series[],
+		u8 cec, u16 opt);
+extern void ar9003_fill_txbf_capabilities(struct ath_hw *ah);
+extern struct ieee80211_txbf_caps
+		ar9003_get_txbf_capabilities(struct ath_hw *ah);
+extern bool ar9300_read_key_cache_mac(struct ath_hw *ah, u16 entry,
+		u8 *mac);
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 22907e2..7110506 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -89,7 +89,7 @@
 #define ATH9K_TX_DATA_UNDERRUN     0x08
 #define ATH9K_TX_DELIM_UNDERRUN    0x10
 #define ATH9K_TX_SW_FILTERED       0x80
-
+#define ATH9K_TX_BF_ERR		   0xa0
 /* 64 bytes */
 #define MIN_TX_FIFO_THRESHOLD   0x1
 
@@ -124,6 +124,12 @@ struct ath_tx_status {
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
+	u8  ts_txbfstatus;  /* Tx bf status */
+#define AR_BW_Mismatch      0x1
+#define AR_Stream_Miss      0x2
+#define AR_CV_Missed        0x4
+#define AR_Dest_Miss        0x8
+#define AR_Expired          0x10
 };
 
 struct ath_rx_status {
@@ -151,6 +157,11 @@ struct ath_rx_status {
 	u32 evm2;
 	u32 evm3;
 	u32 evm4;
+	u8 rx_hw_upload_data:1,
+	   rx_not_sounding:1,
+	   rx_Ness:2,
+	   rx_hw_upload_data_valid:1,
+	   rx_hw_upload_data_type:2;
 };
 
 struct ath_htc_rx_status {
@@ -263,6 +274,15 @@ struct ath_desc {
 #define ATH9K_TXDESC_VMF		0x0100
 #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
 #define ATH9K_TXDESC_LOWRXCHAIN		0x0400
+#define ATH9K_TXDESC_TXBF         0x0800  /*for txbf*/
+#define ATH9K_TXDESC_TXBF_SOUND   0x1000  /* for sounding settings*/
+#define ATH9K_TXDESC_TXBF_SOUND_S 11
+#define ATH9K_TXDESC_SOUND        0x1     /* enable sounding */
+#define ATH9K_TXDESC_TXBF_STAG_SOUND   0x2000     /* enable sounding */
+#define ATH9K_TXDESC_TRQ          0x3     /* request sounding */
+#define ATH9K_TXDESC_CAL          0x2000  /* calibration frame */
+#define ATH9K_TXDESC_CEC          0xC000  /* channel calibration capability*/
+#define ATH9K_TXDESC_CEC_S        14
 #define ATH9K_TXDESC_LDPC		0x00010000
 
 #define ATH9K_RXDESC_INTREQ		0x0020
@@ -352,7 +372,12 @@ struct ar5416_desc {
 #define AR_RTSEnable        0x00400000
 #define AR_VEOL             0x00800000
 #define AR_ClrDestMask      0x01000000
-#define AR_TxCtlRsvd01      0x1e000000
+#define AR_TxBf0            0x02000000
+#define AR_TxBf1            0x04000000
+#define AR_TxBf2            0x08000000
+#define AR_TxBf3            0x10000000
+
+#define AR_TxBfSteered      0x1e000000
 #define AR_TxIntrReq        0x20000000
 #define AR_DestIdxValid     0x40000000
 #define AR_CTSEnable        0x80000000
@@ -495,8 +520,14 @@ struct ar5416_desc {
 #define AR_TxStatusRsvd80   0x0001e000
 #define AR_TxOpExceeded     0x00020000
 #define AR_TxStatusRsvd81   0x001c0000
+#define AR_TXBFStatus	    0x001c0000
+#define AR_TXBFStatus_S	    18
+#define AR_TxBF_BW_Mismatch 0x00040000
+#define AR_TxBF_Stream_Miss 0x00080000
 #define AR_FinalTxIdx       0x00600000
 #define AR_FinalTxIdx_S     21
+#define AR_TxBF_Dest_Miss   0x00800000
+#define AR_TxBF_Expired     0x01000000
 #define AR_TxStatusRsvd82   0x01800000
 #define AR_PowerMgmt        0x02000000
 #define AR_TxStatusRsvd83   0xfc000000
@@ -521,6 +552,8 @@ struct ar5416_desc {
 #define AR_RxMore           0x00001000
 #define AR_NumDelim         0x003fc000
 #define AR_NumDelim_S       14
+#define AR_HwUploadData     0x00400000
+#define AR_HwUploadData_S   22
 #define AR_RxStatusRsvd10   0xff800000
 
 #define AR_RcvTimestamp     ds_rxstatus2
@@ -529,6 +562,12 @@ struct ar5416_desc {
 #define AR_2040             0x00000002
 #define AR_Parallel40       0x00000004
 #define AR_Parallel40_S     2
+#define AR_RxStbc           0x00000008
+#define AR_RxNotSounding    0x00000010
+#define AR_RxNess           0x00000060
+#define AR_RxNess_S         5
+#define AR_HwUploadDataValid    0x00000080
+#define AR_HwUploadDataValid_S  7
 #define AR_RxStatusRsvd30   0x000000f8
 #define AR_RxAntenna	    0xffffff00
 #define AR_RxAntenna_S	    8
@@ -563,6 +602,10 @@ struct ar5416_desc {
 #define AR_RxAggr           0x00020000
 #define AR_PostDelimCRCErr  0x00040000
 #define AR_RxStatusRsvd71   0x3ff80000
+#define AR_HwUploadDataType 0x06000000
+#define AR_HwUploadDataType_S   25
+#define AR_HiRxChain        0x10000000
+#define AR_RxFirstAggr      0x20000000
 #define AR_DecryptBusyErr   0x40000000
 #define AR_KeyMiss          0x80000000
 
@@ -648,6 +691,7 @@ enum ath9k_rx_filter {
 #define ATH9K_RATESERIES_2040     0x0002
 #define ATH9K_RATESERIES_HALFGI   0x0004
 #define ATH9K_RATESERIES_STBC     0x0008
+#define ATH9K_RATESERIES_TXBF     0x0010  /* use TxBF for series */
 
 struct ath9k_11n_rate_series {
 	u32 Tries;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index fa05b71..3d9914e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1499,6 +1499,9 @@ enum {
 #define AR_FCS_FAIL         0x8094
 #define AR_BEACON_CNT       0x8098
 
+#define AR_BASIC_SET        0x80a0
+#define ALL_RATE            0xff
+
 #define AR_SLEEP1               0x80d4
 #define AR_SLEEP1_ASSUME_DTIM   0x00080000
 #define AR_SLEEP1_CAB_TIMEOUT   0xFFE00000
@@ -1508,6 +1511,24 @@ enum {
 #define AR_SLEEP2_BEACON_TIMEOUT    0xFFE00000
 #define AR_SLEEP2_BEACON_TIMEOUT_S  21
 
+/*MAC_PCU_SELF_GEN_DEFAULT*/
+#define AR_SELFGEN              0x80dc
+#define AR_MMSS                 0x00000007
+#define AR_MMSS_S               0
+#define AR_SELFGEN_MMSS_NO RESTRICTION  0
+#define AR_SELFGEN_MMSS_ONEOVER4_us     1
+#define AR_SELFGEN_MMSS_ONEOVER2_us     2
+#define AR_SELFGEN_MMSS_ONE_us          3
+#define AR_SELFGEN_MMSS_TWO_us          4
+#define AR_SELFGEN_MMSS_FOUR_us         5
+#define AR_SELFGEN_MMSS_EIGHT_us        6
+#define AR_SELFGEN_MMSS_SIXTEEN_us      7
+
+#define AR_CEC                  0x00000018
+#define AR_CEC_S                3
+#define AR_SELFGEN_CEC_ONE_SPACETIMESTREAM      1
+#define AR_SELFGEN_CEC_TWO_SPACETIMESTREAM      2
+
 #define AR_TPC                 0x80e8
 #define AR_TPC_ACK             0x0000003f
 #define AR_TPC_ACK_S           0x00
@@ -1716,6 +1737,9 @@ enum {
 #define AR_2040_MODE                0x8318
 #define AR_2040_JOINED_RX_CLEAR 0x00000001
 
+#define AR_H_XFER_TIMEOUT               0x831c
+#define AR_EXBF_IMMDIATE_RESP           0x00000040
+#define AR_EXBF_NOACK_NO_RPT            0x00000100
 
 #define AR_EXTRCCNT         0x8328
 
@@ -1739,6 +1763,7 @@ enum {
 #define AR_PCU_MISC_MODE2_ENABLE_AGGWEP                0x00020000
 #define AR_PCU_MISC_MODE2_HWWAR1                       0x00100000
 #define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
+#define AR_DECOUPLE_DECRYPTION                         0x08000000
 #define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
 
 #define AR_MAC_PCU_ASYNC_FIFO_REG3                     0x8358
@@ -1776,6 +1801,14 @@ enum {
 #define AR_KEYTABLE_TYPE_CCM    0x00000006
 #define AR_KEYTABLE_TYPE_CLR    0x00000007
 #define AR_KEYTABLE_ANT         0x00000008
+
+#define AR_KEYTABLE_MMSS        0x00001c00  /* remote's MMSS*/
+#define AR_KEYTABLE_MMSS_S      10
+#define AR_KEYTABLE_CEC         0x00006000  /* remote's CEC*/
+#define AR_KEYTABLE_CEC_S       13
+#define AR_KEYTABLE_STAGGED     0x00010000  /* remote's stagged sounding*/
+#define AR_KEYTABLE_STAGGED_S   16
+
 #define AR_KEYTABLE_VALID       0x00008000
 #define AR_KEYTABLE_KEY0(_n)    (AR_KEYTABLE(_n) + 0)
 #define AR_KEYTABLE_KEY1(_n)    (AR_KEYTABLE(_n) + 4)
@@ -1816,5 +1849,89 @@ enum {
 #define AR_PHY_AGC_CONTROL_CLC_SUCCESS		0x00080000  /* carrier leak calibration done */
 #define AR_PHY_AGC_CONTROL_YCOK_MAX		0x000003c0
 #define AR_PHY_AGC_CONTROL_YCOK_MAX_S		6
-
+#define AR_TXBF_DBG             0x10000
+
+#define AR_TXBF          0x10004
+#define AR_TXBF_CB_TX       0x00000003
+#define AR_TXBF_CB_TX_S     0
+#define AR_TXBF_PSI_1_PHI_3         0
+#define AR_TXBF_PSI_2_PHI_4         1
+#define AR_TXBF_PSI_3_PHI_5         2
+#define AR_TXBF_PSI_4_PHI_6         3
+
+#define AR_TXBF_NB_TX       0x0000000C
+#define AR_TXBF_NB_TX_S     2
+#define AR_TXBF_NUMBEROFBIT_4       0
+#define AR_TXBF_NUMBEROFBIT_2       1
+#define AR_TXBF_NUMBEROFBIT_6       2
+#define AR_TXBF_NUMBEROFBIT_8       3
+
+#define AR_TXBF_NG_RPT_TX   0x00000030
+#define AR_TXBF_NG_RPT_TX_S 4
+#define AR_TXBF_No_GROUP            0
+#define AR_TXBF_TWO_GROUP           1
+#define AR_TXBF_FOUR_GROUP          2
+
+#define AR_TXBF_NG_CVCACHE  0x000000C0
+#define AR_TXBF_NG_CVCACHE_S  6
+#define AR_TXBF_FOUR_CLIENTS        0
+#define AR_TXBF_EIGHT_CLIENTS       1
+#define AR_TXBF_SIXTEEN_CLIENTS     2
+
+#define AR_TXBF_TXCV_BFWEIGHT_METHOD 0x00000600
+#define AR_TXBF_TXCV_BFWEIGHT_METHOD_S 9
+#define AR_TXBF_NO_WEIGHTING        0
+#define AR_TXBF_MAX_POWER           1
+#define AR_TXBF_KEEP_RATIO          2
+
+#define AR_TXBF_RLR_EN        0x00000800
+#define AR_TXBF_RC_20_U_DONE  0x00001000
+#define AR_TXBF_RC_20_L_DONE  0x00002000
+#define AR_TXBF_RC_40_DONE        0x00004000
+#define AR_TXBF_FORCE_UPDATE_V2BB       0x00008000
+
+#define AR_TXBF_TIMER            0x10008
+#define AR_TXBF_TIMER_TIMEOUT     0x000000FF
+#define AR_TXBF_TIMER_TIMEOUT_S   0
+#define AR_TXBF_TIMER_ATIMEOUT    0x0000FF00
+#define AR_TXBF_TIMER_ATIMEOUT_S  8
+
+/* for SVD cache update */
+#define AR_TXBF_SW                     0x1000c
+#define AR_LRU_ACK                      0x00000001
+#define AR_LRU_ADDR                     0x000003FE
+#define AR_LRU_ADDR_S           1
+#define AR_LRU_EN                       0x00000400
+#define AR_LRU_EN_S                     11
+#define AR_DEST_IDX                     0x0007f000
+#define AR_DEST_IDX_S           12
+#define AR_LRU_WR_ACK			0x00080000
+#define AR_LRU_WR_ACK_S			19
+#define AR_LRU_RD_ACK			0x00100000
+#define AR_LRU_RD_ACK_S			20
+
+#define AR_RC0_0                       0x11000
+#define AR_RC0(_idx)            (AR_RC0_0+(_idx))
+#define AR_RC1_0                       0x11200
+#define AR_RC1(_idx)            (AR_RC1_0+(_idx))
+
+#define AR_CVCACHE_0            0x12400
+#define AR_CVCACHE(_idx)        (AR_CVCACHE_0+(_idx))
+#define AR_CVCACHE_Ng_IDX       0x0000C000
+#define AR_CVCACHE_Ng_IDX_S     14
+#define AR_CVCACHE_BW40         0x00010000
+#define AR_CVCACHE_BW40_S       16
+#define AR_CVCACHE_IMPLICIT     0x00020000
+#define AR_CVCACHE_IMPLICIT_S   17
+#define AR_CVCACHE_DEST_IDX     0x01FC0000
+#define AR_CVCACHE_DEST_IDX_S   18
+#define AR_CVCACHE_Nc_IDX       0x06000000
+#define AR_CVCACHE_Nc_IDX_S     25
+#define AR_CVCACHE_Nr_IDX       0x18000000
+#define AR_CVCACHE_Nr_IDX_S     27
+#define AR_CVCACHE_EXPIRED      0x20000000
+#define AR_CVCACHE_EXPIRED_S    29
+#define AR_CVCACHE_WRITE        0x80000000
+#define AR_CVCACHE_RD_EN	0x40000000
+#define AR_CVCACHE_DATA		0x3fffffff
 #endif
-- 
1.6.3.3

