Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25765 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYHBXti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 12/12] ath9k: Use u8/u16/u32
Date: Sat, 2 Aug 2008 16:49:04 -0700
Message-ID: <1217720944-23234-13-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014958_167450_3B365FC6)
In-Reply-To: <1217720944-23234-12-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-8-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-9-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-10-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-11-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And u_int --> u32

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h    |  534 ++++++++++++------------
 drivers/net/wireless/ath9k/beacon.c   |   36 +-
 drivers/net/wireless/ath9k/core.c     |   84 ++--
 drivers/net/wireless/ath9k/core.h     |  250 ++++++------
 drivers/net/wireless/ath9k/hw.c       |  756 ++++++++++++++++----------------
 drivers/net/wireless/ath9k/hw.h       |  386 +++++++++---------
 drivers/net/wireless/ath9k/initvals.h |   82 ++--
 drivers/net/wireless/ath9k/main.c     |   24 +-
 drivers/net/wireless/ath9k/phy.c      |   60 ++--
 drivers/net/wireless/ath9k/phy.h      |    6 +-
 drivers/net/wireless/ath9k/rc.c       |  126 +++---
 drivers/net/wireless/ath9k/rc.h       |   96 ++--
 drivers/net/wireless/ath9k/recv.c     |   28 +-
 drivers/net/wireless/ath9k/regd.c     |  100 +++---
 drivers/net/wireless/ath9k/regd.h     |  130 +++---
 drivers/net/wireless/ath9k/xmit.c     |   64 ++--
 16 files changed, 1381 insertions(+), 1381 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index b7712d7..a4387f9 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -52,54 +52,54 @@
 #endif
 
 struct ath_tx_status {
-	u_int32_t ts_tstamp;
-	u_int16_t ts_seqnum;
-	u_int8_t ts_status;
-	u_int8_t ts_ratecode;
-	u_int8_t ts_rateindex;
+	u32 ts_tstamp;
+	u16 ts_seqnum;
+	u8 ts_status;
+	u8 ts_ratecode;
+	u8 ts_rateindex;
 	int8_t ts_rssi;
-	u_int8_t ts_shortretry;
-	u_int8_t ts_longretry;
-	u_int8_t ts_virtcol;
-	u_int8_t ts_antenna;
-	u_int8_t ts_flags;
+	u8 ts_shortretry;
+	u8 ts_longretry;
+	u8 ts_virtcol;
+	u8 ts_antenna;
+	u8 ts_flags;
 	int8_t ts_rssi_ctl0;
 	int8_t ts_rssi_ctl1;
 	int8_t ts_rssi_ctl2;
 	int8_t ts_rssi_ext0;
 	int8_t ts_rssi_ext1;
 	int8_t ts_rssi_ext2;
-	u_int8_t pad[3];
-	u_int32_t ba_low;
-	u_int32_t ba_high;
-	u_int32_t evm0;
-	u_int32_t evm1;
-	u_int32_t evm2;
+	u8 pad[3];
+	u32 ba_low;
+	u32 ba_high;
+	u32 evm0;
+	u32 evm1;
+	u32 evm2;
 };
 
 struct ath_rx_status {
-	u_int32_t rs_tstamp;
-	u_int16_t rs_datalen;
-	u_int8_t rs_status;
-	u_int8_t rs_phyerr;
+	u32 rs_tstamp;
+	u16 rs_datalen;
+	u8 rs_status;
+	u8 rs_phyerr;
 	int8_t rs_rssi;
-	u_int8_t rs_keyix;
-	u_int8_t rs_rate;
-	u_int8_t rs_antenna;
-	u_int8_t rs_more;
+	u8 rs_keyix;
+	u8 rs_rate;
+	u8 rs_antenna;
+	u8 rs_more;
 	int8_t rs_rssi_ctl0;
 	int8_t rs_rssi_ctl1;
 	int8_t rs_rssi_ctl2;
 	int8_t rs_rssi_ext0;
 	int8_t rs_rssi_ext1;
 	int8_t rs_rssi_ext2;
-	u_int8_t rs_isaggr;
-	u_int8_t rs_moreaggr;
-	u_int8_t rs_num_delims;
-	u_int8_t rs_flags;
-	u_int32_t evm0;
-	u_int32_t evm1;
-	u_int32_t evm2;
+	u8 rs_isaggr;
+	u8 rs_moreaggr;
+	u8 rs_num_delims;
+	u8 rs_flags;
+	u32 evm0;
+	u32 evm1;
+	u32 evm2;
 };
 
 #define ATH9K_RXERR_CRC           0x01
@@ -116,15 +116,15 @@ struct ath_rx_status {
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
 
-#define ATH9K_RXKEYIX_INVALID	((u_int8_t)-1)
-#define ATH9K_TXKEYIX_INVALID	((u_int)-1)
+#define ATH9K_RXKEYIX_INVALID	((u8)-1)
+#define ATH9K_TXKEYIX_INVALID	((u32)-1)
 
 struct ath_desc {
-	u_int32_t ds_link;
-	u_int32_t ds_data;
-	u_int32_t ds_ctl0;
-	u_int32_t ds_ctl1;
-	u_int32_t ds_hw[20];
+	u32 ds_link;
+	u32 ds_data;
+	u32 ds_ctl0;
+	u32 ds_ctl1;
+	u32 ds_hw[20];
 	union {
 		struct ath_tx_status tx;
 		struct ath_rx_status rx;
@@ -168,7 +168,7 @@ enum hal_capability_type {
 };
 
 struct hal_capabilities {
-	u_int halChanSpreadSupport:1,
+	u32 halChanSpreadSupport:1,
 		halChapTuningSupport:1,
 		halMicAesCcmSupport:1,
 		halMicCkipSupport:1,
@@ -192,20 +192,20 @@ struct hal_capabilities {
 		halAutoSleepSupport:1,
 		hal4kbSplitTransSupport:1,
 		halWowMatchPatternExact:1;
-	u_int32_t halWirelessModes;
-	u_int16_t halTotalQueues;
-	u_int16_t halKeyCacheSize;
-	u_int16_t halLow5GhzChan, halHigh5GhzChan;
-	u_int16_t halLow2GhzChan, halHigh2GhzChan;
-	u_int16_t halNumMRRetries;
-	u_int16_t halRtsAggrLimit;
-	u_int8_t halTxChainMask;
-	u_int8_t halRxChainMask;
-	u_int16_t halTxTrigLevelMax;
-	u_int16_t halRegCap;
-	u_int8_t halNumGpioPins;
-	u_int8_t halNumAntCfg2GHz;
-	u_int8_t halNumAntCfg5GHz;
+	u32 halWirelessModes;
+	u16 halTotalQueues;
+	u16 halKeyCacheSize;
+	u16 halLow5GhzChan, halHigh5GhzChan;
+	u16 halLow2GhzChan, halHigh2GhzChan;
+	u16 halNumMRRetries;
+	u16 halRtsAggrLimit;
+	u8 halTxChainMask;
+	u8 halRxChainMask;
+	u16 halTxTrigLevelMax;
+	u16 halRegCap;
+	u8 halNumGpioPins;
+	u8 halNumAntCfg2GHz;
+	u8 halNumAntCfg5GHz;
 };
 
 struct hal_ops_config {
@@ -214,28 +214,28 @@ struct hal_ops_config {
 	int ath_hal_additional_swba_backoff;
 	int ath_hal_6mb_ack;
 	int ath_hal_cwmIgnoreExtCCA;
-	u_int8_t ath_hal_pciePowerSaveEnable;
-	u_int8_t ath_hal_pcieL1SKPEnable;
-	u_int8_t ath_hal_pcieClockReq;
-	u_int32_t ath_hal_pcieWaen;
+	u8 ath_hal_pciePowerSaveEnable;
+	u8 ath_hal_pcieL1SKPEnable;
+	u8 ath_hal_pcieClockReq;
+	u32 ath_hal_pcieWaen;
 	int ath_hal_pciePowerReset;
-	u_int8_t ath_hal_pcieRestore;
-	u_int8_t ath_hal_analogShiftReg;
-	u_int8_t ath_hal_htEnable;
-	u_int32_t ath_hal_ofdmTrigLow;
-	u_int32_t ath_hal_ofdmTrigHigh;
-	u_int32_t ath_hal_cckTrigHigh;
-	u_int32_t ath_hal_cckTrigLow;
-	u_int32_t ath_hal_enableANI;
-	u_int8_t ath_hal_noiseImmunityLvl;
-	u_int32_t ath_hal_ofdmWeakSigDet;
-	u_int32_t ath_hal_cckWeakSigThr;
-	u_int8_t ath_hal_spurImmunityLvl;
-	u_int8_t ath_hal_firStepLvl;
+	u8 ath_hal_pcieRestore;
+	u8 ath_hal_analogShiftReg;
+	u8 ath_hal_htEnable;
+	u32 ath_hal_ofdmTrigLow;
+	u32 ath_hal_ofdmTrigHigh;
+	u32 ath_hal_cckTrigHigh;
+	u32 ath_hal_cckTrigLow;
+	u32 ath_hal_enableANI;
+	u8 ath_hal_noiseImmunityLvl;
+	u32 ath_hal_ofdmWeakSigDet;
+	u32 ath_hal_cckWeakSigThr;
+	u8 ath_hal_spurImmunityLvl;
+	u8 ath_hal_firStepLvl;
 	int8_t ath_hal_rssiThrHigh;
 	int8_t ath_hal_rssiThrLow;
-	u_int16_t ath_hal_diversityControl;
-	u_int16_t ath_hal_antennaSwitchSwap;
+	u16 ath_hal_diversityControl;
+	u16 ath_hal_antennaSwitchSwap;
 	int ath_hal_serializeRegMode;
 	int ath_hal_intrMitigation;
 #define SPUR_DISABLE        	0
@@ -250,7 +250,7 @@ struct hal_ops_config {
 #define AR_SPUR_FEEQ_BOUND_HT40 19
 #define AR_SPUR_FEEQ_BOUND_HT20 10
 	int ath_hal_spurMode;
-	u_int16_t ath_hal_spurChans[AR_EEPROM_MODAL_SPURS][2];
+	u16 ath_hal_spurChans[AR_EEPROM_MODAL_SPURS][2];
 };
 
 enum ath9k_tx_queue {
@@ -285,23 +285,23 @@ enum ath9k_tx_queue_flags {
 };
 
 struct ath9k_txq_info {
-	u_int32_t tqi_ver;
+	u32 tqi_ver;
 	enum ath9k_tx_queue_subtype tqi_subtype;
 	enum ath9k_tx_queue_flags tqi_qflags;
-	u_int32_t tqi_priority;
-	u_int32_t tqi_aifs;
-	u_int32_t tqi_cwmin;
-	u_int32_t tqi_cwmax;
-	u_int16_t tqi_shretry;
-	u_int16_t tqi_lgretry;
-	u_int32_t tqi_cbrPeriod;
-	u_int32_t tqi_cbrOverflowLimit;
-	u_int32_t tqi_burstTime;
-	u_int32_t tqi_readyTime;
-	u_int32_t tqi_compBuf;
+	u32 tqi_priority;
+	u32 tqi_aifs;
+	u32 tqi_cwmin;
+	u32 tqi_cwmax;
+	u16 tqi_shretry;
+	u16 tqi_lgretry;
+	u32 tqi_cbrPeriod;
+	u32 tqi_cbrOverflowLimit;
+	u32 tqi_burstTime;
+	u32 tqi_readyTime;
+	u32 tqi_compBuf;
 };
 
-#define ATH9K_TXQ_USEDEFAULT ((u_int32_t) -1)
+#define ATH9K_TXQ_USEDEFAULT ((u32) -1)
 
 #define ATH9K_DECOMP_MASK_SIZE     128
 #define ATH9K_READY_TIME_LO_BOUND  50
@@ -318,22 +318,22 @@ enum ath9k_pkt_type {
 };
 
 struct ath9k_tx_queue_info {
-	u_int32_t tqi_ver;
+	u32 tqi_ver;
 	enum ath9k_tx_queue tqi_type;
 	enum ath9k_tx_queue_subtype tqi_subtype;
 	enum ath9k_tx_queue_flags tqi_qflags;
-	u_int32_t tqi_priority;
-	u_int32_t tqi_aifs;
-	u_int32_t tqi_cwmin;
-	u_int32_t tqi_cwmax;
-	u_int16_t tqi_shretry;
-	u_int16_t tqi_lgretry;
-	u_int32_t tqi_cbrPeriod;
-	u_int32_t tqi_cbrOverflowLimit;
-	u_int32_t tqi_burstTime;
-	u_int32_t tqi_readyTime;
-	u_int32_t tqi_physCompBuf;
-	u_int32_t tqi_intFlags;
+	u32 tqi_priority;
+	u32 tqi_aifs;
+	u32 tqi_cwmin;
+	u32 tqi_cwmax;
+	u16 tqi_shretry;
+	u16 tqi_lgretry;
+	u32 tqi_cbrPeriod;
+	u32 tqi_cbrOverflowLimit;
+	u32 tqi_burstTime;
+	u32 tqi_readyTime;
+	u32 tqi_physCompBuf;
+	u32 tqi_intFlags;
 };
 
 enum ath9k_rx_filter {
@@ -395,17 +395,17 @@ enum ath9k_int {
 
 struct ath9k_rate_table {
 	int rateCount;
-	u_int8_t rateCodeToIndex[256];
+	u8 rateCodeToIndex[256];
 	struct {
-		u_int8_t valid;
-		u_int8_t phy;
-		u_int32_t rateKbps;
-		u_int8_t rateCode;
-		u_int8_t shortPreamble;
-		u_int8_t dot11Rate;
-		u_int8_t controlRate;
-		u_int16_t lpAckDuration;
-		u_int16_t spAckDuration;
+		u8 valid;
+		u8 phy;
+		u32 rateKbps;
+		u8 rateCode;
+		u8 shortPreamble;
+		u8 dot11Rate;
+		u8 controlRate;
+		u16 lpAckDuration;
+		u16 spAckDuration;
 	} info[32];
 };
 
@@ -414,11 +414,11 @@ struct ath9k_rate_table {
 #define ATH9K_RATESERIES_HALFGI   0x0004
 
 struct ath9k_11n_rate_series {
-	u_int Tries;
-	u_int Rate;
-	u_int PktDuration;
-	u_int ChSel;
-	u_int RateFlags;
+	u32 Tries;
+	u32 Rate;
+	u32 PktDuration;
+	u32 ChSel;
+	u32 RateFlags;
 };
 
 #define CHANNEL_CW_INT    0x00002
@@ -460,21 +460,21 @@ struct ath9k_11n_rate_series {
 	 CHANNEL_HT40MINUS)
 
 struct ath9k_channel {
-	u_int16_t channel;
-	u_int32_t channelFlags;
-	u_int8_t privFlags;
+	u16 channel;
+	u32 channelFlags;
+	u8 privFlags;
 	int8_t maxRegTxPower;
 	int8_t maxTxPower;
 	int8_t minTxPower;
-	u_int32_t chanmode;
+	u32 chanmode;
 	int32_t CalValid;
 	bool oneTimeCalsDone;
 	int8_t iCoff;
 	int8_t qCoff;
 	int16_t rawNoiseFloor;
 	int8_t antennaMax;
-	u_int32_t regDmnFlags;
-	u_int32_t conformanceTestLimit[3]; /* 0:11a, 1: 11b, 2:11g */
+	u32 regDmnFlags;
+	u32 conformanceTestLimit[3]; /* 0:11a, 1: 11b, 2:11g */
 #ifdef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
@@ -513,12 +513,12 @@ struct ath9k_channel {
 	 (((_c)->channel % 10) != 0))
 
 struct ath9k_keyval {
-	u_int8_t kv_type;
-	u_int8_t kv_pad;
-	u_int16_t kv_len;
-	u_int8_t kv_val[16];
-	u_int8_t kv_mic[8];
-	u_int8_t kv_txmic[8];
+	u8 kv_type;
+	u8 kv_pad;
+	u16 kv_len;
+	u8 kv_val[16];
+	u8 kv_mic[8];
+	u8 kv_txmic[8];
 };
 
 enum ath9k_key_type {
@@ -589,12 +589,12 @@ enum reg_ext_bitmap {
 };
 
 struct ath9k_country_entry {
-	u_int16_t countryCode;
-	u_int16_t regDmnEnum;
-	u_int16_t regDmn5G;
-	u_int16_t regDmn2G;
-	u_int8_t isMultidomain;
-	u_int8_t iso[3];
+	u16 countryCode;
+	u16 regDmnEnum;
+	u16 regDmn5G;
+	u16 regDmn2G;
+	u8 isMultidomain;
+	u8 iso[3];
 };
 
 #define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
@@ -647,16 +647,16 @@ struct ath9k_country_entry {
 #define MAX_RATE_POWER 63
 
 #define LE_READ_2(p)							\
-	((u_int16_t)							\
-	 ((((const u_int8_t *)(p))[0]) | \
-		(((const u_int8_t *)(p))[1] << 8)))
+	((u16)							\
+	 ((((const u8 *)(p))[0]) | \
+		(((const u8 *)(p))[1] << 8)))
 
 #define LE_READ_4(p)							\
-	((u_int32_t)							\
-	 ((((const u_int8_t *)(p))[0]) | \
-		(((const u_int8_t *)(p))[1] << 8) | \
-		(((const u_int8_t *)(p))[2] << 16) | \
-			(((const u_int8_t *)(p))[3] << 24)))
+	((u32)							\
+	 ((((const u8 *)(p))[0]) | \
+		(((const u8 *)(p))[1] << 8) | \
+		(((const u8 *)(p))[2] << 16) | \
+			(((const u8 *)(p))[3] << 24)))
 
 enum ath9k_power_mode {
 	ATH9K_PM_AWAKE = 0,
@@ -671,11 +671,11 @@ enum ath9k_power_mode {
 #define HAL_ANTENNA_MAX_MODE  3
 
 struct ath9k_mib_stats {
-	u_int32_t ackrcv_bad;
-	u_int32_t rts_bad;
-	u_int32_t rts_good;
-	u_int32_t fcs_bad;
-	u_int32_t beacons;
+	u32 ackrcv_bad;
+	u32 rts_bad;
+	u32 rts_good;
+	u32 fcs_bad;
+	u32 beacons;
 };
 
 enum ath9k_ant_setting {
@@ -768,32 +768,32 @@ enum ser_reg_mode {
 
 struct ath9k_nfcal_hist {
 	int16_t nfCalBuffer[ATH9K_NF_CAL_HIST_MAX];
-	u_int8_t currIndex;
+	u8 currIndex;
 	int16_t privNF;
-	u_int8_t invalidNFcount;
+	u8 invalidNFcount;
 };
 
 struct ath9k_beacon_state {
-	u_int32_t bs_nexttbtt;
-	u_int32_t bs_nextdtim;
-	u_int32_t bs_intval;
+	u32 bs_nexttbtt;
+	u32 bs_nextdtim;
+	u32 bs_intval;
 #define ATH9K_BEACON_PERIOD       0x0000ffff
 #define ATH9K_BEACON_ENA          0x00800000
 #define ATH9K_BEACON_RESET_TSF    0x01000000
-	u_int32_t bs_dtimperiod;
-	u_int16_t bs_cfpperiod;
-	u_int16_t bs_cfpmaxduration;
-	u_int32_t bs_cfpnext;
-	u_int16_t bs_timoffset;
-	u_int16_t bs_bmissthreshold;
-	u_int32_t bs_sleepduration;
+	u32 bs_dtimperiod;
+	u16 bs_cfpperiod;
+	u16 bs_cfpmaxduration;
+	u32 bs_cfpnext;
+	u16 bs_timoffset;
+	u16 bs_bmissthreshold;
+	u32 bs_sleepduration;
 };
 
 struct ath9k_node_stats {
-	u_int32_t ns_avgbrssi;
-	u_int32_t ns_avgrssi;
-	u_int32_t ns_avgtxrssi;
-	u_int32_t ns_avgtxrate;
+	u32 ns_avgbrssi;
+	u32 ns_avgrssi;
+	u32 ns_avgtxrssi;
+	u32 ns_avgtxrate;
 };
 
 #define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
@@ -816,40 +816,40 @@ enum {
 #define AH_USE_EEPROM   0x1
 
 struct ath_hal {
-	u_int32_t ah_magic;
-	u_int16_t ah_devid;
-	u_int16_t ah_subvendorid;
+	u32 ah_magic;
+	u16 ah_devid;
+	u16 ah_subvendorid;
 	struct ath_softc *ah_sc;
 	void __iomem *ah_sh;
-	u_int16_t ah_countryCode;
-	u_int32_t ah_macVersion;
-	u_int16_t ah_macRev;
-	u_int16_t ah_phyRev;
-	u_int16_t ah_analog5GhzRev;
-	u_int16_t ah_analog2GhzRev;
-	u_int8_t ah_decompMask[ATH9K_DECOMP_MASK_SIZE];
-	u_int32_t ah_flags;
+	u16 ah_countryCode;
+	u32 ah_macVersion;
+	u16 ah_macRev;
+	u16 ah_phyRev;
+	u16 ah_analog5GhzRev;
+	u16 ah_analog2GhzRev;
+	u8 ah_decompMask[ATH9K_DECOMP_MASK_SIZE];
+	u32 ah_flags;
 	enum ath9k_opmode ah_opmode;
 	struct hal_ops_config ah_config;
 	struct hal_capabilities ah_caps;
 	int16_t ah_powerLimit;
-	u_int16_t ah_maxPowerLevel;
-	u_int ah_tpScale;
-	u_int16_t ah_currentRD;
-	u_int16_t ah_currentRDExt;
-	u_int16_t ah_currentRDInUse;
-	u_int16_t ah_currentRD5G;
-	u_int16_t ah_currentRD2G;
+	u16 ah_maxPowerLevel;
+	u32 ah_tpScale;
+	u16 ah_currentRD;
+	u16 ah_currentRDExt;
+	u16 ah_currentRDInUse;
+	u16 ah_currentRD5G;
+	u16 ah_currentRD2G;
 	char ah_iso[4];
 	enum start_adhoc_option ah_adHocMode;
 	bool ah_commonMode;
 	struct ath9k_channel ah_channels[150];
-	u_int ah_nchan;
+	u32 ah_nchan;
 	struct ath9k_channel *ah_curchan;
-	u_int16_t ah_rfsilent;
+	u16 ah_rfsilent;
 	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
-	u_int16_t ah_txTrigLevel;
+	u16 ah_txTrigLevel;
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
@@ -887,36 +887,36 @@ enum {
 };
 
 struct chan_centers {
-	u_int16_t synth_center;
-	u_int16_t ctl_center;
-	u_int16_t ext_center;
+	u16 synth_center;
+	u16 ctl_center;
+	u16 ext_center;
 };
 
 int ath_hal_getcapability(struct ath_hal *ah,
 			  enum hal_capability_type type,
-			  u_int32_t capability,
-			  u_int32_t *result);
+			  u32 capability,
+			  u32 *result);
 const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
-						     u_int mode);
+						     u32 mode);
 void ath9k_hw_detach(struct ath_hal *ah);
-struct ath_hal *ath9k_hw_attach(u_int16_t devid,
+struct ath_hal *ath9k_hw_attach(u16 devid,
 				struct ath_softc *sc,
 				void __iomem *mem,
 				int *error);
 bool ath9k_regd_init_channels(struct ath_hal *ah,
-			      u_int maxchans, u_int *nchans,
-			      u_int8_t *regclassids,
-			      u_int maxregids, u_int *nregids,
-			      u_int16_t cc, u_int32_t modeSelect,
+			      u32 maxchans, u32 *nchans,
+			      u8 *regclassids,
+			      u32 maxregids, u32 *nregids,
+			      u16 cc, u32 modeSelect,
 			      bool enableOutdoor,
 			      bool enableExtendedChannels);
-u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
+u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah,
 				     enum ath9k_int ints);
 bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    struct ath9k_channel *chan,
 		    enum ath9k_ht_macmode macmode,
-		    u_int8_t txchainmask, u_int8_t rxchainmask,
+		    u8 txchainmask, u8 rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
 		    int *status);
@@ -928,28 +928,28 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 			  struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hal *ah,
 			struct ath9k_channel *chan,
-			u_int8_t rxchainmask,
+			u8 rxchainmask,
 			bool longcal,
 			bool *isCalDone);
 int16_t ath9k_hw_getchan_noise(struct ath_hal *ah,
 			       struct ath9k_channel *chan);
-void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
-			    u_int16_t assocId);
-void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits);
-void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
-			    u_int16_t assocId);
-bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q);
+void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
+			    u16 assocId);
+void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits);
+void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
+			    u16 assocId);
+bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q);
 void ath9k_hw_reset_tsf(struct ath_hal *ah);
-bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry);
-bool ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
-			const u_int8_t *mac);
+bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry);
+bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry,
+			const u8 *mac);
 bool ath9k_hw_set_keycache_entry(struct ath_hal *ah,
-				 u_int16_t entry,
+				 u16 entry,
 				 const struct ath9k_keyval *k,
-				 const u_int8_t *mac,
+				 const u8 *mac,
 				 int xorKey);
 bool ath9k_hw_set_tsfadjust(struct ath_hal *ah,
-			    u_int32_t setting);
+			    u32 setting);
 void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
 bool ath9k_hw_intrpend(struct ath_hal *ah);
 bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked);
@@ -960,59 +960,59 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
 void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
 bool ath9k_hw_phycounters(struct ath_hal *ah);
-bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry);
+bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry);
 bool ath9k_hw_getcapability(struct ath_hal *ah,
 			    enum hal_capability_type type,
-			    u_int32_t capability,
-			    u_int32_t *result);
+			    u32 capability,
+			    u32 *result);
 bool ath9k_hw_setcapability(struct ath_hal *ah,
 			    enum hal_capability_type type,
-			    u_int32_t capability,
-			    u_int32_t setting,
+			    u32 capability,
+			    u32 setting,
 			    int *status);
-u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
-void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac);
-void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask);
+u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
+void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac);
+void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask);
 bool ath9k_hw_setbssidmask(struct ath_hal *ah,
-			   const u_int8_t *mask);
+			   const u8 *mask);
 bool ath9k_hw_setpower(struct ath_hal *ah,
 		       enum ath9k_power_mode mode);
 enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah);
-u_int64_t ath9k_hw_gettsf64(struct ath_hal *ah);
-u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
-bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us);
+u64 ath9k_hw_gettsf64(struct ath_hal *ah);
+u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
+bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us);
 bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			       enum ath9k_ant_setting settings,
 			       struct ath9k_channel *chan,
-			       u_int8_t *tx_chainmask,
-			       u_int8_t *rx_chainmask,
-			       u_int8_t *antenna_cfgd);
-void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna);
+			       u8 *tx_chainmask,
+			       u8 *rx_chainmask,
+			       u8 *antenna_cfgd);
+void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna);
 int ath9k_hw_select_antconfig(struct ath_hal *ah,
-			      u_int32_t cfg);
-bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
-		       u_int32_t txdp);
-bool ath9k_hw_txstart(struct ath_hal *ah, u_int q);
-u_int16_t ath9k_hw_computetxtime(struct ath_hal *ah,
+			      u32 cfg);
+bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q,
+		       u32 txdp);
+bool ath9k_hw_txstart(struct ath_hal *ah, u32 q);
+u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 				 const struct ath9k_rate_table *rates,
-				 u_int32_t frameLen, u_int16_t rateix,
+				 u32 frameLen, u16 rateix,
 				 bool shortPreamble);
 void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
-				  u_int durUpdateEn, u_int rtsctsRate,
-				  u_int rtsctsDuration,
+				  u32 durUpdateEn, u32 rtsctsRate,
+				  u32 rtsctsDuration,
 				  struct ath9k_11n_rate_series series[],
-				  u_int nseries, u_int flags);
+				  u32 nseries, u32 flags);
 void ath9k_hw_set11n_burstduration(struct ath_hal *ah,
 				   struct ath_desc *ds,
-				   u_int burstDuration);
+				   u32 burstDuration);
 void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
-u_int32_t ath9k_hw_reverse_bits(u_int32_t val, u_int32_t n);
-bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q);
-u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
-u_int ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
+u32 ath9k_hw_reverse_bits(u32 val, u32 n);
+bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q);
+u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
+u32 ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 				     struct ath9k_channel *chan);
-u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
+u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
 bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 			      struct ath9k_txq_info *qInfo);
 bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
@@ -1020,62 +1020,62 @@ bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 struct ath9k_channel *ath9k_regd_check_channel(struct ath_hal *ah,
 					      const struct ath9k_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-			    u_int pktLen, enum ath9k_pkt_type type,
-			    u_int txPower, u_int keyIx,
-			    enum ath9k_key_type keyType, u_int flags);
+			    u32 pktLen, enum ath9k_pkt_type type,
+			    u32 txPower, u32 keyIx,
+			    enum ath9k_key_type keyType, u32 flags);
 bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-			 u_int segLen, bool firstSeg,
+			 u32 segLen, bool firstSeg,
 			 bool lastSeg,
 			 const struct ath_desc *ds0);
-u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
-					u_int32_t *rxc_pcnt,
-					u_int32_t *rxf_pcnt,
-					u_int32_t *txf_pcnt);
+u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
+					u32 *rxc_pcnt,
+					u32 *rxf_pcnt,
+					u32 *txf_pcnt);
 void ath9k_hw_dmaRegDump(struct ath_hal *ah);
 void ath9k_hw_beaconinit(struct ath_hal *ah,
-			 u_int32_t next_beacon, u_int32_t beacon_period);
+			 u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 				    const struct ath9k_beacon_state *bs);
 bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
