Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25762 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYHBXtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/12] ath9k: We don't have a HAL anymore :)
Date: Sat, 2 Aug 2008 16:49:00 -0700
Message-ID: <1217720944-23234-9-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014935_337700_E61A48E3)
In-Reply-To: <1217720944-23234-8-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-8-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Replace a bunch of macros with ATH9K prefixes.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |  455 +++++++++++++++-----------------
 drivers/net/wireless/ath9k/beacon.c |   68 +++---
 drivers/net/wireless/ath9k/core.c   |  145 ++++++-----
 drivers/net/wireless/ath9k/core.h   |   41 ++--
 drivers/net/wireless/ath9k/hw.c     |  499 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/hw.h     |   50 ++--
 drivers/net/wireless/ath9k/main.c   |   56 ++--
 drivers/net/wireless/ath9k/phy.c    |    6 +-
 drivers/net/wireless/ath9k/rc.c     |    2 +-
 drivers/net/wireless/ath9k/recv.c   |   30 +-
 drivers/net/wireless/ath9k/regd.c   |    6 +-
 drivers/net/wireless/ath9k/regd.h   |    2 +-
 drivers/net/wireless/ath9k/xmit.c   |  148 +++++-----
 13 files changed, 744 insertions(+), 764 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 4965afb..265d9a5 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -116,8 +116,8 @@ struct ath_rx_status {
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
 
-#define	HAL_RXKEYIX_INVALID	((u_int8_t)-1)
-#define	HAL_TXKEYIX_INVALID	((u_int)-1)
+#define ATH9K_RXKEYIX_INVALID	((u_int8_t)-1)
+#define ATH9K_TXKEYIX_INVALID	((u_int)-1)
 
 struct ath_desc {
 	u_int32_t ds_link;
@@ -137,18 +137,18 @@ struct ath_desc {
 #define	ds_rxstat	ds_us.rx
 #define ds_stat		ds_us.stats
 
-#define	HAL_TXDESC_CLRDMASK	0x0001
-#define	HAL_TXDESC_NOACK	0x0002
-#define	HAL_TXDESC_RTSENA	0x0004
-#define	HAL_TXDESC_CTSENA	0x0008
-#define	HAL_TXDESC_INTREQ	0x0010
-#define	HAL_TXDESC_VEOL		0x0020
-#define HAL_TXDESC_EXT_ONLY     0x0040
-#define HAL_TXDESC_EXT_AND_CTL  0x0080
-#define HAL_TXDESC_VMF          0x0100
-#define HAL_TXDESC_FRAG_IS_ON   0x0200
+#define ATH9K_TXDESC_CLRDMASK		0x0001
+#define ATH9K_TXDESC_NOACK		0x0002
+#define ATH9K_TXDESC_RTSENA		0x0004
+#define ATH9K_TXDESC_CTSENA		0x0008
+#define ATH9K_TXDESC_INTREQ		0x0010
+#define ATH9K_TXDESC_VEOL		0x0020
+#define ATH9K_TXDESC_EXT_ONLY		0x0040
+#define ATH9K_TXDESC_EXT_AND_CTL	0x0080
+#define ATH9K_TXDESC_VMF		0x0100
+#define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
 
-#define	HAL_RXDESC_INTREQ	0x0020
+#define ATH9K_RXDESC_INTREQ		0x0020
 
 enum hal_capability_type {
 	HAL_CAP_CIPHER = 0,
@@ -253,26 +253,26 @@ struct hal_ops_config {
 	u_int16_t ath_hal_spurChans[AR_EEPROM_MODAL_SPURS][2];
 };
 
-enum hal_tx_queue {
-	HAL_TX_QUEUE_INACTIVE = 0,
-	HAL_TX_QUEUE_DATA,
-	HAL_TX_QUEUE_BEACON,
-	HAL_TX_QUEUE_CAB,
-	HAL_TX_QUEUE_UAPSD,
-	HAL_TX_QUEUE_PSPOLL
+enum ath9k_tx_queue {
+	ATH9K_TX_QUEUE_INACTIVE = 0,
+	ATH9K_TX_QUEUE_DATA,
+	ATH9K_TX_QUEUE_BEACON,
+	ATH9K_TX_QUEUE_CAB,
+	ATH9K_TX_QUEUE_UAPSD,
+	ATH9K_TX_QUEUE_PSPOLL
 };
 
-#define	HAL_NUM_TX_QUEUES 10
+#define	ATH9K_NUM_TX_QUEUES 10
 
-enum hal_tx_queue_subtype {
-	HAL_WME_AC_BK = 0,
-	HAL_WME_AC_BE,
-	HAL_WME_AC_VI,
-	HAL_WME_AC_VO,
-	HAL_WME_UPSD
+enum ath9k_tx_queue_subtype {
+	ATH9K_WME_AC_BK = 0,
+	ATH9K_WME_AC_BE,
+	ATH9K_WME_AC_VI,
+	ATH9K_WME_AC_VO,
+	ATH9K_WME_UPSD
 };
 
-enum hal_tx_queue_flags {
+enum ath9k_tx_queue_flags {
 	TXQ_FLAG_TXOKINT_ENABLE = 0x0001,
 	TXQ_FLAG_TXERRINT_ENABLE = 0x0001,
 	TXQ_FLAG_TXDESCINT_ENABLE = 0x0002,
@@ -284,10 +284,10 @@ enum hal_tx_queue_flags {
 	TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE = 0x0080,
 };
 
-struct hal_txq_info {
+struct ath9k_txq_info {
 	u_int32_t tqi_ver;
-	enum hal_tx_queue_subtype tqi_subtype;
-	enum hal_tx_queue_flags tqi_qflags;
+	enum ath9k_tx_queue_subtype tqi_subtype;
+	enum ath9k_tx_queue_flags tqi_qflags;
 	u_int32_t tqi_priority;
 	u_int32_t tqi_aifs;
 	u_int32_t tqi_cwmin;
@@ -301,32 +301,27 @@ struct hal_txq_info {
 	u_int32_t tqi_compBuf;
 };
 
-#define HAL_TQI_NONVAL 0xffff
+#define ATH9K_TXQ_USEDEFAULT ((u_int32_t) -1)
 
-#define	HAL_TXQ_USEDEFAULT ((u_int32_t) -1)
+#define ATH9K_DECOMP_MASK_SIZE     128
+#define ATH9K_READY_TIME_LO_BOUND  50
+#define ATH9K_READY_TIME_HI_BOUND  96
 
-#define HAL_COMP_BUF_MAX_SIZE    9216
-#define HAL_COMP_BUF_ALIGN_SIZE  512
-#define HAL_DECOMP_MASK_SIZE     128
-
-#define HAL_READY_TIME_LO_BOUND  50
-#define HAL_READY_TIME_HI_BOUND  96
-
-enum hal_pkt_type {
-	HAL_PKT_TYPE_NORMAL = 0,
-	HAL_PKT_TYPE_ATIM,
-	HAL_PKT_TYPE_PSPOLL,
-	HAL_PKT_TYPE_BEACON,
-	HAL_PKT_TYPE_PROBE_RESP,
-	HAL_PKT_TYPE_CHIRP,
-	HAL_PKT_TYPE_GRP_POLL,
+enum ath9k_pkt_type {
+	ATH9K_PKT_TYPE_NORMAL = 0,
+	ATH9K_PKT_TYPE_ATIM,
+	ATH9K_PKT_TYPE_PSPOLL,
+	ATH9K_PKT_TYPE_BEACON,
+	ATH9K_PKT_TYPE_PROBE_RESP,
+	ATH9K_PKT_TYPE_CHIRP,
+	ATH9K_PKT_TYPE_GRP_POLL,
 };
 
-struct hal_tx_queue_info {
+struct ath9k_tx_queue_info {
 	u_int32_t tqi_ver;
-	enum hal_tx_queue tqi_type;
-	enum hal_tx_queue_subtype tqi_subtype;
-	enum hal_tx_queue_flags tqi_qflags;
+	enum ath9k_tx_queue tqi_type;
+	enum ath9k_tx_queue_subtype tqi_subtype;
+	enum ath9k_tx_queue_flags tqi_qflags;
 	u_int32_t tqi_priority;
 	u_int32_t tqi_aifs;
 	u_int32_t tqi_cwmin;
@@ -341,59 +336,64 @@ struct hal_tx_queue_info {
 	u_int32_t tqi_intFlags;
 };
 
-enum hal_rx_filter {
-	HAL_RX_FILTER_UCAST = 0x00000001,
-	HAL_RX_FILTER_MCAST = 0x00000002,
-	HAL_RX_FILTER_BCAST = 0x00000004,
-	HAL_RX_FILTER_CONTROL = 0x00000008,
-	HAL_RX_FILTER_BEACON = 0x00000010,
-	HAL_RX_FILTER_PROM = 0x00000020,
-	HAL_RX_FILTER_PROBEREQ = 0x00000080,
-	HAL_RX_FILTER_PSPOLL = 0x00004000,
-	HAL_RX_FILTER_PHYERR = 0x00000100,
-	HAL_RX_FILTER_PHYRADAR = 0x00002000,
+enum ath9k_rx_filter {
+	ATH9K_RX_FILTER_UCAST = 0x00000001,
+	ATH9K_RX_FILTER_MCAST = 0x00000002,
+	ATH9K_RX_FILTER_BCAST = 0x00000004,
+	ATH9K_RX_FILTER_CONTROL = 0x00000008,
+	ATH9K_RX_FILTER_BEACON = 0x00000010,
+	ATH9K_RX_FILTER_PROM = 0x00000020,
+	ATH9K_RX_FILTER_PROBEREQ = 0x00000080,
+	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
+	ATH9K_RX_FILTER_PHYERR = 0x00000100,
+	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
 };
 
-enum hal_int {
-	HAL_INT_RX = 0x00000001,
-	HAL_INT_RXDESC = 0x00000002,
-	HAL_INT_RXNOFRM = 0x00000008,
-	HAL_INT_RXEOL = 0x00000010,
-	HAL_INT_RXORN = 0x00000020,
-	HAL_INT_TX = 0x00000040,
-	HAL_INT_TXDESC = 0x00000080,
-	HAL_INT_TIM_TIMER = 0x00000100,
-	HAL_INT_TXURN = 0x00000800,
-	HAL_INT_MIB = 0x00001000,
-	HAL_INT_RXPHY = 0x00004000,
-	HAL_INT_RXKCM = 0x00008000,
-	HAL_INT_SWBA = 0x00010000,
-	HAL_INT_BMISS = 0x00040000,
-	HAL_INT_BNR = 0x00100000,
-	HAL_INT_TIM = 0x00200000,
-	HAL_INT_DTIM = 0x00400000,
-	HAL_INT_DTIMSYNC = 0x00800000,
-	HAL_INT_GPIO = 0x01000000,
-	HAL_INT_CABEND = 0x02000000,
-	HAL_INT_CST = 0x10000000,
-	HAL_INT_GTT = 0x20000000,
-	HAL_INT_FATAL = 0x40000000,
-	HAL_INT_GLOBAL = 0x80000000,
-	HAL_INT_BMISC = HAL_INT_TIM
-	    | HAL_INT_DTIM | HAL_INT_DTIMSYNC | HAL_INT_CABEND,
-	HAL_INT_COMMON = HAL_INT_RXNOFRM
-	    | HAL_INT_RXDESC
-	    | HAL_INT_RXEOL
-	    | HAL_INT_RXORN
-	    | HAL_INT_TXURN
-	    | HAL_INT_TXDESC
-	    | HAL_INT_MIB
-	    | HAL_INT_RXPHY
-	    | HAL_INT_RXKCM | HAL_INT_SWBA | HAL_INT_BMISS | HAL_INT_GPIO,
-	HAL_INT_NOCARD = 0xffffffff
+enum ath9k_int {
+	ATH9K_INT_RX = 0x00000001,
+	ATH9K_INT_RXDESC = 0x00000002,
+	ATH9K_INT_RXNOFRM = 0x00000008,
+	ATH9K_INT_RXEOL = 0x00000010,
+	ATH9K_INT_RXORN = 0x00000020,
+	ATH9K_INT_TX = 0x00000040,
+	ATH9K_INT_TXDESC = 0x00000080,
+	ATH9K_INT_TIM_TIMER = 0x00000100,
+	ATH9K_INT_TXURN = 0x00000800,
+	ATH9K_INT_MIB = 0x00001000,
+	ATH9K_INT_RXPHY = 0x00004000,
+	ATH9K_INT_RXKCM = 0x00008000,
+	ATH9K_INT_SWBA = 0x00010000,
+	ATH9K_INT_BMISS = 0x00040000,
+	ATH9K_INT_BNR = 0x00100000,
+	ATH9K_INT_TIM = 0x00200000,
+	ATH9K_INT_DTIM = 0x00400000,
+	ATH9K_INT_DTIMSYNC = 0x00800000,
+	ATH9K_INT_GPIO = 0x01000000,
+	ATH9K_INT_CABEND = 0x02000000,
+	ATH9K_INT_CST = 0x10000000,
+	ATH9K_INT_GTT = 0x20000000,
+	ATH9K_INT_FATAL = 0x40000000,
+	ATH9K_INT_GLOBAL = 0x80000000,
+	ATH9K_INT_BMISC = ATH9K_INT_TIM |
+		ATH9K_INT_DTIM |
+		ATH9K_INT_DTIMSYNC |
+		ATH9K_INT_CABEND,
+	ATH9K_INT_COMMON = ATH9K_INT_RXNOFRM |
+		ATH9K_INT_RXDESC |
+		ATH9K_INT_RXEOL |
+		ATH9K_INT_RXORN |
+		ATH9K_INT_TXURN |
+		ATH9K_INT_TXDESC |
+		ATH9K_INT_MIB |
+		ATH9K_INT_RXPHY |
+		ATH9K_INT_RXKCM |
+		ATH9K_INT_SWBA |
+		ATH9K_INT_BMISS |
+		ATH9K_INT_GPIO,
+	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-struct hal_rate_table {
+struct ath9k_rate_table {
 	int rateCount;
 	u_int8_t rateCodeToIndex[256];
 	struct {
@@ -409,11 +409,11 @@ struct hal_rate_table {
 	} info[32];
 };
 
-#define HAL_RATESERIES_RTS_CTS  0x0001
-#define HAL_RATESERIES_2040     0x0002
-#define HAL_RATESERIES_HALFGI   0x0004
+#define ATH9K_RATESERIES_RTS_CTS  0x0001
+#define ATH9K_RATESERIES_2040     0x0002
+#define ATH9K_RATESERIES_HALFGI   0x0004
 
-struct hal_11n_rate_series {
+struct ath9k_11n_rate_series {
 	u_int Tries;
 	u_int Rate;
 	u_int PktDuration;
@@ -476,15 +476,10 @@ struct ath9k_channel {
 	u_int32_t regDmnFlags;
 	u_int32_t conformanceTestLimit[3]; /* 0:11a, 1: 11b, 2:11g */
 #ifdef ATH_NF_PER_CHAN
-	struct hal_nfcal_hist nfCalHist[NUM_NF_READINGS];
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
 };
 
-#define HAL_SPUR_VAL_MASK       0x3FFF
-#define HAL_SPUR_CHAN_WIDTH     87
-#define HAL_BIN_WIDTH_BASE_100HZ    3125
-#define HAL_MAX_BINS_ALLOWED        28
-
 #define IS_CHAN_A(_c) ((((_c)->channelFlags & CHANNEL_A) == CHANNEL_A) || \
        (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
        (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
@@ -517,7 +512,7 @@ struct ath9k_channel {
 	 (((_c)->channel % 20) != 0) &&			\
 	 (((_c)->channel % 10) != 0))
 
-struct hal_keyval {
+struct ath9k_keyval {
 	u_int8_t kv_type;
 	u_int8_t kv_pad;
 	u_int16_t kv_len;
@@ -526,21 +521,21 @@ struct hal_keyval {
 	u_int8_t kv_txmic[8];
 };
 
-enum hal_key_type {
-	HAL_KEY_TYPE_CLEAR,
-	HAL_KEY_TYPE_WEP,
-	HAL_KEY_TYPE_AES,
-	HAL_KEY_TYPE_TKIP,
+enum ath9k_key_type {
+	ATH9K_KEY_TYPE_CLEAR,
+	ATH9K_KEY_TYPE_WEP,
+	ATH9K_KEY_TYPE_AES,
+	ATH9K_KEY_TYPE_TKIP,
 };
 
-enum hal_cipher {
-	HAL_CIPHER_WEP = 0,
-	HAL_CIPHER_AES_OCB = 1,
-	HAL_CIPHER_AES_CCM = 2,
-	HAL_CIPHER_CKIP = 3,
-	HAL_CIPHER_TKIP = 4,
-	HAL_CIPHER_CLR = 5,
-	HAL_CIPHER_MIC = 127
+enum ath9k_cipher {
+	ATH9K_CIPHER_WEP = 0,
+	ATH9K_CIPHER_AES_OCB = 1,
+	ATH9K_CIPHER_AES_CCM = 2,
+	ATH9K_CIPHER_CKIP = 3,
+	ATH9K_CIPHER_TKIP = 4,
+	ATH9K_CIPHER_CLR = 5,
+	ATH9K_CIPHER_MIC = 127
 };
 
 #define AR_EEPROM_EEPCAP_COMPRESS_DIS   0x0001
@@ -583,10 +578,8 @@ enum hal_cipher {
 #define AR_EEPROM_RFSILENT_POLARITY     0x0002
 #define AR_EEPROM_RFSILENT_POLARITY_S   1
 
-enum {
-	CTRY_DEBUG = 0x1ff,
-	CTRY_DEFAULT = 0
-};
+#define CTRY_DEBUG 0x1ff
+#define	CTRY_DEFAULT 0
 
 enum reg_ext_bitmap {
 	REG_EXT_JAPAN_MIDBAND = 1,
@@ -595,7 +588,7 @@ enum reg_ext_bitmap {
 	REG_EXT_JAPAN_DFS_HT40 = 4
 };
 
-struct hal_country_entry {
+struct ath9k_country_entry {
 	u_int16_t countryCode;
 	u_int16_t regDmnEnum;
 	u_int16_t regDmn5G;
@@ -619,10 +612,10 @@ struct hal_country_entry {
 #define REG_CLR_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
 
-#define HAL_COMP_BUF_MAX_SIZE   9216
-#define HAL_COMP_BUF_ALIGN_SIZE 512
+#define ATH9K_COMP_BUF_MAX_SIZE   9216
+#define ATH9K_COMP_BUF_ALIGN_SIZE 512
 
-#define HAL_TXQ_USE_LOCKOUT_BKOFF_DIS   0x00000001
+#define ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS   0x00000001
 
 #define INIT_AIFS       2
 #define INIT_CWMIN      15
@@ -684,17 +677,11 @@ enum hal_status {
 	HAL_EINPROGRESS
 };
 
-enum hal_power_mode {
-	HAL_PM_AWAKE = 0,
-	HAL_PM_FULL_SLEEP,
-	HAL_PM_NETWORK_SLEEP,
-	HAL_PM_UNDEFINED
-};
-
-enum hal_rfgain {
-	HAL_RFGAIN_INACTIVE = 0,
-	HAL_RFGAIN_READ_REQUESTED,
-	HAL_RFGAIN_NEED_CHANGE
+enum ath9k_power_mode {
+	ATH9K_PM_AWAKE = 0,
+	ATH9K_PM_FULL_SLEEP,
+	ATH9K_PM_NETWORK_SLEEP,
+	ATH9K_PM_UNDEFINED
 };
 
 #define HAL_ANTENNA_MIN_MODE  0
@@ -702,7 +689,7 @@ enum hal_rfgain {
 #define HAL_ANTENNA_FIXED_B   2
 #define HAL_ANTENNA_MAX_MODE  3
 
-struct hal_mib_stats {
+struct ath9k_mib_stats {
 	u_int32_t ackrcv_bad;
 	u_int32_t rts_bad;
 	u_int32_t rts_good;
@@ -710,39 +697,36 @@ struct hal_mib_stats {
 	u_int32_t beacons;
 };
 
-enum hal_ant_setting {
-	HAL_ANT_VARIABLE = 0,
-	HAL_ANT_FIXED_A,
-	HAL_ANT_FIXED_B
+enum ath9k_ant_setting {
+	ATH9K_ANT_VARIABLE = 0,
+	ATH9K_ANT_FIXED_A,
+	ATH9K_ANT_FIXED_B
 };
 
-enum hal_opmode {
-	HAL_M_STA = 1,
-	HAL_M_IBSS = 0,
-	HAL_M_HOSTAP = 6,
-	HAL_M_MONITOR = 8
-};
-
-enum {
-	HAL_SLOT_TIME_6 = 6,
-	HAL_SLOT_TIME_9 = 9,
-	HAL_SLOT_TIME_20 = 20,
+enum ath9k_opmode {
+	ATH9K_M_STA = 1,
+	ATH9K_M_IBSS = 0,
+	ATH9K_M_HOSTAP = 6,
+	ATH9K_M_MONITOR = 8
 };
 
+#define ATH9K_SLOT_TIME_6 6
+#define ATH9K_SLOT_TIME_9 9
+#define ATH9K_SLOT_TIME_20 20
 
-enum hal_ht_macmode {
-	HAL_HT_MACMODE_20 = 0,
-	HAL_HT_MACMODE_2040 = 1,
+enum ath9k_ht_macmode {
+	ATH9K_HT_MACMODE_20 = 0,
+	ATH9K_HT_MACMODE_2040 = 1,
 };
 
-enum hal_ht_extprotspacing {
-	HAL_HT_EXTPROTSPACING_20 = 0,
-	HAL_HT_EXTPROTSPACING_25 = 1,
+enum ath9k_ht_extprotspacing {
+	ATH9K_HT_EXTPROTSPACING_20 = 0,
+	ATH9K_HT_EXTPROTSPACING_25 = 1,
 };
 
-struct hal_ht_cwm {
-	enum hal_ht_macmode ht_macmode;
-	enum hal_ht_extprotspacing ht_extprotspacing;
+struct ath9k_ht_cwm {
+	enum ath9k_ht_macmode ht_macmode;
+	enum ath9k_ht_extprotspacing ht_extprotspacing;
 };
 
 enum hal_freq_band {
@@ -750,25 +734,16 @@ enum hal_freq_band {
 	HAL_FREQ_BAND_2GHZ = 1,
 };
 
-enum {
-	HAL_TRUE_CHIP = 1
-};
-
-enum hal_bus_type {
-	HAL_BUS_TYPE_PCI,
-	HAL_BUS_TYPE_AHB
-};
-
-enum hal_ani_cmd {
-	HAL_ANI_PRESENT = 0x1,
-	HAL_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
-	HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION = 0x4,
-	HAL_ANI_CCK_WEAK_SIGNAL_THR = 0x8,
-	HAL_ANI_FIRSTEP_LEVEL = 0x10,
-	HAL_ANI_SPUR_IMMUNITY_LEVEL = 0x20,
-	HAL_ANI_MODE = 0x40,
-	HAL_ANI_PHYERR_RESET = 0x80,
-	HAL_ANI_ALL = 0xff
+enum ath9k_ani_cmd {
+	ATH9K_ANI_PRESENT = 0x1,
+	ATH9K_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
+	ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION = 0x4,
+	ATH9K_ANI_CCK_WEAK_SIGNAL_THR = 0x8,
+	ATH9K_ANI_FIRSTEP_LEVEL = 0x10,
+	ATH9K_ANI_SPUR_IMMUNITY_LEVEL = 0x20,
+	ATH9K_ANI_MODE = 0x40,
+	ATH9K_ANI_PHYERR_RESET = 0x80,
+	ATH9K_ANI_ALL = 0xff
 };
 
 enum phytype {
@@ -787,12 +762,12 @@ enum start_adhoc_option {
 	START_ADHOC_IN_11B,
 };
 
-enum hal_tp_scale {
-	HAL_TP_SCALE_MAX = 0,
-	HAL_TP_SCALE_50,
-	HAL_TP_SCALE_25,
-	HAL_TP_SCALE_12,
-	HAL_TP_SCALE_MIN
+enum ath9k_tp_scale {
+	ATH9K_TP_SCALE_MAX = 0,
+	ATH9K_TP_SCALE_50,
+	ATH9K_TP_SCALE_25,
+	ATH9K_TP_SCALE_12,
+	ATH9K_TP_SCALE_MIN
 };
 
 enum ser_reg_mode {
@@ -807,23 +782,23 @@ enum ser_reg_mode {
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
-#define HAL_NF_CAL_HIST_MAX             5
+#define ATH9K_NF_CAL_HIST_MAX           5
 #define NUM_NF_READINGS                 6
 
-struct hal_nfcal_hist {
-	int16_t nfCalBuffer[HAL_NF_CAL_HIST_MAX];
+struct ath9k_nfcal_hist {
+	int16_t nfCalBuffer[ATH9K_NF_CAL_HIST_MAX];
 	u_int8_t currIndex;
 	int16_t privNF;
 	u_int8_t invalidNFcount;
 };
 
-struct hal_beacon_state {
+struct ath9k_beacon_state {
 	u_int32_t bs_nexttbtt;
 	u_int32_t bs_nextdtim;
 	u_int32_t bs_intval;
-#define HAL_BEACON_PERIOD       0x0000ffff
-#define HAL_BEACON_ENA          0x00800000
-#define HAL_BEACON_RESET_TSF    0x01000000
+#define ATH9K_BEACON_PERIOD       0x0000ffff
+#define ATH9K_BEACON_ENA          0x00800000
+#define ATH9K_BEACON_RESET_TSF    0x01000000
 	u_int32_t bs_dtimperiod;
 	u_int16_t bs_cfpperiod;
 	u_int16_t bs_cfpmaxduration;
@@ -833,33 +808,31 @@ struct hal_beacon_state {
 	u_int32_t bs_sleepduration;
 };
 
-struct hal_node_stats {
+struct ath9k_node_stats {
 	u_int32_t ns_avgbrssi;
 	u_int32_t ns_avgrssi;
 	u_int32_t ns_avgtxrssi;
 	u_int32_t ns_avgtxrate;
 };
 
-#define HAL_RSSI_EP_MULTIPLIER  (1<<7)
-#define HAL_RATE_EP_MULTIPLIER  (1<<7)
+#define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
 
-enum hal_gpio_output_mux_type {
-	HAL_GPIO_OUTPUT_MUX_AS_OUTPUT,
-	HAL_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED,
-	HAL_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED,
-	HAL_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED,
-	HAL_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED,
-	HAL_GPIO_OUTPUT_MUX_NUM_ENTRIES
+enum ath9k_gpio_output_mux_type {
+	ATH9K_GPIO_OUTPUT_MUX_AS_OUTPUT,
+	ATH9K_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED,
+	ATH9K_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED,
+	ATH9K_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED,
+	ATH9K_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED,
+	ATH9K_GPIO_OUTPUT_MUX_NUM_ENTRIES
 };
 
 enum {
-	HAL_RESET_POWER_ON,
-	HAL_RESET_WARM,
-	HAL_RESET_COLD,
+	ATH9K_RESET_POWER_ON,
+	ATH9K_RESET_WARM,
+	ATH9K_RESET_COLD,
 };
 
 #define AH_USE_EEPROM   0x1
-#define AH_IS_HB63      0x2
 
 struct ath_hal {
 	u_int32_t ah_magic;
@@ -873,9 +846,9 @@ struct ath_hal {
 	u_int16_t ah_phyRev;
 	u_int16_t ah_analog5GhzRev;
 	u_int16_t ah_analog2GhzRev;
-	u_int8_t ah_decompMask[HAL_DECOMP_MASK_SIZE];
+	u_int8_t ah_decompMask[ATH9K_DECOMP_MASK_SIZE];
 	u_int32_t ah_flags;
-	enum hal_opmode ah_opmode;
+	enum ath9k_opmode ah_opmode;
 	struct hal_ops_config ah_config;
 	struct hal_capabilities ah_caps;
 	int16_t ah_powerLimit;
@@ -897,7 +870,7 @@ struct ath_hal {
 	bool ah_isPciExpress;
 	u_int16_t ah_txTrigLevel;
 #ifndef ATH_NF_PER_CHAN
-	struct hal_nfcal_hist nfCalHist[NUM_NF_READINGS];
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
 };
 
@@ -942,7 +915,7 @@ enum hal_status ath_hal_getcapability(struct ath_hal *ah,
 				      enum hal_capability_type type,
 				      u_int32_t capability,
 				      u_int32_t *result);
-const struct hal_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
+const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 						   u_int mode);
 void ath9k_hw_detach(struct ath_hal *ah);
 struct ath_hal *ath9k_hw_attach(u_int16_t devid,
@@ -957,20 +930,20 @@ bool ath9k_regd_init_channels(struct ath_hal *ah,
 			      bool enableOutdoor,
 			      bool enableExtendedChannels);
 u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
-enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah,
-				     enum hal_int ints);
-bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah,
+				     enum ath9k_int ints);
+bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    struct ath9k_channel *chan,
-		    enum hal_ht_macmode macmode,
+		    enum ath9k_ht_macmode macmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
-		    enum hal_ht_extprotspacing extprotspacing,
+		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
 		    enum hal_status *status);
 bool ath9k_hw_phy_disable(struct ath_hal *ah);
 void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 			     bool *isCalDone);
 void ath9k_hw_ani_monitor(struct ath_hal *ah,
-			  const struct hal_node_stats *stats,
+			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hal *ah,
 			struct ath9k_channel *chan,
@@ -991,20 +964,20 @@ bool ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 			const u_int8_t *mac);
 bool ath9k_hw_set_keycache_entry(struct ath_hal *ah,
 				 u_int16_t entry,
-				 const struct hal_keyval *k,
+				 const struct ath9k_keyval *k,
 				 const u_int8_t *mac,
 				 int xorKey);
 bool ath9k_hw_set_tsfadjust(struct ath_hal *ah,
 			    u_int32_t setting);
 void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
 bool ath9k_hw_intrpend(struct ath_hal *ah);
-bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked);
+bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked);
 bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah,
 				bool bIncTrigLevel);
 void ath9k_hw_procmibevent(struct ath_hal *ah,
-			   const struct hal_node_stats *stats);
+			   const struct ath9k_node_stats *stats);
 bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
-void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum hal_ht_macmode mode);
+void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
 bool ath9k_hw_phycounters(struct ath_hal *ah);
 bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry);
 bool ath9k_hw_getcapability(struct ath_hal *ah,
@@ -1022,13 +995,13 @@ void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask);
 bool ath9k_hw_setbssidmask(struct ath_hal *ah,
 			   const u_int8_t *mask);
 bool ath9k_hw_setpower(struct ath_hal *ah,
-		       enum hal_power_mode mode);
-enum hal_int ath9k_hw_intrget(struct ath_hal *ah);
+		       enum ath9k_power_mode mode);
+enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah);
 u_int64_t ath9k_hw_gettsf64(struct ath_hal *ah);
 u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
 bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us);
 bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
-			       enum hal_ant_setting settings,
+			       enum ath9k_ant_setting settings,
 			       struct ath9k_channel *chan,
 			       u_int8_t *tx_chainmask,
 			       u_int8_t *rx_chainmask,
@@ -1040,14 +1013,14 @@ bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
 		       u_int32_t txdp);
 bool ath9k_hw_txstart(struct ath_hal *ah, u_int q);
 u_int16_t ath9k_hw_computetxtime(struct ath_hal *ah,
-				 const struct hal_rate_table *rates,
+				 const struct ath9k_rate_table *rates,
 				 u_int32_t frameLen, u_int16_t rateix,
 				 bool shortPreamble);
 void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
 				  u_int durUpdateEn, u_int rtsctsRate,
 				  u_int rtsctsDuration,
-				  struct hal_11n_rate_series series[],
+				  struct ath9k_11n_rate_series series[],
 				  u_int nseries, u_int flags);
 void ath9k_hw_set11n_burstduration(struct ath_hal *ah,
 				   struct ath_desc *ds,
@@ -1060,15 +1033,15 @@ u_int ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 				     struct ath9k_channel *chan);
 u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
 bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
-			      struct hal_txq_info *qInfo);
+			      struct ath9k_txq_info *qInfo);
 bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-			      const struct hal_txq_info *qInfo);
+			      const struct ath9k_txq_info *qInfo);
 struct ath9k_channel *ath9k_regd_check_channel(struct ath_hal *ah,
 					      const struct ath9k_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-			    u_int pktLen, enum hal_pkt_type type,
+			    u_int pktLen, enum ath9k_pkt_type type,
 			    u_int txPower, u_int keyIx,
-			    enum hal_key_type keyType, u_int flags);
+			    enum ath9k_key_type keyType, u_int flags);
 bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
 			 u_int segLen, bool firstSeg,
 			 bool lastSeg,
@@ -1081,7 +1054,7 @@ void ath9k_hw_dmaRegDump(struct ath_hal *ah);
 void ath9k_hw_beaconinit(struct ath_hal *ah,
 			 u_int32_t next_beacon, u_int32_t beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
-				    const struct hal_beacon_state *bs);
+				    const struct ath9k_beacon_state *bs);
 bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 			  u_int32_t size, u_int flags);
 void ath9k_hw_putrxbuf(struct ath_hal *ah, u_int32_t rxdp);
@@ -1112,8 +1085,8 @@ void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah,
 				     struct ath_desc *ds, u_int vmf);
 bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit);
 bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah);
-int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
-			  const struct hal_txq_info *qInfo);
+int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
+			  const struct ath9k_txq_info *qInfo);
 u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q);
 const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid);
 bool ath9k_hw_disable(struct ath_hal *ah);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 596591e..e26f184 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -29,10 +29,10 @@
 static int ath_beaconq_config(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 
 	ath9k_hw_gettxqueueprops(ah, sc->sc_bhalq, &qi);
-	if (sc->sc_opmode == HAL_M_HOSTAP) {
+	if (sc->sc_opmode == ATH9K_M_HOSTAP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
@@ -70,11 +70,11 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	int flags, antenna;
-	const struct hal_rate_table *rt;
+	const struct ath9k_rate_table *rt;
 	u_int8_t rix, rate;
 	int ctsrate = 0;
 	int ctsduration = 0;
-	struct hal_11n_rate_series  series[4];
+	struct ath9k_11n_rate_series  series[4];
 
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: m %p len %u\n",
 		__func__, skb, skb->len);
@@ -82,11 +82,11 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	/* setup descriptors */
 	ds = bf->bf_desc;
 
-	flags = HAL_TXDESC_NOACK;
+	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_opmode == HAL_M_IBSS && ah->ah_caps.halVEOLSupport) {
+	if (sc->sc_opmode == ATH9K_M_IBSS && ah->ah_caps.halVEOLSupport) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
-		flags |= HAL_TXDESC_VEOL;
+		flags |= ATH9K_TXDESC_VEOL;
 		/* Let hardware handle antenna switching. */
 		antenna = 0;
 	} else {
@@ -114,10 +114,10 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	ath9k_hw_set11n_txdesc(ah, ds
 			      , skb->len + FCS_LEN /* frame length */
-			      , HAL_PKT_TYPE_BEACON /* Atheros packet type */
+			      , ATH9K_PKT_TYPE_BEACON /* Atheros packet type */
 			      , avp->av_btxctl.txpower /* txpower XXX */
-			      , HAL_TXKEYIX_INVALID /* no encryption */
-			      , HAL_KEY_TYPE_CLEAR /* no encryption */
+			      , ATH9K_TXKEYIX_INVALID /* no encryption */
+			      , ATH9K_KEY_TYPE_CLEAR /* no encryption */
 			      , flags /* no ack, veol for beacons */
 		);
 
@@ -129,11 +129,11 @@ static void ath_beacon_setup(struct ath_softc *sc,
 			   , ds /* first descriptor */
 		);
 
-	memzero(series, sizeof(struct hal_11n_rate_series) * 4);
+	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
 	series[0].ChSel = sc->sc_tx_chainmask;
-	series[0].RateFlags = (ctsrate) ? HAL_RATESERIES_RTS_CTS : 0;
+	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0,
 		ctsrate, ctsduration, series, 4, 0);
 }
@@ -325,7 +325,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 /*
  *  Setup a h/w transmit queue for beacons.
  *
- *  This function allocates an information structure (struct hal_txq_info)
+ *  This function allocates an information structure (struct ath9k_txq_info)
  *  on the stack, sets some specific parameters (zero out channel width
  *  min/max, and enable aifs). The info structure does not need to be
  *  persistant.
@@ -333,14 +333,14 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 
 int ath_beaconq_setup(struct ath_hal *ah)
 {
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 
 	memzero(&qi, sizeof(qi));
 	qi.tqi_aifs = 1;
 	qi.tqi_cwmin = 0;
 	qi.tqi_cwmax = 0;
 	/* NB: don't enable any interrupts */
-	return ath9k_hw_setuptxqueue(ah, HAL_TX_QUEUE_BEACON, &qi);
+	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 
 
@@ -373,7 +373,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 				struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_opmode == HAL_M_HOSTAP ||
+		if (sc->sc_opmode == ATH9K_M_HOSTAP ||
 			!sc->sc_ah->ah_caps.halVEOLSupport) {
 			int slot;
 			/*
@@ -743,7 +743,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	struct ath_hal *ah = sc->sc_ah;
 	u_int32_t nexttbtt, intval;
 	struct ath_beacon_config conf;
-	enum hal_opmode av_opmode;
+	enum ath9k_opmode av_opmode;
 
 	if (if_id != ATH_IF_ID_ANY)
 		av_opmode = sc->sc_vaps[if_id]->av_opmode;
@@ -768,7 +768,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	nexttbtt = TSF_TO_TU(LE_READ_4(conf.u.last_tstamp + 4),
 			     LE_READ_4(conf.u.last_tstamp));
 	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_opmode == HAL_M_HOSTAP) {
+	if (sc->sc_opmode == ATH9K_M_HOSTAP) {
 		/*
 		 * For multi-bss ap support beacons are either staggered
 		 * evenly over N slots or burst together.  For the former
@@ -776,10 +776,10 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * Slots that are not occupied will generate nothing.
 		 */
 		/* NB: the beacon interval is kept internally in TU's */
-		intval = conf.beacon_interval & HAL_BEACON_PERIOD;
+		intval = conf.beacon_interval & ATH9K_BEACON_PERIOD;
 		intval /= ATH_BCBUF;    /* for staggered beacons */
 	} else {
-		intval = conf.beacon_interval & HAL_BEACON_PERIOD;
+		intval = conf.beacon_interval & ATH9K_BEACON_PERIOD;
 	}
 
 	if (nexttbtt == 0)      /* e.g. for ap mode */
@@ -788,9 +788,9 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		nexttbtt = roundup(nexttbtt, intval);
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
-	/* Check for HAL_M_HOSTAP and sc_nostabeacons for WDS client */
-	if (sc->sc_opmode == HAL_M_STA) {
-		struct hal_beacon_state bs;
+	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
+	if (sc->sc_opmode == ATH9K_M_STA) {
+		struct ath9k_beacon_state bs;
 		u_int64_t tsf;
 		u_int32_t tsftu;
 		int dtimperiod, dtimcount, sleepduration;
@@ -901,21 +901,21 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 
 		ath9k_hw_set_interrupts(ah, 0);
 		ath9k_hw_set_sta_beacon_timers(ah, &bs);
-		sc->sc_imask |= HAL_INT_BMISS;
+		sc->sc_imask |= ATH9K_INT_BMISS;
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	} else {
 		u_int64_t tsf;
 		u_int32_t tsftu;
 		ath9k_hw_set_interrupts(ah, 0);
 		if (nexttbtt == intval)
-			intval |= HAL_BEACON_RESET_TSF;
-		if (sc->sc_opmode == HAL_M_IBSS) {
+			intval |= ATH9K_BEACON_RESET_TSF;
+		if (sc->sc_opmode == ATH9K_M_IBSS) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
 			 * TSF .
 			 */
 #define FUDGE   2
-			if (!(intval & HAL_BEACON_RESET_TSF)) {
+			if (!(intval & ATH9K_BEACON_RESET_TSF)) {
 				tsf = ath9k_hw_gettsf64(ah);
 				tsftu = TSF_TO_TU((u_int32_t)(tsf>>32),
 					(u_int32_t)tsf) + FUDGE;
@@ -927,7 +927,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: IBSS nexttbtt %u intval %u (%u)\n",
 				__func__, nexttbtt,
-				intval & ~HAL_BEACON_RESET_TSF,
+				intval & ~ATH9K_BEACON_RESET_TSF,
 				conf.beacon_interval);
 
 			/*
@@ -937,17 +937,17 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 * self-linked tx descriptor and let the hardware
 			 * deal with things.
 			 */
-			intval |= HAL_BEACON_ENA;
+			intval |= ATH9K_BEACON_ENA;
 			if (!ah->ah_caps.halVEOLSupport)
-				sc->sc_imask |= HAL_INT_SWBA;
+				sc->sc_imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
-		} else if (sc->sc_opmode == HAL_M_HOSTAP) {
+		} else if (sc->sc_opmode == ATH9K_M_HOSTAP) {
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.
 			 */
-			intval |= HAL_BEACON_ENA;
-			sc->sc_imask |= HAL_INT_SWBA;   /* beacon prepare */
+			intval |= ATH9K_BEACON_ENA;
+			sc->sc_imask |= ATH9K_INT_SWBA;   /* beacon prepare */
 			ath_beaconq_config(sc);
 		}
 		ath9k_hw_beaconinit(ah, nexttbtt, intval);
@@ -957,7 +957,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_opmode == HAL_M_IBSS && ah->ah_caps.halVEOLSupport)
+		if (sc->sc_opmode == ATH9K_M_IBSS && ah->ah_caps.halVEOLSupport)
 			ath_beacon_start_adhoc(sc, 0);
 	}
 #undef TSF_TO_TU
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 81679b4..e524678 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -60,7 +60,7 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
-	const struct hal_rate_table *rt;
+	const struct ath9k_rate_table *rt;
 	int i;
 
 	memset(sc->sc_rixmap, 0xff, sizeof(sc->sc_rixmap));
@@ -110,7 +110,7 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 static int ath_rate_setup(struct ath_softc *sc, enum wireless_mode mode)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	const struct hal_rate_table *rt;
+	const struct ath9k_rate_table *rt;
 
 	switch (mode) {
 	case WIRELESS_MODE_11a:
@@ -407,7 +407,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
-	enum hal_ht_macmode ht_macmode;
+	enum ath9k_ht_macmode ht_macmode;
 
 	if (sc->sc_invalid)	/* if the device is invalid or removed */
 		return -EIO;
@@ -625,7 +625,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
 
-	if (sc->sc_opmode == HAL_M_STA || sc->sc_opmode == HAL_M_IBSS) {
+	if (sc->sc_opmode == ATH9K_M_STA || sc->sc_opmode == ATH9K_M_IBSS) {
 		memcpy(sc->sc_curbssid, ath_bcast_mac, ETH_ALEN);
 		ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
 	} else
@@ -641,8 +641,8 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 	 * Disable BMISS interrupt when we're not associated
 	 */
 	ath9k_hw_set_interrupts(ah,
-		sc->sc_imask & ~(HAL_INT_SWBA | HAL_INT_BMISS));
-	sc->sc_imask &= ~(HAL_INT_SWBA | HAL_INT_BMISS);
+		sc->sc_imask & ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
+	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 	/* need to reconfigure the beacons when it moves to RUN */
 	sc->sc_beacons = 0;
 
@@ -652,7 +652,7 @@ int ath_vap_listen(struct ath_softc *sc, int if_id)
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum hal_opmode opmode)
+		   enum ath9k_opmode opmode)
 {
 	struct ath_vap *avp;
 
@@ -663,11 +663,11 @@ int ath_vap_attach(struct ath_softc *sc,
 	}
 
 	switch (opmode) {
-	case HAL_M_STA:
-	case HAL_M_IBSS:
-	case HAL_M_MONITOR:
+	case ATH9K_M_STA:
+	case ATH9K_M_IBSS:
+	case ATH9K_M_MONITOR:
 		break;
-	case HAL_M_HOSTAP:
+	case ATH9K_M_HOSTAP:
 		/* XXX not right, beacon buffer is allocated on RUN trans */
 		if (list_empty(&sc->sc_bbuf))
 			return -ENOMEM;
@@ -767,7 +767,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	struct ath_hal *ah = sc->sc_ah;
 	enum hal_status status;
 	int error = 0;
-	enum hal_ht_macmode ht_macmode = ath_cwm_macmode(sc);
+	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n", __func__, sc->sc_opmode);
 
@@ -826,32 +826,32 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 		goto done;
 	}
 	/* Setup our intr mask. */
-	sc->sc_imask = HAL_INT_RX | HAL_INT_TX
-		| HAL_INT_RXEOL | HAL_INT_RXORN
-		| HAL_INT_FATAL | HAL_INT_GLOBAL;
+	sc->sc_imask = ATH9K_INT_RX | ATH9K_INT_TX
+		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
+		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
 	if (ah->ah_caps.halGTTSupport)
-		sc->sc_imask |= HAL_INT_GTT;
+		sc->sc_imask |= ATH9K_INT_GTT;
 
 	if (ah->ah_caps.halHTSupport)
-		sc->sc_imask |= HAL_INT_CST;
+		sc->sc_imask |= ATH9K_INT_CST;
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
 	if (ath9k_hw_phycounters(ah) &&
-	    ((sc->sc_opmode == HAL_M_STA) || (sc->sc_opmode == HAL_M_IBSS)))
-		sc->sc_imask |= HAL_INT_MIB;
+	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
+		sc->sc_imask |= ATH9K_INT_MIB;
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
 	 * that does, if not overridden by configuration,
 	 * enable the TIM interrupt when operating as station.
 	 */
-	if (ah->ah_caps.halEnhancedPmSupport && sc->sc_opmode == HAL_M_STA &&
+	if (ah->ah_caps.halEnhancedPmSupport && sc->sc_opmode == ATH9K_M_STA &&
 		!sc->sc_config.swBeaconProcess)
-		sc->sc_imask |= HAL_INT_TIM;
+		sc->sc_imask |= ATH9K_INT_TIM;
 	/*
 	 *  Don't enable interrupts here as we've not yet built our
 	 *  vap and node data structures, which will be needed as soon
@@ -910,7 +910,7 @@ static int ath_reset_end(struct ath_softc *sc, u_int32_t flag)
 	/* Restart the txq */
 	if (flag & RESET_RETRY_TXQ) {
 		int i;
-		for (i = 0; i < HAL_NUM_TX_QUEUES; i++) {
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
 				spin_lock_bh(&sc->sc_txq[i].axq_lock);
 				ath_txq_schedule(sc, &sc->sc_txq[i]);
@@ -926,7 +926,7 @@ int ath_reset(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	enum hal_status status;
 	int error = 0;
-	enum hal_ht_macmode ht_macmode = ath_cwm_macmode(sc);
+	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	/* NB: indicate channel change so we do a full reset */
 	spin_lock_bh(&sc->sc_resetlock);
@@ -974,7 +974,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 {
 	struct ath_softc *sc = dev;
 	struct ath_hal *ah = sc->sc_ah;
-	enum hal_int status;
+	enum ath9k_int status;
 	bool sched = false;
 
 	do {
@@ -1010,18 +1010,18 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 		sc->sc_intrstatus = status;
 
-		if (status & HAL_INT_FATAL) {
+		if (status & ATH9K_INT_FATAL) {
 			/* need a chip reset */
 			sched = true;
-		} else if (status & HAL_INT_RXORN) {
+		} else if (status & ATH9K_INT_RXORN) {
 			/* need a chip reset */
 			sched = true;
 		} else {
-			if (status & HAL_INT_SWBA) {
+			if (status & ATH9K_INT_SWBA) {
 				/* schedule a tasklet for beacon handling */
 				tasklet_schedule(&sc->bcon_tasklet);
 			}
-			if (status & HAL_INT_RXEOL) {
+			if (status & ATH9K_INT_RXEOL) {
 				/*
 				 * NB: the hardware should re-read the link when
 				 *     RXE bit is written, but it doesn't work
@@ -1030,20 +1030,20 @@ irqreturn_t ath_isr(int irq, void *dev)
 				sched = true;
 			}
 
-			if (status & HAL_INT_TXURN)
+			if (status & ATH9K_INT_TXURN)
 				/* bump tx trigger level */
 				ath9k_hw_updatetxtriglevel(ah, true);
 			/* XXX: optimize this */
-			if (status & HAL_INT_RX)
+			if (status & ATH9K_INT_RX)
 				sched = true;
-			if (status & HAL_INT_TX)
+			if (status & ATH9K_INT_TX)
 				sched = true;
-			if (status & HAL_INT_BMISS)
+			if (status & ATH9K_INT_BMISS)
 				sched = true;
 			/* carrier sense timeout */
-			if (status & HAL_INT_CST)
+			if (status & ATH9K_INT_CST)
 				sched = true;
-			if (status & HAL_INT_MIB) {
+			if (status & ATH9K_INT_MIB) {
 				/*
 				 * Disable interrupts until we service the MIB
 				 * interrupt; otherwise it will continue to
@@ -1058,7 +1058,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 				ath9k_hw_procmibevent(ah, &sc->sc_halstats);
 				ath9k_hw_set_interrupts(ah, sc->sc_imask);
 			}
-			if (status & HAL_INT_TIM_TIMER) {
+			if (status & ATH9K_INT_TIM_TIMER) {
 				if (!ah->ah_caps.halAutoSleepSupport) {
 					/* Clear RxAbort bit so that we can
 					 * receive frames */
@@ -1071,7 +1071,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	if (sched) {
 		/* turn off every interrupt except SWBA */
-		ath9k_hw_set_interrupts(ah, (sc->sc_imask & HAL_INT_SWBA));
+		ath9k_hw_set_interrupts(ah, (sc->sc_imask & ATH9K_INT_SWBA));
 		tasklet_schedule(&sc->intr_tq);
 	}
 
@@ -1085,18 +1085,19 @@ static void ath9k_tasklet(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	u_int32_t status = sc->sc_intrstatus;
 
-	if (status & HAL_INT_FATAL) {
+	if (status & ATH9K_INT_FATAL) {
 		/* need a chip reset */
 		ath_internal_reset(sc);
 		return;
 	} else {
 
-		if (status & (HAL_INT_RX | HAL_INT_RXEOL | HAL_INT_RXORN)) {
+		if (status &
+		    (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
 			/* XXX: fill me in */
 			/*
-			if (status & HAL_INT_RXORN) {
+			if (status & ATH9K_INT_RXORN) {
 			}
-			if (status & HAL_INT_RXEOL) {
+			if (status & ATH9K_INT_RXEOL) {
 			}
 			*/
 			spin_lock_bh(&sc->sc_rxflushlock);
@@ -1104,16 +1105,16 @@ static void ath9k_tasklet(unsigned long data)
 			spin_unlock_bh(&sc->sc_rxflushlock);
 		}
 		/* XXX: optimize this */
-		if (status & HAL_INT_TX)
+		if (status & ATH9K_INT_TX)
 			ath_tx_tasklet(sc);
 		/* XXX: fill me in */
 		/*
-		if (status & HAL_INT_BMISS) {
+		if (status & ATH9K_INT_BMISS) {
 		}
-		if (status & (HAL_INT_TIM | HAL_INT_DTIMSYNC)) {
-			if (status & HAL_INT_TIM) {
+		if (status & (ATH9K_INT_TIM | ATH9K_INT_DTIMSYNC)) {
+			if (status & ATH9K_INT_TIM) {
 			}
-			if (status & HAL_INT_DTIMSYNC) {
+			if (status & ATH9K_INT_DTIMSYNC) {
 			}
 		}
 		*/
@@ -1205,7 +1206,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		goto bad;
 
 	/* default to STA mode */
-	sc->sc_opmode = HAL_M_MONITOR;
+	sc->sc_opmode = ATH9K_M_MONITOR;
 
 	/* Setup rate tables for all potential media types. */
 	/* 11g encompasses b,g */
@@ -1229,7 +1230,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		error = -EIO;
 		goto bad2;
 	}
-	sc->sc_cabq = ath_txq_setup(sc, HAL_TX_QUEUE_CAB, 0);
+	sc->sc_cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->sc_cabq == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup CAB xmit queue\n", __func__);
@@ -1245,7 +1246,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 
 	/* Setup data queues */
 	/* NB: ensure BK queue is the lowest priority h/w queue */
-	if (!ath_tx_setup(sc, HAL_WME_AC_BK)) {
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for BK traffic\n",
 			__func__);
@@ -1253,21 +1254,21 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
-	if (!ath_tx_setup(sc, HAL_WME_AC_BE)) {
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for BE traffic\n",
 			__func__);
 		error = -EIO;
 		goto bad2;
 	}
-	if (!ath_tx_setup(sc, HAL_WME_AC_VI)) {
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for VI traffic\n",
 			__func__);
 		error = -EIO;
 		goto bad2;
 	}
-	if (!ath_tx_setup(sc, HAL_WME_AC_VO)) {
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to setup xmit queue for VO traffic\n",
 			__func__);
@@ -1281,7 +1282,8 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
-	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER, HAL_CIPHER_TKIP, NULL)) {
+	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)) {
 		/*
 		 * Whether we should enable h/w TKIP MIC.
 		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
@@ -1297,9 +1299,12 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER, HAL_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(ah, HAL_CAP_CIPHER, HAL_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(ah, HAL_CAP_TKIP_SPLIT, 0, NULL))
+	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)
+	    && ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+				      ATH9K_CIPHER_MIC, NULL)
+	    && ath9k_hw_getcapability(ah, HAL_CAP_TKIP_SPLIT,
+				      0, NULL))
 		sc->sc_splitmic = 1;
 
 	/* turn on mcast key search if possible */
@@ -1336,7 +1341,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 	}
-	sc->sc_slottime = HAL_SLOT_TIME_9;	/* default to short slot time */
+	sc->sc_slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
 	/* initialize beacon slots */
 	for (i = 0; i < ARRAY_SIZE(sc->sc_bslot); i++)
@@ -1353,7 +1358,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	return 0;
 bad2:
 	/* cleanup tx queues */
-	for (i = 0; i < HAL_NUM_TX_QUEUES; i++)
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
 bad:
@@ -1371,10 +1376,10 @@ void ath_deinit(struct ath_softc *sc)
 
 	ath_stop(sc);
 	if (!sc->sc_invalid)
-		ath9k_hw_setpower(sc->sc_ah, HAL_PM_AWAKE);
+		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 	ath_rate_detach(sc->sc_rc);
 	/* cleanup tx queues */
-	for (i = 0; i < HAL_NUM_TX_QUEUES; i++)
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
 	ath9k_hw_detach(ah);
@@ -1519,7 +1524,7 @@ void ath_key_reset(struct ath_softc *sc, u_int16_t keyix, int freeslot)
 
 int ath_keyset(struct ath_softc *sc,
 	       u_int16_t keyix,
-	       struct hal_keyval *hk,
+	       struct ath9k_keyval *hk,
 	       const u_int8_t mac[ETH_ALEN])
 {
 	bool status;
@@ -1556,7 +1561,7 @@ void ath_update_txpow(struct ath_softc *sc)
 
 /* Return the current country and domain information */
 void ath_get_currentCountry(struct ath_softc *sc,
-	struct hal_country_entry *ctry)
+	struct ath9k_country_entry *ctry)
 {
 	ath9k_regd_get_current_country(sc->sc_ah, ctry);
 
@@ -1860,19 +1865,19 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
 
 	switch (queue) {
 	case 0:
-		qnum = sc->sc_haltype2q[HAL_WME_AC_VO];
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VO];
 		break;
 	case 1:
-		qnum = sc->sc_haltype2q[HAL_WME_AC_VI];
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VI];
 		break;
 	case 2:
-		qnum = sc->sc_haltype2q[HAL_WME_AC_BE];
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
 		break;
 	case 3:
-		qnum = sc->sc_haltype2q[HAL_WME_AC_BK];
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BK];
 		break;
 	default:
-		qnum = sc->sc_haltype2q[HAL_WME_AC_BE];
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
 		break;
 	}
 
@@ -1884,16 +1889,16 @@ int ath_get_mac80211_qnum(u_int queue, struct ath_softc *sc)
 	int qnum;
 
 	switch (queue) {
-	case HAL_WME_AC_VO:
+	case ATH9K_WME_AC_VO:
 		qnum = 0;
 		break;
-	case HAL_WME_AC_VI:
+	case ATH9K_WME_AC_VI:
 		qnum = 1;
 		break;
-	case HAL_WME_AC_BE:
+	case ATH9K_WME_AC_BE:
 		qnum = 2;
 		break;
-	case HAL_WME_AC_BK:
+	case ATH9K_WME_AC_BK:
 		qnum = 3;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2f1881d..1ac56e0 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -212,7 +212,8 @@ struct ath_buf_state {
 				when set for tx frame */
 	int bfs_rifsburst_elem;	/* RIFS burst/bar */
 	int bfs_nrifsubframes;	/* # of elements in burst */
-	enum hal_key_type bfs_keytype;	/* key type use to encrypt this frame */
+	/* key type use to encrypt this frame */
+	enum ath9k_key_type bfs_keytype;
 };
 
 #define bf_nframes      	bf_state.bfs_nframes
@@ -512,8 +513,8 @@ struct ath_tx_control {
 	u_int ps:1;             /* if one or more stations are in PS mode */
 	u_int use_minrate:1;	/* if this frame should transmitted using
 				minimum rate */
-	enum hal_pkt_type atype;	/* Atheros packet type */
-	enum hal_key_type keytype;	/* key type */
+	enum ath9k_pkt_type atype;	/* Atheros packet type */
+	enum ath9k_key_type keytype;	/* key type */
 	u_int flags;		/* HAL flags */
 	u_int16_t seqno;	/* sequence number */
 	u_int16_t tidno;	/* tid number */
@@ -567,7 +568,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_tx_cleanup(struct ath_softc *sc);
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
-int ath_txq_update(struct ath_softc *sc, int qnum, struct hal_txq_info *q);
+int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *q);
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb);
 void ath_tx_tasklet(struct ath_softc *sc);
 u_int32_t ath_txq_depth(struct ath_softc *sc, int qnum);
@@ -782,7 +783,7 @@ struct ath_vap_config {
 struct ath_vap {
 	struct ieee80211_vif            *av_if_data; /* interface(vap)
 				instance from 802.11 protocal layer */
-	enum hal_opmode                 av_opmode;  /* VAP operational mode */
+	enum ath9k_opmode                 av_opmode;  /* VAP operational mode */
 	struct ath_buf                  *av_bcbuf;  /* beacon buffer */
 	struct ath_beacon_offset        av_boff;    /* dynamic update state */
 	struct ath_tx_control           av_btxctl;  /* tx control information
@@ -798,7 +799,7 @@ struct ath_vap {
 int ath_vap_attach(struct ath_softc *sc,
 		   int if_id,
 		   struct ieee80211_vif *if_data,
-		   enum hal_opmode opmode);
+		   enum ath9k_opmode opmode);
 int ath_vap_detach(struct ath_softc *sc, int if_id);
 int ath_vap_config(struct ath_softc *sc,
 	int if_id, struct ath_vap_config *if_config);
@@ -914,7 +915,7 @@ enum RATE_TYPE {
 };
 
 struct ath_ht_info {
-	enum hal_ht_macmode tx_chan_width;
+	enum ath9k_ht_macmode tx_chan_width;
 	u_int16_t maxampdu;
 	u_int8_t mpdudensity;
 	u_int8_t ext_chan_offset;
@@ -932,7 +933,7 @@ struct ath_softc {
 	struct ath_hal          *sc_ah;     /* HAL Instance */
 	struct ath_rate_softc    *sc_rc;     /* tx rate control support */
 	u_int32_t               sc_intrstatus; /* HAL_STATUS */
-	enum hal_opmode         sc_opmode;  /* current operating mode */
+	enum ath9k_opmode         sc_opmode;  /* current operating mode */
 
 	/* Properties, Config */
 	u_int8_t                sc_invalid;	/* being detached */
@@ -955,7 +956,7 @@ struct ath_softc {
 	u_int16_t               sc_nvaps;       /* # of active virtual ap's */
 	struct ath_vap          *sc_vaps[ATH_BCBUF]; /* interface id
 						to avp map */
-	enum hal_int            sc_imask;       /* interrupt mask copy */
+	enum ath9k_int            sc_imask;       /* interrupt mask copy */
 	u_int8_t                sc_bssidmask[ETH_ALEN];
 	u_int8_t                sc_defant;      /* current default antenna */
 	u_int8_t                sc_rxotherant;  /* rx's on non-default antenna*/
@@ -964,11 +965,11 @@ struct ath_softc {
 	int                     sc_slottime;    /* slot time */
 	u_int8_t                sc_noreset;
 	int                     sc_bslot[ATH_BCBUF];/* beacon xmit slots */
-	struct hal_node_stats   sc_halstats;    /* station-mode rssi stats */
+	struct ath9k_node_stats   sc_halstats;    /* station-mode rssi stats */
 	struct list_head        node_list;
 	struct ath_ht_info      sc_ht_info;
 	int16_t                 sc_noise_floor; /* signal noise floor in dBm */
-	enum hal_ht_extprotspacing   sc_ht_extprotspacing;
+	enum ath9k_ht_extprotspacing   sc_ht_extprotspacing;
 	u_int8_t                sc_tx_chainmask;
 	u_int8_t                sc_rx_chainmask;
 	u_int8_t                sc_rxchaindetect_ref;
@@ -1005,16 +1006,16 @@ struct ath_softc {
 
 	/* TX */
 	struct list_head	sc_txbuf;       /* transmit buffer */
-	struct ath_txq          sc_txq[HAL_NUM_TX_QUEUES];
+	struct ath_txq          sc_txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma      sc_txdma;       /* TX descriptors */
 	u_int                   sc_txqsetup;    /* h/w queues setup */
 	u_int                   sc_txintrperiod;/* tx interrupt batching */
-	int                     sc_haltype2q[HAL_WME_AC_VO+1]; /* HAL WME
+	int                     sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME
 							AC -> h/w qnum */
 	u_int32_t               sc_ant_tx[8];   /* recent tx frames/antenna */
 
 	/* Beacon */
-	struct hal_txq_info     sc_beacon_qi;   /* adhoc only: beacon
+	struct ath9k_txq_info     sc_beacon_qi;   /* adhoc only: beacon
 						queue parameters */
 	struct ath_descdma      sc_bdma;        /* beacon descriptors */
 	struct ath_txq          *sc_cabq;       /* tx q for cab frames */
@@ -1025,8 +1026,8 @@ struct ath_softc {
 
 	/* Rate */
 	struct ieee80211_rate          rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-	const struct hal_rate_table    *sc_rates[WIRELESS_MODE_MAX];
-	const struct hal_rate_table    *sc_currates;   /* current rate table */
+	const struct ath9k_rate_table    *sc_rates[WIRELESS_MODE_MAX];
+	const struct ath9k_rate_table    *sc_currates; /* current rate table */
 	u_int8_t                       sc_rixmap[256]; /* IEEE to h/w
 						rate table ix */
 	u_int8_t                       sc_minrateix;   /* min h/w rate index */
@@ -1061,7 +1062,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
 void ath_setup_rate(struct ath_softc *sc,
 		    enum wireless_mode wMode,
 		    enum RATE_TYPE type,
-		    const struct hal_rate_table *rt);
+		    const struct ath9k_rate_table *rt);
 
 /*********************/
 /* Utility Functions */
@@ -1070,7 +1071,7 @@ void ath_setup_rate(struct ath_softc *sc,
 void ath_key_reset(struct ath_softc *sc, u_int16_t keyix, int freeslot);
 int ath_keyset(struct ath_softc *sc,
 	       u_int16_t keyix,
-	       struct hal_keyval *hk,
+	       struct ath9k_keyval *hk,
 	       const u_int8_t mac[ETH_ALEN]);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u_int queue, struct ath_softc *sc);
@@ -1078,7 +1079,7 @@ void ath_setslottime(struct ath_softc *sc);
 void ath_update_txpow(struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 void ath_get_currentCountry(struct ath_softc *sc,
-	struct hal_country_entry *ctry);
+	struct ath9k_country_entry *ctry);
 u_int64_t ath_extend_tsf(struct ath_softc *sc, u_int32_t rstamp);
 void ath_internal_reset(struct ath_softc *sc);
 u_int32_t ath_chan2flags(struct ieee80211_channel *chan, struct ath_softc *sc);
@@ -1091,6 +1092,6 @@ void ath_skb_unmap_single(struct ath_softc *sc,
 			  int direction,
 			  dma_addr_t *pa);
 void ath_mcast_merge(struct ath_softc *sc, u_int32_t mfilt[2]);
-enum hal_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
+enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 3e95760..b43cda8 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -107,7 +107,7 @@ static const struct ath_hal ar5416hal = {
 	},
 };
 
-static struct hal_rate_table ar5416_11a_table = {
+static struct ath9k_rate_table ar5416_11a_table = {
 	8,
 	{0},
 	{
@@ -122,7 +122,7 @@ static struct hal_rate_table ar5416_11a_table = {
 	},
 };
 
-static struct hal_rate_table ar5416_11b_table = {
+static struct ath9k_rate_table ar5416_11b_table = {
 	4,
 	{0},
 	{
@@ -133,7 +133,7 @@ static struct hal_rate_table ar5416_11b_table = {
 	},
 };
 
-static struct hal_rate_table ar5416_11g_table = {
+static struct ath9k_rate_table ar5416_11g_table = {
 	12,
 	{0},
 	{
@@ -153,7 +153,7 @@ static struct hal_rate_table ar5416_11g_table = {
 	},
 };
 
-static struct hal_rate_table ar5416_11ng_table = {
+static struct ath9k_rate_table ar5416_11ng_table = {
 	28,
 	{0},
 	{
@@ -189,7 +189,7 @@ static struct hal_rate_table ar5416_11ng_table = {
 	},
 };
 
-static struct hal_rate_table ar5416_11na_table = {
+static struct ath9k_rate_table ar5416_11na_table = {
 	24,
 	{0},
 	{
@@ -397,7 +397,7 @@ static inline void ath9k_hw_init_bb(struct ath_hal *ah,
 }
 
 static inline void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
-						 enum hal_opmode opmode)
+						 enum ath9k_opmode opmode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -414,7 +414,7 @@ static inline void ath9k_hw_init_interrupt_masks(struct ath_hal *ah,
 
 	ahp->ah_maskReg |= AR_IMR_TXOK;
 
-	if (opmode == HAL_M_HOSTAP)
+	if (opmode == ATH9K_M_HOSTAP)
 		ahp->ah_maskReg |= AR_IMR_MIB;
 
 	REG_WRITE(ah, AR_IMR, ahp->ah_maskReg);
@@ -973,9 +973,9 @@ u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah)
 	u_int32_t phybits = REG_READ(ah, AR_PHY_ERR);
 
 	if (phybits & AR_PHY_ERR_RADAR)
-		bits |= HAL_RX_FILTER_PHYRADAR;
+		bits |= ATH9K_RX_FILTER_PHYRADAR;
 	if (phybits & (AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING))
-		bits |= HAL_RX_FILTER_PHYERR;
+		bits |= ATH9K_RX_FILTER_PHYERR;
 	return bits;
 }
 
@@ -985,9 +985,9 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits)
 
 	REG_WRITE(ah, AR_RX_FILTER, (bits & 0xffff) | AR_RX_COMPR_BAR);
 	phybits = 0;
-	if (bits & HAL_RX_FILTER_PHYRADAR)
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
 		phybits |= AR_PHY_ERR_RADAR;
-	if (bits & HAL_RX_FILTER_PHYERR)
+	if (bits & ATH9K_RX_FILTER_PHYERR)
 		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
 	REG_WRITE(ah, AR_PHY_ERR, phybits);
 
@@ -1155,11 +1155,11 @@ u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 	return good;
 }
 
-void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum hal_ht_macmode mode)
+void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
 {
 	u_int32_t macmode;
 
-	if (mode == HAL_HT_MACMODE_2040 &&
+	if (mode == ATH9K_HT_MACMODE_2040 &&
 	    !ah->ah_config.ath_hal_cwmIgnoreExtCCA)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
@@ -1210,7 +1210,7 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 		ah->ah_flags = AH_USE_EEPROM;
 
 	ah->ah_powerLimit = MAX_RATE_POWER;
-	ah->ah_tpScale = HAL_TP_SCALE_MAX;
+	ah->ah_tpScale = ATH9K_TP_SCALE_MAX;
 
 	ahp->ah_atimWindow = 0;
 	ahp->ah_diversityControl = ah->ah_config.ath_hal_diversityControl;
@@ -1502,7 +1502,7 @@ static inline void ath9k_hw_init_pll(struct ath_hal *ah,
 }
 
 static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
-			      enum hal_ht_macmode macmode)
+			      enum ath9k_ht_macmode macmode)
 {
 	u_int32_t phymode;
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -1517,7 +1517,7 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 		    (chan->chanmode == CHANNEL_G_HT40PLUS))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
-		if (ahp->ah_extprotspacing == HAL_HT_EXTPROTSPACING_25)
+		if (ahp->ah_extprotspacing == ATH9K_HT_EXTPROTSPACING_25)
 			phymode |= AR_PHY_FC_DYN2040_EXT_CH;
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
@@ -1535,18 +1535,18 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 	val = REG_READ(ah, AR_STA_ID1);
 	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
 	switch (opmode) {
-	case HAL_M_HOSTAP:
+	case ATH9K_M_HOSTAP:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
-	case HAL_M_IBSS:
+	case ATH9K_M_IBSS:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
-	case HAL_M_STA:
-	case HAL_M_MONITOR:
+	case ATH9K_M_STA:
+	case ATH9K_M_MONITOR:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
 		break;
 	}
@@ -1596,7 +1596,7 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 		}
 
 		rst_flags = AR_RTC_RC_MAC_WARM;
-		if (type == HAL_RESET_COLD)
+		if (type == ATH9K_RESET_COLD)
 			rst_flags |= AR_RTC_RC_MAC_COLD;
 	}
 
@@ -1641,7 +1641,7 @@ static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 
 	ath9k_hw_read_revisions(ah);
 
-	return ath9k_hw_set_reset(ah, HAL_RESET_WARM);
+	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
 static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
@@ -1651,11 +1651,11 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
 
 	switch (type) {
-	case HAL_RESET_POWER_ON:
+	case ATH9K_RESET_POWER_ON:
 		return ath9k_hw_set_reset_power_on(ah);
 		break;
-	case HAL_RESET_WARM:
-	case HAL_RESET_COLD:
+	case ATH9K_RESET_WARM:
+	case ATH9K_RESET_COLD:
 		return ath9k_hw_set_reset(ah, type);
 		break;
 	default:
@@ -1724,14 +1724,14 @@ ath9k_hw_get_lower_upper_index(u_int8_t target,
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 {
 	int16_t nfval;
-	int16_t sort[HAL_NF_CAL_HIST_MAX];
+	int16_t sort[ATH9K_NF_CAL_HIST_MAX];
 	int i, j;
 
-	for (i = 0; i < HAL_NF_CAL_HIST_MAX; i++)
+	for (i = 0; i < ATH9K_NF_CAL_HIST_MAX; i++)
 		sort[i] = nfCalBuffer[i];
 
-	for (i = 0; i < HAL_NF_CAL_HIST_MAX - 1; i++) {
-		for (j = 1; j < HAL_NF_CAL_HIST_MAX - i; j++) {
+	for (i = 0; i < ATH9K_NF_CAL_HIST_MAX - 1; i++) {
+		for (j = 1; j < ATH9K_NF_CAL_HIST_MAX - i; j++) {
 			if (sort[j] > sort[j - 1]) {
 				nfval = sort[j];
 				sort[j] = sort[j - 1];
@@ -1739,12 +1739,12 @@ static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 			}
 		}
 	}
-	nfval = sort[(HAL_NF_CAL_HIST_MAX - 1) >> 1];
+	nfval = sort[(ATH9K_NF_CAL_HIST_MAX - 1) >> 1];
 
 	return nfval;
 }
 
-static void ath9k_hw_update_nfcal_hist_buffer(struct hal_nfcal_hist *h,
+static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 					      int16_t *nfarray)
 {
 	int i;
@@ -1752,13 +1752,13 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct hal_nfcal_hist *h,
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		h[i].nfCalBuffer[h[i].currIndex] = nfarray[i];
 
-		if (++h[i].currIndex >= HAL_NF_CAL_HIST_MAX)
+		if (++h[i].currIndex >= ATH9K_NF_CAL_HIST_MAX)
 			h[i].currIndex = 0;
 
 		if (h[i].invalidNFcount > 0) {
 			if (nfarray[i] < AR_PHY_CCA_MIN_BAD_VALUE
 			    || nfarray[i] > AR_PHY_CCA_MAX_HIGH_VALUE) {
-				h[i].invalidNFcount = HAL_NF_CAL_HIST_MAX;
+				h[i].invalidNFcount = ATH9K_NF_CAL_HIST_MAX;
 			} else {
 				h[i].invalidNFcount--;
 				h[i].privNF = nfarray[i];
@@ -1889,7 +1889,7 @@ static void ath9k_hw_start_nfcal(struct ath_hal *ah)
 static void
 ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 {
-	struct hal_nfcal_hist *h;
+	struct ath9k_nfcal_hist *h;
 	int i, j;
 	int32_t val;
 	const u_int32_t ar5416_cca_regs[6] = {
@@ -1950,7 +1950,7 @@ static int16_t ath9k_hw_getnf(struct ath_hal *ah,
 {
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
-	struct hal_nfcal_hist *h;
+	struct ath9k_nfcal_hist *h;
 	u_int8_t chainmask;
 
 	if (AR_SREV_9280(ah))
@@ -1992,7 +1992,7 @@ static int16_t ath9k_hw_getnf(struct ath_hal *ah,
 }
 
 static void ath9k_hw_update_mibstats(struct ath_hal *ah,
-			      struct hal_mib_stats *stats)
+			      struct ath9k_mib_stats *stats)
 {
 	stats->ackrcv_bad += REG_READ(ah, AR_ACK_FAIL);
 	stats->rts_bad += REG_READ(ah, AR_RTS_FAIL);
@@ -2062,23 +2062,23 @@ static void ath9k_hw_ani_attach(struct ath_hal *ah)
 
 	memset(ahp->ah_ani, 0, sizeof(ahp->ah_ani));
 	for (i = 0; i < ARRAY_SIZE(ahp->ah_ani); i++) {
-		ahp->ah_ani[i].ofdmTrigHigh = HAL_ANI_OFDM_TRIG_HIGH;
-		ahp->ah_ani[i].ofdmTrigLow = HAL_ANI_OFDM_TRIG_LOW;
-		ahp->ah_ani[i].cckTrigHigh = HAL_ANI_CCK_TRIG_HIGH;
-		ahp->ah_ani[i].cckTrigLow = HAL_ANI_CCK_TRIG_LOW;
-		ahp->ah_ani[i].rssiThrHigh = HAL_ANI_RSSI_THR_HIGH;
-		ahp->ah_ani[i].rssiThrLow = HAL_ANI_RSSI_THR_LOW;
+		ahp->ah_ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH;
+		ahp->ah_ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW;
+		ahp->ah_ani[i].cckTrigHigh = ATH9K_ANI_CCK_TRIG_HIGH;
+		ahp->ah_ani[i].cckTrigLow = ATH9K_ANI_CCK_TRIG_LOW;
+		ahp->ah_ani[i].rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
+		ahp->ah_ani[i].rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
 		ahp->ah_ani[i].ofdmWeakSigDetectOff =
-			!HAL_ANI_USE_OFDM_WEAK_SIG;
+			!ATH9K_ANI_USE_OFDM_WEAK_SIG;
 		ahp->ah_ani[i].cckWeakSigThreshold =
-			HAL_ANI_CCK_WEAK_SIG_THR;
-		ahp->ah_ani[i].spurImmunityLevel = HAL_ANI_SPUR_IMMUNE_LVL;
-		ahp->ah_ani[i].firstepLevel = HAL_ANI_FIRSTEP_LVL;
+			ATH9K_ANI_CCK_WEAK_SIG_THR;
+		ahp->ah_ani[i].spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
+		ahp->ah_ani[i].firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
 		if (ahp->ah_hasHwPhyCounters) {
 			ahp->ah_ani[i].ofdmPhyErrBase =
-				AR_PHY_COUNTMAX - HAL_ANI_OFDM_TRIG_HIGH;
+				AR_PHY_COUNTMAX - ATH9K_ANI_OFDM_TRIG_HIGH;
 			ahp->ah_ani[i].cckPhyErrBase =
-				AR_PHY_COUNTMAX - HAL_ANI_CCK_TRIG_HIGH;
+				AR_PHY_COUNTMAX - ATH9K_ANI_CCK_TRIG_HIGH;
 		}
 	}
 	if (ahp->ah_hasHwPhyCounters) {
@@ -2092,7 +2092,7 @@ static void ath9k_hw_ani_attach(struct ath_hal *ah)
 		REG_WRITE(ah, AR_PHY_ERR_2, ahp->ah_ani[0].cckPhyErrBase);
 		ath9k_enable_mib_counters(ah);
 	}
-	ahp->ah_aniPeriod = HAL_ANI_PERIOD;
+	ahp->ah_aniPeriod = ATH9K_ANI_PERIOD;
 	if (ah->ah_config.ath_hal_enableANI)
 		ahp->ah_procPhyErr |= HAL_PROCESS_ANI;
 }
@@ -2129,13 +2129,13 @@ static void ath9k_hw_ani_detach(struct ath_hal *ah)
 
 
 static bool ath9k_hw_ani_control(struct ath_hal *ah,
-				 enum hal_ani_cmd cmd, int param)
+				 enum ath9k_ani_cmd cmd, int param)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState = ahp->ah_curani;
 
 	switch (cmd & ahp->ah_ani_function) {
-	case HAL_ANI_NOISE_IMMUNITY_LEVEL:{
+	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
 		u_int level = param;
 
 		if (level >= ARRAY_SIZE(ahp->ah_totalSizeDesired)) {
@@ -2167,7 +2167,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		aniState->noiseImmunityLevel = level;
 		break;
 	}
-	case HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
+	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
 		const int m1ThreshLow[] = { 127, 50 };
 		const int m2ThreshLow[] = { 127, 40 };
 		const int m1Thresh[] = { 127, 0x4d };
@@ -2224,7 +2224,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		}
 		break;
 	}
-	case HAL_ANI_CCK_WEAK_SIGNAL_THR:{
+	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
 		const int weakSigThrCck[] = { 8, 6 };
 		u_int high = param ? 1 : 0;
 
@@ -2240,7 +2240,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		}
 		break;
 	}
-	case HAL_ANI_FIRSTEP_LEVEL:{
+	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		const int firstep[] = { 0, 4, 8 };
 		u_int level = param;
 
@@ -2261,7 +2261,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		aniState->firstepLevel = level;
 		break;
 	}
-	case HAL_ANI_SPUR_IMMUNITY_LEVEL:{
+	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
 		const int cycpwrThr1[] =
 			{ 2, 4, 6, 8, 10, 12, 14, 16 };
 		u_int level = param;
@@ -2284,7 +2284,7 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		aniState->spurImmunityLevel = level;
 		break;
 	}
-	case HAL_ANI_PRESENT:
+	case ATH9K_ANI_PRESENT:
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2367,22 +2367,22 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 	aniState = ahp->ah_curani;
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
-		if (ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
+		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 					 aniState->noiseImmunityLevel + 1)) {
 			return;
 		}
 	}
 
 	if (aniState->spurImmunityLevel < HAL_SPUR_IMMUNE_MAX) {
-		if (ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL,
+		if (ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL,
 					 aniState->spurImmunityLevel + 1)) {
 			return;
 		}
 	}
 
-	if (ah->ah_opmode == HAL_M_HOSTAP) {
+	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
-			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 		}
 		return;
@@ -2391,26 +2391,26 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 	if (rssi > aniState->rssiThrHigh) {
 		if (!aniState->ofdmWeakSigDetectOff) {
 			if (ath9k_hw_ani_control(ah,
-					 HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+					 ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 					 false)) {
 				ath9k_hw_ani_control(ah,
-					HAL_ANI_SPUR_IMMUNITY_LEVEL,
+					ATH9K_ANI_SPUR_IMMUNITY_LEVEL,
 					0);
 				return;
 			}
 		}
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
-			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 			return;
 		}
 	} else if (rssi > aniState->rssiThrLow) {
 		if (aniState->ofdmWeakSigDetectOff)
 			ath9k_hw_ani_control(ah,
-					     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					     true);
+				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     true);
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX)
-			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 		return;
 	} else {
@@ -2418,11 +2418,11 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
-					     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					     false);
+				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     false);
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
-						     HAL_ANI_FIRSTEP_LEVEL,
+						     ATH9K_ANI_FIRSTEP_LEVEL,
 						     0);
 			return;
 		}
@@ -2442,14 +2442,14 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 
 	aniState = ahp->ah_curani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
-		if (ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
+		if (ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 					 aniState->noiseImmunityLevel + 1)) {
 			return;
 		}
 	}
-	if (ah->ah_opmode == HAL_M_HOSTAP) {
+	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX) {
-			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 		}
 		return;
@@ -2457,14 +2457,14 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 	rssi = BEACON_RSSI(ahp);
 	if (rssi > aniState->rssiThrLow) {
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX)
-			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 	} else {
 		mode = ath9k_hw_chan2wmode(ah, chan);
 		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
-						     HAL_ANI_FIRSTEP_LEVEL,
+						     ATH9K_ANI_FIRSTEP_LEVEL,
 						     0);
 		}
 	}
@@ -2484,24 +2484,24 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 	aniState = &ahp->ah_ani[index];
 	ahp->ah_curani = aniState;
 
-	if (DO_ANI(ah) && ah->ah_opmode != HAL_M_STA
-	    && ah->ah_opmode != HAL_M_IBSS) {
+	if (DO_ANI(ah) && ah->ah_opmode != ATH9K_M_STA
+	    && ah->ah_opmode != ATH9K_M_IBSS) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "%s: Reset ANI state opmode %u\n", __func__,
 			 ah->ah_opmode);
 		ahp->ah_stats.ast_ani_reset++;
-		ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL, 0);
-		ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL, 0);
-		ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL, 0);
+		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
+		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
+		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
 		ath9k_hw_ani_control(ah,
-				     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-				     !HAL_ANI_USE_OFDM_WEAK_SIG);
-		ath9k_hw_ani_control(ah, HAL_ANI_CCK_WEAK_SIGNAL_THR,
-				     HAL_ANI_CCK_WEAK_SIG_THR);
+				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     !ATH9K_ANI_USE_OFDM_WEAK_SIG);
+		ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
+				     ATH9K_ANI_CCK_WEAK_SIG_THR);
 		ath9k_hw_setrxfilter(ah,
 				     ath9k_hw_getrxfilter(ah) |
-				     HAL_RX_FILTER_PHYERR);
-		if (ah->ah_opmode == HAL_M_HOSTAP) {
+				     ATH9K_RX_FILTER_PHYERR);
+		if (ah->ah_opmode == ATH9K_M_HOSTAP) {
 			ahp->ah_curani->ofdmTrigHigh =
 				ah->ah_config.ath_hal_ofdmTrigHigh;
 			ahp->ah_curani->ofdmTrigLow =
@@ -2516,25 +2516,25 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 	}
 
 	if (aniState->noiseImmunityLevel != 0)
-		ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
+		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 				     aniState->noiseImmunityLevel);
 	if (aniState->spurImmunityLevel != 0)
-		ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL,
+		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL,
 				     aniState->spurImmunityLevel);
 	if (aniState->ofdmWeakSigDetectOff)
 		ath9k_hw_ani_control(ah,
-				     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 				     !aniState->ofdmWeakSigDetectOff);
 	if (aniState->cckWeakSigThreshold)
-		ath9k_hw_ani_control(ah, HAL_ANI_CCK_WEAK_SIGNAL_THR,
+		ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
 				     aniState->cckWeakSigThreshold);
 	if (aniState->firstepLevel != 0)
-		ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
 	if (ahp->ah_hasHwPhyCounters) {
 		ath9k_hw_setrxfilter(ah,
 				     ath9k_hw_getrxfilter(ah) &
-				     ~HAL_RX_FILTER_PHYERR);
+				     ~ATH9K_RX_FILTER_PHYERR);
 		ath9k_ani_restart(ah);
 		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
@@ -2543,12 +2543,12 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 		ath9k_ani_restart(ah);
 		ath9k_hw_setrxfilter(ah,
 				     ath9k_hw_getrxfilter(ah) |
-				     HAL_RX_FILTER_PHYERR);
+				     ATH9K_RX_FILTER_PHYERR);
 	}
 }
 
 void ath9k_hw_procmibevent(struct ath_hal *ah,
-			   const struct hal_node_stats *stats)
+			   const struct ath9k_node_stats *stats)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t phyCnt1, phyCnt2;
@@ -2600,9 +2600,9 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 
 	aniState = ahp->ah_curani;
 
-	if (ah->ah_opmode == HAL_M_HOSTAP) {
+	if (ah->ah_opmode == ATH9K_M_HOSTAP) {
 		if (aniState->firstepLevel > 0) {
-			if (ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
+			if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 						 aniState->firstepLevel - 1)) {
 				return;
 			}
@@ -2614,7 +2614,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 		} else if (rssi > aniState->rssiThrLow) {
 			if (aniState->ofdmWeakSigDetectOff) {
 				if (ath9k_hw_ani_control(ah,
-					 HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+					 ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 					 true) ==
 				    true) {
 					return;
@@ -2622,7 +2622,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 			}
 			if (aniState->firstepLevel > 0) {
 				if (ath9k_hw_ani_control
-				    (ah, HAL_ANI_FIRSTEP_LEVEL,
+				    (ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel - 1) ==
 				    true) {
 					return;
@@ -2631,7 +2631,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 		} else {
 			if (aniState->firstepLevel > 0) {
 				if (ath9k_hw_ani_control
-				    (ah, HAL_ANI_FIRSTEP_LEVEL,
+				    (ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel - 1) ==
 				    true) {
 					return;
@@ -2641,14 +2641,14 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 	}
 
 	if (aniState->spurImmunityLevel > 0) {
-		if (ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL,
+		if (ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL,
 					 aniState->spurImmunityLevel - 1)) {
 			return;
 		}
 	}
 
 	if (aniState->noiseImmunityLevel > 0) {
-		ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
+		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL,
 				     aniState->noiseImmunityLevel - 1);
 		return;
 	}
@@ -2684,7 +2684,7 @@ static int32_t ath9k_hw_ani_get_listen_time(struct ath_hal *ah)
 }
 
 void ath9k_hw_ani_monitor(struct ath_hal *ah,
-			  const struct hal_node_stats *stats,
+			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -2784,7 +2784,7 @@ static void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah)
 		ah->nfCalHist[i].privNF = AR_PHY_CCA_MAX_GOOD_VALUE;
 		ah->nfCalHist[i].invalidNFcount =
 			AR_PHY_CCA_FILTERWINDOW_LENGTH;
-		for (j = 0; j < HAL_NF_CAL_HIST_MAX; j++) {
+		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
 			ah->nfCalHist[i].nfCalBuffer[j] =
 				AR_PHY_CCA_MAX_GOOD_VALUE;
 		}
@@ -2822,7 +2822,7 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 }
 
 static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
-				enum hal_gpio_output_mux_type
+				enum ath9k_gpio_output_mux_type
 				halSignalType)
 {
 	u_int32_t ah_signal_type;
@@ -2958,7 +2958,7 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	capField = ath9k_hw_get_eeprom(ahp, EEP_OP_CAP);
 
-	if (ah->ah_opmode != HAL_M_HOSTAP &&
+	if (ah->ah_opmode != ATH9K_M_HOSTAP &&
 	    ah->ah_subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (ah->ah_currentRD == 0x64 || ah->ah_currentRD == 0x65)
 			ah->ah_currentRD += 5;
@@ -3032,7 +3032,7 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 		pCap->halTotalQueues =
 			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
 	else
-		pCap->halTotalQueues = HAL_NUM_TX_QUEUES;
+		pCap->halTotalQueues = ATH9K_NUM_TX_QUEUES;
 
 	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
 		pCap->halKeyCacheSize =
@@ -3171,7 +3171,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 	if (setChip) {
 		if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M) ==
 		    AR_RTC_STATUS_SHUTDOWN) {
-			if (ath9k_hw_set_reset_reg(ah, HAL_RESET_POWER_ON)
+			if (ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)
 			    != true) {
 				return false;
 			}
@@ -3205,7 +3205,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 }
 
 bool ath9k_hw_setpower(struct ath_hal *ah,
-		       enum hal_power_mode mode)
+		       enum ath9k_power_mode mode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	static const char *modes[] = {
@@ -3221,14 +3221,14 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 		 setChip ? "set chip " : "");
 
 	switch (mode) {
-	case HAL_PM_AWAKE:
+	case ATH9K_PM_AWAKE:
 		status = ath9k_hw_set_power_awake(ah, setChip);
 		break;
-	case HAL_PM_FULL_SLEEP:
+	case ATH9K_PM_FULL_SLEEP:
 		ath9k_set_power_sleep(ah, setChip);
 		ahp->ah_chipFullSleep = true;
 		break;
-	case HAL_PM_NETWORK_SLEEP:
+	case ATH9K_PM_NETWORK_SLEEP:
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
@@ -3264,14 +3264,14 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	if (ah->ah_config.ath_hal_intrMitigation != 0)
 		ahp->ah_intrMitigation = true;
 
-	if (!ath9k_hw_set_reset_reg(ah, HAL_RESET_POWER_ON)) {
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't reset chip\n",
 			 __func__);
 		ecode = HAL_EIO;
 		goto bad;
 	}
 
-	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE)) {
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't wakeup chip\n",
 			 __func__);
 		ecode = HAL_EIO;
@@ -3334,13 +3334,13 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 
 	if (AR_SREV_9160(ah)) {
 		ah->ah_config.ath_hal_enableANI = 1;
-		ahp->ah_ani_function = (HAL_ANI_SPUR_IMMUNITY_LEVEL |
-					HAL_ANI_FIRSTEP_LEVEL);
+		ahp->ah_ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
+					ATH9K_ANI_FIRSTEP_LEVEL);
 	} else {
-		ahp->ah_ani_function = HAL_ANI_ALL;
+		ahp->ah_ani_function = ATH9K_ANI_ALL;
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
 			ahp->ah_ani_function &=
-				~HAL_ANI_NOISE_IMMUNITY_LEVEL;
+				~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		}
 	}
 
@@ -3519,7 +3519,7 @@ void ath9k_hw_detach(struct ath_hal *ah)
 		ath9k_hw_ani_detach(ah);
 	ath9k_hw_rfdetach(ah);
 
-	ath9k_hw_setpower(ah, HAL_PM_FULL_SLEEP);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 	kfree(ah);
 }
 
@@ -4187,7 +4187,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 
-	if (ah->ah_tpScale != HAL_TP_SCALE_MAX) {
+	if (ah->ah_tpScale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
 			(tpScaleReductionTable[(ah->ah_tpScale)] * 2);
 	}
@@ -5291,7 +5291,7 @@ bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	if (us < HAL_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
+	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad slot time %u\n",
 			 __func__, us);
 		ahp->ah_slottime = (u_int) -1;
@@ -5325,7 +5325,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 static inline enum hal_status
 ath9k_hw_process_ini(struct ath_hal *ah,
 		     struct ath9k_channel *chan,
-		     enum hal_ht_macmode macmode)
+		     enum ath9k_ht_macmode macmode)
 {
 	int i, regWrites = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -5602,7 +5602,7 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 static inline bool
 ath9k_hw_channel_change(struct ath_hal *ah,
 			struct ath9k_channel *chan,
-			enum hal_ht_macmode macmode)
+			enum ath9k_ht_macmode macmode)
 {
 	u_int32_t synthDelay, qnum;
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -5681,10 +5681,10 @@ static bool ath9k_hw_chip_reset(struct ath_hal *ah,
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	if (!ath9k_hw_set_reset_reg(ah, HAL_RESET_WARM))
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
-	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	ahp->ah_chipFullSleep = false;
@@ -5839,11 +5839,11 @@ static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
 }
 
 
-bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
+bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    struct ath9k_channel *chan,
-		    enum hal_ht_macmode macmode,
+		    enum ath9k_ht_macmode macmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
-		    enum hal_ht_extprotspacing extprotspacing,
+		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
 		    enum hal_status *status)
 {
@@ -5872,7 +5872,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 		FAIL(HAL_EINVAL);
 	}
 
-	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	if (curchan)
@@ -5923,7 +5923,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 			else
 				ath9k_hw_set_gpio(ah, 9, 1);
 		}
-		ath9k_hw_cfg_output(ah, 9, HAL_GPIO_OUTPUT_MUX_AS_OUTPUT);
+		ath9k_hw_cfg_output(ah, 9, ATH9K_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	}
 
 	ecode = ath9k_hw_process_ini(ah, chan, macmode);
@@ -6047,15 +6047,15 @@ bad:
 
 bool ath9k_hw_phy_disable(struct ath_hal *ah)
 {
-	return ath9k_hw_set_reset_reg(ah, HAL_RESET_WARM);
+	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM);
 }
 
 bool ath9k_hw_disable(struct ath_hal *ah)
 {
-	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
-	return ath9k_hw_set_reset_reg(ah, HAL_RESET_COLD);
+	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
 }
 
 bool
@@ -6429,7 +6429,7 @@ ath9k_hw_get_channel_centers(struct ath_hal *ah,
 		((ahp->
 		ah_extprotspacing
 		==
-		HAL_HT_EXTPROTSPACING_20)
+		ATH9K_HT_EXTPROTSPACING_20)
 		?
 		HT40_CHANNEL_CENTER_SHIFT
 		: 15));
@@ -6597,7 +6597,7 @@ void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna)
 
 bool
 ath9k_hw_setantennaswitch(struct ath_hal *ah,
-			  enum hal_ant_setting settings,
+			  enum ath9k_ant_setting settings,
 			  struct ath9k_channel *chan,
 			  u_int8_t *tx_chainmask,
 			  u_int8_t *rx_chainmask,
@@ -6614,12 +6614,12 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 		}
 
 		switch (settings) {
-		case HAL_ANT_FIXED_A:
+		case ATH9K_ANT_FIXED_A:
 			*tx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
 			*rx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
 			*antenna_cfgd = true;
 			break;
-		case HAL_ANT_FIXED_B:
+		case ATH9K_ANT_FIXED_B:
 			if (ah->ah_caps.halTxChainMask >
 			    ATH9K_ANTENNA1_CHAINMASK) {
 				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
@@ -6627,7 +6627,7 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			*rx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
 			*antenna_cfgd = true;
 			break;
-		case HAL_ANT_VARIABLE:
+		case ATH9K_ANT_VARIABLE:
 			*tx_chainmask = tx_chainmask_cfg;
 			*rx_chainmask = rx_chainmask_cfg;
 			*antenna_cfgd = true;
@@ -6657,12 +6657,12 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 	switch (type) {
 	case HAL_CAP_CIPHER:
 		switch (capability) {
-		case HAL_CIPHER_AES_CCM:
-		case HAL_CIPHER_AES_OCB:
-		case HAL_CIPHER_TKIP:
-		case HAL_CIPHER_WEP:
-		case HAL_CIPHER_MIC:
-		case HAL_CIPHER_CLR:
+		case ATH9K_CIPHER_AES_CCM:
+		case ATH9K_CIPHER_AES_OCB:
+		case ATH9K_CIPHER_TKIP:
+		case ATH9K_CIPHER_WEP:
+		case ATH9K_CIPHER_MIC:
+		case ATH9K_CIPHER_CLR:
 			return true;
 		default:
 			return false;
@@ -6779,7 +6779,7 @@ bool ath9k_hw_intrpend(struct ath_hal *ah)
 	return false;
 }
 
-bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
+bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 {
 	u_int32_t isr = 0;
 	u_int32_t mask2 = 0;
@@ -6815,17 +6815,17 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 			u_int32_t isr2;
 			isr2 = REG_READ(ah, AR_ISR_S2);
 			if (isr2 & AR_ISR_S2_TIM)
-				mask2 |= HAL_INT_TIM;
+				mask2 |= ATH9K_INT_TIM;
 			if (isr2 & AR_ISR_S2_DTIM)
-				mask2 |= HAL_INT_DTIM;
+				mask2 |= ATH9K_INT_DTIM;
 			if (isr2 & AR_ISR_S2_DTIMSYNC)
-				mask2 |= HAL_INT_DTIMSYNC;
+				mask2 |= ATH9K_INT_DTIMSYNC;
 			if (isr2 & (AR_ISR_S2_CABEND))
-				mask2 |= HAL_INT_CABEND;
+				mask2 |= ATH9K_INT_CABEND;
 			if (isr2 & AR_ISR_S2_GTT)
-				mask2 |= HAL_INT_GTT;
+				mask2 |= ATH9K_INT_GTT;
 			if (isr2 & AR_ISR_S2_CST)
-				mask2 |= HAL_INT_CST;
+				mask2 |= ATH9K_INT_CST;
 		}
 
 		isr = REG_READ(ah, AR_ISR_RAC);
@@ -6834,22 +6834,22 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 			return false;
 		}
 
-		*masked = isr & HAL_INT_COMMON;
+		*masked = isr & ATH9K_INT_COMMON;
 
 		if (ahp->ah_intrMitigation) {
 
 			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
-				*masked |= HAL_INT_RX;
+				*masked |= ATH9K_INT_RX;
 		}
 
 		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
-			*masked |= HAL_INT_RX;
+			*masked |= ATH9K_INT_RX;
 		if (isr &
 		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
 		     AR_ISR_TXEOL)) {
 			u_int32_t s0_s, s1_s;
 
-			*masked |= HAL_INT_TX;
+			*masked |= ATH9K_INT_TX;
 
 			s0_s = REG_READ(ah, AR_ISR_S0_S);
 			ahp->ah_intrTxqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
@@ -6870,7 +6870,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 			if (!pCap->halAutoSleepSupport) {
 				u_int32_t isr5 = REG_READ(ah, AR_ISR_S5_S);
 				if (isr5 & AR_ISR_S5_TIM_TIMER)
-					*masked |= HAL_INT_TIM_TIMER;
+					*masked |= ATH9K_INT_TIM_TIMER;
 			}
 		}
 
@@ -6902,7 +6902,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 				 __func__);
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
-			*masked |= HAL_INT_FATAL;
+			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
 			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
@@ -6916,12 +6916,12 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 	return true;
 }
 
-enum hal_int ath9k_hw_intrget(struct ath_hal *ah)
+enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah)
 {
 	return AH5416(ah)->ah_maskReg;
 }
 
-enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t omask = ahp->ah_maskReg;
@@ -6931,7 +6931,7 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
 		 omask, ints);
 
-	if (omask & HAL_INT_GLOBAL) {
+	if (omask & ATH9K_INT_GLOBAL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: disable IER\n",
 			 __func__);
 		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
@@ -6945,10 +6945,10 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 		}
 	}
 
-	mask = ints & HAL_INT_COMMON;
+	mask = ints & ATH9K_INT_COMMON;
 	mask2 = 0;
 
-	if (ints & HAL_INT_TX) {
+	if (ints & ATH9K_INT_TX) {
 		if (ahp->ah_txOkInterruptMask)
 			mask |= AR_IMR_TXOK;
 		if (ahp->ah_txDescInterruptMask)
@@ -6958,7 +6958,7 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 		if (ahp->ah_txEolInterruptMask)
 			mask |= AR_IMR_TXEOL;
 	}
-	if (ints & HAL_INT_RX) {
+	if (ints & ATH9K_INT_RX) {
 		mask |= AR_IMR_RXERR;
 		if (ahp->ah_intrMitigation)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
@@ -6968,23 +6968,23 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 			mask |= AR_IMR_GENTMR;
 	}
 
-	if (ints & (HAL_INT_BMISC)) {
+	if (ints & (ATH9K_INT_BMISC)) {
 		mask |= AR_IMR_BCNMISC;
-		if (ints & HAL_INT_TIM)
+		if (ints & ATH9K_INT_TIM)
 			mask2 |= AR_IMR_S2_TIM;
-		if (ints & HAL_INT_DTIM)
+		if (ints & ATH9K_INT_DTIM)
 			mask2 |= AR_IMR_S2_DTIM;
-		if (ints & HAL_INT_DTIMSYNC)
+		if (ints & ATH9K_INT_DTIMSYNC)
 			mask2 |= AR_IMR_S2_DTIMSYNC;
-		if (ints & HAL_INT_CABEND)
+		if (ints & ATH9K_INT_CABEND)
 			mask2 |= (AR_IMR_S2_CABEND);
 	}
 
-	if (ints & (HAL_INT_GTT | HAL_INT_CST)) {
+	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
 		mask |= AR_IMR_BCNMISC;
-		if (ints & HAL_INT_GTT)
+		if (ints & ATH9K_INT_GTT)
 			mask2 |= AR_IMR_S2_GTT;
-		if (ints & HAL_INT_CST)
+		if (ints & ATH9K_INT_CST)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
@@ -7002,13 +7002,13 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 	ahp->ah_maskReg = ints;
 
 	if (!pCap->halAutoSleepSupport) {
-		if (ints & HAL_INT_TIM_TIMER)
+		if (ints & ATH9K_INT_TIM_TIMER)
 			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 		else
 			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
-	if (ints & HAL_INT_GLOBAL) {
+	if (ints & ATH9K_INT_GLOBAL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: enable IER\n",
 			 __func__);
 		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
@@ -7040,14 +7040,14 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 	ahp->ah_beaconInterval = beacon_period;
 
 	switch (ah->ah_opmode) {
-	case HAL_M_STA:
-	case HAL_M_MONITOR:
+	case ATH9K_M_STA:
+	case ATH9K_M_MONITOR:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
 		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
 		flags |= AR_TBTT_TIMER_EN;
 		break;
-	case HAL_M_IBSS:
+	case ATH9K_M_IBSS:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
@@ -7055,7 +7055,7 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 				     (ahp->ah_atimWindow ? ahp->
 				      ah_atimWindow : 1)));
 		flags |= AR_NDP_TIMER_EN;
-	case HAL_M_HOSTAP:
+	case ATH9K_M_HOSTAP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
 			  TU_TO_USEC(next_beacon -
@@ -7075,9 +7075,9 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 	REG_WRITE(ah, AR_SWBA_PERIOD, TU_TO_USEC(beacon_period));
 	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
 
-	beacon_period &= ~HAL_BEACON_ENA;
-	if (beacon_period & HAL_BEACON_RESET_TSF) {
-		beacon_period &= ~HAL_BEACON_RESET_TSF;
+	beacon_period &= ~ATH9K_BEACON_ENA;
+	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
+		beacon_period &= ~ATH9K_BEACON_RESET_TSF;
 		ath9k_hw_reset_tsf(ah);
 	}
 
@@ -7086,7 +7086,7 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 
 void
 ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
-			       const struct hal_beacon_state *bs)
+			       const struct ath9k_beacon_state *bs)
 {
 	u_int32_t nextTbtt, beaconintval, dtimperiod, beacontimeout;
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7094,14 +7094,14 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
 	REG_WRITE(ah, AR_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval & HAL_BEACON_PERIOD));
+		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval & HAL_BEACON_PERIOD));
+		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
 
 	REG_RMW_FIELD(ah, AR_RSSI_THR,
 		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
 
-	beaconintval = bs->bs_intval & HAL_BEACON_PERIOD;
+	beaconintval = bs->bs_intval & ATH9K_BEACON_PERIOD;
 
 	if (bs->bs_sleepduration > beaconintval)
 		beaconintval = bs->bs_sleepduration;
@@ -7225,7 +7225,7 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 
 bool
 ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
-			    const struct hal_keyval *k,
+			    const struct ath9k_keyval *k,
 			    const u_int8_t *mac, int xorKey)
 {
 	const struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7242,10 +7242,10 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		return false;
 	}
 	switch (k->kv_type) {
-	case HAL_CIPHER_AES_OCB:
+	case ATH9K_CIPHER_AES_OCB:
 		keyType = AR_KEYTABLE_TYPE_AES;
 		break;
-	case HAL_CIPHER_AES_CCM:
+	case ATH9K_CIPHER_AES_CCM:
 		if (!pCap->halCipherAesCcmSupport) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: AES-CCM not supported by "
@@ -7255,7 +7255,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		}
 		keyType = AR_KEYTABLE_TYPE_CCM;
 		break;
-	case HAL_CIPHER_TKIP:
+	case ATH9K_CIPHER_TKIP:
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->halKeyCacheSize) {
@@ -7265,7 +7265,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 			return false;
 		}
 		break;
-	case HAL_CIPHER_WEP:
+	case ATH9K_CIPHER_WEP:
 		if (k->kv_len < 40 / NBBY) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: WEP key length %u too small\n",
@@ -7279,7 +7279,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		else
 			keyType = AR_KEYTABLE_TYPE_128;
 		break;
-	case HAL_CIPHER_CLR:
+	case ATH9K_CIPHER_CLR:
 		keyType = AR_KEYTABLE_TYPE_CLR;
 		break;
 	default:
@@ -7363,12 +7363,13 @@ ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t txcfg, curLevel, newLevel;
-	enum hal_int omask;
+	enum ath9k_int omask;
 
 	if (ah->ah_txTrigLevel >= MAX_TX_FIFO_THRESHOLD)
 		return false;
 
-	omask = ath9k_hw_set_interrupts(ah, ahp->ah_maskReg & ~HAL_INT_GLOBAL);
+	omask = ath9k_hw_set_interrupts(ah,
+					ahp->ah_maskReg & ~ATH9K_INT_GLOBAL);
 
 	txcfg = REG_READ(ah, AR_TXCFG);
 	curLevel = MS(txcfg, AR_FTRIG);
@@ -7390,12 +7391,12 @@ ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 }
 
 static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
-				   struct hal_tx_queue_info *qi,
-				   const struct hal_txq_info *qInfo)
+				   struct ath9k_tx_queue_info *qi,
+				   const struct ath9k_txq_info *qInfo)
 {
 	u_int32_t cw;
 
-	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
 		return false;
@@ -7407,18 +7408,18 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 	qi->tqi_subtype = qInfo->tqi_subtype;
 	qi->tqi_qflags = qInfo->tqi_qflags;
 	qi->tqi_priority = qInfo->tqi_priority;
-	if (qInfo->tqi_aifs != HAL_TXQ_USEDEFAULT)
+	if (qInfo->tqi_aifs != ATH9K_TXQ_USEDEFAULT)
 		qi->tqi_aifs = min(qInfo->tqi_aifs, 255U);
 	else
 		qi->tqi_aifs = INIT_AIFS;
-	if (qInfo->tqi_cwmin != HAL_TXQ_USEDEFAULT) {
+	if (qInfo->tqi_cwmin != ATH9K_TXQ_USEDEFAULT) {
 		cw = min(qInfo->tqi_cwmin, 1024U);
 		qi->tqi_cwmin = 1;
 		while (qi->tqi_cwmin < cw)
 			qi->tqi_cwmin = (qi->tqi_cwmin << 1) | 1;
 	} else
 		qi->tqi_cwmin = qInfo->tqi_cwmin;
-	if (qInfo->tqi_cwmax != HAL_TXQ_USEDEFAULT) {
+	if (qInfo->tqi_cwmax != ATH9K_TXQ_USEDEFAULT) {
 		cw = min(qInfo->tqi_cwmax, 1024U);
 		qi->tqi_cwmax = 1;
 		while (qi->tqi_cwmax < cw)
@@ -7440,9 +7441,9 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 	qi->tqi_readyTime = qInfo->tqi_readyTime;
 
 	switch (qInfo->tqi_subtype) {
-	case HAL_WME_UPSD:
-		if (qi->tqi_type == HAL_TX_QUEUE_DATA)
-			qi->tqi_intFlags = HAL_TXQ_USE_LOCKOUT_BKOFF_DIS;
+	case ATH9K_WME_UPSD:
+		if (qi->tqi_type == ATH9K_TX_QUEUE_DATA)
+			qi->tqi_intFlags = ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS;
 		break;
 	default:
 		break;
@@ -7451,7 +7452,7 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 }
 
 bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-			      const struct hal_txq_info *qInfo)
+			      const struct ath9k_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7465,10 +7466,10 @@ bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 }
 
 static bool ath9k_hw_get_txq_props(struct ath_hal *ah,
-				   struct hal_txq_info *qInfo,
-				   const struct hal_tx_queue_info *qi)
+				   struct ath9k_txq_info *qInfo,
+				   const struct ath9k_tx_queue_info *qi)
 {
-	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
 		return false;
@@ -7494,7 +7495,7 @@ static bool ath9k_hw_get_txq_props(struct ath_hal *ah,
 
 bool
 ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
-			 struct hal_txq_info *qInfo)
+			 struct ath9k_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7508,31 +7509,31 @@ ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 }
 
 int
-ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
-		      const struct hal_txq_info *qInfo)
+ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
+		      const struct ath9k_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_tx_queue_info *qi;
+	struct ath9k_tx_queue_info *qi;
 	struct hal_capabilities *pCap = &ah->ah_caps;
 	int q;
 
 	switch (type) {
-	case HAL_TX_QUEUE_BEACON:
+	case ATH9K_TX_QUEUE_BEACON:
 		q = pCap->halTotalQueues - 1;
 		break;
-	case HAL_TX_QUEUE_CAB:
+	case ATH9K_TX_QUEUE_CAB:
 		q = pCap->halTotalQueues - 2;
 		break;
-	case HAL_TX_QUEUE_PSPOLL:
+	case ATH9K_TX_QUEUE_PSPOLL:
 		q = 1;
 		break;
-	case HAL_TX_QUEUE_UAPSD:
+	case ATH9K_TX_QUEUE_UAPSD:
 		q = pCap->halTotalQueues - 3;
 		break;
-	case HAL_TX_QUEUE_DATA:
+	case ATH9K_TX_QUEUE_DATA:
 		for (q = 0; q < pCap->halTotalQueues; q++)
 			if (ahp->ah_txq[q].tqi_type ==
-			    HAL_TX_QUEUE_INACTIVE)
+			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
 		if (q == pCap->halTotalQueues) {
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
@@ -7549,12 +7550,12 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
 
 	qi = &ahp->ah_txq[q];
-	if (qi->tqi_type != HAL_TX_QUEUE_INACTIVE) {
+	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 			 "%s: tx queue %u already active\n", __func__, q);
 		return -1;
 	}
-	memset(qi, 0, sizeof(struct hal_tx_queue_info));
+	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
 	qi->tqi_type = type;
 	if (qInfo == NULL) {
 		qi->tqi_qflags =
@@ -7562,7 +7563,7 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
 			| TXQ_FLAG_TXERRINT_ENABLE
 			| TXQ_FLAG_TXDESCINT_ENABLE | TXQ_FLAG_TXURNINT_ENABLE;
 		qi->tqi_aifs = INIT_AIFS;
-		qi->tqi_cwmin = HAL_TXQ_USEDEFAULT;
+		qi->tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
 		qi->tqi_cwmax = INIT_CWMAX;
 		qi->tqi_shretry = INIT_SH_RETRY;
 		qi->tqi_lgretry = INIT_LG_RETRY;
@@ -7577,7 +7578,7 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
 
 static void
 ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
-			    struct hal_tx_queue_info *qi)
+			    struct ath9k_tx_queue_info *qi)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -7601,7 +7602,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
-	struct hal_tx_queue_info *qi;
+	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->halTotalQueues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
@@ -7609,7 +7610,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 		return false;
 	}
 	qi = &ahp->ah_txq[q];
-	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
 		return false;
@@ -7618,7 +7619,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: release queue %u\n",
 		__func__, q);
 
-	qi->tqi_type = HAL_TX_QUEUE_INACTIVE;
+	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ahp->ah_txOkInterruptMask &= ~(1 << q);
 	ahp->ah_txErrInterruptMask &= ~(1 << q);
 	ahp->ah_txDescInterruptMask &= ~(1 << q);
@@ -7634,7 +7635,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_channel *chan = ah->ah_curchan;
-	struct hal_tx_queue_info *qi;
+	struct ath9k_tx_queue_info *qi;
 	u_int32_t cwMin, chanCwMin, value;
 
 	if (q >= pCap->halTotalQueues) {
@@ -7643,7 +7644,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 		return false;
 	}
 	qi = &ahp->ah_txq[q];
-	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
 		return true;
@@ -7651,7 +7652,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: reset queue %u\n", __func__, q);
 
-	if (qi->tqi_cwmin == HAL_TXQ_USEDEFAULT) {
+	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
 			chanCwMin = INIT_CWMIN_11B;
 		else
@@ -7690,7 +7691,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 					:
 					0));
 	}
-	if (qi->tqi_readyTime && (qi->tqi_type != HAL_TX_QUEUE_CAB)) {
+	if (qi->tqi_readyTime && (qi->tqi_type != ATH9K_TX_QUEUE_CAB)) {
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
 			  SM(qi->tqi_readyTime, AR_Q_RDYTIMECFG_DURATION) |
 			  AR_Q_RDYTIMECFG_EN);
@@ -7720,7 +7721,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 			  AR_D_MISC_FRAG_BKOFF_EN);
 	}
 	switch (qi->tqi_type) {
-	case HAL_TX_QUEUE_BEACON:
+	case ATH9K_TX_QUEUE_BEACON:
 		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
 			  | AR_Q_MISC_FSP_DBA_GATED
 			  | AR_Q_MISC_BEACON_USE
@@ -7732,7 +7733,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 			  | AR_D_MISC_BEACON_USE
 			  | AR_D_MISC_POST_FR_BKOFF_DIS);
 		break;
-	case HAL_TX_QUEUE_CAB:
+	case ATH9K_TX_QUEUE_CAB:
 		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
 			  | AR_Q_MISC_FSP_DBA_GATED
 			  | AR_Q_MISC_CBR_INCR_DIS1
@@ -7749,12 +7750,12 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 			  | (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S));
 		break;
-	case HAL_TX_QUEUE_PSPOLL:
+	case ATH9K_TX_QUEUE_PSPOLL:
 		REG_WRITE(ah, AR_QMISC(q),
 			  REG_READ(ah,
 				   AR_QMISC(q)) | AR_Q_MISC_CBR_INCR_DIS1);
 		break;
-	case HAL_TX_QUEUE_UAPSD:
+	case ATH9K_TX_QUEUE_UAPSD:
 		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q))
 			  | AR_D_MISC_POST_FR_BKOFF_DIS);
 		break;
@@ -7762,7 +7763,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 		break;
 	}
 
-	if (qi->tqi_intFlags & HAL_TXQ_USE_LOCKOUT_BKOFF_DIS) {
+	if (qi->tqi_intFlags & ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS) {
 		REG_WRITE(ah, AR_DMISC(q),
 			  REG_READ(ah, AR_DMISC(q)) |
 			  SM(AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL,
@@ -7917,8 +7918,8 @@ ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 
 void
 ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-		       u_int pktLen, enum hal_pkt_type type, u_int txPower,
-		       u_int keyIx, enum hal_key_type keyType, u_int flags)
+		       u_int pktLen, enum ath9k_pkt_type type, u_int txPower,
+		       u_int keyIx, enum ath9k_key_type keyType, u_int flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -7928,19 +7929,19 @@ ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
 		txPower = 63;
 
 	ads->ds_ctl0 = (pktLen & AR_FrameLen)
-		| (flags & HAL_TXDESC_VMF ? AR_VirtMoreFrag : 0)
+		| (flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
 		| SM(txPower, AR_XmitPower)
-		| (flags & HAL_TXDESC_VEOL ? AR_VEOL : 0)
-		| (flags & HAL_TXDESC_CLRDMASK ? AR_ClrDestMask : 0)
-		| (flags & HAL_TXDESC_INTREQ ? AR_TxIntrReq : 0)
-		| (keyIx != HAL_TXKEYIX_INVALID ? AR_DestIdxValid : 0);
+		| (flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
+		| (flags & ATH9K_TXDESC_CLRDMASK ? AR_ClrDestMask : 0)
+		| (flags & ATH9K_TXDESC_INTREQ ? AR_TxIntrReq : 0)
+		| (keyIx != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0);
 
 	ads->ds_ctl1 =
-		(keyIx != HAL_TXKEYIX_INVALID ? SM(keyIx, AR_DestIdx) : 0)
+		(keyIx != ATH9K_TXKEYIX_INVALID ? SM(keyIx, AR_DestIdx) : 0)
 		| SM(type, AR_FrameType)
-		| (flags & HAL_TXDESC_NOACK ? AR_NoAck : 0)
-		| (flags & HAL_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
-		| (flags & HAL_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
+		| (flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
+		| (flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
+		| (flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
 
 	ads->ds_ctl6 = SM(keyType, AR_EncrType);
 
@@ -7958,7 +7959,7 @@ ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 			     struct ath_desc *lastds,
 			     u_int durUpdateEn, u_int rtsctsRate,
 			     u_int rtsctsDuration,
-			     struct hal_11n_rate_series series[],
+			     struct ath9k_11n_rate_series series[],
 			     u_int nseries, u_int flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
@@ -7968,10 +7969,10 @@ ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 	(void) nseries;
 	(void) rtsctsDuration;
 
-	if (flags & (HAL_TXDESC_RTSENA | HAL_TXDESC_CTSENA)) {
+	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
 		ds_ctl0 = ads->ds_ctl0;
 
-		if (flags & HAL_TXDESC_RTSENA) {
+		if (flags & ATH9K_TXDESC_RTSENA) {
 			ds_ctl0 &= ~AR_CTSEnable;
 			ds_ctl0 |= AR_RTSEnable;
 		} else {
@@ -8133,7 +8134,7 @@ ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	ads->ds_ctl1 = size & AR_BufLen;
-	if (flags & HAL_RXDESC_INTREQ)
+	if (flags & ATH9K_RXDESC_INTREQ)
 		ads->ds_ctl1 |= AR_RxIntrReq;
 
 	ads->ds_rxstatus8 &= ~AR_RxDone;
@@ -8170,7 +8171,7 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 	if (ads.ds_rxstatus8 & AR_RxKeyIdxValid)
 		ds->ds_rxstat.rs_keyix = MS(ads.ds_rxstatus8, AR_KeyIdx);
 	else
-		ds->ds_rxstat.rs_keyix = HAL_RXKEYIX_INVALID;
+		ds->ds_rxstat.rs_keyix = ATH9K_RXKEYIX_INVALID;
 
 	ds->ds_rxstat.rs_rate = RXSTATUS_RATE(ah, (&ads));
 	ds->ds_rxstat.rs_more = (ads.ds_rxstatus1 & AR_RxMore) ? 1 : 0;
@@ -8211,7 +8212,7 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 }
 
 static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
-				      struct hal_rate_table *rt)
+				      struct ath9k_rate_table *rt)
 {
 	int i;
 
@@ -8239,10 +8240,10 @@ static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
 	}
 }
 
-const struct hal_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
+const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 						   u_int mode)
 {
-	struct hal_rate_table *rt;
+	struct ath9k_rate_table *rt;
 	switch (mode) {
 	case ATH9K_MODE_SEL_11A:
 		rt = &ar5416_11a_table;
@@ -8329,7 +8330,7 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 
 u_int16_t
 ath9k_hw_computetxtime(struct ath_hal *ah,
-		       const struct hal_rate_table *rates,
+		       const struct ath9k_rate_table *rates,
 		       u_int32_t frameLen, u_int16_t rateix,
 		       bool shortPreamble)
 {
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 1b6429f..1f68317 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -326,13 +326,13 @@ struct ar5416_desc {
 
 #define set11nPktDurRTSCTS(_series, _index)				\
 	(SM((_series)[_index].PktDuration, AR_PacketDur##_index) |	\
-	((_series)[_index].RateFlags & HAL_RATESERIES_RTS_CTS   ?	\
+	((_series)[_index].RateFlags & ATH9K_RATESERIES_RTS_CTS   ?	\
 		AR_RTSCTSQual##_index : 0))
 
 #define set11nRateFlags(_series, _index)				\
-	(((_series)[_index].RateFlags & HAL_RATESERIES_2040 ? \
+	(((_series)[_index].RateFlags & ATH9K_RATESERIES_2040 ? \
 		AR_2040_##_index : 0) \
-	|((_series)[_index].RateFlags & HAL_RATESERIES_HALFGI ? \
+	|((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ? \
 		AR_GI##_index : 0) \
 	|SM((_series)[_index].ChSel, AR_ChainSel##_index))
 
@@ -399,8 +399,8 @@ struct ar5416Stats {
 	u_int32_t ast_ani_reset;
 	u_int32_t ast_ani_lzero;
 	u_int32_t ast_ani_lneg;
-	struct hal_mib_stats ast_mibstats;
-	struct hal_node_stats ast_nodestats;
+	struct ath9k_mib_stats ast_mibstats;
+	struct ath9k_node_stats ast_nodestats;
 };
 
 #define AR5416_OPFLAGS_11A           0x01
@@ -709,11 +709,11 @@ struct ath_hal_5416 {
 	u_int32_t ah_txDescInterruptMask;
 	u_int32_t ah_txEolInterruptMask;
 	u_int32_t ah_txUrnInterruptMask;
-	struct hal_tx_queue_info ah_txq[HAL_NUM_TX_QUEUES];
-	enum hal_power_mode ah_powerMode;
+	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
+	enum ath9k_power_mode ah_powerMode;
 	bool ah_chipFullSleep;
 	u_int32_t ah_atimWindow;
-	enum hal_ant_setting ah_diversityControl;
+	enum ath9k_ant_setting ah_diversityControl;
 	u_int16_t ah_antennaSwitchSwap;
 	enum hal_cal_types ah_suppCals;
 	struct hal_cal_list ah_iqCalData;
@@ -796,12 +796,12 @@ struct ath_hal_5416 {
 	u_int32_t ah_cycleCount;
 	u_int32_t ah_ctlBusy;
 	u_int32_t ah_extBusy;
-	enum hal_ht_extprotspacing ah_extprotspacing;
+	enum ath9k_ht_extprotspacing ah_extprotspacing;
 	u_int8_t ah_txchainmask;
 	u_int8_t ah_rxchainmask;
 	int ah_hwp;
 	void __iomem *ah_cal_mem;
-	enum hal_ani_cmd ah_ani_function;
+	enum ath9k_ani_cmd ah_ani_function;
 	struct ar5416IniArray ah_iniModes;
 	struct ar5416IniArray ah_iniCommon;
 	struct ar5416IniArray ah_iniBank0;
@@ -853,8 +853,8 @@ struct ath_hal_5416 {
 #define HT40_CHANNEL_CENTER_SHIFT   10
 
 #define ar5416CheckOpMode(_opmode)					\
-	((_opmode == HAL_M_STA) || (_opmode == HAL_M_IBSS) ||		\
-	 (_opmode == HAL_M_HOSTAP) || (_opmode == HAL_M_MONITOR))
+	((_opmode == ATH9K_M_STA) || (_opmode == ATH9K_M_IBSS) ||	\
+	 (_opmode == ATH9K_M_HOSTAP) || (_opmode == ATH9K_M_MONITOR))
 
 #define AR5416_EEPROM_MAGIC_OFFSET  0x0
 
@@ -894,18 +894,18 @@ struct ath_hal_5416 {
 #define HAL_SPUR_IMMUNE_MAX             7
 #define HAL_FIRST_STEP_MAX              2
 
-#define HAL_ANI_OFDM_TRIG_HIGH          500
-#define HAL_ANI_OFDM_TRIG_LOW           200
-#define HAL_ANI_CCK_TRIG_HIGH           200
-#define HAL_ANI_CCK_TRIG_LOW            100
-#define HAL_ANI_NOISE_IMMUNE_LVL        4
-#define HAL_ANI_USE_OFDM_WEAK_SIG       true
-#define HAL_ANI_CCK_WEAK_SIG_THR        false
-#define HAL_ANI_SPUR_IMMUNE_LVL         7
-#define HAL_ANI_FIRSTEP_LVL             0
-#define HAL_ANI_RSSI_THR_HIGH           40
-#define HAL_ANI_RSSI_THR_LOW            7
-#define HAL_ANI_PERIOD                  100
+#define ATH9K_ANI_OFDM_TRIG_HIGH          500
+#define ATH9K_ANI_OFDM_TRIG_LOW           200
+#define ATH9K_ANI_CCK_TRIG_HIGH           200
+#define ATH9K_ANI_CCK_TRIG_LOW            100
+#define ATH9K_ANI_NOISE_IMMUNE_LVL        4
+#define ATH9K_ANI_USE_OFDM_WEAK_SIG       true
+#define ATH9K_ANI_CCK_WEAK_SIG_THR        false
+#define ATH9K_ANI_SPUR_IMMUNE_LVL         7
+#define ATH9K_ANI_FIRSTEP_LVL             0
+#define ATH9K_ANI_RSSI_THR_HIGH           40
+#define ATH9K_ANI_RSSI_THR_LOW            7
+#define ATH9K_ANI_PERIOD                  100
 
 #define AR_GPIOD_MASK                   0x00001FFF
 #define AR_GPIO_BIT(_gpio)              (1 << (_gpio))
@@ -916,7 +916,7 @@ struct ath_hal_5416 {
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 #define BEACON_RSSI(ahp) \
 	HAL_EP_RND(ahp->ah_stats.ast_nodestats.ns_avgbrssi, \
-		HAL_RSSI_EP_MULTIPLIER)
+		ATH9K_RSSI_EP_MULTIPLIER)
 
 #define ah_mibStats     ah_stats.ast_mibstats
 
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 08b800f..effcce9 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -59,29 +59,29 @@ static u_int32_t ath_get_extchanmode(struct ath_softc *sc,
 {
 	u_int32_t chanmode = 0;
 	u_int8_t ext_chan_offset = sc->sc_ht_info.ext_chan_offset;
-	enum hal_ht_macmode tx_chan_width = sc->sc_ht_info.tx_chan_width;
+	enum ath9k_ht_macmode tx_chan_width = sc->sc_ht_info.tx_chan_width;
 
 	switch (chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_NONE) &&
-		    (tx_chan_width == HAL_HT_MACMODE_20))
+		    (tx_chan_width == ATH9K_HT_MACMODE_20))
 			chanmode = CHANNEL_G_HT20;
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
-		    (tx_chan_width == HAL_HT_MACMODE_2040))
+		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_G_HT40PLUS;
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_BELOW) &&
-		    (tx_chan_width == HAL_HT_MACMODE_2040))
+		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_G_HT40MINUS;
 		break;
 	case IEEE80211_BAND_5GHZ:
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_NONE) &&
-		    (tx_chan_width == HAL_HT_MACMODE_20))
+		    (tx_chan_width == ATH9K_HT_MACMODE_20))
 			chanmode = CHANNEL_A_HT20;
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
-		    (tx_chan_width == HAL_HT_MACMODE_2040))
+		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_A_HT40PLUS;
 		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_BELOW) &&
-		    (tx_chan_width == HAL_HT_MACMODE_2040))
+		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_A_HT40MINUS;
 		break;
 	default:
@@ -94,7 +94,7 @@ static u_int32_t ath_get_extchanmode(struct ath_softc *sc,
 
 static int ath_setkey_tkip(struct ath_softc *sc,
 			   struct ieee80211_key_conf *key,
-			   struct hal_keyval *hk,
+			   struct ath9k_keyval *hk,
 			   const u8 *addr)
 {
 	u8 *key_rxmic = NULL;
@@ -139,7 +139,7 @@ static int ath_key_config(struct ath_softc *sc,
 			  struct ieee80211_key_conf *key)
 {
 	struct ieee80211_vif *vif;
-	struct hal_keyval hk;
+	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
 	int ret = 0;
 	enum ieee80211_if_types opmode;
@@ -148,13 +148,13 @@ static int ath_key_config(struct ath_softc *sc,
 
 	switch (key->alg) {
 	case ALG_WEP:
-		hk.kv_type = HAL_CIPHER_WEP;
+		hk.kv_type = ATH9K_CIPHER_WEP;
 		break;
 	case ALG_TKIP:
-		hk.kv_type = HAL_CIPHER_TKIP;
+		hk.kv_type = ATH9K_CIPHER_TKIP;
 		break;
 	case ALG_CCMP:
-		hk.kv_type = HAL_CIPHER_AES_CCM;
+		hk.kv_type = ATH9K_CIPHER_AES_CCM;
 		break;
 	default:
 		return -EINVAL;
@@ -420,10 +420,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-		ic_opmode = HAL_M_STA;
+		ic_opmode = ATH9K_M_STA;
 		break;
 	case IEEE80211_IF_TYPE_IBSS:
-		ic_opmode = HAL_M_IBSS;
+		ic_opmode = ATH9K_M_IBSS;
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -471,14 +471,14 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath_rate_newstate(sc, avp);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_opmode == HAL_M_HOSTAP || sc->sc_opmode == HAL_M_IBSS) {
+	if (sc->sc_opmode == ATH9K_M_HOSTAP || sc->sc_opmode == ATH9K_M_IBSS) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
 		ath_beacon_return(sc, avp);
 	}
 
 	/* Set interrupt mask */
-	sc->sc_imask &= ~(HAL_INT_SWBA | HAL_INT_BMISS);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask & ~HAL_INT_GLOBAL);
+	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask & ~ATH9K_INT_GLOBAL);
 	sc->sc_beacons = 0;
 
 	error = ath_vap_detach(sc, 0);
@@ -568,9 +568,9 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 
 			/* Disable BMISS interrupt when we're not associated */
 			ath9k_hw_set_interrupts(sc->sc_ah,
-						sc->sc_imask &
-						~(HAL_INT_SWBA | HAL_INT_BMISS));
-			sc->sc_imask &= ~(HAL_INT_SWBA | HAL_INT_BMISS);
+					sc->sc_imask &
+					~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
+			sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 
 			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: RX filter 0x%x bssid %s aid 0x%x\n",
@@ -699,7 +699,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct ath_softc *sc = hw->priv;
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 	int ret = 0, qnum;
 
 	if (queue >= WME_NUM_AC)
@@ -755,7 +755,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	case DISABLE_KEY:
 		ath_key_delete(sc, key);
 		clear_bit(key->keyidx, sc->sc_keymap);
-		sc->sc_keytype = HAL_CIPHER_CLR;
+		sc->sc_keytype = ATH9K_CIPHER_CLR;
 		break;
 	default:
 		ret = -EINVAL;
@@ -779,9 +779,9 @@ static void ath9k_ht_conf(struct ath_softc *sc,
 			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 			    (bss_conf->ht_bss_conf->bss_cap &
 				IEEE80211_HT_IE_CHA_WIDTH))
-			ht_info->tx_chan_width = HAL_HT_MACMODE_2040;
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
 		else
-			ht_info->tx_chan_width = HAL_HT_MACMODE_20;
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
 
 		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
 		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
@@ -816,7 +816,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		}
 
 		/* New association, store aid */
-		if (avp->av_opmode == HAL_M_STA) {
+		if (avp->av_opmode == ATH9K_M_STA) {
 			sc->sc_curaid = bss_conf->aid;
 			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
 					       sc->sc_curaid);
@@ -1094,7 +1094,7 @@ int ath__rx_indicate(struct ath_softc *sc,
 	/* Prepare rx status */
 	ath9k_rx_prepare(sc, skb, status, &rx_status);
 
-	if (!(keyix == HAL_RXKEYIX_INVALID) &&
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
 	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
 		rx_status.flag |= RX_FLAG_DECRYPTED;
 	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
@@ -1139,7 +1139,7 @@ int ath_rx_subframe(struct ath_node *an,
 	return 0;
 }
 
-enum hal_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
+enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
 {
 	return sc->sc_ht_info.tx_chan_width;
 }
@@ -1147,7 +1147,7 @@ enum hal_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
 void ath_setup_rate(struct ath_softc *sc,
 		    enum wireless_mode wMode,
 		    enum RATE_TYPE type,
-		    const struct hal_rate_table *rt)
+		    const struct ath9k_rate_table *rt)
 {
 	int i, maxrates, a = 0, b = 0;
 	struct ieee80211_supported_band *band_2ghz;
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 09d436f..29af88d 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -390,19 +390,19 @@ ath9k_hw_decrease_chain_power(struct ath_hal *ah, struct ath9k_channel *chan)
 	u_int32_t *bank6Temp = ahp->ah_bank6Temp;
 
 	switch (ahp->ah_diversityControl) {
-	case HAL_ANT_FIXED_A:
+	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
 		    (ahp->
 		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_0 :
 		    REDUCE_CHAIN_1;
 		break;
-	case HAL_ANT_FIXED_B:
+	case ATH9K_ANT_FIXED_B:
 		bank6SelMask =
 		    (ahp->
 		     ah_antennaSwitchSwap & ANTSWAP_AB) ? REDUCE_CHAIN_1 :
 		    REDUCE_CHAIN_0;
 		break;
-	case HAL_ANT_VARIABLE:
+	case ATH9K_ANT_VARIABLE:
 		return;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index ecab05f..b0deeff 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1842,7 +1842,7 @@ void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 
 	if (hw->conf.ht_conf.ht_supported) {
 		capflag |= ATH_RC_HT_FLAG | ATH_RC_DS_FLAG;
-		if (sc->sc_ht_info.tx_chan_width == HAL_HT_MACMODE_2040)
+		if (sc->sc_ht_info.tx_chan_width == ATH9K_HT_MACMODE_2040)
 			capflag |= ATH_RC_CW40_FLAG;
 	}
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 6aefe59..fe20e46 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -184,7 +184,7 @@ static int ath_ampdu_input(struct ath_softc *sc,
 		tid = qc[0] & 0xf;
 	}
 
-	if (sc->sc_opmode == HAL_M_STA) {
+	if (sc->sc_opmode == ATH9K_M_STA) {
 		/* Drop the frame not belonging to me. */
 		if (memcmp(hdr->addr1, sc->sc_myaddr, ETH_ALEN)) {
 			dev_kfree_skb(skb);
@@ -596,32 +596,32 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 u_int32_t ath_calcrxfilter(struct ath_softc *sc)
 {
-#define	RX_FILTER_PRESERVE	(HAL_RX_FILTER_PHYERR | HAL_RX_FILTER_PHYRADAR)
+#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
 	u_int32_t rfilt;
 
 	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
-		| HAL_RX_FILTER_UCAST | HAL_RX_FILTER_BCAST
-		| HAL_RX_FILTER_MCAST;
+		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
+		| ATH9K_RX_FILTER_MCAST;
 
 	/* If not a STA, enable processing of Probe Requests */
-	if (sc->sc_opmode != HAL_M_STA)
-		rfilt |= HAL_RX_FILTER_PROBEREQ;
+	if (sc->sc_opmode != ATH9K_M_STA)
+		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/* Can't set HOSTAP into promiscous mode */
-	if (sc->sc_opmode == HAL_M_MONITOR) {
-		rfilt |= HAL_RX_FILTER_PROM;
+	if (sc->sc_opmode == ATH9K_M_MONITOR) {
+		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
-		rfilt &= ~HAL_RX_FILTER_UCAST;
+		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (sc->sc_opmode == HAL_M_STA || sc->sc_opmode == HAL_M_IBSS ||
+	if (sc->sc_opmode == ATH9K_M_STA || sc->sc_opmode == ATH9K_M_IBSS ||
 	    sc->sc_scanning)
-		rfilt |= HAL_RX_FILTER_BEACON;
+		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
-	if (sc->sc_opmode == HAL_M_HOSTAP)
-		rfilt |= (HAL_RX_FILTER_BEACON | HAL_RX_FILTER_PSPOLL);
+	if (sc->sc_opmode == ATH9K_M_HOSTAP)
+		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 	return rfilt;
 #undef RX_FILTER_PRESERVE
 }
@@ -900,7 +900,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * Enable this if you want to see
 			 * error frames in Monitor mode.
 			 */
-			if (sc->sc_opmode != HAL_M_MONITOR)
+			if (sc->sc_opmode != ATH9K_M_MONITOR)
 				goto rx_next;
 #endif
 			/* fall thru for monitor mode handling... */
@@ -945,7 +945,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 * decryption and MIC failures. For monitor mode,
 			 * we also ignore the CRC error.
 			 */
-			if (sc->sc_opmode == HAL_M_MONITOR) {
+			if (sc->sc_opmode == ATH9K_M_MONITOR) {
 				if (ds->ds_rxstat.rs_status &
 				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 					ATH9K_RXERR_CRC))
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index d380460..d001d43 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -385,7 +385,7 @@ static void ath9k_regd_init_rf_buffer(struct ath9k_channel *ichans,
 			    AR_PHY_CCA_MAX_GOOD_VALUE;
 			ichans[next].nfCalHist[i].invalidNFcount =
 			    AR_PHY_CCA_FILTERWINDOW_LENGTH;
-			for (j = 0; j < HAL_NF_CAL_HIST_MAX; j++) {
+			for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
 				ichans[next].nfCalHist[i].nfCalBuffer[j] =
 				    AR_PHY_CCA_MAX_GOOD_VALUE;
 			}
@@ -464,7 +464,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		return false;
 	}
 
-	if ((rd->flags & NO_HOSTAP) && (ah->ah_opmode == HAL_M_HOSTAP)) {
+	if ((rd->flags & NO_HOSTAP) && (ah->ah_opmode == ATH9K_M_HOSTAP)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"Skipping HOSTAP channel\n");
 		return false;
@@ -1011,7 +1011,7 @@ u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 }
 
 void ath9k_regd_get_current_country(struct ath_hal *ah,
-				    struct hal_country_entry *ctry)
+				    struct ath9k_country_entry *ctry)
 {
 	u_int16_t rd = ath9k_regd_get_eepromRD(ah);
 
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 125941c..85452c7 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -407,6 +407,6 @@ enum CountryCode {
 };
 
 void ath9k_regd_get_current_country(struct ath_hal *ah,
-				    struct hal_country_entry *ctry);
+				    struct ath9k_country_entry *ctry);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 2e3ae65..3937362 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -180,7 +180,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc,
 
 /* Get transmit rate index using rate in Kbps */
 
-static int ath_tx_findindex(const struct hal_rate_table *rt, int rate)
+static int ath_tx_findindex(const struct ath9k_rate_table *rt, int rate)
 {
 	int i;
 	int ndx = 0;
@@ -209,9 +209,9 @@ static int ath_aggr_query(struct ath_softc *sc,
 		return 0;
 }
 
-static enum hal_pkt_type get_hal_packet_type(struct ieee80211_hdr *hdr)
+static enum ath9k_pkt_type get_hal_packet_type(struct ieee80211_hdr *hdr)
 {
-	enum hal_pkt_type htype;
+	enum ath9k_pkt_type htype;
 	__le16 fc;
 
 	fc = hdr->frame_control;
@@ -219,15 +219,15 @@ static enum hal_pkt_type get_hal_packet_type(struct ieee80211_hdr *hdr)
 	/* Calculate Atheros packet type from IEEE80211 packet header */
 
 	if (ieee80211_is_beacon(fc))
-		htype = HAL_PKT_TYPE_BEACON;
+		htype = ATH9K_PKT_TYPE_BEACON;
 	else if (ieee80211_is_probe_resp(fc))
-		htype = HAL_PKT_TYPE_PROBE_RESP;
+		htype = ATH9K_PKT_TYPE_PROBE_RESP;
 	else if (ieee80211_is_atim(fc))
-		htype = HAL_PKT_TYPE_ATIM;
+		htype = ATH9K_PKT_TYPE_ATIM;
 	else if (ieee80211_is_pspoll(fc))
-		htype = HAL_PKT_TYPE_PSPOLL;
+		htype = ATH9K_PKT_TYPE_PSPOLL;
 	else
-		htype = HAL_PKT_TYPE_NORMAL;
+		htype = ATH9K_PKT_TYPE_NORMAL;
 
 	return htype;
 }
@@ -268,7 +268,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	struct ieee80211_hdr *hdr;
 	struct ath_rc_series *rcs;
 	struct ath_txq *txq = NULL;
-	const struct hal_rate_table *rt;
+	const struct ath9k_rate_table *rt;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv;
 	int hdrlen;
@@ -307,19 +307,19 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 	/* Fill Key related fields */
 
-	txctl->keytype = HAL_KEY_TYPE_CLEAR;
-	txctl->keyix = HAL_TXKEYIX_INVALID;
+	txctl->keytype = ATH9K_KEY_TYPE_CLEAR;
+	txctl->keyix = ATH9K_TXKEYIX_INVALID;
 
 	if (!(tx_info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
 		txctl->frmlen += tx_info->control.icv_len;
 
-		if (sc->sc_keytype == HAL_CIPHER_WEP)
-			txctl->keytype = HAL_KEY_TYPE_WEP;
-		else if (sc->sc_keytype == HAL_CIPHER_TKIP)
-			txctl->keytype = HAL_KEY_TYPE_TKIP;
-		else if (sc->sc_keytype == HAL_CIPHER_AES_CCM)
-			txctl->keytype = HAL_KEY_TYPE_AES;
+		if (sc->sc_keytype == ATH9K_CIPHER_WEP)
+			txctl->keytype = ATH9K_KEY_TYPE_WEP;
+		else if (sc->sc_keytype == ATH9K_CIPHER_TKIP)
+			txctl->keytype = ATH9K_KEY_TYPE_TKIP;
+		else if (sc->sc_keytype == ATH9K_CIPHER_AES_CCM)
+			txctl->keytype = ATH9K_KEY_TYPE_AES;
 	}
 
 	/* Fill packet type */
@@ -353,12 +353,12 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 	/* Fill flags */
 
-	txctl->flags = HAL_TXDESC_CLRDMASK;    /* needed for crypto errors */
+	txctl->flags = ATH9K_TXDESC_CLRDMASK;    /* needed for crypto errors */
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		tx_info->flags |= HAL_TXDESC_NOACK;
+		tx_info->flags |= ATH9K_TXDESC_NOACK;
 	if (tx_info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
-		tx_info->flags |= HAL_TXDESC_RTSENA;
+		tx_info->flags |= ATH9K_TXDESC_RTSENA;
 
 	/*
 	 * Setup for rate calculations.
@@ -390,7 +390,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		 * not overridden, since it has been
 		 * incremented by the fragmentation routine.
 		 */
-		if (likely(!(txctl->flags & HAL_TXDESC_FRAG_IS_ON)) &&
+		if (likely(!(txctl->flags & ATH9K_TXDESC_FRAG_IS_ON)) &&
 			txctl->ht && sc->sc_txaggr) {
 			struct ath_atx_tid *tid;
 
@@ -416,7 +416,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	 * Calculate duration.  This logically belongs in the 802.11
 	 * layer but it lacks sufficient information to calculate it.
 	 */
-	if ((txctl->flags & HAL_TXDESC_NOACK) == 0 && !ieee80211_is_ctl(fc)) {
+	if ((txctl->flags & ATH9K_TXDESC_NOACK) == 0 && !ieee80211_is_ctl(fc)) {
 		u_int16_t dur;
 		/*
 		 * XXX not right with fragmentation.
@@ -475,7 +475,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	 */
 	spin_lock_bh(&txq->axq_lock);
 	if ((++txq->axq_intrcnt >= sc->sc_txintrperiod)) {
-		txctl->flags |= HAL_TXDESC_INTREQ;
+		txctl->flags |= ATH9K_TXDESC_INTREQ;
 		txq->axq_intrcnt = 0;
 	}
 	spin_unlock_bh(&txq->axq_lock);
@@ -692,7 +692,7 @@ static u_int32_t ath_pkt_duration(struct ath_softc *sc,
 				  int half_gi,
 				  bool shortPreamble)
 {
-	const struct hal_rate_table *rt = sc->sc_currates;
+	const struct ath9k_rate_table *rt = sc->sc_currates;
 	u_int32_t nbits, nsymbits, duration, nsymbols;
 	u_int8_t rc;
 	int streams, pktlen;
@@ -734,10 +734,10 @@ static u_int32_t ath_pkt_duration(struct ath_softc *sc,
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	const struct hal_rate_table *rt;
+	const struct ath9k_rate_table *rt;
 	struct ath_desc *ds = bf->bf_desc;
 	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
-	struct hal_11n_rate_series series[4];
+	struct ath9k_11n_rate_series series[4];
 	int i, flags, rtsctsena = 0, dynamic_mimops = 0;
 	u_int ctsduration = 0;
 	u_int8_t rix = 0, cix, ctsrate = 0;
@@ -754,7 +754,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			break;
 		}
 	}
-	flags = (bf->bf_flags & (HAL_TXDESC_RTSENA | HAL_TXDESC_CTSENA));
+	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
 	cix = rt->info[rix].controlRate;
 
 	/*
@@ -765,11 +765,11 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	if (sc->sc_protmode != PROT_M_NONE &&
 	    (rt->info[rix].phy == PHY_OFDM ||
 	     rt->info[rix].phy == PHY_HT) &&
-	    (bf->bf_flags & HAL_TXDESC_NOACK) == 0) {
+	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
 		if (sc->sc_protmode == PROT_M_RTSCTS)
-			flags = HAL_TXDESC_RTSENA;
+			flags = ATH9K_TXDESC_RTSENA;
 		else if (sc->sc_protmode == PROT_M_CTSONLY)
-			flags = HAL_TXDESC_CTSENA;
+			flags = ATH9K_TXDESC_CTSENA;
 
 		cix = rt->info[sc->sc_protrix].controlRate;
 		rtsctsena = 1;
@@ -786,14 +786,14 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * 802.11g protection not needed, use our default behavior
 		 */
 		if (!rtsctsena)
-			flags = HAL_TXDESC_RTSENA;
+			flags = ATH9K_TXDESC_RTSENA;
 		/*
 		 * For dynamic MIMO PS, RTS needs to precede the first aggregate
 		 * and the second aggregate should have any protection at all.
 		 */
 		if (an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
 			if (!bf->bf_aggrburst) {
-				flags = HAL_TXDESC_RTSENA;
+				flags = ATH9K_TXDESC_RTSENA;
 				dynamic_mimops = 1;
 			} else {
 				flags = 0;
@@ -806,7 +806,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 */
 	if (sc->sc_config.ath_aggr_prot &&
 	    (!bf->bf_isaggr || (bf->bf_isaggr && bf->bf_al < 8192))) {
-		flags = HAL_TXDESC_RTSENA;
+		flags = ATH9K_TXDESC_RTSENA;
 		cix = rt->info[sc->sc_protrix].controlRate;
 		rtsctsena = 1;
 	}
@@ -820,7 +820,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * while we are bursting the second aggregate the
 		 * RTS is cleared.
 		 */
-		flags &= ~(HAL_TXDESC_RTSENA);
+		flags &= ~(ATH9K_TXDESC_RTSENA);
 	}
 
 	/*
@@ -836,7 +836,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/*
 	 * Setup HAL rate series
 	 */
-	memzero(series, sizeof(struct hal_11n_rate_series) * 4);
+	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	for (i = 0; i < 4; i++) {
 		if (!bf->bf_rcs[i].tries)
@@ -851,11 +851,11 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 
 		series[i].RateFlags = (
 			(bf->bf_rcs[i].flags & ATH_RC_RTSCTS_FLAG) ?
-				HAL_RATESERIES_RTS_CTS : 0) |
+				ATH9K_RATESERIES_RTS_CTS : 0) |
 			((bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) ?
-				HAL_RATESERIES_2040 : 0) |
+				ATH9K_RATESERIES_2040 : 0) |
 			((bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG) ?
-				HAL_RATESERIES_HALFGI : 0);
+				ATH9K_RATESERIES_HALFGI : 0);
 
 		series[i].PktDuration = ath_pkt_duration(
 			sc, rix, bf,
@@ -882,14 +882,14 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		}
 
 		if (rtsctsena)
-			series[i].RateFlags |= HAL_RATESERIES_RTS_CTS;
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 
 		/*
 		 * Set RTS for all rates if node is in dynamic powersave
 		 * mode and we are using dual stream rates.
 		 */
 		if (dynamic_mimops && (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG))
-			series[i].RateFlags |= HAL_RATESERIES_RTS_CTS;
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 	}
 
 	/*
@@ -906,7 +906,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * NB: CTS is assumed the same size as an ACK so we can
 		 *     use the precalculated ACK durations.
 		 */
-		if (flags & HAL_TXDESC_RTSENA) {    /* SIFS + CTS */
+		if (flags & ATH9K_TXDESC_RTSENA) {    /* SIFS + CTS */
 			ctsduration += bf->bf_shpreamble ?
 				rt->info[cix].spAckDuration :
 				rt->info[cix].lpAckDuration;
@@ -914,7 +914,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 
 		ctsduration += series[0].PktDuration;
 
-		if ((bf->bf_flags & HAL_TXDESC_NOACK) == 0) {  /* SIFS + ACK */
+		if ((bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) { /* SIFS + ACK */
 			ctsduration += bf->bf_shpreamble ?
 				rt->info[rix].spAckDuration :
 				rt->info[rix].lpAckDuration;
@@ -924,7 +924,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * Disable multi-rate retry when using RTS/CTS by clearing
 		 * series 1, 2 and 3.
 		 */
-		memzero(&series[1], sizeof(struct hal_11n_rate_series) * 3);
+		memzero(&series[1], sizeof(struct ath9k_11n_rate_series) * 3);
 	}
 
 	/*
@@ -1046,7 +1046,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				 * when perform internal reset in this routine.
 				 * Only enable reset in STA mode for now.
 				 */
-				if (sc->sc_opmode == HAL_M_STA)
+				if (sc->sc_opmode == ATH9K_M_STA)
 					needreset = 1;
 			}
 		} else {
@@ -1363,7 +1363,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 			tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
-				(bf->bf_flags & HAL_TXDESC_NOACK) == 0) {
+				(bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
 			if (ds->ds_txstat.ts_status == 0)
 				nacked++;
 
@@ -1429,11 +1429,11 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	struct ath_hal *ah = sc->sc_ah;
 	int i;
 	int npend = 0;
-	enum hal_ht_macmode ht_macmode = ath_cwm_macmode(sc);
+	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	/* XXX return value */
 	if (!sc->sc_invalid) {
-		for (i = 0; i < HAL_NUM_TX_QUEUES; i++) {
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
 				ath_tx_stopdma(sc, &sc->sc_txq[i]);
 
@@ -1466,7 +1466,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 		spin_unlock_bh(&sc->sc_resetlock);
 	}
 
-	for (i = 0; i < HAL_NUM_TX_QUEUES; i++) {
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_draintxq(sc, &sc->sc_txq[i], retry_tx);
 	}
@@ -1562,7 +1562,7 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 static u_int32_t ath_lookup_rate(struct ath_softc *sc,
 				 struct ath_buf *bf)
 {
-	const struct hal_rate_table *rt = sc->sc_currates;
+	const struct ath9k_rate_table *rt = sc->sc_currates;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_tx_info_priv *tx_info_priv;
@@ -1631,7 +1631,7 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 				  struct ath_buf *bf,
 				  u_int16_t frmlen)
 {
-	const struct hal_rate_table *rt = sc->sc_currates;
+	const struct ath9k_rate_table *rt = sc->sc_currates;
 	u_int32_t nsymbits, nsymbols, mpdudensity;
 	u_int16_t minlen;
 	u_int8_t rc, flags, rix;
@@ -1646,7 +1646,7 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 	 * TODO - this could be improved to be dependent on the rate.
 	 *      The hardware can keep up at lower rates, but not higher rates
 	 */
-	if (bf->bf_keytype != HAL_KEY_TYPE_CLEAR)
+	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR)
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
@@ -2208,14 +2208,14 @@ int ath_tx_cleanup(struct ath_softc *sc)
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 	int qnum;
 
 	memzero(&qi, sizeof(qi));
 	qi.tqi_subtype = subtype;
-	qi.tqi_aifs = HAL_TXQ_USEDEFAULT;
-	qi.tqi_cwmin = HAL_TXQ_USEDEFAULT;
-	qi.tqi_cwmax = HAL_TXQ_USEDEFAULT;
+	qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;
+	qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
+	qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;
 	qi.tqi_compBuf = 0;
 
 	/*
@@ -2233,7 +2233,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	 * The UAPSD queue is an exception, since we take a desc-
 	 * based intr on the EOSP frames.
 	 */
-	if (qtype == HAL_TX_QUEUE_UAPSD)
+	if (qtype == ATH9K_TX_QUEUE_UAPSD)
 		qi.tqi_qflags = TXQ_FLAG_TXDESCINT_ENABLE;
 	else
 		qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE |
@@ -2299,7 +2299,7 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 			__func__, haltype, ARRAY_SIZE(sc->sc_haltype2q));
 		return 0;
 	}
-	txq = ath_txq_setup(sc, HAL_TX_QUEUE_DATA, haltype);
+	txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
 	if (txq != NULL) {
 		sc->sc_haltype2q[haltype] = txq->axq_qnum;
 		return 1;
@@ -2312,7 +2312,7 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	int qnum;
 
 	switch (qtype) {
-	case HAL_TX_QUEUE_DATA:
+	case ATH9K_TX_QUEUE_DATA:
 		if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: HAL AC %u out of range, max %zu!\n",
@@ -2322,10 +2322,10 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 		}
 		qnum = sc->sc_haltype2q[haltype];
 		break;
-	case HAL_TX_QUEUE_BEACON:
+	case ATH9K_TX_QUEUE_BEACON:
 		qnum = sc->sc_bhalq;
 		break;
-	case HAL_TX_QUEUE_CAB:
+	case ATH9K_TX_QUEUE_CAB:
 		qnum = sc->sc_cabq->axq_qnum;
 		break;
 	default:
@@ -2336,11 +2336,11 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 
 /* Update parameters for a transmit queue */
 
-int ath_txq_update(struct ath_softc *sc, int qnum, struct hal_txq_info *qi0)
+int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *qi0)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	int error = 0;
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 
 	if (qnum == sc->sc_bhalq) {
 		/*
@@ -2375,7 +2375,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum, struct hal_txq_info *qi0)
 
 int ath_cabq_update(struct ath_softc *sc)
 {
-	struct hal_txq_info qi;
+	struct ath9k_txq_info qi;
 	int qnum = sc->sc_cabq->axq_qnum;
 	struct ath_beacon_config conf;
 
@@ -2383,10 +2383,10 @@ int ath_cabq_update(struct ath_softc *sc)
 	/*
 	 * Ensure the readytime % is within the bounds.
 	 */
-	if (sc->sc_config.cabqReadytime < HAL_READY_TIME_LO_BOUND)
-		sc->sc_config.cabqReadytime = HAL_READY_TIME_LO_BOUND;
-	else if (sc->sc_config.cabqReadytime > HAL_READY_TIME_HI_BOUND)
-		sc->sc_config.cabqReadytime = HAL_READY_TIME_HI_BOUND;
+	if (sc->sc_config.cabqReadytime < ATH9K_READY_TIME_LO_BOUND)
+		sc->sc_config.cabqReadytime = ATH9K_READY_TIME_LO_BOUND;
+	else if (sc->sc_config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
+		sc->sc_config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
 	ath_get_beaconconfig(sc, ATH_IF_ID_ANY, &conf);
 	qi.tqi_readyTime =
@@ -2424,14 +2424,14 @@ void ath_tx_tasklet(struct ath_softc *sc)
 {
 	u_int64_t tsf = ath9k_hw_gettsf64(sc->sc_ah);
 	int i, nacked = 0;
-	u_int32_t qcumask = ((1 << HAL_NUM_TX_QUEUES) - 1);
+	u_int32_t qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
 
 	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
 
 	/*
 	 * Process each active queue.
 	 */
-	for (i = 0; i < HAL_NUM_TX_QUEUES; i++) {
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
 			nacked += ath_tx_processq(sc, &sc->sc_txq[i]);
 	}
@@ -2784,19 +2784,19 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 			switch (acno) {
 			case WME_AC_BE:
 				ac->qnum = ath_tx_get_qnum(sc,
-					HAL_TX_QUEUE_DATA, HAL_WME_AC_BE);
+					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
 				break;
 			case WME_AC_BK:
 				ac->qnum = ath_tx_get_qnum(sc,
-					HAL_TX_QUEUE_DATA, HAL_WME_AC_BK);
+					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BK);
 				break;
 			case WME_AC_VI:
 				ac->qnum = ath_tx_get_qnum(sc,
-					HAL_TX_QUEUE_DATA, HAL_WME_AC_VI);
+					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VI);
 				break;
 			case WME_AC_VO:
 				ac->qnum = ath_tx_get_qnum(sc,
-					HAL_TX_QUEUE_DATA, HAL_WME_AC_VO);
+					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VO);
 				break;
 			}
 		}
@@ -2812,7 +2812,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc,
 	struct ath_atx_ac *ac, *ac_tmp;
 	struct ath_atx_tid *tid, *tid_tmp;
 	struct ath_txq *txq;
-	for (i = 0; i < HAL_NUM_TX_QUEUES; i++) {
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i)) {
 			txq = &sc->sc_txq[i];
 
-- 
1.5.6.rc2.15.g457bb.dirty

