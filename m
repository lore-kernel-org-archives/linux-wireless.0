Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:58330 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYH2Tph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:45:37 -0400
Date: Fri, 29 Aug 2008 22:45:39 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH] ath5k: HW code cleanup
Message-ID: <20080829194539.GA8017@makis> (sfid-20080829_214551_194802_5E7A83E3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 * No code changes...
    
 * Split hw.c to multiple files for better maintenance and add some documentation on each file
   code is going to grow soon (eeprom.c for example is going to get much stuff currently developed
   on ath_info) so it's better this way.
    
 * Rename following functions to maintain naming scheme:
    
     ah_setup_xtx_desc -> ah_setup_mrr_tx_desc
     (Because xtx doesn't say much, it's actually
     a multi-rate-retry tx descriptor)
    
     ath5k_hw_put_tx/rx_buf - > ath5k_hw_set_tx/rxdp
     ath5k_hw_get_tx/rx_buf -> ath5k_hw_get_tx/rxdp
     (We don't put any "buf" we set descriptor pointers on hw)
    
     ath5k_hw_tx_start -> ath5k_hw_start_tx_dma
     ath5k_hw_start_rx -> ath5k_hw_start_rx_dma
     ath5k_hw_stop_pcu_recv -> ath5k_hw_stop_rx_pcu
     (It's easier this way to identify them, we also
     have ath5k_hw_start_rx_pcu which completes the
     set)
    
     ath5k_hw_set_intr -> ath5k_hw_set_imr
     (As in get_isr we set imr here, not "intr")
    
  * Move ath5k_hw_setup_rx_desc on ah->ah_setup_rx_desc so we can
    include support for different rx descriptors in the future
    
  * Further cleanups so that checkpatch doesn't complain
    (only some > 80 col warnings for eeprom.h and reg.h as usual
    due to comments)
    
  Tested on 5211 and 5213 cards and works ok.
    
  Changes-licensed-under: ISC
  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath5k/Makefile   |   12 +-
 drivers/net/wireless/ath5k/ath5k.h    |  390 +++-
 drivers/net/wireless/ath5k/attach.c   |  315 +++
 drivers/net/wireless/ath5k/base.c     |   32 +-
 drivers/net/wireless/ath5k/caps.c     |  193 ++
 drivers/net/wireless/ath5k/debug.c    |    4 +-
 drivers/net/wireless/ath5k/desc.c     |  667 +++++
 drivers/net/wireless/ath5k/desc.h     |  332 +++
 drivers/net/wireless/ath5k/dma.c      |  566 +++++
 drivers/net/wireless/ath5k/eeprom.c   |  466 ++++
 drivers/net/wireless/ath5k/eeprom.h   |  215 ++
 drivers/net/wireless/ath5k/gpio.c     |  176 ++
 drivers/net/wireless/ath5k/hw.c       | 4492 ---------------------------------
 drivers/net/wireless/ath5k/hw.h       |  616 -----
 drivers/net/wireless/ath5k/initvals.c |   22 +-
 drivers/net/wireless/ath5k/pcu.c      | 1002 ++++++++
 drivers/net/wireless/ath5k/phy.c      |   10 +-
 drivers/net/wireless/ath5k/qcu.c      |  488 ++++
 drivers/net/wireless/ath5k/reg.h      |  102 +-
 drivers/net/wireless/ath5k/reset.c    |  925 +++++++
 20 files changed, 5709 insertions(+), 5316 deletions(-)

diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
index 564ecd0..719cfae 100644
--- a/drivers/net/wireless/ath5k/Makefile
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -1,6 +1,14 @@
-ath5k-y				+= base.o
-ath5k-y				+= hw.o
+ath5k-y				+= caps.o
 ath5k-y				+= initvals.o
+ath5k-y				+= eeprom.o
+ath5k-y				+= gpio.o
+ath5k-y				+= desc.o
+ath5k-y				+= dma.o
+ath5k-y				+= qcu.o
+ath5k-y				+= pcu.o
 ath5k-y				+= phy.o
+ath5k-y				+= reset.o
+ath5k-y				+= attach.o
+ath5k-y				+= base.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c1b4978..4c02117 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -18,18 +18,23 @@
 #ifndef _ATH5K_H
 #define _ATH5K_H
 
-/* Set this to 1 to disable regulatory domain restrictions for channel tests.
- * WARNING: This is for debuging only and has side effects (eg. scan takes too
- * long and results timeouts). It's also illegal to tune to some of the
- * supported frequencies in some countries, so use this at your own risk,
- * you've been warned. */
+/* TODO: Clean up channel debuging -doesn't work anyway- and start
+ * working on reg. control code using all available eeprom information
+ * -rev. engineering needed- */
 #define CHAN_DEBUG	0
 
 #include <linux/io.h>
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-#include "hw.h"
+/* RX/TX descriptor hw structs
+ * TODO: Driver part should only see sw structs */
+#include "desc.h"
+
+/* EEPROM structs/offsets
+ * TODO: Make a more generic struct (eg. add more stuff to ath5k_capabilities)
+ * and clean up common bits, then introduce set/get functions in eeprom.c */
+#include "eeprom.h"
 
 /* PCI IDs */
 #define PCI_DEVICE_ID_ATHEROS_AR5210 		0x0007 /* AR5210 */
@@ -87,7 +92,92 @@
 	ATH5K_PRINTK_LIMIT(_sc, KERN_ERR, _fmt, ##__VA_ARGS__)
 
 /*
+ * AR5K REGISTER ACCESS
+ */
+
+/* Some macros to read/write fields */
+
+/* First shift, then mask */
+#define AR5K_REG_SM(_val, _flags)					\
+	(((_val) << _flags##_S) & (_flags))
+
+/* First mask, then shift */
+#define AR5K_REG_MS(_val, _flags)					\
+	(((_val) & (_flags)) >> _flags##_S)
+
+/* Some registers can hold multiple values of interest. For this
+ * reason when we want to write to these registers we must first
+ * retrieve the values which we do not want to clear (lets call this
+ * old_data) and then set the register with this and our new_value:
+ * ( old_data | new_value) */
+#define AR5K_REG_WRITE_BITS(ah, _reg, _flags, _val)			\
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) & ~(_flags)) | \
+	    (((_val) << _flags##_S) & (_flags)), _reg)
+
+#define AR5K_REG_MASKED_BITS(ah, _reg, _flags, _mask)			\
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) &		\
+			(_mask)) | (_flags), _reg)
+
+#define AR5K_REG_ENABLE_BITS(ah, _reg, _flags)				\
+	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) | (_flags), _reg)
+
+#define AR5K_REG_DISABLE_BITS(ah, _reg, _flags)			\
+	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) & ~(_flags), _reg)
+
+/* Access to PHY registers */
+#define AR5K_PHY_READ(ah, _reg)					\
+	ath5k_hw_reg_read(ah, (ah)->ah_phy + ((_reg) << 2))
+
+#define AR5K_PHY_WRITE(ah, _reg, _val)					\
+	ath5k_hw_reg_write(ah, _val, (ah)->ah_phy + ((_reg) << 2))
+
+/* Access QCU registers per queue */
+#define AR5K_REG_READ_Q(ah, _reg, _queue)				\
+	(ath5k_hw_reg_read(ah, _reg) & (1 << _queue))			\
+
+#define AR5K_REG_WRITE_Q(ah, _reg, _queue)				\
+	ath5k_hw_reg_write(ah, (1 << _queue), _reg)
+
+#define AR5K_Q_ENABLE_BITS(_reg, _queue) do {				\
+	_reg |= 1 << _queue;						\
+} while (0)
+
+#define AR5K_Q_DISABLE_BITS(_reg, _queue) do {				\
+	_reg &= ~(1 << _queue);						\
+} while (0)
+
+/* Used while writing initvals */
+#define AR5K_REG_WAIT(_i) do {						\
+	if (_i % 64)							\
+		udelay(1);						\
+} while (0)
+
+/* Register dumps are done per operation mode */
+#define AR5K_INI_RFGAIN_5GHZ		0
+#define AR5K_INI_RFGAIN_2GHZ		1
+
+/* TODO: Clean this up */
+#define AR5K_INI_VAL_11A		0
+#define AR5K_INI_VAL_11A_TURBO		1
+#define AR5K_INI_VAL_11B		2
+#define AR5K_INI_VAL_11G		3
+#define AR5K_INI_VAL_11G_TURBO		4
+#define AR5K_INI_VAL_XR			0
+#define AR5K_INI_VAL_MAX		5
+
+#define AR5K_RF5111_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
+#define AR5K_RF5112_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
+
+/* Used for BSSID etc manipulation */
+#define AR5K_LOW_ID(_a)(				\
+(_a)[0] | (_a)[1] << 8 | (_a)[2] << 16 | (_a)[3] << 24	\
+)
+
+#define AR5K_HIGH_ID(_a)	((_a)[4] | (_a)[5] << 8)
+
+/*
  * Some tuneable values (these should be changeable by the user)
+ * TODO: Make use of them and add more options OR use debug/configfs
  */
 #define AR5K_TUNE_DMA_BEACON_RESP		2
 #define AR5K_TUNE_SW_BEACON_RESP		10
@@ -98,13 +188,13 @@
 #define AR5K_TUNE_REGISTER_TIMEOUT		20000
 /* Register for RSSI threshold has a mask of 0xff, so 255 seems to
  * be the max value. */
-#define AR5K_TUNE_RSSI_THRES                   129
+#define AR5K_TUNE_RSSI_THRES			129
 /* This must be set when setting the RSSI threshold otherwise it can
  * prevent a reset. If AR5K_RSSI_THR is read after writing to it
  * the BMISS_THRES will be seen as 0, seems harware doesn't keep
  * track of it. Max value depends on harware. For AR5210 this is just 7.
  * For AR5211+ this seems to be up to 255. */
-#define AR5K_TUNE_BMISS_THRES                  7
+#define AR5K_TUNE_BMISS_THRES			7
 #define AR5K_TUNE_REGISTER_DWELL_TIME		20000
 #define AR5K_TUNE_BEACON_INTERVAL		100
 #define AR5K_TUNE_AIFS				2
@@ -123,6 +213,55 @@
 #define AR5K_TUNE_ANT_DIVERSITY			true
 #define AR5K_TUNE_HWTXTRIES			4
 
+#define AR5K_INIT_CARR_SENSE_EN			1
+
+/*Swap RX/TX Descriptor for big endian archs*/
+#if defined(__BIG_ENDIAN)
+#define AR5K_INIT_CFG	(		\
+	AR5K_CFG_SWTD | AR5K_CFG_SWRD	\
+)
+#else
+#define AR5K_INIT_CFG	0x00000000
+#endif
+
+/* Initial values */
+#define AR5K_INIT_TX_LATENCY			502
+#define AR5K_INIT_USEC				39
+#define AR5K_INIT_USEC_TURBO			79
+#define AR5K_INIT_USEC_32			31
+#define AR5K_INIT_SLOT_TIME			396
+#define AR5K_INIT_SLOT_TIME_TURBO		480
+#define AR5K_INIT_ACK_CTS_TIMEOUT		1024
+#define AR5K_INIT_ACK_CTS_TIMEOUT_TURBO		0x08000800
+#define AR5K_INIT_PROG_IFS			920
+#define AR5K_INIT_PROG_IFS_TURBO		960
+#define AR5K_INIT_EIFS				3440
+#define AR5K_INIT_EIFS_TURBO			6880
+#define AR5K_INIT_SIFS				560
+#define AR5K_INIT_SIFS_TURBO			480
+#define AR5K_INIT_SH_RETRY			10
+#define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
+#define AR5K_INIT_SSH_RETRY			32
+#define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
+#define AR5K_INIT_TX_RETRY			10
+
+#define AR5K_INIT_TRANSMIT_LATENCY		(			\
+	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
+	(AR5K_INIT_USEC)						\
+)
+#define AR5K_INIT_TRANSMIT_LATENCY_TURBO	(			\
+	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
+	(AR5K_INIT_USEC_TURBO)						\
+)
+#define AR5K_INIT_PROTO_TIME_CNTRL		(			\
+	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS << 12) |	\
+	(AR5K_INIT_PROG_IFS)						\
+)
+#define AR5K_INIT_PROTO_TIME_CNTRL_TURBO	(			\
+	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS_TURBO << 12) | \
+	(AR5K_INIT_PROG_IFS_TURBO)					\
+)
+
 /* token to use for aifs, cwmin, cwmax in MadWiFi */
 #define	AR5K_TXQ_USEDEFAULT	((u32) -1)
 
@@ -196,7 +335,6 @@ struct ath5k_srev_name {
 #define AR5K_SREV_RAD_5133	0xc0	/* MIMO found on 5418 */
 
 /* IEEE defs */
-
 #define IEEE80211_MAX_LEN       2500
 
 /* TODO add support to mac80211 for vendor-specific rates and modes */
@@ -268,16 +406,13 @@ enum ath5k_driver_mode {
 	AR5K_MODE_MAX		=	5
 };
 
-/* adding this flag to rate_code enables short preamble, see ar5212_reg.h */
-#define AR5K_SET_SHORT_PREAMBLE 0x04
-
 
 /****************\
   TX DEFINITIONS
 \****************/
 
 /*
- * TX Status
+ * TX Status descriptor
  */
 struct ath5k_tx_status {
 	u16	ts_seqnum;
@@ -349,7 +484,6 @@ enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_XR_DATA	= 9,
 };
 
-
 /*
  * Flags to set hw queue's parameters...
  */
@@ -382,7 +516,8 @@ struct ath5k_txq_info {
 
 /*
  * Transmit packet types.
- * These are not fully used inside OpenHAL yet
+ * used on tx control descriptor
+ * TODO: Use them inside base.c corectly
  */
 enum ath5k_pkt_type {
 	AR5K_PKT_TYPE_NORMAL		= 0,
@@ -425,7 +560,7 @@ enum ath5k_dmasize {
 \****************/
 
 /*
- * RX Status
+ * RX Status descriptor
  */
 struct ath5k_rx_status {
 	u16	rs_datalen;
@@ -489,34 +624,59 @@ struct ath5k_beacon_state {
 #define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
 
 
+/*******************************\
+  GAIN OPTIMIZATION DEFINITIONS
+\*******************************/
+
+enum ath5k_rfgain {
+	AR5K_RFGAIN_INACTIVE = 0,
+	AR5K_RFGAIN_READ_REQUESTED,
+	AR5K_RFGAIN_NEED_CHANGE,
+};
+
+#define AR5K_GAIN_CRN_FIX_BITS_5111		4
+#define AR5K_GAIN_CRN_FIX_BITS_5112		7
+#define AR5K_GAIN_CRN_MAX_FIX_BITS		AR5K_GAIN_CRN_FIX_BITS_5112
+#define AR5K_GAIN_DYN_ADJUST_HI_MARGIN		15
+#define AR5K_GAIN_DYN_ADJUST_LO_MARGIN		20
+#define AR5K_GAIN_CCK_PROBE_CORR		5
+#define AR5K_GAIN_CCK_OFDM_GAIN_DELTA		15
+#define AR5K_GAIN_STEP_COUNT			10
+#define AR5K_GAIN_PARAM_TX_CLIP			0
+#define AR5K_GAIN_PARAM_PD_90			1
+#define AR5K_GAIN_PARAM_PD_84			2
+#define AR5K_GAIN_PARAM_GAIN_SEL		3
+#define AR5K_GAIN_PARAM_MIX_ORN			0
+#define AR5K_GAIN_PARAM_PD_138			1
+#define AR5K_GAIN_PARAM_PD_137			2
+#define AR5K_GAIN_PARAM_PD_136			3
+#define AR5K_GAIN_PARAM_PD_132			4
+#define AR5K_GAIN_PARAM_PD_131			5
+#define AR5K_GAIN_PARAM_PD_130			6
+#define AR5K_GAIN_CHECK_ADJUST(_g) 		\
+	((_g)->g_current <= (_g)->g_low || (_g)->g_current >= (_g)->g_high)
+
+struct ath5k_gain_opt_step {
+	s16				gos_param[AR5K_GAIN_CRN_MAX_FIX_BITS];
+	s32				gos_gain;
+};
+
+struct ath5k_gain {
+	u32			g_step_idx;
+	u32			g_current;
+	u32			g_target;
+	u32			g_low;
+	u32			g_high;
+	u32			g_f_corr;
+	u32			g_active;
+	const struct ath5k_gain_opt_step	*g_step;
+};
+
+
 /********************\
   COMMON DEFINITIONS
 \********************/
 
-/*
- * Atheros hardware descriptor
- * This is read and written to by the hardware
- */
-struct ath5k_desc {
-	u32	ds_link;	/* physical address of the next descriptor */
-	u32	ds_data;	/* physical address of data buffer (skb) */
-
-	union {
-		struct ath5k_hw_5210_tx_desc	ds_tx5210;
-		struct ath5k_hw_5212_tx_desc	ds_tx5212;
-		struct ath5k_hw_all_rx_desc	ds_rx;
-	} ud;
-} __packed;
-
-#define AR5K_RXDESC_INTREQ	0x0020
-
-#define AR5K_TXDESC_CLRDMASK	0x0001
-#define AR5K_TXDESC_NOACK	0x0002	/*[5211+]*/
-#define AR5K_TXDESC_RTSENA	0x0004
-#define AR5K_TXDESC_CTSENA	0x0008
-#define AR5K_TXDESC_INTREQ	0x0010
-#define AR5K_TXDESC_VEOL	0x0020	/*[5211+]*/
-
 #define AR5K_SLOT_TIME_9	396
 #define AR5K_SLOT_TIME_20	880
 #define AR5K_SLOT_TIME_MAX	0xffff
@@ -548,15 +708,16 @@ struct ath5k_desc {
 #define CHANNEL_MODES		CHANNEL_ALL
 
 /*
- * Used internaly in OpenHAL (ar5211.c/ar5212.c
- * for reset_tx_queue). Also see struct struct ieee80211_channel.
+ * Used internaly for reset_tx_queue).
+ * Also see struct struct ieee80211_channel.
  */
 #define IS_CHAN_XR(_c)	((_c.hw_value & CHANNEL_XR) != 0)
 #define IS_CHAN_B(_c)	((_c.hw_value & CHANNEL_B) != 0)
 
 /*
- * The following structure will be used to map 2GHz channels to
+ * The following structure is used to map 2GHz channels to
  * 5GHz Atheros channels.
+ * TODO: Clean up
  */
 struct ath5k_athchan_2ghz {
 	u32	a2_flags;
@@ -564,9 +725,9 @@ struct ath5k_athchan_2ghz {
 };
 
 
-/*
- * Rate definitions
- */
+/******************\
+  RATE DEFINITIONS
+\******************/
 
 /**
  * Seems the ar5xxx harware supports up to 32 rates, indexed by 1-32.
@@ -618,6 +779,8 @@ struct ath5k_athchan_2ghz {
 #define ATH5K_RATE_CODE_XR_2M	0x06
 #define ATH5K_RATE_CODE_XR_3M	0x01
 
+/* adding this flag to rate_code enables short preamble */
+#define AR5K_SET_SHORT_PREAMBLE 0x04
 
 /*
  * Crypto definitions
@@ -639,7 +802,6 @@ struct ath5k_athchan_2ghz {
 		return (false);			\
 } while (0)
 
-
 enum ath5k_ant_setting {
 	AR5K_ANT_VARIABLE	= 0,	/* variable by programming */
 	AR5K_ANT_FIXED_A	= 1,	/* fixed to 11a frequencies */
@@ -750,7 +912,8 @@ enum ath5k_power_mode {
 
 /*
  * These match net80211 definitions (not used in
- * d80211).
+ * mac80211).
+ * TODO: Clean this up
  */
 #define AR5K_LED_INIT	0 /*IEEE80211_S_INIT*/
 #define AR5K_LED_SCAN	1 /*IEEE80211_S_SCAN*/
@@ -766,7 +929,8 @@ enum ath5k_power_mode {
 /*
  * Chipset capabilities -see ath5k_hw_get_capability-
  * get_capability function is not yet fully implemented
- * in OpenHAL so most of these don't work yet...
+ * in ath5k so most of these don't work yet...
+ * TODO: Implement these & merge with _TUNE_ stuff above
  */
 enum ath5k_capability_type {
 	AR5K_CAP_REG_DMN		= 0,	/* Used to get current reg. domain id */
@@ -835,6 +999,7 @@ struct ath5k_capabilities {
 #define AR5K_MAX_GPIO		10
 #define AR5K_MAX_RF_BANKS	8
 
+/* TODO: Clean up and merge with ath5k_softc */
 struct ath5k_hw {
 	u32			ah_magic;
 
@@ -927,11 +1092,13 @@ struct ath5k_hw {
 	/*
 	 * Function pointers
 	 */
+	int (*ah_setup_rx_desc)(struct ath5k_hw *ah, struct ath5k_desc *desc,
+				u32 size, unsigned int flags);
 	int (*ah_setup_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int, unsigned int);
-	int (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
+	int (*ah_setup_mrr_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
 	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
@@ -944,33 +1111,38 @@ struct ath5k_hw {
  * Prototypes
  */
 
-/* General Functions */
-extern int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
 extern struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version);
-extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah, unsigned int mode);
 extern void ath5k_hw_detach(struct ath5k_hw *ah);
+
 /* Reset Functions */
+extern int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
 extern int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
 extern int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
+
 /* DMA Related Functions */
-extern void ath5k_hw_start_rx(struct ath5k_hw *ah);
+extern void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
 extern int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
-extern u32 ath5k_hw_get_rx_buf(struct ath5k_hw *ah);
-extern void ath5k_hw_put_rx_buf(struct ath5k_hw *ah, u32 phys_addr);
-extern int ath5k_hw_tx_start(struct ath5k_hw *ah, unsigned int queue);
+extern u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah);
+extern void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
+extern int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue);
 extern int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
-extern u32 ath5k_hw_get_tx_buf(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_put_tx_buf(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr);
+extern u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue);
+extern int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue,
+				u32 phys_addr);
 extern int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase);
 /* Interrupt handling */
 extern bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
 extern int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
-extern enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask);
+extern enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum
+ath5k_int new_mask);
 extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ieee80211_low_level_stats *stats);
+
 /* EEPROM access functions */
-extern int ath5k_hw_set_regdomain(struct ath5k_hw *ah, u16 regdomain);
+extern int ath5k_eeprom_init(struct ath5k_hw *ah);
+extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
+
 /* Protocol Control Unit Functions */
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
 /* BSSID Functions */
@@ -980,14 +1152,14 @@ extern void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc
 extern int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
-extern void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah);
+extern void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
 /* RX Filter functions */
 extern void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
-extern int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index);
+extern int ath5k_hw_set_mcast_filter_idx(struct ath5k_hw *ah, u32 index);
 extern int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index);
 extern u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
 extern void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
-/* Beacon related functions */
+/* Beacon control functions */
 extern u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah);
 extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
@@ -1009,61 +1181,129 @@ extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
 extern int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry);
 extern int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
 extern int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
+
 /* Queue Control Unit, DFS Control Unit Functions */
-extern int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue, const struct ath5k_txq_info *queue_info);
 extern int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue, struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
+				const struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
+				enum ath5k_tx_queue queue_type,
+				struct ath5k_txq_info *queue_info);
+extern u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 extern void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 extern int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
-extern u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
 extern unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah);
+extern int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
+
 /* Hardware Descriptor Functions */
-extern int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc, u32 size, unsigned int flags);
+extern int ath5k_hw_init_desc_functions(struct ath5k_hw *ah);
+
 /* GPIO Functions */
 extern void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
-extern int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio);
 extern int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
+extern int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio);
 extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
 extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
+
 /* Misc functions */
+int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
 extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
-
+extern int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid, u16 assoc_id);
+extern int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
 
 /* Initial register settings functions */
 extern int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
+
 /* Initialize RF */
 extern int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int mode);
 extern int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq);
 extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah);
 extern int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah);
-
-
 /* PHY/RF channel functions */
 extern bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
 extern int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 /* PHY calibration */
 extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel *channel);
-extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
+extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
 /* Misc PHY functions */
 extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
 extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant);
 extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
-extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
+extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* TX power setup */
 extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int txpower);
 extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power);
 
+/*
+ * Functions used internaly
+ */
+
+/*
+ * Translate usec to hw clock units
+ */
+static inline unsigned int ath5k_hw_htoclock(unsigned int usec, bool turbo)
+{
+	return turbo ? (usec * 80) : (usec * 40);
+}
 
+/*
+ * Translate hw clock units to usec
+ */
+static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
+{
+	return turbo ? (clock / 80) : (clock / 40);
+}
+
+/*
+ * Read from a register
+ */
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
 	return ioread32(ah->ah_iobase + reg);
 }
 
+/*
+ * Write to a register
+ */
 static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
 	iowrite32(val, ah->ah_iobase + reg);
 }
 
+#if defined(_ATH5K_RESET) || defined(_ATH5K_PHY)
+/*
+ * Check if a register write has been completed
+ */
+static int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag,
+		u32 val, bool is_set)
+{
+	int i;
+	u32 data;
+
+	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
+		data = ath5k_hw_reg_read(ah, reg);
+		if (is_set && (data & flag))
+			break;
+		else if ((data & flag) == val)
+			break;
+		udelay(15);
+	}
+
+	return (i <= 0) ? -EAGAIN : 0;
+}
+#endif
+
+static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
+{
+	u32 retval = 0, bit, i;
+
+	for (i = 0; i < bits; i++) {
+		bit = (val >> i) & 1;
+		retval = (retval << 1) | bit;
+	}
+
+	return retval;
+}
+
 #endif
diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
new file mode 100644
index 0000000..0eb2511
--- /dev/null
+++ b/drivers/net/wireless/ath5k/attach.c
@@ -0,0 +1,315 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*************************************\
+* Attach/Detach Functions and helpers *
+\*************************************/
+
+#include <linux/pci.h>
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/**
+ * ath5k_hw_post - Power On Self Test helper function
+ *
+ * @ah: The &struct ath5k_hw
+ */
+static int ath5k_hw_post(struct ath5k_hw *ah)
+{
+
+	int i, c;
+	u16 cur_reg;
+	u16 regs[2] = {AR5K_STA_ID0, AR5K_PHY(8)};
+	u32 var_pattern;
+	u32 static_pattern[4] = {
+		0x55555555,	0xaaaaaaaa,
+		0x66666666,	0x99999999
+	};
+	u32 init_val;
+	u32 cur_val;
+
+	for (c = 0; c < 2; c++) {
+
+		cur_reg = regs[c];
+
+		/* Save previous value */
+		init_val = ath5k_hw_reg_read(ah, cur_reg);
+
+		for (i = 0; i < 256; i++) {
+			var_pattern = i << 16 | i;
+			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
+			cur_val = ath5k_hw_reg_read(ah, cur_reg);
+
+			if (cur_val != var_pattern) {
+				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
+				return -EAGAIN;
+			}
+
+			/* Found on ndiswrapper dumps */
+			var_pattern = 0x0039080f;
+			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
+		}
+
+		for (i = 0; i < 4; i++) {
+			var_pattern = static_pattern[i];
+			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
+			cur_val = ath5k_hw_reg_read(ah, cur_reg);
+
+			if (cur_val != var_pattern) {
+				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
+				return -EAGAIN;
+			}
+
+			/* Found on ndiswrapper dumps */
+			var_pattern = 0x003b080f;
+			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
+		}
+
+		/* Restore previous value */
+		ath5k_hw_reg_write(ah, init_val, cur_reg);
+
+	}
+
+	return 0;
+
+}
+
+/**
+ * ath5k_hw_attach - Check if hw is supported and init the needed structs
+ *
+ * @sc: The &struct ath5k_softc we got from the driver's attach function
+ * @mac_version: The mac version id (check out ath5k.h) based on pci id
+ *
+ * Check if the device is supported, perform a POST and initialize the needed
+ * structs. Returns -ENOMEM if we don't have memory for the needed structs,
+ * -ENODEV if the device is not supported or prints an error msg if something
+ * else went wrong.
+ */
+struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
+{
+	struct ath5k_hw *ah;
+	struct pci_dev *pdev = sc->pdev;
+	u8 mac[ETH_ALEN];
+	int ret;
+	u32 srev;
+
+	/*If we passed the test malloc a ath5k_hw struct*/
+	ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
+	if (ah == NULL) {
+		ret = -ENOMEM;
+		ATH5K_ERR(sc, "out of memory\n");
+		goto err;
+	}
+
+	ah->ah_sc = sc;
+	ah->ah_iobase = sc->iobase;
+
+	/*
+	 * HW information
+	 */
+	ah->ah_op_mode = IEEE80211_IF_TYPE_STA;
+	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
+	ah->ah_turbo = false;
+	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
+	ah->ah_imr = 0;
+	ah->ah_atim_window = 0;
+	ah->ah_aifs = AR5K_TUNE_AIFS;
+	ah->ah_cw_min = AR5K_TUNE_CWMIN;
+	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
+	ah->ah_software_retry = false;
+	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
+
+	/*
+	 * Set the mac revision based on the pci id
+	 */
+	ah->ah_version = mac_version;
+
+	/*Fill the ath5k_hw struct with the needed functions*/
+	ret = ath5k_hw_init_desc_functions(ah);
+	if (ret)
+		goto err_free;
+
+	/* Bring device out of sleep and reset it's units */
+	ret = ath5k_hw_nic_wakeup(ah, CHANNEL_B, true);
+	if (ret)
+		goto err_free;
+
+	/* Get MAC, PHY and RADIO revisions */
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	ah->ah_mac_srev = srev;
+	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
+	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
+	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
+			0xffffffff;
+	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
+			CHANNEL_5GHZ);
+
+	if (ah->ah_version == AR5K_AR5210)
+		ah->ah_radio_2ghz_revision = 0;
+	else
+		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
+				CHANNEL_2GHZ);
+
+	/* Return on unsuported chips (unsupported eeprom etc) */
+	if ((srev >= AR5K_SREV_VER_AR5416) &&
+	(srev < AR5K_SREV_VER_AR2425)) {
+		ATH5K_ERR(sc, "Device not yet supported.\n");
+		ret = -ENODEV;
+		goto err_free;
+	} else if (srev == AR5K_SREV_VER_AR2425) {
+		ATH5K_WARN(sc, "Support for RF2425 is under development.\n");
+	}
+
+	/* Identify single chip solutions */
+	if (((srev <= AR5K_SREV_VER_AR5414) &&
+	(srev >= AR5K_SREV_VER_AR2413)) ||
+	(srev == AR5K_SREV_VER_AR2425)) {
+		ah->ah_single_chip = true;
+	} else {
+		ah->ah_single_chip = false;
+	}
+
+	/* Single chip radio */
+	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
+		ah->ah_radio_2ghz_revision = 0;
+
+	/* Identify the radio chip*/
+	if (ah->ah_version == AR5K_AR5210) {
+		ah->ah_radio = AR5K_RF5110;
+	/*
+	 * Register returns 0x0/0x04 for radio revision
+	 * so ath5k_hw_radio_revision doesn't parse the value
+	 * correctly. For now we are based on mac's srev to
+	 * identify RF2425 radio.
+	 */
+	} else if (srev == AR5K_SREV_VER_AR2425) {
+		ah->ah_radio = AR5K_RF2425;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
+		ah->ah_radio = AR5K_RF5111;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5111;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC0) {
+		ah->ah_radio = AR5K_RF5112;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
+		ah->ah_radio = AR5K_RF2413;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC2) {
+		ah->ah_radio = AR5K_RF5413;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
+		/* AR5424 */
+		if (srev >= AR5K_SREV_VER_AR5424) {
+			ah->ah_radio = AR5K_RF5413;
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
+		/* AR2424 */
+		} else {
+			ah->ah_radio = AR5K_RF2413; /* For testing */
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
+		}
+	}
+	ah->ah_phy = AR5K_PHY(0);
+
+	/*
+	 * Write PCI-E power save settings
+	 */
+	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
+		ath5k_hw_reg_write(ah, 0x9248fc00, 0x4080);
+		ath5k_hw_reg_write(ah, 0x24924924, 0x4080);
+		ath5k_hw_reg_write(ah, 0x28000039, 0x4080);
+		ath5k_hw_reg_write(ah, 0x53160824, 0x4080);
+		ath5k_hw_reg_write(ah, 0xe5980579, 0x4080);
+		ath5k_hw_reg_write(ah, 0x001defff, 0x4080);
+		ath5k_hw_reg_write(ah, 0x1aaabe40, 0x4080);
+		ath5k_hw_reg_write(ah, 0xbe105554, 0x4080);
+		ath5k_hw_reg_write(ah, 0x000e3007, 0x4080);
+		ath5k_hw_reg_write(ah, 0x00000000, 0x4084);
+	}
+
+	/*
+	 * POST
+	 */
+	ret = ath5k_hw_post(ah);
+	if (ret)
+		goto err_free;
+
+	/* Write AR5K_PCICFG_UNK on 2112B and later chips */
+	if (ah->ah_radio_5ghz_revision > AR5K_SREV_RAD_2112B ||
+	srev > AR5K_SREV_VER_AR2413) {
+		ath5k_hw_reg_write(ah, AR5K_PCICFG_UNK, AR5K_PCICFG);
+	}
+
+	/*
+	 * Get card capabilities, values, ...
+	 */
+	ret = ath5k_eeprom_init(ah);
+	if (ret) {
+		ATH5K_ERR(sc, "unable to init EEPROM\n");
+		goto err_free;
+	}
+
+	/* Get misc capabilities */
+	ret = ath5k_hw_set_capabilities(ah);
+	if (ret) {
+		ATH5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
+			sc->pdev->device);
+		goto err_free;
+	}
+
+	/* Get MAC address */
+	ret = ath5k_eeprom_read_mac(ah, mac);
+	if (ret) {
+		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
+			sc->pdev->device);
+		goto err_free;
+	}
+
+	ath5k_hw_set_lladdr(ah, mac);
+	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
+	memset(ah->ah_bssid, 0xff, ETH_ALEN);
+	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+	ath5k_hw_set_opmode(ah);
+
+	ath5k_hw_set_rfgain_opt(ah);
+
+	return ah;
+err_free:
+	kfree(ah);
+err:
+	return ERR_PTR(ret);
+}
+
+/**
+ * ath5k_hw_detach - Free the ath5k_hw struct
+ *
+ * @ah: The &struct ath5k_hw
+ */
+void ath5k_hw_detach(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
+
+	if (ah->ah_rf_banks != NULL)
+		kfree(ah->ah_rf_banks);
+
+	/* assume interrupts are down */
+	kfree(ah);
+}
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bcec74e..7989ab5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -707,7 +707,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * return false w/o doing anything.  MAC's that do
 	 * support it will return true w/o doing anything.
 	 */
-	ret = ah->ah_setup_xtx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
+	ret = ah->ah_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
 	if (ret < 0)
 		goto err;
 	if (ret > 0)
@@ -1137,7 +1137,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ds = bf->desc;
 	ds->ds_link = bf->daddr;	/* link to self */
 	ds->ds_data = bf->skbaddr;
-	ath5k_hw_setup_rx_desc(ah, ds,
+	ah->ah_setup_rx_desc(ah, ds,
 		skb_tailroom(skb),	/* buffer size */
 		0);
 
@@ -1188,12 +1188,12 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	list_add_tail(&bf->list, &txq->q);
 	sc->tx_stats[txq->qnum].len++;
 	if (txq->link == NULL) /* is this first packet? */
-		ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
+		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
 		*txq->link = bf->daddr;
 
 	txq->link = &ds->ds_link;
-	ath5k_hw_tx_start(ah, txq->qnum);
+	ath5k_hw_start_tx_dma(ah, txq->qnum);
 	mmiowb();
 	spin_unlock_bh(&txq->lock);
 
@@ -1393,7 +1393,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 		"beacon queueprops tqi_aifs:%d tqi_cw_min:%d tqi_cw_max:%d\n",
 		qi.tqi_aifs, qi.tqi_cw_min, qi.tqi_cw_max);
 
-	ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
+	ret = ath5k_hw_set_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret) {
 		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
 			"hardware queue!\n", __func__);
@@ -1442,14 +1442,14 @@ ath5k_txq_cleanup(struct ath5k_softc *sc)
 		/* don't touch the hardware if marked invalid */
 		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
-			ath5k_hw_get_tx_buf(ah, sc->bhalq));
+			ath5k_hw_get_txdp(ah, sc->bhalq));
 		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 			if (sc->txqs[i].setup) {
 				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
 				ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "txq [%u] %x, "
 					"link %p\n",
 					sc->txqs[i].qnum,
-					ath5k_hw_get_tx_buf(ah,
+					ath5k_hw_get_txdp(ah,
 							sc->txqs[i].qnum),
 					sc->txqs[i].link);
 			}
@@ -1509,8 +1509,8 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 	spin_unlock_bh(&sc->rxbuflock);
 
-	ath5k_hw_put_rx_buf(ah, bf->daddr);
-	ath5k_hw_start_rx(ah);		/* enable recv descriptors */
+	ath5k_hw_set_rxdp(ah, bf->daddr);
+	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
 	ath5k_mode_setup(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
@@ -1527,7 +1527,7 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
-	ath5k_hw_stop_pcu_recv(ah);	/* disable PCU */
+	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
 	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
 
@@ -1976,8 +1976,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		/* NB: hw still stops DMA, so proceed */
 	}
 
-	ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
-	ath5k_hw_tx_start(ah, sc->bhalq);
+	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
+	ath5k_hw_start_tx_dma(ah, sc->bhalq);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
 		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
@@ -2106,7 +2106,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
-	ath5k_hw_set_intr(ah, 0);
+	ath5k_hw_set_imr(ah, 0);
 	sc->bmisscount = 0;
 	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
@@ -2132,7 +2132,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	}
 	/* TODO else AP */
 
-	ath5k_hw_set_intr(ah, sc->imask);
+	ath5k_hw_set_imr(ah, sc->imask);
 }
 
 
@@ -2211,7 +2211,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_led_off(sc);
-		ath5k_hw_set_intr(ah, 0);
+		ath5k_hw_set_imr(ah, 0);
 		synchronize_irq(sc->pdev->irq);
 	}
 	ath5k_txq_cleanup(sc);
@@ -2604,7 +2604,7 @@ ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
 	if (stop) {
-		ath5k_hw_set_intr(ah, 0);
+		ath5k_hw_set_imr(ah, 0);
 		ath5k_txq_cleanup(sc);
 		ath5k_rx_stop(sc);
 	}
diff --git a/drivers/net/wireless/ath5k/caps.c b/drivers/net/wireless/ath5k/caps.c
new file mode 100644
index 0000000..150f5ed
--- /dev/null
+++ b/drivers/net/wireless/ath5k/caps.c
@@ -0,0 +1,193 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/**************\
+* Capabilities *
+\**************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*
+ * Fill the capabilities struct
+ * TODO: Merge this with EEPROM code when we are done with it
+ */
+int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
+{
+	u16 ee_header;
+
+	ATH5K_TRACE(ah->ah_sc);
+	/* Capabilities stored in the EEPROM */
+	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
+
+	if (ah->ah_version == AR5K_AR5210) {
+		/*
+		 * Set radio capabilities
+		 * (The AR5110 only supports the middle 5GHz band)
+		 */
+		ah->ah_capabilities.cap_range.range_5ghz_min = 5120;
+		ah->ah_capabilities.cap_range.range_5ghz_max = 5430;
+		ah->ah_capabilities.cap_range.range_2ghz_min = 0;
+		ah->ah_capabilities.cap_range.range_2ghz_max = 0;
+
+		/* Set supported modes */
+		__set_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode);
+		__set_bit(AR5K_MODE_11A_TURBO, ah->ah_capabilities.cap_mode);
+	} else {
+		/*
+		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
+		 * XXX and from 2312 to 2732GHz. There are problems with the
+		 * XXX current ieee80211 implementation because the IEEE
+		 * XXX channel mapping does not support negative channel
+		 * XXX numbers (2312MHz is channel -19). Of course, this
+		 * XXX doesn't matter because these channels are out of range
+		 * XXX but some regulation domains like MKK (Japan) will
+		 * XXX support frequencies somewhere around 4.8GHz.
+		 */
+
+		/*
+		 * Set radio capabilities
+		 */
+
+		if (AR5K_EEPROM_HDR_11A(ee_header)) {
+			/* 4920 */
+			ah->ah_capabilities.cap_range.range_5ghz_min = 5005;
+			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
+
+			/* Set supported modes */
+			__set_bit(AR5K_MODE_11A,
+					ah->ah_capabilities.cap_mode);
+			__set_bit(AR5K_MODE_11A_TURBO,
+					ah->ah_capabilities.cap_mode);
+			if (ah->ah_version == AR5K_AR5212)
+				__set_bit(AR5K_MODE_11G_TURBO,
+						ah->ah_capabilities.cap_mode);
+		}
+
+		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
+		 * connected */
+		if (AR5K_EEPROM_HDR_11B(ee_header) ||
+				AR5K_EEPROM_HDR_11G(ee_header)) {
+			/* 2312 */
+			ah->ah_capabilities.cap_range.range_2ghz_min = 2412;
+			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
+
+			if (AR5K_EEPROM_HDR_11B(ee_header))
+				__set_bit(AR5K_MODE_11B,
+						ah->ah_capabilities.cap_mode);
+
+			if (AR5K_EEPROM_HDR_11G(ee_header))
+				__set_bit(AR5K_MODE_11G,
+						ah->ah_capabilities.cap_mode);
+		}
+	}
+
+	/* GPIO */
+	ah->ah_gpio_npins = AR5K_NUM_GPIO;
+
+	/* Set number of supported TX queues */
+	if (ah->ah_version == AR5K_AR5210)
+		ah->ah_capabilities.cap_queues.q_tx_num =
+			AR5K_NUM_TX_QUEUES_NOQCU;
+	else
+		ah->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
+
+	return 0;
+}
+
+/* Main function used by the driver part to check caps */
+int ath5k_hw_get_capability(struct ath5k_hw *ah,
+		enum ath5k_capability_type cap_type,
+		u32 capability, u32 *result)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	switch (cap_type) {
+	case AR5K_CAP_NUM_TXQUEUES:
+		if (result) {
+			if (ah->ah_version == AR5K_AR5210)
+				*result = AR5K_NUM_TX_QUEUES_NOQCU;
+			else
+				*result = AR5K_NUM_TX_QUEUES;
+			goto yes;
+		}
+	case AR5K_CAP_VEOL:
+		goto yes;
+	case AR5K_CAP_COMPRESSION:
+		if (ah->ah_version == AR5K_AR5212)
+			goto yes;
+		else
+			goto no;
+	case AR5K_CAP_BURST:
+		goto yes;
+	case AR5K_CAP_TPC:
+		goto yes;
+	case AR5K_CAP_BSSIDMASK:
+		if (ah->ah_version == AR5K_AR5212)
+			goto yes;
+		else
+			goto no;
+	case AR5K_CAP_XR:
+		if (ah->ah_version == AR5K_AR5212)
+			goto yes;
+		else
+			goto no;
+	default:
+		goto no;
+	}
+
+no:
+	return -EINVAL;
+yes:
+	return 0;
+}
+
+/*
+ * TODO: Following functions should be part of a new function
+ * set_capability
+ */
+
+int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
+		u16 assoc_id)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
+			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
+		return 0;
+	}
+
+	return -EIO;
+}
+
+int ath5k_hw_disable_pspoll(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
+			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
+		return 0;
+	}
+
+	return -EIO;
+}
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 6fa6c8e..8f92d67 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -58,8 +58,8 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  */
 
-#include "debug.h"
 #include "base.h"
+#include "debug.h"
 
 static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
@@ -525,7 +525,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 		return;
 
 	printk(KERN_DEBUG "rx queue %x, link %p\n",
-		ath5k_hw_get_rx_buf(ah), sc->rxlink);
+		ath5k_hw_get_rxdp(ah), sc->rxlink);
 
 	spin_lock_bh(&sc->rxbuflock);
 	list_for_each_entry(bf, &sc->rxbuf, list) {
diff --git a/drivers/net/wireless/ath5k/desc.c b/drivers/net/wireless/ath5k/desc.c
new file mode 100644
index 0000000..d45b90a
--- /dev/null
+++ b/drivers/net/wireless/ath5k/desc.c
@@ -0,0 +1,667 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Pavel Roskin <proski@gnu.org>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/******************************\
+ Hardware Descriptor Functions
+\******************************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*
+ * TX Descriptors
+ */
+
+/*
+ * Initialize the 2-word tx control descriptor on 5210/5211
+ */
+static int
+ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+	unsigned int pkt_len, unsigned int hdr_len, enum ath5k_pkt_type type,
+	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
+	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
+	unsigned int rtscts_rate, unsigned int rtscts_duration)
+{
+	u32 frame_type;
+	struct ath5k_hw_2w_tx_ctl *tx_ctl;
+	unsigned int frame_len;
+
+	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
+
+	/*
+	 * Validate input
+	 * - Zero retries don't make sense.
+	 * - A zero rate will put the HW into a mode where it continously sends
+	 *   noise on the channel, so it is important to avoid this.
+	 */
+	if (unlikely(tx_tries0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	if (unlikely(tx_rate0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	/* Clear descriptor */
+	memset(&desc->ud.ds_tx5210, 0, sizeof(struct ath5k_hw_5210_tx_desc));
+
+	/* Setup control descriptor */
+
+	/* Verify and set frame length */
+
+	/* remove padding we might have added before */
+	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+
+	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
+		return -EINVAL;
+
+	tx_ctl->tx_control_0 = frame_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
+
+	/* Verify and set buffer length */
+
+	/* NB: beacon's BufLen must be a multiple of 4 bytes */
+	if (type == AR5K_PKT_TYPE_BEACON)
+		pkt_len = roundup(pkt_len, 4);
+
+	if (pkt_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
+		return -EINVAL;
+
+	tx_ctl->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
+
+	/*
+	 * Verify and set header length
+	 * XXX: I only found that on 5210 code, does it work on 5211 ?
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN)
+			return -EINVAL;
+		tx_ctl->tx_control_0 |=
+			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
+	}
+
+	/*Diferences between 5210-5211*/
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (type) {
+		case AR5K_PKT_TYPE_BEACON:
+		case AR5K_PKT_TYPE_PROBE_RESP:
+			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY;
+		case AR5K_PKT_TYPE_PIFS:
+			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS;
+		default:
+			frame_type = type /*<< 2 ?*/;
+		}
+
+		tx_ctl->tx_control_0 |=
+		AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE) |
+		AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
+
+	} else {
+		tx_ctl->tx_control_0 |=
+			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE) |
+			AR5K_REG_SM(antenna_mode,
+				AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT);
+		tx_ctl->tx_control_1 |=
+			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE);
+	}
+#define _TX_FLAGS(_c, _flag)					\
+	if (flags & AR5K_TXDESC_##_flag) {			\
+		tx_ctl->tx_control_##_c |=			\
+			AR5K_2W_TX_DESC_CTL##_c##_##_flag;	\
+	}
+
+	_TX_FLAGS(0, CLRDMASK);
+	_TX_FLAGS(0, VEOL);
+	_TX_FLAGS(0, INTREQ);
+	_TX_FLAGS(0, RTSENA);
+	_TX_FLAGS(1, NOACK);
+
+#undef _TX_FLAGS
+
+	/*
+	 * WEP crap
+	 */
+	if (key_index != AR5K_TXKEYIX_INVALID) {
+		tx_ctl->tx_control_0 |=
+			AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
+		tx_ctl->tx_control_1 |=
+			AR5K_REG_SM(key_index,
+			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
+	}
+
+	/*
+	 * RTS/CTS Duration [5210 ?]
+	 */
+	if ((ah->ah_version == AR5K_AR5210) &&
+			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
+		tx_ctl->tx_control_1 |= rtscts_duration &
+				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
+
+	return 0;
+}
+
+/*
+ * Initialize the 4-word tx control descriptor on 5212
+ */
+static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
+	struct ath5k_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
+	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
+	unsigned int tx_tries0, unsigned int key_index,
+	unsigned int antenna_mode, unsigned int flags,
+	unsigned int rtscts_rate,
+	unsigned int rtscts_duration)
+{
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
+	unsigned int frame_len;
+
+	ATH5K_TRACE(ah->ah_sc);
+	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
+
+	/*
+	 * Validate input
+	 * - Zero retries don't make sense.
+	 * - A zero rate will put the HW into a mode where it continously sends
+	 *   noise on the channel, so it is important to avoid this.
+	 */
+	if (unlikely(tx_tries0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	if (unlikely(tx_rate0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	/* Clear descriptor */
+	memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
+
+	/* Setup control descriptor */
+
+	/* Verify and set frame length */
+
+	/* remove padding we might have added before */
+	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+
+	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
+		return -EINVAL;
+
+	tx_ctl->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
+
+	/* Verify and set buffer length */
+
+	/* NB: beacon's BufLen must be a multiple of 4 bytes */
+	if (type == AR5K_PKT_TYPE_BEACON)
+		pkt_len = roundup(pkt_len, 4);
+
+	if (pkt_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
+		return -EINVAL;
+
+	tx_ctl->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
+
+	tx_ctl->tx_control_0 |=
+		AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
+		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
+	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
+					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
+	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
+					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
+	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
+
+#define _TX_FLAGS(_c, _flag)					\
+	if (flags & AR5K_TXDESC_##_flag) {			\
+		tx_ctl->tx_control_##_c |=			\
+			AR5K_4W_TX_DESC_CTL##_c##_##_flag;	\
+	}
+
+	_TX_FLAGS(0, CLRDMASK);
+	_TX_FLAGS(0, VEOL);
+	_TX_FLAGS(0, INTREQ);
+	_TX_FLAGS(0, RTSENA);
+	_TX_FLAGS(0, CTSENA);
+	_TX_FLAGS(1, NOACK);
+
+#undef _TX_FLAGS
+
+	/*
+	 * WEP crap
+	 */
+	if (key_index != AR5K_TXKEYIX_INVALID) {
+		tx_ctl->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
+		tx_ctl->tx_control_1 |= AR5K_REG_SM(key_index,
+				AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
+	}
+
+	/*
+	 * RTS/CTS
+	 */
+	if (flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)) {
+		if ((flags & AR5K_TXDESC_RTSENA) &&
+				(flags & AR5K_TXDESC_CTSENA))
+			return -EINVAL;
+		tx_ctl->tx_control_2 |= rtscts_duration &
+				AR5K_4W_TX_DESC_CTL2_RTS_DURATION;
+		tx_ctl->tx_control_3 |= AR5K_REG_SM(rtscts_rate,
+				AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE);
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize a 4-word multi rate retry tx control descriptor on 5212
+ */
+static int
+ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
+	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3)
+{
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
+
+	/*
+	 * Rates can be 0 as long as the retry count is 0 too.
+	 * A zero rate and nonzero retry count will put the HW into a mode where
+	 * it continously sends noise on the channel, so it is important to
+	 * avoid this.
+	 */
+	if (unlikely((tx_rate1 == 0 && tx_tries1 != 0) ||
+		     (tx_rate2 == 0 && tx_tries2 != 0) ||
+		     (tx_rate3 == 0 && tx_tries3 != 0))) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (ah->ah_version == AR5K_AR5212) {
+		tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
+
+#define _XTX_TRIES(_n)							\
+	if (tx_tries##_n) {						\
+		tx_ctl->tx_control_2 |=					\
+		    AR5K_REG_SM(tx_tries##_n,				\
+		    AR5K_4W_TX_DESC_CTL2_XMIT_TRIES##_n);		\
+		tx_ctl->tx_control_3 |=					\
+		    AR5K_REG_SM(tx_rate##_n,				\
+		    AR5K_4W_TX_DESC_CTL3_XMIT_RATE##_n);		\
+	}
+
+		_XTX_TRIES(1);
+		_XTX_TRIES(2);
+		_XTX_TRIES(3);
+
+#undef _XTX_TRIES
+
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Proccess the tx status descriptor on 5210/5211
+ */
+static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
+{
+	struct ath5k_hw_2w_tx_ctl *tx_ctl;
+	struct ath5k_hw_tx_status *tx_status;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
+	tx_status = &desc->ud.ds_tx5210.tx_stat;
+
+	/* No frame has been send or error */
+	if (unlikely((tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE) == 0))
+		return -EINPROGRESS;
+
+	/*
+	 * Get descriptor status
+	 */
+	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
+	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
+	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
+	/*TODO: ts->ts_virtcol + test*/
+	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
+		AR5K_DESC_TX_STATUS1_SEQ_NUM);
+	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
+		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
+	ts->ts_antenna = 1;
+	ts->ts_status = 0;
+	ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_0,
+		AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
+
+	if (!(tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
+		if (tx_status->tx_status_0 &
+				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
+			ts->ts_status |= AR5K_TXERR_XRETRY;
+
+		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
+			ts->ts_status |= AR5K_TXERR_FIFO;
+
+		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
+			ts->ts_status |= AR5K_TXERR_FILT;
+	}
+
+	return 0;
+}
+
+/*
+ * Proccess a tx status descriptor on 5212
+ */
+static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
+{
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
+	struct ath5k_hw_tx_status *tx_status;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
+	tx_status = &desc->ud.ds_tx5212.tx_stat;
+
+	/* No frame has been send or error */
+	if (unlikely(!(tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE)))
+		return -EINPROGRESS;
+
+	/*
+	 * Get descriptor status
+	 */
+	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
+	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
+	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
+		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
+	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
+		AR5K_DESC_TX_STATUS1_SEQ_NUM);
+	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
+		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
+	ts->ts_antenna = (tx_status->tx_status_1 &
+		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA) ? 2 : 1;
+	ts->ts_status = 0;
+
+	switch (AR5K_REG_MS(tx_status->tx_status_1,
+			AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX)) {
+	case 0:
+		ts->ts_rate = tx_ctl->tx_control_3 &
+			AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
+		break;
+	case 1:
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+			AR5K_4W_TX_DESC_CTL3_XMIT_RATE1);
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
+		break;
+	case 2:
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+			AR5K_4W_TX_DESC_CTL3_XMIT_RATE2);
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
+		break;
+	case 3:
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+			AR5K_4W_TX_DESC_CTL3_XMIT_RATE3);
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3);
+		break;
+	}
+
+	/* TX error */
+	if (!(tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
+		if (tx_status->tx_status_0 &
+				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
+			ts->ts_status |= AR5K_TXERR_XRETRY;
+
+		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
+			ts->ts_status |= AR5K_TXERR_FIFO;
+
+		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
+			ts->ts_status |= AR5K_TXERR_FILT;
+	}
+
+	return 0;
+}
+
+/*
+ * RX Descriptors
+ */
+
+/*
+ * Initialize an rx control descriptor
+ */
+static int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
+			u32 size, unsigned int flags)
+{
+	struct ath5k_hw_rx_ctl *rx_ctl;
+
+	ATH5K_TRACE(ah->ah_sc);
+	rx_ctl = &desc->ud.ds_rx.rx_ctl;
+
+	/*
+	 * Clear the descriptor
+	 * If we don't clean the status descriptor,
+	 * while scanning we get too many results,
+	 * most of them virtual, after some secs
+	 * of scanning system hangs. M.F.
+	*/
+	memset(&desc->ud.ds_rx, 0, sizeof(struct ath5k_hw_all_rx_desc));
+
+	/* Setup descriptor */
+	rx_ctl->rx_control_1 = size & AR5K_DESC_RX_CTL1_BUF_LEN;
+	if (unlikely(rx_ctl->rx_control_1 != size))
+		return -EINVAL;
+
+	if (flags & AR5K_RXDESC_INTREQ)
+		rx_ctl->rx_control_1 |= AR5K_DESC_RX_CTL1_INTREQ;
+
+	return 0;
+}
+
+/*
+ * Proccess the rx status descriptor on 5210/5211
+ */
+static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
+{
+	struct ath5k_hw_rx_status *rx_status;
+
+	rx_status = &desc->ud.ds_rx.u.rx_stat;
+
+	/* No frame received / not ready */
+	if (unlikely(!(rx_status->rx_status_1 &
+	AR5K_5210_RX_DESC_STATUS1_DONE)))
+		return -EINPROGRESS;
+
+	/*
+	 * Frame receive status
+	 */
+	rs->rs_datalen = rx_status->rx_status_0 &
+		AR5K_5210_RX_DESC_STATUS0_DATA_LEN;
+	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
+	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
+	rs->rs_antenna = rx_status->rx_status_0 &
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
+	rs->rs_more = rx_status->rx_status_0 &
+		AR5K_5210_RX_DESC_STATUS0_MORE;
+	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
+	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
+		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
+	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
+
+	/*
+	 * Key table status
+	 */
+	if (rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID)
+		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
+			AR5K_5210_RX_DESC_STATUS1_KEY_INDEX);
+	else
+		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
+
+	/*
+	 * Receive/descriptor errors
+	 */
+	if (!(rx_status->rx_status_1 &
+	AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
+		if (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_CRC_ERROR)
+			rs->rs_status |= AR5K_RXERR_CRC;
+
+		if (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN)
+			rs->rs_status |= AR5K_RXERR_FIFO;
+
+		if (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
+			rs->rs_status |= AR5K_RXERR_PHY;
+			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
+				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
+		}
+
+		if (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
+			rs->rs_status |= AR5K_RXERR_DECRYPT;
+	}
+
+	return 0;
+}
+
+/*
+ * Proccess the rx status descriptor on 5212
+ */
+static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
+{
+	struct ath5k_hw_rx_status *rx_status;
+	struct ath5k_hw_rx_error *rx_err;
+
+	ATH5K_TRACE(ah->ah_sc);
+	rx_status = &desc->ud.ds_rx.u.rx_stat;
+
+	/* Overlay on error */
+	rx_err = &desc->ud.ds_rx.u.rx_err;
+
+	/* No frame received / not ready */
+	if (unlikely(!(rx_status->rx_status_1 &
+	AR5K_5212_RX_DESC_STATUS1_DONE)))
+		return -EINPROGRESS;
+
+	/*
+	 * Frame receive status
+	 */
+	rs->rs_datalen = rx_status->rx_status_0 &
+		AR5K_5212_RX_DESC_STATUS0_DATA_LEN;
+	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL);
+	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE);
+	rs->rs_antenna = rx_status->rx_status_0 &
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA;
+	rs->rs_more = rx_status->rx_status_0 &
+		AR5K_5212_RX_DESC_STATUS0_MORE;
+	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
+		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
+	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
+
+	/*
+	 * Key table status
+	 */
+	if (rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID)
+		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
+				AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
+	else
+		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
+
+	/*
+	 * Receive/descriptor errors
+	 */
+	if (!(rx_status->rx_status_1 &
+	AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_CRC_ERROR)
+			rs->rs_status |= AR5K_RXERR_CRC;
+
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
+			rs->rs_status |= AR5K_RXERR_PHY;
+			rs->rs_phyerr |= AR5K_REG_MS(rx_err->rx_error_1,
+					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
+		}
+
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
+			rs->rs_status |= AR5K_RXERR_DECRYPT;
+
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_MIC_ERROR)
+			rs->rs_status |= AR5K_RXERR_MIC;
+	}
+
+	return 0;
+}
+
+/*
+ * Init function pointers inside ath5k_hw struct
+ */
+int ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
+{
+
+	if (ah->ah_version != AR5K_AR5210 &&
+		ah->ah_version != AR5K_AR5211 &&
+		ah->ah_version != AR5K_AR5212)
+			return -ENOTSUPP;
+
+	/* XXX: What is this magic value and where is it used ? */
+	if (ah->ah_version == AR5K_AR5212)
+		ah->ah_magic = AR5K_EEPROM_MAGIC_5212;
+	else if (ah->ah_version == AR5K_AR5211)
+		ah->ah_magic = AR5K_EEPROM_MAGIC_5211;
+
+	if (ah->ah_version == AR5K_AR5212) {
+		ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
+		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
+		ah->ah_setup_mrr_tx_desc = ath5k_hw_setup_mrr_tx_desc;
+		ah->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
+	} else {
+		ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
+		ah->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
+		ah->ah_setup_mrr_tx_desc = ath5k_hw_setup_mrr_tx_desc;
+		ah->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
+	}
+
+	if (ah->ah_version == AR5K_AR5212)
+		ah->ah_proc_rx_desc = ath5k_hw_proc_5212_rx_status;
+	else if (ah->ah_version <= AR5K_AR5211)
+		ah->ah_proc_rx_desc = ath5k_hw_proc_5210_rx_status;
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/ath5k/desc.h b/drivers/net/wireless/ath5k/desc.h
new file mode 100644
index 0000000..56158c8
--- /dev/null
+++ b/drivers/net/wireless/ath5k/desc.h
@@ -0,0 +1,332 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*
+ * Internal RX/TX descriptor structures
+ * (rX: reserved fields possibily used by future versions of the ar5k chipset)
+ */
+
+/*
+ * common hardware RX control descriptor
+ */
+struct ath5k_hw_rx_ctl {
+	u32	rx_control_0; /* RX control word 0 */
+	u32	rx_control_1; /* RX control word 1 */
+} __packed;
+
+/* RX control word 0 field/sflags */
+#define AR5K_DESC_RX_CTL0			0x00000000
+
+/* RX control word 1 fields/flags */
+#define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff
+#define AR5K_DESC_RX_CTL1_INTREQ		0x00002000
+
+/*
+ * common hardware RX status descriptor
+ * 5210/11 and 5212 differ only in the flags defined below
+ */
+struct ath5k_hw_rx_status {
+	u32	rx_status_0; /* RX status word 0 */
+	u32	rx_status_1; /* RX status word 1 */
+} __packed;
+
+/* 5210/5211 */
+/* RX status word 0 fields/flags */
+#define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff
+#define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE_S	15
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	19
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA	0x38000000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	27
+
+/* RX status word 1 fields/flags */
+#define AR5K_5210_RX_DESC_STATUS1_DONE			0x00000001
+#define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
+#define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004
+#define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN		0x00000008
+#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010
+#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0
+#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR_S		5
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_S		9
+#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000
+#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
+#define AR5K_5210_RX_DESC_STATUS1_KEY_CACHE_MISS	0x10000000
+
+/* 5212 */
+/* RX status word 0 fields/flags */
+#define AR5K_5212_RX_DESC_STATUS0_DATA_LEN		0x00000fff
+#define AR5K_5212_RX_DESC_STATUS0_MORE			0x00001000
+#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE_S	15
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x0ff00000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	20
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	28
+
+/* RX status word 1 fields/flags */
+#define AR5K_5212_RX_DESC_STATUS1_DONE			0x00000001
+#define AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
+#define AR5K_5212_RX_DESC_STATUS1_CRC_ERROR		0x00000004
+#define AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR		0x00000010
+#define AR5K_5212_RX_DESC_STATUS1_MIC_ERROR		0x00000020
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_S		9
+#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
+#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
+#define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000
+
+/*
+ * common hardware RX error descriptor
+ */
+struct ath5k_hw_rx_error {
+	u32	rx_error_0; /* RX status word 0 */
+	u32	rx_error_1; /* RX status word 1 */
+} __packed;
+
+/* RX error word 0 fields/flags */
+#define AR5K_RX_DESC_ERROR0			0x00000000
+
+/* RX error word 1 fields/flags */
+#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE	0x0000ff00
+#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE_S	8
+
+/* PHY Error codes */
+#define AR5K_DESC_RX_PHY_ERROR_NONE		0x00
+#define AR5K_DESC_RX_PHY_ERROR_TIMING		0x20
+#define AR5K_DESC_RX_PHY_ERROR_PARITY		0x40
+#define AR5K_DESC_RX_PHY_ERROR_RATE		0x60
+#define AR5K_DESC_RX_PHY_ERROR_LENGTH		0x80
+#define AR5K_DESC_RX_PHY_ERROR_64QAM		0xa0
+#define AR5K_DESC_RX_PHY_ERROR_SERVICE		0xc0
+#define AR5K_DESC_RX_PHY_ERROR_TRANSMITOVR	0xe0
+
+/*
+ * 5210/5211 hardware 2-word TX control descriptor
+ */
+struct ath5k_hw_2w_tx_ctl {
+	u32	tx_control_0; /* TX control word 0 */
+	u32	tx_control_1; /* TX control word 1 */
+} __packed;
+
+/* TX control word 0 fields/flags */
+#define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
+#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN		0x0003f000 /*[5210 ?]*/
+#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN_S	12
+#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE		0x003c0000
+#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE_S	18
+#define AR5K_2W_TX_DESC_CTL0_RTSENA		0x00400000
+#define AR5K_2W_TX_DESC_CTL0_CLRDMASK		0x01000000
+#define AR5K_2W_TX_DESC_CTL0_LONG_PACKET	0x00800000 /*[5210]*/
+#define AR5K_2W_TX_DESC_CTL0_VEOL		0x00800000 /*[5211]*/
+#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE		0x1c000000 /*[5210]*/
+#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_S	26
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000
+
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT			\
+		(ah->ah_version == AR5K_AR5210 ?		\
+		AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210 :	\
+		AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211)
+
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
+#define AR5K_2W_TX_DESC_CTL0_INTREQ		0x20000000
+#define AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
+
+/* TX control word 1 fields/flags */
+#define AR5K_2W_TX_DESC_CTL1_BUF_LEN		0x00000fff
+#define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210	0x0007e000
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211	0x000fe000
+
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX				\
+			(ah->ah_version == AR5K_AR5210 ?		\
+			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210 :	\
+			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211)
+
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
+#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE		0x00700000 /*[5211]*/
+#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_S	20
+#define AR5K_2W_TX_DESC_CTL1_NOACK		0x00800000 /*[5211]*/
+#define AR5K_2W_TX_DESC_CTL1_RTS_DURATION	0xfff80000 /*[5210 ?]*/
+
+/* Frame types */
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NORMAL   0x00
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_ATIM     0x04
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PSPOLL   0x08
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY 0x0c
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS     0x10
+
+/*
+ * 5212 hardware 4-word TX control descriptor
+ */
+struct ath5k_hw_4w_tx_ctl {
+	u32	tx_control_0; /* TX control word 0 */
+
+#define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
+#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER		0x003f0000
+#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER_S	16
+#define AR5K_4W_TX_DESC_CTL0_RTSENA		0x00400000
+#define AR5K_4W_TX_DESC_CTL0_VEOL		0x00800000
+#define AR5K_4W_TX_DESC_CTL0_CLRDMASK		0x01000000
+#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT	0x1e000000
+#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
+#define AR5K_4W_TX_DESC_CTL0_INTREQ		0x20000000
+#define AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
+#define AR5K_4W_TX_DESC_CTL0_CTSENA		0x80000000
+
+	u32	tx_control_1; /* TX control word 1 */
+
+#define AR5K_4W_TX_DESC_CTL1_BUF_LEN		0x00000fff
+#define AR5K_4W_TX_DESC_CTL1_MORE		0x00001000
+#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	0x000fe000
+#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
+#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE		0x00f00000
+#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE_S	20
+#define AR5K_4W_TX_DESC_CTL1_NOACK		0x01000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_PROC		0x06000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_PROC_S	25
+#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN	0x18000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN_S	27
+#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN	0x60000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN_S	29
+
+	u32	tx_control_2; /* TX control word 2 */
+
+#define AR5K_4W_TX_DESC_CTL2_RTS_DURATION		0x00007fff
+#define AR5K_4W_TX_DESC_CTL2_DURATION_UPDATE_ENABLE	0x00008000
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0		0x000f0000
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0_S		16
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1		0x00f00000
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1_S		20
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2		0x0f000000
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2_S		24
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3		0xf0000000
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3_S		28
+
+	u32	tx_control_3; /* TX control word 3 */
+
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE0		0x0000001f
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1		0x000003e0
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1_S	5
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2		0x00007c00
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2_S	10
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3		0x000f8000
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3_S	15
+#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE	0x01f00000
+#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE_S	20
+} __packed;
+
+/*
+ * Common TX status descriptor
+ */
+struct ath5k_hw_tx_status {
+	u32	tx_status_0; /* TX status word 0 */
+	u32	tx_status_1; /* TX status word 1 */
+} __packed;
+
+/* TX status word 0 fields/flags */
+#define AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK	0x00000001
+#define AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES	0x00000002
+#define AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN	0x00000004
+#define AR5K_DESC_TX_STATUS0_FILTERED		0x00000008
+/*???
+#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT	0x000000f0
+#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT_S	4
+*/
+#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT	0x000000f0
+#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT_S	4
+/*???
+#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT	0x00000f00
+#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT_S	8
+*/
+#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT	0x00000f00
+#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT_S	8
+#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT	0x0000f000
+#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT_S	12
+#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP	0xffff0000
+#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP_S	16
+
+/* TX status word 1 fields/flags */
+#define AR5K_DESC_TX_STATUS1_DONE		0x00000001
+#define AR5K_DESC_TX_STATUS1_SEQ_NUM		0x00001ffe
+#define AR5K_DESC_TX_STATUS1_SEQ_NUM_S		1
+#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH	0x001fe000
+#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH_S	13
+#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX	0x00600000
+#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX_S	21
+#define AR5K_DESC_TX_STATUS1_COMP_SUCCESS	0x00800000
+#define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA	0x01000000
+
+/*
+ * 5210/5211 hardware TX descriptor
+ */
+struct ath5k_hw_5210_tx_desc {
+	struct ath5k_hw_2w_tx_ctl	tx_ctl;
+	struct ath5k_hw_tx_status	tx_stat;
+} __packed;
+
+/*
+ * 5212 hardware TX descriptor
+ */
+struct ath5k_hw_5212_tx_desc {
+	struct ath5k_hw_4w_tx_ctl	tx_ctl;
+	struct ath5k_hw_tx_status	tx_stat;
+} __packed;
+
+/*
+ * common hardware RX descriptor
+ */
+struct ath5k_hw_all_rx_desc {
+	struct ath5k_hw_rx_ctl			rx_ctl;
+	union {
+		struct ath5k_hw_rx_status	rx_stat;
+		struct ath5k_hw_rx_error	rx_err;
+	} u;
+} __packed;
+
+/*
+ * Atheros hardware descriptor
+ * This is read and written to by the hardware
+ */
+struct ath5k_desc {
+	u32	ds_link;	/* physical address of the next descriptor */
+	u32	ds_data;	/* physical address of data buffer (skb) */
+
+	union {
+		struct ath5k_hw_5210_tx_desc	ds_tx5210;
+		struct ath5k_hw_5212_tx_desc	ds_tx5212;
+		struct ath5k_hw_all_rx_desc	ds_rx;
+	} ud;
+} __packed;
+
+#define AR5K_RXDESC_INTREQ	0x0020
+
+#define AR5K_TXDESC_CLRDMASK	0x0001
+#define AR5K_TXDESC_NOACK	0x0002	/*[5211+]*/
+#define AR5K_TXDESC_RTSENA	0x0004
+#define AR5K_TXDESC_CTSENA	0x0008
+#define AR5K_TXDESC_INTREQ	0x0010
+#define AR5K_TXDESC_VEOL	0x0020	/*[5211+]*/
+
diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath5k/dma.c
new file mode 100644
index 0000000..a28090b
--- /dev/null
+++ b/drivers/net/wireless/ath5k/dma.c
@@ -0,0 +1,566 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*************************************\
+* DMA and interrupt masking functions *
+\*************************************/
+
+/*
+ * dma.c - DMA and interrupt masking functions
+ *
+ * Here we setup descriptor pointers (rxdp/txdp) start/stop dma engine and
+ * handle queue setup for 5210 chipset (rest are handled on qcu.c).
+ * Also we setup interrupt mask register (IMR) and read the various iterrupt
+ * status registers (ISR).
+ *
+ * TODO: Handle SISR on 5211+ and introduce a function to return the queue
+ * number that resulted the interrupt.
+ */
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*********\
+* Receive *
+\*********/
+
+/**
+ * ath5k_hw_start_rx_dma - Start DMA receive
+ *
+ * @ah:	The &struct ath5k_hw
+ */
+void ath5k_hw_start_rx_dma(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
+	ath5k_hw_reg_read(ah, AR5K_CR);
+}
+
+/**
+ * ath5k_hw_stop_rx_dma - Stop DMA receive
+ *
+ * @ah:	The &struct ath5k_hw
+ */
+int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
+{
+	unsigned int i;
+
+	ATH5K_TRACE(ah->ah_sc);
+	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
+
+	/*
+	 * It may take some time to disable the DMA receive unit
+	 */
+	for (i = 2000; i > 0 &&
+			(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) != 0;
+			i--)
+		udelay(10);
+
+	return i ? 0 : -EBUSY;
+}
+
+/**
+ * ath5k_hw_get_rxdp - Get RX Descriptor's address
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * XXX: Is RXDP read and clear ?
+ */
+u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
+{
+	return ath5k_hw_reg_read(ah, AR5K_RXDP);
+}
+
+/**
+ * ath5k_hw_set_rxdp - Set RX Descriptor's address
+ *
+ * @ah: The &struct ath5k_hw
+ * @phys_addr: RX descriptor address
+ *
+ * XXX: Should we check if rx is enabled before setting rxdp ?
+ */
+void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
+}
+
+
+/**********\
+* Transmit *
+\**********/
+
+/**
+ * ath5k_hw_start_tx_dma - Start DMA transmit for a specific queue
+ *
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ *
+ * Start DMA transmit for a specific queue and since 5210 doesn't have
+ * QCU/DCU, set up queue parameters for 5210 here based on queue type (one
+ * queue for normal data and one queue for beacons). For queue setup
+ * on newer chips check out qcu.c. Returns -EINVAL if queue number is out
+ * of range or if queue is already disabled.
+ *
+ * NOTE: Must be called after setting up tx control descriptor for that
+ * queue (see below).
+ */
+int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
+{
+	u32 tx_queue;
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/* Return if queue is declared inactive */
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return -EIO;
+
+	if (ah->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
+
+		/*
+		 * Set the queue by type on 5210
+		 */
+		switch (ah->ah_txq[queue].tqi_type) {
+		case AR5K_TX_QUEUE_DATA:
+			tx_queue |= AR5K_CR_TXE0 & ~AR5K_CR_TXD0;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+					AR5K_BSR);
+			break;
+		case AR5K_TX_QUEUE_CAB:
+			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
+				AR5K_BCR_BDMAE, AR5K_BSR);
+			break;
+		default:
+			return -EINVAL;
+		}
+		/* Start queue */
+		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
+		ath5k_hw_reg_read(ah, AR5K_CR);
+	} else {
+		/* Return if queue is disabled */
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXD, queue))
+			return -EIO;
+
+		/* Start queue */
+		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXE, queue);
+	}
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_stop_tx_dma - Stop DMA transmit on a specific queue
+ *
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ *
+ * Stop DMA transmit on a specific hw queue and drain queue so we don't
+ * have any pending frames. Returns -EBUSY if we still have pending frames,
+ * -EINVAL if queue number is out of range.
+ *
+ * TODO: Test queue drain code
+ */
+int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
+{
+	unsigned int i = 100;
+	u32 tx_queue, pending;
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/* Return if queue is declared inactive */
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return -EIO;
+
+	if (ah->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
+
+		/*
+		 * Set by queue type
+		 */
+		switch (ah->ah_txq[queue].tqi_type) {
+		case AR5K_TX_QUEUE_DATA:
+			tx_queue |= AR5K_CR_TXD0 & ~AR5K_CR_TXE0;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+		case AR5K_TX_QUEUE_CAB:
+			/* XXX Fix me... */
+			tx_queue |= AR5K_CR_TXD1 & ~AR5K_CR_TXD1;
+			ath5k_hw_reg_write(ah, 0, AR5K_BSR);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* Stop queue */
+		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
+		ath5k_hw_reg_read(ah, AR5K_CR);
+	} else {
+		/*
+		 * Schedule TX disable and wait until queue is empty
+		 */
+		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXD, queue);
+
+		/*Check for pending frames*/
+		do {
+			pending = ath5k_hw_reg_read(ah,
+				AR5K_QUEUE_STATUS(queue)) &
+				AR5K_QCU_STS_FRMPENDCNT;
+			udelay(100);
+		} while (--i && pending);
+
+		/* Clear register */
+		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
+		if (pending)
+			return -EBUSY;
+	}
+
+	/* TODO: Check for success else return error */
+	return 0;
+}
+
+/**
+ * ath5k_hw_get_txdp - Get TX Descriptor's address for a specific queue
+ *
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ *
+ * Get TX descriptor's address for a specific queue. For 5210 we ignore
+ * the queue number and use tx queue type since we only have 2 queues.
+ * We use TXDP0 for normal data queue and TXDP1 for beacon queue.
+ * For newer chips with QCU/DCU we just read the corresponding TXDP register.
+ *
+ * XXX: Is TXDP read and clear ?
+ */
+u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
+{
+	u16 tx_reg;
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/*
+	 * Get the transmit queue descriptor pointer from the selected queue
+	 */
+	/*5210 doesn't have QCU*/
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (ah->ah_txq[queue].tqi_type) {
+		case AR5K_TX_QUEUE_DATA:
+			tx_reg = AR5K_NOQCU_TXDP0;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+		case AR5K_TX_QUEUE_CAB:
+			tx_reg = AR5K_NOQCU_TXDP1;
+			break;
+		default:
+			return 0xffffffff;
+		}
+	} else {
+		tx_reg = AR5K_QUEUE_TXDP(queue);
+	}
+
+	return ath5k_hw_reg_read(ah, tx_reg);
+}
+
+/**
+ * ath5k_hw_set_txdp - Set TX Descriptor's address for a specific queue
+ *
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ *
+ * Set TX descriptor's address for a specific queue. For 5210 we ignore
+ * the queue number and we use tx queue type since we only have 2 queues
+ * so as above we use TXDP0 for normal data queue and TXDP1 for beacon queue.
+ * For newer chips with QCU/DCU we just set the corresponding TXDP register.
+ * Returns -EINVAL if queue type is invalid for 5210 and -EIO if queue is still
+ * active.
+ */
+int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
+{
+	u16 tx_reg;
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/*
+	 * Set the transmit queue descriptor pointer register by type
+	 * on 5210
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (ah->ah_txq[queue].tqi_type) {
+		case AR5K_TX_QUEUE_DATA:
+			tx_reg = AR5K_NOQCU_TXDP0;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+		case AR5K_TX_QUEUE_CAB:
+			tx_reg = AR5K_NOQCU_TXDP1;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		/*
+		 * Set the transmit queue descriptor pointer for
+		 * the selected queue on QCU for 5211+
+		 * (this won't work if the queue is still active)
+		 */
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
+			return -EIO;
+
+		tx_reg = AR5K_QUEUE_TXDP(queue);
+	}
+
+	/* Set descriptor pointer */
+	ath5k_hw_reg_write(ah, phys_addr, tx_reg);
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_update_tx_triglevel - Update tx trigger level
+ *
+ * @ah: The &struct ath5k_hw
+ * @increase: Flag to force increase of trigger level
+ *
+ * This function increases/decreases the tx trigger level for the tx fifo
+ * buffer (aka FIFO threshold) that is used to indicate when PCU flushes
+ * the buffer and transmits it's data. Lowering this results sending small
+ * frames more quickly but can lead to tx underruns, raising it a lot can
+ * result other problems (i think bmiss is related). Right now we start with
+ * the lowest possible (64Bytes) and if we get tx underrun we increase it using
+ * the increase flag. Returns -EIO if we have have reached maximum/minimum.
+ *
+ * XXX: Link this with tx DMA size ?
+ * XXX: Use it to save interrupts ?
+ * TODO: Needs testing, i think it's related to bmiss...
+ */
+int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
+{
+	u32 trigger_level, imr;
+	int ret = -EIO;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/*
+	 * Disable interrupts by setting the mask
+	 */
+	imr = ath5k_hw_set_imr(ah, ah->ah_imr & ~AR5K_INT_GLOBAL);
+
+	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(ah, AR5K_TXCFG),
+			AR5K_TXCFG_TXFULL);
+
+	if (!increase) {
+		if (--trigger_level < AR5K_TUNE_MIN_TX_FIFO_THRES)
+			goto done;
+	} else
+		trigger_level +=
+			((AR5K_TUNE_MAX_TX_FIFO_THRES - trigger_level) / 2);
+
+	/*
+	 * Update trigger level on success
+	 */
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, trigger_level, AR5K_TRIG_LVL);
+	else
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
+				AR5K_TXCFG_TXFULL, trigger_level);
+
+	ret = 0;
+
+done:
+	/*
+	 * Restore interrupt mask
+	 */
+	ath5k_hw_set_imr(ah, imr);
+
+	return ret;
+}
+
+/*******************\
+* Interrupt masking *
+\*******************/
+
+/**
+ * ath5k_hw_is_intr_pending - Check if we have pending interrupts
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Check if we have pending interrupts to process. Returns 1 if we
+ * have pending interrupts and 0 if we haven't.
+ */
+bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	return ath5k_hw_reg_read(ah, AR5K_INTPEND);
+}
+
+/**
+ * ath5k_hw_get_isr - Get interrupt status
+ *
+ * @ah: The @struct ath5k_hw
+ * @interrupt_mask: Driver's interrupt mask used to filter out
+ * interrupts in sw.
+ *
+ * This function is used inside our interrupt handler to determine the reason
+ * for the interrupt by reading Primary Interrupt Status Register. Returns an
+ * abstract interrupt status mask which is mostly ISR with some uncommon bits
+ * being mapped on some standard non hw-specific positions
+ * (check out &ath5k_int).
+ *
+ * NOTE: We use read-and-clear register, so after this function is called ISR
+ * is zeroed.
+ *
+ * XXX: Why filter interrupts in sw with interrupt_mask ? No benefit at all
+ * plus it can be misleading (one might thing that we save interrupts this way)
+ */
+int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
+{
+	u32 data;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/*
+	 * Read interrupt status from the Interrupt Status register
+	 * on 5210
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		data = ath5k_hw_reg_read(ah, AR5K_ISR);
+		if (unlikely(data == AR5K_INT_NOCARD)) {
+			*interrupt_mask = data;
+			return -ENODEV;
+		}
+	} else {
+		/*
+		 * Read interrupt status from the Read-And-Clear
+		 * shadow register.
+		 * Note: PISR/SISR Not available on 5210
+		 */
+		data = ath5k_hw_reg_read(ah, AR5K_RAC_PISR);
+	}
+
+	/*
+	 * Get abstract interrupt mask (driver-compatible)
+	 */
+	*interrupt_mask = (data & AR5K_INT_COMMON) & ah->ah_imr;
+
+	if (unlikely(data == AR5K_INT_NOCARD))
+		return -ENODEV;
+
+	if (data & (AR5K_ISR_RXOK | AR5K_ISR_RXERR))
+		*interrupt_mask |= AR5K_INT_RX;
+
+	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR
+		| AR5K_ISR_TXDESC | AR5K_ISR_TXEOL))
+		*interrupt_mask |= AR5K_INT_TX;
+
+	if (ah->ah_version != AR5K_AR5210) {
+		/*HIU = Host Interface Unit (PCI etc)*/
+		if (unlikely(data & (AR5K_ISR_HIUERR)))
+			*interrupt_mask |= AR5K_INT_FATAL;
+
+		/*Beacon Not Ready*/
+		if (unlikely(data & (AR5K_ISR_BNR)))
+			*interrupt_mask |= AR5K_INT_BNR;
+	}
+
+	/*
+	 * XXX: BMISS interrupts may occur after association.
+	 * I found this on 5210 code but it needs testing. If this is
+	 * true we should disable them before assoc and re-enable them
+	 * after a successfull assoc + some jiffies.
+	 */
+#if 0
+	interrupt_mask &= ~AR5K_INT_BMISS;
+#endif
+
+	/*
+	 * In case we didn't handle anything,
+	 * print the register value.
+	 */
+	if (unlikely(*interrupt_mask == 0 && net_ratelimit()))
+		ATH5K_PRINTF("0x%08x\n", data);
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_set_imr - Set interrupt mask
+ *
+ * @ah: The &struct ath5k_hw
+ * @new_mask: The new interrupt mask to be set
+ *
+ * Set the interrupt mask in hw to save interrupts. We do that by mapping
+ * ath5k_int bits to hw-specific bits to remove abstraction and writing
+ * Interrupt Mask Register.
+ */
+enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
+{
+	enum ath5k_int old_mask, int_mask;
+
+	/*
+	 * Disable card interrupts to prevent any race conditions
+	 * (they will be re-enabled afterwards).
+	 */
+	ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
+	ath5k_hw_reg_read(ah, AR5K_IER);
+
+	old_mask = ah->ah_imr;
+
+	/*
+	 * Add additional, chipset-dependent interrupt mask flags
+	 * and write them to the IMR (interrupt mask register).
+	 */
+	int_mask = new_mask & AR5K_INT_COMMON;
+
+	if (new_mask & AR5K_INT_RX)
+		int_mask |= AR5K_IMR_RXOK | AR5K_IMR_RXERR | AR5K_IMR_RXORN |
+			AR5K_IMR_RXDESC;
+
+	if (new_mask & AR5K_INT_TX)
+		int_mask |= AR5K_IMR_TXOK | AR5K_IMR_TXERR | AR5K_IMR_TXDESC |
+			AR5K_IMR_TXURN;
+
+	if (ah->ah_version != AR5K_AR5210) {
+		if (new_mask & AR5K_INT_FATAL) {
+			int_mask |= AR5K_IMR_HIUERR;
+			AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_MCABT |
+					AR5K_SIMR2_SSERR | AR5K_SIMR2_DPERR);
+		}
+	}
+
+	ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
+
+	/* Store new interrupt mask */
+	ah->ah_imr = new_mask;
+
+	/* ..re-enable interrupts */
+	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
+	ath5k_hw_reg_read(ah, AR5K_IER);
+
+	return old_mask;
+}
+
diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
new file mode 100644
index 0000000..a883839
--- /dev/null
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -0,0 +1,466 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*************************************\
+* EEPROM access functions and helpers *
+\*************************************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*
+ * Read from eeprom
+ */
+static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
+{
+	u32 status, timeout;
+
+	ATH5K_TRACE(ah->ah_sc);
+	/*
+	 * Initialize EEPROM access
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+		(void)ath5k_hw_reg_read(ah, AR5K_EEPROM_BASE + (4 * offset));
+	} else {
+		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
+				AR5K_EEPROM_CMD_READ);
+	}
+
+	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
+		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
+		if (status & AR5K_EEPROM_STAT_RDDONE) {
+			if (status & AR5K_EEPROM_STAT_RDERR)
+				return -EIO;
+			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
+					0xffff);
+			return 0;
+		}
+		udelay(15);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/*
+ * Translate binary channel representation in EEPROM to frequency
+ */
+static u16 ath5k_eeprom_bin2freq(struct ath5k_hw *ah, u16 bin,
+				unsigned int mode)
+{
+	u16 val;
+
+	if (bin == AR5K_EEPROM_CHANNEL_DIS)
+		return bin;
+
+	if (mode == AR5K_EEPROM_MODE_11A) {
+		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+			val = (5 * bin) + 4800;
+		else
+			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
+				(bin * 10) + 5100;
+	} else {
+		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+			val = bin + 2300;
+		else
+			val = bin + 2400;
+	}
+
+	return val;
+}
+
+/*
+ * Read antenna infos from eeprom
+ */
+static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
+		unsigned int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	u32 o = *offset;
+	u16 val;
+	int ret, i = 0;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_switch_settling[mode]	= (val >> 8) & 0x7f;
+	ee->ee_ant_tx_rx[mode]		= (val >> 2) & 0x3f;
+	ee->ee_ant_control[mode][i]	= (val << 4) & 0x3f;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_ant_control[mode][i++]	|= (val >> 12) & 0xf;
+	ee->ee_ant_control[mode][i++]	= (val >> 6) & 0x3f;
+	ee->ee_ant_control[mode][i++]	= val & 0x3f;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_ant_control[mode][i++]	= (val >> 10) & 0x3f;
+	ee->ee_ant_control[mode][i++]	= (val >> 4) & 0x3f;
+	ee->ee_ant_control[mode][i]	= (val << 2) & 0x3f;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_ant_control[mode][i++]	|= (val >> 14) & 0x3;
+	ee->ee_ant_control[mode][i++]	= (val >> 8) & 0x3f;
+	ee->ee_ant_control[mode][i++]	= (val >> 2) & 0x3f;
+	ee->ee_ant_control[mode][i]	= (val << 4) & 0x3f;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_ant_control[mode][i++]	|= (val >> 12) & 0xf;
+	ee->ee_ant_control[mode][i++]	= (val >> 6) & 0x3f;
+	ee->ee_ant_control[mode][i++]	= val & 0x3f;
+
+	/* Get antenna modes */
+	ah->ah_antenna[mode][0] =
+	    (ee->ee_ant_control[mode][0] << 4) | 0x1;
+	ah->ah_antenna[mode][AR5K_ANT_FIXED_A] =
+	     ee->ee_ant_control[mode][1] 	|
+	    (ee->ee_ant_control[mode][2] << 6) 	|
+	    (ee->ee_ant_control[mode][3] << 12) |
+	    (ee->ee_ant_control[mode][4] << 18) |
+	    (ee->ee_ant_control[mode][5] << 24);
+	ah->ah_antenna[mode][AR5K_ANT_FIXED_B] =
+	     ee->ee_ant_control[mode][6] 	|
+	    (ee->ee_ant_control[mode][7] << 6) 	|
+	    (ee->ee_ant_control[mode][8] << 12) |
+	    (ee->ee_ant_control[mode][9] << 18) |
+	    (ee->ee_ant_control[mode][10] << 24);
+
+	/* return new offset */
+	*offset = o;
+
+	return 0;
+}
+
+/*
+ * Read supported modes from eeprom
+ */
+static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
+		unsigned int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	u32 o = *offset;
+	u16 val;
+	int ret;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_tx_end2xlna_enable[mode]	= (val >> 8) & 0xff;
+	ee->ee_thr_62[mode]		= val & 0xff;
+
+	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+		ee->ee_thr_62[mode] = mode == AR5K_EEPROM_MODE_11A ? 15 : 28;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_tx_end2xpa_disable[mode]	= (val >> 8) & 0xff;
+	ee->ee_tx_frm2xpa_enable[mode]	= val & 0xff;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_pga_desired_size[mode]	= (val >> 8) & 0xff;
+
+	if ((val & 0xff) & 0x80)
+		ee->ee_noise_floor_thr[mode] = -((((val & 0xff) ^ 0xff)) + 1);
+	else
+		ee->ee_noise_floor_thr[mode] = val & 0xff;
+
+	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+		ee->ee_noise_floor_thr[mode] =
+		    mode == AR5K_EEPROM_MODE_11A ? -54 : -1;
+
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_xlna_gain[mode]		= (val >> 5) & 0xff;
+	ee->ee_x_gain[mode]		= (val >> 1) & 0xf;
+	ee->ee_xpd[mode]		= val & 0x1;
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
+		ee->ee_fixed_bias[mode] = (val >> 13) & 0x1;
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_false_detect[mode] = (val >> 6) & 0x7f;
+
+		if (mode == AR5K_EEPROM_MODE_11A)
+			ee->ee_xr_power[mode] = val & 0x3f;
+		else {
+			ee->ee_ob[mode][0] = val & 0x7;
+			ee->ee_db[mode][0] = (val >> 3) & 0x7;
+		}
+	}
+
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
+		ee->ee_i_gain[mode] = AR5K_EEPROM_I_GAIN;
+		ee->ee_cck_ofdm_power_delta = AR5K_EEPROM_CCK_OFDM_DELTA;
+	} else {
+		ee->ee_i_gain[mode] = (val >> 13) & 0x7;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_i_gain[mode] |= (val << 3) & 0x38;
+
+		if (mode == AR5K_EEPROM_MODE_11G)
+			ee->ee_cck_ofdm_power_delta = (val >> 3) & 0xff;
+	}
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
+			mode == AR5K_EEPROM_MODE_11A) {
+		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
+		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
+	}
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
+	    mode == AR5K_EEPROM_MODE_11G)
+		ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
+
+	/* return new offset */
+	*offset = o;
+
+	return 0;
+}
+
+/*
+ * Initialize eeprom & capabilities structs
+ */
+int ath5k_eeprom_init(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	unsigned int mode, i;
+	int ret;
+	u32 offset;
+	u16 val;
+
+	/* Initial TX thermal adjustment values */
+	ee->ee_tx_clip = 4;
+	ee->ee_pwd_84 = ee->ee_pwd_90 = 1;
+	ee->ee_gain_select = 1;
+
+	/*
+	 * Read values from EEPROM and store them in the capability structure
+	 */
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MAGIC, ee_magic);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_PROTECT, ee_protect);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_REG_DOMAIN, ee_regdomain);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_VERSION, ee_version);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
+
+	/* Return if we have an old EEPROM */
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
+		return 0;
+
+#ifdef notyet
+	/*
+	 * Validate the checksum of the EEPROM date. There are some
+	 * devices with invalid EEPROMs.
+	 */
+	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
+		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
+		cksum ^= val;
+	}
+	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
+		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
+		return -EIO;
+	}
+#endif
+
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
+	    ee_ant_gain);
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
+	}
+
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
+		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
+		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
+		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
+
+		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB1_2GHZ, val);
+		ee->ee_ob[AR5K_EEPROM_MODE_11G][0] = val & 0x7;
+		ee->ee_db[AR5K_EEPROM_MODE_11G][0] = (val >> 3) & 0x7;
+	}
+
+	/*
+	 * Get conformance test limit values
+	 */
+	offset = AR5K_EEPROM_CTL(ah->ah_ee_version);
+	ee->ee_ctls = AR5K_EEPROM_N_CTLS(ah->ah_ee_version);
+
+	for (i = 0; i < ee->ee_ctls; i++) {
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_ctl[i] = (val >> 8) & 0xff;
+		ee->ee_ctl[i + 1] = val & 0xff;
+	}
+
+	/*
+	 * Get values for 802.11a (5GHz)
+	 */
+	mode = AR5K_EEPROM_MODE_11A;
+
+	ee->ee_turbo_max_power[mode] =
+			AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
+
+	offset = AR5K_EEPROM_MODES_11A(ah->ah_ee_version);
+
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	AR5K_EEPROM_READ(offset++, val);
+	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
+	ee->ee_ob[mode][3]		= (val >> 5) & 0x7;
+	ee->ee_db[mode][3]		= (val >> 2) & 0x7;
+	ee->ee_ob[mode][2]		= (val << 1) & 0x7;
+
+	AR5K_EEPROM_READ(offset++, val);
+	ee->ee_ob[mode][2]		|= (val >> 15) & 0x1;
+	ee->ee_db[mode][2]		= (val >> 12) & 0x7;
+	ee->ee_ob[mode][1]		= (val >> 9) & 0x7;
+	ee->ee_db[mode][1]		= (val >> 6) & 0x7;
+	ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
+	ee->ee_db[mode][0]		= val & 0x7;
+
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_margin_tx_rx[mode] = val & 0x3f;
+	}
+
+	/*
+	 * Get values for 802.11b (2.4GHz)
+	 */
+	mode = AR5K_EEPROM_MODE_11B;
+	offset = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
+
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	AR5K_EEPROM_READ(offset++, val);
+	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
+	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
+	ee->ee_db[mode][1]		= val & 0x7;
+
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_cal_pier[mode][0] =
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+		ee->ee_cal_pier[mode][1] =
+			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
+
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_cal_pier[mode][2] =
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+	}
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+		ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+
+	/*
+	 * Get values for 802.11g (2.4GHz)
+	 */
+	mode = AR5K_EEPROM_MODE_11G;
+	offset = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
+
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	AR5K_EEPROM_READ(offset++, val);
+	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
+	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
+	ee->ee_db[mode][1]		= val & 0x7;
+
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
+	if (ret)
+		return ret;
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_cal_pier[mode][0] =
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+		ee->ee_cal_pier[mode][1] =
+			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
+
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_turbo_max_power[mode] = val & 0x7f;
+		ee->ee_xr_power[mode] = (val >> 7) & 0x3f;
+
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_cal_pier[mode][2] =
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
+		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
+			AR5K_EEPROM_READ(offset++, val);
+			ee->ee_cck_ofdm_gain_delta = val & 0xff;
+		}
+	}
+
+	/*
+	 * Read 5GHz EEPROM channels
+	 */
+
+	return 0;
+}
+
+/*
+ * Read the MAC address from eeprom
+ */
+int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
+{
+	u8 mac_d[ETH_ALEN];
+	u32 total, offset;
+	u16 data;
+	int octet, ret;
+
+	memset(mac, 0, ETH_ALEN);
+	memset(mac_d, 0, ETH_ALEN);
+
+	ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
+	if (ret)
+		return ret;
+
+	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
+		ret = ath5k_hw_eeprom_read(ah, offset, &data);
+		if (ret)
+			return ret;
+
+		total += data;
+		mac_d[octet + 1] = data & 0xff;
+		mac_d[octet] = data >> 8;
+		octet += 2;
+	}
+
+	memcpy(mac, mac_d, ETH_ALEN);
+
+	if (!total || total == 3 * 0xffff)
+		return -EINVAL;
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/ath5k/eeprom.h b/drivers/net/wireless/ath5k/eeprom.h
new file mode 100644
index 0000000..a468ecf
--- /dev/null
+++ b/drivers/net/wireless/ath5k/eeprom.h
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*
+ * Common ar5xxx EEPROM data offsets (set these on AR5K_EEPROM_BASE)
+ */
+#define AR5K_EEPROM_MAGIC		0x003d	/* EEPROM Magic number */
+#define AR5K_EEPROM_MAGIC_VALUE		0x5aa5	/* Default - found on EEPROM */
+#define AR5K_EEPROM_MAGIC_5212		0x0000145c /* 5212 */
+#define AR5K_EEPROM_MAGIC_5211		0x0000145b /* 5211 */
+#define AR5K_EEPROM_MAGIC_5210		0x0000145a /* 5210 */
+
+#define AR5K_EEPROM_PROTECT		0x003f	/* EEPROM protect status */
+#define AR5K_EEPROM_PROTECT_RD_0_31	0x0001	/* Read protection bit for offsets 0x0 - 0x1f */
+#define AR5K_EEPROM_PROTECT_WR_0_31	0x0002	/* Write protection bit for offsets 0x0 - 0x1f */
+#define AR5K_EEPROM_PROTECT_RD_32_63	0x0004	/* 0x20 - 0x3f */
+#define AR5K_EEPROM_PROTECT_WR_32_63	0x0008
+#define AR5K_EEPROM_PROTECT_RD_64_127	0x0010	/* 0x40 - 0x7f */
+#define AR5K_EEPROM_PROTECT_WR_64_127	0x0020
+#define AR5K_EEPROM_PROTECT_RD_128_191	0x0040	/* 0x80 - 0xbf (regdom) */
+#define AR5K_EEPROM_PROTECT_WR_128_191	0x0080
+#define AR5K_EEPROM_PROTECT_RD_192_207	0x0100	/* 0xc0 - 0xcf */
+#define AR5K_EEPROM_PROTECT_WR_192_207	0x0200
+#define AR5K_EEPROM_PROTECT_RD_208_223	0x0400	/* 0xd0 - 0xdf */
+#define AR5K_EEPROM_PROTECT_WR_208_223	0x0800
+#define AR5K_EEPROM_PROTECT_RD_224_239	0x1000	/* 0xe0 - 0xef */
+#define AR5K_EEPROM_PROTECT_WR_224_239	0x2000
+#define AR5K_EEPROM_PROTECT_RD_240_255	0x4000	/* 0xf0 - 0xff */
+#define AR5K_EEPROM_PROTECT_WR_240_255	0x8000
+#define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
+#define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
+#define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)
+#define AR5K_EEPROM_INFO_CKSUM		0xffff
+#define AR5K_EEPROM_INFO(_n)		(AR5K_EEPROM_INFO_BASE + (_n))
+
+#define AR5K_EEPROM_VERSION		AR5K_EEPROM_INFO(1)	/* EEPROM Version */
+#define AR5K_EEPROM_VERSION_3_0		0x3000	/* No idea what's going on before this version */
+#define AR5K_EEPROM_VERSION_3_1		0x3001	/* ob/db values for 2Ghz (ar5211_rfregs) */
+#define AR5K_EEPROM_VERSION_3_2		0x3002	/* different frequency representation (eeprom_bin2freq) */
+#define AR5K_EEPROM_VERSION_3_3		0x3003	/* offsets changed, has 32 CTLs (see below) and ee_false_detect (eeprom_read_modes) */
+#define AR5K_EEPROM_VERSION_3_4		0x3004	/* has ee_i_gain ee_cck_ofdm_power_delta (eeprom_read_modes) */
+#define AR5K_EEPROM_VERSION_4_0		0x4000	/* has ee_misc*, ee_cal_pier, ee_turbo_max_power and ee_xr_power (eeprom_init) */
+#define AR5K_EEPROM_VERSION_4_1		0x4001	/* has ee_margin_tx_rx (eeprom_init) */
+#define AR5K_EEPROM_VERSION_4_2		0x4002	/* has ee_cck_ofdm_gain_delta (eeprom_init) */
+#define AR5K_EEPROM_VERSION_4_3		0x4003
+#define AR5K_EEPROM_VERSION_4_4		0x4004
+#define AR5K_EEPROM_VERSION_4_5		0x4005
+#define AR5K_EEPROM_VERSION_4_6		0x4006	/* has ee_scaled_cck_delta */
+#define AR5K_EEPROM_VERSION_4_7		0x4007
+
+#define AR5K_EEPROM_MODE_11A		0
+#define AR5K_EEPROM_MODE_11B		1
+#define AR5K_EEPROM_MODE_11G		2
+
+#define AR5K_EEPROM_HDR			AR5K_EEPROM_INFO(2)	/* Header that contains the device caps */
+#define AR5K_EEPROM_HDR_11A(_v)		(((_v) >> AR5K_EEPROM_MODE_11A) & 0x1)
+#define AR5K_EEPROM_HDR_11B(_v)		(((_v) >> AR5K_EEPROM_MODE_11B) & 0x1)
+#define AR5K_EEPROM_HDR_11G(_v)		(((_v) >> AR5K_EEPROM_MODE_11G) & 0x1)
+#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz (?) */
+#define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for a/XR mode (eeprom_init) */
+#define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)
+#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz (?) */
+#define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
+
+#define AR5K_EEPROM_RFKILL_GPIO_SEL	0x0000001c
+#define AR5K_EEPROM_RFKILL_GPIO_SEL_S	2
+#define AR5K_EEPROM_RFKILL_POLARITY	0x00000002
+#define AR5K_EEPROM_RFKILL_POLARITY_S	1
+
+/* Newer EEPROMs are using a different offset */
+#define AR5K_EEPROM_OFF(_v, _v3_0, _v3_3) \
+	(((_v) >= AR5K_EEPROM_VERSION_3_3) ? _v3_3 : _v3_0)
+
+#define AR5K_EEPROM_ANT_GAIN(_v)	AR5K_EEPROM_OFF(_v, 0x00c4, 0x00c3)
+#define AR5K_EEPROM_ANT_GAIN_5GHZ(_v)	((int8_t)(((_v) >> 8) & 0xff))
+#define AR5K_EEPROM_ANT_GAIN_2GHZ(_v)	((int8_t)((_v) & 0xff))
+
+/* calibration settings */
+#define AR5K_EEPROM_MODES_11A(_v)	AR5K_EEPROM_OFF(_v, 0x00c5, 0x00d4)
+#define AR5K_EEPROM_MODES_11B(_v)	AR5K_EEPROM_OFF(_v, 0x00d0, 0x00f2)
+#define AR5K_EEPROM_MODES_11G(_v)	AR5K_EEPROM_OFF(_v, 0x00da, 0x010d)
+#define AR5K_EEPROM_CTL(_v)		AR5K_EEPROM_OFF(_v, 0x00e4, 0x0128)	/* Conformance test limits */
+
+/* [3.1 - 3.3] */
+#define AR5K_EEPROM_OBDB0_2GHZ		0x00ec
+#define AR5K_EEPROM_OBDB1_2GHZ		0x00ed
+
+/* Misc values available since EEPROM 4.0 */
+#define AR5K_EEPROM_MISC0		0x00c4
+#define AR5K_EEPROM_EARSTART(_v)	((_v) & 0xfff)
+#define AR5K_EEPROM_EEMAP(_v)		(((_v) >> 14) & 0x3)
+#define AR5K_EEPROM_MISC1		0x00c5
+#define AR5K_EEPROM_TARGET_PWRSTART(_v)	((_v) & 0xfff)
+#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)	(((_v) >> 14) & 0x1)
+
+
+/* Some EEPROM defines */
+#define AR5K_EEPROM_EEP_SCALE		100
+#define AR5K_EEPROM_EEP_DELTA		10
+#define AR5K_EEPROM_N_MODES		3
+#define AR5K_EEPROM_N_5GHZ_CHAN		10
+#define AR5K_EEPROM_N_2GHZ_CHAN		3
+#define AR5K_EEPROM_MAX_CHAN		10
+#define AR5K_EEPROM_N_PCDAC		11
+#define AR5K_EEPROM_N_TEST_FREQ		8
+#define AR5K_EEPROM_N_EDGES		8
+#define AR5K_EEPROM_N_INTERCEPTS	11
+#define AR5K_EEPROM_FREQ_M(_v)		AR5K_EEPROM_OFF(_v, 0x7f, 0xff)
+#define AR5K_EEPROM_PCDAC_M		0x3f
+#define AR5K_EEPROM_PCDAC_START		1
+#define AR5K_EEPROM_PCDAC_STOP		63
+#define AR5K_EEPROM_PCDAC_STEP		1
+#define AR5K_EEPROM_NON_EDGE_M		0x40
+#define AR5K_EEPROM_CHANNEL_POWER	8
+#define AR5K_EEPROM_N_OBDB		4
+#define AR5K_EEPROM_OBDB_DIS		0xffff
+#define AR5K_EEPROM_CHANNEL_DIS		0xff
+#define AR5K_EEPROM_SCALE_OC_DELTA(_x)	(((_x) * 2) / 10)
+#define AR5K_EEPROM_N_CTLS(_v)		AR5K_EEPROM_OFF(_v, 16, 32)
+#define AR5K_EEPROM_MAX_CTLS		32
+#define AR5K_EEPROM_N_XPD_PER_CHANNEL	4
+#define AR5K_EEPROM_N_XPD0_POINTS	4
+#define AR5K_EEPROM_N_XPD3_POINTS	3
+#define AR5K_EEPROM_N_INTERCEPT_10_2GHZ	35
+#define AR5K_EEPROM_N_INTERCEPT_10_5GHZ	55
+#define AR5K_EEPROM_POWER_M		0x3f
+#define AR5K_EEPROM_POWER_MIN		0
+#define AR5K_EEPROM_POWER_MAX		3150
+#define AR5K_EEPROM_POWER_STEP		50
+#define AR5K_EEPROM_POWER_TABLE_SIZE	64
+#define AR5K_EEPROM_N_POWER_LOC_11B	4
+#define AR5K_EEPROM_N_POWER_LOC_11G	6
+#define AR5K_EEPROM_I_GAIN		10
+#define AR5K_EEPROM_CCK_OFDM_DELTA	15
+#define AR5K_EEPROM_N_IQ_CAL		2
+
+#define AR5K_EEPROM_READ(_o, _v) do {			\
+	ret = ath5k_hw_eeprom_read(ah, (_o), &(_v));	\
+	if (ret)					\
+		return ret;				\
+} while (0)
+
+#define AR5K_EEPROM_READ_HDR(_o, _v)					\
+	AR5K_EEPROM_READ(_o, ah->ah_capabilities.cap_eeprom._v);	\
+
+/* Struct to hold EEPROM calibration data */
+struct ath5k_eeprom_info {
+	u16	ee_magic;
+	u16	ee_protect;
+	u16	ee_regdomain;
+	u16	ee_version;
+	u16	ee_header;
+	u16	ee_ant_gain;
+	u16	ee_misc0;
+	u16	ee_misc1;
+	u16	ee_cck_ofdm_gain_delta;
+	u16	ee_cck_ofdm_power_delta;
+	u16	ee_scaled_cck_delta;
+
+	/* Used for tx thermal adjustment (eeprom_init, rfregs) */
+	u16	ee_tx_clip;
+	u16	ee_pwd_84;
+	u16	ee_pwd_90;
+	u16	ee_gain_select;
+
+	/* RF Calibration settings (reset, rfregs) */
+	u16	ee_i_cal[AR5K_EEPROM_N_MODES];
+	u16	ee_q_cal[AR5K_EEPROM_N_MODES];
+	u16	ee_fixed_bias[AR5K_EEPROM_N_MODES];
+	u16	ee_turbo_max_power[AR5K_EEPROM_N_MODES];
+	u16	ee_xr_power[AR5K_EEPROM_N_MODES];
+	u16	ee_switch_settling[AR5K_EEPROM_N_MODES];
+	u16	ee_ant_tx_rx[AR5K_EEPROM_N_MODES];
+	u16	ee_ant_control[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_PCDAC];
+	u16	ee_ob[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
+	u16	ee_db[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
+	u16	ee_tx_end2xlna_enable[AR5K_EEPROM_N_MODES];
+	u16	ee_tx_end2xpa_disable[AR5K_EEPROM_N_MODES];
+	u16	ee_tx_frm2xpa_enable[AR5K_EEPROM_N_MODES];
+	u16	ee_thr_62[AR5K_EEPROM_N_MODES];
+	u16	ee_xlna_gain[AR5K_EEPROM_N_MODES];
+	u16	ee_xpd[AR5K_EEPROM_N_MODES];
+	u16	ee_x_gain[AR5K_EEPROM_N_MODES];
+	u16	ee_i_gain[AR5K_EEPROM_N_MODES];
+	u16	ee_margin_tx_rx[AR5K_EEPROM_N_MODES];
+
+	/* Unused */
+	u16	ee_false_detect[AR5K_EEPROM_N_MODES];
+	u16	ee_cal_pier[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_2GHZ_CHAN];
+	u16	ee_channel[AR5K_EEPROM_N_MODES][AR5K_EEPROM_MAX_CHAN]; /*empty*/
+
+	/* Conformance test limits (Unused) */
+	u16	ee_ctls;
+	u16	ee_ctl[AR5K_EEPROM_MAX_CTLS];
+
+	/* Noise Floor Calibration settings */
+	s16	ee_noise_floor_thr[AR5K_EEPROM_N_MODES];
+	s8	ee_adc_desired_size[AR5K_EEPROM_N_MODES];
+	s8	ee_pga_desired_size[AR5K_EEPROM_N_MODES];
+};
diff --git a/drivers/net/wireless/ath5k/gpio.c b/drivers/net/wireless/ath5k/gpio.c
new file mode 100644
index 0000000..b77205a
--- /dev/null
+++ b/drivers/net/wireless/ath5k/gpio.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/****************\
+  GPIO Functions
+\****************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*
+ * Set led state
+ */
+void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
+{
+	u32 led;
+	/*5210 has different led mode handling*/
+	u32 led_5210;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/*Reset led status*/
+	if (ah->ah_version != AR5K_AR5210)
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
+			AR5K_PCICFG_LEDMODE |  AR5K_PCICFG_LED);
+	else
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_LED);
+
+	/*
+	 * Some blinking values, define at your wish
+	 */
+	switch (state) {
+	case AR5K_LED_SCAN:
+	case AR5K_LED_AUTH:
+		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_PEND;
+		led_5210 = AR5K_PCICFG_LED_PEND | AR5K_PCICFG_LED_BCTL;
+		break;
+
+	case AR5K_LED_INIT:
+		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_NONE;
+		led_5210 = AR5K_PCICFG_LED_PEND;
+		break;
+
+	case AR5K_LED_ASSOC:
+	case AR5K_LED_RUN:
+		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_ASSOC;
+		led_5210 = AR5K_PCICFG_LED_ASSOC;
+		break;
+
+	default:
+		led = AR5K_PCICFG_LEDMODE_PROM | AR5K_PCICFG_LED_NONE;
+		led_5210 = AR5K_PCICFG_LED_PEND;
+		break;
+	}
+
+	/*Write new status to the register*/
+	if (ah->ah_version != AR5K_AR5210)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led);
+	else
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led_5210);
+}
+
+/*
+ * Set GPIO inputs
+ */
+int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (gpio > AR5K_NUM_GPIO)
+		return -EINVAL;
+
+	ath5k_hw_reg_write(ah,
+		(ath5k_hw_reg_read(ah, AR5K_GPIOCR) & ~AR5K_GPIOCR_OUT(gpio))
+		| AR5K_GPIOCR_IN(gpio), AR5K_GPIOCR);
+
+	return 0;
+}
+
+/*
+ * Set GPIO outputs
+ */
+int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (gpio > AR5K_NUM_GPIO)
+		return -EINVAL;
+
+	ath5k_hw_reg_write(ah,
+		(ath5k_hw_reg_read(ah, AR5K_GPIOCR) & ~AR5K_GPIOCR_OUT(gpio))
+		| AR5K_GPIOCR_OUT(gpio), AR5K_GPIOCR);
+
+	return 0;
+}
+
+/*
+ * Get GPIO state
+ */
+u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (gpio > AR5K_NUM_GPIO)
+		return 0xffffffff;
+
+	/* GPIO input magic */
+	return ((ath5k_hw_reg_read(ah, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
+		0x1;
+}
+
+/*
+ * Set GPIO state
+ */
+int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
+{
+	u32 data;
+	ATH5K_TRACE(ah->ah_sc);
+
+	if (gpio > AR5K_NUM_GPIO)
+		return -EINVAL;
+
+	/* GPIO output magic */
+	data = ath5k_hw_reg_read(ah, AR5K_GPIODO);
+
+	data &= ~(1 << gpio);
+	data |= (val & 1) << gpio;
+
+	ath5k_hw_reg_write(ah, data, AR5K_GPIODO);
+
+	return 0;
+}
+
+/*
+ * Initialize the GPIO interrupt (RFKill switch)
+ */
+void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
+		u32 interrupt_level)
+{
+	u32 data;
+
+	ATH5K_TRACE(ah->ah_sc);
+	if (gpio > AR5K_NUM_GPIO)
+		return;
+
+	/*
+	 * Set the GPIO interrupt
+	 */
+	data = (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &
+		~(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_SELH |
+		AR5K_GPIOCR_INT_ENA | AR5K_GPIOCR_OUT(gpio))) |
+		(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_ENA);
+
+	ath5k_hw_reg_write(ah, interrupt_level ? data :
+		(data | AR5K_GPIOCR_INT_SELH), AR5K_GPIOCR);
+
+	ah->ah_imr |= AR5K_IMR_GPIO;
+
+	/* Enable GPIO interrupts */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PIMR, AR5K_IMR_GPIO);
+}
+
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
deleted file mode 100644
index b987aa1..0000000
--- a/drivers/net/wireless/ath5k/hw.c
+++ /dev/null
@@ -1,4492 +0,0 @@
-/*
- * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
- * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
- * Copyright (c) 2007 Matthew W. S. Bell  <mentor@madwifi.org>
- * Copyright (c) 2007 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
- * Copyright (c) 2007 Pavel Roskin <proski@gnu.org>
- * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
- *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- *
- */
-
-/*
- * HW related functions for Atheros Wireless LAN devices.
- */
-
-#include <linux/pci.h>
-#include <linux/delay.h>
-
-#include "reg.h"
-#include "base.h"
-#include "debug.h"
-
-/* Prototypes */
-static int ath5k_hw_nic_reset(struct ath5k_hw *, u32);
-static int ath5k_hw_nic_wakeup(struct ath5k_hw *, int, bool);
-static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
-	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
-	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
-	unsigned int, unsigned int);
-static int ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
-	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
-	unsigned int);
-static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *,
-					 struct ath5k_tx_status *);
-static int ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
-	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
-	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
-	unsigned int, unsigned int);
-static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *,
-					 struct ath5k_tx_status *);
-static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *, struct ath5k_desc *,
-					struct ath5k_rx_status *);
-static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *, struct ath5k_desc *,
-					struct ath5k_rx_status *);
-static int ath5k_hw_get_capabilities(struct ath5k_hw *);
-
-static int ath5k_eeprom_init(struct ath5k_hw *);
-static int ath5k_eeprom_read_mac(struct ath5k_hw *, u8 *);
-
-static int ath5k_hw_enable_pspoll(struct ath5k_hw *, u8 *, u16);
-static int ath5k_hw_disable_pspoll(struct ath5k_hw *);
-
-/*
- * Enable to overwrite the country code (use "00" for debug)
- */
-#if 0
-#define COUNTRYCODE "00"
-#endif
-
-/*******************\
-  General Functions
-\*******************/
-
-/*
- * Functions used internaly
- */
-
-static inline unsigned int ath5k_hw_htoclock(unsigned int usec, bool turbo)
-{
-	return turbo ? (usec * 80) : (usec * 40);
-}
-
-static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
-{
-	return turbo ? (clock / 80) : (clock / 40);
-}
-
-/*
- * Check if a register write has been completed
- */
-int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
-		bool is_set)
-{
-	int i;
-	u32 data;
-
-	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
-		data = ath5k_hw_reg_read(ah, reg);
-		if (is_set && (data & flag))
-			break;
-		else if ((data & flag) == val)
-			break;
-		udelay(15);
-	}
-
-	return (i <= 0) ? -EAGAIN : 0;
-}
-
-
-/***************************************\
-	Attach/Detach Functions
-\***************************************/
-
-/*
- * Power On Self Test helper function
- */
-static int ath5k_hw_post(struct ath5k_hw *ah)
-{
-
-	int i, c;
-	u16 cur_reg;
-	u16 regs[2] = {AR5K_STA_ID0, AR5K_PHY(8)};
-	u32 var_pattern;
-	u32 static_pattern[4] = {
-		0x55555555,	0xaaaaaaaa,
-		0x66666666,	0x99999999
-	};
-	u32 init_val;
-	u32 cur_val;
-
-	for (c = 0; c < 2; c++) {
-
-		cur_reg = regs[c];
-
-		/* Save previous value */
-		init_val = ath5k_hw_reg_read(ah, cur_reg);
-
-		for (i = 0; i < 256; i++) {
-			var_pattern = i << 16 | i;
-			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
-			cur_val = ath5k_hw_reg_read(ah, cur_reg);
-
-			if (cur_val != var_pattern) {
-				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
-				return -EAGAIN;
-			}
-
-			/* Found on ndiswrapper dumps */
-			var_pattern = 0x0039080f;
-			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
-		}
-
-		for (i = 0; i < 4; i++) {
-			var_pattern = static_pattern[i];
-			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
-			cur_val = ath5k_hw_reg_read(ah, cur_reg);
-
-			if (cur_val != var_pattern) {
-				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
-				return -EAGAIN;
-			}
-
-			/* Found on ndiswrapper dumps */
-			var_pattern = 0x003b080f;
-			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
-		}
-
-		/* Restore previous value */
-		ath5k_hw_reg_write(ah, init_val, cur_reg);
-
-	}
-
-	return 0;
-
-}
-
-/*
- * Check if the device is supported and initialize the needed structs
- */
-struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
-{
-	struct ath5k_hw *ah;
-	struct pci_dev *pdev = sc->pdev;
-	u8 mac[ETH_ALEN];
-	int ret;
-	u32 srev;
-
-	/*If we passed the test malloc a ath5k_hw struct*/
-	ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
-	if (ah == NULL) {
-		ret = -ENOMEM;
-		ATH5K_ERR(sc, "out of memory\n");
-		goto err;
-	}
-
-	ah->ah_sc = sc;
-	ah->ah_iobase = sc->iobase;
-
-	/*
-	 * HW information
-	 */
-
-	ah->ah_op_mode = IEEE80211_IF_TYPE_STA;
-	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
-	ah->ah_turbo = false;
-	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
-	ah->ah_imr = 0;
-	ah->ah_atim_window = 0;
-	ah->ah_aifs = AR5K_TUNE_AIFS;
-	ah->ah_cw_min = AR5K_TUNE_CWMIN;
-	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
-	ah->ah_software_retry = false;
-	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
-
-	/*
-	 * Set the mac revision based on the pci id
-	 */
-	ah->ah_version = mac_version;
-
-	/*Fill the ath5k_hw struct with the needed functions*/
-	if (ah->ah_version == AR5K_AR5212)
-		ah->ah_magic = AR5K_EEPROM_MAGIC_5212;
-	else if (ah->ah_version == AR5K_AR5211)
-		ah->ah_magic = AR5K_EEPROM_MAGIC_5211;
-
-	if (ah->ah_version == AR5K_AR5212) {
-		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
-		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		ah->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
-	} else {
-		ah->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
-		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		ah->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
-	}
-
-	if (ah->ah_version == AR5K_AR5212)
-		ah->ah_proc_rx_desc = ath5k_hw_proc_5212_rx_status;
-	else if (ah->ah_version <= AR5K_AR5211)
-		ah->ah_proc_rx_desc = ath5k_hw_proc_5210_rx_status;
-
-	/* Bring device out of sleep and reset it's units */
-	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
-	if (ret)
-		goto err_free;
-
-	/* Get MAC, PHY and RADIO revisions */
-	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
-	ah->ah_mac_srev = srev;
-	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
-	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
-	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
-			0xffffffff;
-	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
-			CHANNEL_5GHZ);
-
-	if (ah->ah_version == AR5K_AR5210)
-		ah->ah_radio_2ghz_revision = 0;
-	else
-		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-				CHANNEL_2GHZ);
-
-	/* Return on unsuported chips (unsupported eeprom etc) */
-	if ((srev >= AR5K_SREV_VER_AR5416) &&
-	(srev < AR5K_SREV_VER_AR2425)) {
-		ATH5K_ERR(sc, "Device not yet supported.\n");
-		ret = -ENODEV;
-		goto err_free;
-	} else if (srev == AR5K_SREV_VER_AR2425) {
-		ATH5K_WARN(sc, "Support for RF2425 is under development.\n");
-	}
-
-	/* Identify single chip solutions */
-	if (((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2413)) ||
-	(srev == AR5K_SREV_VER_AR2425)) {
-		ah->ah_single_chip = true;
-	} else {
-		ah->ah_single_chip = false;
-	}
-
-	/* Single chip radio */
-	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
-		ah->ah_radio_2ghz_revision = 0;
-
-	/* Identify the radio chip*/
-	if (ah->ah_version == AR5K_AR5210) {
-		ah->ah_radio = AR5K_RF5110;
-	/*
-	 * Register returns 0x0/0x04 for radio revision
-	 * so ath5k_hw_radio_revision doesn't parse the value
-	 * correctly. For now we are based on mac's srev to
-	 * identify RF2425 radio.
-	 */
-	} else if (srev == AR5K_SREV_VER_AR2425) {
-		ah->ah_radio = AR5K_RF2425;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
-		ah->ah_radio = AR5K_RF5111;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5111;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC0) {
-		ah->ah_radio = AR5K_RF5112;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
-		ah->ah_radio = AR5K_RF2413;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC2) {
-		ah->ah_radio = AR5K_RF5413;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
-		/* AR5424 */
-		if (srev >= AR5K_SREV_VER_AR5424) {
-			ah->ah_radio = AR5K_RF5413;
-			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
-		/* AR2424 */
-		} else {
-			ah->ah_radio = AR5K_RF2413; /* For testing */
-			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
-		}
-	}
-	ah->ah_phy = AR5K_PHY(0);
-
-	/*
-	 * Write PCI-E power save settings
-	 */
-	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
-		ath5k_hw_reg_write(ah, 0x9248fc00, 0x4080);
-		ath5k_hw_reg_write(ah, 0x24924924, 0x4080);
-		ath5k_hw_reg_write(ah, 0x28000039, 0x4080);
-		ath5k_hw_reg_write(ah, 0x53160824, 0x4080);
-		ath5k_hw_reg_write(ah, 0xe5980579, 0x4080);
-		ath5k_hw_reg_write(ah, 0x001defff, 0x4080);
-		ath5k_hw_reg_write(ah, 0x1aaabe40, 0x4080);
-		ath5k_hw_reg_write(ah, 0xbe105554, 0x4080);
-		ath5k_hw_reg_write(ah, 0x000e3007, 0x4080);
-		ath5k_hw_reg_write(ah, 0x00000000, 0x4084);
-	}
-
-	/*
-	 * POST
-	 */
-	ret = ath5k_hw_post(ah);
-	if (ret)
-		goto err_free;
-
-	/* Write AR5K_PCICFG_UNK on 2112B and later chips */
-	if (ah->ah_radio_5ghz_revision > AR5K_SREV_RAD_2112B ||
-	srev > AR5K_SREV_VER_AR2413) {
-		ath5k_hw_reg_write(ah, AR5K_PCICFG_UNK, AR5K_PCICFG);
-	}
-
-	/*
-	 * Get card capabilities, values, ...
-	 */
-	ret = ath5k_eeprom_init(ah);
-	if (ret) {
-		ATH5K_ERR(sc, "unable to init EEPROM\n");
-		goto err_free;
-	}
-
-	/* Get misc capabilities */
-	ret = ath5k_hw_get_capabilities(ah);
-	if (ret) {
-		ATH5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
-			sc->pdev->device);
-		goto err_free;
-	}
-
-	/* Get MAC address */
-	ret = ath5k_eeprom_read_mac(ah, mac);
-	if (ret) {
-		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
-			sc->pdev->device);
-		goto err_free;
-	}
-
-	ath5k_hw_set_lladdr(ah, mac);
-	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memset(ah->ah_bssid, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
-	ath5k_hw_set_opmode(ah);
-
-	ath5k_hw_set_rfgain_opt(ah);
-
-	return ah;
-err_free:
-	kfree(ah);
-err:
-	return ERR_PTR(ret);
-}
-
-/*
- * Bring up MAC + PHY Chips
- */
-static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
-{
-	struct pci_dev *pdev = ah->ah_sc->pdev;
-	u32 turbo, mode, clock, bus_flags;
-	int ret;
-
-	turbo = 0;
-	mode = 0;
-	clock = 0;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* Wakeup the device */
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
-	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
-		return ret;
-	}
-
-	if (ah->ah_version != AR5K_AR5210) {
-		/*
-		 * Get channel mode flags
-		 */
-
-		if (ah->ah_radio >= AR5K_RF5112) {
-			mode = AR5K_PHY_MODE_RAD_RF5112;
-			clock = AR5K_PHY_PLL_RF5112;
-		} else {
-			mode = AR5K_PHY_MODE_RAD_RF5111;	/*Zero*/
-			clock = AR5K_PHY_PLL_RF5111;		/*Zero*/
-		}
-
-		if (flags & CHANNEL_2GHZ) {
-			mode |= AR5K_PHY_MODE_FREQ_2GHZ;
-			clock |= AR5K_PHY_PLL_44MHZ;
-
-			if (flags & CHANNEL_CCK) {
-				mode |= AR5K_PHY_MODE_MOD_CCK;
-			} else if (flags & CHANNEL_OFDM) {
-				/* XXX Dynamic OFDM/CCK is not supported by the
-				 * AR5211 so we set MOD_OFDM for plain g (no
-				 * CCK headers) operation. We need to test
-				 * this, 5211 might support ofdm-only g after
-				 * all, there are also initial register values
-				 * in the code for g mode (see initvals.c). */
-				if (ah->ah_version == AR5K_AR5211)
-					mode |= AR5K_PHY_MODE_MOD_OFDM;
-				else
-					mode |= AR5K_PHY_MODE_MOD_DYN;
-			} else {
-				ATH5K_ERR(ah->ah_sc,
-					"invalid radio modulation mode\n");
-				return -EINVAL;
-			}
-		} else if (flags & CHANNEL_5GHZ) {
-			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
-			clock |= AR5K_PHY_PLL_40MHZ;
-
-			if (flags & CHANNEL_OFDM)
-				mode |= AR5K_PHY_MODE_MOD_OFDM;
-			else {
-				ATH5K_ERR(ah->ah_sc,
-					"invalid radio modulation mode\n");
-				return -EINVAL;
-			}
-		} else {
-			ATH5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
-			return -EINVAL;
-		}
-
-		if (flags & CHANNEL_TURBO)
-			turbo = AR5K_PHY_TURBO_MODE | AR5K_PHY_TURBO_SHORT;
-	} else { /* Reset the device */
-
-		/* ...enable Atheros turbo mode if requested */
-		if (flags & CHANNEL_TURBO)
-			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
-					AR5K_PHY_TURBO);
-	}
-
-	/* reseting PCI on PCI-E cards results card to hang
-	 * and always return 0xffff... so we ingore that flag
-	 * for PCI-E cards */
-	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
-
-	/* Reset chipset */
-	ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
-		AR5K_RESET_CTL_BASEBAND | bus_flags);
-	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip\n");
-		return -EIO;
-	}
-
-	if (ah->ah_version == AR5K_AR5210)
-		udelay(2300);
-
-	/* ...wakeup again!*/
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
-	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
-		return ret;
-	}
-
-	/* ...final warm reset */
-	if (ath5k_hw_nic_reset(ah, 0)) {
-		ATH5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
-		return -EIO;
-	}
-
-	if (ah->ah_version != AR5K_AR5210) {
-		/* ...set the PHY operating mode */
-		ath5k_hw_reg_write(ah, clock, AR5K_PHY_PLL);
-		udelay(300);
-
-		ath5k_hw_reg_write(ah, mode, AR5K_PHY_MODE);
-		ath5k_hw_reg_write(ah, turbo, AR5K_PHY_TURBO);
-	}
-
-	return 0;
-}
-
-/*
- * Free the ath5k_hw struct
- */
-void ath5k_hw_detach(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
-
-	if (ah->ah_rf_banks != NULL)
-		kfree(ah->ah_rf_banks);
-
-	/* assume interrupts are down */
-	kfree(ah);
-}
-
-/****************************\
-  Reset function and helpers
-\****************************/
-
-/**
- * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
- *
- * @ah: the &struct ath5k_hw
- * @channel: the currently set channel upon reset
- *
- * Write the OFDM timings for the AR5212 upon reset. This is a helper for
- * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
- * depending on the bandwidth of the channel.
- *
- */
-static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
-	struct ieee80211_channel *channel)
-{
-	/* Get exponent and mantissa and set it */
-	u32 coef_scaled, coef_exp, coef_man,
-		ds_coef_exp, ds_coef_man, clock;
-
-	if (!(ah->ah_version == AR5K_AR5212) ||
-		!(channel->hw_value & CHANNEL_OFDM))
-		BUG();
-
-	/* Seems there are two PLLs, one for baseband sampling and one
-	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
-	 * turbo. */
-	clock = channel->hw_value & CHANNEL_TURBO ? 80 : 40;
-	coef_scaled = ((5 * (clock << 24)) / 2) /
-	channel->center_freq;
-
-	for (coef_exp = 31; coef_exp > 0; coef_exp--)
-		if ((coef_scaled >> coef_exp) & 0x1)
-			break;
-
-	if (!coef_exp)
-		return -EINVAL;
-
-	coef_exp = 14 - (coef_exp - 24);
-	coef_man = coef_scaled +
-		(1 << (24 - coef_exp - 1));
-	ds_coef_man = coef_man >> (24 - coef_exp);
-	ds_coef_exp = coef_exp - 16;
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-		AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
-	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-		AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
-
-	return 0;
-}
-
-
-/*
- * index into rates for control rates, we can set it up like this because
- * this is only used for AR5212 and we know it supports G mode
- */
-static int control_rates[] =
-	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
-
-/**
- * ath5k_hw_write_rate_duration - set rate duration during hw resets
- *
- * @ah: the &struct ath5k_hw
- * @mode: one of enum ath5k_driver_mode
- *
- * Write the rate duration table upon hw reset. This is a helper for
- * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout for
- * the hardware for the current mode for each rate. The rates which are capable
- * of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have another
- * register for the short preamble ACK timeout calculation.
- */
-static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
-       unsigned int mode)
-{
-	struct ath5k_softc *sc = ah->ah_sc;
-	struct ieee80211_rate *rate;
-	unsigned int i;
-
-	/* Write rate duration table */
-	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
-		u32 reg;
-		u16 tx_time;
-
-		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
-
-		/* Set ACK timeout */
-		reg = AR5K_RATE_DUR(rate->hw_value);
-
-		/* An ACK frame consists of 10 bytes. If you add the FCS,
-		 * which ieee80211_generic_frame_duration() adds,
-		 * its 14 bytes. Note we use the control rate and not the
-		 * actual rate for this rate. See mac80211 tx.c
-		 * ieee80211_duration() for a brief description of
-		 * what rate we should choose to TX ACKs. */
-		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
-							sc->vif, 10, rate));
-
-		ath5k_hw_reg_write(ah, tx_time, reg);
-
-		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
-			continue;
-
-		/*
-		 * We're not distinguishing short preamble here,
-		 * This is true, all we'll get is a longer value here
-		 * which is not necessarilly bad. We could use
-		 * export ieee80211_frame_duration() but that needs to be
-		 * fixed first to be properly used by mac802111 drivers:
-		 *
-		 *  - remove erp stuff and let the routine figure ofdm
-		 *    erp rates
-		 *  - remove passing argument ieee80211_local as
-		 *    drivers don't have access to it
-		 *  - move drivers using ieee80211_generic_frame_duration()
-		 *    to this
-		 */
-		ath5k_hw_reg_write(ah, tx_time,
-			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
-	}
-}
-
-/*
- * Main reset function
- */
-int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
-	struct ieee80211_channel *channel, bool change_channel)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	struct pci_dev *pdev = ah->ah_sc->pdev;
-	u32 data, s_seq, s_ant, s_led[3], dma_size;
-	unsigned int i, mode, freq, ee_mode, ant[2];
-	int ret;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	s_seq = 0;
-	s_ant = 0;
-	ee_mode = 0;
-	freq = 0;
-	mode = 0;
-
-	/*
-	 * Save some registers before a reset
-	 */
-	/*DCU/Antenna selection not available on 5210*/
-	if (ah->ah_version != AR5K_AR5210) {
-		if (change_channel) {
-			/* Seq number for queue 0 -do this for all queues ? */
-			s_seq = ath5k_hw_reg_read(ah,
-					AR5K_QUEUE_DFS_SEQNUM(0));
-			/*Default antenna*/
-			s_ant = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
-		}
-	}
-
-	/*GPIOs*/
-	s_led[0] = ath5k_hw_reg_read(ah, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
-	s_led[1] = ath5k_hw_reg_read(ah, AR5K_GPIOCR);
-	s_led[2] = ath5k_hw_reg_read(ah, AR5K_GPIODO);
-
-	if (change_channel && ah->ah_rf_banks != NULL)
-		ath5k_hw_get_rf_gain(ah);
-
-
-	/*Wakeup the device*/
-	ret = ath5k_hw_nic_wakeup(ah, channel->hw_value, false);
-	if (ret)
-		return ret;
-
-	/*
-	 * Initialize operating mode
-	 */
-	ah->ah_op_mode = op_mode;
-
-	/*
-	 * 5111/5112 Settings
-	 * 5210 only comes with RF5110
-	 */
-	if (ah->ah_version != AR5K_AR5210) {
-		if (ah->ah_radio != AR5K_RF5111 &&
-			ah->ah_radio != AR5K_RF5112 &&
-			ah->ah_radio != AR5K_RF5413 &&
-			ah->ah_radio != AR5K_RF2413 &&
-			ah->ah_radio != AR5K_RF2425) {
-			ATH5K_ERR(ah->ah_sc,
-				"invalid phy radio: %u\n", ah->ah_radio);
-			return -EINVAL;
-		}
-
-		switch (channel->hw_value & CHANNEL_MODES) {
-		case CHANNEL_A:
-			mode = AR5K_MODE_11A;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		case CHANNEL_G:
-			mode = AR5K_MODE_11G;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11G;
-			break;
-		case CHANNEL_B:
-			mode = AR5K_MODE_11B;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11B;
-			break;
-		case CHANNEL_T:
-			mode = AR5K_MODE_11A_TURBO;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		/*Is this ok on 5211 too ?*/
-		case CHANNEL_TG:
-			mode = AR5K_MODE_11G_TURBO;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11G;
-			break;
-		case CHANNEL_XR:
-			if (ah->ah_version == AR5K_AR5211) {
-				ATH5K_ERR(ah->ah_sc,
-					"XR mode not available on 5211");
-				return -EINVAL;
-			}
-			mode = AR5K_MODE_XR;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		default:
-			ATH5K_ERR(ah->ah_sc,
-				"invalid channel: %d\n", channel->center_freq);
-			return -EINVAL;
-		}
-
-		/* PHY access enable */
-		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
-
-	}
-
-	ret = ath5k_hw_write_initvals(ah, mode, change_channel);
-	if (ret)
-		return ret;
-
-	/*
-	 * 5211/5212 Specific
-	 */
-	if (ah->ah_version != AR5K_AR5210) {
-		/*
-		 * Write initial RF gain settings
-		 * This should work for both 5111/5112
-		 */
-		ret = ath5k_hw_rfgain(ah, freq);
-		if (ret)
-			return ret;
-
-		mdelay(1);
-
-		/*
-		 * Write some more initial register settings
-		 */
-		if (ah->ah_version == AR5K_AR5212) {
-			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
-
-			if (channel->hw_value == CHANNEL_G)
-				if (ah->ah_mac_srev < AR5K_SREV_VER_AR2413)
-					ath5k_hw_reg_write(ah, 0x00f80d80,
-								0x994c);
-				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2424)
-					ath5k_hw_reg_write(ah, 0x00380140,
-								0x994c);
-				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2425)
-					ath5k_hw_reg_write(ah, 0x00fc0ec0,
-								0x994c);
-				else /* 2425 */
-					ath5k_hw_reg_write(ah, 0x00fc0fc0,
-								0x994c);
-			else
-				ath5k_hw_reg_write(ah, 0x00000000, 0x994c);
-
-			/* Some bits are disabled here, we know nothing about
-			 * register 0xa228 yet, most of the times this ends up
-			 * with a value 0x9b5 -haven't seen any dump with
-			 * a different value- */
-			/* Got this from decompiling binary HAL */
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffffdff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffe03ff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-			data = 0;
-
-			/* Just write 0x9b5 ? */
-			/* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
-			ath5k_hw_reg_write(ah, 0x0000000f, AR5K_SEQ_MASK);
-			ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
-			ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
-		}
-
-		/* Fix for first revision of the RF5112 RF chipset */
-		if (ah->ah_radio >= AR5K_RF5112 &&
-				ah->ah_radio_5ghz_revision <
-				AR5K_SREV_RAD_5112A) {
-			ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
-					AR5K_PHY_CCKTXCTL);
-			if (channel->hw_value & CHANNEL_5GHZ)
-				data = 0xffb81020;
-			else
-				data = 0xffb80d20;
-			ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
-			data = 0;
-		}
-
-		/*
-		 * Set TX power (FIXME)
-		 */
-		ret = ath5k_hw_txpower(ah, channel, AR5K_TUNE_DEFAULT_TXPOWER);
-		if (ret)
-			return ret;
-
-		/* Write rate duration table only on AR5212 and if
-		 * virtual interface has already been brought up
-		 * XXX: rethink this after new mode changes to
-		 * mac80211 are integrated */
-		if (ah->ah_version == AR5K_AR5212 &&
-			ah->ah_sc->vif != NULL)
-			ath5k_hw_write_rate_duration(ah, mode);
-
-		/*
-		 * Write RF registers
-		 */
-		ret = ath5k_hw_rfregs(ah, channel, mode);
-		if (ret)
-			return ret;
-
-		/*
-		 * Configure additional registers
-		 */
-
-		/* Write OFDM timings on 5212*/
-		if (ah->ah_version == AR5K_AR5212 &&
-			channel->hw_value & CHANNEL_OFDM) {
-			ret = ath5k_hw_write_ofdm_timings(ah, channel);
-			if (ret)
-				return ret;
-		}
-
-		/*Enable/disable 802.11b mode on 5111
-		(enable 2111 frequency converter + CCK)*/
-		if (ah->ah_radio == AR5K_RF5111) {
-			if (mode == AR5K_MODE_11B)
-				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
-				    AR5K_TXCFG_B_MODE);
-			else
-				AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
-				    AR5K_TXCFG_B_MODE);
-		}
-
-		/*
-		 * Set channel and calibrate the PHY
-		 */
-		ret = ath5k_hw_channel(ah, channel);
-		if (ret)
-			return ret;
-
-		/* Set antenna mode */
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_ANT_CTL,
-			ah->ah_antenna[ee_mode][0], 0xfffffc06);
-
-		/*
-		 * In case a fixed antenna was set as default
-		 * write the same settings on both AR5K_PHY_ANT_SWITCH_TABLE
-		 * registers.
-		 */
-		if (s_ant != 0){
-			if (s_ant == AR5K_ANT_FIXED_A) /* 1 - Main */
-				ant[0] = ant[1] = AR5K_ANT_FIXED_A;
-			else	/* 2 - Aux */
-				ant[0] = ant[1] = AR5K_ANT_FIXED_B;
-		} else {
-			ant[0] = AR5K_ANT_FIXED_A;
-			ant[1] = AR5K_ANT_FIXED_B;
-		}
-
-		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[0]],
-			AR5K_PHY_ANT_SWITCH_TABLE_0);
-		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[1]],
-			AR5K_PHY_ANT_SWITCH_TABLE_1);
-
-		/* Commit values from EEPROM */
-		if (ah->ah_radio == AR5K_RF5111)
-			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_FRAME_CTL,
-			    AR5K_PHY_FRAME_CTL_TX_CLIP, ee->ee_tx_clip);
-
-		ath5k_hw_reg_write(ah,
-			AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
-			AR5K_PHY_NFTHRES);
-
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_SETTLING,
-			(ee->ee_switch_settling[ee_mode] << 7) & 0x3f80,
-			0xffffc07f);
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_GAIN,
-			(ee->ee_ant_tx_rx[ee_mode] << 12) & 0x3f000,
-			0xfffc0fff);
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_DESIRED_SIZE,
-			(ee->ee_adc_desired_size[ee_mode] & 0x00ff) |
-			((ee->ee_pga_desired_size[ee_mode] << 8) & 0xff00),
-			0xffff0000);
-
-		ath5k_hw_reg_write(ah,
-			(ee->ee_tx_end2xpa_disable[ee_mode] << 24) |
-			(ee->ee_tx_end2xpa_disable[ee_mode] << 16) |
-			(ee->ee_tx_frm2xpa_enable[ee_mode] << 8) |
-			(ee->ee_tx_frm2xpa_enable[ee_mode]), AR5K_PHY_RF_CTL4);
-
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_RF_CTL3,
-			ee->ee_tx_end2xlna_enable[ee_mode] << 8, 0xffff00ff);
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_NF,
-			(ee->ee_thr_62[ee_mode] << 12) & 0x7f000, 0xfff80fff);
-		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_OFDM_SELFCORR, 4, 0xffffff01);
-
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
-		    AR5K_PHY_IQ_CORR_ENABLE |
-		    (ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
-		    ee->ee_q_cal[ee_mode]);
-
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN_2GHZ,
-				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
-				ee->ee_margin_tx_rx[ee_mode]);
-
-	} else {
-		mdelay(1);
-		/* Disable phy and wait */
-		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
-		mdelay(1);
-	}
-
-	/*
-	 * Restore saved values
-	 */
-	/*DCU/Antenna selection not available on 5210*/
-	if (ah->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(ah, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
-		ath5k_hw_reg_write(ah, s_ant, AR5K_DEFAULT_ANTENNA);
-	}
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, s_led[0]);
-	ath5k_hw_reg_write(ah, s_led[1], AR5K_GPIOCR);
-	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
-
-	/*
-	 * Misc
-	 */
-	/* XXX: add ah->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
-
-	ath5k_hw_set_opmode(ah);
-	/*PISR/SISR Not available on 5210*/
-	if (ah->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
-		/* If we later allow tuning for this, store into sc structure */
-		data = AR5K_TUNE_RSSI_THRES |
-			AR5K_TUNE_BMISS_THRES << AR5K_RSSI_THR_BMISS_S;
-		ath5k_hw_reg_write(ah, data, AR5K_RSSI_THR);
-	}
-
-	/*
-	 * Set Rx/Tx DMA Configuration
-	 *
-	 * Set maximum DMA size (512) except for PCI-E cards since
-	 * it causes rx overruns and tx errors (tested on 5424 but since
-	 * rx overruns also occur on 5416/5418 with madwifi we set 128
-	 * for all PCI-E cards to be safe).
-	 *
-	 * In dumps this is 128 for allchips.
-	 *
-	 * XXX: need to check 5210 for this
-	 * TODO: Check out tx triger level, it's always 64 on dumps but I
-	 * guess we can tweak it and see how it goes ;-)
-	 */
-	dma_size = (pdev->is_pcie) ? AR5K_DMASIZE_128B : AR5K_DMASIZE_512B;
-	if (ah->ah_version != AR5K_AR5210) {
-		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
-			AR5K_TXCFG_SDMAMR, dma_size);
-		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG,
-			AR5K_RXCFG_SDMAMW, dma_size);
-	}
-
-	/*
-	 * Enable the PHY and wait until completion
-	 */
-	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
-
-	/*
-	 * On 5211+ read activation -> rx delay
-	 * and use it.
-	 */
-	if (ah->ah_version != AR5K_AR5210) {
-		data = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
-			AR5K_PHY_RX_DELAY_M;
-		data = (channel->hw_value & CHANNEL_CCK) ?
-			((data << 2) / 22) : (data / 10);
-
-		udelay(100 + (2 * data));
-		data = 0;
-	} else {
-		mdelay(1);
-	}
-
-	/*
-	 * Perform ADC test (?)
-	 */
-	data = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
-	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
-	for (i = 0; i <= 20; i++) {
-		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
-			break;
-		udelay(200);
-	}
-	ath5k_hw_reg_write(ah, data, AR5K_PHY_TST1);
-	data = 0;
-
-	/*
-	 * Start automatic gain calibration
-	 *
-	 * During AGC calibration RX path is re-routed to
-	 * a signal detector so we don't receive anything.
-	 *
-	 * This method is used to calibrate some static offsets
-	 * used together with on-the fly I/Q calibration (the
-	 * one performed via ath5k_hw_phy_calibrate), that doesn't
-	 * interrupt rx path.
-	 *
-	 * If we are in a noisy environment AGC calibration may time
-	 * out.
-	 */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
-				AR5K_PHY_AGCCTL_CAL);
-
-	/* At the same time start I/Q calibration for QAM constellation
-	 * -no need for CCK- */
-	ah->ah_calibration = false;
-	if (!(mode == AR5K_MODE_11B)) {
-		ah->ah_calibration = true;
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
-				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
-				AR5K_PHY_IQ_RUN);
-	}
-
-	/* Wait for gain calibration to finish (we check for I/Q calibration
-	 * during ath5k_phy_calibrate) */
-	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_CAL, 0, false)) {
-		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
-			channel->center_freq);
-		return -EAGAIN;
-	}
-
-	/*
-	 * Start noise floor calibration
-	 *
-	 * If we run NF calibration before AGC, it always times out.
-	 * Binary HAL starts NF and AGC calibration at the same time
-	 * and only waits for AGC to finish. I believe that's wrong because
-	 * during NF calibration, rx path is also routed to a detector, so if
-	 * it doesn't finish we won't have RX.
-	 *
-	 * XXX: Find an interval that's OK for all cards...
-	 */
-	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
-	if (ret)
-		return ret;
-
-	/*
-	 * Reset queues and start beacon timers at the end of the reset routine
-	 */
-	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
-		/*No QCU on 5210*/
-		if (ah->ah_version != AR5K_AR5210)
-			AR5K_REG_WRITE_Q(ah, AR5K_QUEUE_QCUMASK(i), i);
-
-		ret = ath5k_hw_reset_tx_queue(ah, i);
-		if (ret) {
-			ATH5K_ERR(ah->ah_sc,
-				"failed to reset TX queue #%d\n", i);
-			return ret;
-		}
-	}
-
-	/* Pre-enable interrupts on 5211/5212*/
-	if (ah->ah_version != AR5K_AR5210)
-		ath5k_hw_set_intr(ah, AR5K_INT_RX | AR5K_INT_TX |
-				AR5K_INT_FATAL);
-
-	/*
-	 * Set RF kill flags if supported by the device (read from the EEPROM)
-	 * Disable gpio_intr for now since it results system hang.
-	 * TODO: Handle this in ath5k_intr
-	 */
-#if 0
-	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
-		ath5k_hw_set_gpio_input(ah, 0);
-		ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, 0);
-		if (ah->ah_gpio[0] == 0)
-			ath5k_hw_set_gpio_intr(ah, 0, 1);
-		else
-			ath5k_hw_set_gpio_intr(ah, 0, 0);
-	}
-#endif
-
-	/*
-	 * Set the 32MHz reference clock on 5212 phy clock sleep register
-	 *
-	 * TODO: Find out how to switch to external 32Khz clock to save power
-	 */
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(ah, ah->ah_phy_spending, AR5K_PHY_SPENDING);
-
-		data = ath5k_hw_reg_read(ah, AR5K_USEC_5211) & 0xffffc07f ;
-		data |= (ah->ah_phy_spending == AR5K_PHY_SPENDING_18) ?
-						0x00000f80 : 0x00001380 ;
-		ath5k_hw_reg_write(ah, data, AR5K_USEC_5211);
-		data = 0;
-	}
-
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
-		ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
-		ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
-		if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2413)
-			ath5k_hw_reg_write(ah, 0x00000004, 0x8120);
-	}
-
-	/*
-	 * Disable beacons and reset the register
-	 */
-	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
-			AR5K_BEACON_RESET_TSF);
-
-	return 0;
-}
-
-/*
- * Reset chipset
- */
-static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
-{
-	int ret;
-	u32 mask = val ? val : ~0U;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* Read-and-clear RX Descriptor Pointer*/
-	ath5k_hw_reg_read(ah, AR5K_RXDP);
-
-	/*
-	 * Reset the device and wait until success
-	 */
-	ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
-
-	/* Wait at least 128 PCI clocks */
-	udelay(15);
-
-	if (ah->ah_version == AR5K_AR5210) {
-		val &= AR5K_RESET_CTL_CHIP;
-		mask &= AR5K_RESET_CTL_CHIP;
-	} else {
-		val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
-		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
-	}
-
-	ret = ath5k_hw_register_timeout(ah, AR5K_RESET_CTL, mask, val, false);
-
-	/*
-	 * Reset configuration register (for hw byte-swap). Note that this
-	 * is only set for big endian. We do the necessary magic in
-	 * AR5K_INIT_CFG.
-	 */
-	if ((val & AR5K_RESET_CTL_PCU) == 0)
-		ath5k_hw_reg_write(ah, AR5K_INIT_CFG, AR5K_CFG);
-
-	return ret;
-}
-
-/*
- * Power management functions
- */
-
-/*
- * Sleep control
- */
-int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
-		bool set_chip, u16 sleep_duration)
-{
-	unsigned int i;
-	u32 staid, data;
-
-	ATH5K_TRACE(ah->ah_sc);
-	staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
-
-	switch (mode) {
-	case AR5K_PM_AUTO:
-		staid &= ~AR5K_STA_ID1_DEFAULT_ANTENNA;
-		/* fallthrough */
-	case AR5K_PM_NETWORK_SLEEP:
-		if (set_chip)
-			ath5k_hw_reg_write(ah,
-				AR5K_SLEEP_CTL_SLE_ALLOW |
-				sleep_duration,
-				AR5K_SLEEP_CTL);
-
-		staid |= AR5K_STA_ID1_PWR_SV;
-		break;
-
-	case AR5K_PM_FULL_SLEEP:
-		if (set_chip)
-			ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_SLP,
-				AR5K_SLEEP_CTL);
-
-		staid |= AR5K_STA_ID1_PWR_SV;
-		break;
-
-	case AR5K_PM_AWAKE:
-
-		staid &= ~AR5K_STA_ID1_PWR_SV;
-
-		if (!set_chip)
-			goto commit;
-
-		/* Preserve sleep duration */
-		data = ath5k_hw_reg_read(ah, AR5K_SLEEP_CTL);
-		if( data & 0xffc00000 ){
-			data = 0;
-		} else {
-			data = data & 0xfffcffff;
-		}
-
-		ath5k_hw_reg_write(ah, data, AR5K_SLEEP_CTL);
-		udelay(15);
-
-		for (i = 50; i > 0; i--) {
-			/* Check if the chip did wake up */
-			if ((ath5k_hw_reg_read(ah, AR5K_PCICFG) &
-					AR5K_PCICFG_SPWR_DN) == 0)
-				break;
-
-			/* Wait a bit and retry */
-			udelay(200);
-			ath5k_hw_reg_write(ah, data, AR5K_SLEEP_CTL);
-		}
-
-		/* Fail if the chip didn't wake up */
-		if (i <= 0)
-			return -EIO;
-
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-commit:
-	ah->ah_power_mode = mode;
-	ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);
-
-	return 0;
-}
-
-/***********************\
-  DMA Related Functions
-\***********************/
-
-/*
- * Receive functions
- */
-
-/*
- * Start DMA receive
- */
-void ath5k_hw_start_rx(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
-	ath5k_hw_reg_read(ah, AR5K_CR);
-}
-
-/*
- * Stop DMA receive
- */
-int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
-{
-	unsigned int i;
-
-	ATH5K_TRACE(ah->ah_sc);
-	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
-
-	/*
-	 * It may take some time to disable the DMA receive unit
-	 */
-	for (i = 2000; i > 0 &&
-			(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) != 0;
-			i--)
-		udelay(10);
-
-	return i ? 0 : -EBUSY;
-}
-
-/*
- * Get the address of the RX Descriptor
- */
-u32 ath5k_hw_get_rx_buf(struct ath5k_hw *ah)
-{
-	return ath5k_hw_reg_read(ah, AR5K_RXDP);
-}
-
-/*
- * Set the address of the RX Descriptor
- */
-void ath5k_hw_put_rx_buf(struct ath5k_hw *ah, u32 phys_addr)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*TODO:Shouldn't we check if RX is enabled first ?*/
-	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
-}
-
-/*
- * Transmit functions
- */
-
-/*
- * Start DMA transmit for a specific queue
- * (see also QCU/DCU functions)
- */
-int ath5k_hw_tx_start(struct ath5k_hw *ah, unsigned int queue)
-{
-	u32 tx_queue;
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	/* Return if queue is declared inactive */
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return -EIO;
-
-	if (ah->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
-
-		/*
-		 * Set the queue by type on 5210
-		 */
-		switch (ah->ah_txq[queue].tqi_type) {
-		case AR5K_TX_QUEUE_DATA:
-			tx_queue |= AR5K_CR_TXE0 & ~AR5K_CR_TXD0;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
-					AR5K_BSR);
-			break;
-		case AR5K_TX_QUEUE_CAB:
-			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
-				AR5K_BCR_BDMAE, AR5K_BSR);
-			break;
-		default:
-			return -EINVAL;
-		}
-		/* Start queue */
-		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
-		ath5k_hw_reg_read(ah, AR5K_CR);
-	} else {
-		/* Return if queue is disabled */
-		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXD, queue))
-			return -EIO;
-
-		/* Start queue */
-		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXE, queue);
-	}
-
-	return 0;
-}
-
-/*
- * Stop DMA transmit for a specific queue
- * (see also QCU/DCU functions)
- */
-int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
-{
-	unsigned int i = 100;
-	u32 tx_queue, pending;
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	/* Return if queue is declared inactive */
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return -EIO;
-
-	if (ah->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
-
-		/*
-		 * Set by queue type
-		 */
-		switch (ah->ah_txq[queue].tqi_type) {
-		case AR5K_TX_QUEUE_DATA:
-			tx_queue |= AR5K_CR_TXD0 & ~AR5K_CR_TXE0;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-		case AR5K_TX_QUEUE_CAB:
-			/* XXX Fix me... */
-			tx_queue |= AR5K_CR_TXD1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(ah, 0, AR5K_BSR);
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		/* Stop queue */
-		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
-		ath5k_hw_reg_read(ah, AR5K_CR);
-	} else {
-		/*
-		 * Schedule TX disable and wait until queue is empty
-		 */
-		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXD, queue);
-
-		/*Check for pending frames*/
-		do {
-			pending = ath5k_hw_reg_read(ah,
-				AR5K_QUEUE_STATUS(queue)) &
-				AR5K_QCU_STS_FRMPENDCNT;
-			udelay(100);
-		} while (--i && pending);
-
-		/* Clear register */
-		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
-		if (pending)
-			return -EBUSY;
-	}
-
-	/* TODO: Check for success else return error */
-	return 0;
-}
-
-/*
- * Get the address of the TX Descriptor for a specific queue
- * (see also QCU/DCU functions)
- */
-u32 ath5k_hw_get_tx_buf(struct ath5k_hw *ah, unsigned int queue)
-{
-	u16 tx_reg;
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	/*
-	 * Get the transmit queue descriptor pointer from the selected queue
-	 */
-	/*5210 doesn't have QCU*/
-	if (ah->ah_version == AR5K_AR5210) {
-		switch (ah->ah_txq[queue].tqi_type) {
-		case AR5K_TX_QUEUE_DATA:
-			tx_reg = AR5K_NOQCU_TXDP0;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-		case AR5K_TX_QUEUE_CAB:
-			tx_reg = AR5K_NOQCU_TXDP1;
-			break;
-		default:
-			return 0xffffffff;
-		}
-	} else {
-		tx_reg = AR5K_QUEUE_TXDP(queue);
-	}
-
-	return ath5k_hw_reg_read(ah, tx_reg);
-}
-
-/*
- * Set the address of the TX Descriptor for a specific queue
- * (see also QCU/DCU functions)
- */
-int ath5k_hw_put_tx_buf(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
-{
-	u16 tx_reg;
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	/*
-	 * Set the transmit queue descriptor pointer register by type
-	 * on 5210
-	 */
-	if (ah->ah_version == AR5K_AR5210) {
-		switch (ah->ah_txq[queue].tqi_type) {
-		case AR5K_TX_QUEUE_DATA:
-			tx_reg = AR5K_NOQCU_TXDP0;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-		case AR5K_TX_QUEUE_CAB:
-			tx_reg = AR5K_NOQCU_TXDP1;
-			break;
-		default:
-			return -EINVAL;
-		}
-	} else {
-		/*
-		 * Set the transmit queue descriptor pointer for
-		 * the selected queue on QCU for 5211+
-		 * (this won't work if the queue is still active)
-		 */
-		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
-			return -EIO;
-
-		tx_reg = AR5K_QUEUE_TXDP(queue);
-	}
-
-	/* Set descriptor pointer */
-	ath5k_hw_reg_write(ah, phys_addr, tx_reg);
-
-	return 0;
-}
-
-/*
- * Update tx trigger level
- */
-int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
-{
-	u32 trigger_level, imr;
-	int ret = -EIO;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*
-	 * Disable interrupts by setting the mask
-	 */
-	imr = ath5k_hw_set_intr(ah, ah->ah_imr & ~AR5K_INT_GLOBAL);
-
-	/*TODO: Boundary check on trigger_level*/
-	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(ah, AR5K_TXCFG),
-			AR5K_TXCFG_TXFULL);
-
-	if (!increase) {
-		if (--trigger_level < AR5K_TUNE_MIN_TX_FIFO_THRES)
-			goto done;
-	} else
-		trigger_level +=
-			((AR5K_TUNE_MAX_TX_FIFO_THRES - trigger_level) / 2);
-
-	/*
-	 * Update trigger level on success
-	 */
-	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, trigger_level, AR5K_TRIG_LVL);
-	else
-		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
-				AR5K_TXCFG_TXFULL, trigger_level);
-
-	ret = 0;
-
-done:
-	/*
-	 * Restore interrupt mask
-	 */
-	ath5k_hw_set_intr(ah, imr);
-
-	return ret;
-}
-
-/*
- * Interrupt handling
- */
-
-/*
- * Check if we have pending interrupts
- */
-bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_reg_read(ah, AR5K_INTPEND);
-}
-
-/*
- * Get interrupt mask (ISR)
- */
-int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
-{
-	u32 data;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*
-	 * Read interrupt status from the Interrupt Status register
-	 * on 5210
-	 */
-	if (ah->ah_version == AR5K_AR5210) {
-		data = ath5k_hw_reg_read(ah, AR5K_ISR);
-		if (unlikely(data == AR5K_INT_NOCARD)) {
-			*interrupt_mask = data;
-			return -ENODEV;
-		}
-	} else {
-		/*
-		 * Read interrupt status from the Read-And-Clear shadow register
-		 * Note: PISR/SISR Not available on 5210
-		 */
-		data = ath5k_hw_reg_read(ah, AR5K_RAC_PISR);
-	}
-
-	/*
-	 * Get abstract interrupt mask (driver-compatible)
-	 */
-	*interrupt_mask = (data & AR5K_INT_COMMON) & ah->ah_imr;
-
-	if (unlikely(data == AR5K_INT_NOCARD))
-		return -ENODEV;
-
-	if (data & (AR5K_ISR_RXOK | AR5K_ISR_RXERR))
-		*interrupt_mask |= AR5K_INT_RX;
-
-	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR
-		| AR5K_ISR_TXDESC | AR5K_ISR_TXEOL))
-		*interrupt_mask |= AR5K_INT_TX;
-
-	if (ah->ah_version != AR5K_AR5210) {
-		/*HIU = Host Interface Unit (PCI etc)*/
-		if (unlikely(data & (AR5K_ISR_HIUERR)))
-			*interrupt_mask |= AR5K_INT_FATAL;
-
-		/*Beacon Not Ready*/
-		if (unlikely(data & (AR5K_ISR_BNR)))
-			*interrupt_mask |= AR5K_INT_BNR;
-	}
-
-	/*
-	 * XXX: BMISS interrupts may occur after association.
-	 * I found this on 5210 code but it needs testing. If this is
-	 * true we should disable them before assoc and re-enable them
-	 * after a successfull assoc + some jiffies.
-	 */
-#if 0
-	interrupt_mask &= ~AR5K_INT_BMISS;
-#endif
-
-	/*
-	 * In case we didn't handle anything,
-	 * print the register value.
-	 */
-	if (unlikely(*interrupt_mask == 0 && net_ratelimit()))
-		ATH5K_PRINTF("0x%08x\n", data);
-
-	return 0;
-}
-
-/*
- * Set interrupt mask
- */
-enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask)
-{
-	enum ath5k_int old_mask, int_mask;
-
-	/*
-	 * Disable card interrupts to prevent any race conditions
-	 * (they will be re-enabled afterwards).
-	 */
-	ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
-	ath5k_hw_reg_read(ah, AR5K_IER);
-
-	old_mask = ah->ah_imr;
-
-	/*
-	 * Add additional, chipset-dependent interrupt mask flags
-	 * and write them to the IMR (interrupt mask register).
-	 */
-	int_mask = new_mask & AR5K_INT_COMMON;
-
-	if (new_mask & AR5K_INT_RX)
-		int_mask |= AR5K_IMR_RXOK | AR5K_IMR_RXERR | AR5K_IMR_RXORN |
-			AR5K_IMR_RXDESC;
-
-	if (new_mask & AR5K_INT_TX)
-		int_mask |= AR5K_IMR_TXOK | AR5K_IMR_TXERR | AR5K_IMR_TXDESC |
-			AR5K_IMR_TXURN;
-
-	if (ah->ah_version != AR5K_AR5210) {
-		if (new_mask & AR5K_INT_FATAL) {
-			int_mask |= AR5K_IMR_HIUERR;
-			AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_MCABT |
-					AR5K_SIMR2_SSERR | AR5K_SIMR2_DPERR);
-		}
-	}
-
-	ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
-
-	/* Store new interrupt mask */
-	ah->ah_imr = new_mask;
-
-	/* ..re-enable interrupts */
-	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
-	ath5k_hw_reg_read(ah, AR5K_IER);
-
-	return old_mask;
-}
-
-
-/*************************\
-  EEPROM access functions
-\*************************/
-
-/*
- * Read from eeprom
- */
-static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
-{
-	u32 status, timeout;
-
-	ATH5K_TRACE(ah->ah_sc);
-	/*
-	 * Initialize EEPROM access
-	 */
-	if (ah->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
-		(void)ath5k_hw_reg_read(ah, AR5K_EEPROM_BASE + (4 * offset));
-	} else {
-		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
-				AR5K_EEPROM_CMD_READ);
-	}
-
-	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
-		if (status & AR5K_EEPROM_STAT_RDDONE) {
-			if (status & AR5K_EEPROM_STAT_RDERR)
-				return -EIO;
-			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
-					0xffff);
-			return 0;
-		}
-		udelay(15);
-	}
-
-	return -ETIMEDOUT;
-}
-
-/*
- * Write to eeprom - currently disabled, use at your own risk
- */
-#if 0
-static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
-{
-
-	u32 status, timeout;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*
-	 * Initialize eeprom access
-	 */
-
-	if (ah->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
-	} else {
-		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
-				AR5K_EEPROM_CMD_RESET);
-	}
-
-	/*
-	 * Write data to data register
-	 */
-
-	if (ah->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(ah, data, AR5K_EEPROM_BASE + (4 * offset));
-	} else {
-		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
-		ath5k_hw_reg_write(ah, data, AR5K_EEPROM_DATA);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
-				AR5K_EEPROM_CMD_WRITE);
-	}
-
-	/*
-	 * Check status
-	 */
-
-	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
-		if (status & AR5K_EEPROM_STAT_WRDONE) {
-			if (status & AR5K_EEPROM_STAT_WRERR)
-				return EIO;
-			return 0;
-		}
-		udelay(15);
-	}
-
-	ATH5K_ERR(ah->ah_sc, "EEPROM Write is disabled!");
-	return -EIO;
-}
-#endif
-
-/*
- * Translate binary channel representation in EEPROM to frequency
- */
-static u16 ath5k_eeprom_bin2freq(struct ath5k_hw *ah, u16 bin, unsigned int mode)
-{
-	u16 val;
-
-	if (bin == AR5K_EEPROM_CHANNEL_DIS)
-		return bin;
-
-	if (mode == AR5K_EEPROM_MODE_11A) {
-		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
-			val = (5 * bin) + 4800;
-		else
-			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
-				(bin * 10) + 5100;
-	} else {
-		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
-			val = bin + 2300;
-		else
-			val = bin + 2400;
-	}
-
-	return val;
-}
-
-/*
- * Read antenna infos from eeprom
- */
-static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
-		unsigned int mode)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 o = *offset;
-	u16 val;
-	int ret, i = 0;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_switch_settling[mode]	= (val >> 8) & 0x7f;
-	ee->ee_ant_tx_rx[mode]		= (val >> 2) & 0x3f;
-	ee->ee_ant_control[mode][i]	= (val << 4) & 0x3f;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_ant_control[mode][i++]	|= (val >> 12) & 0xf;
-	ee->ee_ant_control[mode][i++]	= (val >> 6) & 0x3f;
-	ee->ee_ant_control[mode][i++]	= val & 0x3f;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_ant_control[mode][i++]	= (val >> 10) & 0x3f;
-	ee->ee_ant_control[mode][i++]	= (val >> 4) & 0x3f;
-	ee->ee_ant_control[mode][i]	= (val << 2) & 0x3f;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_ant_control[mode][i++]	|= (val >> 14) & 0x3;
-	ee->ee_ant_control[mode][i++]	= (val >> 8) & 0x3f;
-	ee->ee_ant_control[mode][i++]	= (val >> 2) & 0x3f;
-	ee->ee_ant_control[mode][i]	= (val << 4) & 0x3f;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_ant_control[mode][i++]	|= (val >> 12) & 0xf;
-	ee->ee_ant_control[mode][i++]	= (val >> 6) & 0x3f;
-	ee->ee_ant_control[mode][i++]	= val & 0x3f;
-
-	/* Get antenna modes */
-	ah->ah_antenna[mode][0] =
-	    (ee->ee_ant_control[mode][0] << 4) | 0x1;
-	ah->ah_antenna[mode][AR5K_ANT_FIXED_A] =
-	     ee->ee_ant_control[mode][1] 	|
-	    (ee->ee_ant_control[mode][2] << 6) 	|
-	    (ee->ee_ant_control[mode][3] << 12) |
-	    (ee->ee_ant_control[mode][4] << 18) |
-	    (ee->ee_ant_control[mode][5] << 24);
-	ah->ah_antenna[mode][AR5K_ANT_FIXED_B] =
-	     ee->ee_ant_control[mode][6] 	|
-	    (ee->ee_ant_control[mode][7] << 6) 	|
-	    (ee->ee_ant_control[mode][8] << 12) |
-	    (ee->ee_ant_control[mode][9] << 18) |
-	    (ee->ee_ant_control[mode][10] << 24);
-
-	/* return new offset */
-	*offset = o;
-
-	return 0;
-}
-
-/*
- * Read supported modes from eeprom
- */
-static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
-		unsigned int mode)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 o = *offset;
-	u16 val;
-	int ret;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_tx_end2xlna_enable[mode]	= (val >> 8) & 0xff;
-	ee->ee_thr_62[mode]		= val & 0xff;
-
-	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
-		ee->ee_thr_62[mode] = mode == AR5K_EEPROM_MODE_11A ? 15 : 28;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_tx_end2xpa_disable[mode]	= (val >> 8) & 0xff;
-	ee->ee_tx_frm2xpa_enable[mode]	= val & 0xff;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_pga_desired_size[mode]	= (val >> 8) & 0xff;
-
-	if ((val & 0xff) & 0x80)
-		ee->ee_noise_floor_thr[mode] = -((((val & 0xff) ^ 0xff)) + 1);
-	else
-		ee->ee_noise_floor_thr[mode] = val & 0xff;
-
-	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
-		ee->ee_noise_floor_thr[mode] =
-		    mode == AR5K_EEPROM_MODE_11A ? -54 : -1;
-
-	AR5K_EEPROM_READ(o++, val);
-	ee->ee_xlna_gain[mode]		= (val >> 5) & 0xff;
-	ee->ee_x_gain[mode]		= (val >> 1) & 0xf;
-	ee->ee_xpd[mode]		= val & 0x1;
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
-		ee->ee_fixed_bias[mode] = (val >> 13) & 0x1;
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_false_detect[mode] = (val >> 6) & 0x7f;
-
-		if (mode == AR5K_EEPROM_MODE_11A)
-			ee->ee_xr_power[mode] = val & 0x3f;
-		else {
-			ee->ee_ob[mode][0] = val & 0x7;
-			ee->ee_db[mode][0] = (val >> 3) & 0x7;
-		}
-	}
-
-	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
-		ee->ee_i_gain[mode] = AR5K_EEPROM_I_GAIN;
-		ee->ee_cck_ofdm_power_delta = AR5K_EEPROM_CCK_OFDM_DELTA;
-	} else {
-		ee->ee_i_gain[mode] = (val >> 13) & 0x7;
-
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_i_gain[mode] |= (val << 3) & 0x38;
-
-		if (mode == AR5K_EEPROM_MODE_11G)
-			ee->ee_cck_ofdm_power_delta = (val >> 3) & 0xff;
-	}
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
-			mode == AR5K_EEPROM_MODE_11A) {
-		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
-		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
-	}
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
-	    mode == AR5K_EEPROM_MODE_11G)
-		ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
-
-	/* return new offset */
-	*offset = o;
-
-	return 0;
-}
-
-/*
- * Initialize eeprom & capabilities structs
- */
-static int ath5k_eeprom_init(struct ath5k_hw *ah)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	unsigned int mode, i;
-	int ret;
-	u32 offset;
-	u16 val;
-
-	/* Initial TX thermal adjustment values */
-	ee->ee_tx_clip = 4;
-	ee->ee_pwd_84 = ee->ee_pwd_90 = 1;
-	ee->ee_gain_select = 1;
-
-	/*
-	 * Read values from EEPROM and store them in the capability structure
-	 */
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MAGIC, ee_magic);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_PROTECT, ee_protect);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_REG_DOMAIN, ee_regdomain);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_VERSION, ee_version);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
-
-	/* Return if we have an old EEPROM */
-	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
-		return 0;
-
-#ifdef notyet
-	/*
-	 * Validate the checksum of the EEPROM date. There are some
-	 * devices with invalid EEPROMs.
-	 */
-	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
-		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
-		cksum ^= val;
-	}
-	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
-		return -EIO;
-	}
-#endif
-
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
-	    ee_ant_gain);
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
-		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
-		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
-	}
-
-	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
-		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
-		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
-		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
-
-		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB1_2GHZ, val);
-		ee->ee_ob[AR5K_EEPROM_MODE_11G][0] = val & 0x7;
-		ee->ee_db[AR5K_EEPROM_MODE_11G][0] = (val >> 3) & 0x7;
-	}
-
-	/*
-	 * Get conformance test limit values
-	 */
-	offset = AR5K_EEPROM_CTL(ah->ah_ee_version);
-	ee->ee_ctls = AR5K_EEPROM_N_CTLS(ah->ah_ee_version);
-
-	for (i = 0; i < ee->ee_ctls; i++) {
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_ctl[i] = (val >> 8) & 0xff;
-		ee->ee_ctl[i + 1] = val & 0xff;
-	}
-
-	/*
-	 * Get values for 802.11a (5GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11A;
-
-	ee->ee_turbo_max_power[mode] =
-			AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
-
-	offset = AR5K_EEPROM_MODES_11A(ah->ah_ee_version);
-
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][3]		= (val >> 5) & 0x7;
-	ee->ee_db[mode][3]		= (val >> 2) & 0x7;
-	ee->ee_ob[mode][2]		= (val << 1) & 0x7;
-
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_ob[mode][2]		|= (val >> 15) & 0x1;
-	ee->ee_db[mode][2]		= (val >> 12) & 0x7;
-	ee->ee_ob[mode][1]		= (val >> 9) & 0x7;
-	ee->ee_db[mode][1]		= (val >> 6) & 0x7;
-	ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
-	ee->ee_db[mode][0]		= val & 0x7;
-
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_margin_tx_rx[mode] = val & 0x3f;
-	}
-
-	/*
-	 * Get values for 802.11b (2.4GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11B;
-	offset = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
-
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
-	ee->ee_db[mode][1]		= val & 0x7;
-
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
-
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-	}
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-		ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
-
-	/*
-	 * Get values for 802.11g (2.4GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11G;
-	offset = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
-
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
-	ee->ee_db[mode][1]		= val & 0x7;
-
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
-
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
-
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_turbo_max_power[mode] = val & 0x7f;
-		ee->ee_xr_power[mode] = (val >> 7) & 0x3f;
-
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
-
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
-		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
-
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
-			AR5K_EEPROM_READ(offset++, val);
-			ee->ee_cck_ofdm_gain_delta = val & 0xff;
-		}
-	}
-
-	/*
-	 * Read 5GHz EEPROM channels
-	 */
-
-	return 0;
-}
-
-/*
- * Read the MAC address from eeprom
- */
-static int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
-{
-	u8 mac_d[ETH_ALEN];
-	u32 total, offset;
-	u16 data;
-	int octet, ret;
-
-	memset(mac, 0, ETH_ALEN);
-	memset(mac_d, 0, ETH_ALEN);
-
-	ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
-	if (ret)
-		return ret;
-
-	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		ret = ath5k_hw_eeprom_read(ah, offset, &data);
-		if (ret)
-			return ret;
-
-		total += data;
-		mac_d[octet + 1] = data & 0xff;
-		mac_d[octet] = data >> 8;
-		octet += 2;
-	}
-
-	memcpy(mac, mac_d, ETH_ALEN);
-
-	if (!total || total == 3 * 0xffff)
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
- * Fill the capabilities struct
- */
-static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
-{
-	u16 ee_header;
-
-	ATH5K_TRACE(ah->ah_sc);
-	/* Capabilities stored in the EEPROM */
-	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
-
-	if (ah->ah_version == AR5K_AR5210) {
-		/*
-		 * Set radio capabilities
-		 * (The AR5110 only supports the middle 5GHz band)
-		 */
-		ah->ah_capabilities.cap_range.range_5ghz_min = 5120;
-		ah->ah_capabilities.cap_range.range_5ghz_max = 5430;
-		ah->ah_capabilities.cap_range.range_2ghz_min = 0;
-		ah->ah_capabilities.cap_range.range_2ghz_max = 0;
-
-		/* Set supported modes */
-		__set_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode);
-		__set_bit(AR5K_MODE_11A_TURBO, ah->ah_capabilities.cap_mode);
-	} else {
-		/*
-		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
-		 * XXX and from 2312 to 2732GHz. There are problems with the
-		 * XXX current ieee80211 implementation because the IEEE
-		 * XXX channel mapping does not support negative channel
-		 * XXX numbers (2312MHz is channel -19). Of course, this
-		 * XXX doesn't matter because these channels are out of range
-		 * XXX but some regulation domains like MKK (Japan) will
-		 * XXX support frequencies somewhere around 4.8GHz.
-		 */
-
-		/*
-		 * Set radio capabilities
-		 */
-
-		if (AR5K_EEPROM_HDR_11A(ee_header)) {
-			ah->ah_capabilities.cap_range.range_5ghz_min = 5005; /* 4920 */
-			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
-
-			/* Set supported modes */
-			__set_bit(AR5K_MODE_11A,
-					ah->ah_capabilities.cap_mode);
-			__set_bit(AR5K_MODE_11A_TURBO,
-					ah->ah_capabilities.cap_mode);
-			if (ah->ah_version == AR5K_AR5212)
-				__set_bit(AR5K_MODE_11G_TURBO,
-						ah->ah_capabilities.cap_mode);
-		}
-
-		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
-		 * connected */
-		if (AR5K_EEPROM_HDR_11B(ee_header) ||
-				AR5K_EEPROM_HDR_11G(ee_header)) {
-			ah->ah_capabilities.cap_range.range_2ghz_min = 2412; /* 2312 */
-			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
-
-			if (AR5K_EEPROM_HDR_11B(ee_header))
-				__set_bit(AR5K_MODE_11B,
-						ah->ah_capabilities.cap_mode);
-
-			if (AR5K_EEPROM_HDR_11G(ee_header))
-				__set_bit(AR5K_MODE_11G,
-						ah->ah_capabilities.cap_mode);
-		}
-	}
-
-	/* GPIO */
-	ah->ah_gpio_npins = AR5K_NUM_GPIO;
-
-	/* Set number of supported TX queues */
-	if (ah->ah_version == AR5K_AR5210)
-		ah->ah_capabilities.cap_queues.q_tx_num =
-			AR5K_NUM_TX_QUEUES_NOQCU;
-	else
-		ah->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
-
-	return 0;
-}
-
-/*********************************\
-  Protocol Control Unit Functions
-\*********************************/
-
-/*
- * Set Operation mode
- */
-int ath5k_hw_set_opmode(struct ath5k_hw *ah)
-{
-	u32 pcu_reg, beacon_reg, low_id, high_id;
-
-	pcu_reg = 0;
-	beacon_reg = 0;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	switch (ah->ah_op_mode) {
-	case IEEE80211_IF_TYPE_IBSS:
-		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
-		beacon_reg |= AR5K_BCR_ADHOC;
-		break;
-
-	case IEEE80211_IF_TYPE_AP:
-	case IEEE80211_IF_TYPE_MESH_POINT:
-		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
-		beacon_reg |= AR5K_BCR_AP;
-		break;
-
-	case IEEE80211_IF_TYPE_STA:
-		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_PWR_SV : 0);
-	case IEEE80211_IF_TYPE_MNTR:
-		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	/*
-	 * Set PCU registers
-	 */
-	low_id = AR5K_LOW_ID(ah->ah_sta_id);
-	high_id = AR5K_HIGH_ID(ah->ah_sta_id);
-	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
-
-	/*
-	 * Set Beacon Control Register on 5210
-	 */
-	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, beacon_reg, AR5K_BCR);
-
-	return 0;
-}
-
-/*
- * BSSID Functions
- */
-
-/*
- * Get station id
- */
-void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	memcpy(mac, ah->ah_sta_id, ETH_ALEN);
-}
-
-/*
- * Set station id
- */
-int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
-{
-	u32 low_id, high_id;
-
-	ATH5K_TRACE(ah->ah_sc);
-	/* Set new station ID */
-	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
-
-	low_id = AR5K_LOW_ID(mac);
-	high_id = AR5K_HIGH_ID(mac);
-
-	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, high_id, AR5K_STA_ID1);
-
-	return 0;
-}
-
-/*
- * Set BSSID
- */
-void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
-{
-	u32 low_id, high_id;
-	u16 tim_offset = 0;
-
-	/*
-	 * Set simple BSSID mask on 5212
-	 */
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM1);
-	}
-
-	/*
-	 * Set BSSID which triggers the "SME Join" operation
-	 */
-	low_id = AR5K_LOW_ID(bssid);
-	high_id = AR5K_HIGH_ID(bssid);
-	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
-	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
-				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
-
-	if (assoc_id == 0) {
-		ath5k_hw_disable_pspoll(ah);
-		return;
-	}
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_BEACON, AR5K_BEACON_TIM,
-			tim_offset ? tim_offset + 4 : 0);
-
-	ath5k_hw_enable_pspoll(ah, NULL, 0);
-}
-/**
- * ath5k_hw_set_bssid_mask - set common bits we should listen to
- *
- * The bssid_mask is a utility used by AR5212 hardware to inform the hardware
- * which bits of the interface's MAC address should be looked at when trying
- * to decide which packets to ACK. In station mode every bit matters. In AP
- * mode with a single BSS every bit matters as well. In AP mode with
- * multiple BSSes not every bit matters.
- *
- * @ah: the &struct ath5k_hw
- * @mask: the bssid_mask, a u8 array of size ETH_ALEN
- *
- * Note that this is a simple filter and *does* not filter out all
- * relevant frames. Some non-relevant frames will get through, probability
- * jocks are welcomed to compute.
- *
- * When handling multiple BSSes (or VAPs) you can get the BSSID mask by
- * computing the set of:
- *
- *     ~ ( MAC XOR BSSID )
- *
- * When you do this you are essentially computing the common bits. Later it
- * is assumed the harware will "and" (&) the BSSID mask with the MAC address
- * to obtain the relevant bits which should match on the destination frame.
- *
- * Simple example: on your card you have have two BSSes you have created with
- * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
- * There is another BSSID-03 but you are not part of it. For simplicity's sake,
- * assuming only 4 bits for a mac address and for BSSIDs you can then have:
- *
- *                  \
- * MAC:                0001 |
- * BSSID-01:   0100 | --> Belongs to us
- * BSSID-02:   1001 |
- *                  /
- * -------------------
- * BSSID-03:   0110  | --> External
- * -------------------
- *
- * Our bssid_mask would then be:
- *
- *             On loop iteration for BSSID-01:
- *             ~(0001 ^ 0100)  -> ~(0101)
- *                             ->   1010
- *             bssid_mask      =    1010
- *
- *             On loop iteration for BSSID-02:
- *             bssid_mask &= ~(0001   ^   1001)
- *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
- *             bssid_mask =   (1010)  & ~(1001)
- *             bssid_mask =   (1010)  &  (0110)
- *             bssid_mask =   0010
- *
- * A bssid_mask of 0010 means "only pay attention to the second least
- * significant bit". This is because its the only bit common
- * amongst the MAC and all BSSIDs we support. To findout what the real
- * common bit is we can simply "&" the bssid_mask now with any BSSID we have
- * or our MAC address (we assume the hardware uses the MAC address).
- *
- * Now, suppose there's an incoming frame for BSSID-03:
- *
- * IFRAME-01:  0110
- *
- * An easy eye-inspeciton of this already should tell you that this frame
- * will not pass our check. This is beacuse the bssid_mask tells the
- * hardware to only look at the second least significant bit and the
- * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB
- * as 1, which does not match 0.
- *
- * So with IFRAME-01 we *assume* the hardware will do:
- *
- *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
- *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
- *  --> allow = (0010) == 0000 ? 1 : 0;
- *  --> allow = 0
- *
- *  Lets now test a frame that should work:
- *
- * IFRAME-02:  0001 (we should allow)
- *
- *     allow = (0001 & 1010) == 1010
- *
- *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
- *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
- *  --> allow = (0010) == (0010)
- *  --> allow = 1
- *
- * Other examples:
- *
- * IFRAME-03:  0100 --> allowed
- * IFRAME-04:  1001 --> allowed
- * IFRAME-05:  1101 --> allowed but its not for us!!!
- *
- */
-int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
-{
-	u32 low_id, high_id;
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (ah->ah_version == AR5K_AR5212) {
-		low_id = AR5K_LOW_ID(mask);
-		high_id = AR5K_HIGH_ID(mask);
-
-		ath5k_hw_reg_write(ah, low_id, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, high_id, AR5K_BSS_IDM1);
-
-		return 0;
-	}
-
-	return -EIO;
-}
-
-/*
- * Receive start/stop functions
- */
-
-/*
- * Start receive on PCU
- */
-void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
-
-	/* TODO: ANI Support */
-}
-
-/*
- * Stop receive on PCU
- */
-void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
-
-	/* TODO: ANI Support */
-}
-
-/*
- * RX Filter functions
- */
-
-/*
- * Set multicast filter
- */
-void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	/* Set the multicat filter */
-	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
-	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
-}
-
-/*
- * Set multicast filter by index
- */
-int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index)
-{
-
-	ATH5K_TRACE(ah->ah_sc);
-	if (index >= 64)
-		return -EINVAL;
-	else if (index >= 32)
-		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER1,
-				(1 << (index - 32)));
-	else
-		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
-
-	return 0;
-}
-
-/*
- * Clear Multicast filter by index
- */
-int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
-{
-
-	ATH5K_TRACE(ah->ah_sc);
-	if (index >= 64)
-		return -EINVAL;
-	else if (index >= 32)
-		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER1,
-				(1 << (index - 32)));
-	else
-		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
-
-	return 0;
-}
-
-/*
- * Get current rx filter
- */
-u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
-{
-	u32 data, filter = 0;
-
-	ATH5K_TRACE(ah->ah_sc);
-	filter = ath5k_hw_reg_read(ah, AR5K_RX_FILTER);
-
-	/*Radar detection for 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		data = ath5k_hw_reg_read(ah, AR5K_PHY_ERR_FIL);
-
-		if (data & AR5K_PHY_ERR_FIL_RADAR)
-			filter |= AR5K_RX_FILTER_RADARERR;
-		if (data & (AR5K_PHY_ERR_FIL_OFDM | AR5K_PHY_ERR_FIL_CCK))
-			filter |= AR5K_RX_FILTER_PHYERR;
-	}
-
-	return filter;
-}
-
-/*
- * Set rx filter
- */
-void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
-{
-	u32 data = 0;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* Set PHY error filter register on 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		if (filter & AR5K_RX_FILTER_RADARERR)
-			data |= AR5K_PHY_ERR_FIL_RADAR;
-		if (filter & AR5K_RX_FILTER_PHYERR)
-			data |= AR5K_PHY_ERR_FIL_OFDM | AR5K_PHY_ERR_FIL_CCK;
-	}
-
-	/*
-	 * The AR5210 uses promiscous mode to detect radar activity
-	 */
-	if (ah->ah_version == AR5K_AR5210 &&
-			(filter & AR5K_RX_FILTER_RADARERR)) {
-		filter &= ~AR5K_RX_FILTER_RADARERR;
-		filter |= AR5K_RX_FILTER_PROM;
-	}
-
-	/*Zero length DMA*/
-	if (data)
-		AR5K_REG_ENABLE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_ZLFDMA);
-	else
-		AR5K_REG_DISABLE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_ZLFDMA);
-
-	/*Write RX Filter register*/
-	ath5k_hw_reg_write(ah, filter & 0xff, AR5K_RX_FILTER);
-
-	/*Write PHY error filter register on 5212*/
-	if (ah->ah_version == AR5K_AR5212)
-		ath5k_hw_reg_write(ah, data, AR5K_PHY_ERR_FIL);
-
-}
-
-/*
- * Beacon related functions
- */
-
-/*
- * Get a 32bit TSF
- */
-u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_reg_read(ah, AR5K_TSF_L32);
-}
-
-/*
- * Get the full 64bit TSF
- */
-u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
-{
-	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
-	ATH5K_TRACE(ah->ah_sc);
-
-	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
-}
-
-/*
- * Force a TSF reset
- */
-void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
-}
-
-/*
- * Initialize beacon timers
- */
-void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
-{
-	u32 timer1, timer2, timer3;
-
-	ATH5K_TRACE(ah->ah_sc);
-	/*
-	 * Set the additional timers by mode
-	 */
-	switch (ah->ah_op_mode) {
-	case IEEE80211_IF_TYPE_STA:
-		if (ah->ah_version == AR5K_AR5210) {
-			timer1 = 0xffffffff;
-			timer2 = 0xffffffff;
-		} else {
-			timer1 = 0x0000ffff;
-			timer2 = 0x0007ffff;
-		}
-		break;
-
-	default:
-		timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) << 3;
-		timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) << 3;
-	}
-
-	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
-
-	/*
-	 * Set the beacon register and enable all timers.
-	 * (next beacon, DMA beacon, software beacon, ATIM window time)
-	 */
-	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
-	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
-	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
-	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
-
-	ath5k_hw_reg_write(ah, interval & (AR5K_BEACON_PERIOD |
-			AR5K_BEACON_RESET_TSF | AR5K_BEACON_ENABLE),
-		AR5K_BEACON);
-}
-
-#if 0
-/*
- * Set beacon timers
- */
-int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
-		const struct ath5k_beacon_state *state)
-{
-	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
-
-	/*
-	 * TODO: should be changed through *state
-	 * review struct ath5k_beacon_state struct
-	 *
-	 * XXX: These are used for cfp period bellow, are they
-	 * ok ? Is it O.K. for tsf here to be 0 or should we use
-	 * get_tsf ?
-	 */
-	u32 dtim_count = 0; /* XXX */
-	u32 cfp_count = 0; /* XXX */
-	u32 tsf = 0; /* XXX */
-
-	ATH5K_TRACE(ah->ah_sc);
-	/* Return on an invalid beacon state */
-	if (state->bs_interval < 1)
-		return -EINVAL;
-
-	interval = state->bs_interval;
-	dtim = state->bs_dtim_period;
-
-	/*
-	 * PCF support?
-	 */
-	if (state->bs_cfp_period > 0) {
-		/*
-		 * Enable PCF mode and set the CFP
-		 * (Contention Free Period) and timer registers
-		 */
-		cfp_period = state->bs_cfp_period * state->bs_dtim_period *
-			state->bs_interval;
-		next_cfp = (cfp_count * state->bs_dtim_period + dtim_count) *
-			state->bs_interval;
-
-		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
-				AR5K_STA_ID1_DEFAULT_ANTENNA |
-				AR5K_STA_ID1_PCF);
-		ath5k_hw_reg_write(ah, cfp_period, AR5K_CFP_PERIOD);
-		ath5k_hw_reg_write(ah, state->bs_cfp_max_duration,
-				AR5K_CFP_DUR);
-		ath5k_hw_reg_write(ah, (tsf + (next_cfp == 0 ? cfp_period :
-						next_cfp)) << 3, AR5K_TIMER2);
-	} else {
-		/* Disable PCF mode */
-		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
-				AR5K_STA_ID1_DEFAULT_ANTENNA |
-				AR5K_STA_ID1_PCF);
-	}
-
-	/*
-	 * Enable the beacon timer register
-	 */
-	ath5k_hw_reg_write(ah, state->bs_next_beacon, AR5K_TIMER0);
-
-	/*
-	 * Start the beacon timers
-	 */
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_BEACON) &~
-		(AR5K_BEACON_PERIOD | AR5K_BEACON_TIM)) |
-		AR5K_REG_SM(state->bs_tim_offset ? state->bs_tim_offset + 4 : 0,
-		AR5K_BEACON_TIM) | AR5K_REG_SM(state->bs_interval,
-		AR5K_BEACON_PERIOD), AR5K_BEACON);
-
-	/*
-	 * Write new beacon miss threshold, if it appears to be valid
-	 * XXX: Figure out right values for min <= bs_bmiss_threshold <= max
-	 * and return if its not in range. We can test this by reading value and
-	 * setting value to a largest value and seeing which values register.
-	 */
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
-			state->bs_bmiss_threshold);
-
-	/*
-	 * Set sleep control register
-	 * XXX: Didn't find this in 5210 code but since this register
-	 * exists also in ar5k's 5210 headers i leave it as common code.
-	 */
-	AR5K_REG_WRITE_BITS(ah, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
-			(state->bs_sleep_duration - 3) << 3);
-
-	/*
-	 * Set enhanced sleep registers on 5212
-	 */
-	if (ah->ah_version == AR5K_AR5212) {
-		if (state->bs_sleep_duration > state->bs_interval &&
-				roundup(state->bs_sleep_duration, interval) ==
-				state->bs_sleep_duration)
-			interval = state->bs_sleep_duration;
-
-		if (state->bs_sleep_duration > dtim && (dtim == 0 ||
-				roundup(state->bs_sleep_duration, dtim) ==
-				state->bs_sleep_duration))
-			dtim = state->bs_sleep_duration;
-
-		if (interval > dtim)
-			return -EINVAL;
-
-		next_beacon = interval == dtim ? state->bs_next_dtim :
-			state->bs_next_beacon;
-
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM((state->bs_next_dtim - 3) << 3,
-			AR5K_SLEEP0_NEXT_DTIM) |
-			AR5K_REG_SM(10, AR5K_SLEEP0_CABTO) |
-			AR5K_SLEEP0_ENH_SLEEP_EN |
-			AR5K_SLEEP0_ASSUME_DTIM, AR5K_SLEEP0);
-
-		ath5k_hw_reg_write(ah, AR5K_REG_SM((next_beacon - 3) << 3,
-			AR5K_SLEEP1_NEXT_TIM) |
-			AR5K_REG_SM(10, AR5K_SLEEP1_BEACON_TO), AR5K_SLEEP1);
-
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
-			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
-	}
-
-	return 0;
-}
-
-/*
- * Reset beacon timers
- */
-void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	/*
-	 * Disable beacon timer
-	 */
-	ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
-
-	/*
-	 * Disable some beacon register values
-	 */
-	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
-			AR5K_STA_ID1_DEFAULT_ANTENNA | AR5K_STA_ID1_PCF);
-	ath5k_hw_reg_write(ah, AR5K_BEACON_PERIOD, AR5K_BEACON);
-}
-
-/*
- * Wait for beacon queue to finish
- */
-int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
-{
-	unsigned int i;
-	int ret;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* 5210 doesn't have QCU*/
-	if (ah->ah_version == AR5K_AR5210) {
-		/*
-		 * Wait for beaconn queue to finish by checking
-		 * Control Register and Beacon Status Register.
-		 */
-		for (i = AR5K_TUNE_BEACON_INTERVAL / 2; i > 0; i--) {
-			if (!(ath5k_hw_reg_read(ah, AR5K_BSR) & AR5K_BSR_TXQ1F)
-					||
-			    !(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_BSR_TXQ1F))
-				break;
-			udelay(10);
-		}
-
-		/* Timeout... */
-		if (i <= 0) {
-			/*
-			 * Re-schedule the beacon queue
-			 */
-			ath5k_hw_reg_write(ah, phys_addr, AR5K_NOQCU_TXDP1);
-			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
-					AR5K_BCR);
-
-			return -EIO;
-		}
-		ret = 0;
-	} else {
-	/*5211/5212*/
-		ret = ath5k_hw_register_timeout(ah,
-			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
-			AR5K_QCU_STS_FRMPENDCNT, 0, false);
-
-		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
-			return -EIO;
-	}
-
-	return ret;
-}
-#endif
-
-/*
- * Update mib counters (statistics)
- */
-void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
-		struct ieee80211_low_level_stats  *stats)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* Read-And-Clear */
-	stats->dot11ACKFailureCount += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
-	stats->dot11RTSFailureCount += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
-	stats->dot11RTSSuccessCount += ath5k_hw_reg_read(ah, AR5K_RTS_OK);
-	stats->dot11FCSErrorCount += ath5k_hw_reg_read(ah, AR5K_FCS_FAIL);
-
-	/* XXX: Should we use this to track beacon count ?
-	 * -we read it anyway to clear the register */
-	ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
-
-	/* Reset profile count registers on 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
-	}
-}
-
-/** ath5k_hw_set_ack_bitrate - set bitrate for ACKs
- *
- * @ah: the &struct ath5k_hw
- * @high: determines if to use low bit rate or now
- */
-void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
-{
-	if (ah->ah_version != AR5K_AR5212)
-		return;
-	else {
-		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
-		if (high)
-			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
-		else
-			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
-	}
-}
-
-
-/*
- * ACK/CTS Timeouts
- */
-
-/*
- * Set ACK timeout on PCU
- */
-int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
-			ah->ah_turbo) <= timeout)
-		return -EINVAL;
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
-		ath5k_hw_htoclock(timeout, ah->ah_turbo));
-
-	return 0;
-}
-
-/*
- * Read the ACK timeout from PCU
- */
-unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
-}
-
-/*
- * Set CTS timeout on PCU
- */
-int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
-			ah->ah_turbo) <= timeout)
-		return -EINVAL;
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
-			ath5k_hw_htoclock(timeout, ah->ah_turbo));
-
-	return 0;
-}
-
-/*
- * Read CTS timeout from PCU
- */
-unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
-}
-
-/*
- * Key table (WEP) functions
- */
-
-int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
-{
-	unsigned int i;
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
-		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
-
-	/*
-	 * Set NULL encryption on AR5212+
-	 *
-	 * Note: AR5K_KEYTABLE_TYPE -> AR5K_KEYTABLE_OFF(entry, 5)
-	 *       AR5K_KEYTABLE_TYPE_NULL -> 0x00000007
-	 *
-	 * Note2: Windows driver (ndiswrapper) sets this to
-	 *        0x00000714 instead of 0x00000007
-	 */
-	if (ah->ah_version > AR5K_AR5211)
-		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
-				AR5K_KEYTABLE_TYPE(entry));
-
-	return 0;
-}
-
-int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	/* Check the validation flag at the end of the entry */
-	return ath5k_hw_reg_read(ah, AR5K_KEYTABLE_MAC1(entry)) &
-		AR5K_KEYTABLE_VALID;
-}
-
-int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
-		const struct ieee80211_key_conf *key, const u8 *mac)
-{
-	unsigned int i;
-	__le32 key_v[5] = {};
-	u32 keytype;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/* key->keylen comes in from mac80211 in bytes */
-
-	if (key->keylen > AR5K_KEYTABLE_SIZE / 8)
-		return -EOPNOTSUPP;
-
-	switch (key->keylen) {
-	/* WEP 40-bit   = 40-bit  entered key + 24 bit IV = 64-bit */
-	case 40 / 8:
-		memcpy(&key_v[0], key->key, 5);
-		keytype = AR5K_KEYTABLE_TYPE_40;
-		break;
-
-	/* WEP 104-bit  = 104-bit entered key + 24-bit IV = 128-bit */
-	case 104 / 8:
-		memcpy(&key_v[0], &key->key[0], 6);
-		memcpy(&key_v[2], &key->key[6], 6);
-		memcpy(&key_v[4], &key->key[12], 1);
-		keytype = AR5K_KEYTABLE_TYPE_104;
-		break;
-	/* WEP 128-bit  = 128-bit entered key + 24 bit IV = 152-bit */
-	case 128 / 8:
-		memcpy(&key_v[0], &key->key[0], 6);
-		memcpy(&key_v[2], &key->key[6], 6);
-		memcpy(&key_v[4], &key->key[12], 4);
-		keytype = AR5K_KEYTABLE_TYPE_128;
-		break;
-
-	default:
-		return -EINVAL; /* shouldn't happen */
-	}
-
-	for (i = 0; i < ARRAY_SIZE(key_v); i++)
-		ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
-				AR5K_KEYTABLE_OFF(entry, i));
-
-	ath5k_hw_reg_write(ah, keytype, AR5K_KEYTABLE_TYPE(entry));
-
-	return ath5k_hw_set_key_lladdr(ah, entry, mac);
-}
-
-int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
-{
-	u32 low_id, high_id;
-
-	ATH5K_TRACE(ah->ah_sc);
-	 /* Invalid entry (key table overflow) */
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	/* MAC may be NULL if it's a broadcast key. In this case no need to
-	 * to compute AR5K_LOW_ID and AR5K_HIGH_ID as we already know it. */
-	if (unlikely(mac == NULL)) {
-		low_id = 0xffffffff;
-		high_id = 0xffff | AR5K_KEYTABLE_VALID;
-	} else {
-		low_id = AR5K_LOW_ID(mac);
-		high_id = AR5K_HIGH_ID(mac) | AR5K_KEYTABLE_VALID;
-	}
-
-	ath5k_hw_reg_write(ah, low_id, AR5K_KEYTABLE_MAC0(entry));
-	ath5k_hw_reg_write(ah, high_id, AR5K_KEYTABLE_MAC1(entry));
-
-	return 0;
-}
-
-
-/********************************************\
-Queue Control Unit, DFS Control Unit Functions
-\********************************************/
-
-/*
- * Initialize a transmit queue
- */
-int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
-		struct ath5k_txq_info *queue_info)
-{
-	unsigned int queue;
-	int ret;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*
-	 * Get queue by type
-	 */
-	/*5210 only has 2 queues*/
-	if (ah->ah_version == AR5K_AR5210) {
-		switch (queue_type) {
-		case AR5K_TX_QUEUE_DATA:
-			queue = AR5K_TX_QUEUE_ID_NOQCU_DATA;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-		case AR5K_TX_QUEUE_CAB:
-			queue = AR5K_TX_QUEUE_ID_NOQCU_BEACON;
-			break;
-		default:
-			return -EINVAL;
-		}
-	} else {
-		switch (queue_type) {
-		case AR5K_TX_QUEUE_DATA:
-			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
-				ah->ah_txq[queue].tqi_type !=
-				AR5K_TX_QUEUE_INACTIVE; queue++) {
-
-				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
-					return -EINVAL;
-			}
-			break;
-		case AR5K_TX_QUEUE_UAPSD:
-			queue = AR5K_TX_QUEUE_ID_UAPSD;
-			break;
-		case AR5K_TX_QUEUE_BEACON:
-			queue = AR5K_TX_QUEUE_ID_BEACON;
-			break;
-		case AR5K_TX_QUEUE_CAB:
-			queue = AR5K_TX_QUEUE_ID_CAB;
-			break;
-		case AR5K_TX_QUEUE_XR_DATA:
-			if (ah->ah_version != AR5K_AR5212)
-				ATH5K_ERR(ah->ah_sc,
-					"XR data queues only supported in"
-					" 5212!\n");
-			queue = AR5K_TX_QUEUE_ID_XR_DATA;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	/*
-	 * Setup internal queue structure
-	 */
-	memset(&ah->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
-	ah->ah_txq[queue].tqi_type = queue_type;
-
-	if (queue_info != NULL) {
-		queue_info->tqi_type = queue_type;
-		ret = ath5k_hw_setup_tx_queueprops(ah, queue, queue_info);
-		if (ret)
-			return ret;
-	}
-	/*
-	 * We use ah_txq_status to hold a temp value for
-	 * the Secondary interrupt mask registers on 5211+
-	 * check out ath5k_hw_reset_tx_queue
-	 */
-	AR5K_Q_ENABLE_BITS(ah->ah_txq_status, queue);
-
-	return queue;
-}
-
-/*
- * Setup a transmit queue
- */
-int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue,
-				const struct ath5k_txq_info *queue_info)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return -EIO;
-
-	memcpy(&ah->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
-
-	/*XXX: Is this supported on 5210 ?*/
-	if ((queue_info->tqi_type == AR5K_TX_QUEUE_DATA &&
-			((queue_info->tqi_subtype == AR5K_WME_AC_VI) ||
-			(queue_info->tqi_subtype == AR5K_WME_AC_VO))) ||
-			queue_info->tqi_type == AR5K_TX_QUEUE_UAPSD)
-		ah->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
-
-	return 0;
-}
-
-/*
- * Get properties for a specific transmit queue
- */
-int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
-		struct ath5k_txq_info *queue_info)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
-	return 0;
-}
-
-/*
- * Set a transmit queue inactive
- */
-void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
-		return;
-
-	/* This queue will be skipped in further operations */
-	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
-	/*For SIMR setup*/
-	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
-}
-
-/*
- * Set DFS params for a transmit queue
- */
-int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
-{
-	u32 cw_min, cw_max, retry_lg, retry_sh;
-	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
-
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	tq = &ah->ah_txq[queue];
-
-	if (tq->tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return 0;
-
-	if (ah->ah_version == AR5K_AR5210) {
-		/* Only handle data queues, others will be ignored */
-		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
-			return 0;
-
-		/* Set Slot time */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
-			AR5K_SLOT_TIME);
-		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
-			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
-		/* Set Transmit Latency */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
-			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
-		/* Set IFS0 */
-		if (ah->ah_turbo)
-			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME_TURBO) <<
-				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
-				AR5K_IFS0);
-		else
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
-				AR5K_INIT_SIFS, AR5K_IFS0);
-
-		/* Set IFS1 */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
-			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
-		/* Set AR5K_PHY_SETTLING */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
-			| 0x38 :
-			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
-			| 0x1C,
-			AR5K_PHY_SETTLING);
-		/* Set Frame Control Register */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
-			AR5K_PHY_TURBO_SHORT | 0x2020) :
-			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
-			AR5K_PHY_FRAME_CTL_5210);
-	}
-
-	/*
-	 * Calculate cwmin/max by channel mode
-	 */
-	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
-	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
-	ah->ah_aifs = AR5K_TUNE_AIFS;
-	/*XR is only supported on 5212*/
-	if (IS_CHAN_XR(ah->ah_current_channel) &&
-			ah->ah_version == AR5K_AR5212) {
-		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
-		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
-		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
-	/*B mode is not supported on 5210*/
-	} else if (IS_CHAN_B(ah->ah_current_channel) &&
-			ah->ah_version != AR5K_AR5210) {
-		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
-		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
-		ah->ah_aifs = AR5K_TUNE_AIFS_11B;
-	}
-
-	cw_min = 1;
-	while (cw_min < ah->ah_cw_min)
-		cw_min = (cw_min << 1) | 1;
-
-	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
-		((cw_min << tq->tqi_cw_min) + (1 << tq->tqi_cw_min) - 1);
-	cw_max = tq->tqi_cw_max < 0 ? (cw_max >> (-tq->tqi_cw_max)) :
-		((cw_max << tq->tqi_cw_max) + (1 << tq->tqi_cw_max) - 1);
-
-	/*
-	 * Calculate and set retry limits
-	 */
-	if (ah->ah_software_retry) {
-		/* XXX Need to test this */
-		retry_lg = ah->ah_limit_tx_retries;
-		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
-			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
-	} else {
-		retry_lg = AR5K_INIT_LG_RETRY;
-		retry_sh = AR5K_INIT_SH_RETRY;
-	}
-
-	/*No QCU/DCU [5210]*/
-	if (ah->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(ah,
-			(cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
-			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
-			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
-			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
-			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
-			AR5K_NODCU_RETRY_LMT);
-	} else {
-		/*QCU/DCU [5211+]*/
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
-			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
-			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
-			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
-			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
-
-	/*===Rest is also for QCU/DCU only [5211+]===*/
-
-		/*
-		 * Set initial content window (cw_min/cw_max)
-		 * and arbitrated interframe space (aifs)...
-		 */
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
-			AR5K_REG_SM(cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
-			AR5K_REG_SM(ah->ah_aifs + tq->tqi_aifs,
-				AR5K_DCU_LCL_IFS_AIFS),
-			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
-
-		/*
-		 * Set misc registers
-		 */
-		ath5k_hw_reg_write(ah, AR5K_QCU_MISC_DCU_EARLY,
-			AR5K_QUEUE_MISC(queue));
-
-		if (tq->tqi_cbr_period) {
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_cbr_period,
-				AR5K_QCU_CBRCFG_INTVAL) |
-				AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
-				AR5K_QCU_CBRCFG_ORN_THRES),
-				AR5K_QUEUE_CBRCFG(queue));
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_CBR);
-			if (tq->tqi_cbr_overflow_limit)
-				AR5K_REG_ENABLE_BITS(ah,
-					AR5K_QUEUE_MISC(queue),
-					AR5K_QCU_MISC_CBR_THRES_ENABLE);
-		}
-
-		if (tq->tqi_ready_time)
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
-				AR5K_QCU_RDYTIMECFG_INTVAL) |
-				AR5K_QCU_RDYTIMECFG_ENABLE,
-				AR5K_QUEUE_RDYTIMECFG(queue));
-
-		if (tq->tqi_burst_time) {
-			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_burst_time,
-				AR5K_DCU_CHAN_TIME_DUR) |
-				AR5K_DCU_CHAN_TIME_ENABLE,
-				AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
-
-			if (tq->tqi_flags & AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
-				AR5K_REG_ENABLE_BITS(ah,
-					AR5K_QUEUE_MISC(queue),
-					AR5K_QCU_MISC_RDY_VEOL_POLICY);
-		}
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
-			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
-				AR5K_QUEUE_DFS_MISC(queue));
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
-			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_BACKOFF_FRAG,
-				AR5K_QUEUE_DFS_MISC(queue));
-
-		/*
-		 * Set registers by queue type
-		 */
-		switch (tq->tqi_type) {
-		case AR5K_TX_QUEUE_BEACON:
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_DBA_GT |
-				AR5K_QCU_MISC_CBREXP_BCN |
-				AR5K_QCU_MISC_BCN_ENABLE);
-
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
-				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
-				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
-				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
-				AR5K_DCU_MISC_BCN_ENABLE);
-
-			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
-				(AR5K_TUNE_SW_BEACON_RESP -
-				AR5K_TUNE_DMA_BEACON_RESP) -
-				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
-				AR5K_QCU_RDYTIMECFG_ENABLE,
-				AR5K_QUEUE_RDYTIMECFG(queue));
-			break;
-
-		case AR5K_TX_QUEUE_CAB:
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_DBA_GT |
-				AR5K_QCU_MISC_CBREXP |
-				AR5K_QCU_MISC_CBREXP_BCN);
-
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
-				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
-				AR5K_DCU_MISC_ARBLOCK_CTL_S));
-			break;
-
-		case AR5K_TX_QUEUE_UAPSD:
-			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_CBREXP);
-			break;
-
-		case AR5K_TX_QUEUE_DATA:
-		default:
-			break;
-		}
-
-		/*
-		 * Enable interrupts for this tx queue
-		 * in the secondary interrupt mask registers
-		 */
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXOKINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txok, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXERRINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txerr, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXURNINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txurn, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXDESCINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txdesc, queue);
-
-		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
-			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
-
-
-		/* Update secondary interrupt mask registers */
-		ah->ah_txq_imr_txok &= ah->ah_txq_status;
-		ah->ah_txq_imr_txerr &= ah->ah_txq_status;
-		ah->ah_txq_imr_txurn &= ah->ah_txq_status;
-		ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
-		ah->ah_txq_imr_txeol &= ah->ah_txq_status;
-
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
-			AR5K_SIMR0_QCU_TXOK) |
-			AR5K_REG_SM(ah->ah_txq_imr_txdesc,
-			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txerr,
-			AR5K_SIMR1_QCU_TXERR) |
-			AR5K_REG_SM(ah->ah_txq_imr_txeol,
-			AR5K_SIMR1_QCU_TXEOL), AR5K_SIMR1);
-		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txurn,
-			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
-	}
-
-	return 0;
-}
-
-/*
- * Get number of pending frames
- * for a specific queue [5211+]
- */
-u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue) {
-	ATH5K_TRACE(ah->ah_sc);
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
-
-	/* Return if queue is declared inactive */
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return false;
-
-	/* XXX: How about AR5K_CFG_TXCNT ? */
-	if (ah->ah_version == AR5K_AR5210)
-		return false;
-
-	return AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT;
-}
-
-/*
- * Set slot time
- */
-int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
-		return -EINVAL;
-
-	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time,
-				ah->ah_turbo), AR5K_SLOT_TIME);
-	else
-		ath5k_hw_reg_write(ah, slot_time, AR5K_DCU_GBL_IFS_SLOT);
-
-	return 0;
-}
-
-/*
- * Get slot time
- */
-unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (ah->ah_version == AR5K_AR5210)
-		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
-				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
-	else
-		return ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
-}
-
-
-/******************************\
- Hardware Descriptor Functions
-\******************************/
-
-/*
- * TX Descriptor
- */
-
-/*
- * Initialize the 2-word tx descriptor on 5210/5211
- */
-static int
-ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int pkt_len, unsigned int hdr_len, enum ath5k_pkt_type type,
-	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
-	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
-	unsigned int rtscts_rate, unsigned int rtscts_duration)
-{
-	u32 frame_type;
-	struct ath5k_hw_2w_tx_ctl *tx_ctl;
-	unsigned int frame_len;
-
-	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
-
-	/*
-	 * Validate input
-	 * - Zero retries don't make sense.
-	 * - A zero rate will put the HW into a mode where it continously sends
-	 *   noise on the channel, so it is important to avoid this.
-	 */
-	if (unlikely(tx_tries0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero retries\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
-	if (unlikely(tx_rate0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	/* Clear descriptor */
-	memset(&desc->ud.ds_tx5210, 0, sizeof(struct ath5k_hw_5210_tx_desc));
-
-	/* Setup control descriptor */
-
-	/* Verify and set frame length */
-
-	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
-
-	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
-		return -EINVAL;
-
-	tx_ctl->tx_control_0 = frame_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
-
-	/* Verify and set buffer length */
-
-	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	if(type == AR5K_PKT_TYPE_BEACON)
-		pkt_len = roundup(pkt_len, 4);
-
-	if (pkt_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
-		return -EINVAL;
-
-	tx_ctl->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
-
-	/*
-	 * Verify and set header length
-	 * XXX: I only found that on 5210 code, does it work on 5211 ?
-	 */
-	if (ah->ah_version == AR5K_AR5210) {
-		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN)
-			return -EINVAL;
-		tx_ctl->tx_control_0 |=
-			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
-	}
-
-	/*Diferences between 5210-5211*/
-	if (ah->ah_version == AR5K_AR5210) {
-		switch (type) {
-		case AR5K_PKT_TYPE_BEACON:
-		case AR5K_PKT_TYPE_PROBE_RESP:
-			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY;
-		case AR5K_PKT_TYPE_PIFS:
-			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS;
-		default:
-			frame_type = type /*<< 2 ?*/;
-		}
-
-		tx_ctl->tx_control_0 |=
-			AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE) |
-			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
-	} else {
-		tx_ctl->tx_control_0 |=
-			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE) |
-			AR5K_REG_SM(antenna_mode, AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT);
-		tx_ctl->tx_control_1 |=
-			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE);
-	}
-#define _TX_FLAGS(_c, _flag)						\
-	if (flags & AR5K_TXDESC_##_flag)				\
-		tx_ctl->tx_control_##_c |=				\
-			AR5K_2W_TX_DESC_CTL##_c##_##_flag
-
-	_TX_FLAGS(0, CLRDMASK);
-	_TX_FLAGS(0, VEOL);
-	_TX_FLAGS(0, INTREQ);
-	_TX_FLAGS(0, RTSENA);
-	_TX_FLAGS(1, NOACK);
-
-#undef _TX_FLAGS
-
-	/*
-	 * WEP crap
-	 */
-	if (key_index != AR5K_TXKEYIX_INVALID) {
-		tx_ctl->tx_control_0 |=
-			AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
-		tx_ctl->tx_control_1 |=
-			AR5K_REG_SM(key_index,
-			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
-	}
-
-	/*
-	 * RTS/CTS Duration [5210 ?]
-	 */
-	if ((ah->ah_version == AR5K_AR5210) &&
-			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
-		tx_ctl->tx_control_1 |= rtscts_duration &
-				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
-
-	return 0;
-}
-
-/*
- * Initialize the 4-word tx descriptor on 5212
- */
-static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
-	struct ath5k_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
-	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
-	unsigned int tx_tries0, unsigned int key_index,
-	unsigned int antenna_mode, unsigned int flags, unsigned int rtscts_rate,
-	unsigned int rtscts_duration)
-{
-	struct ath5k_hw_4w_tx_ctl *tx_ctl;
-	unsigned int frame_len;
-
-	ATH5K_TRACE(ah->ah_sc);
-	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
-
-	/*
-	 * Validate input
-	 * - Zero retries don't make sense.
-	 * - A zero rate will put the HW into a mode where it continously sends
-	 *   noise on the channel, so it is important to avoid this.
-	 */
-	if (unlikely(tx_tries0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero retries\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
-	if (unlikely(tx_rate0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	/* Clear descriptor */
-	memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
-
-	/* Setup control descriptor */
-
-	/* Verify and set frame length */
-
-	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
-
-	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
-		return -EINVAL;
-
-	tx_ctl->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
-
-	/* Verify and set buffer length */
-
-	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	if(type == AR5K_PKT_TYPE_BEACON)
-		pkt_len = roundup(pkt_len, 4);
-
-	if (pkt_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
-		return -EINVAL;
-
-	tx_ctl->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
-
-	tx_ctl->tx_control_0 |=
-		AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
-		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
-	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
-					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
-	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
-					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
-	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
-
-#define _TX_FLAGS(_c, _flag)			\
-	if (flags & AR5K_TXDESC_##_flag)	\
-		tx_ctl->tx_control_##_c |=	\
-			AR5K_4W_TX_DESC_CTL##_c##_##_flag
-
-	_TX_FLAGS(0, CLRDMASK);
-	_TX_FLAGS(0, VEOL);
-	_TX_FLAGS(0, INTREQ);
-	_TX_FLAGS(0, RTSENA);
-	_TX_FLAGS(0, CTSENA);
-	_TX_FLAGS(1, NOACK);
-
-#undef _TX_FLAGS
-
-	/*
-	 * WEP crap
-	 */
-	if (key_index != AR5K_TXKEYIX_INVALID) {
-		tx_ctl->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
-		tx_ctl->tx_control_1 |= AR5K_REG_SM(key_index,
-				AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
-	}
-
-	/*
-	 * RTS/CTS
-	 */
-	if (flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)) {
-		if ((flags & AR5K_TXDESC_RTSENA) &&
-				(flags & AR5K_TXDESC_CTSENA))
-			return -EINVAL;
-		tx_ctl->tx_control_2 |= rtscts_duration &
-				AR5K_4W_TX_DESC_CTL2_RTS_DURATION;
-		tx_ctl->tx_control_3 |= AR5K_REG_SM(rtscts_rate,
-				AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE);
-	}
-
-	return 0;
-}
-
-/*
- * Initialize a 4-word multirate tx descriptor on 5212
- */
-static int
-ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
-	unsigned int tx_rate3, u_int tx_tries3)
-{
-	struct ath5k_hw_4w_tx_ctl *tx_ctl;
-
-	/*
-	 * Rates can be 0 as long as the retry count is 0 too.
-	 * A zero rate and nonzero retry count will put the HW into a mode where
-	 * it continously sends noise on the channel, so it is important to
-	 * avoid this.
-	 */
-	if (unlikely((tx_rate1 == 0 && tx_tries1 != 0) ||
-		     (tx_rate2 == 0 && tx_tries2 != 0) ||
-		     (tx_rate3 == 0 && tx_tries3 != 0))) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	if (ah->ah_version == AR5K_AR5212) {
-		tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
-
-#define _XTX_TRIES(_n)							\
-	if (tx_tries##_n) {						\
-		tx_ctl->tx_control_2 |=				\
-		    AR5K_REG_SM(tx_tries##_n,				\
-		    AR5K_4W_TX_DESC_CTL2_XMIT_TRIES##_n);		\
-		tx_ctl->tx_control_3 |=				\
-		    AR5K_REG_SM(tx_rate##_n,				\
-		    AR5K_4W_TX_DESC_CTL3_XMIT_RATE##_n);		\
-	}
-
-		_XTX_TRIES(1);
-		_XTX_TRIES(2);
-		_XTX_TRIES(3);
-
-#undef _XTX_TRIES
-
-		return 1;
-	}
-
-	return 0;
-}
-
-/*
- * Proccess the tx status descriptor on 5210/5211
- */
-static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
-{
-	struct ath5k_hw_2w_tx_ctl *tx_ctl;
-	struct ath5k_hw_tx_status *tx_status;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
-	tx_status = &desc->ud.ds_tx5210.tx_stat;
-
-	/* No frame has been send or error */
-	if (unlikely((tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE) == 0))
-		return -EINPROGRESS;
-
-	/*
-	 * Get descriptor status
-	 */
-	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
-	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
-	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
-	/*TODO: ts->ts_virtcol + test*/
-	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
-		AR5K_DESC_TX_STATUS1_SEQ_NUM);
-	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
-		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
-	ts->ts_antenna = 1;
-	ts->ts_status = 0;
-	ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_0,
-		AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
-
-	if ((tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK) == 0){
-		if (tx_status->tx_status_0 &
-				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
-			ts->ts_status |= AR5K_TXERR_XRETRY;
-
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
-			ts->ts_status |= AR5K_TXERR_FIFO;
-
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
-			ts->ts_status |= AR5K_TXERR_FILT;
-	}
-
-	return 0;
-}
-
-/*
- * Proccess a tx descriptor on 5212
- */
-static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
-{
-	struct ath5k_hw_4w_tx_ctl *tx_ctl;
-	struct ath5k_hw_tx_status *tx_status;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
-	tx_status = &desc->ud.ds_tx5212.tx_stat;
-
-	/* No frame has been send or error */
-	if (unlikely((tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE) == 0))
-		return -EINPROGRESS;
-
-	/*
-	 * Get descriptor status
-	 */
-	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
-	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
-	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
-		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
-	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
-		AR5K_DESC_TX_STATUS1_SEQ_NUM);
-	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
-		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
-	ts->ts_antenna = (tx_status->tx_status_1 &
-		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA) ? 2 : 1;
-	ts->ts_status = 0;
-
-	switch (AR5K_REG_MS(tx_status->tx_status_1,
-			AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX)) {
-	case 0:
-		ts->ts_rate = tx_ctl->tx_control_3 &
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
-		break;
-	case 1:
-		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE1);
-		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
-			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
-		break;
-	case 2:
-		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE2);
-		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
-			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
-		break;
-	case 3:
-		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE3);
-		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
-			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3);
-		break;
-	}
-
-	if ((tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK) == 0){
-		if (tx_status->tx_status_0 &
-				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
-			ts->ts_status |= AR5K_TXERR_XRETRY;
-
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
-			ts->ts_status |= AR5K_TXERR_FIFO;
-
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
-			ts->ts_status |= AR5K_TXERR_FILT;
-	}
-
-	return 0;
-}
-
-/*
- * RX Descriptor
- */
-
-/*
- * Initialize an rx descriptor
- */
-int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-			u32 size, unsigned int flags)
-{
-	struct ath5k_hw_rx_ctl *rx_ctl;
-
-	ATH5K_TRACE(ah->ah_sc);
-	rx_ctl = &desc->ud.ds_rx.rx_ctl;
-
-	/*
-	 * Clear the descriptor
-	 * If we don't clean the status descriptor,
-	 * while scanning we get too many results,
-	 * most of them virtual, after some secs
-	 * of scanning system hangs. M.F.
-	*/
-	memset(&desc->ud.ds_rx, 0, sizeof(struct ath5k_hw_all_rx_desc));
-
-	/* Setup descriptor */
-	rx_ctl->rx_control_1 = size & AR5K_DESC_RX_CTL1_BUF_LEN;
-	if (unlikely(rx_ctl->rx_control_1 != size))
-		return -EINVAL;
-
-	if (flags & AR5K_RXDESC_INTREQ)
-		rx_ctl->rx_control_1 |= AR5K_DESC_RX_CTL1_INTREQ;
-
-	return 0;
-}
-
-/*
- * Proccess the rx status descriptor on 5210/5211
- */
-static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
-{
-	struct ath5k_hw_rx_status *rx_status;
-
-	rx_status = &desc->ud.ds_rx.u.rx_stat;
-
-	/* No frame received / not ready */
-	if (unlikely((rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_DONE)
-				== 0))
-		return -EINPROGRESS;
-
-	/*
-	 * Frame receive status
-	 */
-	rs->rs_datalen = rx_status->rx_status_0 &
-		AR5K_5210_RX_DESC_STATUS0_DATA_LEN;
-	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
-	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
-	rs->rs_antenna = rx_status->rx_status_0 &
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	rs->rs_more = rx_status->rx_status_0 &
-		AR5K_5210_RX_DESC_STATUS0_MORE;
-	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
-	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
-		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
-	rs->rs_status = 0;
-	rs->rs_phyerr = 0;
-
-	/*
-	 * Key table status
-	 */
-	if (rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID)
-		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
-			AR5K_5210_RX_DESC_STATUS1_KEY_INDEX);
-	else
-		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
-
-	/*
-	 * Receive/descriptor errors
-	 */
-	if ((rx_status->rx_status_1 &
-			AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
-		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_CRC_ERROR)
-			rs->rs_status |= AR5K_RXERR_CRC;
-
-		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN)
-			rs->rs_status |= AR5K_RXERR_FIFO;
-
-		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
-			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
-					   AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
-		}
-
-		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
-			rs->rs_status |= AR5K_RXERR_DECRYPT;
-	}
-
-	return 0;
-}
-
-/*
- * Proccess the rx status descriptor on 5212
- */
-static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
-{
-	struct ath5k_hw_rx_status *rx_status;
-	struct ath5k_hw_rx_error *rx_err;
-
-	ATH5K_TRACE(ah->ah_sc);
-	rx_status = &desc->ud.ds_rx.u.rx_stat;
-
-	/* Overlay on error */
-	rx_err = &desc->ud.ds_rx.u.rx_err;
-
-	/* No frame received / not ready */
-	if (unlikely((rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_DONE)
-				== 0))
-		return -EINPROGRESS;
-
-	/*
-	 * Frame receive status
-	 */
-	rs->rs_datalen = rx_status->rx_status_0 &
-		AR5K_5212_RX_DESC_STATUS0_DATA_LEN;
-	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL);
-	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE);
-	rs->rs_antenna = rx_status->rx_status_0 &
-		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	rs->rs_more = rx_status->rx_status_0 &
-		AR5K_5212_RX_DESC_STATUS0_MORE;
-	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
-		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
-	rs->rs_status = 0;
-	rs->rs_phyerr = 0;
-
-	/*
-	 * Key table status
-	 */
-	if (rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID)
-		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
-				AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
-	else
-		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
-
-	/*
-	 * Receive/descriptor errors
-	 */
-	if ((rx_status->rx_status_1 &
-			AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
-		if (rx_status->rx_status_1 &
-				AR5K_5212_RX_DESC_STATUS1_CRC_ERROR)
-			rs->rs_status |= AR5K_RXERR_CRC;
-
-		if (rx_status->rx_status_1 &
-				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
-			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr |= AR5K_REG_MS(rx_err->rx_error_1,
-					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
-		}
-
-		if (rx_status->rx_status_1 &
-				AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
-			rs->rs_status |= AR5K_RXERR_DECRYPT;
-
-		if (rx_status->rx_status_1 &
-				AR5K_5212_RX_DESC_STATUS1_MIC_ERROR)
-			rs->rs_status |= AR5K_RXERR_MIC;
-	}
-
-	return 0;
-}
-
-
-/****************\
-  GPIO Functions
-\****************/
-
-/*
- * Set led state
- */
-void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
-{
-	u32 led;
-	/*5210 has different led mode handling*/
-	u32 led_5210;
-
-	ATH5K_TRACE(ah->ah_sc);
-
-	/*Reset led status*/
-	if (ah->ah_version != AR5K_AR5210)
-		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
-			AR5K_PCICFG_LEDMODE |  AR5K_PCICFG_LED);
-	else
-		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_LED);
-
-	/*
-	 * Some blinking values, define at your wish
-	 */
-	switch (state) {
-	case AR5K_LED_SCAN:
-	case AR5K_LED_AUTH:
-		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_PEND;
-		led_5210 = AR5K_PCICFG_LED_PEND | AR5K_PCICFG_LED_BCTL;
-		break;
-
-	case AR5K_LED_INIT:
-		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_NONE;
-		led_5210 = AR5K_PCICFG_LED_PEND;
-		break;
-
-	case AR5K_LED_ASSOC:
-	case AR5K_LED_RUN:
-		led = AR5K_PCICFG_LEDMODE_PROP | AR5K_PCICFG_LED_ASSOC;
-		led_5210 = AR5K_PCICFG_LED_ASSOC;
-		break;
-
-	default:
-		led = AR5K_PCICFG_LEDMODE_PROM | AR5K_PCICFG_LED_NONE;
-		led_5210 = AR5K_PCICFG_LED_PEND;
-		break;
-	}
-
-	/*Write new status to the register*/
-	if (ah->ah_version != AR5K_AR5210)
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led);
-	else
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led_5210);
-}
-
-/*
- * Set GPIO outputs
- */
-int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
-		return -EINVAL;
-
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &~
-		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_OUT(gpio), AR5K_GPIOCR);
-
-	return 0;
-}
-
-/*
- * Set GPIO inputs
- */
-int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
-		return -EINVAL;
-
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &~
-		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_IN(gpio), AR5K_GPIOCR);
-
-	return 0;
-}
-
-/*
- * Get GPIO state
- */
-u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
-		return 0xffffffff;
-
-	/* GPIO input magic */
-	return ((ath5k_hw_reg_read(ah, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
-		0x1;
-}
-
-/*
- * Set GPIO state
- */
-int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
-{
-	u32 data;
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (gpio > AR5K_NUM_GPIO)
-		return -EINVAL;
-
-	/* GPIO output magic */
-	data = ath5k_hw_reg_read(ah, AR5K_GPIODO);
-
-	data &= ~(1 << gpio);
-	data |= (val & 1) << gpio;
-
-	ath5k_hw_reg_write(ah, data, AR5K_GPIODO);
-
-	return 0;
-}
-
-/*
- * Initialize the GPIO interrupt (RFKill switch)
- */
-void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
-		u32 interrupt_level)
-{
-	u32 data;
-
-	ATH5K_TRACE(ah->ah_sc);
-	if (gpio > AR5K_NUM_GPIO)
-		return;
-
-	/*
-	 * Set the GPIO interrupt
-	 */
-	data = (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &
-		~(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_SELH |
-		AR5K_GPIOCR_INT_ENA | AR5K_GPIOCR_OUT(gpio))) |
-		(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_ENA);
-
-	ath5k_hw_reg_write(ah, interrupt_level ? data :
-		(data | AR5K_GPIOCR_INT_SELH), AR5K_GPIOCR);
-
-	ah->ah_imr |= AR5K_IMR_GPIO;
-
-	/* Enable GPIO interrupts */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PIMR, AR5K_IMR_GPIO);
-}
-
-
-
-
-/****************\
-  Misc functions
-\****************/
-
-int ath5k_hw_get_capability(struct ath5k_hw *ah,
-		enum ath5k_capability_type cap_type,
-		u32 capability, u32 *result)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	switch (cap_type) {
-	case AR5K_CAP_NUM_TXQUEUES:
-		if (result) {
-			if (ah->ah_version == AR5K_AR5210)
-				*result = AR5K_NUM_TX_QUEUES_NOQCU;
-			else
-				*result = AR5K_NUM_TX_QUEUES;
-			goto yes;
-		}
-	case AR5K_CAP_VEOL:
-		goto yes;
-	case AR5K_CAP_COMPRESSION:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	case AR5K_CAP_BURST:
-		goto yes;
-	case AR5K_CAP_TPC:
-		goto yes;
-	case AR5K_CAP_BSSIDMASK:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	case AR5K_CAP_XR:
-		if (ah->ah_version == AR5K_AR5212)
-			goto yes;
-		else
-			goto no;
-	default:
-		goto no;
-	}
-
-no:
-	return -EINVAL;
-yes:
-	return 0;
-}
-
-static int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
-		u16 assoc_id)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (ah->ah_version == AR5K_AR5210) {
-		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
-			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return 0;
-	}
-
-	return -EIO;
-}
-
-static int ath5k_hw_disable_pspoll(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-
-	if (ah->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
-			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return 0;
-	}
-
-	return -EIO;
-}
diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
deleted file mode 100644
index 64fca8d..0000000
--- a/drivers/net/wireless/ath5k/hw.h
+++ /dev/null
@@ -1,616 +0,0 @@
-/*
- * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
- * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
- * Copyright (c) 2007 Matthew W. S. Bell  <mentor@madwifi.org>
- * Copyright (c) 2007 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
- *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/delay.h>
-
-/*
- * Gain settings
- */
-
-enum ath5k_rfgain {
-	AR5K_RFGAIN_INACTIVE = 0,
-	AR5K_RFGAIN_READ_REQUESTED,
-	AR5K_RFGAIN_NEED_CHANGE,
-};
-
-#define AR5K_GAIN_CRN_FIX_BITS_5111		4
-#define AR5K_GAIN_CRN_FIX_BITS_5112		7
-#define AR5K_GAIN_CRN_MAX_FIX_BITS		AR5K_GAIN_CRN_FIX_BITS_5112
-#define AR5K_GAIN_DYN_ADJUST_HI_MARGIN		15
-#define AR5K_GAIN_DYN_ADJUST_LO_MARGIN		20
-#define AR5K_GAIN_CCK_PROBE_CORR		5
-#define AR5K_GAIN_CCK_OFDM_GAIN_DELTA		15
-#define AR5K_GAIN_STEP_COUNT			10
-#define AR5K_GAIN_PARAM_TX_CLIP			0
-#define AR5K_GAIN_PARAM_PD_90			1
-#define AR5K_GAIN_PARAM_PD_84			2
-#define AR5K_GAIN_PARAM_GAIN_SEL		3
-#define AR5K_GAIN_PARAM_MIX_ORN			0
-#define AR5K_GAIN_PARAM_PD_138			1
-#define AR5K_GAIN_PARAM_PD_137			2
-#define AR5K_GAIN_PARAM_PD_136			3
-#define AR5K_GAIN_PARAM_PD_132			4
-#define AR5K_GAIN_PARAM_PD_131			5
-#define AR5K_GAIN_PARAM_PD_130			6
-#define AR5K_GAIN_CHECK_ADJUST(_g) 		\
-	((_g)->g_current <= (_g)->g_low || (_g)->g_current >= (_g)->g_high)
-
-struct ath5k_gain_opt_step {
-	s16				gos_param[AR5K_GAIN_CRN_MAX_FIX_BITS];
-	s32				gos_gain;
-};
-
-struct ath5k_gain {
-	u32			g_step_idx;
-	u32			g_current;
-	u32			g_target;
-	u32			g_low;
-	u32			g_high;
-	u32			g_f_corr;
-	u32			g_active;
-	const struct ath5k_gain_opt_step	*g_step;
-};
-
-
-/*
- * HW SPECIFIC STRUCTS
- */
-
-/* Some EEPROM defines */
-#define AR5K_EEPROM_EEP_SCALE		100
-#define AR5K_EEPROM_EEP_DELTA		10
-#define AR5K_EEPROM_N_MODES		3
-#define AR5K_EEPROM_N_5GHZ_CHAN		10
-#define AR5K_EEPROM_N_2GHZ_CHAN		3
-#define AR5K_EEPROM_MAX_CHAN		10
-#define AR5K_EEPROM_N_PCDAC		11
-#define AR5K_EEPROM_N_TEST_FREQ		8
-#define AR5K_EEPROM_N_EDGES		8
-#define AR5K_EEPROM_N_INTERCEPTS	11
-#define AR5K_EEPROM_FREQ_M(_v)		AR5K_EEPROM_OFF(_v, 0x7f, 0xff)
-#define AR5K_EEPROM_PCDAC_M		0x3f
-#define AR5K_EEPROM_PCDAC_START		1
-#define AR5K_EEPROM_PCDAC_STOP		63
-#define AR5K_EEPROM_PCDAC_STEP		1
-#define AR5K_EEPROM_NON_EDGE_M		0x40
-#define AR5K_EEPROM_CHANNEL_POWER	8
-#define AR5K_EEPROM_N_OBDB		4
-#define AR5K_EEPROM_OBDB_DIS		0xffff
-#define AR5K_EEPROM_CHANNEL_DIS		0xff
-#define AR5K_EEPROM_SCALE_OC_DELTA(_x)	(((_x) * 2) / 10)
-#define AR5K_EEPROM_N_CTLS(_v)		AR5K_EEPROM_OFF(_v, 16, 32)
-#define AR5K_EEPROM_MAX_CTLS		32
-#define AR5K_EEPROM_N_XPD_PER_CHANNEL	4
-#define AR5K_EEPROM_N_XPD0_POINTS	4
-#define AR5K_EEPROM_N_XPD3_POINTS	3
-#define AR5K_EEPROM_N_INTERCEPT_10_2GHZ	35
-#define AR5K_EEPROM_N_INTERCEPT_10_5GHZ	55
-#define AR5K_EEPROM_POWER_M		0x3f
-#define AR5K_EEPROM_POWER_MIN		0
-#define AR5K_EEPROM_POWER_MAX		3150
-#define AR5K_EEPROM_POWER_STEP		50
-#define AR5K_EEPROM_POWER_TABLE_SIZE	64
-#define AR5K_EEPROM_N_POWER_LOC_11B	4
-#define AR5K_EEPROM_N_POWER_LOC_11G	6
-#define AR5K_EEPROM_I_GAIN		10
-#define AR5K_EEPROM_CCK_OFDM_DELTA	15
-#define AR5K_EEPROM_N_IQ_CAL		2
-
-/* Struct to hold EEPROM calibration data */
-struct ath5k_eeprom_info {
-	u16	ee_magic;
-	u16	ee_protect;
-	u16	ee_regdomain;
-	u16	ee_version;
-	u16	ee_header;
-	u16	ee_ant_gain;
-	u16	ee_misc0;
-	u16	ee_misc1;
-	u16	ee_cck_ofdm_gain_delta;
-	u16	ee_cck_ofdm_power_delta;
-	u16	ee_scaled_cck_delta;
-
-	/* Used for tx thermal adjustment (eeprom_init, rfregs) */
-	u16	ee_tx_clip;
-	u16	ee_pwd_84;
-	u16	ee_pwd_90;
-	u16	ee_gain_select;
-
-	/* RF Calibration settings (reset, rfregs) */
-	u16	ee_i_cal[AR5K_EEPROM_N_MODES];
-	u16	ee_q_cal[AR5K_EEPROM_N_MODES];
-	u16	ee_fixed_bias[AR5K_EEPROM_N_MODES];
-	u16	ee_turbo_max_power[AR5K_EEPROM_N_MODES];
-	u16	ee_xr_power[AR5K_EEPROM_N_MODES];
-	u16	ee_switch_settling[AR5K_EEPROM_N_MODES];
-	u16	ee_ant_tx_rx[AR5K_EEPROM_N_MODES];
-	u16	ee_ant_control[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_PCDAC];
-	u16	ee_ob[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
-	u16	ee_db[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
-	u16	ee_tx_end2xlna_enable[AR5K_EEPROM_N_MODES];
-	u16	ee_tx_end2xpa_disable[AR5K_EEPROM_N_MODES];
-	u16	ee_tx_frm2xpa_enable[AR5K_EEPROM_N_MODES];
-	u16	ee_thr_62[AR5K_EEPROM_N_MODES];
-	u16	ee_xlna_gain[AR5K_EEPROM_N_MODES];
-	u16	ee_xpd[AR5K_EEPROM_N_MODES];
-	u16	ee_x_gain[AR5K_EEPROM_N_MODES];
-	u16	ee_i_gain[AR5K_EEPROM_N_MODES];
-	u16	ee_margin_tx_rx[AR5K_EEPROM_N_MODES];
-
-	/* Unused */
-	u16	ee_false_detect[AR5K_EEPROM_N_MODES];
-	u16	ee_cal_pier[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_2GHZ_CHAN];
-	u16	ee_channel[AR5K_EEPROM_N_MODES][AR5K_EEPROM_MAX_CHAN]; /*empty*/
-
-	/* Conformance test limits (Unused) */
-	u16	ee_ctls;
-	u16	ee_ctl[AR5K_EEPROM_MAX_CTLS];
-
-	/* Noise Floor Calibration settings */
-	s16	ee_noise_floor_thr[AR5K_EEPROM_N_MODES];
-	s8	ee_adc_desired_size[AR5K_EEPROM_N_MODES];
-	s8	ee_pga_desired_size[AR5K_EEPROM_N_MODES];
-};
-
-/*
- * Internal RX/TX descriptor structures
- * (rX: reserved fields possibily used by future versions of the ar5k chipset)
- */
-
-/*
- * common hardware RX control descriptor
- */
-struct ath5k_hw_rx_ctl {
-	u32	rx_control_0; /* RX control word 0 */
-
-#define AR5K_DESC_RX_CTL0			0x00000000
-
-	u32	rx_control_1; /* RX control word 1 */
-
-#define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff
-#define AR5K_DESC_RX_CTL1_INTREQ		0x00002000
-} __packed;
-
-/*
- * common hardware RX status descriptor
- * 5210/11 and 5212 differ only in the flags defined below
- */
-struct ath5k_hw_rx_status {
-	u32	rx_status_0; /* RX status word 0 */
-	u32	rx_status_1; /* RX status word 1 */
-} __packed;
-
-/* 5210/5211 */
-#define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE_S	15
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	19
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA	0x38000000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	27
-#define AR5K_5210_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN		0x00000008
-#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010
-#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0
-#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR_S		5
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000
-#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
-#define AR5K_5210_RX_DESC_STATUS1_KEY_CACHE_MISS	0x10000000
-
-/* 5212 */
-#define AR5K_5212_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_5212_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE_S	15
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x0ff00000
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	20
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	28
-#define AR5K_5212_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_5212_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008
-#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR		0x00000010
-#define AR5K_5212_RX_DESC_STATUS1_MIC_ERROR		0x00000020
-#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00
-#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
-#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
-#define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000
-
-/*
- * common hardware RX error descriptor
- */
-struct ath5k_hw_rx_error {
-	u32	rx_error_0; /* RX error word 0 */
-
-#define AR5K_RX_DESC_ERROR0			0x00000000
-
-	u32	rx_error_1; /* RX error word 1 */
-
-#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE	0x0000ff00
-#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE_S	8
-} __packed;
-
-#define AR5K_DESC_RX_PHY_ERROR_NONE		0x00
-#define AR5K_DESC_RX_PHY_ERROR_TIMING		0x20
-#define AR5K_DESC_RX_PHY_ERROR_PARITY		0x40
-#define AR5K_DESC_RX_PHY_ERROR_RATE		0x60
-#define AR5K_DESC_RX_PHY_ERROR_LENGTH		0x80
-#define AR5K_DESC_RX_PHY_ERROR_64QAM		0xa0
-#define AR5K_DESC_RX_PHY_ERROR_SERVICE		0xc0
-#define AR5K_DESC_RX_PHY_ERROR_TRANSMITOVR	0xe0
-
-/*
- * 5210/5211 hardware 2-word TX control descriptor
- */
-struct ath5k_hw_2w_tx_ctl {
-	u32	tx_control_0; /* TX control word 0 */
-
-#define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
-#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN		0x0003f000 /*[5210 ?]*/
-#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN_S	12
-#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE		0x003c0000
-#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE_S	18
-#define AR5K_2W_TX_DESC_CTL0_RTSENA		0x00400000
-#define AR5K_2W_TX_DESC_CTL0_CLRDMASK		0x01000000
-#define AR5K_2W_TX_DESC_CTL0_LONG_PACKET	0x00800000 /*[5210]*/
-#define AR5K_2W_TX_DESC_CTL0_VEOL		0x00800000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE		0x1c000000 /*[5210]*/
-#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_S	26
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT	(ah->ah_version == AR5K_AR5210 ? \
-						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210 : \
-						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211)
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
-#define AR5K_2W_TX_DESC_CTL0_INTREQ		0x20000000
-#define AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
-
-	u32	tx_control_1; /* TX control word 1 */
-
-#define AR5K_2W_TX_DESC_CTL1_BUF_LEN		0x00000fff
-#define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210	0x0007e000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211	0x000fe000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	(ah->ah_version == AR5K_AR5210 ? \
-						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210 : \
-						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211)
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
-#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE		0x00700000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_S	20
-#define AR5K_2W_TX_DESC_CTL1_NOACK		0x00800000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL1_RTS_DURATION	0xfff80000 /*[5210 ?]*/
-} __packed;
-
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NORMAL   0x00
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_ATIM     0x04
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PSPOLL   0x08
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY 0x0c
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS     0x10
-
-/*
- * 5212 hardware 4-word TX control descriptor
- */
-struct ath5k_hw_4w_tx_ctl {
-	u32	tx_control_0; /* TX control word 0 */
-
-#define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
-#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER		0x003f0000
-#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER_S	16
-#define AR5K_4W_TX_DESC_CTL0_RTSENA		0x00400000
-#define AR5K_4W_TX_DESC_CTL0_VEOL		0x00800000
-#define AR5K_4W_TX_DESC_CTL0_CLRDMASK		0x01000000
-#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT	0x1e000000
-#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
-#define AR5K_4W_TX_DESC_CTL0_INTREQ		0x20000000
-#define AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
-#define AR5K_4W_TX_DESC_CTL0_CTSENA		0x80000000
-
-	u32	tx_control_1; /* TX control word 1 */
-
-#define AR5K_4W_TX_DESC_CTL1_BUF_LEN		0x00000fff
-#define AR5K_4W_TX_DESC_CTL1_MORE		0x00001000
-#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	0x000fe000
-#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
-#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE		0x00f00000
-#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE_S	20
-#define AR5K_4W_TX_DESC_CTL1_NOACK		0x01000000
-#define AR5K_4W_TX_DESC_CTL1_COMP_PROC		0x06000000
-#define AR5K_4W_TX_DESC_CTL1_COMP_PROC_S	25
-#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN	0x18000000
-#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN_S	27
-#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN	0x60000000
-#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN_S	29
-
-	u32	tx_control_2; /* TX control word 2 */
-
-#define AR5K_4W_TX_DESC_CTL2_RTS_DURATION		0x00007fff
-#define AR5K_4W_TX_DESC_CTL2_DURATION_UPDATE_ENABLE	0x00008000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0		0x000f0000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0_S		16
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1		0x00f00000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1_S		20
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2		0x0f000000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2_S		24
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3		0xf0000000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3_S		28
-
-	u32	tx_control_3; /* TX control word 3 */
-
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE0		0x0000001f
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1		0x000003e0
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1_S	5
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2		0x00007c00
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2_S	10
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3		0x000f8000
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3_S	15
-#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE	0x01f00000
-#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE_S	20
-} __packed;
-
-/*
- * Common TX status descriptor
- */
-struct ath5k_hw_tx_status {
-	u32	tx_status_0; /* TX status word 0 */
-
-#define AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK	0x00000001
-#define AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES	0x00000002
-#define AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN	0x00000004
-#define AR5K_DESC_TX_STATUS0_FILTERED		0x00000008
-/*???
-#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT	0x000000f0
-#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT_S	4
-*/
-#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT	0x000000f0
-#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT_S	4
-/*???
-#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT	0x00000f00
-#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT_S	8
-*/
-#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT	0x00000f00
-#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT_S	8
-#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT	0x0000f000
-#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT_S	12
-#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP	0xffff0000
-#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP_S	16
-
-	u32	tx_status_1; /* TX status word 1 */
-
-#define AR5K_DESC_TX_STATUS1_DONE		0x00000001
-#define AR5K_DESC_TX_STATUS1_SEQ_NUM		0x00001ffe
-#define AR5K_DESC_TX_STATUS1_SEQ_NUM_S		1
-#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH	0x001fe000
-#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH_S	13
-#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX	0x00600000
-#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX_S	21
-#define AR5K_DESC_TX_STATUS1_COMP_SUCCESS	0x00800000
-#define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA	0x01000000
-} __packed;
-
-
-/*
- * 5210/5211 hardware TX descriptor
- */
-struct ath5k_hw_5210_tx_desc {
-	struct ath5k_hw_2w_tx_ctl	tx_ctl;
-	struct ath5k_hw_tx_status	tx_stat;
-} __packed;
-
-/*
- * 5212 hardware TX descriptor
- */
-struct ath5k_hw_5212_tx_desc {
-	struct ath5k_hw_4w_tx_ctl	tx_ctl;
-	struct ath5k_hw_tx_status	tx_stat;
-} __packed;
-
-/*
- * common hardware RX descriptor
- */
-struct ath5k_hw_all_rx_desc {
-	struct ath5k_hw_rx_ctl			rx_ctl;
-	union {
-		struct ath5k_hw_rx_status	rx_stat;
-		struct ath5k_hw_rx_error	rx_err;
-	} u;
-} __packed;
-
-
-/*
- * AR5K REGISTER ACCESS
- */
-
-/*Swap RX/TX Descriptor for big endian archs*/
-#if defined(__BIG_ENDIAN)
-#define AR5K_INIT_CFG	(		\
-	AR5K_CFG_SWTD | AR5K_CFG_SWRD	\
-)
-#else
-#define AR5K_INIT_CFG	0x00000000
-#endif
-
-/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(ah, _reg)
-
-#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(ah, _val, _reg)*/
-
-#define AR5K_REG_SM(_val, _flags)					\
-	(((_val) << _flags##_S) & (_flags))
-
-#define AR5K_REG_MS(_val, _flags)					\
-	(((_val) & (_flags)) >> _flags##_S)
-
-/* Some registers can hold multiple values of interest. For this
- * reason when we want to write to these registers we must first
- * retrieve the values which we do not want to clear (lets call this
- * old_data) and then set the register with this and our new_value:
- * ( old_data | new_value) */
-#define AR5K_REG_WRITE_BITS(ah, _reg, _flags, _val)			\
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) & ~(_flags)) | \
-	    (((_val) << _flags##_S) & (_flags)), _reg)
-
-#define AR5K_REG_MASKED_BITS(ah, _reg, _flags, _mask)			\
-	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) &		\
-			(_mask)) | (_flags), _reg)
-
-#define AR5K_REG_ENABLE_BITS(ah, _reg, _flags)				\
-	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) | (_flags), _reg)
-
-#define AR5K_REG_DISABLE_BITS(ah, _reg, _flags)			\
-	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) & ~(_flags), _reg)
-
-#define AR5K_PHY_WRITE(ah, _reg, _val)					\
-	ath5k_hw_reg_write(ah, _val, (ah)->ah_phy + ((_reg) << 2))
-
-#define AR5K_PHY_READ(ah, _reg)					\
-	ath5k_hw_reg_read(ah, (ah)->ah_phy + ((_reg) << 2))
-
-#define AR5K_REG_WAIT(_i) do {						\
-	if (_i % 64)							\
-		udelay(1);						\
-} while (0)
-
-#define AR5K_EEPROM_READ(_o, _v) do {					\
-	if ((ret = ath5k_hw_eeprom_read(ah, (_o), &(_v))) != 0)	\
-		return (ret);						\
-} while (0)
-
-#define AR5K_EEPROM_READ_HDR(_o, _v)					\
-	AR5K_EEPROM_READ(_o, ah->ah_capabilities.cap_eeprom._v);	\
-
-/* Read status of selected queue */
-#define AR5K_REG_READ_Q(ah, _reg, _queue)				\
-	(ath5k_hw_reg_read(ah, _reg) & (1 << _queue))			\
-
-#define AR5K_REG_WRITE_Q(ah, _reg, _queue)				\
-	ath5k_hw_reg_write(ah, (1 << _queue), _reg)
-
-#define AR5K_Q_ENABLE_BITS(_reg, _queue) do {				\
-	_reg |= 1 << _queue;						\
-} while (0)
-
-#define AR5K_Q_DISABLE_BITS(_reg, _queue) do {				\
-	_reg &= ~(1 << _queue);						\
-} while (0)
-
-#define AR5K_LOW_ID(_a)(				\
-(_a)[0] | (_a)[1] << 8 | (_a)[2] << 16 | (_a)[3] << 24	\
-)
-
-#define AR5K_HIGH_ID(_a)	((_a)[4] | (_a)[5] << 8)
-
-/*
- * Initial register values
- */
-
-/*
- * Common initial register values
- */
-#define AR5K_INIT_MODE				CHANNEL_B
-
-#define AR5K_INIT_TX_LATENCY			502
-#define AR5K_INIT_USEC				39
-#define AR5K_INIT_USEC_TURBO			79
-#define AR5K_INIT_USEC_32			31
-#define AR5K_INIT_CARR_SENSE_EN			1
-#define AR5K_INIT_PROG_IFS			920
-#define AR5K_INIT_PROG_IFS_TURBO		960
-#define AR5K_INIT_EIFS				3440
-#define AR5K_INIT_EIFS_TURBO			6880
-#define AR5K_INIT_SLOT_TIME			396
-#define AR5K_INIT_SLOT_TIME_TURBO		480
-#define AR5K_INIT_ACK_CTS_TIMEOUT		1024
-#define AR5K_INIT_ACK_CTS_TIMEOUT_TURBO		0x08000800
-#define AR5K_INIT_SIFS				560
-#define AR5K_INIT_SIFS_TURBO			480
-#define AR5K_INIT_SH_RETRY			10
-#define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
-#define AR5K_INIT_SSH_RETRY			32
-#define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
-#define AR5K_INIT_TX_RETRY			10
-#define AR5K_INIT_TOPS				8
-#define AR5K_INIT_RXNOFRM			8
-#define AR5K_INIT_RPGTO				0
-#define AR5K_INIT_TXNOFRM			0
-#define AR5K_INIT_BEACON_PERIOD			65535
-#define AR5K_INIT_TIM_OFFSET			0
-#define AR5K_INIT_BEACON_EN			0
-#define AR5K_INIT_RESET_TSF			0
-
-#define AR5K_INIT_TRANSMIT_LATENCY		(			\
-	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
-	(AR5K_INIT_USEC)						\
-)
-#define AR5K_INIT_TRANSMIT_LATENCY_TURBO	(			\
-	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
-	(AR5K_INIT_USEC_TURBO)						\
-)
-#define AR5K_INIT_PROTO_TIME_CNTRL		(			\
-	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS << 12) |	\
-	(AR5K_INIT_PROG_IFS)						\
-)
-#define AR5K_INIT_PROTO_TIME_CNTRL_TURBO	(			\
-	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS_TURBO << 12) | \
-	(AR5K_INIT_PROG_IFS_TURBO)					\
-)
-#define AR5K_INIT_BEACON_CONTROL		(			\
-	(AR5K_INIT_RESET_TSF << 24) | (AR5K_INIT_BEACON_EN << 23) |	\
-	(AR5K_INIT_TIM_OFFSET << 16) | (AR5K_INIT_BEACON_PERIOD)	\
-)
-
-/*
- * Non-common initial register values which have to be loaded into the
- * card at boot time and after each reset.
- */
-
-/* Register dumps are done per operation mode */
-#define AR5K_INI_RFGAIN_5GHZ		0
-#define AR5K_INI_RFGAIN_2GHZ		1
-
-#define AR5K_INI_VAL_11A		0
-#define AR5K_INI_VAL_11A_TURBO		1
-#define AR5K_INI_VAL_11B		2
-#define AR5K_INI_VAL_11G		3
-#define AR5K_INI_VAL_11G_TURBO		4
-#define AR5K_INI_VAL_XR			0
-#define AR5K_INI_VAL_MAX		5
-
-#define AR5K_RF5111_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
-#define AR5K_RF5112_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
-
-static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
-{
-	u32 retval = 0, bit, i;
-
-	for (i = 0; i < bits; i++) {
-		bit = (val >> i) & 1;
-		retval = (retval << 1) | bit;
-	}
-
-	return retval;
-}
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 2806b21..ea2e1a2 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1,9 +1,9 @@
 /*
  * Initial register settings functions
  *
- * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
- * Copyright (c) 2006, 2007 Nick Kossifidis <mickflemm@gmail.com>
- * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -20,13 +20,9 @@
  */
 
 #include "ath5k.h"
-#include "base.h"
 #include "reg.h"
-
-/*
- * MAC/PHY REGISTERS
- */
-
+#include "debug.h"
+#include "base.h"
 
 /*
  * Mode-independent initial register writes
@@ -65,10 +61,10 @@ static const struct ath5k_ini ar5210_ini[] = {
 	{ AR5K_TXCFG,		AR5K_DMASIZE_128B },
 	{ AR5K_RXCFG,		AR5K_DMASIZE_128B },
 	{ AR5K_CFG,		AR5K_INIT_CFG },
-	{ AR5K_TOPS,		AR5K_INIT_TOPS },
-	{ AR5K_RXNOFRM,		AR5K_INIT_RXNOFRM },
-	{ AR5K_RPGTO,		AR5K_INIT_RPGTO },
-	{ AR5K_TXNOFRM,		AR5K_INIT_TXNOFRM },
+	{ AR5K_TOPS,		8 },
+	{ AR5K_RXNOFRM,		8 },
+	{ AR5K_RPGTO,		0 },
+	{ AR5K_TXNOFRM,		0 },
 	{ AR5K_SFR,		0 },
 	{ AR5K_MIBC,		0 },
 	{ AR5K_MISC,		0 },
diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
new file mode 100644
index 0000000..5a896d1
--- /dev/null
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -0,0 +1,1002 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Matthew W. S. Bell  <mentor@madwifi.org>
+ * Copyright (c) 2007-2008 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
+ * Copyright (c) 2007-2008 Pavel Roskin <proski@gnu.org>
+ * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/*********************************\
+* Protocol Control Unit Functions *
+\*********************************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*******************\
+* Generic functions *
+\*******************/
+
+/**
+ * ath5k_hw_set_opmode - Set PCU operating mode
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Initialize PCU for the various operating modes (AP/STA etc)
+ *
+ * NOTE: ah->ah_op_mode must be set before calling this.
+ */
+int ath5k_hw_set_opmode(struct ath5k_hw *ah)
+{
+	u32 pcu_reg, beacon_reg, low_id, high_id;
+
+	pcu_reg = 0;
+	beacon_reg = 0;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	switch (ah->ah_op_mode) {
+	case IEEE80211_IF_TYPE_IBSS:
+		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
+			(ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_NO_PSPOLL : 0);
+		beacon_reg |= AR5K_BCR_ADHOC;
+		break;
+
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
+			(ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_NO_PSPOLL : 0);
+		beacon_reg |= AR5K_BCR_AP;
+		break;
+
+	case IEEE80211_IF_TYPE_STA:
+		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
+			(ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_PWR_SV : 0);
+	case IEEE80211_IF_TYPE_MNTR:
+		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
+			(ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_NO_PSPOLL : 0);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Set PCU registers
+	 */
+	low_id = AR5K_LOW_ID(ah->ah_sta_id);
+	high_id = AR5K_HIGH_ID(ah->ah_sta_id);
+	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
+
+	/*
+	 * Set Beacon Control Register on 5210
+	 */
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, beacon_reg, AR5K_BCR);
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_update - Update mib counters (mac layer statistics)
+ *
+ * @ah: The &struct ath5k_hw
+ * @stats: The &struct ieee80211_low_level_stats we use to track
+ * statistics on the driver
+ *
+ * Reads MIB counters from PCU and updates sw statistics. Must be
+ * called after a MIB interrupt.
+ */
+void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
+		struct ieee80211_low_level_stats  *stats)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* Read-And-Clear */
+	stats->dot11ACKFailureCount += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
+	stats->dot11RTSFailureCount += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
+	stats->dot11RTSSuccessCount += ath5k_hw_reg_read(ah, AR5K_RTS_OK);
+	stats->dot11FCSErrorCount += ath5k_hw_reg_read(ah, AR5K_FCS_FAIL);
+
+	/* XXX: Should we use this to track beacon count ?
+	 * -we read it anyway to clear the register */
+	ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
+
+	/* Reset profile count registers on 5212*/
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
+	}
+}
+
+/**
+ * ath5k_hw_set_ack_bitrate - set bitrate for ACKs
+ *
+ * @ah: The &struct ath5k_hw
+ * @high: Flag to determine if we want to use high transmition rate
+ * for ACKs or not
+ *
+ * If high flag is set, we tell hw to use a set of control rates based on
+ * the current transmition rate (check out control_rates array inside reset.c).
+ * If not hw just uses the lowest rate available for the current modulation
+ * scheme being used (1Mbit for CCK and 6Mbits for OFDM).
+ */
+void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
+{
+	if (ah->ah_version != AR5K_AR5212)
+		return;
+	else {
+		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
+		if (high)
+			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
+		else
+			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
+	}
+}
+
+
+/******************\
+* ACK/CTS Timeouts *
+\******************/
+
+/**
+ * ath5k_hw_het_ack_timeout - Get ACK timeout from PCU in usec
+ *
+ * @ah: The &struct ath5k_hw
+ */
+unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
+}
+
+/**
+ * ath5k_hw_set_ack_timeout - Set ACK timeout on PCU
+ *
+ * @ah: The &struct ath5k_hw
+ * @timeout: Timeout in usec
+ */
+int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
+			ah->ah_turbo) <= timeout)
+		return -EINVAL;
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
+		ath5k_hw_htoclock(timeout, ah->ah_turbo));
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_get_cts_timeout - Get CTS timeout from PCU in usec
+ *
+ * @ah: The &struct ath5k_hw
+ */
+unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
+}
+
+/**
+ * ath5k_hw_set_cts_timeout - Set CTS timeout on PCU
+ *
+ * @ah: The &struct ath5k_hw
+ * @timeout: Timeout in usec
+ */
+int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
+			ah->ah_turbo) <= timeout)
+		return -EINVAL;
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
+			ath5k_hw_htoclock(timeout, ah->ah_turbo));
+
+	return 0;
+}
+
+
+/****************\
+* BSSID handling *
+\****************/
+
+/**
+ * ath5k_hw_get_lladdr - Get station id
+ *
+ * @ah: The &struct ath5k_hw
+ * @mac: The card's mac address
+ *
+ * Initialize ah->ah_sta_id using the mac address provided
+ * (just a memcpy).
+ *
+ * TODO: Remove it once we merge ath5k_softc and ath5k_hw
+ */
+void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	memcpy(mac, ah->ah_sta_id, ETH_ALEN);
+}
+
+/**
+ * ath5k_hw_set_lladdr - Set station id
+ *
+ * @ah: The &struct ath5k_hw
+ * @mac: The card's mac address
+ *
+ * Set station id on hw using the provided mac address
+ */
+int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
+{
+	u32 low_id, high_id;
+
+	ATH5K_TRACE(ah->ah_sc);
+	/* Set new station ID */
+	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
+
+	low_id = AR5K_LOW_ID(mac);
+	high_id = AR5K_HIGH_ID(mac);
+
+	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah, high_id, AR5K_STA_ID1);
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_set_associd - Set BSSID for association
+ *
+ * @ah: The &struct ath5k_hw
+ * @bssid: BSSID
+ * @assoc_id: Assoc id
+ *
+ * Sets the BSSID which trigers the "SME Join" operation
+ */
+void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
+{
+	u32 low_id, high_id;
+	u16 tim_offset = 0;
+
+	/*
+	 * Set simple BSSID mask on 5212
+	 */
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM1);
+	}
+
+	/*
+	 * Set BSSID which triggers the "SME Join" operation
+	 */
+	low_id = AR5K_LOW_ID(bssid);
+	high_id = AR5K_HIGH_ID(bssid);
+	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
+	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
+				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
+
+	if (assoc_id == 0) {
+		ath5k_hw_disable_pspoll(ah);
+		return;
+	}
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_BEACON, AR5K_BEACON_TIM,
+			tim_offset ? tim_offset + 4 : 0);
+
+	ath5k_hw_enable_pspoll(ah, NULL, 0);
+}
+
+/**
+ * ath5k_hw_set_bssid_mask - filter out bssids we listen
+ *
+ * @ah: the &struct ath5k_hw
+ * @mask: the bssid_mask, a u8 array of size ETH_ALEN
+ *
+ * BSSID masking is a method used by AR5212 and newer hardware to inform PCU
+ * which bits of the interface's MAC address should be looked at when trying
+ * to decide which packets to ACK. In station mode and AP mode with a single
+ * BSS every bit matters since we lock to only one BSS. In AP mode with
+ * multiple BSSes (virtual interfaces) not every bit matters because hw must
+ * accept frames for all BSSes and so we tweak some bits of our mac address
+ * in order to have multiple BSSes.
+ *
+ * NOTE: This is a simple filter and does *not* filter out all
+ * relevant frames. Some frames that are not for us might get ACKed from us
+ * by PCU because they just match the mask.
+ *
+ * When handling multiple BSSes you can get the BSSID mask by computing the
+ * set of  ~ ( MAC XOR BSSID ) for all bssids we handle.
+ *
+ * When you do this you are essentially computing the common bits of all your
+ * BSSes. Later it is assumed the harware will "and" (&) the BSSID mask with
+ * the MAC address to obtain the relevant bits and compare the result with
+ * (frame's BSSID & mask) to see if they match.
+ */
+/*
+ * Simple example: on your card you have have two BSSes you have created with
+ * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
+ * There is another BSSID-03 but you are not part of it. For simplicity's sake,
+ * assuming only 4 bits for a mac address and for BSSIDs you can then have:
+ *
+ *                  \
+ * MAC:                0001 |
+ * BSSID-01:   0100 | --> Belongs to us
+ * BSSID-02:   1001 |
+ *                  /
+ * -------------------
+ * BSSID-03:   0110  | --> External
+ * -------------------
+ *
+ * Our bssid_mask would then be:
+ *
+ *             On loop iteration for BSSID-01:
+ *             ~(0001 ^ 0100)  -> ~(0101)
+ *                             ->   1010
+ *             bssid_mask      =    1010
+ *
+ *             On loop iteration for BSSID-02:
+ *             bssid_mask &= ~(0001   ^   1001)
+ *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
+ *             bssid_mask =   (1010)  & ~(1001)
+ *             bssid_mask =   (1010)  &  (0110)
+ *             bssid_mask =   0010
+ *
+ * A bssid_mask of 0010 means "only pay attention to the second least
+ * significant bit". This is because its the only bit common
+ * amongst the MAC and all BSSIDs we support. To findout what the real
+ * common bit is we can simply "&" the bssid_mask now with any BSSID we have
+ * or our MAC address (we assume the hardware uses the MAC address).
+ *
+ * Now, suppose there's an incoming frame for BSSID-03:
+ *
+ * IFRAME-01:  0110
+ *
+ * An easy eye-inspeciton of this already should tell you that this frame
+ * will not pass our check. This is beacuse the bssid_mask tells the
+ * hardware to only look at the second least significant bit and the
+ * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB
+ * as 1, which does not match 0.
+ *
+ * So with IFRAME-01 we *assume* the hardware will do:
+ *
+ *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
+ *  --> allow = (0010) == 0000 ? 1 : 0;
+ *  --> allow = 0
+ *
+ *  Lets now test a frame that should work:
+ *
+ * IFRAME-02:  0001 (we should allow)
+ *
+ *     allow = (0001 & 1010) == 1010
+ *
+ *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
+ *  --> allow = (0010) == (0010)
+ *  --> allow = 1
+ *
+ * Other examples:
+ *
+ * IFRAME-03:  0100 --> allowed
+ * IFRAME-04:  1001 --> allowed
+ * IFRAME-05:  1101 --> allowed but its not for us!!!
+ *
+ */
+int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
+{
+	u32 low_id, high_id;
+	ATH5K_TRACE(ah->ah_sc);
+
+	if (ah->ah_version == AR5K_AR5212) {
+		low_id = AR5K_LOW_ID(mask);
+		high_id = AR5K_HIGH_ID(mask);
+
+		ath5k_hw_reg_write(ah, low_id, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, high_id, AR5K_BSS_IDM1);
+
+		return 0;
+	}
+
+	return -EIO;
+}
+
+
+/************\
+* RX Control *
+\************/
+
+/**
+ * ath5k_hw_start_rx_pcu - Start RX engine
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Starts RX engine on PCU so that hw can process RXed frames
+ * (ACK etc).
+ *
+ * NOTE: RX DMA should be already enabled using ath5k_hw_start_rx_dma
+ * TODO: Init ANI here
+ */
+void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+}
+
+/**
+ * at5k_hw_stop_rx_pcu - Stop RX engine
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Stops RX engine on PCU
+ *
+ * TODO: Detach ANI here
+ */
+void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+}
+
+/*
+ * Set multicast filter
+ */
+void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	/* Set the multicat filter */
+	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
+	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
+}
+
+/*
+ * Set multicast filter by index
+ */
+int ath5k_hw_set_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
+{
+
+	ATH5K_TRACE(ah->ah_sc);
+	if (index >= 64)
+		return -EINVAL;
+	else if (index >= 32)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER1,
+				(1 << (index - 32)));
+	else
+		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
+
+	return 0;
+}
+
+/*
+ * Clear Multicast filter by index
+ */
+int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
+{
+
+	ATH5K_TRACE(ah->ah_sc);
+	if (index >= 64)
+		return -EINVAL;
+	else if (index >= 32)
+		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER1,
+				(1 << (index - 32)));
+	else
+		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
+
+	return 0;
+}
+
+/**
+ * ath5k_hw_get_rx_filter - Get current rx filter
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Returns the RX filter by reading rx filter and
+ * phy error filter registers. RX filter is used
+ * to set the allowed frame types that PCU will accept
+ * and pass to the driver. For a list of frame types
+ * check out reg.h.
+ */
+u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
+{
+	u32 data, filter = 0;
+
+	ATH5K_TRACE(ah->ah_sc);
+	filter = ath5k_hw_reg_read(ah, AR5K_RX_FILTER);
+
+	/*Radar detection for 5212*/
+	if (ah->ah_version == AR5K_AR5212) {
+		data = ath5k_hw_reg_read(ah, AR5K_PHY_ERR_FIL);
+
+		if (data & AR5K_PHY_ERR_FIL_RADAR)
+			filter |= AR5K_RX_FILTER_RADARERR;
+		if (data & (AR5K_PHY_ERR_FIL_OFDM | AR5K_PHY_ERR_FIL_CCK))
+			filter |= AR5K_RX_FILTER_PHYERR;
+	}
+
+	return filter;
+}
+
+/**
+ * ath5k_hw_set_rx_filter - Set rx filter
+ *
+ * @ah: The &struct ath5k_hw
+ * @filter: RX filter mask (see reg.h)
+ *
+ * Sets RX filter register and also handles PHY error filter
+ * register on 5212 and newer chips so that we have proper PHY
+ * error reporting.
+ */
+void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
+{
+	u32 data = 0;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* Set PHY error filter register on 5212*/
+	if (ah->ah_version == AR5K_AR5212) {
+		if (filter & AR5K_RX_FILTER_RADARERR)
+			data |= AR5K_PHY_ERR_FIL_RADAR;
+		if (filter & AR5K_RX_FILTER_PHYERR)
+			data |= AR5K_PHY_ERR_FIL_OFDM | AR5K_PHY_ERR_FIL_CCK;
+	}
+
+	/*
+	 * The AR5210 uses promiscous mode to detect radar activity
+	 */
+	if (ah->ah_version == AR5K_AR5210 &&
+			(filter & AR5K_RX_FILTER_RADARERR)) {
+		filter &= ~AR5K_RX_FILTER_RADARERR;
+		filter |= AR5K_RX_FILTER_PROM;
+	}
+
+	/*Zero length DMA*/
+	if (data)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_ZLFDMA);
+	else
+		AR5K_REG_DISABLE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_ZLFDMA);
+
+	/*Write RX Filter register*/
+	ath5k_hw_reg_write(ah, filter & 0xff, AR5K_RX_FILTER);
+
+	/*Write PHY error filter register on 5212*/
+	if (ah->ah_version == AR5K_AR5212)
+		ath5k_hw_reg_write(ah, data, AR5K_PHY_ERR_FIL);
+
+}
+
+
+/****************\
+* Beacon control *
+\****************/
+
+/**
+ * ath5k_hw_get_tsf32 - Get a 32bit TSF
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Returns lower 32 bits of current TSF
+ */
+u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	return ath5k_hw_reg_read(ah, AR5K_TSF_L32);
+}
+
+/**
+ * ath5k_hw_get_tsf64 - Get the full 64bit TSF
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Returns the current TSF
+ */
+u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
+{
+	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+	ATH5K_TRACE(ah->ah_sc);
+
+	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
+}
+
+/**
+ * ath5k_hw_reset_tsf - Force a TSF reset
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Forces a TSF reset on PCU
+ */
+void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
+}
+
+/*
+ * Initialize beacon timers
+ */
+void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
+{
+	u32 timer1, timer2, timer3;
+
+	ATH5K_TRACE(ah->ah_sc);
+	/*
+	 * Set the additional timers by mode
+	 */
+	switch (ah->ah_op_mode) {
+	case IEEE80211_IF_TYPE_STA:
+		if (ah->ah_version == AR5K_AR5210) {
+			timer1 = 0xffffffff;
+			timer2 = 0xffffffff;
+		} else {
+			timer1 = 0x0000ffff;
+			timer2 = 0x0007ffff;
+		}
+		break;
+
+	default:
+		timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) << 3;
+		timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) << 3;
+	}
+
+	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
+
+	/*
+	 * Set the beacon register and enable all timers.
+	 * (next beacon, DMA beacon, software beacon, ATIM window time)
+	 */
+	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
+	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
+	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
+	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
+
+	ath5k_hw_reg_write(ah, interval & (AR5K_BEACON_PERIOD |
+			AR5K_BEACON_RESET_TSF | AR5K_BEACON_ENABLE),
+		AR5K_BEACON);
+}
+
+#if 0
+/*
+ * Set beacon timers
+ */
+int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
+		const struct ath5k_beacon_state *state)
+{
+	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
+
+	/*
+	 * TODO: should be changed through *state
+	 * review struct ath5k_beacon_state struct
+	 *
+	 * XXX: These are used for cfp period bellow, are they
+	 * ok ? Is it O.K. for tsf here to be 0 or should we use
+	 * get_tsf ?
+	 */
+	u32 dtim_count = 0; /* XXX */
+	u32 cfp_count = 0; /* XXX */
+	u32 tsf = 0; /* XXX */
+
+	ATH5K_TRACE(ah->ah_sc);
+	/* Return on an invalid beacon state */
+	if (state->bs_interval < 1)
+		return -EINVAL;
+
+	interval = state->bs_interval;
+	dtim = state->bs_dtim_period;
+
+	/*
+	 * PCF support?
+	 */
+	if (state->bs_cfp_period > 0) {
+		/*
+		 * Enable PCF mode and set the CFP
+		 * (Contention Free Period) and timer registers
+		 */
+		cfp_period = state->bs_cfp_period * state->bs_dtim_period *
+			state->bs_interval;
+		next_cfp = (cfp_count * state->bs_dtim_period + dtim_count) *
+			state->bs_interval;
+
+		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
+				AR5K_STA_ID1_DEFAULT_ANTENNA |
+				AR5K_STA_ID1_PCF);
+		ath5k_hw_reg_write(ah, cfp_period, AR5K_CFP_PERIOD);
+		ath5k_hw_reg_write(ah, state->bs_cfp_max_duration,
+				AR5K_CFP_DUR);
+		ath5k_hw_reg_write(ah, (tsf + (next_cfp == 0 ? cfp_period :
+						next_cfp)) << 3, AR5K_TIMER2);
+	} else {
+		/* Disable PCF mode */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
+				AR5K_STA_ID1_DEFAULT_ANTENNA |
+				AR5K_STA_ID1_PCF);
+	}
+
+	/*
+	 * Enable the beacon timer register
+	 */
+	ath5k_hw_reg_write(ah, state->bs_next_beacon, AR5K_TIMER0);
+
+	/*
+	 * Start the beacon timers
+	 */
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_BEACON) &
+		~(AR5K_BEACON_PERIOD | AR5K_BEACON_TIM)) |
+		AR5K_REG_SM(state->bs_tim_offset ? state->bs_tim_offset + 4 : 0,
+		AR5K_BEACON_TIM) | AR5K_REG_SM(state->bs_interval,
+		AR5K_BEACON_PERIOD), AR5K_BEACON);
+
+	/*
+	 * Write new beacon miss threshold, if it appears to be valid
+	 * XXX: Figure out right values for min <= bs_bmiss_threshold <= max
+	 * and return if its not in range. We can test this by reading value and
+	 * setting value to a largest value and seeing which values register.
+	 */
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
+			state->bs_bmiss_threshold);
+
+	/*
+	 * Set sleep control register
+	 * XXX: Didn't find this in 5210 code but since this register
+	 * exists also in ar5k's 5210 headers i leave it as common code.
+	 */
+	AR5K_REG_WRITE_BITS(ah, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
+			(state->bs_sleep_duration - 3) << 3);
+
+	/*
+	 * Set enhanced sleep registers on 5212
+	 */
+	if (ah->ah_version == AR5K_AR5212) {
+		if (state->bs_sleep_duration > state->bs_interval &&
+				roundup(state->bs_sleep_duration, interval) ==
+				state->bs_sleep_duration)
+			interval = state->bs_sleep_duration;
+
+		if (state->bs_sleep_duration > dtim && (dtim == 0 ||
+				roundup(state->bs_sleep_duration, dtim) ==
+				state->bs_sleep_duration))
+			dtim = state->bs_sleep_duration;
+
+		if (interval > dtim)
+			return -EINVAL;
+
+		next_beacon = interval == dtim ? state->bs_next_dtim :
+			state->bs_next_beacon;
+
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM((state->bs_next_dtim - 3) << 3,
+			AR5K_SLEEP0_NEXT_DTIM) |
+			AR5K_REG_SM(10, AR5K_SLEEP0_CABTO) |
+			AR5K_SLEEP0_ENH_SLEEP_EN |
+			AR5K_SLEEP0_ASSUME_DTIM, AR5K_SLEEP0);
+
+		ath5k_hw_reg_write(ah, AR5K_REG_SM((next_beacon - 3) << 3,
+			AR5K_SLEEP1_NEXT_TIM) |
+			AR5K_REG_SM(10, AR5K_SLEEP1_BEACON_TO), AR5K_SLEEP1);
+
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
+			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
+	}
+
+	return 0;
+}
+
+/*
+ * Reset beacon timers
+ */
+void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	/*
+	 * Disable beacon timer
+	 */
+	ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
+
+	/*
+	 * Disable some beacon register values
+	 */
+	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
+			AR5K_STA_ID1_DEFAULT_ANTENNA | AR5K_STA_ID1_PCF);
+	ath5k_hw_reg_write(ah, AR5K_BEACON_PERIOD, AR5K_BEACON);
+}
+
+/*
+ * Wait for beacon queue to finish
+ */
+int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
+{
+	unsigned int i;
+	int ret;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* 5210 doesn't have QCU*/
+	if (ah->ah_version == AR5K_AR5210) {
+		/*
+		 * Wait for beaconn queue to finish by checking
+		 * Control Register and Beacon Status Register.
+		 */
+		for (i = AR5K_TUNE_BEACON_INTERVAL / 2; i > 0; i--) {
+			if (!(ath5k_hw_reg_read(ah, AR5K_BSR) & AR5K_BSR_TXQ1F)
+					||
+			    !(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_BSR_TXQ1F))
+				break;
+			udelay(10);
+		}
+
+		/* Timeout... */
+		if (i <= 0) {
+			/*
+			 * Re-schedule the beacon queue
+			 */
+			ath5k_hw_reg_write(ah, phys_addr, AR5K_NOQCU_TXDP1);
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+					AR5K_BCR);
+
+			return -EIO;
+		}
+		ret = 0;
+	} else {
+	/*5211/5212*/
+		ret = ath5k_hw_register_timeout(ah,
+			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
+			AR5K_QCU_STS_FRMPENDCNT, 0, false);
+
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
+			return -EIO;
+	}
+
+	return ret;
+}
+#endif
+
+
+/*********************\
+* Key table functions *
+\*********************/
+
+/*
+ * Reset a key entry on the table
+ */
+int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
+{
+	unsigned int i;
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
+
+	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
+		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
+
+	/*
+	 * Set NULL encryption on AR5212+
+	 *
+	 * Note: AR5K_KEYTABLE_TYPE -> AR5K_KEYTABLE_OFF(entry, 5)
+	 *       AR5K_KEYTABLE_TYPE_NULL -> 0x00000007
+	 *
+	 * Note2: Windows driver (ndiswrapper) sets this to
+	 *        0x00000714 instead of 0x00000007
+	 */
+	if (ah->ah_version > AR5K_AR5211)
+		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
+				AR5K_KEYTABLE_TYPE(entry));
+
+	return 0;
+}
+
+/*
+ * Check if a table entry is valid
+ */
+int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
+
+	/* Check the validation flag at the end of the entry */
+	return ath5k_hw_reg_read(ah, AR5K_KEYTABLE_MAC1(entry)) &
+		AR5K_KEYTABLE_VALID;
+}
+
+/*
+ * Set a key entry on the table
+ */
+int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
+		const struct ieee80211_key_conf *key, const u8 *mac)
+{
+	unsigned int i;
+	__le32 key_v[5] = {};
+	u32 keytype;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* key->keylen comes in from mac80211 in bytes */
+
+	if (key->keylen > AR5K_KEYTABLE_SIZE / 8)
+		return -EOPNOTSUPP;
+
+	switch (key->keylen) {
+	/* WEP 40-bit   = 40-bit  entered key + 24 bit IV = 64-bit */
+	case 40 / 8:
+		memcpy(&key_v[0], key->key, 5);
+		keytype = AR5K_KEYTABLE_TYPE_40;
+		break;
+
+	/* WEP 104-bit  = 104-bit entered key + 24-bit IV = 128-bit */
+	case 104 / 8:
+		memcpy(&key_v[0], &key->key[0], 6);
+		memcpy(&key_v[2], &key->key[6], 6);
+		memcpy(&key_v[4], &key->key[12], 1);
+		keytype = AR5K_KEYTABLE_TYPE_104;
+		break;
+	/* WEP 128-bit  = 128-bit entered key + 24 bit IV = 152-bit */
+	case 128 / 8:
+		memcpy(&key_v[0], &key->key[0], 6);
+		memcpy(&key_v[2], &key->key[6], 6);
+		memcpy(&key_v[4], &key->key[12], 4);
+		keytype = AR5K_KEYTABLE_TYPE_128;
+		break;
+
+	default:
+		return -EINVAL; /* shouldn't happen */
+	}
+
+	for (i = 0; i < ARRAY_SIZE(key_v); i++)
+		ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
+				AR5K_KEYTABLE_OFF(entry, i));
+
+	ath5k_hw_reg_write(ah, keytype, AR5K_KEYTABLE_TYPE(entry));
+
+	return ath5k_hw_set_key_lladdr(ah, entry, mac);
+}
+
+int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
+{
+	u32 low_id, high_id;
+
+	ATH5K_TRACE(ah->ah_sc);
+	 /* Invalid entry (key table overflow) */
+	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
+
+	/* MAC may be NULL if it's a broadcast key. In this case no need to
+	 * to compute AR5K_LOW_ID and AR5K_HIGH_ID as we already know it. */
+	if (unlikely(mac == NULL)) {
+		low_id = 0xffffffff;
+		high_id = 0xffff | AR5K_KEYTABLE_VALID;
+	} else {
+		low_id = AR5K_LOW_ID(mac);
+		high_id = AR5K_HIGH_ID(mac) | AR5K_KEYTABLE_VALID;
+	}
+
+	ath5k_hw_reg_write(ah, low_id, AR5K_KEYTABLE_MAC0(entry));
+	ath5k_hw_reg_write(ah, high_id, AR5K_KEYTABLE_MAC1(entry));
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index fa0d47f..1ea8ed9 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1,9 +1,9 @@
 /*
  * PHY functions
  *
- * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
- * Copyright (c) 2006, 2007 Nick Kossifidis <mickflemm@gmail.com>
- * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -19,6 +19,8 @@
  *
  */
 
+#define _ATH5K_PHY
+
 #include <linux/delay.h>
 
 #include "ath5k.h"
@@ -2501,3 +2503,5 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power)
 
 	return ath5k_hw_txpower(ah, channel, power);
 }
+
+#undef _ATH5K_PHY
diff --git a/drivers/net/wireless/ath5k/qcu.c b/drivers/net/wireless/ath5k/qcu.c
new file mode 100644
index 0000000..2e20f78
--- /dev/null
+++ b/drivers/net/wireless/ath5k/qcu.c
@@ -0,0 +1,488 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+/********************************************\
+Queue Control Unit, DFS Control Unit Functions
+\********************************************/
+
+#include "ath5k.h"
+#include "reg.h"
+#include "debug.h"
+#include "base.h"
+
+/*
+ * Get properties for a transmit queue
+ */
+int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
+		struct ath5k_txq_info *queue_info)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
+	return 0;
+}
+
+/*
+ * Set properties for a transmit queue
+ */
+int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
+				const struct ath5k_txq_info *queue_info)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return -EIO;
+
+	memcpy(&ah->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
+
+	/*XXX: Is this supported on 5210 ?*/
+	if ((queue_info->tqi_type == AR5K_TX_QUEUE_DATA &&
+			((queue_info->tqi_subtype == AR5K_WME_AC_VI) ||
+			(queue_info->tqi_subtype == AR5K_WME_AC_VO))) ||
+			queue_info->tqi_type == AR5K_TX_QUEUE_UAPSD)
+		ah->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
+
+	return 0;
+}
+
+/*
+ * Initialize a transmit queue
+ */
+int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
+		struct ath5k_txq_info *queue_info)
+{
+	unsigned int queue;
+	int ret;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/*
+	 * Get queue by type
+	 */
+	/*5210 only has 2 queues*/
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (queue_type) {
+		case AR5K_TX_QUEUE_DATA:
+			queue = AR5K_TX_QUEUE_ID_NOQCU_DATA;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+		case AR5K_TX_QUEUE_CAB:
+			queue = AR5K_TX_QUEUE_ID_NOQCU_BEACON;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		switch (queue_type) {
+		case AR5K_TX_QUEUE_DATA:
+			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
+				ah->ah_txq[queue].tqi_type !=
+				AR5K_TX_QUEUE_INACTIVE; queue++) {
+
+				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
+					return -EINVAL;
+			}
+			break;
+		case AR5K_TX_QUEUE_UAPSD:
+			queue = AR5K_TX_QUEUE_ID_UAPSD;
+			break;
+		case AR5K_TX_QUEUE_BEACON:
+			queue = AR5K_TX_QUEUE_ID_BEACON;
+			break;
+		case AR5K_TX_QUEUE_CAB:
+			queue = AR5K_TX_QUEUE_ID_CAB;
+			break;
+		case AR5K_TX_QUEUE_XR_DATA:
+			if (ah->ah_version != AR5K_AR5212)
+				ATH5K_ERR(ah->ah_sc,
+					"XR data queues only supported in"
+					" 5212!\n");
+			queue = AR5K_TX_QUEUE_ID_XR_DATA;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Setup internal queue structure
+	 */
+	memset(&ah->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
+	ah->ah_txq[queue].tqi_type = queue_type;
+
+	if (queue_info != NULL) {
+		queue_info->tqi_type = queue_type;
+		ret = ath5k_hw_set_tx_queueprops(ah, queue, queue_info);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * We use ah_txq_status to hold a temp value for
+	 * the Secondary interrupt mask registers on 5211+
+	 * check out ath5k_hw_reset_tx_queue
+	 */
+	AR5K_Q_ENABLE_BITS(ah->ah_txq_status, queue);
+
+	return queue;
+}
+
+/*
+ * Get number of pending frames
+ * for a specific queue [5211+]
+ */
+u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/* Return if queue is declared inactive */
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return false;
+
+	/* XXX: How about AR5K_CFG_TXCNT ? */
+	if (ah->ah_version == AR5K_AR5210)
+		return false;
+
+	return AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT;
+}
+
+/*
+ * Set a transmit queue inactive
+ */
+void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
+		return;
+
+	/* This queue will be skipped in further operations */
+	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
+	/*For SIMR setup*/
+	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
+}
+
+/*
+ * Set DFS properties for a transmit queue on DCU
+ */
+int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
+{
+	u32 cw_min, cw_max, retry_lg, retry_sh;
+	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
+
+	ATH5K_TRACE(ah->ah_sc);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	tq = &ah->ah_txq[queue];
+
+	if (tq->tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return 0;
+
+	if (ah->ah_version == AR5K_AR5210) {
+		/* Only handle data queues, others will be ignored */
+		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
+			return 0;
+
+		/* Set Slot time */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
+			AR5K_SLOT_TIME);
+		/* Set ACK_CTS timeout */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
+			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
+		/* Set Transmit Latency */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
+			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
+
+		/* Set IFS0 */
+		if (ah->ah_turbo) {
+			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
+				(ah->ah_aifs + tq->tqi_aifs) *
+				AR5K_INIT_SLOT_TIME_TURBO) <<
+				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
+				AR5K_IFS0);
+		} else {
+			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
+				(ah->ah_aifs + tq->tqi_aifs) *
+				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
+				AR5K_INIT_SIFS, AR5K_IFS0);
+		}
+
+		/* Set IFS1 */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
+			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
+		/* Set AR5K_PHY_SETTLING */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
+			| 0x38 :
+			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
+			| 0x1C,
+			AR5K_PHY_SETTLING);
+		/* Set Frame Control Register */
+		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
+			AR5K_PHY_TURBO_SHORT | 0x2020) :
+			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
+			AR5K_PHY_FRAME_CTL_5210);
+	}
+
+	/*
+	 * Calculate cwmin/max by channel mode
+	 */
+	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
+	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
+	ah->ah_aifs = AR5K_TUNE_AIFS;
+	/*XR is only supported on 5212*/
+	if (IS_CHAN_XR(ah->ah_current_channel) &&
+			ah->ah_version == AR5K_AR5212) {
+		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
+		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
+		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
+	/*B mode is not supported on 5210*/
+	} else if (IS_CHAN_B(ah->ah_current_channel) &&
+			ah->ah_version != AR5K_AR5210) {
+		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
+		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
+		ah->ah_aifs = AR5K_TUNE_AIFS_11B;
+	}
+
+	cw_min = 1;
+	while (cw_min < ah->ah_cw_min)
+		cw_min = (cw_min << 1) | 1;
+
+	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
+		((cw_min << tq->tqi_cw_min) + (1 << tq->tqi_cw_min) - 1);
+	cw_max = tq->tqi_cw_max < 0 ? (cw_max >> (-tq->tqi_cw_max)) :
+		((cw_max << tq->tqi_cw_max) + (1 << tq->tqi_cw_max) - 1);
+
+	/*
+	 * Calculate and set retry limits
+	 */
+	if (ah->ah_software_retry) {
+		/* XXX Need to test this */
+		retry_lg = ah->ah_limit_tx_retries;
+		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
+			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
+	} else {
+		retry_lg = AR5K_INIT_LG_RETRY;
+		retry_sh = AR5K_INIT_SH_RETRY;
+	}
+
+	/*No QCU/DCU [5210]*/
+	if (ah->ah_version == AR5K_AR5210) {
+		ath5k_hw_reg_write(ah,
+			(cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
+			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
+				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
+			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
+				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
+			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
+			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
+			AR5K_NODCU_RETRY_LMT);
+	} else {
+		/*QCU/DCU [5211+]*/
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
+				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
+			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
+				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
+			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
+			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
+			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
+
+	/*===Rest is also for QCU/DCU only [5211+]===*/
+
+		/*
+		 * Set initial content window (cw_min/cw_max)
+		 * and arbitrated interframe space (aifs)...
+		 */
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM(cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
+			AR5K_REG_SM(cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
+			AR5K_REG_SM(ah->ah_aifs + tq->tqi_aifs,
+				AR5K_DCU_LCL_IFS_AIFS),
+			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
+
+		/*
+		 * Set misc registers
+		 */
+		ath5k_hw_reg_write(ah, AR5K_QCU_MISC_DCU_EARLY,
+			AR5K_QUEUE_MISC(queue));
+
+		if (tq->tqi_cbr_period) {
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_cbr_period,
+				AR5K_QCU_CBRCFG_INTVAL) |
+				AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
+				AR5K_QCU_CBRCFG_ORN_THRES),
+				AR5K_QUEUE_CBRCFG(queue));
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+				AR5K_QCU_MISC_FRSHED_CBR);
+			if (tq->tqi_cbr_overflow_limit)
+				AR5K_REG_ENABLE_BITS(ah,
+					AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_CBR_THRES_ENABLE);
+		}
+
+		if (tq->tqi_ready_time)
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
+				AR5K_QCU_RDYTIMECFG_INTVAL) |
+				AR5K_QCU_RDYTIMECFG_ENABLE,
+				AR5K_QUEUE_RDYTIMECFG(queue));
+
+		if (tq->tqi_burst_time) {
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_burst_time,
+				AR5K_DCU_CHAN_TIME_DUR) |
+				AR5K_DCU_CHAN_TIME_ENABLE,
+				AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
+
+			if (tq->tqi_flags
+			& AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
+				AR5K_REG_ENABLE_BITS(ah,
+					AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_RDY_VEOL_POLICY);
+		}
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
+			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
+				AR5K_QUEUE_DFS_MISC(queue));
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
+			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_BACKOFF_FRAG,
+				AR5K_QUEUE_DFS_MISC(queue));
+
+		/*
+		 * Set registers by queue type
+		 */
+		switch (tq->tqi_type) {
+		case AR5K_TX_QUEUE_BEACON:
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
+				AR5K_QCU_MISC_CBREXP_BCN |
+				AR5K_QCU_MISC_BCN_ENABLE);
+
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
+				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
+				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
+				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
+				AR5K_DCU_MISC_BCN_ENABLE);
+
+			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
+				(AR5K_TUNE_SW_BEACON_RESP -
+				AR5K_TUNE_DMA_BEACON_RESP) -
+				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
+				AR5K_QCU_RDYTIMECFG_ENABLE,
+				AR5K_QUEUE_RDYTIMECFG(queue));
+			break;
+
+		case AR5K_TX_QUEUE_CAB:
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
+				AR5K_QCU_MISC_CBREXP |
+				AR5K_QCU_MISC_CBREXP_BCN);
+
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
+				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
+				AR5K_DCU_MISC_ARBLOCK_CTL_S));
+			break;
+
+		case AR5K_TX_QUEUE_UAPSD:
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+				AR5K_QCU_MISC_CBREXP);
+			break;
+
+		case AR5K_TX_QUEUE_DATA:
+		default:
+			break;
+		}
+
+		/*
+		 * Enable interrupts for this tx queue
+		 * in the secondary interrupt mask registers
+		 */
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXOKINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txok, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXERRINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txerr, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXURNINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txurn, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXDESCINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txdesc, queue);
+
+		if (tq->tqi_flags & AR5K_TXQ_FLAG_TXEOLINT_ENABLE)
+			AR5K_Q_ENABLE_BITS(ah->ah_txq_imr_txeol, queue);
+
+
+		/* Update secondary interrupt mask registers */
+		ah->ah_txq_imr_txok &= ah->ah_txq_status;
+		ah->ah_txq_imr_txerr &= ah->ah_txq_status;
+		ah->ah_txq_imr_txurn &= ah->ah_txq_status;
+		ah->ah_txq_imr_txdesc &= ah->ah_txq_status;
+		ah->ah_txq_imr_txeol &= ah->ah_txq_status;
+
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txok,
+			AR5K_SIMR0_QCU_TXOK) |
+			AR5K_REG_SM(ah->ah_txq_imr_txdesc,
+			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txerr,
+			AR5K_SIMR1_QCU_TXERR) |
+			AR5K_REG_SM(ah->ah_txq_imr_txeol,
+			AR5K_SIMR1_QCU_TXEOL), AR5K_SIMR1);
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_imr_txurn,
+			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
+	}
+
+	return 0;
+}
+
+/*
+ * Get slot time from DCU
+ */
+unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (ah->ah_version == AR5K_AR5210)
+		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
+				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
+	else
+		return ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
+}
+
+/*
+ * Set slot time on DCU
+ */
+int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
+{
+	ATH5K_TRACE(ah->ah_sc);
+	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
+		return -EINVAL;
+
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time,
+				ah->ah_turbo), AR5K_SLOT_TIME);
+	else
+		ath5k_hw_reg_write(ah, slot_time, AR5K_DCU_GBL_IFS_SLOT);
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 7562bf1..5b94663 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1,7 +1,7 @@
 /*
- * Copyright (c) 2007 Nick Kossifidis <mickflemm@gmail.com>
- * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
- * Copyright (c) 2007 Michael Taylor <mike.taylor@apprion.com>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2007-2008 Michael Taylor <mike.taylor@apprion.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -977,98 +977,6 @@
 #define AR5K_EEPROM_BASE	0x6000
 
 /*
- * Common ar5xxx EEPROM data offsets (set these on AR5K_EEPROM_BASE)
- */
-#define AR5K_EEPROM_MAGIC		0x003d	/* EEPROM Magic number */
-#define AR5K_EEPROM_MAGIC_VALUE		0x5aa5	/* Default - found on EEPROM */
-#define AR5K_EEPROM_MAGIC_5212		0x0000145c /* 5212 */
-#define AR5K_EEPROM_MAGIC_5211		0x0000145b /* 5211 */
-#define AR5K_EEPROM_MAGIC_5210		0x0000145a /* 5210 */
-
-#define AR5K_EEPROM_PROTECT		0x003f	/* EEPROM protect status */
-#define AR5K_EEPROM_PROTECT_RD_0_31	0x0001	/* Read protection bit for offsets 0x0 - 0x1f */
-#define AR5K_EEPROM_PROTECT_WR_0_31	0x0002	/* Write protection bit for offsets 0x0 - 0x1f */
-#define AR5K_EEPROM_PROTECT_RD_32_63	0x0004	/* 0x20 - 0x3f */
-#define AR5K_EEPROM_PROTECT_WR_32_63	0x0008
-#define AR5K_EEPROM_PROTECT_RD_64_127	0x0010	/* 0x40 - 0x7f */
-#define AR5K_EEPROM_PROTECT_WR_64_127	0x0020
-#define AR5K_EEPROM_PROTECT_RD_128_191	0x0040	/* 0x80 - 0xbf (regdom) */
-#define AR5K_EEPROM_PROTECT_WR_128_191	0x0080
-#define AR5K_EEPROM_PROTECT_RD_192_207	0x0100	/* 0xc0 - 0xcf */
-#define AR5K_EEPROM_PROTECT_WR_192_207	0x0200
-#define AR5K_EEPROM_PROTECT_RD_208_223	0x0400	/* 0xd0 - 0xdf */
-#define AR5K_EEPROM_PROTECT_WR_208_223	0x0800
-#define AR5K_EEPROM_PROTECT_RD_224_239	0x1000	/* 0xe0 - 0xef */
-#define AR5K_EEPROM_PROTECT_WR_224_239	0x2000
-#define AR5K_EEPROM_PROTECT_RD_240_255	0x4000	/* 0xf0 - 0xff */
-#define AR5K_EEPROM_PROTECT_WR_240_255	0x8000
-#define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
-#define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
-#define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)
-#define AR5K_EEPROM_INFO_CKSUM		0xffff
-#define AR5K_EEPROM_INFO(_n)		(AR5K_EEPROM_INFO_BASE + (_n))
-
-#define AR5K_EEPROM_VERSION		AR5K_EEPROM_INFO(1)	/* EEPROM Version */
-#define AR5K_EEPROM_VERSION_3_0		0x3000	/* No idea what's going on before this version */
-#define AR5K_EEPROM_VERSION_3_1		0x3001	/* ob/db values for 2Ghz (ar5211_rfregs) */
-#define AR5K_EEPROM_VERSION_3_2		0x3002	/* different frequency representation (eeprom_bin2freq) */
-#define AR5K_EEPROM_VERSION_3_3		0x3003	/* offsets changed, has 32 CTLs (see below) and ee_false_detect (eeprom_read_modes) */
-#define AR5K_EEPROM_VERSION_3_4		0x3004	/* has ee_i_gain ee_cck_ofdm_power_delta (eeprom_read_modes) */
-#define AR5K_EEPROM_VERSION_4_0		0x4000	/* has ee_misc*, ee_cal_pier, ee_turbo_max_power and ee_xr_power (eeprom_init) */
-#define AR5K_EEPROM_VERSION_4_1		0x4001	/* has ee_margin_tx_rx (eeprom_init) */
-#define AR5K_EEPROM_VERSION_4_2		0x4002	/* has ee_cck_ofdm_gain_delta (eeprom_init) */
-#define AR5K_EEPROM_VERSION_4_3		0x4003
-#define AR5K_EEPROM_VERSION_4_4		0x4004
-#define AR5K_EEPROM_VERSION_4_5		0x4005
-#define AR5K_EEPROM_VERSION_4_6		0x4006	/* has ee_scaled_cck_delta */
-#define AR5K_EEPROM_VERSION_4_7		0x4007
-
-#define AR5K_EEPROM_MODE_11A		0
-#define AR5K_EEPROM_MODE_11B		1
-#define AR5K_EEPROM_MODE_11G		2
-
-#define AR5K_EEPROM_HDR			AR5K_EEPROM_INFO(2)	/* Header that contains the device caps */
-#define AR5K_EEPROM_HDR_11A(_v)		(((_v) >> AR5K_EEPROM_MODE_11A) & 0x1)
-#define AR5K_EEPROM_HDR_11B(_v)		(((_v) >> AR5K_EEPROM_MODE_11B) & 0x1)
-#define AR5K_EEPROM_HDR_11G(_v)		(((_v) >> AR5K_EEPROM_MODE_11G) & 0x1)
-#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz (?) */
-#define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for a/XR mode (eeprom_init) */
-#define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)
-#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz (?) */
-#define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
-
-#define AR5K_EEPROM_RFKILL_GPIO_SEL	0x0000001c
-#define AR5K_EEPROM_RFKILL_GPIO_SEL_S	2
-#define AR5K_EEPROM_RFKILL_POLARITY	0x00000002
-#define AR5K_EEPROM_RFKILL_POLARITY_S	1
-
-/* Newer EEPROMs are using a different offset */
-#define AR5K_EEPROM_OFF(_v, _v3_0, _v3_3) \
-	(((_v) >= AR5K_EEPROM_VERSION_3_3) ? _v3_3 : _v3_0)
-
-#define AR5K_EEPROM_ANT_GAIN(_v)	AR5K_EEPROM_OFF(_v, 0x00c4, 0x00c3)
-#define AR5K_EEPROM_ANT_GAIN_5GHZ(_v)	((int8_t)(((_v) >> 8) & 0xff))
-#define AR5K_EEPROM_ANT_GAIN_2GHZ(_v)	((int8_t)((_v) & 0xff))
-
-/* calibration settings */
-#define AR5K_EEPROM_MODES_11A(_v)	AR5K_EEPROM_OFF(_v, 0x00c5, 0x00d4)
-#define AR5K_EEPROM_MODES_11B(_v)	AR5K_EEPROM_OFF(_v, 0x00d0, 0x00f2)
-#define AR5K_EEPROM_MODES_11G(_v)	AR5K_EEPROM_OFF(_v, 0x00da, 0x010d)
-#define AR5K_EEPROM_CTL(_v)		AR5K_EEPROM_OFF(_v, 0x00e4, 0x0128)	/* Conformance test limits */
-
-/* [3.1 - 3.3] */
-#define AR5K_EEPROM_OBDB0_2GHZ		0x00ec
-#define AR5K_EEPROM_OBDB1_2GHZ		0x00ed
-
-/* Misc values available since EEPROM 4.0 */
-#define AR5K_EEPROM_MISC0		0x00c4
-#define AR5K_EEPROM_EARSTART(_v)	((_v) & 0xfff)
-#define AR5K_EEPROM_EEMAP(_v)		(((_v) >> 14) & 0x3)
-#define AR5K_EEPROM_MISC1		0x00c5
-#define AR5K_EEPROM_TARGET_PWRSTART(_v)	((_v) & 0xfff)
-#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)	(((_v) >> 14) & 0x1)
-
-/*
  * EEPROM data register
  */
 #define AR5K_EEPROM_DATA_5211	0x6004
@@ -1950,13 +1858,13 @@
 #define	AR5K_PHY_GAIN_OFFSET_RXTX_FLAG	0x00020000	/* RX-TX flag (?) */
 
 /*
- * Desired size register
+ * Desired ADC/PGA size register
  * (for more infos read ANI patent)
  */
 #define AR5K_PHY_DESIRED_SIZE		0x9850			/* Register Address */
 #define	AR5K_PHY_DESIRED_SIZE_ADC	0x000000ff	/* Mask for ADC desired size */
 #define	AR5K_PHY_DESIRED_SIZE_PGA	0x0000ff00	/* Mask for PGA desired size */
-#define	AR5K_PHY_DESIRED_SIZE_TOT	0x0ff00000	/* Mask for Total desired size (?) */
+#define	AR5K_PHY_DESIRED_SIZE_TOT	0x0ff00000	/* Mask for Total desired size */
 
 /*
  * PHY signal register
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
new file mode 100644
index 0000000..d260fba
--- /dev/null
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -0,0 +1,925 @@
+/*
+ * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007-2008 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
+ * Copyright (c) 2007-2008 Pavel Roskin <proski@gnu.org>
+ * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
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
+ *
+ */
+
+#define _ATH5K_RESET
+
+/*****************************\
+  Reset functions and helpers
+\*****************************/
+
+#include <linux/pci.h>
+#include "ath5k.h"
+#include "reg.h"
+#include "base.h"
+#include "debug.h"
+
+/**
+ * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
+ *
+ * @ah: the &struct ath5k_hw
+ * @channel: the currently set channel upon reset
+ *
+ * Write the OFDM timings for the AR5212 upon reset. This is a helper for
+ * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
+ * depending on the bandwidth of the channel.
+ *
+ */
+static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
+	struct ieee80211_channel *channel)
+{
+	/* Get exponent and mantissa and set it */
+	u32 coef_scaled, coef_exp, coef_man,
+		ds_coef_exp, ds_coef_man, clock;
+
+	if (!(ah->ah_version == AR5K_AR5212) ||
+		!(channel->hw_value & CHANNEL_OFDM))
+		BUG();
+
+	/* Seems there are two PLLs, one for baseband sampling and one
+	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
+	 * turbo. */
+	clock = channel->hw_value & CHANNEL_TURBO ? 80 : 40;
+	coef_scaled = ((5 * (clock << 24)) / 2) /
+	channel->center_freq;
+
+	for (coef_exp = 31; coef_exp > 0; coef_exp--)
+		if ((coef_scaled >> coef_exp) & 0x1)
+			break;
+
+	if (!coef_exp)
+		return -EINVAL;
+
+	coef_exp = 14 - (coef_exp - 24);
+	coef_man = coef_scaled +
+		(1 << (24 - coef_exp - 1));
+	ds_coef_man = coef_man >> (24 - coef_exp);
+	ds_coef_exp = coef_exp - 16;
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
+
+	return 0;
+}
+
+
+/*
+ * index into rates for control rates, we can set it up like this because
+ * this is only used for AR5212 and we know it supports G mode
+ */
+static int control_rates[] =
+	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
+
+/**
+ * ath5k_hw_write_rate_duration - set rate duration during hw resets
+ *
+ * @ah: the &struct ath5k_hw
+ * @mode: one of enum ath5k_driver_mode
+ *
+ * Write the rate duration table upon hw reset. This is a helper for
+ * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout for
+ * the hardware for the current mode for each rate. The rates which are capable
+ * of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have another
+ * register for the short preamble ACK timeout calculation.
+ */
+static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
+       unsigned int mode)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	struct ieee80211_rate *rate;
+	unsigned int i;
+
+	/* Write rate duration table */
+	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
+		u32 reg;
+		u16 tx_time;
+
+		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
+
+		/* Set ACK timeout */
+		reg = AR5K_RATE_DUR(rate->hw_value);
+
+		/* An ACK frame consists of 10 bytes. If you add the FCS,
+		 * which ieee80211_generic_frame_duration() adds,
+		 * its 14 bytes. Note we use the control rate and not the
+		 * actual rate for this rate. See mac80211 tx.c
+		 * ieee80211_duration() for a brief description of
+		 * what rate we should choose to TX ACKs. */
+		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
+							sc->vif, 10, rate));
+
+		ath5k_hw_reg_write(ah, tx_time, reg);
+
+		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
+			continue;
+
+		/*
+		 * We're not distinguishing short preamble here,
+		 * This is true, all we'll get is a longer value here
+		 * which is not necessarilly bad. We could use
+		 * export ieee80211_frame_duration() but that needs to be
+		 * fixed first to be properly used by mac802111 drivers:
+		 *
+		 *  - remove erp stuff and let the routine figure ofdm
+		 *    erp rates
+		 *  - remove passing argument ieee80211_local as
+		 *    drivers don't have access to it
+		 *  - move drivers using ieee80211_generic_frame_duration()
+		 *    to this
+		 */
+		ath5k_hw_reg_write(ah, tx_time,
+			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
+	}
+}
+
+/*
+ * Reset chipset
+ */
+static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
+{
+	int ret;
+	u32 mask = val ? val : ~0U;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* Read-and-clear RX Descriptor Pointer*/
+	ath5k_hw_reg_read(ah, AR5K_RXDP);
+
+	/*
+	 * Reset the device and wait until success
+	 */
+	ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
+
+	/* Wait at least 128 PCI clocks */
+	udelay(15);
+
+	if (ah->ah_version == AR5K_AR5210) {
+		val &= AR5K_RESET_CTL_CHIP;
+		mask &= AR5K_RESET_CTL_CHIP;
+	} else {
+		val &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
+		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
+	}
+
+	ret = ath5k_hw_register_timeout(ah, AR5K_RESET_CTL, mask, val, false);
+
+	/*
+	 * Reset configuration register (for hw byte-swap). Note that this
+	 * is only set for big endian. We do the necessary magic in
+	 * AR5K_INIT_CFG.
+	 */
+	if ((val & AR5K_RESET_CTL_PCU) == 0)
+		ath5k_hw_reg_write(ah, AR5K_INIT_CFG, AR5K_CFG);
+
+	return ret;
+}
+
+/*
+ * Sleep control
+ */
+int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
+		bool set_chip, u16 sleep_duration)
+{
+	unsigned int i;
+	u32 staid, data;
+
+	ATH5K_TRACE(ah->ah_sc);
+	staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
+
+	switch (mode) {
+	case AR5K_PM_AUTO:
+		staid &= ~AR5K_STA_ID1_DEFAULT_ANTENNA;
+		/* fallthrough */
+	case AR5K_PM_NETWORK_SLEEP:
+		if (set_chip)
+			ath5k_hw_reg_write(ah,
+				AR5K_SLEEP_CTL_SLE_ALLOW |
+				sleep_duration,
+				AR5K_SLEEP_CTL);
+
+		staid |= AR5K_STA_ID1_PWR_SV;
+		break;
+
+	case AR5K_PM_FULL_SLEEP:
+		if (set_chip)
+			ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_SLP,
+				AR5K_SLEEP_CTL);
+
+		staid |= AR5K_STA_ID1_PWR_SV;
+		break;
+
+	case AR5K_PM_AWAKE:
+
+		staid &= ~AR5K_STA_ID1_PWR_SV;
+
+		if (!set_chip)
+			goto commit;
+
+		/* Preserve sleep duration */
+		data = ath5k_hw_reg_read(ah, AR5K_SLEEP_CTL);
+		if (data & 0xffc00000)
+			data = 0;
+		else
+			data = data & 0xfffcffff;
+
+		ath5k_hw_reg_write(ah, data, AR5K_SLEEP_CTL);
+		udelay(15);
+
+		for (i = 50; i > 0; i--) {
+			/* Check if the chip did wake up */
+			if ((ath5k_hw_reg_read(ah, AR5K_PCICFG) &
+					AR5K_PCICFG_SPWR_DN) == 0)
+				break;
+
+			/* Wait a bit and retry */
+			udelay(200);
+			ath5k_hw_reg_write(ah, data, AR5K_SLEEP_CTL);
+		}
+
+		/* Fail if the chip didn't wake up */
+		if (i <= 0)
+			return -EIO;
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+commit:
+	ah->ah_power_mode = mode;
+	ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);
+
+	return 0;
+}
+
+/*
+ * Bring up MAC + PHY Chips
+ */
+int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
+{
+	struct pci_dev *pdev = ah->ah_sc->pdev;
+	u32 turbo, mode, clock, bus_flags;
+	int ret;
+
+	turbo = 0;
+	mode = 0;
+	clock = 0;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	/* Wakeup the device */
+	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
+		return ret;
+	}
+
+	if (ah->ah_version != AR5K_AR5210) {
+		/*
+		 * Get channel mode flags
+		 */
+
+		if (ah->ah_radio >= AR5K_RF5112) {
+			mode = AR5K_PHY_MODE_RAD_RF5112;
+			clock = AR5K_PHY_PLL_RF5112;
+		} else {
+			mode = AR5K_PHY_MODE_RAD_RF5111;	/*Zero*/
+			clock = AR5K_PHY_PLL_RF5111;		/*Zero*/
+		}
+
+		if (flags & CHANNEL_2GHZ) {
+			mode |= AR5K_PHY_MODE_FREQ_2GHZ;
+			clock |= AR5K_PHY_PLL_44MHZ;
+
+			if (flags & CHANNEL_CCK) {
+				mode |= AR5K_PHY_MODE_MOD_CCK;
+			} else if (flags & CHANNEL_OFDM) {
+				/* XXX Dynamic OFDM/CCK is not supported by the
+				 * AR5211 so we set MOD_OFDM for plain g (no
+				 * CCK headers) operation. We need to test
+				 * this, 5211 might support ofdm-only g after
+				 * all, there are also initial register values
+				 * in the code for g mode (see initvals.c). */
+				if (ah->ah_version == AR5K_AR5211)
+					mode |= AR5K_PHY_MODE_MOD_OFDM;
+				else
+					mode |= AR5K_PHY_MODE_MOD_DYN;
+			} else {
+				ATH5K_ERR(ah->ah_sc,
+					"invalid radio modulation mode\n");
+				return -EINVAL;
+			}
+		} else if (flags & CHANNEL_5GHZ) {
+			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
+			clock |= AR5K_PHY_PLL_40MHZ;
+
+			if (flags & CHANNEL_OFDM)
+				mode |= AR5K_PHY_MODE_MOD_OFDM;
+			else {
+				ATH5K_ERR(ah->ah_sc,
+					"invalid radio modulation mode\n");
+				return -EINVAL;
+			}
+		} else {
+			ATH5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
+			return -EINVAL;
+		}
+
+		if (flags & CHANNEL_TURBO)
+			turbo = AR5K_PHY_TURBO_MODE | AR5K_PHY_TURBO_SHORT;
+	} else { /* Reset the device */
+
+		/* ...enable Atheros turbo mode if requested */
+		if (flags & CHANNEL_TURBO)
+			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
+					AR5K_PHY_TURBO);
+	}
+
+	/* reseting PCI on PCI-E cards results card to hang
+	 * and always return 0xffff... so we ingore that flag
+	 * for PCI-E cards */
+	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+
+	/* Reset chipset */
+	ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
+		AR5K_RESET_CTL_BASEBAND | bus_flags);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip\n");
+		return -EIO;
+	}
+
+	if (ah->ah_version == AR5K_AR5210)
+		udelay(2300);
+
+	/* ...wakeup again!*/
+	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
+		return ret;
+	}
+
+	/* ...final warm reset */
+	if (ath5k_hw_nic_reset(ah, 0)) {
+		ATH5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
+		return -EIO;
+	}
+
+	if (ah->ah_version != AR5K_AR5210) {
+		/* ...set the PHY operating mode */
+		ath5k_hw_reg_write(ah, clock, AR5K_PHY_PLL);
+		udelay(300);
+
+		ath5k_hw_reg_write(ah, mode, AR5K_PHY_MODE);
+		ath5k_hw_reg_write(ah, turbo, AR5K_PHY_TURBO);
+	}
+
+	return 0;
+}
+
+/*
+ * Main reset function
+ */
+int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
+	struct ieee80211_channel *channel, bool change_channel)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct pci_dev *pdev = ah->ah_sc->pdev;
+	u32 data, s_seq, s_ant, s_led[3], dma_size;
+	unsigned int i, mode, freq, ee_mode, ant[2];
+	int ret;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	s_seq = 0;
+	s_ant = 0;
+	ee_mode = 0;
+	freq = 0;
+	mode = 0;
+
+	/*
+	 * Save some registers before a reset
+	 */
+	/*DCU/Antenna selection not available on 5210*/
+	if (ah->ah_version != AR5K_AR5210) {
+		if (change_channel) {
+			/* Seq number for queue 0 -do this for all queues ? */
+			s_seq = ath5k_hw_reg_read(ah,
+					AR5K_QUEUE_DFS_SEQNUM(0));
+			/*Default antenna*/
+			s_ant = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
+		}
+	}
+
+	/*GPIOs*/
+	s_led[0] = ath5k_hw_reg_read(ah, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
+	s_led[1] = ath5k_hw_reg_read(ah, AR5K_GPIOCR);
+	s_led[2] = ath5k_hw_reg_read(ah, AR5K_GPIODO);
+
+	if (change_channel && ah->ah_rf_banks != NULL)
+		ath5k_hw_get_rf_gain(ah);
+
+
+	/*Wakeup the device*/
+	ret = ath5k_hw_nic_wakeup(ah, channel->hw_value, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * Initialize operating mode
+	 */
+	ah->ah_op_mode = op_mode;
+
+	/*
+	 * 5111/5112 Settings
+	 * 5210 only comes with RF5110
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+		if (ah->ah_radio != AR5K_RF5111 &&
+			ah->ah_radio != AR5K_RF5112 &&
+			ah->ah_radio != AR5K_RF5413 &&
+			ah->ah_radio != AR5K_RF2413 &&
+			ah->ah_radio != AR5K_RF2425) {
+			ATH5K_ERR(ah->ah_sc,
+				"invalid phy radio: %u\n", ah->ah_radio);
+			return -EINVAL;
+		}
+
+		switch (channel->hw_value & CHANNEL_MODES) {
+		case CHANNEL_A:
+			mode = AR5K_MODE_11A;
+			freq = AR5K_INI_RFGAIN_5GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11A;
+			break;
+		case CHANNEL_G:
+			mode = AR5K_MODE_11G;
+			freq = AR5K_INI_RFGAIN_2GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11G;
+			break;
+		case CHANNEL_B:
+			mode = AR5K_MODE_11B;
+			freq = AR5K_INI_RFGAIN_2GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11B;
+			break;
+		case CHANNEL_T:
+			mode = AR5K_MODE_11A_TURBO;
+			freq = AR5K_INI_RFGAIN_5GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11A;
+			break;
+		/*Is this ok on 5211 too ?*/
+		case CHANNEL_TG:
+			mode = AR5K_MODE_11G_TURBO;
+			freq = AR5K_INI_RFGAIN_2GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11G;
+			break;
+		case CHANNEL_XR:
+			if (ah->ah_version == AR5K_AR5211) {
+				ATH5K_ERR(ah->ah_sc,
+					"XR mode not available on 5211");
+				return -EINVAL;
+			}
+			mode = AR5K_MODE_XR;
+			freq = AR5K_INI_RFGAIN_5GHZ;
+			ee_mode = AR5K_EEPROM_MODE_11A;
+			break;
+		default:
+			ATH5K_ERR(ah->ah_sc,
+				"invalid channel: %d\n", channel->center_freq);
+			return -EINVAL;
+		}
+
+		/* PHY access enable */
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+
+	}
+
+	ret = ath5k_hw_write_initvals(ah, mode, change_channel);
+	if (ret)
+		return ret;
+
+	/*
+	 * 5211/5212 Specific
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+		/*
+		 * Write initial RF gain settings
+		 * This should work for both 5111/5112
+		 */
+		ret = ath5k_hw_rfgain(ah, freq);
+		if (ret)
+			return ret;
+
+		mdelay(1);
+
+		/*
+		 * Write some more initial register settings
+		 */
+		if (ah->ah_version == AR5K_AR5212) {
+			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
+
+			if (channel->hw_value == CHANNEL_G)
+				if (ah->ah_mac_srev < AR5K_SREV_VER_AR2413)
+					ath5k_hw_reg_write(ah, 0x00f80d80,
+								0x994c);
+				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2424)
+					ath5k_hw_reg_write(ah, 0x00380140,
+								0x994c);
+				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2425)
+					ath5k_hw_reg_write(ah, 0x00fc0ec0,
+								0x994c);
+				else /* 2425 */
+					ath5k_hw_reg_write(ah, 0x00fc0fc0,
+								0x994c);
+			else
+				ath5k_hw_reg_write(ah, 0x00000000, 0x994c);
+
+			/* Some bits are disabled here, we know nothing about
+			 * register 0xa228 yet, most of the times this ends up
+			 * with a value 0x9b5 -haven't seen any dump with
+			 * a different value- */
+			/* Got this from decompiling binary HAL */
+			data = ath5k_hw_reg_read(ah, 0xa228);
+			data &= 0xfffffdff;
+			ath5k_hw_reg_write(ah, data, 0xa228);
+
+			data = ath5k_hw_reg_read(ah, 0xa228);
+			data &= 0xfffe03ff;
+			ath5k_hw_reg_write(ah, data, 0xa228);
+			data = 0;
+
+			/* Just write 0x9b5 ? */
+			/* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
+			ath5k_hw_reg_write(ah, 0x0000000f, AR5K_SEQ_MASK);
+			ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
+			ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
+		}
+
+		/* Fix for first revision of the RF5112 RF chipset */
+		if (ah->ah_radio >= AR5K_RF5112 &&
+				ah->ah_radio_5ghz_revision <
+				AR5K_SREV_RAD_5112A) {
+			ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
+					AR5K_PHY_CCKTXCTL);
+			if (channel->hw_value & CHANNEL_5GHZ)
+				data = 0xffb81020;
+			else
+				data = 0xffb80d20;
+			ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
+			data = 0;
+		}
+
+		/*
+		 * Set TX power (FIXME)
+		 */
+		ret = ath5k_hw_txpower(ah, channel, AR5K_TUNE_DEFAULT_TXPOWER);
+		if (ret)
+			return ret;
+
+		/* Write rate duration table only on AR5212 and if
+		 * virtual interface has already been brought up
+		 * XXX: rethink this after new mode changes to
+		 * mac80211 are integrated */
+		if (ah->ah_version == AR5K_AR5212 &&
+			ah->ah_sc->vif != NULL)
+			ath5k_hw_write_rate_duration(ah, mode);
+
+		/*
+		 * Write RF registers
+		 */
+		ret = ath5k_hw_rfregs(ah, channel, mode);
+		if (ret)
+			return ret;
+
+		/*
+		 * Configure additional registers
+		 */
+
+		/* Write OFDM timings on 5212*/
+		if (ah->ah_version == AR5K_AR5212 &&
+			channel->hw_value & CHANNEL_OFDM) {
+			ret = ath5k_hw_write_ofdm_timings(ah, channel);
+			if (ret)
+				return ret;
+		}
+
+		/*Enable/disable 802.11b mode on 5111
+		(enable 2111 frequency converter + CCK)*/
+		if (ah->ah_radio == AR5K_RF5111) {
+			if (mode == AR5K_MODE_11B)
+				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
+				    AR5K_TXCFG_B_MODE);
+			else
+				AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
+				    AR5K_TXCFG_B_MODE);
+		}
+
+		/*
+		 * Set channel and calibrate the PHY
+		 */
+		ret = ath5k_hw_channel(ah, channel);
+		if (ret)
+			return ret;
+
+		/* Set antenna mode */
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_ANT_CTL,
+			ah->ah_antenna[ee_mode][0], 0xfffffc06);
+
+		/*
+		 * In case a fixed antenna was set as default
+		 * write the same settings on both AR5K_PHY_ANT_SWITCH_TABLE
+		 * registers.
+		 */
+		if (s_ant != 0) {
+			if (s_ant == AR5K_ANT_FIXED_A) /* 1 - Main */
+				ant[0] = ant[1] = AR5K_ANT_FIXED_A;
+			else	/* 2 - Aux */
+				ant[0] = ant[1] = AR5K_ANT_FIXED_B;
+		} else {
+			ant[0] = AR5K_ANT_FIXED_A;
+			ant[1] = AR5K_ANT_FIXED_B;
+		}
+
+		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[0]],
+			AR5K_PHY_ANT_SWITCH_TABLE_0);
+		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[1]],
+			AR5K_PHY_ANT_SWITCH_TABLE_1);
+
+		/* Commit values from EEPROM */
+		if (ah->ah_radio == AR5K_RF5111)
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_FRAME_CTL,
+			    AR5K_PHY_FRAME_CTL_TX_CLIP, ee->ee_tx_clip);
+
+		ath5k_hw_reg_write(ah,
+			AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
+			AR5K_PHY_NFTHRES);
+
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_SETTLING,
+			(ee->ee_switch_settling[ee_mode] << 7) & 0x3f80,
+			0xffffc07f);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_GAIN,
+			(ee->ee_ant_tx_rx[ee_mode] << 12) & 0x3f000,
+			0xfffc0fff);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_DESIRED_SIZE,
+			(ee->ee_adc_desired_size[ee_mode] & 0x00ff) |
+			((ee->ee_pga_desired_size[ee_mode] << 8) & 0xff00),
+			0xffff0000);
+
+		ath5k_hw_reg_write(ah,
+			(ee->ee_tx_end2xpa_disable[ee_mode] << 24) |
+			(ee->ee_tx_end2xpa_disable[ee_mode] << 16) |
+			(ee->ee_tx_frm2xpa_enable[ee_mode] << 8) |
+			(ee->ee_tx_frm2xpa_enable[ee_mode]), AR5K_PHY_RF_CTL4);
+
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_RF_CTL3,
+			ee->ee_tx_end2xlna_enable[ee_mode] << 8, 0xffff00ff);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_NF,
+			(ee->ee_thr_62[ee_mode] << 12) & 0x7f000, 0xfff80fff);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_OFDM_SELFCORR, 4, 0xffffff01);
+
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
+		    AR5K_PHY_IQ_CORR_ENABLE |
+		    (ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
+		    ee->ee_q_cal[ee_mode]);
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN_2GHZ,
+				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
+				ee->ee_margin_tx_rx[ee_mode]);
+
+	} else {
+		mdelay(1);
+		/* Disable phy and wait */
+		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+		mdelay(1);
+	}
+
+	/*
+	 * Restore saved values
+	 */
+	/*DCU/Antenna selection not available on 5210*/
+	if (ah->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
+		ath5k_hw_reg_write(ah, s_ant, AR5K_DEFAULT_ANTENNA);
+	}
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, s_led[0]);
+	ath5k_hw_reg_write(ah, s_led[1], AR5K_GPIOCR);
+	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
+
+	/*
+	 * Misc
+	 */
+	/* XXX: add ah->aid once mac80211 gives this to us */
+	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+
+	ath5k_hw_set_opmode(ah);
+	/*PISR/SISR Not available on 5210*/
+	if (ah->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
+		/* If we later allow tuning for this, store into sc structure */
+		data = AR5K_TUNE_RSSI_THRES |
+			AR5K_TUNE_BMISS_THRES << AR5K_RSSI_THR_BMISS_S;
+		ath5k_hw_reg_write(ah, data, AR5K_RSSI_THR);
+	}
+
+	/*
+	 * Set Rx/Tx DMA Configuration
+	 *
+	 * Set maximum DMA size (512) except for PCI-E cards since
+	 * it causes rx overruns and tx errors (tested on 5424 but since
+	 * rx overruns also occur on 5416/5418 with madwifi we set 128
+	 * for all PCI-E cards to be safe).
+	 *
+	 * In dumps this is 128 for allchips.
+	 *
+	 * XXX: need to check 5210 for this
+	 * TODO: Check out tx triger level, it's always 64 on dumps but I
+	 * guess we can tweak it and see how it goes ;-)
+	 */
+	dma_size = (pdev->is_pcie) ? AR5K_DMASIZE_128B : AR5K_DMASIZE_512B;
+	if (ah->ah_version != AR5K_AR5210) {
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
+			AR5K_TXCFG_SDMAMR, dma_size);
+		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG,
+			AR5K_RXCFG_SDMAMW, dma_size);
+	}
+
+	/*
+	 * Enable the PHY and wait until completion
+	 */
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+
+	/*
+	 * On 5211+ read activation -> rx delay
+	 * and use it.
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+		data = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
+			AR5K_PHY_RX_DELAY_M;
+		data = (channel->hw_value & CHANNEL_CCK) ?
+			((data << 2) / 22) : (data / 10);
+
+		udelay(100 + (2 * data));
+		data = 0;
+	} else {
+		mdelay(1);
+	}
+
+	/*
+	 * Perform ADC test (?)
+	 */
+	data = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
+	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
+	for (i = 0; i <= 20; i++) {
+		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
+			break;
+		udelay(200);
+	}
+	ath5k_hw_reg_write(ah, data, AR5K_PHY_TST1);
+	data = 0;
+
+	/*
+	 * Start automatic gain calibration
+	 *
+	 * During AGC calibration RX path is re-routed to
+	 * a signal detector so we don't receive anything.
+	 *
+	 * This method is used to calibrate some static offsets
+	 * used together with on-the fly I/Q calibration (the
+	 * one performed via ath5k_hw_phy_calibrate), that doesn't
+	 * interrupt rx path.
+	 *
+	 * If we are in a noisy environment AGC calibration may time
+	 * out.
+	 */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+				AR5K_PHY_AGCCTL_CAL);
+
+	/* At the same time start I/Q calibration for QAM constellation
+	 * -no need for CCK- */
+	ah->ah_calibration = false;
+	if (!(mode == AR5K_MODE_11B)) {
+		ah->ah_calibration = true;
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
+				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
+				AR5K_PHY_IQ_RUN);
+	}
+
+	/* Wait for gain calibration to finish (we check for I/Q calibration
+	 * during ath5k_phy_calibrate) */
+	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_CAL, 0, false)) {
+		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
+			channel->center_freq);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Start noise floor calibration
+	 *
+	 * If we run NF calibration before AGC, it always times out.
+	 * Binary HAL starts NF and AGC calibration at the same time
+	 * and only waits for AGC to finish. I believe that's wrong because
+	 * during NF calibration, rx path is also routed to a detector, so if
+	 * it doesn't finish we won't have RX.
+	 *
+	 * XXX: Find an interval that's OK for all cards...
+	 */
+	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
+	if (ret)
+		return ret;
+
+	/*
+	 * Reset queues and start beacon timers at the end of the reset routine
+	 */
+	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
+		/*No QCU on 5210*/
+		if (ah->ah_version != AR5K_AR5210)
+			AR5K_REG_WRITE_Q(ah, AR5K_QUEUE_QCUMASK(i), i);
+
+		ret = ath5k_hw_reset_tx_queue(ah, i);
+		if (ret) {
+			ATH5K_ERR(ah->ah_sc,
+				"failed to reset TX queue #%d\n", i);
+			return ret;
+		}
+	}
+
+	/* Pre-enable interrupts on 5211/5212*/
+	if (ah->ah_version != AR5K_AR5210)
+		ath5k_hw_set_imr(ah, AR5K_INT_RX | AR5K_INT_TX |
+				AR5K_INT_FATAL);
+
+	/*
+	 * Set RF kill flags if supported by the device (read from the EEPROM)
+	 * Disable gpio_intr for now since it results system hang.
+	 * TODO: Handle this in ath5k_intr
+	 */
+#if 0
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_hw_set_gpio_input(ah, 0);
+		ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, 0);
+		if (ah->ah_gpio[0] == 0)
+			ath5k_hw_set_gpio_intr(ah, 0, 1);
+		else
+			ath5k_hw_set_gpio_intr(ah, 0, 0);
+	}
+#endif
+
+	/*
+	 * Set the 32MHz reference clock on 5212 phy clock sleep register
+	 *
+	 * TODO: Find out how to switch to external 32Khz clock to save power
+	 */
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
+		ath5k_hw_reg_write(ah, ah->ah_phy_spending, AR5K_PHY_SPENDING);
+
+		data = ath5k_hw_reg_read(ah, AR5K_USEC_5211) & 0xffffc07f ;
+		data |= (ah->ah_phy_spending == AR5K_PHY_SPENDING_18) ?
+						0x00000f80 : 0x00001380 ;
+		ath5k_hw_reg_write(ah, data, AR5K_USEC_5211);
+		data = 0;
+	}
+
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
+		ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
+		ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
+		if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2413)
+			ath5k_hw_reg_write(ah, 0x00000004, 0x8120);
+	}
+
+	/*
+	 * Disable beacons and reset the register
+	 */
+	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
+			AR5K_BEACON_RESET_TSF);
+
+	return 0;
+}
+
+#undef _ATH5K_RESET