-			  u_int32_t size, u_int flags);
-void ath9k_hw_putrxbuf(struct ath_hal *ah, u_int32_t rxdp);
+			  u32 size, u32 flags);
+void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp);
 void ath9k_hw_rxena(struct ath_hal *ah);
 void ath9k_hw_setopmode(struct ath_hal *ah);
-bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac);
-void ath9k_hw_setmcastfilter(struct ath_hal *ah, u_int32_t filter0,
-			     u_int32_t filter1);
-u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah);
+bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
+void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0,
+			     u32 filter1);
+u32 ath9k_hw_getrxfilter(struct ath_hal *ah);
 void ath9k_hw_startpcureceive(struct ath_hal *ah);
 void ath9k_hw_stoppcurecv(struct ath_hal *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
 int ath9k_hw_rxprocdesc(struct ath_hal *ah,
-			struct ath_desc *ds, u_int32_t pa,
-			struct ath_desc *nds, u_int64_t tsf);
-u_int32_t ath9k_hw_gettxbuf(struct ath_hal *ah, u_int q);
+			struct ath_desc *ds, u32 pa,
+			struct ath_desc *nds, u64 tsf);
+u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q);
 int ath9k_hw_txprocdesc(struct ath_hal *ah,
 			struct ath_desc *ds);
 void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
-				 u_int numDelims);
+				 u32 numDelims);
 void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
-				u_int aggrLen);
+				u32 aggrLen);
 void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds);
-bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q);
-void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs);
+bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q);
+void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs);
 void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds);
 void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah,
-				     struct ath_desc *ds, u_int vmf);
-bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit);
+				     struct ath_desc *ds, u32 vmf);
+bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
 bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah);
 int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_txq_info *qInfo);
-u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q);
-const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid);
+u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q);
+const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 bool ath9k_hw_disable(struct ath_hal *ah);
 void ath9k_hw_rfdetach(struct ath_hal *ah);
 void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 				  struct ath9k_channel *chan,
 				  struct chan_centers *centers);
 bool ath9k_get_channel_edges(struct ath_hal *ah,
-			     u_int16_t flags, u_int16_t *low,
-			     u_int16_t *high);
+			     u16 flags, u16 *low,
+			     u16 *high);
 #endif
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index e26f184..ff80327 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -71,7 +71,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	struct ath_desc *ds;
 	int flags, antenna;
 	const struct ath9k_rate_table *rt;
-	u_int8_t rix, rate;
+	u8 rix, rate;
 	int ctsrate = 0;
 	int ctsduration = 0;
 	struct ath9k_11n_rate_series  series[4];
@@ -433,7 +433,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	 * following the header.
 	 */
 	if (avp->av_bslot > 0) {
-		u_int64_t tsfadjust;
+		u64 tsfadjust;
 		__le64 val;
 		int intval;
 
@@ -539,19 +539,19 @@ void ath_beacon_free(struct ath_softc *sc)
 void ath9k_beacon_tasklet(unsigned long data)
 {
 #define TSF_TO_TU(_h,_l)					\
-	((((u_int32_t)(_h)) << 22) | (((u_int32_t)(_l)) >> 10))
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
 	int slot, if_id;
-	u_int32_t bfaddr;
-	u_int32_t rx_clear = 0, rx_frame = 0, tx_frame = 0;
-	u_int32_t show_cycles = 0;
-	u_int32_t bc = 0; /* beacon count */
-	u_int64_t tsf;
-	u_int32_t tsftu;
-	u_int16_t intval;
+	u32 bfaddr;
+	u32 rx_clear = 0, rx_frame = 0, tx_frame = 0;
+	u32 show_cycles = 0;
+	u32 bc = 0; /* beacon count */
+	u64 tsf;
+	u32 tsftu;
+	u16 intval;
 
 	if (sc->sc_noreset) {
 		show_cycles = ath9k_hw_GetMibCycleCountsPct(ah,
@@ -739,9 +739,9 @@ void ath_bstuck_process(struct ath_softc *sc)
 void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
 #define TSF_TO_TU(_h,_l)					\
-	((((u_int32_t)(_h)) << 22) | (((u_int32_t)(_l)) >> 10))
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 	struct ath_hal *ah = sc->sc_ah;
-	u_int32_t nexttbtt, intval;
+	u32 nexttbtt, intval;
 	struct ath_beacon_config conf;
 	enum ath9k_opmode av_opmode;
 
@@ -791,8 +791,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
 	if (sc->sc_opmode == ATH9K_M_STA) {
 		struct ath9k_beacon_state bs;
-		u_int64_t tsf;
-		u_int32_t tsftu;
+		u64 tsf;
+		u32 tsftu;
 		int dtimperiod, dtimcount, sleepduration;
 		int cfpperiod, cfpcount;
 
@@ -904,8 +904,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		sc->sc_imask |= ATH9K_INT_BMISS;
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	} else {
-		u_int64_t tsf;
-		u_int32_t tsftu;
+		u64 tsf;
+		u32 tsftu;
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
 			intval |= ATH9K_BEACON_RESET_TSF;
@@ -917,8 +917,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 #define FUDGE   2
 			if (!(intval & ATH9K_BEACON_RESET_TSF)) {
 				tsf = ath9k_hw_gettsf64(ah);
-				tsftu = TSF_TO_TU((u_int32_t)(tsf>>32),
-					(u_int32_t)tsf) + FUDGE;
+				tsftu = TSF_TO_TU((u32)(tsf>>32),
+					(u32)tsf) + FUDGE;
 				do {
 					nexttbtt += intval;
 				} while (nexttbtt < tsftu);
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index df86dd3..3225705 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -21,23 +21,23 @@
 
 static int ath_outdoor;		/* enable outdoor use */
 
-static const u_int8_t ath_bcast_mac[ETH_ALEN] =
+static const u8 ath_bcast_mac[ETH_ALEN] =
     { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
-static u_int32_t ath_chainmask_sel_up_rssi_thres =
+static u32 ath_chainmask_sel_up_rssi_thres =
 	ATH_CHAINMASK_SEL_UP_RSSI_THRES;
-static u_int32_t ath_chainmask_sel_down_rssi_thres =
+static u32 ath_chainmask_sel_down_rssi_thres =
 	ATH_CHAINMASK_SEL_DOWN_RSSI_THRES;
-static u_int32_t ath_chainmask_sel_period =
+static u32 ath_chainmask_sel_period =
 	ATH_CHAINMASK_SEL_TIMEOUT;
 
 /* return bus cachesize in 4B word units */
 
 static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 {
-	u_int8_t u8tmp;
+	u8 u8tmp;
 
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u_int8_t *)&u8tmp);
+	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u8 *)&u8tmp);
 	*csz = (int)u8tmp;
 
 	/*
@@ -68,11 +68,11 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 	BUG_ON(!rt);
 
 	for (i = 0; i < rt->rateCount; i++)
-		sc->sc_rixmap[rt->info[i].rateCode] = (u_int8_t) i;
+		sc->sc_rixmap[rt->info[i].rateCode] = (u8) i;
 
 	memzero(sc->sc_hwmap, sizeof(sc->sc_hwmap));
 	for (i = 0; i < 256; i++) {
-		u_int8_t ix = rt->rateCodeToIndex[i];
+		u8 ix = rt->rateCodeToIndex[i];
 
 		if (ix == 0xff)
 			continue;
@@ -173,8 +173,8 @@ static int ath_setup_channels(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	int nchan, i, a = 0, b = 0;
-	u_int8_t regclassids[ATH_REGCLASSIDS_MAX];
-	u_int nregclass = 0;
+	u8 regclassids[ATH_REGCLASSIDS_MAX];
+	u32 nregclass = 0;
 	struct ieee80211_supported_band *band_2ghz;
 	struct ieee80211_supported_band *band_5ghz;
 	struct ieee80211_channel *chan_2ghz;
@@ -184,7 +184,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 	/* Fill in ah->ah_channels */
 	if (!ath9k_regd_init_channels(ah,
 				      ATH_CHAN_MAX,
-				      (u_int *)&nchan,
+				      (u32 *)&nchan,
 				      regclassids,
 				      ATH_REGCLASSIDS_MAX,
 				      &nregclass,
@@ -192,7 +192,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 				      ATH9K_MODE_SEL_ALL,
 				      false,
 				      1)) {
-		u_int32_t rd = ah->ah_currentRD;
+		u32 rd = ah->ah_currentRD;
 
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to collect channel list; "
@@ -357,8 +357,8 @@ static int ath_stop(struct ath_softc *sc)
 void ath_scan_start(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u_int32_t rfilt;
-	u_int32_t now = (u_int32_t) jiffies_to_msecs(get_timestamp());
+	u32 rfilt;
+	u32 now = (u32) jiffies_to_msecs(get_timestamp());
 
 	sc->sc_scanning = 1;
 	rfilt = ath_calcrxfilter(sc);
@@ -382,8 +382,8 @@ void ath_scan_start(struct ath_softc *sc)
 void ath_scan_end(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u_int32_t rfilt;
-	u_int32_t now = (u_int32_t) jiffies_to_msecs(get_timestamp());
+	u32 rfilt;
+	u32 now = (u32) jiffies_to_msecs(get_timestamp());
 
 	sc->sc_scanning = 0;
 	/* Request for a full reset due to rx packet filter changes */
@@ -605,7 +605,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_vap *avp;
-	u_int32_t rfilt = 0;
+	u32 rfilt = 0;
 	DECLARE_MAC_BUF(mac);
 
 	avp = sc->sc_vaps[if_id];
@@ -874,7 +874,7 @@ done:
  * and to reset the hardware when rf gain settings must be reset.
  */
 
-static int ath_reset_start(struct ath_softc *sc, u_int32_t flag)
+static int ath_reset_start(struct ath_softc *sc, u32 flag)
 {
 	struct ath_hal *ah = sc->sc_ah;
 
@@ -886,7 +886,7 @@ static int ath_reset_start(struct ath_softc *sc, u_int32_t flag)
 	return 0;
 }
 
-static int ath_reset_end(struct ath_softc *sc, u_int32_t flag)
+static int ath_reset_end(struct ath_softc *sc, u32 flag)
 {
 	struct ath_hal *ah = sc->sc_ah;
 
@@ -1083,7 +1083,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 static void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
-	u_int32_t status = sc->sc_intrstatus;
+	u32 status = sc->sc_intrstatus;
 
 	if (status & ATH9K_INT_FATAL) {
 		/* need a chip reset */
@@ -1124,13 +1124,13 @@ static void ath9k_tasklet(unsigned long data)
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
 }
 
-int ath_init(u_int16_t devid, struct ath_softc *sc)
+int ath_init(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hal *ah = NULL;
 	int status;
 	int error = 0, i;
 	int csz = 0;
-	u_int32_t rd;
+	u32 rd;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_invalid = 1;
@@ -1180,7 +1180,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	 * reset the contents on initial power up.
 	 */
 	for (i = 0; i < sc->sc_keymax; i++)
-		ath9k_hw_keyreset(ah, (u_int16_t) i);
+		ath9k_hw_keyreset(ah, (u16) i);
 	/*
 	 * Mark key cache slots associated with global keys
 	 * as in use.  If we knew TKIP was not to be used we
@@ -1514,7 +1514,7 @@ void ath_newassoc(struct ath_softc *sc,
 /* Encryption */
 /**************/
 
-void ath_key_reset(struct ath_softc *sc, u_int16_t keyix, int freeslot)
+void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot)
 {
 	ath9k_hw_keyreset(sc->sc_ah, keyix);
 	if (freeslot)
@@ -1522,9 +1522,9 @@ void ath_key_reset(struct ath_softc *sc, u_int16_t keyix, int freeslot)
 }
 
 int ath_keyset(struct ath_softc *sc,
-	       u_int16_t keyix,
+	       u16 keyix,
 	       struct ath9k_keyval *hk,
-	       const u_int8_t mac[ETH_ALEN])
+	       const u8 mac[ETH_ALEN])
 {
 	bool status;
 
@@ -1548,7 +1548,7 @@ int ath_keyset(struct ath_softc *sc,
 void ath_update_txpow(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u_int32_t txpow;
+	u32 txpow;
 
 	if (sc->sc_curtxpow != sc->sc_config.txpowlimit) {
 		ath9k_hw_set_txpowerlimit(ah, sc->sc_config.txpowlimit);
@@ -1598,8 +1598,8 @@ void ath_slow_ant_div_init(struct ath_antdiv *antdiv,
 }
 
 void ath_slow_ant_div_start(struct ath_antdiv *antdiv,
-			    u_int8_t num_antcfg,
-			    const u_int8_t *bssid)
+			    u8 num_antcfg,
+			    const u8 *bssid)
 {
 	antdiv->antdiv_num_antcfg =
 		num_antcfg < ATH_ANT_DIV_MAX_CFG ?
@@ -1620,10 +1620,10 @@ void ath_slow_ant_div_stop(struct ath_antdiv *antdiv)
 }
 
 static int32_t ath_find_max_val(int32_t *val,
-	u_int8_t num_val, u_int8_t *max_index)
+	u8 num_val, u8 *max_index)
 {
-	u_int32_t MaxVal = *val++;
-	u_int32_t cur_index = 0;
+	u32 MaxVal = *val++;
+	u32 cur_index = 0;
 
 	*max_index = 0;
 	while (++cur_index < num_val) {
@@ -1644,8 +1644,8 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
 {
 	struct ath_softc *sc = antdiv->antdiv_sc;
 	struct ath_hal *ah = sc->sc_ah;
-	u_int64_t curtsf = 0;
-	u_int8_t bestcfg, curcfg = antdiv->antdiv_curcfg;
+	u64 curtsf = 0;
+	u8 bestcfg, curcfg = antdiv->antdiv_curcfg;
 	__le16 fc = hdr->frame_control;
 
 	if (antdiv->antdiv_start && ieee80211_is_beacon(fc)
@@ -1756,9 +1756,9 @@ int ath_descdma_setup(struct ath_softc *sc,
 	 * one skipped descriptor per 4K page.
 	 */
 	if (!(sc->sc_ah->ah_caps.hal4kbSplitTransSupport)) {
-		u_int32_t ndesc_skipped =
+		u32 ndesc_skipped =
 			ATH_DESC_4KB_BOUND_NUM_SKIPPED(dd->dd_desc_len);
-		u_int32_t dma_len;
+		u32 dma_len;
 
 		while (ndesc_skipped) {
 			dma_len = ndesc_skipped * sizeof(struct ath_desc);
@@ -1778,8 +1778,8 @@ int ath_descdma_setup(struct ath_softc *sc,
 	}
 	ds = dd->dd_desc;
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
-		__func__, dd->dd_name, ds, (u_int32_t) dd->dd_desc_len,
-		ito64(dd->dd_desc_paddr), /*XXX*/(u_int32_t) dd->dd_desc_len);
+		__func__, dd->dd_name, ds, (u32) dd->dd_desc_len,
+		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
 	/* allocate buffers */
 	bsize = sizeof(struct ath_buf) * nbuf;
@@ -1883,7 +1883,7 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
 	return qnum;
 }
 
-int ath_get_mac80211_qnum(u_int queue, struct ath_softc *sc)
+int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
 {
 	int qnum;
 
@@ -1916,9 +1916,9 @@ int ath_get_mac80211_qnum(u_int queue, struct ath_softc *sc)
  *  a full 64-bit TSF using the current h/w TSF.
 */
 
-u_int64_t ath_extend_tsf(struct ath_softc *sc, u_int32_t rstamp)
+u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
 {
-	u_int64_t tsf;
+	u64 tsf;
 
 	tsf = ath9k_hw_gettsf64(sc->sc_ah);
 	if ((tsf & 0x7fff) < rstamp)
@@ -1933,7 +1933,7 @@ u_int64_t ath_extend_tsf(struct ath_softc *sc, u_int32_t rstamp)
  *  MIMO technology.
 */
 
-void ath_setdefantenna(void *context, u_int antenna)
+void ath_setdefantenna(void *context, u32 antenna)
 {
 	struct ath_softc *sc = (struct ath_softc *)context;
 	struct ath_hal *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1ac56e0..e243b53 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -136,11 +136,11 @@ enum ATH_DEBUG {
 /* Per-instance load-time (note: NOT run-time) configurations
  * for Atheros Device */
 struct ath_config {
-	u_int32_t   ath_aggr_prot;
-	u_int16_t   txpowlimit;
-	u_int16_t   txpowlimit_override;
-	u_int8_t    cabqReadytime; /* Cabq Readytime % */
-	u_int8_t    swBeaconProcess; /* Process received beacons
+	u32   ath_aggr_prot;
+	u16   txpowlimit;
+	u16   txpowlimit_override;
+	u8    cabqReadytime; /* Cabq Readytime % */
+	u8    swBeaconProcess; /* Process received beacons
 					in SW (vs HW) */
 };
 
@@ -192,8 +192,8 @@ chains is due to FF aggregation in the driver. */
 
 struct ath_buf_state {
 	int bfs_nframes;	/* # frames in aggregate */
-	u_int16_t bfs_al;	/* length of aggregate */
-	u_int16_t bfs_frmlen;	/* length of frame */
+	u16 bfs_al;	/* length of aggregate */
+	u16 bfs_frmlen;	/* length of frame */
 	int bfs_seqno;		/* sequence number */
 	int bfs_tidno;		/* tid of this frame */
 	int bfs_retries;	/* current retries */
@@ -256,8 +256,8 @@ struct ath_buf {
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
-	u_int32_t bf_status;
-	u_int16_t bf_flags;		/* tx descriptor flags */
+	u32 bf_status;
+	u16 bf_flags;		/* tx descriptor flags */
 	struct ath_buf_state bf_state;	/* buffer state */
 	dma_addr_t bf_dmacontext;
 };
@@ -284,7 +284,7 @@ struct ath_descdma {
 	const char *dd_name;
 	struct ath_desc *dd_desc;	/* descriptors  */
 	dma_addr_t dd_desc_paddr;	/* physical addr of dd_desc  */
-	u_int32_t dd_desc_len;		/* size of dd_desc  */
+	u32 dd_desc_len;		/* size of dd_desc  */
 	struct ath_buf *dd_bufptr;	/* associated buffers */
 	dma_addr_t dd_dmacontext;
 };
@@ -326,13 +326,13 @@ enum ATH_RX_TYPE {
 
 /* per frame rx status block */
 struct ath_recv_status {
-	u_int64_t tsf;		/* mac tsf */
+	u64 tsf;		/* mac tsf */
 	int8_t rssi;		/* RSSI (noise floor ajusted) */
 	int8_t rssictl[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
 	int8_t rssiextn[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
 	int8_t abs_rssi;	/* absolute RSSI */
-	u_int8_t rateieee;	/* data rate received (IEEE rate code) */
-	u_int8_t ratecode;	/* phy rate code */
+	u8 rateieee;	/* data rate received (IEEE rate code) */
+	u8 ratecode;	/* phy rate code */
 	int rateKbps;		/* data rate received (Kbps) */
 	int antenna;		/* rx antenna */
 	int flags;		/* status of associated skb */
@@ -366,8 +366,8 @@ struct ath_arx_tid {
 	int                 baw_tail;   /* tail of block-ack window */
 	int                 seq_reset;  /* need to reset start sequence */
 	int         	    addba_exchangecomplete;
-	u_int16_t           seq_next;   /* next expected sequence */
-	u_int16_t           baw_size;   /* block-ack window size */
+	u16           seq_next;   /* next expected sequence */
+	u16           baw_size;   /* block-ack window size */
 };
 
 /* Per-node receiver aggregate state */
@@ -378,7 +378,7 @@ struct ath_arx {
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
-u_int32_t ath_calcrxfilter(struct ath_softc *sc);
+u32 ath_calcrxfilter(struct ath_softc *sc);
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an);
 void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
@@ -395,7 +395,7 @@ int ath_rx_input(struct ath_softc *sc,
 int ath__rx_indicate(struct ath_softc *sc,
 		    struct sk_buff *skb,
 		    struct ath_recv_status *status,
-		    u_int16_t keyix);
+		    u16 keyix);
 int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
 		    struct ath_recv_status *status);
 
@@ -444,15 +444,15 @@ enum ATH_SM_PWRSAV{
  * hardware queue).
  */
 struct ath_txq {
-	u_int			axq_qnum;	/* hardware q number */
-	u_int32_t		*axq_link;	/* link ptr in last TX desc */
+	u32			axq_qnum;	/* hardware q number */
+	u32		*axq_link;	/* link ptr in last TX desc */
 	struct list_head	axq_q;		/* transmit queue */
 	spinlock_t		axq_lock;	/* lock on q and link */
 	unsigned long		axq_lockflags;	/* intr state when must cli */
-	u_int			axq_depth;	/* queue depth */
-	u_int8_t                axq_aggr_depth; /* aggregates queued */
-	u_int32_t		axq_totalqueued;/* total ever queued */
-	u_int			axq_intrcnt;	/* count to determine
+	u32			axq_depth;	/* queue depth */
+	u8                axq_aggr_depth; /* aggregates queued */
+	u32		axq_totalqueued;/* total ever queued */
+	u32			axq_intrcnt;	/* count to determine
 						if descriptor should generate
 						int on this txq. */
 	bool			stopped;	/* Is mac80211 queue
@@ -474,9 +474,9 @@ struct ath_atx_tid {
 	struct ath_node         *an;        /* parent node structure */
 	struct ath_atx_ac       *ac;        /* parent access category */
 	struct ath_buf          *tx_buf[ATH_TID_MAX_BUFS];/* active tx frames */
-	u_int16_t               seq_start;  /* starting seq of BA window */
-	u_int16_t               seq_next;   /* next seq to be used */
-	u_int16_t               baw_size;   /* BA window size */
+	u16               seq_start;  /* starting seq of BA window */
+	u16               seq_next;   /* next seq to be used */
+	u16               baw_size;   /* BA window size */
 	int                     tidno;      /* TID number */
 	int                     baw_head;   /* first un-acked tx buffer */
 	int                     baw_tail;   /* next unused tx buffer slot */
@@ -484,7 +484,7 @@ struct ath_atx_tid {
 	int                     paused;     /* TID is paused */
 	int                     cleanup_inprogress; /* aggr of this TID is
 						being teared down */
-	u_int32_t               addba_exchangecomplete:1; /* ADDBA state */
+	u32               addba_exchangecomplete:1; /* ADDBA state */
 	int32_t                 addba_exchangeinprogress;
 	int                     addba_exchangeattempts;
 };
@@ -509,21 +509,21 @@ struct ath_tx_control {
 	struct ath_node *an;	/* destination to sent to */
 	int if_id;		/* only valid for cab traffic */
 	int qnum;		/* h/w queue number */
-	u_int ht:1;             /* if it can be transmitted using HT */
-	u_int ps:1;             /* if one or more stations are in PS mode */
-	u_int use_minrate:1;	/* if this frame should transmitted using
+	u32 ht:1;             /* if it can be transmitted using HT */
+	u32 ps:1;             /* if one or more stations are in PS mode */
+	u32 use_minrate:1;	/* if this frame should transmitted using
 				minimum rate */
 	enum ath9k_pkt_type atype;	/* Atheros packet type */
 	enum ath9k_key_type keytype;	/* key type */
-	u_int flags;		/* HAL flags */
-	u_int16_t seqno;	/* sequence number */
-	u_int16_t tidno;	/* tid number */
-	u_int16_t txpower;	/* transmit power */
-	u_int16_t frmlen;       /* frame length */
-	u_int32_t keyix;        /* key index */
+	u32 flags;		/* HAL flags */
+	u16 seqno;	/* sequence number */
+	u16 tidno;	/* tid number */
+	u16 txpower;	/* transmit power */
+	u16 frmlen;       /* frame length */
+	u32 keyix;        /* key index */
 	int min_rate;		/* minimum rate */
 	int mcast_rate;		/* multicast rate */
-	u_int16_t nextfraglen;	/* next fragment length */
+	u16 nextfraglen;	/* next fragment length */
 	/* below is set only by ath_dev */
 	struct ath_softc *dev;	/* device handle */
 	dma_addr_t dmacontext;
@@ -551,7 +551,7 @@ struct ath_tx_stat {
 #define ATH_TX_CHAIN_RSSI_VALID 0x01
 /* if extn chain rssis are valid */
 #define ATH_TX_RSSI_EXTN_VALID  0x02
-	u_int32_t airtime;	/* time on air per final tx rate */
+	u32 airtime;	/* time on air per final tx rate */
 };
 
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
@@ -571,9 +571,9 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *q);
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb);
 void ath_tx_tasklet(struct ath_softc *sc);
-u_int32_t ath_txq_depth(struct ath_softc *sc, int qnum);
-u_int32_t ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
-void ath_notify_txq_status(struct ath_softc *sc, u_int16_t queue_depth);
+u32 ath_txq_depth(struct ath_softc *sc, int qnum);
+u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
+void ath_notify_txq_status(struct ath_softc *sc, u16 queue_depth);
 void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		     struct ath_xmit_status *tx_status, struct ath_node *an);
 
@@ -657,8 +657,8 @@ struct ath_node {
 	atomic_t		an_refcnt;
 	struct ath_chainmask_sel an_chainmask_sel;
 	struct ath_node_aggr 	an_aggr; /* A-MPDU aggregation state */
-	u_int8_t             	an_smmode; /* SM Power save mode */
-	u_int8_t         	an_flags;
+	u8             	an_smmode; /* SM Power save mode */
+	u8         	an_flags;
 	u8	 		an_addr[ETH_ALEN];
 };
 
@@ -667,9 +667,9 @@ void ath_tx_resume_tid(struct ath_softc *sc,
 enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
 	struct ath_node *an, u8 tidno);
 void ath_tx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u_int8_t tidno);
+	struct ath_node *an, u8 tidno);
 void ath_rx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u_int8_t tidno);
+	struct ath_node *an, u8 tidno);
 int ath_rx_aggr_start(struct ath_softc *sc,
 		      const u8 *addr,
 		      u16 tid,
@@ -687,11 +687,11 @@ int ath_tx_aggr_stop(struct ath_softc *sc,
 void ath_newassoc(struct ath_softc *sc,
 	struct ath_node *node, int isnew, int isuapsd);
 struct ath_node *ath_node_attach(struct ath_softc *sc,
-	u_int8_t addr[ETH_ALEN], int if_id);
+	u8 addr[ETH_ALEN], int if_id);
 void ath_node_detach(struct ath_softc *sc, struct ath_node *an, bool bh_flag);
-struct ath_node *ath_node_get(struct ath_softc *sc, u_int8_t addr[ETH_ALEN]);
+struct ath_node *ath_node_get(struct ath_softc *sc, u8 addr[ETH_ALEN]);
 void ath_node_put(struct ath_softc *sc, struct ath_node *an, bool bh_flag);
-struct ath_node *ath_node_find(struct ath_softc *sc, u_int8_t *addr);
+struct ath_node *ath_node_find(struct ath_softc *sc, u8 *addr);
 
 /*******************/
 /* Beacon Handling */
@@ -713,22 +713,22 @@ struct ath_node *ath_node_find(struct ath_softc *sc, u_int8_t *addr);
 
 /* beacon configuration */
 struct ath_beacon_config {
-	u_int16_t beacon_interval;
-	u_int16_t listen_interval;
-	u_int16_t dtim_period;
-	u_int16_t bmiss_timeout;
-	u_int8_t dtim_count;
-	u_int8_t tim_offset;
+	u16 beacon_interval;
+	u16 listen_interval;
+	u16 dtim_period;
+	u16 bmiss_timeout;
+	u8 dtim_count;
+	u8 tim_offset;
 	union {
-		u_int64_t last_tsf;
-		u_int8_t last_tstamp[8];
+		u64 last_tsf;
+		u8 last_tstamp[8];
 	} u; /* last received beacon/probe response timestamp of this BSS. */
 };
 
 /* offsets in a beacon frame for
  * quick acess of beacon content by low-level driver */
 struct ath_beacon_offset {
-	u_int8_t *bo_tim;	/* start of atim/dtim */
+	u8 *bo_tim;	/* start of atim/dtim */
 };
 
 void ath9k_beacon_tasklet(unsigned long data);
@@ -775,8 +775,8 @@ int ath_update_beacon(struct ath_softc *sc,
 
 /* VAP configuration (from protocol layer) */
 struct ath_vap_config {
-	u_int32_t av_fixed_rateset;
-	u_int32_t av_fixed_retryset;
+	u32 av_fixed_rateset;
+	u32 av_fixed_retryset;
 };
 
 /* driver-specific vap state */
@@ -820,28 +820,28 @@ enum ATH_ANT_DIV_STATE{
 
 struct ath_antdiv {
 	struct ath_softc *antdiv_sc;
-	u_int8_t antdiv_start;
+	u8 antdiv_start;
 	enum ATH_ANT_DIV_STATE antdiv_state;
-	u_int8_t antdiv_num_antcfg;
-	u_int8_t antdiv_curcfg;
-	u_int8_t antdiv_bestcfg;
+	u8 antdiv_num_antcfg;
+	u8 antdiv_curcfg;
+	u8 antdiv_bestcfg;
 	int32_t antdivf_rssitrig;
 	int32_t antdiv_lastbrssi[ATH_ANT_DIV_MAX_CFG];
-	u_int64_t antdiv_lastbtsf[ATH_ANT_DIV_MAX_CFG];
-	u_int64_t antdiv_laststatetsf;
-	u_int8_t antdiv_bssid[ETH_ALEN];
+	u64 antdiv_lastbtsf[ATH_ANT_DIV_MAX_CFG];
+	u64 antdiv_laststatetsf;
+	u8 antdiv_bssid[ETH_ALEN];
 };
 
 void ath_slow_ant_div_init(struct ath_antdiv *antdiv,
 	struct ath_softc *sc, int32_t rssitrig);
 void ath_slow_ant_div_start(struct ath_antdiv *antdiv,
-			    u_int8_t num_antcfg,
-			    const u_int8_t *bssid);
+			    u8 num_antcfg,
+			    const u8 *bssid);
 void ath_slow_ant_div_stop(struct ath_antdiv *antdiv);
 void ath_slow_ant_div(struct ath_antdiv *antdiv,
 		      struct ieee80211_hdr *wh,
 		      struct ath_rx_status *rx_stats);
-void ath_setdefantenna(void *sc, u_int antenna);
+void ath_setdefantenna(void *sc, u32 antenna);
 
 /********************/
 /* Main driver core */
@@ -916,9 +916,9 @@ enum RATE_TYPE {
 
 struct ath_ht_info {
 	enum ath9k_ht_macmode tx_chan_width;
-	u_int16_t maxampdu;
-	u_int8_t mpdudensity;
-	u_int8_t ext_chan_offset;
+	u16 maxampdu;
+	u8 mpdudensity;
+	u8 ext_chan_offset;
 };
 
 struct ath_softc {
@@ -932,52 +932,52 @@ struct ath_softc {
 	int                     sc_debug;   /* Debug masks */
 	struct ath_hal          *sc_ah;     /* HAL Instance */
 	struct ath_rate_softc    *sc_rc;     /* tx rate control support */
-	u_int32_t               sc_intrstatus; /* HAL_STATUS */
+	u32               sc_intrstatus; /* HAL_STATUS */
 	enum ath9k_opmode         sc_opmode;  /* current operating mode */
 
 	/* Properties, Config */
-	u_int8_t                sc_invalid;	/* being detached */
-	u_int8_t                sc_beacons;	/* beacons running */
-	u_int8_t                sc_scanning;	/* scanning active */
-	u_int8_t                sc_txaggr;	/* enable 11n tx aggregation */
-	u_int8_t                sc_rxaggr;	/* enable 11n rx aggregation */
-	u_int8_t                sc_update_chainmask;	/* change chain mask */
-	u_int8_t                sc_full_reset;		/* force full reset */
+	u8                sc_invalid;	/* being detached */
+	u8                sc_beacons;	/* beacons running */
+	u8                sc_scanning;	/* scanning active */
+	u8                sc_txaggr;	/* enable 11n tx aggregation */
+	u8                sc_rxaggr;	/* enable 11n rx aggregation */
+	u8                sc_update_chainmask;	/* change chain mask */
+	u8                sc_full_reset;		/* force full reset */
 	enum wireless_mode      sc_curmode;     /* current phy mode */
-	u_int16_t               sc_curtxpow;    /* current tx power limit */
-	u_int16_t               sc_curaid;      /* current association id */
-	u_int8_t                sc_curbssid[ETH_ALEN];
-	u_int8_t                sc_myaddr[ETH_ALEN];
+	u16               sc_curtxpow;    /* current tx power limit */
+	u16               sc_curaid;      /* current association id */
+	u8                sc_curbssid[ETH_ALEN];
+	u8                sc_myaddr[ETH_ALEN];
 	enum PROT_MODE          sc_protmode;    /* protection mode */
-	u_int8_t                sc_mcastantenna;/* Multicast antenna number */
-	u_int8_t                sc_txantenna;   /* data tx antenna
+	u8                sc_mcastantenna;/* Multicast antenna number */
+	u8                sc_txantenna;   /* data tx antenna
 						(fixed or auto) */
-	u_int8_t                sc_nbcnvaps;    /* # of vaps sending beacons */
-	u_int16_t               sc_nvaps;       /* # of active virtual ap's */
+	u8                sc_nbcnvaps;    /* # of vaps sending beacons */
+	u16               sc_nvaps;       /* # of active virtual ap's */
 	struct ath_vap          *sc_vaps[ATH_BCBUF]; /* interface id
 						to avp map */
 	enum ath9k_int            sc_imask;       /* interrupt mask copy */
-	u_int8_t                sc_bssidmask[ETH_ALEN];
-	u_int8_t                sc_defant;      /* current default antenna */
-	u_int8_t                sc_rxotherant;  /* rx's on non-default antenna*/
-	u_int16_t               sc_cachelsz;    /* cache line size */
+	u8                sc_bssidmask[ETH_ALEN];
+	u8                sc_defant;      /* current default antenna */
+	u8                sc_rxotherant;  /* rx's on non-default antenna*/
+	u16               sc_cachelsz;    /* cache line size */
 	int                     sc_slotupdate;  /* slot to next advance fsm */
 	int                     sc_slottime;    /* slot time */
-	u_int8_t                sc_noreset;
+	u8                sc_noreset;
 	int                     sc_bslot[ATH_BCBUF];/* beacon xmit slots */
 	struct ath9k_node_stats   sc_halstats;    /* station-mode rssi stats */
 	struct list_head        node_list;
 	struct ath_ht_info      sc_ht_info;
 	int16_t                 sc_noise_floor; /* signal noise floor in dBm */
 	enum ath9k_ht_extprotspacing   sc_ht_extprotspacing;
-	u_int8_t                sc_tx_chainmask;
-	u_int8_t                sc_rx_chainmask;
-	u_int8_t                sc_rxchaindetect_ref;
-	u_int8_t                sc_rxchaindetect_thresh5GHz;
-	u_int8_t                sc_rxchaindetect_thresh2GHz;
-	u_int8_t                sc_rxchaindetect_delta5GHz;
-	u_int8_t                sc_rxchaindetect_delta2GHz;
-	u_int32_t               sc_rtsaggrlimit; /* Chipset specific
+	u8                sc_tx_chainmask;
+	u8                sc_rx_chainmask;
+	u8                sc_rxchaindetect_ref;
+	u8                sc_rxchaindetect_thresh5GHz;
+	u8                sc_rxchaindetect_thresh2GHz;
+	u8                sc_rxchaindetect_delta5GHz;
+	u8                sc_rxchaindetect_delta2GHz;
+	u32               sc_rtsaggrlimit; /* Chipset specific
 						aggr limit */
 	u32                     sc_flags;
 #ifdef CONFIG_SLOW_ANT_DIV
@@ -991,28 +991,28 @@ struct ath_softc {
 	} sc_updateslot;            /* slot time update fsm */
 
 	/* Crypto */
-	u_int                   sc_keymax;      /* size of key cache */
+	u32                   sc_keymax;      /* size of key cache */
 	DECLARE_BITMAP		(sc_keymap, ATH_KEYMAX);/* key use bit map */
-	u_int8_t		sc_splitmic;	/* split TKIP MIC keys */
+	u8		sc_splitmic;	/* split TKIP MIC keys */
 	int                     sc_keytype;     /* type of the key being used */
 
 	/* RX */
 	struct list_head	sc_rxbuf;       /* receive buffer */
 	struct ath_descdma      sc_rxdma;       /* RX descriptors */
 	int                     sc_rxbufsize;   /* rx size based on mtu */
-	u_int32_t               *sc_rxlink;     /* link ptr in last RX desc */
-	u_int32_t               sc_rxflush;     /* rx flush in progress */
-	u_int64_t               sc_lastrx;      /* tsf of last rx'd frame */
+	u32               *sc_rxlink;     /* link ptr in last RX desc */
+	u32               sc_rxflush;     /* rx flush in progress */
+	u64               sc_lastrx;      /* tsf of last rx'd frame */
 
 	/* TX */
 	struct list_head	sc_txbuf;       /* transmit buffer */
 	struct ath_txq          sc_txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma      sc_txdma;       /* TX descriptors */
-	u_int                   sc_txqsetup;    /* h/w queues setup */
-	u_int                   sc_txintrperiod;/* tx interrupt batching */
+	u32                   sc_txqsetup;    /* h/w queues setup */
+	u32                   sc_txintrperiod;/* tx interrupt batching */
 	int                     sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME
 							AC -> h/w qnum */
-	u_int32_t               sc_ant_tx[8];   /* recent tx frames/antenna */
+	u32               sc_ant_tx[8];   /* recent tx frames/antenna */
 
 	/* Beacon */
 	struct ath9k_txq_info     sc_beacon_qi;   /* adhoc only: beacon
@@ -1020,21 +1020,21 @@ struct ath_softc {
 	struct ath_descdma      sc_bdma;        /* beacon descriptors */
 	struct ath_txq          *sc_cabq;       /* tx q for cab frames */
 	struct list_head	sc_bbuf;	/* beacon buffers */
-	u_int                   sc_bhalq;       /* HAL q for outgoing beacons */
-	u_int                   sc_bmisscount;  /* missed beacon transmits */
-	u_int32_t               ast_be_xmit; /* beacons transmitted */
+	u32                   sc_bhalq;       /* HAL q for outgoing beacons */
+	u32                   sc_bmisscount;  /* missed beacon transmits */
+	u32               ast_be_xmit; /* beacons transmitted */
 
 	/* Rate */
 	struct ieee80211_rate          rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	const struct ath9k_rate_table    *sc_rates[WIRELESS_MODE_MAX];
 	const struct ath9k_rate_table    *sc_currates; /* current rate table */
-	u_int8_t                       sc_rixmap[256]; /* IEEE to h/w
+	u8                       sc_rixmap[256]; /* IEEE to h/w
 						rate table ix */
-	u_int8_t                       sc_minrateix;   /* min h/w rate index */
-	u_int8_t                       sc_protrix; /* protection rate index */
+	u8                       sc_minrateix;   /* min h/w rate index */
+	u8                       sc_protrix; /* protection rate index */
 	struct {
-		u_int32_t rateKbps;      /* transfer rate in kbs */
-		u_int8_t ieeerate;       /* IEEE rate */
+		u32 rateKbps;      /* transfer rate in kbs */
+		u8 ieeerate;       /* IEEE rate */
 	} sc_hwmap[256];         /* h/w rate ix mappings */
 
 	/* Channel, Band */
@@ -1050,7 +1050,7 @@ struct ath_softc {
 	spinlock_t              node_lock;
 };
 
-int ath_init(u_int16_t devid, struct ath_softc *sc);
+int ath_init(u16 devid, struct ath_softc *sc);
 void ath_deinit(struct ath_softc *sc);
 int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
 int ath_suspend(struct ath_softc *sc);
@@ -1068,21 +1068,21 @@ void ath_setup_rate(struct ath_softc *sc,
 /* Utility Functions */
 /*********************/
 
-void ath_key_reset(struct ath_softc *sc, u_int16_t keyix, int freeslot);
+void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot);
 int ath_keyset(struct ath_softc *sc,
-	       u_int16_t keyix,
+	       u16 keyix,
 	       struct ath9k_keyval *hk,
-	       const u_int8_t mac[ETH_ALEN]);
+	       const u8 mac[ETH_ALEN]);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
-int ath_get_mac80211_qnum(u_int queue, struct ath_softc *sc);
+int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 void ath_setslottime(struct ath_softc *sc);
 void ath_update_txpow(struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 void ath_get_currentCountry(struct ath_softc *sc,
 	struct ath9k_country_entry *ctry);
-u_int64_t ath_extend_tsf(struct ath_softc *sc, u_int32_t rstamp);
+u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
 void ath_internal_reset(struct ath_softc *sc);
-u_int32_t ath_chan2flags(struct ieee80211_channel *chan, struct ath_softc *sc);
+u32 ath_chan2flags(struct ieee80211_channel *chan, struct ath_softc *sc);
 dma_addr_t ath_skb_map_single(struct ath_softc *sc,
 			      struct sk_buff *skb,
 			      int direction,
@@ -1091,7 +1091,7 @@ void ath_skb_unmap_single(struct ath_softc *sc,
 			  struct sk_buff *skb,
 			  int direction,
 			  dma_addr_t *pa);
-void ath_mcast_merge(struct ath_softc *sc, u_int32_t mfilt[2]);
+void ath_mcast_merge(struct ath_softc *sc, u32 mfilt[2]);
 enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4e249a4..78c0495 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -23,15 +23,15 @@
 #include "initvals.h"
 
 static void ath9k_hw_iqcal_collect(struct ath_hal *ah);
-static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains);
+static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u8 numChains);
 static void ath9k_hw_adc_gaincal_collect(struct ath_hal *ah);
 static void ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah,
-					   u_int8_t numChains);
+					   u8 numChains);
 static void ath9k_hw_adc_dccal_collect(struct ath_hal *ah);
 static void ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah,
-					 u_int8_t numChains);
+					 u8 numChains);
 
-static const u_int8_t CLOCK_RATE[] = { 40, 80, 22, 44, 88, 40 };
+static const u8 CLOCK_RATE[] = { 40, 80, 22, 44, 88, 40 };
 static const int16_t NOISE_FLOOR[] = { -96, -93, -98, -96, -93, -96 };
 
 static const struct hal_percal_data iq_cal_multi_sample = {
@@ -231,9 +231,9 @@ static enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
 }
 
 static bool ath9k_hw_wait(struct ath_hal *ah,
-			  u_int reg,
-			  u_int32_t mask,
-			  u_int32_t val)
+			  u32 reg,
+			  u32 mask,
+			  u32 val)
 {
 	int i;
 
@@ -249,8 +249,8 @@ static bool ath9k_hw_wait(struct ath_hal *ah,
 	return false;
 }
 
-static bool ath9k_hw_eeprom_read(struct ath_hal *ah, u_int off,
-				 u_int16_t *data)
+static bool ath9k_hw_eeprom_read(struct ath_hal *ah, u32 off,
+				 u16 *data)
 {
 	(void) REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
@@ -282,8 +282,8 @@ static int ath9k_hw_flash_map(struct ath_hal *ah)
 	return 0;
 }
 
-static bool ath9k_hw_flash_read(struct ath_hal *ah, u_int off,
-				u_int16_t *data)
+static bool ath9k_hw_flash_read(struct ath_hal *ah, u32 off,
+				u16 *data)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -293,7 +293,7 @@ static bool ath9k_hw_flash_read(struct ath_hal *ah, u_int off,
 
 static void ath9k_hw_read_revisions(struct ath_hal *ah)
 {
-	u_int32_t val;
+	u32 val;
 
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
 
@@ -318,9 +318,9 @@ static void ath9k_hw_read_revisions(struct ath_hal *ah)
 	}
 }
 
-u_int32_t ath9k_hw_reverse_bits(u_int32_t val, u_int32_t n)
+u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 {
-	u_int32_t retval;
+	u32 retval;
 	int i;
 
 	for (i = 0, retval = 0; i < n; i++) {
@@ -383,7 +383,7 @@ static inline void ath9k_hw_override_ini(struct ath_hal *ah,
 static inline void ath9k_hw_init_bb(struct ath_hal *ah,
 				    struct ath9k_channel *chan)
 {
-	u_int32_t synthDelay;
+	u32 synthDelay;
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
 	if (IS_CHAN_CCK(chan))
@@ -445,12 +445,12 @@ static inline void ath9k_hw_init_qos(struct ath_hal *ah)
 }
 
 static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
-				      u_int reg,
-				      u_int32_t mask,
-				      u_int32_t shift,
-				      u_int32_t val)
+				      u32 reg,
+				      u32 mask,
+				      u32 shift,
+				      u32 val)
 {
-	u_int32_t regVal;
+	u32 regVal;
 
 	regVal = REG_READ(ah, reg) & ~mask;
 	regVal |= (val << shift) & mask;
@@ -463,14 +463,14 @@ static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
 	return;
 }
 
-static u_int8_t ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
+static u8 ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
 					    enum hal_freq_band freq_band)
 {
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[HAL_FREQ_BAND_2GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
-	u_int8_t num_ant_config;
+	u8 num_ant_config;
 
 	num_ant_config = 1;
 
@@ -484,8 +484,8 @@ static u_int8_t ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
 static int
 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 				struct ath9k_channel *chan,
-				u_int8_t index,
-				u_int16_t *config)
+				u8 index,
+				u16 *config)
 {
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
 	struct modal_eep_header *pModal =
@@ -513,8 +513,8 @@ ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 }
 
 static inline bool ath9k_hw_nvram_read(struct ath_hal *ah,
-				       u_int off,
-				       u_int16_t *data)
+				       u32 off,
+				       u16 *data)
 {
 	if (ath9k_hw_use_flash(ah))
 		return ath9k_hw_flash_read(ah, off, data);
@@ -526,7 +526,7 @@ static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
-	u_int16_t *eep_data;
+	u16 *eep_data;
 	int addr, ar5416_eep_start_loc = 0;
 
 	if (!ath9k_hw_use_flash(ah)) {
@@ -537,9 +537,9 @@ static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 	if (AR_SREV_9100(ah))
 		ar5416_eep_start_loc = 256;
 
-	eep_data = (u_int16_t *) eep;
+	eep_data = (u16 *) eep;
 	for (addr = 0;
-	     addr < sizeof(struct ar5416_eeprom) / sizeof(u_int16_t);
+	     addr < sizeof(struct ar5416_eeprom) / sizeof(u16);
 	     addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
@@ -562,8 +562,8 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 	int i, regChainOffset;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
-	u_int8_t txRxAttenLocal;
-	u_int16_t ant_config;
+	u8 txRxAttenLocal;
+	u16 ant_config;
 
 	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
@@ -791,8 +791,8 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 
 static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 {
-	u_int32_t sum = 0, el;
-	u_int16_t *eepdata;
+	u32 sum = 0, el;
+	u16 *eepdata;
 	int i;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	bool need_swap = false;
@@ -800,7 +800,7 @@ static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 		(struct ar5416_eeprom *) &ahp->ah_eeprom;
 
 	if (!ath9k_hw_use_flash(ah)) {
-		u_int16_t magic, magic2;
+		u16 magic, magic2;
 		int addr;
 
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
@@ -817,13 +817,13 @@ static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
 				need_swap = true;
-				eepdata = (u_int16_t *) (&ahp->ah_eeprom);
+				eepdata = (u16 *) (&ahp->ah_eeprom);
 
 				for (addr = 0;
 				     addr <
 					     sizeof(struct ar5416_eeprom) /
-					     sizeof(u_int16_t); addr++) {
-					u_int16_t temp;
+					     sizeof(u16); addr++) {
+					u16 temp;
 
 					temp = swab16(*eepdata);
 					*eepdata = temp;
@@ -853,18 +853,18 @@ static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 		el = ahp->ah_eeprom.baseEepHeader.length;
 
 	if (el > sizeof(struct ar5416_eeprom))
-		el = sizeof(struct ar5416_eeprom) / sizeof(u_int16_t);
+		el = sizeof(struct ar5416_eeprom) / sizeof(u16);
 	else
-		el = el / sizeof(u_int16_t);
+		el = el / sizeof(u16);
 
-	eepdata = (u_int16_t *) (&ahp->ah_eeprom);
+	eepdata = (u16 *) (&ahp->ah_eeprom);
 
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
 
 	if (need_swap) {
-		u_int32_t integer, j;
-		u_int16_t word;
+		u32 integer, j;
+		u16 word;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "EEPROM Endianness is not native.. Changing \n");
@@ -924,17 +924,17 @@ static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 
 static bool ath9k_hw_chip_test(struct ath_hal *ah)
 {
-	u_int32_t regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
-	u_int32_t regHold[2];
-	u_int32_t patternData[4] = { 0x55555555,
+	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
+	u32 regHold[2];
+	u32 patternData[4] = { 0x55555555,
 				     0xaaaaaaaa,
 				     0x66666666,
 				     0x99999999 };
 	int i, j;
 
 	for (i = 0; i < 2; i++) {
-		u_int32_t addr = regAddr[i];
-		u_int32_t wrData, rdData;
+		u32 addr = regAddr[i];
+		u32 wrData, rdData;
 
 		regHold[i] = REG_READ(ah, addr);
 		for (j = 0; j < 0x100; j++) {
@@ -967,10 +967,10 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 	return true;
 }
 
-u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah)
+u32 ath9k_hw_getrxfilter(struct ath_hal *ah)
 {
-	u_int32_t bits = REG_READ(ah, AR_RX_FILTER);
-	u_int32_t phybits = REG_READ(ah, AR_PHY_ERR);
+	u32 bits = REG_READ(ah, AR_RX_FILTER);
+	u32 phybits = REG_READ(ah, AR_PHY_ERR);
 
 	if (phybits & AR_PHY_ERR_RADAR)
 		bits |= ATH9K_RX_FILTER_PHYRADAR;
@@ -979,9 +979,9 @@ u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah)
 	return bits;
 }
 
-void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits)
+void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits)
 {
-	u_int32_t phybits;
+	u32 phybits;
 
 	REG_WRITE(ah, AR_RX_FILTER, (bits & 0xffff) | AR_RX_COMPR_BAR);
 	phybits = 0;
@@ -1001,12 +1001,12 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits)
 
 bool ath9k_hw_setcapability(struct ath_hal *ah,
 			    enum hal_capability_type type,
-			    u_int32_t capability,
-			    u_int32_t setting,
+			    u32 capability,
+			    u32 setting,
 			    int *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t v;
+	u32 v;
 
 	switch (type) {
 	case HAL_CAP_TKIP_MIC:
@@ -1044,9 +1044,9 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 
 void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 {
-	u_int32_t val[ATH9K_NUM_DMA_DEBUG_REGS];
+	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
 	int qcuOffset = 0, dcuOffset = 0;
-	u_int32_t *qcuBase = &val[0], *dcuBase = &val[4];
+	u32 *qcuBase = &val[0], *dcuBase = &val[4];
 	int i;
 
 	REG_WRITE(ah, AR_MACMISC,
@@ -1059,7 +1059,7 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 		if (i % 4 == 0)
 			DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "\n");
 
-		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u_int32_t)));
+		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u32)));
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO, "%d: %08x ", i, val[i]);
 	}
 
@@ -1114,18 +1114,18 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah)
 		"AR_CR 0x%x \n", REG_READ(ah, AR_CR));
 }
 
-u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
-					u_int32_t *rxc_pcnt,
-					u_int32_t *rxf_pcnt,
-					u_int32_t *txf_pcnt)
+u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
+					u32 *rxc_pcnt,
+					u32 *rxf_pcnt,
+					u32 *txf_pcnt)
 {
-	static u_int32_t cycles, rx_clear, rx_frame, tx_frame;
-	u_int32_t good = 1;
+	static u32 cycles, rx_clear, rx_frame, tx_frame;
+	u32 good = 1;
 
-	u_int32_t rc = REG_READ(ah, AR_RCCNT);
-	u_int32_t rf = REG_READ(ah, AR_RFCNT);
-	u_int32_t tf = REG_READ(ah, AR_TFCNT);
-	u_int32_t cc = REG_READ(ah, AR_CCCNT);
+	u32 rc = REG_READ(ah, AR_RCCNT);
+	u32 rf = REG_READ(ah, AR_RFCNT);
+	u32 tf = REG_READ(ah, AR_TFCNT);
+	u32 cc = REG_READ(ah, AR_CCCNT);
 
 	if (cycles == 0 || cycles > cc) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
@@ -1133,10 +1133,10 @@ u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 			 __func__);
 		good = 0;
 	} else {
-		u_int32_t cc_d = cc - cycles;
-		u_int32_t rc_d = rc - rx_clear;
-		u_int32_t rf_d = rf - rx_frame;
-		u_int32_t tf_d = tf - tx_frame;
+		u32 cc_d = cc - cycles;
+		u32 rc_d = rc - rx_clear;
+		u32 rf_d = rf - rx_frame;
+		u32 tf_d = tf - tx_frame;
 
 		if (cc_d != 0) {
 			*rxc_pcnt = rc_d * 100 / cc_d;
@@ -1157,7 +1157,7 @@ u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 
 void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
 {
-	u_int32_t macmode;
+	u32 macmode;
 
 	if (mode == ATH9K_HT_MACMODE_2040 &&
 	    !ah->ah_config.ath_hal_cwmIgnoreExtCCA)
@@ -1174,12 +1174,12 @@ static void ath9k_hw_mark_phy_inactive(struct ath_hal *ah)
 }
 
 
-static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
+static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 					      struct ath_softc *sc,
 					      void __iomem *mem,
 					      int *status)
 {
-	static const u_int8_t defbssidmask[ETH_ALEN] =
+	static const u8 defbssidmask[ETH_ALEN] =
 		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	struct ath_hal_5416 *ahp;
 	struct ath_hal *ah;
@@ -1220,10 +1220,10 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 	ahp->ah_staId1Defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
 	ahp->ah_beaconInterval = 100;
 	ahp->ah_enable32kHzClock = DONT_USE_32KHZ;
-	ahp->ah_slottime = (u_int) -1;
-	ahp->ah_acktimeout = (u_int) -1;
-	ahp->ah_ctstimeout = (u_int) -1;
-	ahp->ah_globaltxtimeout = (u_int) -1;
+	ahp->ah_slottime = (u32) -1;
+	ahp->ah_acktimeout = (u32) -1;
+	ahp->ah_ctstimeout = (u32) -1;
+	ahp->ah_globaltxtimeout = (u32) -1;
 	memcpy(&ahp->ah_bssidmask, defbssidmask, ETH_ALEN);
 
 	ahp->ah_gBeaconRate = 0;
@@ -1246,7 +1246,7 @@ static int ath9k_hw_eeprom_attach(struct ath_hal *ah)
 	return status;
 }
 
-u_int32_t ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
+u32 ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
 			      enum eeprom_param param)
 {
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
@@ -1295,7 +1295,7 @@ u_int32_t ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
 
 static inline int ath9k_hw_get_radiorev(struct ath_hal *ah)
 {
-	u_int32_t val;
+	u32 val;
 	int i;
 
 	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
@@ -1308,9 +1308,9 @@ static inline int ath9k_hw_get_radiorev(struct ath_hal *ah)
 
 static inline int ath9k_hw_init_macaddr(struct ath_hal *ah)
 {
-	u_int32_t sum;
+	u32 sum;
 	int i;
-	u_int16_t eeval;
+	u16 eeval;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	DECLARE_MAC_BUF(mac);
 
@@ -1331,9 +1331,9 @@ static inline int ath9k_hw_init_macaddr(struct ath_hal *ah)
 	return 0;
 }
 
-static inline int16_t ath9k_hw_interpolate(u_int16_t target,
-					   u_int16_t srcLeft,
-					   u_int16_t srcRight,
+static inline int16_t ath9k_hw_interpolate(u16 target,
+					   u16 srcLeft,
+					   u16 srcRight,
 					   int16_t targetLeft,
 					   int16_t targetRight)
 {
@@ -1349,24 +1349,24 @@ static inline int16_t ath9k_hw_interpolate(u_int16_t target,
 	return rv;
 }
 
-static inline u_int16_t ath9k_hw_fbin2freq(u_int8_t fbin,
+static inline u16 ath9k_hw_fbin2freq(u8 fbin,
 					   bool is2GHz)
 {
 
 	if (fbin == AR5416_BCHAN_UNUSED)
 		return fbin;
 
-	return (u_int16_t) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
+	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
 }
 
-static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
-					       u_int16_t i,
+static u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
+					       u16 i,
 					       bool is2GHz)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep =
 		(struct ar5416_eeprom *) &ahp->ah_eeprom;
-	u_int16_t spur_val = AR_NO_SPUR;
+	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		 "Getting spur idx %d is2Ghz. %d val %x\n",
@@ -1406,7 +1406,7 @@ static inline int ath9k_hw_rfattach(struct ath_hal *ah)
 
 static int ath9k_hw_rf_claim(struct ath_hal *ah)
 {
-	u_int32_t val;
+	u32 val;
 
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
 
@@ -1436,7 +1436,7 @@ static int ath9k_hw_rf_claim(struct ath_hal *ah)
 static inline void ath9k_hw_init_pll(struct ath_hal *ah,
 				     struct ath9k_channel *chan)
 {
-	u_int32_t pll;
+	u32 pll;
 
 	if (AR_SREV_9100(ah)) {
 		if (chan && IS_CHAN_5GHZ(chan))
@@ -1494,7 +1494,7 @@ static inline void ath9k_hw_init_pll(struct ath_hal *ah,
 				pll |= SM(0xb, AR_RTC_PLL_DIV);
 		}
 	}
-	REG_WRITE(ah, (u_int16_t) (AR_RTC_PLL_CONTROL), pll);
+	REG_WRITE(ah, (u16) (AR_RTC_PLL_CONTROL), pll);
 
 	udelay(RTC_PLL_SETTLE_DELAY);
 
@@ -1504,7 +1504,7 @@ static inline void ath9k_hw_init_pll(struct ath_hal *ah,
 static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode)
 {
-	u_int32_t phymode;
+	u32 phymode;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
@@ -1530,7 +1530,7 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 
 static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 {
-	u_int32_t val;
+	u32 val;
 
 	val = REG_READ(ah, AR_STA_ID1);
 	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
@@ -1555,7 +1555,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 static inline void
 ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
 {
-	u_int32_t rfMode = 0;
+	u32 rfMode = 0;
 
 	if (chan == NULL)
 		return;
@@ -1575,8 +1575,8 @@ ath9k_hw_set_rfmode(struct ath_hal *ah, struct ath9k_channel *chan)
 
 static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 {
-	u_int32_t rst_flags;
-	u_int32_t tmpReg;
+	u32 rst_flags;
+	u32 tmpReg;
 
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
@@ -1600,11 +1600,11 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 			rst_flags |= AR_RTC_RC_MAC_COLD;
 	}
 
-	REG_WRITE(ah, (u_int16_t) (AR_RTC_RC), rst_flags);
+	REG_WRITE(ah, (u16) (AR_RTC_RC), rst_flags);
 	udelay(50);
 
-	REG_WRITE(ah, (u_int16_t) (AR_RTC_RC), 0);
-	if (!ath9k_hw_wait(ah, (u_int16_t) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
+	REG_WRITE(ah, (u16) (AR_RTC_RC), 0);
+	if (!ath9k_hw_wait(ah, (u16) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"%s: RTC stuck in MAC reset\n",
 			__func__);
@@ -1627,8 +1627,8 @@ static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
-	REG_WRITE(ah, (u_int16_t) (AR_RTC_RESET), 0);
-	REG_WRITE(ah, (u_int16_t) (AR_RTC_RESET), 1);
+	REG_WRITE(ah, (u16) (AR_RTC_RESET), 0);
+	REG_WRITE(ah, (u16) (AR_RTC_RESET), 1);
 
 	if (!ath9k_hw_wait(ah,
 			   AR_RTC_STATUS,
@@ -1645,7 +1645,7 @@ static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 }
 
 static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
-				   u_int32_t type)
+				   u32 type)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
@@ -1690,20 +1690,20 @@ struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
 }
 
 static inline bool
-ath9k_hw_get_lower_upper_index(u_int8_t target,
-			       u_int8_t *pList,
-			       u_int16_t listSize,
-			       u_int16_t *indexL,
-			       u_int16_t *indexR)
+ath9k_hw_get_lower_upper_index(u8 target,
+			       u8 *pList,
+			       u16 listSize,
+			       u16 *indexL,
+			       u16 *indexR)
 {
-	u_int16_t i;
+	u16 i;
 
 	if (target <= pList[0]) {
 		*indexL = *indexR = 0;
 		return true;
 	}
 	if (target >= pList[listSize - 1]) {
-		*indexL = *indexR = (u_int16_t) (listSize - 1);
+		*indexL = *indexR = (u16) (listSize - 1);
 		return true;
 	}
 
@@ -1714,7 +1714,7 @@ ath9k_hw_get_lower_upper_index(u_int8_t target,
 		}
 		if (target < pList[i + 1]) {
 			*indexL = i;
-			*indexR = (u_int16_t) (i + 1);
+			*indexR = (u16) (i + 1);
 			return false;
 		}
 	}
@@ -1892,7 +1892,7 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 	struct ath9k_nfcal_hist *h;
 	int i, j;
 	int32_t val;
-	const u_int32_t ar5416_cca_regs[6] = {
+	const u32 ar5416_cca_regs[6] = {
 		AR_PHY_CCA,
 		AR_PHY_CH1_CCA,
 		AR_PHY_CH2_CCA,
@@ -1900,7 +1900,7 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 		AR_PHY_CH1_EXT_CCA,
 		AR_PHY_CH2_EXT_CCA
 	};
-	u_int8_t chainmask;
+	u8 chainmask;
 
 	if (AR_SREV_9280(ah))
 		chainmask = 0x1B;
@@ -1917,7 +1917,7 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 		if (chainmask & (1 << i)) {
 			val = REG_READ(ah, ar5416_cca_regs[i]);
 			val &= 0xFFFFFE00;
-			val |= (((u_int32_t) (h[i].privNF) << 1) & 0x1ff);
+			val |= (((u32) (h[i].privNF) << 1) & 0x1ff);
 			REG_WRITE(ah, ar5416_cca_regs[i], val);
 		}
 	}
@@ -1939,7 +1939,7 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 		if (chainmask & (1 << i)) {
 			val = REG_READ(ah, ar5416_cca_regs[i]);
 			val &= 0xFFFFFE00;
-			val |= (((u_int32_t) (-50) << 1) & 0x1ff);
+			val |= (((u32) (-50) << 1) & 0x1ff);
 			REG_WRITE(ah, ar5416_cca_regs[i], val);
 		}
 	}
@@ -1951,7 +1951,7 @@ static int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
 	struct ath9k_nfcal_hist *h;
-	u_int8_t chainmask;
+	u8 chainmask;
 
 	if (AR_SREV_9280(ah))
 		chainmask = 0x1B;
@@ -2136,7 +2136,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 
 	switch (cmd & ahp->ah_ani_function) {
 	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
-		u_int level = param;
+		u32 level = param;
 
 		if (level >= ARRAY_SIZE(ahp->ah_totalSizeDesired)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2174,7 +2174,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		const int m2Thresh[] = { 127, 0x40 };
 		const int m2CountThr[] = { 31, 16 };
 		const int m2CountThrLow[] = { 63, 48 };
-		u_int on = param ? 1 : 0;
+		u32 on = param ? 1 : 0;
 
 		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
 			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
@@ -2226,7 +2226,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 	}
 	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
 		const int weakSigThrCck[] = { 8, 6 };
-		u_int high = param ? 1 : 0;
+		u32 high = param ? 1 : 0;
 
 		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
 			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
@@ -2242,7 +2242,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 	}
 	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		const int firstep[] = { 0, 4, 8 };
-		u_int level = param;
+		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2264,7 +2264,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
 		const int cycpwrThr1[] =
 			{ 2, 4, 6, 8, 10, 12, 14, 16 };
-		u_int level = param;
+		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2551,7 +2551,7 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 			   const struct ath9k_node_stats *stats)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t phyCnt1, phyCnt2;
+	u32 phyCnt1, phyCnt2;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Processing Mib Intr\n");
 
@@ -2571,7 +2571,7 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
 		struct ar5416AniState *aniState = ahp->ah_curani;
-		u_int32_t ofdmPhyErrCnt, cckPhyErrCnt;
+		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
 		ahp->ah_stats.ast_ani_ofdmerrs +=
@@ -2658,7 +2658,7 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState;
-	u_int32_t txFrameCount, rxFrameCount, cycleCount;
+	u32 txFrameCount, rxFrameCount, cycleCount;
 	int32_t listenTime;
 
 	txFrameCount = REG_READ(ah, AR_TFCNT);
@@ -2704,8 +2704,8 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 	aniState->listenTime += listenTime;
 
 	if (ahp->ah_hasHwPhyCounters) {
-		u_int32_t phyCnt1, phyCnt2;
-		u_int32_t ofdmPhyErrCnt, cckPhyErrCnt;
+		u32 phyCnt1, phyCnt2;
+		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
 		ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
 
@@ -2794,10 +2794,10 @@ static void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah)
 #endif
 
 static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
-					 u_int32_t gpio, u_int32_t type)
+					 u32 gpio, u32 type)
 {
 	int addr;
-	u_int32_t gpio_shift, tmp;
+	u32 gpio_shift, tmp;
 
 	if (gpio > 11)
 		addr = AR_GPIO_OUTPUT_MUX3;
@@ -2821,14 +2821,14 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 	}
 }
 
-static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
+static bool ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 				enum ath9k_gpio_output_mux_type
 				halSignalType)
 {
-	u_int32_t ah_signal_type;
-	u_int32_t gpio_shift;
+	u32 ah_signal_type;
+	u32 gpio_shift;
 
-	static u_int32_t MuxSignalConversionTable[] = {
+	static u32 MuxSignalConversionTable[] = {
 
 		AR_GPIO_OUTPUT_MUX_AS_OUTPUT,
 
@@ -2859,15 +2859,15 @@ static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
 	return true;
 }
 
-static bool ath9k_hw_set_gpio(struct ath_hal *ah, u_int32_t gpio,
-			      u_int32_t val)
+static bool ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio,
+			      u32 val)
 {
 	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
 		AR_GPIO_BIT(gpio));
 	return true;
 }
 
-static u_int32_t ath9k_hw_gpio_get(struct ath_hal *ah, u_int32_t gpio)
+static u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
 {
 	if (gpio >= ah->ah_caps.halNumGpioPins)
 		return 0xffffffff;
@@ -2910,9 +2910,9 @@ static inline int ath9k_hw_post_attach(struct ath_hal *ah)
 	return 0;
 }
 
-static u_int32_t ath9k_hw_ini_fixup(struct ath_hal *ah,
+static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
 				    struct ar5416_eeprom *pEepData,
-				    u_int32_t reg, u_int32_t value)
+				    u32 reg, u32 value)
 {
 	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
 
@@ -2947,7 +2947,7 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
-	u_int16_t capField = 0, eeval;
+	u16 capField = 0, eeval;
 
 	eeval = ath9k_hw_get_eeprom(ahp, EEP_REG_0);
 
@@ -3141,7 +3141,7 @@ static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		REG_CLR_BIT(ah, (u_int16_t) (AR_RTC_RESET),
+		REG_CLR_BIT(ah, (u16) (AR_RTC_RESET),
 			    AR_RTC_RESET_EN);
 	}
 }
@@ -3165,7 +3165,7 @@ static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 				     int setChip)
 {
-	u_int32_t val;
+	u32 val;
 	int i;
 
 	if (setChip) {
@@ -3240,7 +3240,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	return status;
 }
 
-static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
+static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 					  struct ath_softc *sc,
 					  void __iomem *mem,
 					  int *status)
@@ -3249,8 +3249,8 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	struct ath_hal *ah;
 	int ecode;
 #ifndef CONFIG_SLOW_ANT_DIV
-	u_int32_t i;
-	u_int32_t j;
+	u32 i;
+	u32 j;
 #endif
 
 	ahp = ath9k_hw_newstate(devid, sc, mem, status);
@@ -3465,10 +3465,10 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 #ifndef CONFIG_SLOW_ANT_DIV
 	if (ah->ah_devid == AR9280_DEVID_PCI) {
 		for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
-			u_int32_t reg = INI_RA(&ahp->ah_iniModes, i, 0);
+			u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
 
 			for (j = 1; j < ahp->ah_iniModes.ia_columns; j++) {
-				u_int32_t val = INI_RA(&ahp->ah_iniModes, i, j);
+				u32 val = INI_RA(&ahp->ah_iniModes, i, j);
 
 				INI_RA(&ahp->ah_iniModes, i, j) =
 					ath9k_hw_ini_fixup(ah, &ahp->ah_eeprom,
@@ -3524,8 +3524,8 @@ void ath9k_hw_detach(struct ath_hal *ah)
 }
 
 bool ath9k_get_channel_edges(struct ath_hal *ah,
-			     u_int16_t flags, u_int16_t *low,
-			     u_int16_t *high)
+			     u16 flags, u16 *low,
+			     u16 *high)
 {
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
@@ -3543,17 +3543,17 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 	return false;
 }
 
-static inline bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
-					   u_int8_t pwrMax,
-					   u_int8_t *pPwrList,
-					   u_int8_t *pVpdList,
-					   u_int16_t
+static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin,
+					   u8 pwrMax,
+					   u8 *pPwrList,
+					   u8 *pVpdList,
+					   u16
 					   numIntercepts,
-					   u_int8_t *pRetVpdList)
+					   u8 *pRetVpdList)
 {
-	u_int16_t i, k;
-	u_int8_t currPwr = pwrMin;
-	u_int16_t idxL = 0, idxR = 0;
+	u16 i, k;
+	u8 currPwr = pwrMin;
+	u16 idxL = 0, idxR = 0;
 
 	for (i = 0; i <= (pwrMax - pwrMin) / 2; i++) {
 		ath9k_hw_get_lower_upper_index(currPwr, pPwrList,
@@ -3562,18 +3562,18 @@ static inline bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
 		if (idxR < 1)
 			idxR = 1;
 		if (idxL == numIntercepts - 1)
-			idxL = (u_int16_t) (numIntercepts - 2);
+			idxL = (u16) (numIntercepts - 2);
 		if (pPwrList[idxL] == pPwrList[idxR])
 			k = pVpdList[idxL];
 		else
-			k = (u_int16_t) (((currPwr -
+			k = (u16) (((currPwr -
 					   pPwrList[idxL]) *
 					  pVpdList[idxR] +
 					  (pPwrList[idxR] -
 					   currPwr) * pVpdList[idxL]) /
 					 (pPwrList[idxR] -
 					  pPwrList[idxL]));
-		pRetVpdList[i] = (u_int8_t) k;
+		pRetVpdList[i] = (u8) k;
 		currPwr += 2;
 	}
 
@@ -3584,30 +3584,30 @@ static inline void
 ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 				    struct ath9k_channel *chan,
 				    struct cal_data_per_freq *pRawDataSet,
-				    u_int8_t *bChans,
-				    u_int16_t availPiers,
-				    u_int16_t tPdGainOverlap,
+				    u8 *bChans,
+				    u16 availPiers,
+				    u16 tPdGainOverlap,
 				    int16_t *pMinCalPower,
-				    u_int16_t *pPdGainBoundaries,
-				    u_int8_t *pPDADCValues,
-				    u_int16_t numXpdGains)
+				    u16 *pPdGainBoundaries,
+				    u8 *pPDADCValues,
+				    u16 numXpdGains)
 {
 	int i, j, k;
 	int16_t ss;
-	u_int16_t idxL = 0, idxR = 0, numPiers;
-	static u_int8_t vpdTableL[AR5416_NUM_PD_GAINS]
+	u16 idxL = 0, idxR = 0, numPiers;
+	static u8 vpdTableL[AR5416_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u_int8_t vpdTableR[AR5416_NUM_PD_GAINS]
+	static u8 vpdTableR[AR5416_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u_int8_t vpdTableI[AR5416_NUM_PD_GAINS]
+	static u8 vpdTableI[AR5416_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
-	u_int8_t *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u_int8_t minPwrT4[AR5416_NUM_PD_GAINS];
-	u_int8_t maxPwrT4[AR5416_NUM_PD_GAINS];
+	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
 	int16_t vpdStep;
 	int16_t tmpVal;
-	u_int16_t sizeCurrVpdTable, maxIndex, tgtIndex;
+	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
 	bool match;
 	int16_t minDelta = 0;
 	struct chan_centers centers;
@@ -3619,7 +3619,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 			break;
 	}
 
-	match = ath9k_hw_get_lower_upper_index((u_int8_t)
+	match = ath9k_hw_get_lower_upper_index((u8)
 					       FREQ2FBIN(centers.
 							 synth_center,
 							 IS_CHAN_2GHZ
@@ -3663,8 +3663,8 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 
 			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
 				vpdTableI[i][j] =
-					(u_int8_t) (ath9k_hw_interpolate
-						    ((u_int16_t)
+					(u8) (ath9k_hw_interpolate
+						    ((u16)
 						     FREQ2FBIN(centers.
 							       synth_center,
 							       IS_CHAN_2GHZ
@@ -3683,14 +3683,14 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 	for (i = 0; i < numXpdGains; i++) {
 		if (i == (numXpdGains - 1))
 			pPdGainBoundaries[i] =
-				(u_int16_t) (maxPwrT4[i] / 2);
+				(u16) (maxPwrT4[i] / 2);
 		else
 			pPdGainBoundaries[i] =
-				(u_int16_t) ((maxPwrT4[i] +
+				(u16) ((maxPwrT4[i] +
 					      minPwrT4[i + 1]) / 4);
 
 		pPdGainBoundaries[i] =
-			min((u_int16_t) AR5416_MAX_RATE_POWER,
+			min((u16) AR5416_MAX_RATE_POWER,
 			    pPdGainBoundaries[i]);
 
 		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
@@ -3716,13 +3716,13 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
 			tmpVal = (int16_t) (vpdTableI[i][0] + ss * vpdStep);
 			pPDADCValues[k++] =
-				(u_int8_t) ((tmpVal < 0) ? 0 : tmpVal);
+				(u8) ((tmpVal < 0) ? 0 : tmpVal);
 			ss++;
 		}
 
 		sizeCurrVpdTable =
-			(u_int8_t) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
-		tgtIndex = (u_int8_t) (pPdGainBoundaries[i] + tPdGainOverlap -
+			(u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
+		tgtIndex = (u8) (pPdGainBoundaries[i] + tPdGainOverlap -
 				       (minPwrT4[i] / 2));
 		maxIndex = (tgtIndex <
 			    sizeCurrVpdTable) ? tgtIndex : sizeCurrVpdTable;
@@ -3743,7 +3743,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 						     [sizeCurrVpdTable -
 						      1] + (ss - maxIndex +
 							    1) * vpdStep));
-				pPDADCValues[k++] = (u_int8_t) ((tmpVal >
+				pPDADCValues[k++] = (u8) ((tmpVal >
 						 255) ? 255 : tmpVal);
 				ss++;
 			}
@@ -3769,15 +3769,15 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			     int16_t *pTxPowerIndexOffset)
 {
 	struct cal_data_per_freq *pRawDataset;
-	u_int8_t *pCalBChans = NULL;
-	u_int16_t pdGainOverlap_t2;
-	static u_int8_t pdadcValues[AR5416_NUM_PDADC_VALUES];
-	u_int16_t gainBoundaries[AR5416_PD_GAINS_IN_MASK];
-	u_int16_t numPiers, i, j;
+	u8 *pCalBChans = NULL;
+	u16 pdGainOverlap_t2;
+	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
+	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
+	u16 numPiers, i, j;
 	int16_t tMinCalPower;
-	u_int16_t numXpdGain, xpdMask;
-	u_int16_t xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
-	u_int32_t reg32, regOffset, regChainOffset;
+	u16 numXpdGain, xpdMask;
+	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
+	u32 reg32, regOffset, regChainOffset;
 	int16_t modalIdx;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -3791,7 +3791,7 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			pEepData->modalHeader[modalIdx].pdGainOverlap;
 	} else {
 		pdGainOverlap_t2 =
-			(u_int16_t) (MS
+			(u16) (MS
 				     (REG_READ(ah, AR_PHY_TPCRG5),
 				      AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
 	}
@@ -3811,7 +3811,7 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			if (numXpdGain >= AR5416_NUM_PD_GAINS)
 				break;
 			xpdGainValues[numXpdGain] =
-				(u_int16_t) (AR5416_PD_GAINS_IN_MASK - i);
+				(u16) (AR5416_PD_GAINS_IN_MASK - i);
 			numXpdGain++;
 		}
 	}
@@ -3902,7 +3902,7 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int8_t i;
+	u8 i;
 
 	if (ah->ah_isPciExpress != true)
 		return;
@@ -3969,15 +3969,15 @@ static inline void
 ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 				  struct ath9k_channel *chan,
 				  struct cal_target_power_leg *powInfo,
-				  u_int16_t numChannels,
+				  u16 numChannels,
 				  struct cal_target_power_leg *pNewPower,
-				  u_int16_t numRates,
+				  u16 numRates,
 				  bool isExtTarget)
 {
-	u_int16_t clo, chi;
+	u16 clo, chi;
 	int i;
 	int matchIndex = -1, lowIndex = -1;
-	u_int16_t freq;
+	u16 freq;
 	struct chan_centers centers;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
@@ -4020,7 +4020,7 @@ ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 
 		for (i = 0; i < numRates; i++) {
 			pNewPower->tPow2x[i] =
-				(u_int8_t) ath9k_hw_interpolate(freq, clo, chi,
+				(u8) ath9k_hw_interpolate(freq, clo, chi,
 								powInfo
 								[lowIndex].
 								tPow2x[i],
@@ -4035,15 +4035,15 @@ static inline void
 ath9k_hw_get_target_powers(struct ath_hal *ah,
 			   struct ath9k_channel *chan,
 			   struct cal_target_power_ht *powInfo,
-			   u_int16_t numChannels,
+			   u16 numChannels,
 			   struct cal_target_power_ht *pNewPower,
-			   u_int16_t numRates,
+			   u16 numRates,
 			   bool isHt40Target)
 {
-	u_int16_t clo, chi;
+	u16 clo, chi;
 	int i;
 	int matchIndex = -1, lowIndex = -1;
-	u_int16_t freq;
+	u16 freq;
 	struct chan_centers centers;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
@@ -4087,7 +4087,7 @@ ath9k_hw_get_target_powers(struct ath_hal *ah,
 
 		for (i = 0; i < numRates; i++) {
 			pNewPower->tPow2x[i] =
-				(u_int8_t) ath9k_hw_interpolate(freq, clo, chi,
+				(u8) ath9k_hw_interpolate(freq, clo, chi,
 								powInfo
 								[lowIndex].
 								tPow2x[i],
@@ -4098,12 +4098,12 @@ ath9k_hw_get_target_powers(struct ath_hal *ah,
 	}
 }
 
-static inline u_int16_t
-ath9k_hw_get_max_edge_power(u_int16_t freq,
+static inline u16
+ath9k_hw_get_max_edge_power(u16 freq,
 			    struct cal_ctl_edges *pRdEdgesPower,
 			    bool is2GHz)
 {
-	u_int16_t twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	int i;
 
 	for (i = 0; (i < AR5416_NUM_BAND_EDGES)
@@ -4133,13 +4133,13 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				  struct ar5416_eeprom *pEepData,
 				  struct ath9k_channel *chan,
 				  int16_t *ratesArray,
-				  u_int16_t cfgCtl,
-				  u_int8_t AntennaReduction,
-				  u_int8_t twiceMaxRegulatoryPower,
-				  u_int8_t powerLimit)
+				  u16 cfgCtl,
+				  u8 AntennaReduction,
+				  u8 twiceMaxRegulatoryPower,
+				  u8 powerLimit)
 {
-	u_int8_t twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u_int16_t tpScaleReductionTable[5] =
+	u8 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 
 	int i;
@@ -4155,17 +4155,17 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
 		0, {0, 0, 0, 0}
 	};
-	u_int8_t scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u_int16_t ctlModesFor11a[] =
+	u8 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 ctlModesFor11a[] =
 		{ CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40 };
-	u_int16_t ctlModesFor11g[] =
+	u16 ctlModesFor11g[] =
 		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
 		  CTL_2GHT40
 		};
-	u_int16_t numCtlModes, *pCtlMode, ctlMode, freq;
+	u16 numCtlModes, *pCtlMode, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
-	u_int8_t twiceMinEdgePower;
+	u8 twiceMinEdgePower;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	tx_chainmask = ahp->ah_txchainmask;
@@ -4178,7 +4178,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		pEepData->modalHeader
 			[IS_CHAN_2GHZ(chan)].antennaGainCh[1]);
 
-	twiceLargestAntenna = max((u_int8_t) twiceLargestAntenna,
+	twiceLargestAntenna = max((u8) twiceLargestAntenna,
 		pEepData->modalHeader
 			[IS_CHAN_2GHZ(chan)].antennaGainCh[2]);
 
@@ -4459,16 +4459,16 @@ static int
 ath9k_hw_set_txpower(struct ath_hal *ah,
 		     struct ar5416_eeprom *pEepData,
 		     struct ath9k_channel *chan,
-		     u_int16_t cfgCtl,
-		     u_int8_t twiceAntennaReduction,
-		     u_int8_t twiceMaxRegulatoryPower,
-		     u_int8_t powerLimit)
+		     u16 cfgCtl,
+		     u8 twiceAntennaReduction,
+		     u8 twiceMaxRegulatoryPower,
+		     u8 powerLimit)
 {
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t txPowerIndexOffset = 0;
-	u_int8_t ht40PowerIncForPdadc = 2;
+	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
 	memset(ratesArray, 0, sizeof(ratesArray));
@@ -4601,11 +4601,11 @@ ath9k_hw_set_txpower(struct ath_hal *ah,
 }
 
 static inline void ath9k_hw_get_delta_slope_vals(struct ath_hal *ah,
-						 u_int32_t coef_scaled,
-						 u_int32_t *coef_mantissa,
-						 u_int32_t *coef_exponent)
+						 u32 coef_scaled,
+						 u32 *coef_mantissa,
+						 u32 *coef_exponent)
 {
-	u_int32_t coef_exp, coef_man;
+	u32 coef_exp, coef_man;
 
 	for (coef_exp = 31; coef_exp > 0; coef_exp--)
 		if ((coef_scaled >> coef_exp) & 0x1)
@@ -4623,8 +4623,8 @@ static void
 ath9k_hw_set_delta_slope(struct ath_hal *ah,
 			 struct ath9k_channel *chan)
 {
-	u_int32_t coef_scaled, ds_coef_exp, ds_coef_man;
-	u_int32_t clockMhzScaled = 0x64000000;
+	u32 coef_scaled, ds_coef_exp, ds_coef_man;
+	u32 clockMhzScaled = 0x64000000;
 	struct chan_centers centers;
 
 	if (IS_CHAN_HALF_RATE(chan))
@@ -5145,7 +5145,7 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 	struct modal_eep_header *pModal;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
-	u_int8_t biaslevel;
+	u8 biaslevel;
 
 	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
 		return;
@@ -5159,7 +5159,7 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 		biaslevel = pModal->xpaBiasLvl;
 	} else {
 
-		u_int16_t resetFreqBin, freqBin, freqCount = 0;
+		u16 resetFreqBin, freqBin, freqCount = 0;
 		struct chan_centers centers;
 
 		ath9k_hw_get_channel_centers(ah, chan, &centers);
@@ -5167,7 +5167,7 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 		resetFreqBin =
 			FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan));
 		freqBin = pModal->xpaBiasLvlFreq[0] & 0xff;
-		biaslevel = (u_int8_t) (pModal->xpaBiasLvlFreq[0] >> 14);
+		biaslevel = (u8) (pModal->xpaBiasLvlFreq[0] >> 14);
 
 		freqCount++;
 
@@ -5178,7 +5178,7 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 			freqBin = pModal->xpaBiasLvlFreq[freqCount] & 0xff;
 			if (resetFreqBin >= freqBin) {
 				biaslevel =
-					(u_int8_t) (pModal->
+					(u8) (pModal->
 						    xpaBiasLvlFreq[freqCount]
 						    >> 14);
 			} else {
@@ -5199,7 +5199,7 @@ static void ath9k_hw_set_addac(struct ath_hal *ah,
 	}
 }
 
-static u_int ath9k_hw_mac_usec(struct ath_hal *ah, u_int clks)
+static u32 ath9k_hw_mac_usec(struct ath_hal *ah, u32 clks)
 {
 	if (ah->ah_curchan != NULL)
 		return clks /
@@ -5208,7 +5208,7 @@ static u_int ath9k_hw_mac_usec(struct ath_hal *ah, u_int clks)
 		return clks / CLOCK_RATE[WIRELESS_MODE_11b];
 }
 
-static u_int ath9k_hw_mac_to_usec(struct ath_hal *ah, u_int clks)
+static u32 ath9k_hw_mac_to_usec(struct ath_hal *ah, u32 clks)
 {
 	struct ath9k_channel *chan = ah->ah_curchan;
 
@@ -5218,7 +5218,7 @@ static u_int ath9k_hw_mac_to_usec(struct ath_hal *ah, u_int clks)
 		return ath9k_hw_mac_usec(ah, clks);
 }
 
-static u_int ath9k_hw_mac_clks(struct ath_hal *ah, u_int usecs)
+static u32 ath9k_hw_mac_clks(struct ath_hal *ah, u32 usecs)
 {
 	if (ah->ah_curchan != NULL)
 		return usecs * CLOCK_RATE[ath9k_hw_chan2wmode(ah,
@@ -5227,7 +5227,7 @@ static u_int ath9k_hw_mac_clks(struct ath_hal *ah, u_int usecs)
 		return usecs * CLOCK_RATE[WIRELESS_MODE_11b];
 }
 
-static u_int ath9k_hw_mac_to_clks(struct ath_hal *ah, u_int usecs)
+static u32 ath9k_hw_mac_to_clks(struct ath_hal *ah, u32 usecs)
 {
 	struct ath9k_channel *chan = ah->ah_curchan;
 
@@ -5237,14 +5237,14 @@ static u_int ath9k_hw_mac_to_clks(struct ath_hal *ah, u_int usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
+static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u32 us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad ack timeout %u\n",
 			 __func__, us);
-		ahp->ah_acktimeout = (u_int) -1;
+		ahp->ah_acktimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
@@ -5254,14 +5254,14 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
 	}
 }
 
-static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
+static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u32 us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad cts timeout %u\n",
 			 __func__, us);
-		ahp->ah_ctstimeout = (u_int) -1;
+		ahp->ah_ctstimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_TIME_OUT,
@@ -5271,14 +5271,14 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
 	}
 }
 static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
-					  u_int tu)
+					  u32 tu)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (tu > 0xFFFF) {
 		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
 			"%s: bad global tx timeout %u\n", __func__, tu);
-		ahp->ah_globaltxtimeout = (u_int) -1;
+		ahp->ah_globaltxtimeout = (u32) -1;
 		return false;
 	} else {
 		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
@@ -5287,14 +5287,14 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
 	}
 }
 
-bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
+bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad slot time %u\n",
 			 __func__, us);
-		ahp->ah_slottime = (u_int) -1;
+		ahp->ah_slottime = (u32) -1;
 		return false;
 	} else {
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
@@ -5312,13 +5312,13 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 	if (ahp->ah_miscMode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
 			  REG_READ(ah, AR_PCU_MISC) | ahp->ah_miscMode);
-	if (ahp->ah_slottime != (u_int) -1)
+	if (ahp->ah_slottime != (u32) -1)
 		ath9k_hw_setslottime(ah, ahp->ah_slottime);
-	if (ahp->ah_acktimeout != (u_int) -1)
+	if (ahp->ah_acktimeout != (u32) -1)
 		ath9k_hw_set_ack_timeout(ah, ahp->ah_acktimeout);
-	if (ahp->ah_ctstimeout != (u_int) -1)
+	if (ahp->ah_ctstimeout != (u32) -1)
 		ath9k_hw_set_cts_timeout(ah, ahp->ah_ctstimeout);
-	if (ahp->ah_globaltxtimeout != (u_int) -1)
+	if (ahp->ah_globaltxtimeout != (u32) -1)
 		ath9k_hw_set_global_txtimeout(ah, ahp->ah_globaltxtimeout);
 }
 
@@ -5329,7 +5329,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 {
 	int i, regWrites = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int modesIndex, freqIndex;
+	u32 modesIndex, freqIndex;
 	int status;
 
 	switch (chan->chanmode) {
@@ -5369,8 +5369,8 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		REG_WRITE_ARRAY(&ahp->ah_iniAddac, 1, regWrites);
 	} else {
 		struct ar5416IniArray temp;
-		u_int32_t addacSize =
-			sizeof(u_int32_t) * ahp->ah_iniAddac.ia_rows *
+		u32 addacSize =
+			sizeof(u32) * ahp->ah_iniAddac.ia_rows *
 			ahp->ah_iniAddac.ia_columns;
 
 		memcpy(ahp->ah_addac5416_21,
@@ -5387,8 +5387,8 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
 
 	for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
-		u_int32_t reg = INI_RA(&ahp->ah_iniModes, i, 0);
-		u_int32_t val = INI_RA(&ahp->ah_iniModes, i, modesIndex);
+		u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
+		u32 val = INI_RA(&ahp->ah_iniModes, i, modesIndex);
 
 #ifdef CONFIG_SLOW_ANT_DIV
 		if (ah->ah_devid == AR9280_DEVID_PCI)
@@ -5407,8 +5407,8 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	}
 
 	for (i = 0; i < ahp->ah_iniCommon.ia_rows; i++) {
-		u_int32_t reg = INI_RA(&ahp->ah_iniCommon, i, 0);
-		u_int32_t val = INI_RA(&ahp->ah_iniCommon, i, 1);
+		u32 reg = INI_RA(&ahp->ah_iniCommon, i, 0);
+		u32 val = INI_RA(&ahp->ah_iniCommon, i, 1);
 
 		REG_WRITE(ah, reg, val);
 
@@ -5436,8 +5436,8 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 				      ath9k_regd_get_antenna_allowed(ah,
 								     chan),
 				      chan->maxRegTxPower * 2,
-				      min((u_int32_t) MAX_RATE_POWER,
-					  (u_int32_t) ah->ah_powerLimit));
+				      min((u32) MAX_RATE_POWER,
+					  (u32) ah->ah_powerLimit));
 	if (status != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			 "%s: error init'ing transmit power\n", __func__);
@@ -5512,7 +5512,7 @@ static inline void ath9k_hw_reset_calibration(struct ath_hal *ah,
 static inline void
 ath9k_hw_per_calibration(struct ath_hal *ah,
 			 struct ath9k_channel *ichan,
-			 u_int8_t rxchainmask,
+			 u8 rxchainmask,
 			 struct hal_cal_list *currCal,
 			 bool *isCalDone)
 {
@@ -5604,7 +5604,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 			struct ath9k_channel *chan,
 			enum ath9k_ht_macmode macmode)
 {
-	u_int32_t synthDelay, qnum;
+	u32 synthDelay, qnum;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
@@ -5644,8 +5644,8 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 				 ath9k_regd_get_ctl(ah, chan),
 				 ath9k_regd_get_antenna_allowed(ah, chan),
 				 chan->maxRegTxPower * 2,
-				 min((u_int32_t) MAX_RATE_POWER,
-				     (u_int32_t) ah->ah_powerLimit)) != 0) {
+				 min((u32) MAX_RATE_POWER,
+				     (u32) ah->ah_powerLimit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error init'ing transmit power\n", __func__);
 		return false;
@@ -5697,7 +5697,7 @@ static bool ath9k_hw_chip_reset(struct ath_hal *ah,
 
 static inline void ath9k_hw_set_dma(struct ath_hal *ah)
 {
-	u_int32_t regval;
+	u32 regval;
 
 	regval = REG_READ(ah, AR_AHB_MODE);
 	REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
@@ -5841,17 +5841,17 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    struct ath9k_channel *chan,
 		    enum ath9k_ht_macmode macmode,
-		    u_int8_t txchainmask, u_int8_t rxchainmask,
+		    u8 txchainmask, u8 rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
 		    int *status)
 {
 #define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
-	u_int32_t saveLedState;
+	u32 saveLedState;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *curchan = ah->ah_curchan;
-	u_int32_t saveDefAntenna;
-	u_int32_t macStaId1;
+	u32 saveDefAntenna;
+	u32 macStaId1;
 	int ecode;
 	int i, rx_chainmask;
 
@@ -6016,7 +6016,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
 
 	if (AR_SREV_9100(ah)) {
-		u_int32_t mask;
+		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
@@ -6059,7 +6059,7 @@ bool ath9k_hw_disable(struct ath_hal *ah)
 
 bool
 ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
-		   u_int8_t rxchainmask, bool longcal,
+		   u8 rxchainmask, bool longcal,
 		   bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -6178,11 +6178,11 @@ static void ath9k_hw_adc_dccal_collect(struct ath_hal *ah)
 	}
 }
 
-static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
+static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u8 numChains)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t powerMeasQ, powerMeasI, iqCorrMeas;
-	u_int32_t qCoffDenom, iCoffDenom;
+	u32 powerMeasQ, powerMeasI, iqCorrMeas;
+	u32 qCoffDenom, iCoffDenom;
 	int32_t qCoff, iCoff;
 	int iqCorrNeg, i;
 
@@ -6259,12 +6259,12 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 }
 
 static void
-ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u_int8_t numChains)
+ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u8 numChains)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset,
+	u32 iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset,
 		qEvenMeasOffset;
-	u_int32_t qGainMismatch, iGainMismatch, val, i;
+	u32 qGainMismatch, iGainMismatch, val, i;
 
 	for (i = 0; i < numChains; i++) {
 		iOddMeasOffset = ahp->ah_totalAdcIOddPhase[i];
@@ -6319,14 +6319,14 @@ ath9k_hw_adc_gaincal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 }
 
 static void
-ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
+ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u8 numChains)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t iOddMeasOffset, iEvenMeasOffset, val, i;
+	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
 	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
 	const struct hal_percal_data *calData =
 		ahp->ah_cal_list_curr->calData;
-	u_int32_t numSamples =
+	u32 numSamples =
 		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
 
 	for (i = 0; i < numChains; i++) {
@@ -6377,20 +6377,20 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
 }
 
-bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
+bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *chan = ah->ah_curchan;
 
-	ah->ah_powerLimit = min(limit, (u_int32_t) MAX_RATE_POWER);
+	ah->ah_powerLimit = min(limit, (u32) MAX_RATE_POWER);
 
 	if (ath9k_hw_set_txpower(ah, &ahp->ah_eeprom, chan,
 				 ath9k_regd_get_ctl(ah, chan),
 				 ath9k_regd_get_antenna_allowed(ah,
 								chan),
 				 chan->maxRegTxPower * 2,
-				 min((u_int32_t) MAX_RATE_POWER,
-				     (u_int32_t) ah->ah_powerLimit)) != 0)
+				 min((u32) MAX_RATE_POWER,
+				     (u32) ah->ah_powerLimit)) != 0)
 		return false;
 
 	return true;
@@ -6482,14 +6482,14 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 	*isCalDone = false;
 }
 
-void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac)
+void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	memcpy(mac, ahp->ah_macaddr, ETH_ALEN);
 }
 
-bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac)
+bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -6497,7 +6497,7 @@ bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac)
 	return true;
 }
 
-void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask)
+void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -6505,7 +6505,7 @@ void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask)
 }
 
 bool
-ath9k_hw_setbssidmask(struct ath_hal *ah, const u_int8_t *mask)
+ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -6543,8 +6543,8 @@ static void ath9k_enable_rfkill(struct ath_hal *ah)
 #endif
 
 void
-ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
-		       u_int16_t assocId)
+ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
+		       u16 assocId)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -6556,9 +6556,9 @@ ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
 		  ((assocId & 0x3fff) << AR_BSS_ID1_AID_S));
 }
 
-u_int64_t ath9k_hw_gettsf64(struct ath_hal *ah)
+u64 ath9k_hw_gettsf64(struct ath_hal *ah)
 {
-	u_int64_t tsf;
+	u64 tsf;
 
 	tsf = REG_READ(ah, AR_TSF_U32);
 	tsf = (tsf << 32) | REG_READ(ah, AR_TSF_L32);
@@ -6583,12 +6583,12 @@ void ath9k_hw_reset_tsf(struct ath_hal *ah)
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
 }
 
-u_int ath9k_hw_getdefantenna(struct ath_hal *ah)
+u32 ath9k_hw_getdefantenna(struct ath_hal *ah)
 {
 	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
 }
 
-void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna)
+void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna)
 {
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
 }
@@ -6597,12 +6597,12 @@ bool
 ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			  enum ath9k_ant_setting settings,
 			  struct ath9k_channel *chan,
-			  u_int8_t *tx_chainmask,
-			  u_int8_t *rx_chainmask,
-			  u_int8_t *antenna_cfgd)
+			  u8 *tx_chainmask,
+			  u8 *rx_chainmask,
+			  u8 *antenna_cfgd)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	static u_int8_t tx_chainmask_cfg, rx_chainmask_cfg;
+	static u8 tx_chainmask_cfg, rx_chainmask_cfg;
 
 	if (AR_SREV_9280(ah)) {
 		if (!tx_chainmask_cfg) {
@@ -6647,7 +6647,7 @@ void ath9k_hw_setopmode(struct ath_hal *ah)
 
 bool
 ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
-		       u_int32_t capability, u_int32_t *result)
+		       u32 capability, u32 *result)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	const struct hal_capabilities *pCap = &ah->ah_caps;
@@ -6734,13 +6734,13 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 }
 
 int
-ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
+ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *chan = ah->ah_curchan;
 	const struct hal_capabilities *pCap = &ah->ah_caps;
-	u_int16_t ant_config;
-	u_int32_t halNumAntConfig;
+	u16 ant_config;
+	u32 halNumAntConfig;
 
 	halNumAntConfig =
 		IS_CHAN_2GHZ(chan) ? pCap->halNumAntCfg2GHz : pCap->
@@ -6759,7 +6759,7 @@ ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
 
 bool ath9k_hw_intrpend(struct ath_hal *ah)
 {
-	u_int32_t host_isr;
+	u32 host_isr;
 
 	if (AR_SREV_9100(ah))
 		return true;
@@ -6778,10 +6778,10 @@ bool ath9k_hw_intrpend(struct ath_hal *ah)
 
 bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 {
-	u_int32_t isr = 0;
-	u_int32_t mask2 = 0;
+	u32 isr = 0;
+	u32 mask2 = 0;
 	struct hal_capabilities *pCap = &ah->ah_caps;
-	u_int32_t sync_cause = 0;
+	u32 sync_cause = 0;
 	bool fatal_int = false;
 
 	if (!AR_SREV_9100(ah)) {
@@ -6809,7 +6809,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 		struct ath_hal_5416 *ahp = AH5416(ah);
 
 		if (isr & AR_ISR_BCNMISC) {
-			u_int32_t isr2;
+			u32 isr2;
 			isr2 = REG_READ(ah, AR_ISR_S2);
 			if (isr2 & AR_ISR_S2_TIM)
 				mask2 |= ATH9K_INT_TIM;
@@ -6844,7 +6844,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 		if (isr &
 		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
 		     AR_ISR_TXEOL)) {
-			u_int32_t s0_s, s1_s;
+			u32 s0_s, s1_s;
 
 			*masked |= ATH9K_INT_TX;
 
@@ -6865,7 +6865,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 
 		if (!AR_SREV_9100(ah)) {
 			if (!pCap->halAutoSleepSupport) {
-				u_int32_t isr5 = REG_READ(ah, AR_ISR_S5_S);
+				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
 				if (isr5 & AR_ISR_S5_TIM_TIMER)
 					*masked |= ATH9K_INT_TIM_TIMER;
 			}
@@ -6921,8 +6921,8 @@ enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah)
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t omask = ahp->ah_maskReg;
-	u_int32_t mask, mask2;
+	u32 omask = ahp->ah_maskReg;
+	u32 mask, mask2;
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
@@ -7029,7 +7029,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 
 void
 ath9k_hw_beaconinit(struct ath_hal *ah,
-		    u_int32_t next_beacon, u_int32_t beacon_period)
+		    u32 next_beacon, u32 beacon_period)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	int flags = 0;
@@ -7085,7 +7085,7 @@ void
 ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 			       const struct ath9k_beacon_state *bs)
 {
-	u_int32_t nextTbtt, beaconintval, dtimperiod, beacontimeout;
+	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
@@ -7146,19 +7146,19 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 
 }
 
-bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry)
+bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry)
 {
 	if (entry < ah->ah_caps.halKeyCacheSize) {
-		u_int32_t val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
+		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
 		if (val & AR_KEYTABLE_VALID)
 			return true;
 	}
 	return false;
 }
 
-bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
+bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
 {
-	u_int32_t keyType;
+	u32 keyType;
 
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
@@ -7177,7 +7177,7 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
 	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), 0);
 
 	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u_int16_t micentry = entry + 64;
+		u16 micentry = entry + 64;
 
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
@@ -7193,10 +7193,10 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
 }
 
 bool
-ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
-		   const u_int8_t *mac)
+ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry,
+		   const u8 *mac)
 {
-	u_int32_t macHi, macLo;
+	u32 macHi, macLo;
 
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
@@ -7221,14 +7221,14 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 }
 
 bool
-ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
+ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 			    const struct ath9k_keyval *k,
-			    const u_int8_t *mac, int xorKey)
+			    const u8 *mac, int xorKey)
 {
 	const struct hal_capabilities *pCap = &ah->ah_caps;
-	u_int32_t key0, key1, key2, key3, key4;
-	u_int32_t keyType;
-	u_int32_t xorMask = xorKey ?
+	u32 key0, key1, key2, key3, key4;
+	u32 keyType;
+	u32 xorMask = xorKey ?
 		(ATH9K_KEY_XOR << 24 | ATH9K_KEY_XOR << 16 | ATH9K_KEY_XOR << 8
 		 | ATH9K_KEY_XOR) : 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -7295,7 +7295,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		key4 &= 0xff;
 
 	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u_int16_t micentry = entry + 64;
+		u16 micentry = entry + 64;
 
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
@@ -7306,7 +7306,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 
 		if (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) {
-			u_int32_t mic0, mic1, mic2, mic3, mic4;
+			u32 mic0, mic1, mic2, mic3, mic4;
 
 			mic0 = LE_READ_4(k->kv_mic + 0);
 			mic2 = LE_READ_4(k->kv_mic + 4);
@@ -7322,7 +7322,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 				  AR_KEYTABLE_TYPE_CLR);
 
 		} else {
-			u_int32_t mic0, mic2;
+			u32 mic0, mic2;
 
 			mic0 = LE_READ_4(k->kv_mic + 0);
 			mic2 = LE_READ_4(k->kv_mic + 4);
@@ -7359,7 +7359,7 @@ bool
 ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t txcfg, curLevel, newLevel;
+	u32 txcfg, curLevel, newLevel;
 	enum ath9k_int omask;
 
 	if (ah->ah_txTrigLevel >= MAX_TX_FIFO_THRESHOLD)
@@ -7391,7 +7391,7 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 				   struct ath9k_tx_queue_info *qi,
 				   const struct ath9k_txq_info *qInfo)
 {
-	u_int32_t cw;
+	u32 cw;
 
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
@@ -7425,11 +7425,11 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 		qi->tqi_cwmax = INIT_CWMAX;
 
 	if (qInfo->tqi_shretry != 0)
-		qi->tqi_shretry = min((u_int32_t) qInfo->tqi_shretry, 15U);
+		qi->tqi_shretry = min((u32) qInfo->tqi_shretry, 15U);
 	else
 		qi->tqi_shretry = INIT_SH_RETRY;
 	if (qInfo->tqi_lgretry != 0)
-		qi->tqi_lgretry = min((u_int32_t) qInfo->tqi_lgretry, 15U);
+		qi->tqi_lgretry = min((u32) qInfo->tqi_lgretry, 15U);
 	else
 		qi->tqi_lgretry = INIT_LG_RETRY;
 	qi->tqi_cbrPeriod = qInfo->tqi_cbrPeriod;
@@ -7595,7 +7595,7 @@ ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 		      AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
 }
 
-bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
+bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7627,13 +7627,13 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 	return true;
 }
 
-bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
+bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ath9k_tx_queue_info *qi;
-	u_int32_t cwMin, chanCwMin, value;
+	u32 cwMin, chanCwMin, value;
 
 	if (q >= pCap->halTotalQueues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
@@ -7793,7 +7793,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 	return true;
 }
 
-void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs)
+void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	*txqs &= ahp->ah_intrTxqs;
@@ -7802,7 +7802,7 @@ void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs)
 
 bool
 ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-		    u_int segLen, bool firstSeg,
+		    u32 segLen, bool firstSeg,
 		    bool lastSeg, const struct ath_desc *ds0)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -7915,8 +7915,8 @@ ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 
 void
 ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-		       u_int pktLen, enum ath9k_pkt_type type, u_int txPower,
-		       u_int keyIx, enum ath9k_key_type keyType, u_int flags)
+		       u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
+		       u32 keyIx, enum ath9k_key_type keyType, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -7954,14 +7954,14 @@ ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
 void
 ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 			     struct ath_desc *lastds,
-			     u_int durUpdateEn, u_int rtsctsRate,
-			     u_int rtsctsDuration,
+			     u32 durUpdateEn, u32 rtsctsRate,
+			     u32 rtsctsDuration,
 			     struct ath9k_11n_rate_series series[],
-			     u_int nseries, u_int flags)
+			     u32 nseries, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	struct ar5416_desc *last_ads = AR5416DESC(lastds);
-	u_int32_t ds_ctl0;
+	u32 ds_ctl0;
 
 	(void) nseries;
 	(void) rtsctsDuration;
@@ -8012,7 +8012,7 @@ ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 
 void
 ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
-			   u_int aggrLen)
+			   u32 aggrLen)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -8024,7 +8024,7 @@ ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
 
 void
 ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
-			    u_int numDelims)
+			    u32 numDelims)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	unsigned int ctl6;
@@ -8055,7 +8055,7 @@ void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds)
 
 void
 ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
-			      u_int burstDuration)
+			      u32 burstDuration)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -8065,7 +8065,7 @@ ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
 
 void
 ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
-				u_int vmf)
+				u32 vmf)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -8075,7 +8075,7 @@ ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
 		ads->ds_ctl0 &= ~AR_VirtMoreFrag;
 }
 
-void ath9k_hw_putrxbuf(struct ath_hal *ah, u_int32_t rxdp)
+void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp)
 {
 	REG_WRITE(ah, AR_RXDP, rxdp);
 }
@@ -8094,7 +8094,7 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 
 		if (!ath9k_hw_wait
 		    (ah, AR_OBS_BUS_1, AR_OBS_BUS_1_RX_STATE, 0)) {
-			u_int32_t reg;
+			u32 reg;
 
 			REG_CLR_BIT(ah, AR_DIAG_SW,
 				    (AR_DIAG_RX_DIS |
@@ -8116,8 +8116,8 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 }
 
 void
-ath9k_hw_setmcastfilter(struct ath_hal *ah, u_int32_t filter0,
-			u_int32_t filter1)
+ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0,
+			u32 filter1)
 {
 	REG_WRITE(ah, AR_MCAST_FIL0, filter0);
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
@@ -8125,7 +8125,7 @@ ath9k_hw_setmcastfilter(struct ath_hal *ah, u_int32_t filter0,
 
 bool
 ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
-		     u_int32_t size, u_int flags)
+		     u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -8142,7 +8142,7 @@ ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 
 int
 ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
-		    u_int32_t pa, struct ath_desc *nds, u_int64_t tsf)
+		    u32 pa, struct ath_desc *nds, u64 tsf)
 {
 	struct ar5416_desc ads;
 	struct ar5416_desc *adsp = AR5416DESC(ds);
@@ -8194,7 +8194,7 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 		if (ads.ds_rxstatus8 & AR_CRCErr)
 			ds->ds_rxstat.rs_status |= ATH9K_RXERR_CRC;
 		else if (ads.ds_rxstatus8 & AR_PHYErr) {
-			u_int phyerr;
+			u32 phyerr;
 
 			ds->ds_rxstat.rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
@@ -8216,10 +8216,10 @@ static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
 	if (rt->rateCodeToIndex[0] != 0)
 		return;
 	for (i = 0; i < 256; i++)
-		rt->rateCodeToIndex[i] = (u_int8_t) -1;
+		rt->rateCodeToIndex[i] = (u8) -1;
 	for (i = 0; i < rt->rateCount; i++) {
-		u_int8_t code = rt->info[i].rateCode;
-		u_int8_t cix = rt->info[i].controlRate;
+		u8 code = rt->info[i].rateCode;
+		u8 cix = rt->info[i].controlRate;
 
 		rt->rateCodeToIndex[code] = i;
 		rt->rateCodeToIndex[code | rt->info[i].shortPreamble] = i;
@@ -8238,7 +8238,7 @@ static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
 }
 
 const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
-						   u_int mode)
+						   u32 mode)
 {
 	struct ath9k_rate_table *rt;
 	switch (mode) {
@@ -8270,7 +8270,7 @@ const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 	return rt;
 }
 
-static const char *ath9k_hw_devname(u_int16_t devid)
+static const char *ath9k_hw_devname(u16 devid)
 {
 	switch (devid) {
 	case AR5416_DEVID_PCI:
@@ -8285,13 +8285,13 @@ static const char *ath9k_hw_devname(u_int16_t devid)
 	return NULL;
 }
 
-const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid)
+const char *ath9k_hw_probe(u16 vendorid, u16 devid)
 {
 	return vendorid == ATHEROS_VENDOR_ID ?
 		ath9k_hw_devname(devid) : NULL;
 }
 
-struct ath_hal *ath9k_hw_attach(u_int16_t devid,
+struct ath_hal *ath9k_hw_attach(u16 devid,
 				struct ath_softc *sc,
 				void __iomem *mem,
 				int *error)
@@ -8325,14 +8325,14 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 	return ah;
 }
 
-u_int16_t
+u16
 ath9k_hw_computetxtime(struct ath_hal *ah,
 		       const struct ath9k_rate_table *rates,
-		       u_int32_t frameLen, u_int16_t rateix,
+		       u32 frameLen, u16 rateix,
 		       bool shortPreamble)
 {
-	u_int32_t bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
-	u_int32_t kbps;
+	u32 bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
+	u32 kbps;
 
 	kbps = rates->info[rateix].rateKbps;
 
@@ -8388,7 +8388,7 @@ ath9k_hw_computetxtime(struct ath_hal *ah,
 	return txTime;
 }
 
-u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags)
+u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags)
 {
 	if (flags & CHANNEL_2GHZ) {
 		if (freq == 2484)
@@ -8447,7 +8447,7 @@ ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 		return ichan->rawNoiseFloor;
 }
 
-bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u_int32_t setting)
+bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -8465,20 +8465,20 @@ bool ath9k_hw_phycounters(struct ath_hal *ah)
 	return ahp->ah_hasHwPhyCounters ? true : false;
 }
 
-u_int32_t ath9k_hw_gettxbuf(struct ath_hal *ah, u_int q)
+u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q)
 {
 	return REG_READ(ah, AR_QTXDP(q));
 }
 
-bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
-		       u_int32_t txdp)
+bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q,
+		       u32 txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 
 	return true;
 }
 
-bool ath9k_hw_txstart(struct ath_hal *ah, u_int q)
+bool ath9k_hw_txstart(struct ath_hal *ah, u32 q)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
 
@@ -8487,9 +8487,9 @@ bool ath9k_hw_txstart(struct ath_hal *ah, u_int q)
 	return true;
 }
 
-u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q)
+u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q)
 {
-	u_int32_t npend;
+	u32 npend;
 
 	npend = REG_READ(ah, AR_QSTS(q)) & AR_Q_STS_PEND_FR_CNT;
 	if (npend == 0) {
@@ -8500,9 +8500,9 @@ u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q)
 	return npend;
 }
 
-bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
+bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 {
-	u_int wait;
+	u32 wait;
 
 	REG_WRITE(ah, AR_Q_TXD, 1 << q);
 
@@ -8513,7 +8513,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 	}
 
 	if (ath9k_hw_numtxpending(ah, q)) {
-		u_int32_t tsfLow, j;
+		u32 tsfLow, j;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			 "%s: Num of pending TX Frames %d on Q %d\n",
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 1f68317..ae680f2 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -21,43 +21,43 @@
 #include <linux/delay.h>
 
 struct ar5416_desc {
-	u_int32_t ds_link;
-	u_int32_t ds_data;
-	u_int32_t ds_ctl0;
-	u_int32_t ds_ctl1;
+	u32 ds_link;
+	u32 ds_data;
+	u32 ds_ctl0;
+	u32 ds_ctl1;
 	union {
 		struct {
-			u_int32_t ctl2;
-			u_int32_t ctl3;
-			u_int32_t ctl4;
-			u_int32_t ctl5;
-			u_int32_t ctl6;
-			u_int32_t ctl7;
-			u_int32_t ctl8;
-			u_int32_t ctl9;
-			u_int32_t ctl10;
-			u_int32_t ctl11;
-			u_int32_t status0;
-			u_int32_t status1;
-			u_int32_t status2;
-			u_int32_t status3;
-			u_int32_t status4;
-			u_int32_t status5;
-			u_int32_t status6;
-			u_int32_t status7;
-			u_int32_t status8;
-			u_int32_t status9;
+			u32 ctl2;
+			u32 ctl3;
+			u32 ctl4;
+			u32 ctl5;
+			u32 ctl6;
+			u32 ctl7;
+			u32 ctl8;
+			u32 ctl9;
+			u32 ctl10;
+			u32 ctl11;
+			u32 status0;
+			u32 status1;
+			u32 status2;
+			u32 status3;
+			u32 status4;
+			u32 status5;
+			u32 status6;
+			u32 status7;
+			u32 status8;
+			u32 status9;
 		} tx;
 		struct {
-			u_int32_t status0;
-			u_int32_t status1;
-			u_int32_t status2;
-			u_int32_t status3;
-			u_int32_t status4;
-			u_int32_t status5;
-			u_int32_t status6;
-			u_int32_t status7;
-			u_int32_t status8;
+			u32 status0;
+			u32 status1;
+			u32 status2;
+			u32 status3;
+			u32 status4;
+			u32 status5;
+			u32 status6;
+			u32 status7;
+			u32 status8;
 		} rx;
 	} u;
 } __packed;
@@ -351,26 +351,26 @@ struct ar5416_desc {
 
 struct ar5416AniState {
 	struct ath9k_channel c;
-	u_int8_t noiseImmunityLevel;
-	u_int8_t spurImmunityLevel;
-	u_int8_t firstepLevel;
-	u_int8_t ofdmWeakSigDetectOff;
-	u_int8_t cckWeakSigThreshold;
-	u_int32_t listenTime;
-	u_int32_t ofdmTrigHigh;
-	u_int32_t ofdmTrigLow;
+	u8 noiseImmunityLevel;
+	u8 spurImmunityLevel;
+	u8 firstepLevel;
+	u8 ofdmWeakSigDetectOff;
+	u8 cckWeakSigThreshold;
+	u32 listenTime;
+	u32 ofdmTrigHigh;
+	u32 ofdmTrigLow;
 	int32_t cckTrigHigh;
 	int32_t cckTrigLow;
 	int32_t rssiThrLow;
 	int32_t rssiThrHigh;
-	u_int32_t noiseFloor;
-	u_int32_t txFrameCount;
-	u_int32_t rxFrameCount;
-	u_int32_t cycleCount;
-	u_int32_t ofdmPhyErrCount;
-	u_int32_t cckPhyErrCount;
-	u_int32_t ofdmPhyErrBase;
-	u_int32_t cckPhyErrBase;
+	u32 noiseFloor;
+	u32 txFrameCount;
+	u32 rxFrameCount;
+	u32 cycleCount;
+	u32 ofdmPhyErrCount;
+	u32 cckPhyErrCount;
+	u32 ofdmPhyErrBase;
+	u32 cckPhyErrBase;
 	int16_t pktRssi[2];
 	int16_t ofdmErrRssi[2];
 	int16_t cckErrRssi[2];
@@ -384,21 +384,21 @@ struct ar5416AniState {
     ((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
 
 struct ar5416Stats {
-	u_int32_t ast_ani_niup;
-	u_int32_t ast_ani_nidown;
-	u_int32_t ast_ani_spurup;
-	u_int32_t ast_ani_spurdown;
-	u_int32_t ast_ani_ofdmon;
-	u_int32_t ast_ani_ofdmoff;
-	u_int32_t ast_ani_cckhigh;
-	u_int32_t ast_ani_ccklow;
-	u_int32_t ast_ani_stepup;
-	u_int32_t ast_ani_stepdown;
-	u_int32_t ast_ani_ofdmerrs;
-	u_int32_t ast_ani_cckerrs;
-	u_int32_t ast_ani_reset;
-	u_int32_t ast_ani_lzero;
-	u_int32_t ast_ani_lneg;
+	u32 ast_ani_niup;
+	u32 ast_ani_nidown;
+	u32 ast_ani_spurup;
+	u32 ast_ani_spurdown;
+	u32 ast_ani_ofdmon;
+	u32 ast_ani_ofdmoff;
+	u32 ast_ani_cckhigh;
+	u32 ast_ani_ccklow;
+	u32 ast_ani_stepup;
+	u32 ast_ani_stepdown;
+	u32 ast_ani_ofdmerrs;
+	u32 ast_ani_cckerrs;
+	u32 ast_ani_reset;
+	u32 ast_ani_lzero;
+	u32 ast_ani_lneg;
 	struct ath9k_mib_stats ast_mibstats;
 	struct ath9k_node_stats ast_nodestats;
 };
@@ -495,100 +495,100 @@ enum ar5416_rates {
 };
 
 struct base_eep_header {
-	u_int16_t length;
-	u_int16_t checksum;
-	u_int16_t version;
-	u_int8_t opCapFlags;
-	u_int8_t eepMisc;
-	u_int16_t regDmn[2];
-	u_int8_t macAddr[6];
-	u_int8_t rxMask;
-	u_int8_t txMask;
-	u_int16_t rfSilent;
-	u_int16_t blueToothOptions;
-	u_int16_t deviceCap;
-	u_int32_t binBuildNumber;
-	u_int8_t deviceType;
-	u_int8_t pwdclkind;
-	u_int8_t futureBase[32];
+	u16 length;
+	u16 checksum;
+	u16 version;
+	u8 opCapFlags;
+	u8 eepMisc;
+	u16 regDmn[2];
+	u8 macAddr[6];
+	u8 rxMask;
+	u8 txMask;
+	u16 rfSilent;
+	u16 blueToothOptions;
+	u16 deviceCap;
+	u32 binBuildNumber;
+	u8 deviceType;
+	u8 pwdclkind;
+	u8 futureBase[32];
 } __packed;
 
 struct spur_chan {
-	u_int16_t spurChan;
-	u_int8_t spurRangeLow;
-	u_int8_t spurRangeHigh;
+	u16 spurChan;
+	u8 spurRangeLow;
+	u8 spurRangeHigh;
 } __packed;
 
 struct modal_eep_header {
-	u_int32_t antCtrlChain[AR5416_MAX_CHAINS];
-	u_int32_t antCtrlCommon;
-	u_int8_t antennaGainCh[AR5416_MAX_CHAINS];
-	u_int8_t switchSettling;
-	u_int8_t txRxAttenCh[AR5416_MAX_CHAINS];
-	u_int8_t rxTxMarginCh[AR5416_MAX_CHAINS];
-	u_int8_t adcDesiredSize;
-	u_int8_t pgaDesiredSize;
-	u_int8_t xlnaGainCh[AR5416_MAX_CHAINS];
-	u_int8_t txEndToXpaOff;
-	u_int8_t txEndToRxOn;
-	u_int8_t txFrameToXpaOn;
-	u_int8_t thresh62;
-	u_int8_t noiseFloorThreshCh[AR5416_MAX_CHAINS];
-	u_int8_t xpdGain;
-	u_int8_t xpd;
-	u_int8_t iqCalICh[AR5416_MAX_CHAINS];
-	u_int8_t iqCalQCh[AR5416_MAX_CHAINS];
-	u_int8_t pdGainOverlap;
-	u_int8_t ob;
-	u_int8_t db;
-	u_int8_t xpaBiasLvl;
-	u_int8_t pwrDecreaseFor2Chain;
-	u_int8_t pwrDecreaseFor3Chain;
-	u_int8_t txFrameToDataStart;
-	u_int8_t txFrameToPaOn;
-	u_int8_t ht40PowerIncForPdadc;
-	u_int8_t bswAtten[AR5416_MAX_CHAINS];
-	u_int8_t bswMargin[AR5416_MAX_CHAINS];
-	u_int8_t swSettleHt40;
-	u_int8_t xatten2Db[AR5416_MAX_CHAINS];
-	u_int8_t xatten2Margin[AR5416_MAX_CHAINS];
-	u_int8_t ob_ch1;
-	u_int8_t db_ch1;
-	u_int8_t useAnt1:1,
+	u32 antCtrlChain[AR5416_MAX_CHAINS];
+	u32 antCtrlCommon;
+	u8 antennaGainCh[AR5416_MAX_CHAINS];
+	u8 switchSettling;
+	u8 txRxAttenCh[AR5416_MAX_CHAINS];
+	u8 rxTxMarginCh[AR5416_MAX_CHAINS];
+	u8 adcDesiredSize;
+	u8 pgaDesiredSize;
+	u8 xlnaGainCh[AR5416_MAX_CHAINS];
+	u8 txEndToXpaOff;
+	u8 txEndToRxOn;
+	u8 txFrameToXpaOn;
+	u8 thresh62;
+	u8 noiseFloorThreshCh[AR5416_MAX_CHAINS];
+	u8 xpdGain;
+	u8 xpd;
+	u8 iqCalICh[AR5416_MAX_CHAINS];
+	u8 iqCalQCh[AR5416_MAX_CHAINS];
+	u8 pdGainOverlap;
+	u8 ob;
+	u8 db;
+	u8 xpaBiasLvl;
+	u8 pwrDecreaseFor2Chain;
+	u8 pwrDecreaseFor3Chain;
+	u8 txFrameToDataStart;
+	u8 txFrameToPaOn;
+	u8 ht40PowerIncForPdadc;
+	u8 bswAtten[AR5416_MAX_CHAINS];
+	u8 bswMargin[AR5416_MAX_CHAINS];
+	u8 swSettleHt40;
+	u8 xatten2Db[AR5416_MAX_CHAINS];
+	u8 xatten2Margin[AR5416_MAX_CHAINS];
+	u8 ob_ch1;
+	u8 db_ch1;
+	u8 useAnt1:1,
 	    force_xpaon:1,
 	    local_bias:1,
 	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
-	u_int8_t futureModalar9280;
-	u_int16_t xpaBiasLvlFreq[3];
-	u_int8_t futureModal[6];
+	u8 futureModalar9280;
+	u16 xpaBiasLvlFreq[3];
+	u8 futureModal[6];
 
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
 
 struct cal_data_per_freq {
-	u_int8_t pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
-	u_int8_t vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
 } __packed;
 
 struct cal_target_power_leg {
-	u_int8_t bChannel;
-	u_int8_t tPow2x[4];
+	u8 bChannel;
+	u8 tPow2x[4];
 } __packed;
 
 struct cal_target_power_ht {
-	u_int8_t bChannel;
-	u_int8_t tPow2x[8];
+	u8 bChannel;
+	u8 tPow2x[8];
 } __packed;
 
 #ifdef __BIG_ENDIAN_BITFIELD
 struct cal_ctl_edges {
-	u_int8_t bChannel;
-	u_int8_t flag:2, tPower:6;
+	u8 bChannel;
+	u8 flag:2, tPower:6;
 } __packed;
 #else
 struct cal_ctl_edges {
-	u_int8_t bChannel;
-	u_int8_t tPower:6, flag:2;
+	u8 bChannel;
+	u8 tPower:6, flag:2;
 } __packed;
 #endif
 
@@ -599,10 +599,10 @@ struct cal_ctl_data {
 
 struct ar5416_eeprom {
 	struct base_eep_header baseEepHeader;
-	u_int8_t custData[64];
+	u8 custData[64];
 	struct modal_eep_header modalHeader[2];
-	u_int8_t calFreqPier5G[AR5416_NUM_5G_CAL_PIERS];
-	u_int8_t calFreqPier2G[AR5416_NUM_2G_CAL_PIERS];
+	u8 calFreqPier5G[AR5416_NUM_5G_CAL_PIERS];
+	u8 calFreqPier2G[AR5416_NUM_2G_CAL_PIERS];
 	struct cal_data_per_freq
 	 calPierData5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS];
 	struct cal_data_per_freq
@@ -621,19 +621,19 @@ struct ar5416_eeprom {
 	 calTargetPower2GHT20[AR5416_NUM_2G_20_TARGET_POWERS];
 	struct cal_target_power_ht
 	 calTargetPower2GHT40[AR5416_NUM_2G_40_TARGET_POWERS];
-	u_int8_t ctlIndex[AR5416_NUM_CTLS];
+	u8 ctlIndex[AR5416_NUM_CTLS];
 	struct cal_ctl_data ctlData[AR5416_NUM_CTLS];
-	u_int8_t padding;
+	u8 padding;
 } __packed;
 
 struct ar5416IniArray {
-	u_int32_t *ia_array;
-	u_int32_t ia_rows;
-	u_int32_t ia_columns;
+	u32 *ia_array;
+	u32 ia_rows;
+	u32 ia_columns;
 };
 
 #define INIT_INI_ARRAY(iniarray, array, rows, columns) do {	\
-		(iniarray)->ia_array = (u_int32_t *)(array);    \
+		(iniarray)->ia_array = (u32 *)(array);    \
 		(iniarray)->ia_rows = (rows);			\
 		(iniarray)->ia_columns = (columns);		\
 	} while (0)
@@ -681,10 +681,10 @@ enum hal_cal_state {
 
 struct hal_percal_data {
 	enum hal_cal_types calType;
-	u_int32_t calNumSamples;
-	u_int32_t calCountMax;
+	u32 calNumSamples;
+	u32 calCountMax;
 	void (*calCollect) (struct ath_hal *);
-	void (*calPostProc) (struct ath_hal *, u_int8_t);
+	void (*calPostProc) (struct ath_hal *, u8);
 };
 
 struct hal_cal_list {
@@ -696,25 +696,25 @@ struct hal_cal_list {
 struct ath_hal_5416 {
 	struct ath_hal ah;
 	struct ar5416_eeprom ah_eeprom;
-	u_int8_t ah_macaddr[ETH_ALEN];
-	u_int8_t ah_bssid[ETH_ALEN];
-	u_int8_t ah_bssidmask[ETH_ALEN];
-	u_int16_t ah_assocId;
+	u8 ah_macaddr[ETH_ALEN];
+	u8 ah_bssid[ETH_ALEN];
+	u8 ah_bssidmask[ETH_ALEN];
+	u16 ah_assocId;
 	int16_t ah_curchanRadIndex;
-	u_int32_t ah_maskReg;
+	u32 ah_maskReg;
 	struct ar5416Stats ah_stats;
-	u_int32_t ah_txDescMask;
-	u_int32_t ah_txOkInterruptMask;
-	u_int32_t ah_txErrInterruptMask;
-	u_int32_t ah_txDescInterruptMask;
-	u_int32_t ah_txEolInterruptMask;
-	u_int32_t ah_txUrnInterruptMask;
+	u32 ah_txDescMask;
+	u32 ah_txOkInterruptMask;
+	u32 ah_txErrInterruptMask;
+	u32 ah_txDescInterruptMask;
+	u32 ah_txEolInterruptMask;
+	u32 ah_txUrnInterruptMask;
 	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
 	enum ath9k_power_mode ah_powerMode;
 	bool ah_chipFullSleep;
-	u_int32_t ah_atimWindow;
+	u32 ah_atimWindow;
 	enum ath9k_ant_setting ah_diversityControl;
-	u_int16_t ah_antennaSwitchSwap;
+	u16 ah_antennaSwitchSwap;
 	enum hal_cal_types ah_suppCals;
 	struct hal_cal_list ah_iqCalData;
 	struct hal_cal_list ah_adcGainCalData;
@@ -735,70 +735,70 @@ struct ath_hal_5416 {
 #define ah_totalAdcDcOffsetQOddPhase  ah_Meas2.sign
 #define ah_totalAdcDcOffsetQEvenPhase ah_Meas3.sign
 	union {
-		u_int32_t unsign[AR5416_MAX_CHAINS];
+		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
 	} ah_Meas0;
 	union {
-		u_int32_t unsign[AR5416_MAX_CHAINS];
+		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
 	} ah_Meas1;
 	union {
-		u_int32_t unsign[AR5416_MAX_CHAINS];
+		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
 	} ah_Meas2;
 	union {
-		u_int32_t unsign[AR5416_MAX_CHAINS];
+		u32 unsign[AR5416_MAX_CHAINS];
 		int32_t sign[AR5416_MAX_CHAINS];
 	} ah_Meas3;
-	u_int16_t ah_CalSamples;
-	u_int32_t ah_tx6PowerInHalfDbm;
-	u_int32_t ah_staId1Defaults;
-	u_int32_t ah_miscMode;
+	u16 ah_CalSamples;
+	u32 ah_tx6PowerInHalfDbm;
+	u32 ah_staId1Defaults;
+	u32 ah_miscMode;
 	bool ah_tpcEnabled;
-	u_int32_t ah_beaconInterval;
+	u32 ah_beaconInterval;
 	enum {
 		AUTO_32KHZ,
 		USE_32KHZ,
 		DONT_USE_32KHZ,
 	} ah_enable32kHzClock;
-	u_int32_t *ah_analogBank0Data;
-	u_int32_t *ah_analogBank1Data;
-	u_int32_t *ah_analogBank2Data;
-	u_int32_t *ah_analogBank3Data;
-	u_int32_t *ah_analogBank6Data;
-	u_int32_t *ah_analogBank6TPCData;
-	u_int32_t *ah_analogBank7Data;
-	u_int32_t *ah_addac5416_21;
-	u_int32_t *ah_bank6Temp;
-	u_int32_t ah_ofdmTxPower;
+	u32 *ah_analogBank0Data;
+	u32 *ah_analogBank1Data;
+	u32 *ah_analogBank2Data;
+	u32 *ah_analogBank3Data;
+	u32 *ah_analogBank6Data;
+	u32 *ah_analogBank6TPCData;
+	u32 *ah_analogBank7Data;
+	u32 *ah_addac5416_21;
+	u32 *ah_bank6Temp;
+	u32 ah_ofdmTxPower;
 	int16_t ah_txPowerIndexOffset;
-	u_int ah_slottime;
-	u_int ah_acktimeout;
-	u_int ah_ctstimeout;
-	u_int ah_globaltxtimeout;
-	u_int8_t ah_gBeaconRate;
-	u_int32_t ah_gpioSelect;
-	u_int32_t ah_polarity;
-	u_int32_t ah_gpioBit;
+	u32 ah_slottime;
+	u32 ah_acktimeout;
+	u32 ah_ctstimeout;
+	u32 ah_globaltxtimeout;
+	u8 ah_gBeaconRate;
+	u32 ah_gpioSelect;
+	u32 ah_polarity;
+	u32 ah_gpioBit;
 	bool ah_eepEnabled;
-	u_int32_t ah_procPhyErr;
+	u32 ah_procPhyErr;
 	bool ah_hasHwPhyCounters;
-	u_int32_t ah_aniPeriod;
+	u32 ah_aniPeriod;
 	struct ar5416AniState *ah_curani;
 	struct ar5416AniState ah_ani[255];
 	int ah_totalSizeDesired[5];
 	int ah_coarseHigh[5];
 	int ah_coarseLow[5];
 	int ah_firpwr[5];
-	u_int16_t ah_ratesArray[16];
-	u_int32_t ah_intrTxqs;
+	u16 ah_ratesArray[16];
+	u32 ah_intrTxqs;
 	bool ah_intrMitigation;
-	u_int32_t ah_cycleCount;
-	u_int32_t ah_ctlBusy;
-	u_int32_t ah_extBusy;
+	u32 ah_cycleCount;
+	u32 ah_ctlBusy;
+	u32 ah_extBusy;
 	enum ath9k_ht_extprotspacing ah_extprotspacing;
-	u_int8_t ah_txchainmask;
-	u_int8_t ah_rxchainmask;
+	u8 ah_txchainmask;
+	u8 ah_rxchainmask;
 	int ah_hwp;
 	void __iomem *ah_cal_mem;
 	enum ath9k_ani_cmd ah_ani_function;
@@ -963,7 +963,7 @@ struct ath_hal_5416 {
 #define OFDM_PLCP_BITS_QUARTER      22
 #define OFDM_SYMBOL_TIME_QUARTER    16
 
-u_int32_t ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
+u32 ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
 			      enum eeprom_param param);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/initvals.h b/drivers/net/wireless/ath9k/initvals.h
index c05873b..3dd3815 100644
--- a/drivers/net/wireless/ath9k/initvals.h
+++ b/drivers/net/wireless/ath9k/initvals.h
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-static const u_int32_t ar5416Modes_9100[][6] = {
+static const u32 ar5416Modes_9100[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -78,7 +78,7 @@ static const u_int32_t ar5416Modes_9100[][6] = {
     { 0x0000a334, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
 };
 
-static const u_int32_t ar5416Common_9100[][2] = {
+static const u32 ar5416Common_9100[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020015 },
     { 0x00000034, 0x00000005 },
@@ -456,12 +456,12 @@ static const u_int32_t ar5416Common_9100[][2] = {
     { 0x0000a3e0, 0x000001ce },
 };
 
-static const u_int32_t ar5416Bank0_9100[][2] = {
+static const u32 ar5416Bank0_9100[][2] = {
     { 0x000098b0, 0x1e5795e5 },
     { 0x000098e0, 0x02008020 },
 };
 
-static const u_int32_t ar5416BB_RfGain_9100[][3] = {
+static const u32 ar5416BB_RfGain_9100[][3] = {
     { 0x00009a00, 0x00000000, 0x00000000 },
     { 0x00009a04, 0x00000040, 0x00000040 },
     { 0x00009a08, 0x00000080, 0x00000080 },
@@ -528,21 +528,21 @@ static const u_int32_t ar5416BB_RfGain_9100[][3] = {
     { 0x00009afc, 0x000000f9, 0x000000f9 },
 };
 
-static const u_int32_t ar5416Bank1_9100[][2] = {
+static const u32 ar5416Bank1_9100[][2] = {
     { 0x000098b0, 0x02108421 },
     { 0x000098ec, 0x00000008 },
 };
 
-static const u_int32_t ar5416Bank2_9100[][2] = {
+static const u32 ar5416Bank2_9100[][2] = {
     { 0x000098b0, 0x0e73ff17 },
     { 0x000098e0, 0x00000420 },
 };
 
-static const u_int32_t ar5416Bank3_9100[][3] = {
+static const u32 ar5416Bank3_9100[][3] = {
     { 0x000098f0, 0x01400018, 0x01c00018 },
 };
 
-static const u_int32_t ar5416Bank6_9100[][3] = {
+static const u32 ar5416Bank6_9100[][3] = {
 
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -579,7 +579,7 @@ static const u_int32_t ar5416Bank6_9100[][3] = {
     { 0x000098d0, 0x0000000f, 0x0010000f },
 };
 
-static const u_int32_t ar5416Bank6TPC_9100[][3] = {
+static const u32 ar5416Bank6TPC_9100[][3] = {
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -615,13 +615,13 @@ static const u_int32_t ar5416Bank6TPC_9100[][3] = {
     { 0x000098d0, 0x0000000f, 0x0010000f },
 };
 
-static const u_int32_t ar5416Bank7_9100[][2] = {
+static const u32 ar5416Bank7_9100[][2] = {
     { 0x0000989c, 0x00000500 },
     { 0x0000989c, 0x00000800 },
     { 0x000098cc, 0x0000000e },
 };
 
-static const u_int32_t ar5416Addac_9100[][2] = {
+static const u32 ar5416Addac_9100[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000003 },
     {0x0000989c,  0x00000000 },
@@ -661,7 +661,7 @@ static const u_int32_t ar5416Addac_9100[][2] = {
     {0x000098c4,  0x00000000 },
 };
 
-static const u_int32_t ar5416Modes[][6] = {
+static const u32 ar5416Modes[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -735,7 +735,7 @@ static const u_int32_t ar5416Modes[][6] = {
     { 0x0000a334, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
 };
 
-static const u_int32_t ar5416Common[][2] = {
+static const u32 ar5416Common[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020015 },
     { 0x00000034, 0x00000005 },
@@ -1109,12 +1109,12 @@ static const u_int32_t ar5416Common[][2] = {
     { 0x0000a3e0, 0x000001ce },
 };
 
-static const u_int32_t ar5416Bank0[][2] = {
+static const u32 ar5416Bank0[][2] = {
     { 0x000098b0, 0x1e5795e5 },
     { 0x000098e0, 0x02008020 },
 };
 
-static const u_int32_t ar5416BB_RfGain[][3] = {
+static const u32 ar5416BB_RfGain[][3] = {
     { 0x00009a00, 0x00000000, 0x00000000 },
     { 0x00009a04, 0x00000040, 0x00000040 },
     { 0x00009a08, 0x00000080, 0x00000080 },
@@ -1181,21 +1181,21 @@ static const u_int32_t ar5416BB_RfGain[][3] = {
     { 0x00009afc, 0x000000f9, 0x000000f9 },
 };
 
-static const u_int32_t ar5416Bank1[][2] = {
+static const u32 ar5416Bank1[][2] = {
     { 0x000098b0, 0x02108421},
     { 0x000098ec, 0x00000008},
 };
 
-static const u_int32_t ar5416Bank2[][2] = {
+static const u32 ar5416Bank2[][2] = {
     { 0x000098b0, 0x0e73ff17},
     { 0x000098e0, 0x00000420},
 };
 
-static const u_int32_t ar5416Bank3[][3] = {
+static const u32 ar5416Bank3[][3] = {
     { 0x000098f0, 0x01400018, 0x01c00018 },
 };
 
-static const u_int32_t ar5416Bank6[][3] = {
+static const u32 ar5416Bank6[][3] = {
 
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -1233,7 +1233,7 @@ static const u_int32_t ar5416Bank6[][3] = {
 };
 
 
-static const u_int32_t ar5416Bank6TPC[][3] = {
+static const u32 ar5416Bank6TPC[][3] = {
 
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -1270,13 +1270,13 @@ static const u_int32_t ar5416Bank6TPC[][3] = {
     { 0x000098d0, 0x0000000f, 0x0010000f },
 };
 
-static const u_int32_t ar5416Bank7[][2] = {
+static const u32 ar5416Bank7[][2] = {
     { 0x0000989c, 0x00000500 },
     { 0x0000989c, 0x00000800 },
     { 0x000098cc, 0x0000000e },
 };
 
-static const u_int32_t ar5416Addac[][2] = {
+static const u32 ar5416Addac[][2] = {
     {0x0000989c, 0x00000000 },
     {0x0000989c, 0x00000000 },
     {0x0000989c, 0x00000000 },
@@ -1312,7 +1312,7 @@ static const u_int32_t ar5416Addac[][2] = {
 };
 
 
-static const u_int32_t ar5416Modes_9160[][6] = {
+static const u32 ar5416Modes_9160[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -1376,7 +1376,7 @@ static const u_int32_t ar5416Modes_9160[][6] = {
     { 0x0000a334, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
 };
 
-static const u_int32_t ar5416Common_9160[][2] = {
+static const u32 ar5416Common_9160[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020015 },
     { 0x00000034, 0x00000005 },
@@ -1755,12 +1755,12 @@ static const u_int32_t ar5416Common_9160[][2] = {
     { 0x0000a3e0, 0x000001ce },
 };
 
-static const u_int32_t ar5416Bank0_9160[][2] = {
+static const u32 ar5416Bank0_9160[][2] = {
     { 0x000098b0, 0x1e5795e5 },
     { 0x000098e0, 0x02008020 },
 };
 
-static const u_int32_t ar5416BB_RfGain_9160[][3] = {
+static const u32 ar5416BB_RfGain_9160[][3] = {
     { 0x00009a00, 0x00000000, 0x00000000 },
     { 0x00009a04, 0x00000040, 0x00000040 },
     { 0x00009a08, 0x00000080, 0x00000080 },
@@ -1827,21 +1827,21 @@ static const u_int32_t ar5416BB_RfGain_9160[][3] = {
     { 0x00009afc, 0x000000f9, 0x000000f9 },
 };
 
-static const u_int32_t ar5416Bank1_9160[][2] = {
+static const u32 ar5416Bank1_9160[][2] = {
     { 0x000098b0, 0x02108421 },
     { 0x000098ec, 0x00000008 },
 };
 
-static const u_int32_t ar5416Bank2_9160[][2] = {
+static const u32 ar5416Bank2_9160[][2] = {
     { 0x000098b0, 0x0e73ff17 },
     { 0x000098e0, 0x00000420 },
 };
 
-static const u_int32_t ar5416Bank3_9160[][3] = {
+static const u32 ar5416Bank3_9160[][3] = {
     { 0x000098f0, 0x01400018, 0x01c00018 },
 };
 
-static const u_int32_t ar5416Bank6_9160[][3] = {
+static const u32 ar5416Bank6_9160[][3] = {
 
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -1878,7 +1878,7 @@ static const u_int32_t ar5416Bank6_9160[][3] = {
     { 0x000098d0, 0x0000000f, 0x0010000f },
 };
 
-static const u_int32_t ar5416Bank6TPC_9160[][3] = {
+static const u32 ar5416Bank6TPC_9160[][3] = {
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
     { 0x0000989c, 0x00000000, 0x00000000 },
@@ -1914,14 +1914,14 @@ static const u_int32_t ar5416Bank6TPC_9160[][3] = {
     { 0x000098d0, 0x0000000f, 0x0010000f },
 };
 
-static const u_int32_t ar5416Bank7_9160[][2] = {
+static const u32 ar5416Bank7_9160[][2] = {
     { 0x0000989c, 0x00000500 },
     { 0x0000989c, 0x00000800 },
     { 0x000098cc, 0x0000000e },
 };
 
 
-static u_int32_t ar5416Addac_9160[][2] = {
+static u32 ar5416Addac_9160[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
@@ -1957,7 +1957,7 @@ static u_int32_t ar5416Addac_9160[][2] = {
 };
 
 
-static u_int32_t ar5416Addac_91601_1[][2] = {
+static u32 ar5416Addac_91601_1[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
@@ -1994,7 +1994,7 @@ static u_int32_t ar5416Addac_91601_1[][2] = {
 
 
 
-static const u_int32_t ar9280Modes_9280[][6] = {
+static const u32 ar9280Modes_9280[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -2196,7 +2196,7 @@ static const u_int32_t ar9280Modes_9280[][6] = {
     { 0x0000788c, 0x00010000, 0x00010000, 0x00110000, 0x00110000, 0x00110000 },
 };
 
-static const u_int32_t ar9280Common_9280[][2] = {
+static const u32 ar9280Common_9280[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020015 },
     { 0x00000034, 0x00000005 },
@@ -2546,7 +2546,7 @@ static const u_int32_t ar9280Common_9280[][2] = {
 
 
 
-static const u_int32_t ar9280Modes_9280_2[][6] = {
+static const u32 ar9280Modes_9280_2[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -2750,7 +2750,7 @@ static const u_int32_t ar9280Modes_9280_2[][6] = {
     { 0x00007894, 0x5a508000, 0x5a508000, 0x5a508000, 0x5a508000, 0x5a508000 },
 };
 
-static const u_int32_t ar9280Common_9280_2[][2] = {
+static const u32 ar9280Common_9280_2[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020015 },
     { 0x00000034, 0x00000005 },
@@ -3098,7 +3098,7 @@ static const u_int32_t ar9280Common_9280_2[][2] = {
     { 0x00007898, 0x2a850160 },
 };
 
-static const u_int32_t ar9280Modes_fast_clock_9280_2[][3] = {
+static const u32 ar9280Modes_fast_clock_9280_2[][3] = {
     { 0x00001030, 0x00000268, 0x000004d0 },
     { 0x00001070, 0x0000018c, 0x00000318 },
     { 0x000010b0, 0x00000fd0, 0x00001fa0 },
@@ -3117,7 +3117,7 @@ static const u_int32_t ar9280Modes_fast_clock_9280_2[][3] = {
 
 
 
-static const u_int32_t ar9280PciePhy_clkreq_off_L1_9280[][2] = {
+static const u32 ar9280PciePhy_clkreq_off_L1_9280[][2] = {
     {0x00004040,  0x9248fd00 },
     {0x00004040,  0x24924924 },
     {0x00004040,  0xa8000019 },
@@ -3132,7 +3132,7 @@ static const u_int32_t ar9280PciePhy_clkreq_off_L1_9280[][2] = {
 
 
 
-static const u_int32_t ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
+static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
     {0x00004040,  0x9248fd00 },
     {0x00004040,  0x24924924 },
     {0x00004040,  0xa8000019 },
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7222a42..9549524 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -54,11 +54,11 @@ static int ath_get_channel(struct ath_softc *sc,
 	return -1;
 }
 
-static u_int32_t ath_get_extchanmode(struct ath_softc *sc,
+static u32 ath_get_extchanmode(struct ath_softc *sc,
 				     struct ieee80211_channel *chan)
 {
-	u_int32_t chanmode = 0;
-	u_int8_t ext_chan_offset = sc->sc_ht_info.ext_chan_offset;
+	u32 chanmode = 0;
+	u8 ext_chan_offset = sc->sc_ht_info.ext_chan_offset;
 	enum ath9k_ht_macmode tx_chan_width = sc->sc_ht_info.tx_chan_width;
 
 	switch (chan->band) {
@@ -296,7 +296,7 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
 	rx_status->flag |= RX_FLAG_TSFT;
 }
 
-static u_int8_t parse_mpdudensity(u_int8_t mpdudensity)
+static u8 parse_mpdudensity(u8 mpdudensity)
 {
 	/*
 	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
@@ -524,7 +524,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_vap *avp;
-	u_int32_t rfilt = 0;
+	u32 rfilt = 0;
 	int error, i;
 	DECLARE_MAC_BUF(mac);
 
@@ -609,9 +609,9 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
 	if ((avp->av_opmode != IEEE80211_IF_TYPE_STA)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
-			if (ath9k_hw_keyisvalid(sc->sc_ah, (u_int16_t)i))
+			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
-						   (u_int16_t)i,
+						   (u16)i,
 						   sc->sc_curbssid);
 	}
 
@@ -921,7 +921,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 {
-	u_int64_t tsf;
+	u64 tsf;
 	struct ath_softc *sc = hw->priv;
 	struct ath_hal *ah = sc->sc_ah;
 
@@ -1072,7 +1072,7 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 int ath__rx_indicate(struct ath_softc *sc,
 		     struct sk_buff *skb,
 		     struct ath_recv_status *status,
-		     u_int16_t keyix)
+		     u16 keyix)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_node *an = NULL;
@@ -1239,7 +1239,7 @@ static int ath_detach(struct ath_softc *sc)
 	return 0;
 }
 
-static int ath_attach(u_int16_t devid,
+static int ath_attach(u16 devid,
 		      struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -1336,7 +1336,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	const char *athname;
-	u_int8_t csz;
+	u8 csz;
 	u32 val;
 	int ret = 0;
 
@@ -1363,7 +1363,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 * DMA to work so force a reasonable value here if it
 		 * comes up zero.
 		 */
-		csz = L1_CACHE_BYTES / sizeof(u_int32_t);
+		csz = L1_CACHE_BYTES / sizeof(u32);
 		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
 	}
 	/*
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 2e0b093..eb9121f 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -20,7 +20,7 @@
 #include "phy.h"
 
 void
-ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex, u_int freqIndex,
+ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex, u32 freqIndex,
 		    int regWrites)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -31,18 +31,18 @@ ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex, u_int freqIndex,
 bool
 ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
 {
-	u_int32_t channelSel = 0;
-	u_int32_t bModeSynth = 0;
-	u_int32_t aModeRefSel = 0;
-	u_int32_t reg32 = 0;
-	u_int16_t freq;
+	u32 channelSel = 0;
+	u32 bModeSynth = 0;
+	u32 aModeRefSel = 0;
+	u32 reg32 = 0;
+	u16 freq;
 	struct chan_centers centers;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
 	if (freq < 4800) {
-		u_int32_t txctl;
+		u32 txctl;
 
 		if (((freq - 2192) % 5) == 0) {
 			channelSel = ((freq - 672) * 2 - 3040) / 10;
@@ -107,10 +107,10 @@ bool
 ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 			    struct ath9k_channel *chan)
 {
-	u_int16_t bMode, fracMode, aModeRefSel = 0;
-	u_int32_t freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
+	u16 bMode, fracMode, aModeRefSel = 0;
+	u32 freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
 	struct chan_centers centers;
-	u_int32_t refDivA = 24;
+	u32 refDivA = 24;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
@@ -119,7 +119,7 @@ ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 	reg32 &= 0xc0000000;
 
 	if (freq < 4800) {
-		u_int32_t txctl;
+		u32 txctl;
 
 		bMode = 1;
 		fracMode = 1;
@@ -175,11 +175,11 @@ ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 }
 
 static void
-ath9k_phy_modify_rx_buffer(u_int32_t *rfBuf, u_int32_t reg32,
-			   u_int32_t numBits, u_int32_t firstBit,
-			   u_int32_t column)
+ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
+			   u32 numBits, u32 firstBit,
+			   u32 column)
 {
-	u_int32_t tmp32, mask, arrayEntry, lastBit;
+	u32 tmp32, mask, arrayEntry, lastBit;
 	int32_t bitPosition, bitsLeft;
 
 	tmp32 = ath9k_hw_reverse_bits(reg32, numBits);
@@ -203,13 +203,13 @@ ath9k_phy_modify_rx_buffer(u_int32_t *rfBuf, u_int32_t reg32,
 
 bool
 ath9k_hw_set_rf_regs(struct ath_hal *ah, struct ath9k_channel *chan,
-		     u_int16_t modesIndex)
+		     u16 modesIndex)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	u_int32_t eepMinorRev;
-	u_int32_t ob5GHz = 0, db5GHz = 0;
-	u_int32_t ob2GHz = 0, db2GHz = 0;
+	u32 eepMinorRev;
+	u32 ob5GHz = 0, db5GHz = 0;
+	u32 ob2GHz = 0, db2GHz = 0;
 	int regWrites = 0;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -319,25 +319,25 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 	if (!AR_SREV_9280_10_OR_LATER(ah)) {
 
 		ahp->ah_analogBank0Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank0.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank1Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank1.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank2Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank2.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank3Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank3.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank6Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank6TPCData =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank6TPC.ia_rows), GFP_KERNEL);
 		ahp->ah_analogBank7Data =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank7.ia_rows), GFP_KERNEL);
 
 		if (ahp->ah_analogBank0Data == NULL
@@ -355,7 +355,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 		}
 
 		ahp->ah_addac5416_21 =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniAddac.ia_rows *
 			     ahp->ah_iniAddac.ia_columns), GFP_KERNEL);
 		if (ahp->ah_addac5416_21 == NULL) {
@@ -367,7 +367,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 		}
 
 		ahp->ah_bank6Temp =
-		    kzalloc((sizeof(u_int32_t) *
+		    kzalloc((sizeof(u32) *
 			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
 		if (ahp->ah_bank6Temp == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
@@ -386,8 +386,8 @@ ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	int i, regWrites = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	u_int32_t bank6SelMask;
-	u_int32_t *bank6Temp = ahp->ah_bank6Temp;
+	u32 bank6SelMask;
+	u32 *bank6Temp = ahp->ah_bank6Temp;
 
 	switch (ahp->ah_diversityControl) {
 	case ATH9K_ANT_FIXED_A:
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 5fb1e1f..0cd399a 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -22,11 +22,11 @@ bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 					  *chan);
 bool ath9k_hw_set_channel(struct ath_hal *ah,
 				   struct ath9k_channel *chan);
-void ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex,
-			 u_int freqIndex, int regWrites);
+void ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex,
+			 u32 freqIndex, int regWrites);
 bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
 				   struct ath9k_channel *chan,
-				   u_int16_t modesIndex);
+				   u16 modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
 				   struct ath9k_channel *chan);
 bool ath9k_hw_init_rf(struct ath_hal *ah,
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index b0deeff..e5a6325 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -22,7 +22,7 @@
 #include "core.h"
 #include "../net/mac80211/rate.h"
 
-static u_int32_t tx_triglevel_max;
+static u32 tx_triglevel_max;
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
@@ -543,7 +543,7 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 				   struct ath_tx_ratectrl *rate_ctrl)
 {
-	u_int8_t i, j, idx, idx_next;
+	u8 i, j, idx, idx_next;
 
 	for (i = rate_ctrl->max_valid_rate - 1; i > 0; i--) {
 		for (j = 0; j <= i-1; j++) {
@@ -563,21 +563,21 @@ static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 
 static void ath_rc_init_valid_txmask(struct ath_tx_ratectrl *rate_ctrl)
 {
-	u_int8_t i;
+	u8 i;
 
 	for (i = 0; i < rate_ctrl->rate_table_size; i++)
 		rate_ctrl->valid_rate_index[i] = FALSE;
 }
 
 static inline void ath_rc_set_valid_txmask(struct ath_tx_ratectrl *rate_ctrl,
-					   u_int8_t index, int valid_tx_rate)
+					   u8 index, int valid_tx_rate)
 {
 	ASSERT(index <= rate_ctrl->rate_table_size);
 	rate_ctrl->valid_rate_index[index] = valid_tx_rate ? TRUE : FALSE;
 }
 
 static inline int ath_rc_isvalid_txmask(struct ath_tx_ratectrl *rate_ctrl,
-					u_int8_t index)
+					u8 index)
 {
 	ASSERT(index <= rate_ctrl->rate_table_size);
 	return rate_ctrl->valid_rate_index[index];
@@ -587,10 +587,10 @@ static inline int ath_rc_isvalid_txmask(struct ath_tx_ratectrl *rate_ctrl,
 static inline int
 ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
 			    struct ath_tx_ratectrl *rate_ctrl,
-			    u_int8_t cur_valid_txrate,
-			    u_int8_t *next_idx)
+			    u8 cur_valid_txrate,
+			    u8 *next_idx)
 {
-	u_int8_t i;
+	u8 i;
 
 	for (i = 0; i < rate_ctrl->max_valid_rate - 1; i++) {
 		if (rate_ctrl->valid_rate_index[i] == cur_valid_txrate) {
@@ -606,7 +606,7 @@ ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
 
 /* Return true only for single stream */
 
-static int ath_rc_valid_phyrate(u_int32_t phy, u_int32_t capflag, int ignore_cw)
+static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 {
 	if (WLAN_RC_PHY_HT(phy) & !(capflag & WLAN_RC_HT_FLAG))
 		return FALSE;
@@ -625,7 +625,7 @@ static int ath_rc_valid_phyrate(u_int32_t phy, u_int32_t capflag, int ignore_cw)
 static inline int
 ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
 				 struct ath_tx_ratectrl *rate_ctrl,
-				 u_int8_t cur_valid_txrate, u_int8_t *next_idx)
+				 u8 cur_valid_txrate, u8 *next_idx)
 {
 	int8_t i;
 
@@ -641,14 +641,14 @@ ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
 /*
  * Initialize the Valid Rate Index from valid entries in Rate Table
  */
-static u_int8_t
+static u8
 ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 			   const struct ath_rate_table *rate_table,
-			   u_int32_t capflag)
+			   u32 capflag)
 {
 	struct ath_tx_ratectrl *rate_ctrl;
-	u_int8_t i, hi = 0;
-	u_int32_t valid;
+	u8 i, hi = 0;
+	u32 valid;
 
 	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
 	for (i = 0; i < rate_table->rate_cnt; i++) {
@@ -656,8 +656,8 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 				rate_table->info[i].valid_single_stream :
 				rate_table->info[i].valid);
 		if (valid == TRUE) {
-			u_int32_t phy = rate_table->info[i].phy;
-			u_int8_t valid_rate_count = 0;
+			u32 phy = rate_table->info[i].phy;
+			u8 valid_rate_count = 0;
 
 			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
 				continue;
@@ -676,22 +676,22 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 /*
  * Initialize the Valid Rate Index from Rate Set
  */
-static u_int8_t
+static u8
 ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 			  const struct ath_rate_table *rate_table,
 			  struct ath_rateset *rateset,
-			  u_int32_t capflag)
+			  u32 capflag)
 {
 	/* XXX: Clean me up and make identation friendly */
-	u_int8_t i, j, hi = 0;
+	u8 i, j, hi = 0;
 	struct ath_tx_ratectrl *rate_ctrl =
 		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
 	/* Use intersection of working rates and valid rates */
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
-			u_int32_t phy = rate_table->info[j].phy;
-			u_int32_t valid = (ath_rc_priv->single_stream ?
+			u32 phy = rate_table->info[j].phy;
+			u32 valid = (ath_rc_priv->single_stream ?
 				rate_table->info[j].valid_single_stream :
 				rate_table->info[j].valid);
 
@@ -707,7 +707,7 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 				WLAN_RC_CAP_MODE(capflag)) &&
 				!WLAN_RC_PHY_HT(phy)) {
 
-				u_int8_t valid_rate_count = 0;
+				u8 valid_rate_count = 0;
 
 				if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
 					continue;
@@ -726,20 +726,20 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 	return hi;
 }
 
-static u_int8_t
+static u8
 ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 			    const struct ath_rate_table *rate_table,
-			    u_int8_t *mcs_set, u_int32_t capflag)
+			    u8 *mcs_set, u32 capflag)
 {
-	u_int8_t i, j, hi = 0;
+	u8 i, j, hi = 0;
 	struct ath_tx_ratectrl *rate_ctrl =
 		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
 	/* Use intersection of working rates and valid rates */
 	for (i = 0; i <  ((struct ath_rateset *)mcs_set)->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
-			u_int32_t phy = rate_table->info[j].phy;
-			u_int32_t valid = (ath_rc_priv->single_stream ?
+			u32 phy = rate_table->info[j].phy;
+			u32 valid = (ath_rc_priv->single_stream ?
 				rate_table->info[j].valid_single_stream :
 				rate_table->info[j].valid);
 
@@ -814,8 +814,8 @@ void ath_rate_detach(struct ath_rate_softc *asc)
 		kfree(asc);
 }
 
-u_int8_t ath_rate_findrateix(struct ath_softc *sc,
-			     u_int8_t dot11rate)
+u8 ath_rate_findrateix(struct ath_softc *sc,
+			     u8 dot11rate)
 {
 	const struct ath_rate_table *ratetable;
 	struct ath_rate_softc *rsc = sc->sc_rc;
@@ -865,14 +865,14 @@ void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
 	}
 }
 
-static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
+static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 				   struct ath_rate_node *ath_rc_priv,
 				   const struct ath_rate_table *rate_table,
 				   int probe_allowed, int *is_probing,
 				   int is_retry)
 {
-	u_int32_t dt, best_thruput, this_thruput, now_msec;
-	u_int8_t rate, next_rate, best_rate, maxindex, minindex;
+	u32 dt, best_thruput, this_thruput, now_msec;
+	u8 rate, next_rate, best_rate, maxindex, minindex;
 	int8_t  rssi_last, rssi_reduce = 0, index = 0;
 	struct ath_tx_ratectrl  *rate_ctrl = NULL;
 
@@ -900,7 +900,7 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (dt >= 185)
 		rssi_reduce = 10;
 	else if (dt >= 25)
-		rssi_reduce = (u_int8_t)((dt - 25) >> 4);
+		rssi_reduce = (u8)((dt - 25) >> 4);
 
 	/* Now reduce rssi_last by rssi_reduce */
 	if (rssi_last < rssi_reduce)
@@ -924,7 +924,7 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 	 * if we have very good channel characteristics.
 	 */
 	for (index = maxindex; index >= minindex ; index--) {
-		u_int8_t per_thres;
+		u8 per_thres;
 
 		rate = rate_ctrl->valid_rate_index[index];
 		if (rate > rate_ctrl->rate_max_phy)
@@ -1005,8 +1005,8 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 
 static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
 				   struct ath_rc_series *series,
-				   u_int8_t tries,
-				   u_int8_t rix,
+				   u8 tries,
+				   u8 rix,
 				   int rtsctsenable)
 {
 	series->tries = tries;
@@ -1022,14 +1022,14 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
 	series->max_4ms_framelen = rate_table->info[rix].max_4ms_framelen;
 }
 
-static u_int8_t ath_rc_rate_getidx(struct ath_softc *sc,
+static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 				   struct ath_rate_node *ath_rc_priv,
 				   const struct ath_rate_table *rate_table,
-				   u_int8_t rix, u_int16_t stepdown,
-				   u_int16_t min_rate)
+				   u8 rix, u16 stepdown,
+				   u16 min_rate)
 {
-	u_int32_t j;
-	u_int8_t nextindex;
+	u32 j;
+	u8 nextindex;
 	struct ath_tx_ratectrl *rate_ctrl =
 		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
@@ -1059,7 +1059,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rc_series series[], int *is_probe,
 			    int is_retry)
 {
-	u_int8_t try_per_rate = 0, i = 0, rix, nrix;
+	u8 try_per_rate = 0, i = 0, rix, nrix;
 	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
 
@@ -1093,8 +1093,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 	/* Fill in the other rates for multirate retry */
 	for ( ; i < num_rates; i++) {
-		u_int8_t try_num;
-		u_int8_t min_rate;
+		u8 try_num;
+		u8 min_rate;
 
 		try_num = ((i + 1) == num_rates) ?
 			num_tries - (try_per_rate * i) : try_per_rate ;
@@ -1126,8 +1126,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	if ((sc->sc_curmode == WIRELESS_MODE_11NG_HT20) ||
 			(sc->sc_curmode == WIRELESS_MODE_11NG_HT40PLUS) ||
 			(sc->sc_curmode == WIRELESS_MODE_11NG_HT40MINUS)) {
-		u_int8_t  dot11rate = rate_table->info[rix].dot11rate;
-		u_int8_t phy = rate_table->info[rix].phy;
+		u8  dot11rate = rate_table->info[rix].dot11rate;
+		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
 		    ((dot11rate == 2 && phy == WLAN_RC_PHY_HT_40_SS) ||
 		    (dot11rate == 3 && phy == WLAN_RC_PHY_HT_20_SS))) {
@@ -1162,8 +1162,8 @@ void ath_rate_findrate(struct ath_softc *sc,
 	} else {
 		/* Fixed rate */
 		int idx;
-		u_int8_t flags;
-		u_int32_t rix;
+		u8 flags;
+		u32 rix;
 		struct ath_rate_softc *asc = ath_rc_priv->asc;
 		struct ath_rate_table *rate_table;
 
@@ -1172,7 +1172,7 @@ void ath_rate_findrate(struct ath_softc *sc,
 
 		for (idx = 0; idx < 4; idx++) {
 			unsigned int    mcs;
-			u_int8_t series_rix = 0;
+			u8 series_rix = 0;
 
 			series[idx].tries =
 				IEEE80211_RATE_IDX_ENTRY(
@@ -1225,14 +1225,14 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			     int tx_rate, int xretries, int retries)
 {
 	struct ath_tx_ratectrl *rate_ctrl;
-	u_int32_t now_msec = jiffies_to_msecs(jiffies);
+	u32 now_msec = jiffies_to_msecs(jiffies);
 	int state_change = FALSE, rate, count;
-	u_int8_t last_per;
+	u8 last_per;
 	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table =
 		(struct ath_rate_table *)asc->hw_rate_table[sc->sc_curmode];
 
-	static u_int32_t nretry_to_per_lookup[10] = {
+	static u32 nretry_to_per_lookup[10] = {
 		100 * 0 / 1,
 		100 * 1 / 4,
 		100 * 1 / 2,
@@ -1276,7 +1276,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				retries = count - 1;
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
 			rate_ctrl->state[tx_rate].per =
-				(u_int8_t)(rate_ctrl->state[tx_rate].per -
+				(u8)(rate_ctrl->state[tx_rate].per -
 				(rate_ctrl->state[tx_rate].per >> 3) +
 				((100) >> 3));
 		}
@@ -1309,7 +1309,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 */
 			if (info_priv->n_frames > 0)
 				rate_ctrl->state[tx_rate].per
-				      = (u_int8_t)
+				      = (u8)
 					(rate_ctrl->state[tx_rate].per -
 					(rate_ctrl->state[tx_rate].per >> 3) +
 					((100*(retries*info_priv->n_frames +
@@ -1319,7 +1319,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		} else {
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
 
-			rate_ctrl->state[tx_rate].per = (u_int8_t)
+			rate_ctrl->state[tx_rate].per = (u8)
 				(rate_ctrl->state[tx_rate].per -
 				(rate_ctrl->state[tx_rate].per >> 3) +
 				(nretry_to_per_lookup[retries] >> 3));
@@ -1347,7 +1347,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				 */
 				rate_ctrl->probe_rate = 0;
 			} else {
-				u_int8_t probe_rate = 0;
+				u8 probe_rate = 0;
 
 				rate_ctrl->rate_max_phy = rate_ctrl->probe_rate;
 				probe_rate = rate_ctrl->probe_rate;
@@ -1438,7 +1438,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			rate_table->info[tx_rate].ratekbps <=
 			rate_table->info[rate_ctrl->rate_max_phy].ratekbps) {
 		ath_rc_get_nextlowervalid_txrate(rate_table, rate_ctrl,
-				(u_int8_t) tx_rate, &rate_ctrl->rate_max_phy);
+				(u8) tx_rate, &rate_ctrl->rate_max_phy);
 
 		/* Don't probe for a little while. */
 		rate_ctrl->probe_time = now_msec;
@@ -1563,8 +1563,8 @@ static void ath_rc_update(struct ath_softc *sc,
 	struct ath_rate_table *rate_table;
 	struct ath_tx_ratectrl *rate_ctrl;
 	struct ath_rc_series rcs[4];
-	u_int8_t flags;
-	u_int32_t series = 0, rix;
+	u8 flags;
+	u32 series = 0, rix;
 
 	memcpy(rcs, info_priv->rcs, 4 * sizeof(rcs[0]));
 	rate_table = (struct ath_rate_table *)
@@ -1692,17 +1692,17 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
  */
 static void ath_rc_sib_update(struct ath_softc *sc,
 			      struct ath_rate_node *ath_rc_priv,
-			      u_int32_t capflag, int keep_state,
+			      u32 capflag, int keep_state,
 			      struct ath_rateset *negotiated_rates,
 			      struct ath_rateset *negotiated_htrates)
 {
 	struct ath_rate_table *rate_table = NULL;
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rateset *rateset = negotiated_rates;
-	u_int8_t *ht_mcs = (u_int8_t *)negotiated_htrates;
+	u8 *ht_mcs = (u8 *)negotiated_htrates;
 	struct ath_tx_ratectrl *rate_ctrl  = (struct ath_tx_ratectrl *)
 		(ath_rc_priv);
-	u_int8_t i, j, k, hi = 0, hthi = 0;
+	u8 i, j, k, hi = 0, hthi = 0;
 
 	rate_table = (struct ath_rate_table *)
 		asc->hw_rate_table[sc->sc_curmode];
@@ -1838,7 +1838,7 @@ static void ath_setup_rates(struct ieee80211_local *local, struct sta_info *sta)
 void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 {
 	struct ath_softc *sc = hw->priv;
-	u_int32_t capflag = 0;
+	u32 capflag = 0;
 
 	if (hw->conf.ht_conf.ht_supported) {
 		capflag |= ATH_RC_HT_FLAG | ATH_RC_DS_FLAG;
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 1c54924..7642a44 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -149,31 +149,31 @@ struct ath_rate_table {
 		int valid;            /* Valid for use in rate control */
 		int valid_single_stream;/* Valid for use in rate control
 					for single stream operation */
-		u_int8_t phy;              /* CCK/OFDM/TURBO/XR */
-		u_int32_t ratekbps;         /* Rate in Kbits per second */
-		u_int32_t user_ratekbps;     /* User rate in KBits per second */
-		u_int8_t ratecode;         /* rate that goes into
+		u8 phy;              /* CCK/OFDM/TURBO/XR */
+		u32 ratekbps;         /* Rate in Kbits per second */
+		u32 user_ratekbps;     /* User rate in KBits per second */
+		u8 ratecode;         /* rate that goes into
 					hw descriptors */
-		u_int8_t short_preamble;    /* Mask for enabling short preamble
+		u8 short_preamble;    /* Mask for enabling short preamble
 						in rate code for CCK */
-		u_int8_t dot11rate;        /* Value that goes into supported
+		u8 dot11rate;        /* Value that goes into supported
 					rates info element of MLME */
-		u_int8_t ctrl_rate;      /* Index of next lower basic rate,
+		u8 ctrl_rate;      /* Index of next lower basic rate,
 					used for duration computation */
 		int8_t rssi_ack_validmin;  /* Rate control related */
 		int8_t rssi_ack_deltamin;  /* Rate control related */
-		u_int8_t base_index;        /* base rate index */
-		u_int8_t cw40index;        /* 40cap rate index */
-		u_int8_t sgi_index;         /* shortgi rate index */
-		u_int8_t ht_index;          /* shortgi rate index */
-		u_int32_t max_4ms_framelen;   /* Maximum frame length(bytes)
+		u8 base_index;        /* base rate index */
+		u8 cw40index;        /* 40cap rate index */
+		u8 sgi_index;         /* shortgi rate index */
+		u8 ht_index;          /* shortgi rate index */
+		u32 max_4ms_framelen;   /* Maximum frame length(bytes)
 						for 4ms tx duration */
 	} info[RATE_TABLE_SIZE];
-	u_int32_t probe_interval;        /* interval for ratectrl to
+	u32 probe_interval;        /* interval for ratectrl to
 					probe for other rates */
-	u_int32_t rssi_reduce_interval;   /* interval for ratectrl
+	u32 rssi_reduce_interval;   /* interval for ratectrl
 						to reduce RSSI */
-	u_int8_t initial_ratemax;   /* the initial ratemax value used
+	u8 initial_ratemax;   /* the initial ratemax value used
 					in ath_rc_sib_update() */
 };
 
@@ -182,10 +182,10 @@ struct ath_rate_table {
 #define ATH_RC_SHORT_PREAMBLE           0x00000004
 
 struct ath_rc_series {
-	u_int8_t    rix;
-	u_int8_t    tries;
-	u_int8_t    flags;
-	u_int32_t   max_4ms_framelen;
+	u8    rix;
+	u8    tries;
+	u8    flags;
+	u32   max_4ms_framelen;
 };
 
 /* rcs_flags definition */
@@ -203,7 +203,7 @@ struct ath_rc_series {
 
 struct ath_tx_ratectrl_state {
 	int8_t rssi_thres; /* required rssi for this rate (dB) */
-	u_int8_t per; /* recent estimate of packet error rate (%) */
+	u8 per; /* recent estimate of packet error rate (%) */
 };
 
 struct ath_tx_ratectrl {
@@ -215,34 +215,34 @@ struct ath_tx_ratectrl {
 	int32_t rssi_sum_cnt;        /* count of rssi_sum for averaging */
 	int32_t rssi_sum_rate;       /* rate that we are averaging */
 	int32_t rssi_sum;           /* running sum of rssi for averaging */
-	u_int32_t valid_txrate_mask;   /* mask of valid rates */
-	u_int8_t rate_table_size;      /* rate table size */
-	u_int8_t rate_max;            /* max rate that has recently worked */
-	u_int8_t probe_rate;          /* rate we are probing at */
-	u_int32_t rssi_time;          /* msec timestamp for last ack rssi */
-	u_int32_t rssi_down_time;      /* msec timestamp for last down step */
-	u_int32_t probe_time;         /* msec timestamp for last probe */
-	u_int8_t hw_maxretry_pktcnt;   /* num packets since we got
+	u32 valid_txrate_mask;   /* mask of valid rates */
+	u8 rate_table_size;      /* rate table size */
+	u8 rate_max;            /* max rate that has recently worked */
+	u8 probe_rate;          /* rate we are probing at */
+	u32 rssi_time;          /* msec timestamp for last ack rssi */
+	u32 rssi_down_time;      /* msec timestamp for last down step */
+	u32 probe_time;         /* msec timestamp for last probe */
+	u8 hw_maxretry_pktcnt;   /* num packets since we got
 					HW max retry error */
-	u_int8_t max_valid_rate;       /* maximum number of valid rate */
-	u_int8_t valid_rate_index[MAX_TX_RATE_TBL]; /* valid rate index */
-	u_int32_t per_down_time;       /* msec timstamp for last
+	u8 max_valid_rate;       /* maximum number of valid rate */
+	u8 valid_rate_index[MAX_TX_RATE_TBL]; /* valid rate index */
+	u32 per_down_time;       /* msec timstamp for last
 					PER down step */
 
 	/* 11n state */
-	u_int8_t  valid_phy_ratecnt[WLAN_RC_PHY_MAX]; /* valid rate count */
-	u_int8_t  valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
-	u_int8_t  rc_phy_mode;
-	u_int8_t  rate_max_phy;        /* Phy index for the max rate */
-	u_int32_t rate_max_lastused;   /* msec timstamp of when we
+	u8  valid_phy_ratecnt[WLAN_RC_PHY_MAX]; /* valid rate count */
+	u8  valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
+	u8  rc_phy_mode;
+	u8  rate_max_phy;        /* Phy index for the max rate */
+	u32 rate_max_lastused;   /* msec timstamp of when we
 					last used rateMaxPhy */
-	u_int32_t probe_interval;     /* interval for ratectrl to probe
+	u32 probe_interval;     /* interval for ratectrl to probe
 					for other rates */
 };
 
 struct ath_rateset {
-	u_int8_t rs_nrates;
-	u_int8_t rs_rates[ATH_RATE_MAX];
+	u8 rs_nrates;
+	u8 rs_rates[ATH_RATE_MAX];
 };
 
 /* per-device state */
@@ -255,18 +255,18 @@ struct ath_rate_softc {
 /* per-node state */
 struct ath_rate_node {
 	struct ath_tx_ratectrl tx_ratectrl;	/* rate control state proper */
-	u_int32_t prev_data_rix;	/* rate idx of last data frame */
+	u32 prev_data_rix;	/* rate idx of last data frame */
 
 	/* map of rate ix -> negotiated rate set ix */
-	u_int8_t rixmap[MAX_TX_RATE_TBL];
+	u8 rixmap[MAX_TX_RATE_TBL];
 
 	/* map of ht rate ix -> negotiated rate set ix */
-	u_int8_t ht_rixmap[MAX_TX_RATE_TBL];
+	u8 ht_rixmap[MAX_TX_RATE_TBL];
 
-	u_int8_t ht_cap;		/* ht capabilities */
-	u_int8_t ant_tx;		/* current transmit antenna */
+	u8 ht_cap;		/* ht capabilities */
+	u8 ant_tx;		/* current transmit antenna */
 
-	u_int8_t single_stream;   /* When TRUE, only single
+	u8 single_stream;   /* When TRUE, only single
 				stream Tx possible */
 	struct ath_rateset neg_rates;	/* Negotiated rates */
 	struct ath_rateset neg_ht_rates;	/* Negotiated HT rates */
@@ -280,7 +280,7 @@ struct ath_tx_info_priv {
 	struct ath_tx_status tx;
 	int n_frames;
 	int n_bad_frames;
-	u_int8_t min_rate;
+	u8 min_rate;
 };
 
 /*
@@ -307,8 +307,8 @@ void ath_rate_findrate(struct ath_softc *sc, struct ath_rate_node *ath_rc_priv,
 /*
  * Return rate index for given Dot11 Rate.
  */
-u_int8_t ath_rate_findrateix(struct ath_softc *sc,
-			     u_int8_t dot11_rate);
+u8 ath_rate_findrateix(struct ath_softc *sc,
+			     u8 dot11_rate);
 
 /* Routines to register/unregister rate control algorithm */
 int ath_rate_control_register(void);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 05dbfe1..8e14e64 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -75,7 +75,7 @@ static int ath_bar_rx(struct ath_softc *sc,
 	struct sk_buff *tskb;
 	struct ath_recv_status *rx_status;
 	int tidno, index, cindex;
-	u_int16_t seqno;
+	u16 seqno;
 
 	/* look at BAR contents	 */
 
@@ -148,8 +148,8 @@ static int ath_ampdu_input(struct ath_softc *sc,
 	struct ieee80211_hdr *hdr;
 	struct ath_arx_tid *rxtid;
 	struct ath_rxbuf *rxbuf;
-	u_int8_t type, subtype;
-	u_int16_t rxseq;
+	u8 type, subtype;
+	u16 rxseq;
 	int tid = 0, index, cindex, rxdiff;
 	__le16 fc;
 	u8 *qc;
@@ -386,10 +386,10 @@ static void ath_rx_flush_tid(struct ath_softc *sc,
 }
 
 static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
-	u_int32_t len)
+	u32 len)
 {
 	struct sk_buff *skb;
-	u_int off;
+	u32 off;
 
 	/*
 	 * Cache-line-align.  This is important (for the
@@ -441,7 +441,7 @@ static void ath_rx_requeue(struct ath_softc *sc, struct sk_buff *skb)
 static int ath_rx_indicate(struct ath_softc *sc,
 			   struct sk_buff *skb,
 			   struct ath_recv_status *status,
-			   u_int16_t keyix)
+			   u16 keyix)
 {
 	struct ath_buf *bf = ATH_RX_CONTEXT(skb)->ctx_rxbuf;
 	struct sk_buff *nskb;
@@ -471,7 +471,7 @@ static int ath_rx_indicate(struct ath_softc *sc,
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u_int32_t rfilt, mfilt[2];
+	u32 rfilt, mfilt[2];
 
 	/* configure rx filter */
 	rfilt = ath_calcrxfilter(sc);
@@ -515,7 +515,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		 */
 		sc->sc_rxbufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 					   min(sc->sc_cachelsz,
-					       (u_int16_t)64));
+					       (u16)64));
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "%s: cachelsz %u rxbufsize %u\n",
 			__func__, sc->sc_cachelsz, sc->sc_rxbufsize);
@@ -594,10 +594,10 @@ void ath_rx_cleanup(struct ath_softc *sc)
  *   - when scanning
  */
 
-u_int32_t ath_calcrxfilter(struct ath_softc *sc)
+u32 ath_calcrxfilter(struct ath_softc *sc)
 {
 #define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
-	u_int32_t rfilt;
+	u32 rfilt;
 
 	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
 		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
@@ -677,7 +677,7 @@ start_recv:
 bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u_int64_t tsf;
+	u64 tsf;
 	bool stopped;
 
 	ath9k_hw_stoppcurecv(ah);	/* disable PCU */
@@ -743,8 +743,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ath_recv_status rx_status;
 	struct ath_hal *ah = sc->sc_ah;
 	int type, rx_processed = 0;
-	u_int phyerr;
-	u_int8_t chainreset = 0;
+	u32 phyerr;
+	u8 chainreset = 0;
 	int retval;
 	__le16 fc;
 
@@ -1199,7 +1199,7 @@ int ath_rx_aggr_stop(struct ath_softc *sc,
 /* Rx aggregation tear down */
 
 void ath_rx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u_int8_t tid)
+	struct ath_node *an, u8 tid)
 {
 	struct ath_arx_tid *rxtid = &an->an_aggr.rx.tid[tid];
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index d001d43..7b0176e 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -32,26 +32,26 @@ static int ath9k_regd_chansort(const void *a, const void *b)
 }
 
 static void
-ath9k_regd_sort(void *a, u_int32_t n, u_int32_t size, ath_hal_cmp_t *cmp)
+ath9k_regd_sort(void *a, u32 n, u32 size, ath_hal_cmp_t *cmp)
 {
-	u_int8_t *aa = a;
-	u_int8_t *ai, *t;
+	u8 *aa = a;
+	u8 *ai, *t;
 
 	for (ai = aa + size; --n >= 1; ai += size)
 		for (t = ai; t > aa; t -= size) {
-			u_int8_t *u = t - size;
+			u8 *u = t - size;
 			if (cmp(u, t) <= 0)
 				break;
 			swap(u, t, size);
 		}
 }
 
-static u_int16_t ath9k_regd_get_eepromRD(struct ath_hal *ah)
+static u16 ath9k_regd_get_eepromRD(struct ath_hal *ah)
 {
 	return ah->ah_currentRD & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-static bool ath9k_regd_is_chan_bm_zero(u_int64_t *bitmask)
+static bool ath9k_regd_is_chan_bm_zero(u64 *bitmask)
 {
 	int i;
 
@@ -64,11 +64,11 @@ static bool ath9k_regd_is_chan_bm_zero(u_int64_t *bitmask)
 
 static bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 {
-	u_int16_t rd = ath9k_regd_get_eepromRD(ah);
+	u16 rd = ath9k_regd_get_eepromRD(ah);
 	int i;
 
 	if (rd & COUNTRY_ERD_FLAG) {
-		u_int16_t cc = rd & ~COUNTRY_ERD_FLAG;
+		u16 cc = rd & ~COUNTRY_ERD_FLAG;
 		for (i = 0; i < ARRAY_SIZE(allCountries); i++)
 			if (allCountries[i].countryCode == cc)
 				return true;
@@ -85,7 +85,7 @@ static bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 
 static bool ath9k_regd_is_fcc_midband_supported(struct ath_hal *ah)
 {
-	u_int32_t regcap;
+	u32 regcap;
 
 	regcap = ah->ah_caps.halRegCap;
 
@@ -96,9 +96,9 @@ static bool ath9k_regd_is_fcc_midband_supported(struct ath_hal *ah)
 }
 
 static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
-				      u_int16_t cc)
+				      u16 cc)
 {
-	u_int16_t rd;
+	u16 rd;
 	int i;
 
 	if (cc == CTRY_DEFAULT)
@@ -131,12 +131,12 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 	return false;
 }
 
-static u_int
+static u32
 ath9k_regd_get_wmodes_nreg(struct ath_hal *ah,
 			   struct country_code_to_enum_rd *country,
 			   struct regDomain *rd5GHz)
 {
-	u_int modesAvail;
+	u32 modesAvail;
 
 	modesAvail = ah->ah_caps.halWirelessModes;
 
@@ -175,7 +175,7 @@ ath9k_regd_get_wmodes_nreg(struct ath_hal *ah,
 
 bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
 {
-	u_int16_t rd;
+	u16 rd;
 
 	rd = ath9k_regd_get_eepromRD(ah);
 
@@ -193,7 +193,7 @@ bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
 }
 
 static struct country_code_to_enum_rd*
-ath9k_regd_find_country(u_int16_t countryCode)
+ath9k_regd_find_country(u16 countryCode)
 {
 	int i;
 
@@ -204,15 +204,15 @@ ath9k_regd_find_country(u_int16_t countryCode)
 	return NULL;
 }
 
-static u_int16_t ath9k_regd_get_default_country(struct ath_hal *ah)
+static u16 ath9k_regd_get_default_country(struct ath_hal *ah)
 {
-	u_int16_t rd;
+	u16 rd;
 	int i;
 
 	rd = ath9k_regd_get_eepromRD(ah);
 	if (rd & COUNTRY_ERD_FLAG) {
 		struct country_code_to_enum_rd *country = NULL;
-		u_int16_t cc = rd & ~COUNTRY_ERD_FLAG;
+		u16 cc = rd & ~COUNTRY_ERD_FLAG;
 
 		country = ath9k_regd_find_country(cc);
 		if (country != NULL)
@@ -261,16 +261,16 @@ static bool ath9k_regd_is_valid_reg_domainPair(int regDmnPair)
 
 static bool
 ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
-			       u_int16_t channelFlag, struct regDomain *rd)
+			       u16 channelFlag, struct regDomain *rd)
 {
 	int i, found;
-	u_int64_t flags = NO_REQ;
+	u64 flags = NO_REQ;
 	struct reg_dmn_pair_mapping *regPair = NULL;
 	int regOrg;
 
 	regOrg = regDmn;
 	if (regDmn == CTRY_DEFAULT) {
-		u_int16_t rdnum;
+		u16 rdnum;
 		rdnum = ath9k_regd_get_eepromRD(ah);
 
 		if (!(rdnum & COUNTRY_ERD_FLAG)) {
@@ -324,14 +324,14 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 	}
 }
 
-static bool ath9k_regd_is_bit_set(int bit, u_int64_t *bitmask)
+static bool ath9k_regd_is_bit_set(int bit, u64 *bitmask)
 {
 	int byteOffset, bitnum;
-	u_int64_t val;
+	u64 val;
 
 	byteOffset = bit / 64;
 	bitnum = bit - byteOffset * 64;
-	val = ((u_int64_t) 1) << bitnum;
+	val = ((u64) 1) << bitnum;
 	if (bitmask[byteOffset] & val)
 		return true;
 	else
@@ -339,8 +339,8 @@ static bool ath9k_regd_is_bit_set(int bit, u_int64_t *bitmask)
 }
 
 static void
-ath9k_regd_add_reg_classid(u_int8_t *regclassids, u_int maxregids,
-			   u_int *nregids, u_int8_t regclassid)
+ath9k_regd_add_reg_classid(u8 *regclassids, u32 maxregids,
+			   u32 *nregids, u8 regclassid)
 {
 	int i;
 
@@ -395,7 +395,7 @@ static void ath9k_regd_init_rf_buffer(struct ath9k_channel *ichans,
 #endif
 
 static int ath9k_regd_is_chan_present(struct ath_hal *ah,
-				      u_int16_t c)
+				      u16 c)
 {
 	int i;
 
@@ -411,11 +411,11 @@ static int ath9k_regd_is_chan_present(struct ath_hal *ah,
 
 static bool
 ath9k_regd_add_channel(struct ath_hal *ah,
-		       u_int16_t c,
-		       u_int16_t c_lo,
-		       u_int16_t c_hi,
-		       u_int16_t maxChan,
-		       u_int8_t ctl,
+		       u16 c,
+		       u16 c_lo,
+		       u16 c_hi,
+		       u16 maxChan,
+		       u8 ctl,
 		       int pos,
 		       struct regDomain rd5GHz,
 		       struct RegDmnFreqBand *fband,
@@ -426,8 +426,8 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 {
 	struct ath9k_channel *chan;
 	int ret;
-	u_int32_t channelFlags = 0;
-	u_int8_t privFlags = 0;
+	u32 channelFlags = 0;
+	u8 privFlags = 0;
 
 	if (!(c_lo <= c && c <= c_hi)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
@@ -529,7 +529,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		if ((c < 2412) || (c > 2462)) {
 			if (rd5GHz.regDmnEnum == MKK1 ||
 			    rd5GHz.regDmnEnum == MKK2) {
-				u_int32_t regcap = ah->ah_caps.halRegCap;
+				u32 regcap = ah->ah_caps.halRegCap;
 				if (!(regcap &
 				      (AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
 				       AR_EEPROM_EEREGCAP_EN_KK_U2 |
@@ -590,7 +590,7 @@ static bool ath9k_regd_japan_check(struct ath_hal *ah,
 {
 	bool skipband = false;
 	int i;
-	u_int32_t regcap;
+	u32 regcap;
 
 	for (i = 0; i < ARRAY_SIZE(j_bandcheck); i++) {
 		if (j_bandcheck[i].freqbandbit == b) {
@@ -615,22 +615,22 @@ static bool ath9k_regd_japan_check(struct ath_hal *ah,
 
 bool
 ath9k_regd_init_channels(struct ath_hal *ah,
-			 u_int maxchans,
-			 u_int *nchans, u_int8_t *regclassids,
-			 u_int maxregids, u_int *nregids, u_int16_t cc,
-			 u_int32_t modeSelect, bool enableOutdoor,
+			 u32 maxchans,
+			 u32 *nchans, u8 *regclassids,
+			 u32 maxregids, u32 *nregids, u16 cc,
+			 u32 modeSelect, bool enableOutdoor,
 			 bool enableExtendedChannels)
 {
-	u_int modesAvail;
-	u_int16_t maxChan = 7000;
+	u32 modesAvail;
+	u16 maxChan = 7000;
 	struct country_code_to_enum_rd *country = NULL;
 	struct regDomain rd5GHz, rd2GHz;
 	const struct cmode *cm;
 	struct ath9k_channel *ichans = &ah->ah_channels[0];
 	int next = 0, b;
-	u_int8_t ctl;
+	u8 ctl;
 	int regdmn;
-	u_int16_t chanSep;
+	u16 chanSep;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: cc %u mode 0x%x%s%s\n",
 		 __func__, cc, modeSelect,
@@ -739,8 +739,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		maxchans = ARRAY_SIZE(ah->ah_channels);
 
 	for (cm = modes; cm < &modes[ARRAY_SIZE(modes)]; cm++) {
-		u_int16_t c, c_hi, c_lo;
-		u_int64_t *channelBM = NULL;
+		u16 c, c_hi, c_lo;
+		u64 *channelBM = NULL;
 		struct regDomain *rd = NULL;
 		struct RegDmnFreqBand *fband = NULL, *freqs;
 		int8_t low_adj = 0, hi_adj = 0;
@@ -967,7 +967,7 @@ ath9k_regd_check_channel(struct ath_hal *ah,
 	return NULL;
 }
 
-u_int
+u32
 ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 			       struct ath9k_channel *chan)
 {
@@ -980,9 +980,9 @@ ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 	return ichan->antennaMax;
 }
 
-u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
+u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 {
-	u_int ctl = NO_CTL;
+	u32 ctl = NO_CTL;
 	struct ath9k_channel *ichan;
 
 	if (ah->ah_countryCode == CTRY_DEFAULT && isWwrSKU(ah)) {
@@ -1013,7 +1013,7 @@ u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 void ath9k_regd_get_current_country(struct ath_hal *ah,
 				    struct ath9k_country_entry *ctry)
 {
-	u_int16_t rd = ath9k_regd_get_eepromRD(ah);
+	u16 rd = ath9k_regd_get_eepromRD(ah);
 
 	ctry->isMultidomain = false;
 	if (rd == CTRY_DEFAULT)
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 85452c7..ae77496 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -20,57 +20,57 @@
 #include "ath9k.h"
 
 #define BMLEN 2
-#define BMZERO {(u_int64_t) 0, (u_int64_t) 0}
+#define BMZERO {(u64) 0, (u64) 0}
 
 #define BM(_fa, _fb, _fc, _fd, _fe, _ff, _fg, _fh, _fi, _fj, _fk, _fl) \
 	{((((_fa >= 0) && (_fa < 64)) ? \
-		(((u_int64_t) 1) << _fa) : (u_int64_t) 0) | \
+		(((u64) 1) << _fa) : (u64) 0) | \
 	(((_fb >= 0) && (_fb < 64)) ? \
-		(((u_int64_t) 1) << _fb) : (u_int64_t) 0) | \
+		(((u64) 1) << _fb) : (u64) 0) | \
 	(((_fc >= 0) && (_fc < 64)) ? \
-		(((u_int64_t) 1) << _fc) : (u_int64_t) 0) | \
+		(((u64) 1) << _fc) : (u64) 0) | \
 	(((_fd >= 0) && (_fd < 64)) ? \
-		(((u_int64_t) 1) << _fd) : (u_int64_t) 0) | \
+		(((u64) 1) << _fd) : (u64) 0) | \
 	(((_fe >= 0) && (_fe < 64)) ? \
-		(((u_int64_t) 1) << _fe) : (u_int64_t) 0) | \
+		(((u64) 1) << _fe) : (u64) 0) | \
 	(((_ff >= 0) && (_ff < 64)) ? \
-		(((u_int64_t) 1) << _ff) : (u_int64_t) 0) | \
+		(((u64) 1) << _ff) : (u64) 0) | \
 	(((_fg >= 0) && (_fg < 64)) ? \
-		(((u_int64_t) 1) << _fg) : (u_int64_t) 0) | \
+		(((u64) 1) << _fg) : (u64) 0) | \
 	(((_fh >= 0) && (_fh < 64)) ? \
-		(((u_int64_t) 1) << _fh) : (u_int64_t) 0) | \
+		(((u64) 1) << _fh) : (u64) 0) | \
 	(((_fi >= 0) && (_fi < 64)) ? \
-		(((u_int64_t) 1) << _fi) : (u_int64_t) 0) | \
+		(((u64) 1) << _fi) : (u64) 0) | \
 	(((_fj >= 0) && (_fj < 64)) ? \
-		(((u_int64_t) 1) << _fj) : (u_int64_t) 0) | \
+		(((u64) 1) << _fj) : (u64) 0) | \
 	(((_fk >= 0) && (_fk < 64)) ? \
-		(((u_int64_t) 1) << _fk) : (u_int64_t) 0) | \
+		(((u64) 1) << _fk) : (u64) 0) | \
 	(((_fl >= 0) && (_fl < 64)) ? \
-		(((u_int64_t) 1) << _fl) : (u_int64_t) 0) | \
+		(((u64) 1) << _fl) : (u64) 0) | \
 			((((_fa > 63) && (_fa < 128)) ? \
-			(((u_int64_t) 1) << (_fa - 64)) : (u_int64_t) 0) | \
+			(((u64) 1) << (_fa - 64)) : (u64) 0) | \
 	(((_fb > 63) && (_fb < 128)) ? \
-		(((u_int64_t) 1) << (_fb - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fb - 64)) : (u64) 0) | \
 	(((_fc > 63) && (_fc < 128)) ? \
-		(((u_int64_t) 1) << (_fc - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fc - 64)) : (u64) 0) | \
 	(((_fd > 63) && (_fd < 128)) ? \
-		(((u_int64_t) 1) << (_fd - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fd - 64)) : (u64) 0) | \
 	(((_fe > 63) && (_fe < 128)) ? \
-		(((u_int64_t) 1) << (_fe - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fe - 64)) : (u64) 0) | \
 	(((_ff > 63) && (_ff < 128)) ? \
-		(((u_int64_t) 1) << (_ff - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_ff - 64)) : (u64) 0) | \
 	(((_fg > 63) && (_fg < 128)) ? \
-		(((u_int64_t) 1) << (_fg - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fg - 64)) : (u64) 0) | \
 	(((_fh > 63) && (_fh < 128)) ? \
-		(((u_int64_t) 1) << (_fh - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fh - 64)) : (u64) 0) | \
 	(((_fi > 63) && (_fi < 128)) ? \
-		(((u_int64_t) 1) << (_fi - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fi - 64)) : (u64) 0) | \
 	(((_fj > 63) && (_fj < 128)) ? \
-		(((u_int64_t) 1) << (_fj - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fj - 64)) : (u64) 0) | \
 	(((_fk > 63) && (_fk < 128)) ? \
-		(((u_int64_t) 1) << (_fk - 64)) : (u_int64_t) 0) | \
+		(((u64) 1) << (_fk - 64)) : (u64) 0) | \
 	(((_fl > 63) && (_fl < 128)) ? \
-		(((u_int64_t) 1) << (_fl - 64)) : (u_int64_t) 0)))}
+		(((u64) 1) << (_fl - 64)) : (u64) 0)))}
 
 #define DEF_REGDMN      FCC1_FCCA
 #define DEF_DMN_5       FCC1
@@ -126,10 +126,10 @@
 #define CHAN_FLAGS      (CHANNEL_ALL|CHANNEL_HALF|CHANNEL_QUARTER)
 
 #define swap(_a, _b, _size) {                   \
-	u_int8_t *s = _b;                       \
+	u8 *s = _b;                       \
 	int i = _size;                          \
 	do {                                    \
-		u_int8_t tmp = *_a;             \
+		u8 tmp = *_a;             \
 		*_a++ = *s;                     \
 		*s++ = tmp;                     \
 	} while (--i);                          \
@@ -150,23 +150,23 @@
 typedef int ath_hal_cmp_t(const void *, const void *);
 
 struct reg_dmn_pair_mapping {
-	u_int16_t regDmnEnum;
-	u_int16_t regDmn5GHz;
-	u_int16_t regDmn2GHz;
-	u_int32_t flags5GHz;
-	u_int32_t flags2GHz;
-	u_int64_t pscanMask;
-	u_int16_t singleCC;
+	u16 regDmnEnum;
+	u16 regDmn5GHz;
+	u16 regDmn2GHz;
+	u32 flags5GHz;
+	u32 flags2GHz;
+	u64 pscanMask;
+	u16 singleCC;
 };
 
 struct ccmap {
 	char isoName[3];
-	u_int16_t countryCode;
+	u16 countryCode;
 };
 
 struct country_code_to_enum_rd {
-	u_int16_t countryCode;
-	u_int16_t regDmnEnum;
+	u16 countryCode;
+	u16 regDmnEnum;
 	const char *isoName;
 	const char *name;
 	bool allow11g;
@@ -176,52 +176,52 @@ struct country_code_to_enum_rd {
 	bool allow11ng40;
 	bool allow11na20;
 	bool allow11na40;
-	u_int16_t outdoorChanStart;
+	u16 outdoorChanStart;
 };
 
 struct RegDmnFreqBand {
-	u_int16_t lowChannel;
-	u_int16_t highChannel;
-	u_int8_t powerDfs;
-	u_int8_t antennaMax;
-	u_int8_t channelBW;
-	u_int8_t channelSep;
-	u_int64_t useDfs;
-	u_int64_t usePassScan;
-	u_int8_t regClassId;
+	u16 lowChannel;
+	u16 highChannel;
+	u8 powerDfs;
+	u8 antennaMax;
+	u8 channelBW;
+	u8 channelSep;
+	u64 useDfs;
+	u64 usePassScan;
+	u8 regClassId;
 };
 
 struct regDomain {
-	u_int16_t regDmnEnum;
-	u_int8_t conformanceTestLimit;
-	u_int64_t dfsMask;
-	u_int64_t pscan;
-	u_int32_t flags;
-	u_int64_t chan11a[BMLEN];
-	u_int64_t chan11a_turbo[BMLEN];
-	u_int64_t chan11a_dyn_turbo[BMLEN];
-	u_int64_t chan11b[BMLEN];
-	u_int64_t chan11g[BMLEN];
-	u_int64_t chan11g_turbo[BMLEN];
+	u16 regDmnEnum;
+	u8 conformanceTestLimit;
+	u64 dfsMask;
+	u64 pscan;
+	u32 flags;
+	u64 chan11a[BMLEN];
+	u64 chan11a_turbo[BMLEN];
+	u64 chan11a_dyn_turbo[BMLEN];
+	u64 chan11b[BMLEN];
+	u64 chan11g[BMLEN];
+	u64 chan11g_turbo[BMLEN];
 };
 
 struct cmode {
-	u_int32_t mode;
-	u_int32_t flags;
+	u32 mode;
+	u32 flags;
 };
 
 #define YES true
 #define NO  false
 
 struct japan_bandcheck {
-	u_int16_t freqbandbit;
-	u_int32_t eepromflagtocheck;
+	u16 freqbandbit;
+	u32 eepromflagtocheck;
 };
 
 struct common_mode_power {
-	u_int16_t lchan;
-	u_int16_t hchan;
-	u_int8_t pwrlvl;
+	u16 lchan;
+	u16 hchan;
+	u8 pwrlvl;
 };
 
 enum CountryCode {
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index c6992f3..f0297ee 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -37,7 +37,7 @@
 
 #define OFDM_SIFS_TIME    	    16
 
-static u_int32_t bits_per_symbol[][2] = {
+static u32 bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
 	{    26,   54 },     /*  0: BPSK */
 	{    52,  108 },     /*  1: QPSK 1/2 */
@@ -198,7 +198,7 @@ static int ath_tx_findindex(const struct ath9k_rate_table *rt, int rate)
 /* Check if it's okay to send out aggregates */
 
 static int ath_aggr_query(struct ath_softc *sc,
-	struct ath_node *an, u_int8_t tidno)
+	struct ath_node *an, u8 tidno)
 {
 	struct ath_atx_tid *tid;
 	tid = ATH_AN_2_TID(an, tidno);
@@ -273,7 +273,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv;
 	int hdrlen;
-	u_int8_t rix, antenna;
+	u8 rix, antenna;
 	__le16 fc;
 	u8 *qc;
 
@@ -374,7 +374,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 			    (tx_info->flags & IEEE80211_TX_CTL_AMPDU));
 
 		if (is_multicast_ether_addr(hdr->addr1)) {
-			rcs[0].rix = (u_int8_t)
+			rcs[0].rix = (u8)
 				ath_tx_findindex(rt, txctl->mcast_rate);
 
 			/*
@@ -418,7 +418,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	 * layer but it lacks sufficient information to calculate it.
 	 */
 	if ((txctl->flags & ATH9K_TXDESC_NOACK) == 0 && !ieee80211_is_ctl(fc)) {
-		u_int16_t dur;
+		u16 dur;
 		/*
 		 * XXX not right with fragmentation.
 		 */
@@ -620,8 +620,8 @@ static int ath_tx_num_badfrms(struct ath_softc *sc,
 	int isnodegone = (an->an_flags & ATH_NODE_CLEAN);
 	struct ath_buf *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
-	u_int16_t seq_st = 0;
-	u_int32_t ba[WME_BA_BMP_SIZE >> 5];
+	u16 seq_st = 0;
+	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int ba_index;
 	int nbad = 0;
 	int isaggr = 0;
@@ -686,16 +686,16 @@ static void ath_tx_update_baw(struct ath_softc *sc,
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
 
-static u_int32_t ath_pkt_duration(struct ath_softc *sc,
-				  u_int8_t rix,
+static u32 ath_pkt_duration(struct ath_softc *sc,
+				  u8 rix,
 				  struct ath_buf *bf,
 				  int width,
 				  int half_gi,
 				  bool shortPreamble)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
-	u_int32_t nbits, nsymbits, duration, nsymbols;
-	u_int8_t rc;
+	u32 nbits, nsymbits, duration, nsymbols;
+	u8 rc;
 	int streams, pktlen;
 
 	pktlen = bf->bf_isaggr ? bf->bf_al : bf->bf_frmlen;
@@ -740,9 +740,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
 	struct ath9k_11n_rate_series series[4];
 	int i, flags, rtsctsena = 0, dynamic_mimops = 0;
-	u_int ctsduration = 0;
-	u_int8_t rix = 0, cix, ctsrate = 0;
-	u_int32_t aggr_limit_with_rts = sc->sc_rtsaggrlimit;
+	u32 ctsduration = 0;
+	u8 rix = 0, cix, ctsrate = 0;
+	u32 aggr_limit_with_rts = sc->sc_rtsaggrlimit;
 	struct ath_node *an = (struct ath_node *) bf->bf_node;
 
 	/*
@@ -1020,8 +1020,8 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	struct ath_desc *ds = bf_last->bf_desc;
 	struct ath_buf *bf_next, *bf_lastq = NULL;
 	struct list_head bf_head, bf_pending;
-	u_int16_t seq_st = 0;
-	u_int32_t ba[WME_BA_BMP_SIZE >> 5];
+	u16 seq_st = 0;
+	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
 	int isnodegone = (an->an_flags & ATH_NODE_CLEAN);
 
@@ -1560,15 +1560,15 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
  * returns aggr limit based on lowest of the rates
  */
 
-static u_int32_t ath_lookup_rate(struct ath_softc *sc,
+static u32 ath_lookup_rate(struct ath_softc *sc,
 				 struct ath_buf *bf)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_tx_info_priv *tx_info_priv;
-	u_int32_t max_4ms_framelen, frame_length;
-	u_int16_t aggr_limit, legacy = 0, maxampdu;
+	u32 max_4ms_framelen, frame_length;
+	u16 aggr_limit, legacy = 0, maxampdu;
 	int i;
 
 
@@ -1608,7 +1608,7 @@ static u_int32_t ath_lookup_rate(struct ath_softc *sc,
 		return 0;
 
 	aggr_limit = min(max_4ms_framelen,
-		(u_int32_t)ATH_AMPDU_LIMIT_DEFAULT);
+		(u32)ATH_AMPDU_LIMIT_DEFAULT);
 
 	/*
 	 * h/w can accept aggregates upto 16 bit lengths (65535).
@@ -1630,12 +1630,12 @@ static u_int32_t ath_lookup_rate(struct ath_softc *sc,
 
 static int ath_compute_num_delims(struct ath_softc *sc,
 				  struct ath_buf *bf,
-				  u_int16_t frmlen)
+				  u16 frmlen)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
-	u_int32_t nsymbits, nsymbols, mpdudensity;
-	u_int16_t minlen;
-	u_int8_t rc, flags, rix;
+	u32 nsymbits, nsymbols, mpdudensity;
+	u16 minlen;
+	u8 rc, flags, rix;
 	int width, half_gi, ndelim, mindelim;
 
 	/* Select standard number of delimiters based on frame length alone */
@@ -1708,7 +1708,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	struct ath_buf *bf, *tbf, *bf_first, *bf_prev = NULL;
 	struct list_head bf_head;
 	int rl = 0, nframes = 0, ndelim;
-	u_int16_t aggr_limit = 0, al = 0, bpad = 0,
+	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	int prev_al = 0, is_ds_rate = 0;
@@ -1982,7 +1982,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 static int ath_tx_start_dma(struct ath_softc *sc,
 			    struct sk_buff *skb,
 			    struct scatterlist *sg,
-			    u_int32_t n_sg,
+			    u32 n_sg,
 			    struct ath_tx_control *txctl)
 {
 	struct ath_node *an = txctl->an;
@@ -2048,7 +2048,7 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 			       ds,
 			       bf->bf_frmlen, /* frame length */
 			       txctl->atype, /* Atheros packet type */
-			       min(txctl->txpower, (u_int16_t)60), /* txpower */
+			       min(txctl->txpower, (u16)60), /* txpower */
 			       txctl->keyix,            /* key cache index */
 			       txctl->keytype,          /* key type */
 			       txctl->flags);           /* flags */
@@ -2423,9 +2423,9 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb)
 
 void ath_tx_tasklet(struct ath_softc *sc)
 {
-	u_int64_t tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	u64 tsf = ath9k_hw_gettsf64(sc->sc_ah);
 	int i, nacked = 0;
-	u_int32_t qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
+	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
 
 	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
 
@@ -2517,12 +2517,12 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 	ath_drain_txdataq(sc, retry_tx);
 }
 
-u_int32_t ath_txq_depth(struct ath_softc *sc, int qnum)
+u32 ath_txq_depth(struct ath_softc *sc, int qnum)
 {
 	return sc->sc_txq[qnum].axq_depth;
 }
 
-u_int32_t ath_txq_aggr_depth(struct ath_softc *sc, int qnum)
+u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum)
 {
 	return sc->sc_txq[qnum].axq_aggr_depth;
 }
@@ -2621,7 +2621,7 @@ int ath_tx_aggr_stop(struct ath_softc *sc,
  */
 
 void ath_tx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u_int8_t tid)
+	struct ath_node *an, u8 tid)
 {
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = &sc->sc_txq[txtid->ac->qnum];
-- 
1.5.6.rc2.15.g457bb.dirty

