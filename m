Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30460 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZBIIAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:43 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57798.538059.131949@gargle.gargle.HOWL> (sfid-20090209_090054_133938_C076E33F)
Date: Mon, 9 Feb 2009 13:26:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 01/10] ath9k: Header file cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split the core header files into manageable pieces.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ahb.c    |    4 +-
 drivers/net/wireless/ath9k/ani.c    |    5 +-
 drivers/net/wireless/ath9k/ani.h    |  111 +++
 drivers/net/wireless/ath9k/ath9k.h  | 1653 ++++++++++++++---------------------
 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/calib.c  |    5 +-
 drivers/net/wireless/ath9k/calib.h  |  124 +++
 drivers/net/wireless/ath9k/core.h   |  821 -----------------
 drivers/net/wireless/ath9k/debug.c  |    4 +-
 drivers/net/wireless/ath9k/debug.h  |  153 ++++
 drivers/net/wireless/ath9k/eeprom.c |    5 +-
 drivers/net/wireless/ath9k/eeprom.h |  484 ++++++++++
 drivers/net/wireless/ath9k/hw.c     |    5 +-
 drivers/net/wireless/ath9k/hw.h     | 1377 +++++++++++-------------------
 drivers/net/wireless/ath9k/mac.c    |    5 +-
 drivers/net/wireless/ath9k/mac.h    |  676 ++++++++++++++
 drivers/net/wireless/ath9k/main.c   |    4 +-
 drivers/net/wireless/ath9k/pci.c    |    4 +-
 drivers/net/wireless/ath9k/phy.c    |    5 +-
 drivers/net/wireless/ath9k/rc.c     |    2 +-
 drivers/net/wireless/ath9k/rc.h     |   17 +-
 drivers/net/wireless/ath9k/recv.c   |    2 +-
 drivers/net/wireless/ath9k/reg.h    |    1 +
 drivers/net/wireless/ath9k/regd.c   |    4 +-
 drivers/net/wireless/ath9k/regd.h   |   12 +-
 drivers/net/wireless/ath9k/xmit.c   |    2 +-
 26 files changed, 2733 insertions(+), 2754 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ani.h
 create mode 100644 drivers/net/wireless/ath9k/calib.h
 delete mode 100644 drivers/net/wireless/ath9k/core.h
 create mode 100644 drivers/net/wireless/ath9k/debug.h
 create mode 100644 drivers/net/wireless/ath9k/eeprom.h
 create mode 100644 drivers/net/wireless/ath9k/mac.h

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index 7f2c3a0..361ace1 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -19,9 +19,7 @@
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
 #include <linux/ath9k_platform.h>
-#include "core.h"
-#include "reg.h"
-#include "hw.h"
+#include "ath9k.h"
 
 /* return bus cachesize in 4B word units */
 static void ath_ahb_read_cachesize(struct ath_softc *sc, int *csz)
diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 42197ff..d75bd6e 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hal *ah,
 					struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath9k/ani.h b/drivers/net/wireless/ath9k/ani.h
new file mode 100644
index 0000000..cfb7fbc
--- /dev/null
+++ b/drivers/net/wireless/ath9k/ani.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#ifndef ANI_H
+#define ANI_H
+
+#define HAL_PROCESS_ANI           0x00000001
+#define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
+
+#define DO_ANI(ah) ((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
+
+#define HAL_EP_RND(x, mul)						\
+	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
+#define BEACON_RSSI(ahp)					\
+	HAL_EP_RND(ahp->ah_stats.ast_nodestats.ns_avgbrssi,	\
+		   ATH9K_RSSI_EP_MULTIPLIER)
+
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
+
+#define HAL_NOISE_IMMUNE_MAX              4
+#define HAL_SPUR_IMMUNE_MAX               7
+#define HAL_FIRST_STEP_MAX                2
+
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
+};
+
+struct ath9k_mib_stats {
+	u32 ackrcv_bad;
+	u32 rts_bad;
+	u32 rts_good;
+	u32 fcs_bad;
+	u32 beacons;
+};
+
+struct ath9k_node_stats {
+	u32 ns_avgbrssi;
+	u32 ns_avgrssi;
+	u32 ns_avgtxrssi;
+	u32 ns_avgtxrate;
+};
+
+struct ar5416Stats {
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
+	struct ath9k_mib_stats ast_mibstats;
+	struct ath9k_node_stats ast_nodestats;
+};
+#define ah_mibStats ah_stats.ast_mibstats
+
+void ath9k_ani_reset(struct ath_hal *ah);
+void ath9k_hw_ani_monitor(struct ath_hal *ah,
+			  const struct ath9k_node_stats *stats,
+			  struct ath9k_channel *chan);
+bool ath9k_hw_phycounters(struct ath_hal *ah);
+void ath9k_enable_mib_counters(struct ath_hal *ah);
+void ath9k_hw_disable_mib_counters(struct ath_hal *ah);
+u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah, u32 *rxc_pcnt,
+				  u32 *rxf_pcnt, u32 *txf_pcnt);
+void ath9k_hw_procmibevent(struct ath_hal *ah,
+			   const struct ath9k_node_stats *stats);
+void ath9k_hw_ani_setup(struct ath_hal *ah);
+void ath9k_hw_ani_attach(struct ath_hal *ah);
+void ath9k_hw_ani_detach(struct ath_hal *ah);
+
+#endif /* ANI_H */
diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 5289d28..3cb7bf8 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -17,1028 +17,683 @@
 #ifndef ATH9K_H
 #define ATH9K_H
 
-#include <linux/io.h>
-
-#define ATHEROS_VENDOR_ID	0x168c
-
-#define AR5416_DEVID_PCI	0x0023
-#define AR5416_DEVID_PCIE	0x0024
-#define AR9160_DEVID_PCI	0x0027
-#define AR9280_DEVID_PCI	0x0029
-#define AR9280_DEVID_PCIE	0x002a
-#define AR9285_DEVID_PCIE	0x002b
-
-#define AR5416_AR9100_DEVID	0x000b
-
-#define	AR_SUBVENDOR_ID_NOG	0x0e11
-#define AR_SUBVENDOR_ID_NEW_A	0x7065
-
-#define ATH9K_TXERR_XRETRY         0x01
-#define ATH9K_TXERR_FILT           0x02
-#define ATH9K_TXERR_FIFO           0x04
-#define ATH9K_TXERR_XTXOP          0x08
-#define ATH9K_TXERR_TIMER_EXPIRED  0x10
-
-#define ATH9K_TX_BA                0x01
-#define ATH9K_TX_PWRMGMT           0x02
-#define ATH9K_TX_DESC_CFG_ERR      0x04
-#define ATH9K_TX_DATA_UNDERRUN     0x08
-#define ATH9K_TX_DELIM_UNDERRUN    0x10
-#define ATH9K_TX_SW_ABORTED        0x40
-#define ATH9K_TX_SW_FILTERED       0x80
-
-#define NBBY    8
-
-struct ath_tx_status {
-	u32 ts_tstamp;
-	u16 ts_seqnum;
-	u8 ts_status;
-	u8 ts_ratecode;
-	u8 ts_rateindex;
-	int8_t ts_rssi;
-	u8 ts_shortretry;
-	u8 ts_longretry;
-	u8 ts_virtcol;
-	u8 ts_antenna;
-	u8 ts_flags;
-	int8_t ts_rssi_ctl0;
-	int8_t ts_rssi_ctl1;
-	int8_t ts_rssi_ctl2;
-	int8_t ts_rssi_ext0;
-	int8_t ts_rssi_ext1;
-	int8_t ts_rssi_ext2;
-	u8 pad[3];
-	u32 ba_low;
-	u32 ba_high;
-	u32 evm0;
-	u32 evm1;
-	u32 evm2;
-};
-
-struct ath_rx_status {
-	u32 rs_tstamp;
-	u16 rs_datalen;
-	u8 rs_status;
-	u8 rs_phyerr;
-	int8_t rs_rssi;
-	u8 rs_keyix;
-	u8 rs_rate;
-	u8 rs_antenna;
-	u8 rs_more;
-	int8_t rs_rssi_ctl0;
-	int8_t rs_rssi_ctl1;
-	int8_t rs_rssi_ctl2;
-	int8_t rs_rssi_ext0;
-	int8_t rs_rssi_ext1;
-	int8_t rs_rssi_ext2;
-	u8 rs_isaggr;
-	u8 rs_moreaggr;
-	u8 rs_num_delims;
-	u8 rs_flags;
-	u32 evm0;
-	u32 evm1;
-	u32 evm2;
-};
-
-#define ATH9K_RXERR_CRC           0x01
-#define ATH9K_RXERR_PHY           0x02
-#define ATH9K_RXERR_FIFO          0x04
-#define ATH9K_RXERR_DECRYPT       0x08
-#define ATH9K_RXERR_MIC           0x10
-
-#define ATH9K_RX_MORE             0x01
-#define ATH9K_RX_MORE_AGGR        0x02
-#define ATH9K_RX_GI               0x04
-#define ATH9K_RX_2040             0x08
-#define ATH9K_RX_DELIM_CRC_PRE    0x10
-#define ATH9K_RX_DELIM_CRC_POST   0x20
-#define ATH9K_RX_DECRYPT_BUSY     0x40
-
-#define ATH9K_RXKEYIX_INVALID	((u8)-1)
-#define ATH9K_TXKEYIX_INVALID	((u32)-1)
-
-struct ath_desc {
-	u32 ds_link;
-	u32 ds_data;
-	u32 ds_ctl0;
-	u32 ds_ctl1;
-	u32 ds_hw[20];
-	union {
-		struct ath_tx_status tx;
-		struct ath_rx_status rx;
-		void *stats;
-	} ds_us;
-	void *ds_vdata;
-} __packed;
-
-#define	ds_txstat	ds_us.tx
-#define	ds_rxstat	ds_us.rx
-#define ds_stat		ds_us.stats
-
-#define ATH9K_TXDESC_CLRDMASK		0x0001
-#define ATH9K_TXDESC_NOACK		0x0002
-#define ATH9K_TXDESC_RTSENA		0x0004
-#define ATH9K_TXDESC_CTSENA		0x0008
-/* ATH9K_TXDESC_INTREQ forces a tx interrupt to be generated for
- * the descriptor its marked on.  We take a tx interrupt to reap
- * descriptors when the h/w hits an EOL condition or
- * when the descriptor is specifically marked to generate
- * an interrupt with this flag. Descriptors should be
- * marked periodically to insure timely replenishing of the
- * supply needed for sending frames. Defering interrupts
- * reduces system load and potentially allows more concurrent
- * work to be done but if done to aggressively can cause
- * senders to backup. When the hardware queue is left too
- * large rate control information may also be too out of
- * date. An Alternative for this is TX interrupt mitigation
- * but this needs more testing. */
-#define ATH9K_TXDESC_INTREQ		0x0010
-#define ATH9K_TXDESC_VEOL		0x0020
-#define ATH9K_TXDESC_EXT_ONLY		0x0040
-#define ATH9K_TXDESC_EXT_AND_CTL	0x0080
-#define ATH9K_TXDESC_VMF		0x0100
-#define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
-#define ATH9K_TXDESC_CAB		0x0400
-
-#define ATH9K_RXDESC_INTREQ		0x0020
-
-enum wireless_mode {
-	ATH9K_MODE_11A = 0,
-	ATH9K_MODE_11B = 2,
-	ATH9K_MODE_11G = 3,
-	ATH9K_MODE_11NA_HT20 = 6,
-	ATH9K_MODE_11NG_HT20 = 7,
-	ATH9K_MODE_11NA_HT40PLUS = 8,
-	ATH9K_MODE_11NA_HT40MINUS = 9,
-	ATH9K_MODE_11NG_HT40PLUS = 10,
-	ATH9K_MODE_11NG_HT40MINUS = 11,
-	ATH9K_MODE_MAX
-};
-
-enum ath9k_hw_caps {
-	ATH9K_HW_CAP_CHAN_SPREAD		= BIT(0),
-	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(1),
-	ATH9K_HW_CAP_MIC_CKIP                   = BIT(2),
-	ATH9K_HW_CAP_MIC_TKIP                   = BIT(3),
-	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(4),
-	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(5),
-	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(6),
-	ATH9K_HW_CAP_VEOL                       = BIT(7),
-	ATH9K_HW_CAP_BSSIDMASK                  = BIT(8),
-	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(9),
-	ATH9K_HW_CAP_CHAN_HALFRATE              = BIT(10),
-	ATH9K_HW_CAP_CHAN_QUARTERRATE           = BIT(11),
-	ATH9K_HW_CAP_HT                         = BIT(12),
-	ATH9K_HW_CAP_GTT                        = BIT(13),
-	ATH9K_HW_CAP_FASTCC                     = BIT(14),
-	ATH9K_HW_CAP_RFSILENT                   = BIT(15),
-	ATH9K_HW_CAP_WOW                        = BIT(16),
-	ATH9K_HW_CAP_CST                        = BIT(17),
-	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(18),
-	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(19),
-	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(20),
-	ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT     = BIT(21),
-	ATH9K_HW_CAP_BT_COEX			= BIT(22)
-};
-
-enum ath9k_capability_type {
-	ATH9K_CAP_CIPHER = 0,
-	ATH9K_CAP_TKIP_MIC,
-	ATH9K_CAP_TKIP_SPLIT,
-	ATH9K_CAP_PHYCOUNTERS,
-	ATH9K_CAP_DIVERSITY,
-	ATH9K_CAP_TXPOW,
-	ATH9K_CAP_PHYDIAG,
-	ATH9K_CAP_MCAST_KEYSRCH,
-	ATH9K_CAP_TSF_ADJUST,
-	ATH9K_CAP_WME_TKIPMIC,
-	ATH9K_CAP_RFSILENT,
-	ATH9K_CAP_ANT_CFG_2GHZ,
-	ATH9K_CAP_ANT_CFG_5GHZ
-};
-
-struct ath9k_hw_capabilities {
-	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
-	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */
-	u16 total_queues;
-	u16 keycache_size;
-	u16 low_5ghz_chan, high_5ghz_chan;
-	u16 low_2ghz_chan, high_2ghz_chan;
-	u16 num_mr_retries;
-	u16 rts_aggr_limit;
-	u8 tx_chainmask;
-	u8 rx_chainmask;
-	u16 tx_triglevel_max;
-	u16 reg_cap;
-	u8 num_gpio_pins;
-	u8 num_antcfg_2ghz;
-	u8 num_antcfg_5ghz;
-};
-
-struct ath9k_ops_config {
-	int dma_beacon_response_time;
-	int sw_beacon_response_time;
-	int additional_swba_backoff;
-	int ack_6mb;
-	int cwm_ignore_extcca;
-	u8 pcie_powersave_enable;
-	u8 pcie_l1skp_enable;
-	u8 pcie_clock_req;
-	u32 pcie_waen;
-	int pcie_power_reset;
-	u8 pcie_restore;
-	u8 analog_shiftreg;
-	u8 ht_enable;
-	u32 ofdm_trig_low;
-	u32 ofdm_trig_high;
-	u32 cck_trig_high;
-	u32 cck_trig_low;
-	u32 enable_ani;
-	u8 noise_immunity_level;
-	u32 ofdm_weaksignal_det;
-	u32 cck_weaksignal_thr;
-	u8 spur_immunity_level;
-	u8 firstep_level;
-	int8_t rssi_thr_high;
-	int8_t rssi_thr_low;
-	u16 diversity_control;
-	u16 antenna_switch_swap;
-	int serialize_regmode;
-	int intr_mitigation;
-#define SPUR_DISABLE        	0
-#define SPUR_ENABLE_IOCTL   	1
-#define SPUR_ENABLE_EEPROM  	2
-#define AR_EEPROM_MODAL_SPURS   5
-#define AR_SPUR_5413_1      	1640
-#define AR_SPUR_5413_2      	1200
-#define AR_NO_SPUR      	0x8000
-#define AR_BASE_FREQ_2GHZ   	2300
-#define AR_BASE_FREQ_5GHZ   	4900
-#define AR_SPUR_FEEQ_BOUND_HT40 19
-#define AR_SPUR_FEEQ_BOUND_HT20 10
-	int spurmode;
-	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
-};
-
-enum ath9k_tx_queue {
-	ATH9K_TX_QUEUE_INACTIVE = 0,
-	ATH9K_TX_QUEUE_DATA,
-	ATH9K_TX_QUEUE_BEACON,
-	ATH9K_TX_QUEUE_CAB,
-	ATH9K_TX_QUEUE_UAPSD,
-	ATH9K_TX_QUEUE_PSPOLL
-};
-
-#define	ATH9K_NUM_TX_QUEUES 10
-
-enum ath9k_tx_queue_subtype {
-	ATH9K_WME_AC_BK = 0,
-	ATH9K_WME_AC_BE,
-	ATH9K_WME_AC_VI,
-	ATH9K_WME_AC_VO,
-	ATH9K_WME_UPSD
-};
-
-enum ath9k_tx_queue_flags {
-	TXQ_FLAG_TXOKINT_ENABLE = 0x0001,
-	TXQ_FLAG_TXERRINT_ENABLE = 0x0001,
-	TXQ_FLAG_TXDESCINT_ENABLE = 0x0002,
-	TXQ_FLAG_TXEOLINT_ENABLE = 0x0004,
-	TXQ_FLAG_TXURNINT_ENABLE = 0x0008,
-	TXQ_FLAG_BACKOFF_DISABLE = 0x0010,
-	TXQ_FLAG_COMPRESSION_ENABLE = 0x0020,
-	TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE = 0x0040,
-	TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE = 0x0080,
-};
-
-#define ATH9K_TXQ_USEDEFAULT ((u32) -1)
-
-#define ATH9K_DECOMP_MASK_SIZE     128
-#define ATH9K_READY_TIME_LO_BOUND  50
-#define ATH9K_READY_TIME_HI_BOUND  96
-
-enum ath9k_pkt_type {
-	ATH9K_PKT_TYPE_NORMAL = 0,
-	ATH9K_PKT_TYPE_ATIM,
-	ATH9K_PKT_TYPE_PSPOLL,
-	ATH9K_PKT_TYPE_BEACON,
-	ATH9K_PKT_TYPE_PROBE_RESP,
-	ATH9K_PKT_TYPE_CHIRP,
-	ATH9K_PKT_TYPE_GRP_POLL,
-};
-
-struct ath9k_tx_queue_info {
-	u32 tqi_ver;
-	enum ath9k_tx_queue tqi_type;
-	enum ath9k_tx_queue_subtype tqi_subtype;
-	enum ath9k_tx_queue_flags tqi_qflags;
-	u32 tqi_priority;
-	u32 tqi_aifs;
-	u32 tqi_cwmin;
-	u32 tqi_cwmax;
-	u16 tqi_shretry;
-	u16 tqi_lgretry;
-	u32 tqi_cbrPeriod;
-	u32 tqi_cbrOverflowLimit;
-	u32 tqi_burstTime;
-	u32 tqi_readyTime;
-	u32 tqi_physCompBuf;
-	u32 tqi_intFlags;
-};
-
-enum ath9k_rx_filter {
-	ATH9K_RX_FILTER_UCAST = 0x00000001,
-	ATH9K_RX_FILTER_MCAST = 0x00000002,
-	ATH9K_RX_FILTER_BCAST = 0x00000004,
-	ATH9K_RX_FILTER_CONTROL = 0x00000008,
-	ATH9K_RX_FILTER_BEACON = 0x00000010,
-	ATH9K_RX_FILTER_PROM = 0x00000020,
-	ATH9K_RX_FILTER_PROBEREQ = 0x00000080,
-	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
-	ATH9K_RX_FILTER_PHYERR = 0x00000100,
-	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
-};
-
-enum ath9k_int {
-	ATH9K_INT_RX = 0x00000001,
-	ATH9K_INT_RXDESC = 0x00000002,
-	ATH9K_INT_RXNOFRM = 0x00000008,
-	ATH9K_INT_RXEOL = 0x00000010,
-	ATH9K_INT_RXORN = 0x00000020,
-	ATH9K_INT_TX = 0x00000040,
-	ATH9K_INT_TXDESC = 0x00000080,
-	ATH9K_INT_TIM_TIMER = 0x00000100,
-	ATH9K_INT_TXURN = 0x00000800,
-	ATH9K_INT_MIB = 0x00001000,
-	ATH9K_INT_RXPHY = 0x00004000,
-	ATH9K_INT_RXKCM = 0x00008000,
-	ATH9K_INT_SWBA = 0x00010000,
-	ATH9K_INT_BMISS = 0x00040000,
-	ATH9K_INT_BNR = 0x00100000,
-	ATH9K_INT_TIM = 0x00200000,
-	ATH9K_INT_DTIM = 0x00400000,
-	ATH9K_INT_DTIMSYNC = 0x00800000,
-	ATH9K_INT_GPIO = 0x01000000,
-	ATH9K_INT_CABEND = 0x02000000,
-	ATH9K_INT_CST = 0x10000000,
-	ATH9K_INT_GTT = 0x20000000,
-	ATH9K_INT_FATAL = 0x40000000,
-	ATH9K_INT_GLOBAL = 0x80000000,
-	ATH9K_INT_BMISC = ATH9K_INT_TIM |
-		ATH9K_INT_DTIM |
-		ATH9K_INT_DTIMSYNC |
-		ATH9K_INT_CABEND,
-	ATH9K_INT_COMMON = ATH9K_INT_RXNOFRM |
-		ATH9K_INT_RXDESC |
-		ATH9K_INT_RXEOL |
-		ATH9K_INT_RXORN |
-		ATH9K_INT_TXURN |
-		ATH9K_INT_TXDESC |
-		ATH9K_INT_MIB |
-		ATH9K_INT_RXPHY |
-		ATH9K_INT_RXKCM |
-		ATH9K_INT_SWBA |
-		ATH9K_INT_BMISS |
-		ATH9K_INT_GPIO,
-	ATH9K_INT_NOCARD = 0xffffffff
-};
-
-#define ATH9K_RATESERIES_RTS_CTS  0x0001
-#define ATH9K_RATESERIES_2040     0x0002
-#define ATH9K_RATESERIES_HALFGI   0x0004
-
-struct ath9k_11n_rate_series {
-	u32 Tries;
-	u32 Rate;
-	u32 PktDuration;
-	u32 ChSel;
-	u32 RateFlags;
-};
-
-#define CHANNEL_CW_INT    0x00002
-#define CHANNEL_CCK       0x00020
-#define CHANNEL_OFDM      0x00040
-#define CHANNEL_2GHZ      0x00080
-#define CHANNEL_5GHZ      0x00100
-#define CHANNEL_PASSIVE   0x00200
-#define CHANNEL_DYN       0x00400
-#define CHANNEL_HALF      0x04000
-#define CHANNEL_QUARTER   0x08000
-#define CHANNEL_HT20      0x10000
-#define CHANNEL_HT40PLUS  0x20000
-#define CHANNEL_HT40MINUS 0x40000
-
-#define CHANNEL_INTERFERENCE    0x01
-#define CHANNEL_DFS             0x02
-#define CHANNEL_4MS_LIMIT       0x04
-#define CHANNEL_DFS_CLEAR       0x08
-#define CHANNEL_DISALLOW_ADHOC  0x10
-#define CHANNEL_PER_11D_ADHOC   0x20
-
-#define CHANNEL_A           (CHANNEL_5GHZ|CHANNEL_OFDM)
-#define CHANNEL_B           (CHANNEL_2GHZ|CHANNEL_CCK)
-#define CHANNEL_G           (CHANNEL_2GHZ|CHANNEL_OFDM)
-#define CHANNEL_G_HT20      (CHANNEL_2GHZ|CHANNEL_HT20)
-#define CHANNEL_A_HT20      (CHANNEL_5GHZ|CHANNEL_HT20)
-#define CHANNEL_G_HT40PLUS  (CHANNEL_2GHZ|CHANNEL_HT40PLUS)
-#define CHANNEL_G_HT40MINUS (CHANNEL_2GHZ|CHANNEL_HT40MINUS)
-#define CHANNEL_A_HT40PLUS  (CHANNEL_5GHZ|CHANNEL_HT40PLUS)
-#define CHANNEL_A_HT40MINUS (CHANNEL_5GHZ|CHANNEL_HT40MINUS)
-#define CHANNEL_ALL				\
-	(CHANNEL_OFDM|				\
-	 CHANNEL_CCK|				\
-	 CHANNEL_2GHZ |				\
-	 CHANNEL_5GHZ |				\
-	 CHANNEL_HT20 |				\
-	 CHANNEL_HT40PLUS |			\
-	 CHANNEL_HT40MINUS)
-
-struct ath9k_channel {
-	struct ieee80211_channel *chan;
-	u16 channel;
-	u32 channelFlags;
-	u32 chanmode;
-	int32_t CalValid;
-	bool oneTimeCalsDone;
-	int8_t iCoff;
-	int8_t qCoff;
-	int16_t rawNoiseFloor;
-};
-
-#define IS_CHAN_A(_c) ((((_c)->channelFlags & CHANNEL_A) == CHANNEL_A) || \
-       (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
-       (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
-       (((_c)->channelFlags & CHANNEL_A_HT40MINUS) == CHANNEL_A_HT40MINUS))
-#define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
-       (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
-       (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
-       (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
-#define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
-#define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
-#define IS_CHAN_PASSIVE(_c) (((_c)->channelFlags & CHANNEL_PASSIVE) != 0)
-#define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
-#define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
-
-/* These macros check chanmode and not channelFlags */
-#define IS_CHAN_B(_c) ((_c)->chanmode == CHANNEL_B)
-#define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT20))
-#define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
-			  ((_c)->chanmode == CHANNEL_A_HT40MINUS) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT40PLUS) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
-
-#define IS_CHAN_A_5MHZ_SPACED(_c)			\
-	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
-	 (((_c)->channel % 20) != 0) &&			\
-	 (((_c)->channel % 10) != 0))
-
-struct ath9k_keyval {
-	u8 kv_type;
-	u8 kv_pad;
-	u16 kv_len;
-	u8 kv_val[16];
-	u8 kv_mic[8];
-	u8 kv_txmic[8];
-};
-
-enum ath9k_key_type {
-	ATH9K_KEY_TYPE_CLEAR,
-	ATH9K_KEY_TYPE_WEP,
-	ATH9K_KEY_TYPE_AES,
-	ATH9K_KEY_TYPE_TKIP,
-};
-
-enum ath9k_cipher {
-	ATH9K_CIPHER_WEP = 0,
-	ATH9K_CIPHER_AES_OCB = 1,
-	ATH9K_CIPHER_AES_CCM = 2,
-	ATH9K_CIPHER_CKIP = 3,
-	ATH9K_CIPHER_TKIP = 4,
-	ATH9K_CIPHER_CLR = 5,
-	ATH9K_CIPHER_MIC = 127
-};
-
-#define AR_EEPROM_EEPCAP_COMPRESS_DIS   0x0001
-#define AR_EEPROM_EEPCAP_AES_DIS        0x0002
-#define AR_EEPROM_EEPCAP_FASTFRAME_DIS  0x0004
-#define AR_EEPROM_EEPCAP_BURST_DIS      0x0008
-#define AR_EEPROM_EEPCAP_MAXQCU         0x01F0
-#define AR_EEPROM_EEPCAP_MAXQCU_S       4
-#define AR_EEPROM_EEPCAP_HEAVY_CLIP_EN  0x0200
-#define AR_EEPROM_EEPCAP_KC_ENTRIES     0xF000
-#define AR_EEPROM_EEPCAP_KC_ENTRIES_S   12
-
-#define AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND   0x0040
-#define AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN    0x0080
-#define AR_EEPROM_EEREGCAP_EN_KK_U2         0x0100
-#define AR_EEPROM_EEREGCAP_EN_KK_MIDBAND    0x0200
-#define AR_EEPROM_EEREGCAP_EN_KK_U1_ODD     0x0400
-#define AR_EEPROM_EEREGCAP_EN_KK_NEW_11A    0x0800
-
-#define AR_EEPROM_EEREGCAP_EN_KK_U1_ODD_PRE4_0  0x4000
-#define AR_EEPROM_EEREGCAP_EN_KK_NEW_11A_PRE4_0 0x8000
-
-#define SD_NO_CTL               0xE0
-#define NO_CTL                  0xff
-#define CTL_MODE_M              7
-#define CTL_11A                 0
-#define CTL_11B                 1
-#define CTL_11G                 2
-#define CTL_2GHT20              5
-#define CTL_5GHT20              6
-#define CTL_2GHT40              7
-#define CTL_5GHT40              8
-
-#define AR_EEPROM_MAC(i)        (0x1d+(i))
-
-#define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
-#define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
-#define AR_EEPROM_RFSILENT_POLARITY     0x0002
-#define AR_EEPROM_RFSILENT_POLARITY_S   1
-
-#define CTRY_DEBUG 0x1ff
-#define	CTRY_DEFAULT 0
-
-enum reg_ext_bitmap {
-	REG_EXT_JAPAN_MIDBAND = 1,
-	REG_EXT_FCC_DFS_HT40 = 2,
-	REG_EXT_JAPAN_NONDFS_HT40 = 3,
-	REG_EXT_JAPAN_DFS_HT40 = 4
-};
-
-struct ath9k_country_entry {
-	u16 countryCode;
-	u16 regDmnEnum;
-	u16 regDmn5G;
-	u16 regDmn2G;
-	u8 isMultidomain;
-	u8 iso[3];
-};
-
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
-
-#define SM(_v, _f)  (((_v) << _f##_S) & _f)
-#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
-#define REG_RMW(_a, _r, _set, _clr)    \
-	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
-#define REG_RMW_FIELD(_a, _r, _f, _v) \
-	REG_WRITE(_a, _r, \
-	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
-#define REG_SET_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
-#define REG_CLR_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
-
-#define ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS   0x00000001
-
-#define INIT_AIFS       2
-#define INIT_CWMIN      15
-#define INIT_CWMIN_11B  31
-#define INIT_CWMAX      1023
-#define INIT_SH_RETRY   10
-#define INIT_LG_RETRY   10
-#define INIT_SSH_RETRY  32
-#define INIT_SLG_RETRY  32
-
-#define WLAN_CTRL_FRAME_SIZE (2+2+6+4)
-
-#define ATH_AMPDU_LIMIT_MAX      (64 * 1024 - 1)
-#define ATH_AMPDU_LIMIT_DEFAULT  ATH_AMPDU_LIMIT_MAX
-
-#define IEEE80211_WEP_IVLEN      3
-#define IEEE80211_WEP_KIDLEN     1
-#define IEEE80211_WEP_CRCLEN     4
-#define IEEE80211_MAX_MPDU_LEN  (3840 + FCS_LEN +		\
-				 (IEEE80211_WEP_IVLEN +		\
-				  IEEE80211_WEP_KIDLEN +	\
-				  IEEE80211_WEP_CRCLEN))
-#define MAX_RATE_POWER 63
-
-enum ath9k_power_mode {
-	ATH9K_PM_AWAKE = 0,
-	ATH9K_PM_FULL_SLEEP,
-	ATH9K_PM_NETWORK_SLEEP,
-	ATH9K_PM_UNDEFINED
-};
-
-struct ath9k_mib_stats {
-	u32 ackrcv_bad;
-	u32 rts_bad;
-	u32 rts_good;
-	u32 fcs_bad;
-	u32 beacons;
-};
+#include <linux/etherdevice.h>
+#include <linux/device.h>
+#include <net/mac80211.h>
+#include <linux/leds.h>
+#include <linux/rfkill.h>
+
+#include "hw.h"
+#include "rc.h"
+#include "debug.h"
+
+struct ath_node;
+
+/* Macro to expand scalars to 64-bit objects */
+
+#define	ito64(x) (sizeof(x) == 8) ?			\
+	(((unsigned long long int)(x)) & (0xff)) :	\
+	(sizeof(x) == 16) ?				\
+	(((unsigned long long int)(x)) & 0xffff) :	\
+	((sizeof(x) == 32) ?				\
+	 (((unsigned long long int)(x)) & 0xffffffff) : \
+	 (unsigned long long int)(x))
+
+/* increment with wrap-around */
+#define INCR(_l, _sz)   do {			\
+		(_l)++;				\
+		(_l) &= ((_sz) - 1);		\
+	} while (0)
+
+/* decrement with wrap-around */
+#define DECR(_l,  _sz)  do {			\
+		(_l)--;				\
+		(_l) &= ((_sz) - 1);		\
+	} while (0)
+
+#define A_MAX(a, b) ((a) > (b) ? (a) : (b))
+
+#define ASSERT(exp) do {			\
+		if (unlikely(!(exp))) {		\
+			BUG();			\
+		}				\
+	} while (0)
+
+#define TSF_TO_TU(_h,_l) \
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
+
+#define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
+
+static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+struct ath_config {
+	u32 ath_aggr_prot;
+	u16 txpowlimit;
+	u8 cabqReadytime;
+	u8 swBeaconProcess;
+};
+
+/*************************/
+/* Descriptor Management */
+/*************************/
+
+#define ATH_TXBUF_RESET(_bf) do {				\
+		(_bf)->bf_status = 0;				\
+		(_bf)->bf_lastbf = NULL;			\
+		(_bf)->bf_next = NULL;				\
+		memset(&((_bf)->bf_state), 0,			\
+		       sizeof(struct ath_buf_state));		\
+	} while (0)
+
+/**
+ * enum buffer_type - Buffer type flags
+ *
+ * @BUF_HT: Send this buffer using HT capabilities
+ * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
+ * @BUF_AGGR: Indicates whether the buffer can be aggregated
+ *	(used in aggregation scheduling)
+ * @BUF_RETRY: Indicates whether the buffer is retried
+ * @BUF_XRETRY: To denote excessive retries of the buffer
+ */
+enum buffer_type {
+	BUF_HT			= BIT(1),
+	BUF_AMPDU		= BIT(2),
+	BUF_AGGR		= BIT(3),
+	BUF_RETRY		= BIT(4),
+	BUF_XRETRY		= BIT(5),
+};
+
+struct ath_buf_state {
+	int bfs_nframes;		/* # frames in aggregate */
+	u16 bfs_al;			/* length of aggregate */
+	u16 bfs_frmlen;			/* length of frame */
+	int bfs_seqno;			/* sequence number */
+	int bfs_tidno;			/* tid of this frame */
+	int bfs_retries;		/* current retries */
+	u32 bf_type;			/* BUF_* (enum buffer_type) */
+	u32 bfs_keyix;
+	enum ath9k_key_type bfs_keytype;
+};
+
+#define bf_nframes      	bf_state.bfs_nframes
+#define bf_al           	bf_state.bfs_al
+#define bf_frmlen       	bf_state.bfs_frmlen
+#define bf_retries      	bf_state.bfs_retries
+#define bf_seqno        	bf_state.bfs_seqno
+#define bf_tidno        	bf_state.bfs_tidno
+#define bf_keyix                bf_state.bfs_keyix
+#define bf_keytype      	bf_state.bfs_keytype
+#define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
+#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
+#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
+#define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
+#define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
-enum ath9k_ant_setting {
-	ATH9K_ANT_VARIABLE = 0,
-	ATH9K_ANT_FIXED_A,
-	ATH9K_ANT_FIXED_B
-};
+/*
+ * Abstraction of a contiguous buffer to transmit/receive.  There is only
+ * a single hw descriptor encapsulated here.
+ */
+struct ath_buf {
+	struct list_head list;
+	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
+					   an aggregate) */
+	struct ath_buf *bf_next;	/* next subframe in the aggregate */
+	void *bf_mpdu;			/* enclosing frame structure */
+	struct ath_desc *bf_desc;	/* virtual addr of desc */
+	dma_addr_t bf_daddr;		/* physical addr of desc */
+	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
+	u32 bf_status;
+	u16 bf_flags;			/* tx descriptor flags */
+	struct ath_buf_state bf_state;	/* buffer state */
+	dma_addr_t bf_dmacontext;
+};
+
+#define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
+#define ATH_BUFSTATUS_STALE     0x00000002
+
+/* DMA state for tx/rx descriptors */
+
+struct ath_descdma {
+	const char *dd_name;
+	struct ath_desc *dd_desc;	/* descriptors  */
+	dma_addr_t dd_desc_paddr;	/* physical addr of dd_desc  */
+	u32 dd_desc_len;		/* size of dd_desc  */
+	struct ath_buf *dd_bufptr;	/* associated buffers */
+	dma_addr_t dd_dmacontext;
+};
+
+int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
+		      struct list_head *head, const char *name,
+		      int nbuf, int ndesc);
+void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
+			 struct list_head *head);
+
+/***********/
+/* RX / TX */
+/***********/
+
+#define ATH_MAX_ANTENNA         3
+#define ATH_RXBUF               512
+#define WME_NUM_TID             16
+#define ATH_TXBUF               512
+#define ATH_TXMAXTRY            13
+#define ATH_11N_TXMAXTRY        10
+#define ATH_MGT_TXMAXTRY        4
+#define WME_BA_BMP_SIZE         64
+#define WME_MAX_BA              WME_BA_BMP_SIZE
+#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
+
+#define TID_TO_WME_AC(_tid)				\
+	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
+	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
+	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
+	 WME_AC_VO)
+
+#define WME_AC_BE   0
+#define WME_AC_BK   1
+#define WME_AC_VI   2
+#define WME_AC_VO   3
+#define WME_NUM_AC  4
+
+#define ADDBA_EXCHANGE_ATTEMPTS    10
+#define ATH_AGGR_DELIM_SZ          4
+#define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
+/* number of delimiters for encryption padding */
+#define ATH_AGGR_ENCRYPTDELIM      10
+/* minimum h/w qdepth to be sustained to maximize aggregation */
+#define ATH_AGGR_MIN_QDEPTH        2
+#define ATH_AMPDU_SUBFRAME_DEFAULT 32
+#define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
+#define ATH_AMPDU_LIMIT_DEFAULT    ATH_AMPDU_LIMIT_MAX
+
+#define IEEE80211_SEQ_SEQ_SHIFT    4
+#define IEEE80211_SEQ_MAX          4096
+#define IEEE80211_MIN_AMPDU_BUF    0x8
+#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
+#define IEEE80211_WEP_IVLEN        3
+#define IEEE80211_WEP_KIDLEN       1
+#define IEEE80211_WEP_CRCLEN       4
+#define IEEE80211_MAX_MPDU_LEN     (3840 + FCS_LEN +		\
+				    (IEEE80211_WEP_IVLEN +	\
+				     IEEE80211_WEP_KIDLEN +	\
+				     IEEE80211_WEP_CRCLEN))
+
+/* return whether a bit at index _n in bitmap _bm is set
+ * _sz is the size of the bitmap  */
+#define ATH_BA_ISSET(_bm, _n)  (((_n) < (WME_BA_BMP_SIZE)) &&		\
+				((_bm)[(_n) >> 5] & (1 << ((_n) & 31))))
+
+/* return block-ack bitmap index given sequence and starting sequence */
+#define ATH_BA_INDEX(_st, _seq) (((_seq) - (_st)) & (IEEE80211_SEQ_MAX - 1))
+
+/* returns delimiter padding required given the packet length */
+#define ATH_AGGR_GET_NDELIM(_len)					\
+	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
+	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+
+#define BAW_WITHIN(_start, _bawsz, _seqno) \
+	((((_seqno) - (_start)) & 4095) < (_bawsz))
+
+#define ATH_DS_BA_SEQ(_ds)         ((_ds)->ds_us.tx.ts_seqnum)
+#define ATH_DS_BA_BITMAP(_ds)      (&(_ds)->ds_us.tx.ba_low)
+#define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
+#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
+
+enum ATH_AGGR_STATUS {
+	ATH_AGGR_DONE,
+	ATH_AGGR_BAW_CLOSED,
+	ATH_AGGR_LIMITED,
+};
+
+struct ath_txq {
+	u32 axq_qnum;			/* hardware q number */
+	u32 *axq_link;			/* link ptr in last TX desc */
+	struct list_head axq_q;		/* transmit queue */
+	spinlock_t axq_lock;
+	u32 axq_depth;			/* queue depth */
+	u8 axq_aggr_depth;		/* aggregates queued */
+	u32 axq_totalqueued;		/* total ever queued */
+	bool stopped;			/* Is mac80211 queue stopped ? */
+	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
+
+	/* first desc of the last descriptor that contains CTS */
+	struct ath_desc *axq_lastdsWithCTS;
+
+	/* final desc of the gating desc that determines whether
+	   lastdsWithCTS has been DMA'ed or not */
+	struct ath_desc *axq_gatingds;
+
+	struct list_head axq_acq;
+};
+
+#define AGGR_CLEANUP         BIT(1)
+#define AGGR_ADDBA_COMPLETE  BIT(2)
+#define AGGR_ADDBA_PROGRESS  BIT(3)
+
+/* per TID aggregate tx state for a destination */
+struct ath_atx_tid {
+	struct list_head list;		/* round-robin tid entry */
+	struct list_head buf_q;		/* pending buffers */
+	struct ath_node *an;
+	struct ath_atx_ac *ac;
+	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS]; /* active tx frames */
+	u16 seq_start;
+	u16 seq_next;
+	u16 baw_size;
+	int tidno;
+	int baw_head;			/* first un-acked tx buffer */
+	int baw_tail;			/* next unused tx buffer slot */
+	int sched;
+	int paused;
+	u8 state;
+	int addba_exchangeattempts;
+};
+
+/* per access-category aggregate tx state for a destination */
+struct ath_atx_ac {
+	int sched;			/* dest-ac is scheduled */
+	int qnum;			/* H/W queue number associated
+					   with this AC */
+	struct list_head list;		/* round-robin txq entry */
+	struct list_head tid_q;		/* queue of TIDs with buffers */
+};
+
+/* per-frame tx control block */
+struct ath_tx_control {
+	struct ath_txq *txq;
+	int if_id;
+};
+
+/* per frame tx status block */
+struct ath_xmit_status {
+	int retries;	/* number of retries to successufully
+			   transmit this frame */
+	int flags;	/* status of transmit */
+#define ATH_TX_ERROR        0x01
+#define ATH_TX_XRETRY       0x02
+#define ATH_TX_BAR          0x04
+};
+
+/* All RSSI values are noise floor adjusted */
+struct ath_tx_stat {
+	int rssi;
+	int rssictl[ATH_MAX_ANTENNA];
+	int rssiextn[ATH_MAX_ANTENNA];
+	int rateieee;
+	int rateKbps;
+	int ratecode;
+	int flags;
+	u32 airtime;	/* time on air per final tx rate */
+};
+
+struct aggr_rifs_param {
+	int param_max_frames;
+	int param_max_len;
+	int param_rl;
+	int param_al;
+	struct ath_rc_series *param_rcs;
+};
+
+struct ath_node {
+	struct ath_softc *an_sc;
+	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_ac ac[WME_NUM_AC];
+	u16 maxampdu;
+	u8 mpdudensity;
+};
+
+struct ath_tx {
+	u16 seq_no;
+	u32 txqsetup;
+	int hwq_map[ATH9K_WME_AC_VO+1];
+	spinlock_t txbuflock;
+	struct list_head txbuf;
+	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
+	struct ath_descdma txdma;
+};
+
+struct ath_rx {
+	u8 defant;
+	u8 rxotherant;
+	u32 *rxlink;
+	int bufsize;
+	unsigned int rxfilter;
+	spinlock_t rxflushlock;
+	spinlock_t rxbuflock;
+	struct list_head rxbuf;
+	struct ath_descdma rxdma;
+};
+
+int ath_startrecv(struct ath_softc *sc);
+bool ath_stoprecv(struct ath_softc *sc);
+void ath_flushrecv(struct ath_softc *sc);
+u32 ath_calcrxfilter(struct ath_softc *sc);
+int ath_rx_init(struct ath_softc *sc, int nbufs);
+void ath_rx_cleanup(struct ath_softc *sc);
+int ath_rx_tasklet(struct ath_softc *sc, int flush);
+struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
+void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
+int ath_tx_setup(struct ath_softc *sc, int haltype);
+void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
+void ath_draintxq(struct ath_softc *sc,
+		     struct ath_txq *txq, bool retry_tx);
+void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
+void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
+void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
+int ath_tx_init(struct ath_softc *sc, int nbufs);
+int ath_tx_cleanup(struct ath_softc *sc);
+struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
+int ath_txq_update(struct ath_softc *sc, int qnum,
+		   struct ath9k_tx_queue_info *q);
+int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+		 struct ath_tx_control *txctl);
+void ath_tx_tasklet(struct ath_softc *sc);
+void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
+bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn);
+int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+
+/********/
+/* VAPs */
+/********/
 
-#define ATH9K_SLOT_TIME_6 6
-#define ATH9K_SLOT_TIME_9 9
-#define ATH9K_SLOT_TIME_20 20
+/*
+ * Define the scheme that we select MAC address for multiple
+ * BSS on the same radio. The very first VAP will just use the MAC
+ * address from the EEPROM. For the next 3 VAPs, we set the
+ * U/L bit (bit 1) in MAC address, and use the next two bits as the
+ * index of the VAP.
+ */
 
-enum ath9k_ht_macmode {
-	ATH9K_HT_MACMODE_20 = 0,
-	ATH9K_HT_MACMODE_2040 = 1,
-};
+#define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
+	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
 
-enum ath9k_ht_extprotspacing {
-	ATH9K_HT_EXTPROTSPACING_20 = 0,
-	ATH9K_HT_EXTPROTSPACING_25 = 1,
+struct ath_vap {
+	int av_bslot;
+	enum nl80211_iftype av_opmode;
+	struct ath_buf *av_bcbuf;
+	struct ath_tx_control av_btxctl;
 };
 
-struct ath9k_ht_cwm {
-	enum ath9k_ht_macmode ht_macmode;
-	enum ath9k_ht_extprotspacing ht_extprotspacing;
-};
+/*******************/
+/* Beacon Handling */
+/*******************/
 
-enum ath9k_ani_cmd {
-	ATH9K_ANI_PRESENT = 0x1,
-	ATH9K_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
-	ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION = 0x4,
-	ATH9K_ANI_CCK_WEAK_SIGNAL_THR = 0x8,
-	ATH9K_ANI_FIRSTEP_LEVEL = 0x10,
-	ATH9K_ANI_SPUR_IMMUNITY_LEVEL = 0x20,
-	ATH9K_ANI_MODE = 0x40,
-	ATH9K_ANI_PHYERR_RESET = 0x80,
-	ATH9K_ANI_ALL = 0xff
-};
+/*
+ * Regardless of the number of beacons we stagger, (i.e. regardless of the
+ * number of BSSIDs) if a given beacon does not go out even after waiting this
+ * number of beacon intervals, the game's up.
+ */
+#define BSTUCK_THRESH           	(9 * ATH_BCBUF)
+#define	ATH_BCBUF               	1
+#define ATH_DEFAULT_BINTVAL     	100 /* TU */
+#define ATH_DEFAULT_BMISS_LIMIT 	10
+#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
+
+struct ath_beacon_config {
+	u16 beacon_interval;
+	u16 listen_interval;
+	u16 dtim_period;
+	u16 bmiss_timeout;
+	u8 dtim_count;
+	u8 tim_offset;
+	union {
+		u64 last_tsf;
+		u8 last_tstamp[8];
+	} u; /* last received beacon/probe response timestamp of this BSS. */
+};
+
+struct ath_beacon {
+	enum {
+		OK,		/* no change needed */
+		UPDATE,		/* update pending */
+		COMMIT		/* beacon sent, commit change */
+	} updateslot;		/* slot time update fsm */
+
+	u32 beaconq;
+	u32 bmisscnt;
+	u32 ast_be_xmit;
+	u64 bc_tstamp;
+	int bslot[ATH_BCBUF];
+	int slottime;
+	int slotupdate;
+	struct ath9k_tx_queue_info beacon_qi;
+	struct ath_descdma bdma;
+	struct ath_txq *cabq;
+	struct list_head bbuf;
+};
+
+void ath9k_beacon_tasklet(unsigned long data);
+void ath_beacon_config(struct ath_softc *sc, int if_id);
+int ath_beaconq_setup(struct ath_hal *ah);
+int ath_beacon_alloc(struct ath_softc *sc, int if_id);
+void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp);
+void ath_beacon_sync(struct ath_softc *sc, int if_id);
+
+/*******/
+/* ANI */
+/*******/
 
-enum {
-	WLAN_RC_PHY_OFDM,
-	WLAN_RC_PHY_CCK,
-	WLAN_RC_PHY_HT_20_SS,
-	WLAN_RC_PHY_HT_20_DS,
-	WLAN_RC_PHY_HT_40_SS,
-	WLAN_RC_PHY_HT_40_DS,
-	WLAN_RC_PHY_HT_20_SS_HGI,
-	WLAN_RC_PHY_HT_20_DS_HGI,
-	WLAN_RC_PHY_HT_40_SS_HGI,
-	WLAN_RC_PHY_HT_40_DS_HGI,
-	WLAN_RC_PHY_MAX
-};
+/* ANI values for STA only.
+   FIXME: Add appropriate values for AP later */
 
-enum ath9k_tp_scale {
-	ATH9K_TP_SCALE_MAX = 0,
-	ATH9K_TP_SCALE_50,
-	ATH9K_TP_SCALE_25,
-	ATH9K_TP_SCALE_12,
-	ATH9K_TP_SCALE_MIN
-};
+#define ATH_ANI_POLLINTERVAL    100     /* 100 milliseconds between ANI poll */
+#define ATH_SHORT_CALINTERVAL   1000    /* 1 second between calibrations */
+#define ATH_LONG_CALINTERVAL    30000   /* 30 seconds between calibrations */
+#define ATH_RESTART_CALINTERVAL 1200000 /* 20 minutes between calibrations */
 
-enum ser_reg_mode {
-	SER_REG_MODE_OFF = 0,
-	SER_REG_MODE_ON = 1,
-	SER_REG_MODE_AUTO = 2,
+struct ath_ani {
+	bool sc_caldone;
+	int16_t sc_noise_floor;
+	unsigned int sc_longcal_timer;
+	unsigned int sc_shortcal_timer;
+	unsigned int sc_resetcal_timer;
+	unsigned int sc_checkani_timer;
+	struct timer_list timer;
 };
 
-#define AR_PHY_CCA_MAX_GOOD_VALUE      		-85
-#define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
-#define AR_PHY_CCA_MIN_BAD_VALUE       		-121
-#define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
-#define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
+/********************/
+/*   LED Control    */
+/********************/
 
-#define ATH9K_NF_CAL_HIST_MAX           5
-#define NUM_NF_READINGS                 6
+#define ATH_LED_PIN	1
+#define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
+#define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
 
-struct ath9k_nfcal_hist {
-	int16_t nfCalBuffer[ATH9K_NF_CAL_HIST_MAX];
-	u8 currIndex;
-	int16_t privNF;
-	u8 invalidNFcount;
+enum ath_led_type {
+	ATH_LED_RADIO,
+	ATH_LED_ASSOC,
+	ATH_LED_TX,
+	ATH_LED_RX
 };
 
-struct ath9k_beacon_state {
-	u32 bs_nexttbtt;
-	u32 bs_nextdtim;
-	u32 bs_intval;
-#define ATH9K_BEACON_PERIOD       0x0000ffff
-#define ATH9K_BEACON_ENA          0x00800000
-#define ATH9K_BEACON_RESET_TSF    0x01000000
-	u32 bs_dtimperiod;
-	u16 bs_cfpperiod;
-	u16 bs_cfpmaxduration;
-	u32 bs_cfpnext;
-	u16 bs_timoffset;
-	u16 bs_bmissthreshold;
-	u32 bs_sleepduration;
+struct ath_led {
+	struct ath_softc *sc;
+	struct led_classdev led_cdev;
+	enum ath_led_type led_type;
+	char name[32];
+	bool registered;
 };
 
-struct ath9k_node_stats {
-	u32 ns_avgbrssi;
-	u32 ns_avgrssi;
-	u32 ns_avgtxrssi;
-	u32 ns_avgtxrate;
-};
-
-#define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
-
-#define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
-#define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
-#define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
-#define AR_GPIO_OUTPUT_MUX_AS_TX_FRAME           3
-#define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
-#define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
+/* Rfkill */
+#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
 
-enum {
-	ATH9K_RESET_POWER_ON,
-	ATH9K_RESET_WARM,
-	ATH9K_RESET_COLD,
+struct ath_rfkill {
+	struct rfkill *rfkill;
+	struct delayed_work rfkill_poll;
+	char rfkill_name[32];
 };
 
-#define AH_USE_EEPROM   0x1
-
-struct ath_hal {
-	u32 ah_magic;
-	u16 ah_devid;
-	u16 ah_subvendorid;
-	u32 ah_macVersion;
-	u16 ah_macRev;
-	u16 ah_phyRev;
-	u16 ah_analog5GhzRev;
-	u16 ah_analog2GhzRev;
-
-	void __iomem *ah_sh;
-	struct ath_softc *ah_sc;
-
-	enum nl80211_iftype ah_opmode;
-	struct ath9k_ops_config ah_config;
-	struct ath9k_hw_capabilities ah_caps;
-
-	u16 ah_countryCode;
-	u32 ah_flags;
-	int16_t ah_powerLimit;
-	u16 ah_maxPowerLevel;
-	u32 ah_tpScale;
-	u16 ah_currentRD;
-	u16 ah_currentRDExt;
-	u16 ah_currentRDInUse;
-	char alpha2[2];
-	struct reg_dmn_pair_mapping *regpair;
-	enum ath9k_power_mode ah_power_mode;
-	enum ath9k_power_mode ah_restore_mode;
-
-	struct ath9k_channel ah_channels[38];
-	struct ath9k_channel *ah_curchan;
-
-	bool ah_isPciExpress;
-	u16 ah_txTrigLevel;
-	u16 ah_rfsilent;
-	u32 ah_rfkill_gpio;
-	u32 ah_rfkill_polarity;
-	u32 ah_btactive_gpio;
-	u32 ah_wlanactive_gpio;
-	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-
-	bool sw_mgmt_crypto;
-};
-
-struct chan_centers {
-	u16 synth_center;
-	u16 ctl_center;
-	u16 ext_center;
-};
+/********************/
+/* Main driver core */
+/********************/
 
-struct ath_rate_table;
-
-/* Helpers */
-
-bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val);
-u32 ath9k_hw_reverse_bits(u32 val, u32 n);
-bool ath9k_get_channel_edges(struct ath_hal *ah,
-			     u16 flags, u16 *low,
-			     u16 *high);
-u16 ath9k_hw_computetxtime(struct ath_hal *ah,
-			   struct ath_rate_table *rates,
-			   u32 frameLen, u16 rateix,
-			   bool shortPreamble);
-void ath9k_hw_get_channel_centers(struct ath_hal *ah,
-				  struct ath9k_channel *chan,
-				  struct chan_centers *centers);
-
-/* Attach, Detach */
-
-const char *ath9k_hw_probe(u16 vendorid, u16 devid);
-void ath9k_hw_detach(struct ath_hal *ah);
-struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
-				void __iomem *mem, int *error);
-void ath9k_hw_rfdetach(struct ath_hal *ah);
-
-
-/* HW Reset */
-
-int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
-		    bool bChannelChange);
-
-/* Key Cache Management */
-
-bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry);
-bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac);
-bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
-				 const struct ath9k_keyval *k,
-				 const u8 *mac, int xorKey);
-bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry);
-
-/* Power Management */
-
-bool ath9k_hw_setpower(struct ath_hal *ah,
-		       enum ath9k_power_mode mode);
-void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
-
-/* Beacon timers */
-
-void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period);
-void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
-				    const struct ath9k_beacon_state *bs);
-/* HW Capabilities */
-
-bool ath9k_hw_fill_cap_info(struct ath_hal *ah);
-bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 *result);
-bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 setting, int *status);
-
-/* GPIO / RFKILL / Antennae */
+/*
+ * Default cache line size, in bytes.
+ * Used when PCI device not fully initialized by bootrom/BIOS
+*/
+#define DEFAULT_CACHELINE       32
+#define	ATH_DEFAULT_NOISE_FLOOR -95
+#define ATH_REGCLASSIDS_MAX     10
+#define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
+#define ATH_MAX_SW_RETRIES      10
+#define ATH_CHAN_MAX            255
+#define IEEE80211_WEP_NKID      4       /* number of key ids */
 
-void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
-u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
-void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
-			 u32 ah_signal_type);
-void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hal *ah);
+/*
+ * The key cache is used for h/w cipher state and also for
+ * tracking station state such as the current tx antenna.
+ * We also setup a mapping table between key cache slot indices
+ * and station state to short-circuit node lookups on rx.
+ * Different parts have different size key caches.  We handle
+ * up to ATH_KEYMAX entries (could dynamically allocate state).
+ */
+#define	ATH_KEYMAX	        128     /* max key cache size we handle */
+
+#define ATH_IF_ID_ANY   	0xff
+#define ATH_TXPOWER_MAX         100     /* .5 dBm units */
+#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RATE_DUMMY_MARKER   0
+
+#define SC_OP_INVALID		BIT(0)
+#define SC_OP_BEACONS		BIT(1)
+#define SC_OP_RXAGGR		BIT(2)
+#define SC_OP_TXAGGR		BIT(3)
+#define SC_OP_CHAINMASK_UPDATE	BIT(4)
+#define SC_OP_FULL_RESET	BIT(5)
+#define SC_OP_NO_RESET		BIT(6)
+#define SC_OP_PREAMBLE_SHORT	BIT(7)
+#define SC_OP_PROTECT_ENABLE	BIT(8)
+#define SC_OP_RXFLUSH		BIT(9)
+#define SC_OP_LED_ASSOCIATED	BIT(10)
+#define SC_OP_RFKILL_REGISTERED	BIT(11)
+#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
+#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
+#define SC_OP_WAIT_FOR_BEACON	BIT(14)
+#define SC_OP_LED_ON		BIT(15)
+
+struct ath_bus_ops {
+	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+	void		(*cleanup)(struct ath_softc *sc);
+	bool		(*eeprom_read)(struct ath_hal *ah, u32 off, u16 *data);
+};
+
+struct ath_softc {
+	struct ieee80211_hw *hw;
+	struct device *dev;
+	struct tasklet_struct intr_tq;
+	struct tasklet_struct bcon_tasklet;
+	struct ath_hal *sc_ah;
+	void __iomem *mem;
+	int irq;
+	spinlock_t sc_resetlock;
+	struct mutex mutex;
+
+	u8 sc_curbssid[ETH_ALEN];
+	u8 sc_myaddr[ETH_ALEN];
+	u8 sc_bssidmask[ETH_ALEN];
+	u32 sc_intrstatus;
+	u32 sc_flags; /* SC_OP_* */
+	u16 sc_curtxpow;
+	u16 sc_curaid;
+	u16 sc_cachelsz;
+	u8 sc_nbcnvaps;
+	u16 sc_nvaps;
+	u8 sc_tx_chainmask;
+	u8 sc_rx_chainmask;
+	u32 sc_keymax;
+	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
+	u8 sc_splitmic;
+	atomic_t ps_usecount;
+	enum ath9k_int sc_imask;
+	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
+	enum ath9k_ht_macmode tx_chan_width;
+
+	struct ath_config sc_config;
+	struct ath_rx rx;
+	struct ath_tx tx;
+	struct ath_beacon beacon;
+	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
+	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
+	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
+	struct ath_rate_table *cur_rate_table;
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+
+	struct ath_led radio_led;
+	struct ath_led assoc_led;
+	struct ath_led tx_led;
+	struct ath_led rx_led;
+	struct delayed_work ath_led_blink_work;
+	int led_on_duration;
+	int led_off_duration;
+	int led_on_cnt;
+	int led_off_cnt;
+
+	struct ath_rfkill rf_kill;
+	struct ath_ani sc_ani;
+	struct ath9k_node_stats sc_halstats;
+#ifdef CONFIG_ATH9K_DEBUG
+	struct ath9k_debug sc_debug;
+#endif
+	struct ath_bus_ops *bus_ops;
+};
+
+int ath_reset(struct ath_softc *sc, bool retry_tx);
+int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
+int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
+int ath_cabq_update(struct ath_softc *);
+
+static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
+{
+	sc->bus_ops->read_cachesize(sc, csz);
+}
+
+static inline void ath_bus_cleanup(struct ath_softc *sc)
+{
+	sc->bus_ops->cleanup(sc);
+}
+
+extern struct ieee80211_ops ath9k_ops;
+
+irqreturn_t ath_isr(int irq, void *dev);
+void ath_cleanup(struct ath_softc *sc);
+int ath_attach(u16 devid, struct ath_softc *sc);
+void ath_detach(struct ath_softc *sc);
+const char *ath_mac_bb_name(u32 mac_bb_version);
+const char *ath_rf_name(u16 rf_version);
+
+#ifdef CONFIG_PCI
+int ath_pci_init(void);
+void ath_pci_exit(void);
+#else
+static inline int ath_pci_init(void) { return 0; };
+static inline void ath_pci_exit(void) {};
 #endif
-u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
-void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna);
-bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
-			       enum ath9k_ant_setting settings,
-			       struct ath9k_channel *chan,
-			       u8 *tx_chainmask,
-			       u8 *rx_chainmask,
-			       u8 *antenna_cfgd);
-
-/* General Operation */
-
-u32 ath9k_hw_getrxfilter(struct ath_hal *ah);
-void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits);
-bool ath9k_hw_phy_disable(struct ath_hal *ah);
-bool ath9k_hw_disable(struct ath_hal *ah);
-bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
-void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac);
-bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
-void ath9k_hw_setopmode(struct ath_hal *ah);
-void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1);
-void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask);
-bool ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask);
-void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid, u16 assocId);
-u64 ath9k_hw_gettsf64(struct ath_hal *ah);
-void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64);
-void ath9k_hw_reset_tsf(struct ath_hal *ah);
-bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting);
-bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us);
-void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
-
-/* Regulatory */
-u16 ath9k_regd_get_rd(struct ath_hal *ah);
-bool ath9k_is_world_regd(struct ath_hal *ah);
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah);
-const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
-
-void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby);
-void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
-
-int ath9k_regd_init(struct ath_hal *ah);
-bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah);
-u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
-int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
-
-/* ANI */
-
-void ath9k_ani_reset(struct ath_hal *ah);
-void ath9k_hw_ani_monitor(struct ath_hal *ah,
-			  const struct ath9k_node_stats *stats,
-			  struct ath9k_channel *chan);
-bool ath9k_hw_phycounters(struct ath_hal *ah);
-void ath9k_enable_mib_counters(struct ath_hal *ah);
-void ath9k_hw_disable_mib_counters(struct ath_hal *ah);
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
-				  u32 *rxc_pcnt,
-				  u32 *rxf_pcnt,
-				  u32 *txf_pcnt);
-void ath9k_hw_procmibevent(struct ath_hal *ah,
-			   const struct ath9k_node_stats *stats);
-void ath9k_hw_ani_setup(struct ath_hal *ah);
-void ath9k_hw_ani_attach(struct ath_hal *ah);
-void ath9k_hw_ani_detach(struct ath_hal *ah);
-
-/* Calibration */
-
-bool ath9k_hw_reset_calvalid(struct ath_hal *ah);
-void ath9k_hw_start_nfcal(struct ath_hal *ah);
-void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan);
-int16_t ath9k_hw_getnf(struct ath_hal *ah,
-		       struct ath9k_channel *chan);
-void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah);
-s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan);
-bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal,
-			bool *isCalDone);
-bool ath9k_hw_init_cal(struct ath_hal *ah,
-		       struct ath9k_channel *chan);
-
-
-/* EEPROM */
-
-int ath9k_hw_set_txpower(struct ath_hal *ah,
-			 struct ath9k_channel *chan,
-			 u16 cfgCtl,
-			 u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower,
-			 u8 powerLimit);
-void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan);
-bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
-				       struct ath9k_channel *chan,
-				       int16_t *ratesArray,
-				       u16 cfgCtl,
-				       u8 AntennaReduction,
-				       u8 twiceMaxRegulatoryPower,
-				       u8 powerLimit);
-bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset);
-bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
-				      struct ath9k_channel *chan);
-u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
-				    struct ath9k_channel *chan);
-u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
-			       enum ieee80211_band freq_band);
-u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz);
-int ath9k_hw_eeprom_attach(struct ath_hal *ah);
-
-/* Interrupt Handling */
-
-bool ath9k_hw_intrpend(struct ath_hal *ah);
-bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked);
-enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah);
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints);
-
-/* MAC (PCU/QCU) */
-
-u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q);
-bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp);
-bool ath9k_hw_txstart(struct ath_hal *ah, u32 q);
-u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q);
-bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel);
-bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q);
-bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-			 u32 segLen, bool firstSeg,
-			 bool lastSeg, const struct ath_desc *ds0);
-void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
-int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
-			    u32 keyIx, enum ath9k_key_type keyType, u32 flags);
-void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
-				  struct ath_desc *lastds,
-				  u32 durUpdateEn, u32 rtsctsRate,
-				  u32 rtsctsDuration,
-				  struct ath9k_11n_rate_series series[],
-				  u32 nseries, u32 flags);
-void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
-				u32 aggrLen);
-void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
-				 u32 numDelims);
-void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds);
-void ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
-				   u32 burstDuration);
-void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
-				     u32 vmf);
-void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs);
-bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
-			    const struct ath9k_tx_queue_info *qinfo);
-bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
-			    struct ath9k_tx_queue_info *qinfo);
-int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
-			  const struct ath9k_tx_queue_info *qinfo);
-bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q);
-bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q);
-int ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
-			u32 pa, struct ath_desc *nds, u64 tsf);
-bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
-			  u32 size, u32 flags);
-bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
-void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp);
-void ath9k_hw_rxena(struct ath_hal *ah);
-void ath9k_hw_startpcureceive(struct ath_hal *ah);
-void ath9k_hw_stoppcurecv(struct ath_hal *ah);
-bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
-void ath9k_hw_btcoex_enable(struct ath_hal *ah);
 
+#ifdef CONFIG_ATHEROS_AR71XX
+int ath_ahb_init(void);
+void ath_ahb_exit(void);
+#else
+static inline int ath_ahb_init(void) { return 0; };
+static inline void ath_ahb_exit(void) {};
 #endif
+
+static inline void ath9k_ps_wakeup(struct ath_softc *sc)
+{
+	if (atomic_inc_return(&sc->ps_usecount) == 1)
+		if (sc->sc_ah->ah_power_mode !=  ATH9K_PM_AWAKE) {
+			sc->sc_ah->ah_restore_mode = sc->sc_ah->ah_power_mode;
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+		}
+}
+
+static inline void ath9k_ps_restore(struct ath_softc *sc)
+{
+	if (atomic_dec_and_test(&sc->ps_usecount))
+		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
+			ath9k_hw_setpower(sc->sc_ah,
+					  sc->sc_ah->ah_restore_mode);
+}
+#endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 61d37be..1f92ad7 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
+#include "ath9k.h"
 
 /*
  *  This function will modify certain transmit queue properties depending on
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 69ff01c..016302c 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath9k/calib.h
new file mode 100644
index 0000000..ac7d88f
--- /dev/null
+++ b/drivers/net/wireless/ath9k/calib.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#ifndef CALIB_H
+#define CALIB_H
+
+extern const struct hal_percal_data iq_cal_multi_sample;
+extern const struct hal_percal_data iq_cal_single_sample;
+extern const struct hal_percal_data adc_gain_cal_multi_sample;
+extern const struct hal_percal_data adc_gain_cal_single_sample;
+extern const struct hal_percal_data adc_dc_cal_multi_sample;
+extern const struct hal_percal_data adc_dc_cal_single_sample;
+extern const struct hal_percal_data adc_init_dc_cal;
+
+#define AR_PHY_CCA_MAX_GOOD_VALUE      		-85
+#define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
+#define AR_PHY_CCA_MIN_BAD_VALUE       		-121
+#define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
+#define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
+
+#define NUM_NF_READINGS       6
+#define ATH9K_NF_CAL_HIST_MAX 5
+
+struct ar5416IniArray {
+	u32 *ia_array;
+	u32 ia_rows;
+	u32 ia_columns;
+};
+
+#define INIT_INI_ARRAY(iniarray, array, rows, columns) do {	\
+		(iniarray)->ia_array = (u32 *)(array);		\
+		(iniarray)->ia_rows = (rows);			\
+		(iniarray)->ia_columns = (columns);		\
+	} while (0)
+
+#define INI_RA(iniarray, row, column) \
+	(((iniarray)->ia_array)[(row) *	((iniarray)->ia_columns) + (column)])
+
+#define INIT_CAL(_perCal) do {				\
+		(_perCal)->calState = CAL_WAITING;	\
+		(_perCal)->calNext = NULL;		\
+	} while (0)
+
+#define INSERT_CAL(_ahp, _perCal)					\
+	do {								\
+		if ((_ahp)->ah_cal_list_last == NULL) {			\
+			(_ahp)->ah_cal_list =				\
+				(_ahp)->ah_cal_list_last = (_perCal);	\
+			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
+		} else {						\
+			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
+			(_ahp)->ah_cal_list_last = (_perCal);		\
+			(_perCal)->calNext = (_ahp)->ah_cal_list;	\
+		}							\
+	} while (0)
+
+enum hal_cal_types {
+	ADC_DC_INIT_CAL = 0x1,
+	ADC_GAIN_CAL = 0x2,
+	ADC_DC_CAL = 0x4,
+	IQ_MISMATCH_CAL = 0x8
+};
+
+enum hal_cal_state {
+	CAL_INACTIVE,
+	CAL_WAITING,
+	CAL_RUNNING,
+	CAL_DONE
+};
+
+#define MIN_CAL_SAMPLES     1
+#define MAX_CAL_SAMPLES    64
+#define INIT_LOG_COUNT      5
+#define PER_MIN_LOG_COUNT   2
+#define PER_MAX_LOG_COUNT  10
+
+struct hal_percal_data {
+	enum hal_cal_types calType;
+	u32 calNumSamples;
+	u32 calCountMax;
+	void (*calCollect) (struct ath_hal *);
+	void (*calPostProc) (struct ath_hal *, u8);
+};
+
+struct hal_cal_list {
+	const struct hal_percal_data *calData;
+	enum hal_cal_state calState;
+	struct hal_cal_list *calNext;
+};
+
+struct ath9k_nfcal_hist {
+	int16_t nfCalBuffer[ATH9K_NF_CAL_HIST_MAX];
+	u8 currIndex;
+	int16_t privNF;
+	u8 invalidNFcount;
+};
+
+bool ath9k_hw_reset_calvalid(struct ath_hal *ah);
+void ath9k_hw_start_nfcal(struct ath_hal *ah);
+void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan);
+int16_t ath9k_hw_getnf(struct ath_hal *ah,
+		       struct ath9k_channel *chan);
+void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah);
+s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan);
+bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
+			u8 rxchainmask, bool longcal,
+			bool *isCalDone);
+bool ath9k_hw_init_cal(struct ath_hal *ah,
+		       struct ath9k_channel *chan);
+
+#endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
deleted file mode 100644
index 64fc5c2..0000000
--- a/drivers/net/wireless/ath9k/core.h
+++ /dev/null
@@ -1,821 +0,0 @@
-/*
- * Copyright (c) 2008 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
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
-#ifndef CORE_H
-#define CORE_H
-
-#include <linux/etherdevice.h>
-#include <linux/device.h>
-#include <net/mac80211.h>
-#include <linux/leds.h>
-#include <linux/rfkill.h>
-
-#include "ath9k.h"
-#include "rc.h"
-
-struct ath_node;
-
-/* Macro to expand scalars to 64-bit objects */
-
-#define	ito64(x) (sizeof(x) == 8) ?			\
-	(((unsigned long long int)(x)) & (0xff)) :	\
-	(sizeof(x) == 16) ?				\
-	(((unsigned long long int)(x)) & 0xffff) :	\
-	((sizeof(x) == 32) ?				\
-	 (((unsigned long long int)(x)) & 0xffffffff) : \
-	 (unsigned long long int)(x))
-
-/* increment with wrap-around */
-#define INCR(_l, _sz)   do {			\
-		(_l)++;				\
-		(_l) &= ((_sz) - 1);		\
-	} while (0)
-
-/* decrement with wrap-around */
-#define DECR(_l,  _sz)  do {			\
-		(_l)--;				\
-		(_l) &= ((_sz) - 1);		\
-	} while (0)
-
-#define A_MAX(a, b) ((a) > (b) ? (a) : (b))
-
-#define ASSERT(exp) do {			\
-		if (unlikely(!(exp))) {		\
-			BUG();			\
-		}				\
-	} while (0)
-
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
-#define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
-
-static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-
-enum ATH_DEBUG {
-	ATH_DBG_RESET		= 0x00000001,
-	ATH_DBG_REG_IO		= 0x00000002,
-	ATH_DBG_QUEUE		= 0x00000004,
-	ATH_DBG_EEPROM		= 0x00000008,
-	ATH_DBG_CALIBRATE	= 0x00000010,
-	ATH_DBG_CHANNEL		= 0x00000020,
-	ATH_DBG_INTERRUPT	= 0x00000040,
-	ATH_DBG_REGULATORY	= 0x00000080,
-	ATH_DBG_ANI		= 0x00000100,
-	ATH_DBG_POWER_MGMT	= 0x00000200,
-	ATH_DBG_XMIT		= 0x00000400,
-	ATH_DBG_BEACON		= 0x00001000,
-	ATH_DBG_CONFIG		= 0x00002000,
-	ATH_DBG_KEYCACHE	= 0x00004000,
-	ATH_DBG_FATAL		= 0x00008000,
-	ATH_DBG_ANY		= 0xffffffff
-};
-
-#define DBG_DEFAULT (ATH_DBG_FATAL)
-
-#ifdef CONFIG_ATH9K_DEBUG
-
-/**
- * struct ath_interrupt_stats - Contains statistics about interrupts
- * @total: Total no. of interrupts generated so far
- * @rxok: RX with no errors
- * @rxeol: RX with no more RXDESC available
- * @rxorn: RX FIFO overrun
- * @txok: TX completed at the requested rate
- * @txurn: TX FIFO underrun
- * @mib: MIB regs reaching its threshold
- * @rxphyerr: RX with phy errors
- * @rx_keycache_miss: RX with key cache misses
- * @swba: Software Beacon Alert
- * @bmiss: Beacon Miss
- * @bnr: Beacon Not Ready
- * @cst: Carrier Sense TImeout
- * @gtt: Global TX Timeout
- * @tim: RX beacon TIM occurrence
- * @cabend: RX End of CAB traffic
- * @dtimsync: DTIM sync lossage
- * @dtim: RX Beacon with DTIM
- */
-struct ath_interrupt_stats {
-	u32 total;
-	u32 rxok;
-	u32 rxeol;
-	u32 rxorn;
-	u32 txok;
-	u32 txeol;
-	u32 txurn;
-	u32 mib;
-	u32 rxphyerr;
-	u32 rx_keycache_miss;
-	u32 swba;
-	u32 bmiss;
-	u32 bnr;
-	u32 cst;
-	u32 gtt;
-	u32 tim;
-	u32 cabend;
-	u32 dtimsync;
-	u32 dtim;
-};
-
-struct ath_legacy_rc_stats {
-	u32 success;
-};
-
-struct ath_11n_rc_stats {
-	u32 success;
-	u32 retries;
-	u32 xretries;
-};
-
-struct ath_stats {
-	struct ath_interrupt_stats istats;
-	struct ath_legacy_rc_stats legacy_rcstats[12]; /* max(11a,11b,11g) */
-	struct ath_11n_rc_stats n_rcstats[16]; /* 0..15 MCS rates */
-};
-
-struct ath9k_debug {
-	int debug_mask;
-	struct dentry *debugfs_root;
-	struct dentry *debugfs_phy;
-	struct dentry *debugfs_dma;
-	struct dentry *debugfs_interrupt;
-	struct dentry *debugfs_rcstat;
-	struct ath_stats stats;
-};
-
-void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
-int ath9k_init_debug(struct ath_softc *sc);
-void ath9k_exit_debug(struct ath_softc *sc);
-void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
-void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
-void ath_debug_stat_retries(struct ath_softc *sc, int rix,
-			    int xretries, int retries);
-
-#else
-
-static inline void DPRINTF(struct ath_softc *sc, int dbg_mask,
-			   const char *fmt, ...)
-{
-}
-
-static inline int ath9k_init_debug(struct ath_softc *sc)
-{
-	return 0;
-}
-
-static inline void ath9k_exit_debug(struct ath_softc *sc)
-{
-}
-
-static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
-					    enum ath9k_int status)
-{
-}
-
-static inline void ath_debug_stat_rc(struct ath_softc *sc,
-				     struct sk_buff *skb)
-{
-}
-
-static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
-					  int xretries, int retries)
-{
-}
-
-#endif /* CONFIG_ATH9K_DEBUG */
-
-struct ath_config {
-	u32 ath_aggr_prot;
-	u16 txpowlimit;
-	u8 cabqReadytime;
-	u8 swBeaconProcess;
-};
-
-/*************************/
-/* Descriptor Management */
-/*************************/
-
-#define ATH_TXBUF_RESET(_bf) do {				\
-		(_bf)->bf_status = 0;				\
-		(_bf)->bf_lastbf = NULL;			\
-		(_bf)->bf_next = NULL;				\
-		memset(&((_bf)->bf_state), 0,			\
-		       sizeof(struct ath_buf_state));		\
-	} while (0)
-
-/**
- * enum buffer_type - Buffer type flags
- *
- * @BUF_HT: Send this buffer using HT capabilities
- * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
- * @BUF_AGGR: Indicates whether the buffer can be aggregated
- *	(used in aggregation scheduling)
- * @BUF_RETRY: Indicates whether the buffer is retried
- * @BUF_XRETRY: To denote excessive retries of the buffer
- */
-enum buffer_type {
-	BUF_HT			= BIT(1),
-	BUF_AMPDU		= BIT(2),
-	BUF_AGGR		= BIT(3),
-	BUF_RETRY		= BIT(4),
-	BUF_XRETRY		= BIT(5),
-};
-
-struct ath_buf_state {
-	int bfs_nframes;		/* # frames in aggregate */
-	u16 bfs_al;			/* length of aggregate */
-	u16 bfs_frmlen;			/* length of frame */
-	int bfs_seqno;			/* sequence number */
-	int bfs_tidno;			/* tid of this frame */
-	int bfs_retries;		/* current retries */
-	u32 bf_type;			/* BUF_* (enum buffer_type) */
-	u32 bfs_keyix;
-	enum ath9k_key_type bfs_keytype;
-};
-
-#define bf_nframes      	bf_state.bfs_nframes
-#define bf_al           	bf_state.bfs_al
-#define bf_frmlen       	bf_state.bfs_frmlen
-#define bf_retries      	bf_state.bfs_retries
-#define bf_seqno        	bf_state.bfs_seqno
-#define bf_tidno        	bf_state.bfs_tidno
-#define bf_keyix                bf_state.bfs_keyix
-#define bf_keytype      	bf_state.bfs_keytype
-#define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
-#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
-#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
-#define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
-#define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
-
-/*
- * Abstraction of a contiguous buffer to transmit/receive.  There is only
- * a single hw descriptor encapsulated here.
- */
-struct ath_buf {
-	struct list_head list;
-	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
-					   an aggregate) */
-	struct ath_buf *bf_next;	/* next subframe in the aggregate */
-	void *bf_mpdu;			/* enclosing frame structure */
-	struct ath_desc *bf_desc;	/* virtual addr of desc */
-	dma_addr_t bf_daddr;		/* physical addr of desc */
-	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
-	u32 bf_status;
-	u16 bf_flags;			/* tx descriptor flags */
-	struct ath_buf_state bf_state;	/* buffer state */
-	dma_addr_t bf_dmacontext;
-};
-
-#define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
-#define ATH_BUFSTATUS_STALE     0x00000002
-
-/* DMA state for tx/rx descriptors */
-
-struct ath_descdma {
-	const char *dd_name;
-	struct ath_desc *dd_desc;	/* descriptors  */
-	dma_addr_t dd_desc_paddr;	/* physical addr of dd_desc  */
-	u32 dd_desc_len;		/* size of dd_desc  */
-	struct ath_buf *dd_bufptr;	/* associated buffers */
-	dma_addr_t dd_dmacontext;
-};
-
-int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
-		      struct list_head *head, const char *name,
-		      int nbuf, int ndesc);
-void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
-			 struct list_head *head);
-
-/***********/
-/* RX / TX */
-/***********/
-
-#define ATH_MAX_ANTENNA         3
-#define ATH_RXBUF               512
-#define WME_NUM_TID             16
-#define ATH_TXBUF               512
-#define ATH_TXMAXTRY            13
-#define ATH_11N_TXMAXTRY        10
-#define ATH_MGT_TXMAXTRY        4
-#define WME_BA_BMP_SIZE         64
-#define WME_MAX_BA              WME_BA_BMP_SIZE
-#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
-
-#define TID_TO_WME_AC(_tid)				\
-	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
-	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
-	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
-	 WME_AC_VO)
-
-#define WME_AC_BE   0
-#define WME_AC_BK   1
-#define WME_AC_VI   2
-#define WME_AC_VO   3
-#define WME_NUM_AC  4
-
-#define ADDBA_EXCHANGE_ATTEMPTS    10
-#define ATH_AGGR_DELIM_SZ          4
-#define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
-/* number of delimiters for encryption padding */
-#define ATH_AGGR_ENCRYPTDELIM      10
-/* minimum h/w qdepth to be sustained to maximize aggregation */
-#define ATH_AGGR_MIN_QDEPTH        2
-#define ATH_AMPDU_SUBFRAME_DEFAULT 32
-#define IEEE80211_SEQ_SEQ_SHIFT    4
-#define IEEE80211_SEQ_MAX          4096
-#define IEEE80211_MIN_AMPDU_BUF    0x8
-#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
-
-/* return whether a bit at index _n in bitmap _bm is set
- * _sz is the size of the bitmap  */
-#define ATH_BA_ISSET(_bm, _n)  (((_n) < (WME_BA_BMP_SIZE)) &&		\
-				((_bm)[(_n) >> 5] & (1 << ((_n) & 31))))
-
-/* return block-ack bitmap index given sequence and starting sequence */
-#define ATH_BA_INDEX(_st, _seq) (((_seq) - (_st)) & (IEEE80211_SEQ_MAX - 1))
-
-/* returns delimiter padding required given the packet length */
-#define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
-
-#define BAW_WITHIN(_start, _bawsz, _seqno) \
-	((((_seqno) - (_start)) & 4095) < (_bawsz))
-
-#define ATH_DS_BA_SEQ(_ds)         ((_ds)->ds_us.tx.ts_seqnum)
-#define ATH_DS_BA_BITMAP(_ds)      (&(_ds)->ds_us.tx.ba_low)
-#define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
-#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
-
-enum ATH_AGGR_STATUS {
-	ATH_AGGR_DONE,
-	ATH_AGGR_BAW_CLOSED,
-	ATH_AGGR_LIMITED,
-};
-
-struct ath_txq {
-	u32 axq_qnum;			/* hardware q number */
-	u32 *axq_link;			/* link ptr in last TX desc */
-	struct list_head axq_q;		/* transmit queue */
-	spinlock_t axq_lock;
-	u32 axq_depth;			/* queue depth */
-	u8 axq_aggr_depth;		/* aggregates queued */
-	u32 axq_totalqueued;		/* total ever queued */
-	bool stopped;			/* Is mac80211 queue stopped ? */
-	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
-
-	/* first desc of the last descriptor that contains CTS */
-	struct ath_desc *axq_lastdsWithCTS;
-
-	/* final desc of the gating desc that determines whether
-	   lastdsWithCTS has been DMA'ed or not */
-	struct ath_desc *axq_gatingds;
-
-	struct list_head axq_acq;
-};
-
-#define AGGR_CLEANUP         BIT(1)
-#define AGGR_ADDBA_COMPLETE  BIT(2)
-#define AGGR_ADDBA_PROGRESS  BIT(3)
-
-/* per TID aggregate tx state for a destination */
-struct ath_atx_tid {
-	struct list_head list;		/* round-robin tid entry */
-	struct list_head buf_q;		/* pending buffers */
-	struct ath_node *an;
-	struct ath_atx_ac *ac;
-	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS]; /* active tx frames */
-	u16 seq_start;
-	u16 seq_next;
-	u16 baw_size;
-	int tidno;
-	int baw_head;			/* first un-acked tx buffer */
-	int baw_tail;			/* next unused tx buffer slot */
-	int sched;
-	int paused;
-	u8 state;
-	int addba_exchangeattempts;
-};
-
-/* per access-category aggregate tx state for a destination */
-struct ath_atx_ac {
-	int sched;			/* dest-ac is scheduled */
-	int qnum;			/* H/W queue number associated
-					   with this AC */
-	struct list_head list;		/* round-robin txq entry */
-	struct list_head tid_q;		/* queue of TIDs with buffers */
-};
-
-/* per-frame tx control block */
-struct ath_tx_control {
-	struct ath_txq *txq;
-	int if_id;
-};
-
-/* per frame tx status block */
-struct ath_xmit_status {
-	int retries;	/* number of retries to successufully
-			   transmit this frame */
-	int flags;	/* status of transmit */
-#define ATH_TX_ERROR        0x01
-#define ATH_TX_XRETRY       0x02
-#define ATH_TX_BAR          0x04
-};
-
-/* All RSSI values are noise floor adjusted */
-struct ath_tx_stat {
-	int rssi;
-	int rssictl[ATH_MAX_ANTENNA];
-	int rssiextn[ATH_MAX_ANTENNA];
-	int rateieee;
-	int rateKbps;
-	int ratecode;
-	int flags;
-	u32 airtime;	/* time on air per final tx rate */
-};
-
-struct aggr_rifs_param {
-	int param_max_frames;
-	int param_max_len;
-	int param_rl;
-	int param_al;
-	struct ath_rc_series *param_rcs;
-};
-
-struct ath_node {
-	struct ath_softc *an_sc;
-	struct ath_atx_tid tid[WME_NUM_TID];
-	struct ath_atx_ac ac[WME_NUM_AC];
-	u16 maxampdu;
-	u8 mpdudensity;
-};
-
-struct ath_tx {
-	u16 seq_no;
-	u32 txqsetup;
-	int hwq_map[ATH9K_WME_AC_VO+1];
-	spinlock_t txbuflock;
-	struct list_head txbuf;
-	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
-	struct ath_descdma txdma;
-};
-
-struct ath_rx {
-	u8 defant;
-	u8 rxotherant;
-	u32 *rxlink;
-	int bufsize;
-	unsigned int rxfilter;
-	spinlock_t rxflushlock;
-	spinlock_t rxbuflock;
-	struct list_head rxbuf;
-	struct ath_descdma rxdma;
-};
-
-int ath_startrecv(struct ath_softc *sc);
-bool ath_stoprecv(struct ath_softc *sc);
-void ath_flushrecv(struct ath_softc *sc);
-u32 ath_calcrxfilter(struct ath_softc *sc);
-int ath_rx_init(struct ath_softc *sc, int nbufs);
-void ath_rx_cleanup(struct ath_softc *sc);
-int ath_rx_tasklet(struct ath_softc *sc, int flush);
-struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
-void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
-int ath_tx_setup(struct ath_softc *sc, int haltype);
-void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
-void ath_draintxq(struct ath_softc *sc,
-		     struct ath_txq *txq, bool retry_tx);
-void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
-void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
-void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
-int ath_tx_init(struct ath_softc *sc, int nbufs);
-int ath_tx_cleanup(struct ath_softc *sc);
-struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
-int ath_txq_update(struct ath_softc *sc, int qnum,
-		   struct ath9k_tx_queue_info *q);
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
-		 struct ath_tx_control *txctl);
-void ath_tx_tasklet(struct ath_softc *sc);
-void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
-bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		      u16 tid, u16 *ssn);
-int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
-void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
-
-/********/
-/* VAPs */
-/********/
-
-/*
- * Define the scheme that we select MAC address for multiple
- * BSS on the same radio. The very first VAP will just use the MAC
- * address from the EEPROM. For the next 3 VAPs, we set the
- * U/L bit (bit 1) in MAC address, and use the next two bits as the
- * index of the VAP.
- */
-
-#define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
-	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
-
-struct ath_vap {
-	int av_bslot;
-	enum nl80211_iftype av_opmode;
-	struct ath_buf *av_bcbuf;
-	struct ath_tx_control av_btxctl;
-};
-
-/*******************/
-/* Beacon Handling */
-/*******************/
-
-/*
- * Regardless of the number of beacons we stagger, (i.e. regardless of the
- * number of BSSIDs) if a given beacon does not go out even after waiting this
- * number of beacon intervals, the game's up.
- */
-#define BSTUCK_THRESH           	(9 * ATH_BCBUF)
-#define	ATH_BCBUF               	1
-#define ATH_DEFAULT_BINTVAL     	100 /* TU */
-#define ATH_DEFAULT_BMISS_LIMIT 	10
-#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
-
-struct ath_beacon_config {
-	u16 beacon_interval;
-	u16 listen_interval;
-	u16 dtim_period;
-	u16 bmiss_timeout;
-	u8 dtim_count;
-	u8 tim_offset;
-	union {
-		u64 last_tsf;
-		u8 last_tstamp[8];
-	} u; /* last received beacon/probe response timestamp of this BSS. */
-};
-
-struct ath_beacon {
-	enum {
-		OK,		/* no change needed */
-		UPDATE,		/* update pending */
-		COMMIT		/* beacon sent, commit change */
-	} updateslot;		/* slot time update fsm */
-
-	u32 beaconq;
-	u32 bmisscnt;
-	u32 ast_be_xmit;
-	u64 bc_tstamp;
-	int bslot[ATH_BCBUF];
-	int slottime;
-	int slotupdate;
-	struct ath9k_tx_queue_info beacon_qi;
-	struct ath_descdma bdma;
-	struct ath_txq *cabq;
-	struct list_head bbuf;
-};
-
-void ath9k_beacon_tasklet(unsigned long data);
-void ath_beacon_config(struct ath_softc *sc, int if_id);
-int ath_beaconq_setup(struct ath_hal *ah);
-int ath_beacon_alloc(struct ath_softc *sc, int if_id);
-void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp);
-void ath_beacon_sync(struct ath_softc *sc, int if_id);
-
-/*******/
-/* ANI */
-/*******/
-
-/* ANI values for STA only.
-   FIXME: Add appropriate values for AP later */
-
-#define ATH_ANI_POLLINTERVAL    100     /* 100 milliseconds between ANI poll */
-#define ATH_SHORT_CALINTERVAL   1000    /* 1 second between calibrations */
-#define ATH_LONG_CALINTERVAL    30000   /* 30 seconds between calibrations */
-#define ATH_RESTART_CALINTERVAL 1200000 /* 20 minutes between calibrations */
-
-struct ath_ani {
-	bool sc_caldone;
-	int16_t sc_noise_floor;
-	unsigned int sc_longcal_timer;
-	unsigned int sc_shortcal_timer;
-	unsigned int sc_resetcal_timer;
-	unsigned int sc_checkani_timer;
-	struct timer_list timer;
-};
-
-/********************/
-/*   LED Control    */
-/********************/
-
-#define ATH_LED_PIN	1
-#define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
-#define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
-
-enum ath_led_type {
-	ATH_LED_RADIO,
-	ATH_LED_ASSOC,
-	ATH_LED_TX,
-	ATH_LED_RX
-};
-
-struct ath_led {
-	struct ath_softc *sc;
-	struct led_classdev led_cdev;
-	enum ath_led_type led_type;
-	char name[32];
-	bool registered;
-};
-
-/* Rfkill */
-#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
-
-struct ath_rfkill {
-	struct rfkill *rfkill;
-	struct delayed_work rfkill_poll;
-	char rfkill_name[32];
-};
-
-/********************/
-/* Main driver core */
-/********************/
-
-/*
- * Default cache line size, in bytes.
- * Used when PCI device not fully initialized by bootrom/BIOS
-*/
-#define DEFAULT_CACHELINE       32
-#define	ATH_DEFAULT_NOISE_FLOOR -95
-#define ATH_REGCLASSIDS_MAX     10
-#define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
-#define ATH_MAX_SW_RETRIES      10
-#define ATH_CHAN_MAX            255
-#define IEEE80211_WEP_NKID      4       /* number of key ids */
-
-/*
- * The key cache is used for h/w cipher state and also for
- * tracking station state such as the current tx antenna.
- * We also setup a mapping table between key cache slot indices
- * and station state to short-circuit node lookups on rx.
- * Different parts have different size key caches.  We handle
- * up to ATH_KEYMAX entries (could dynamically allocate state).
- */
-#define	ATH_KEYMAX	        128     /* max key cache size we handle */
-
-#define ATH_IF_ID_ANY   	0xff
-#define ATH_TXPOWER_MAX         100     /* .5 dBm units */
-#define ATH_RSSI_DUMMY_MARKER   0x127
-#define ATH_RATE_DUMMY_MARKER   0
-
-#define SC_OP_INVALID		BIT(0)
-#define SC_OP_BEACONS		BIT(1)
-#define SC_OP_RXAGGR		BIT(2)
-#define SC_OP_TXAGGR		BIT(3)
-#define SC_OP_CHAINMASK_UPDATE	BIT(4)
-#define SC_OP_FULL_RESET	BIT(5)
-#define SC_OP_NO_RESET		BIT(6)
-#define SC_OP_PREAMBLE_SHORT	BIT(7)
-#define SC_OP_PROTECT_ENABLE	BIT(8)
-#define SC_OP_RXFLUSH		BIT(9)
-#define SC_OP_LED_ASSOCIATED	BIT(10)
-#define SC_OP_RFKILL_REGISTERED	BIT(11)
-#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
-#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
-#define SC_OP_WAIT_FOR_BEACON	BIT(14)
-#define SC_OP_LED_ON		BIT(15)
-
-struct ath_bus_ops {
-	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
-	void		(*cleanup)(struct ath_softc *sc);
-	bool		(*eeprom_read)(struct ath_hal *ah, u32 off, u16 *data);
-};
-
-struct ath_softc {
-	struct ieee80211_hw *hw;
-	struct device *dev;
-	struct tasklet_struct intr_tq;
-	struct tasklet_struct bcon_tasklet;
-	struct ath_hal *sc_ah;
-	void __iomem *mem;
-	int irq;
-	spinlock_t sc_resetlock;
-	struct mutex mutex;
-
-	u8 sc_curbssid[ETH_ALEN];
-	u8 sc_myaddr[ETH_ALEN];
-	u8 sc_bssidmask[ETH_ALEN];
-	u32 sc_intrstatus;
-	u32 sc_flags; /* SC_OP_* */
-	u16 sc_curtxpow;
-	u16 sc_curaid;
-	u16 sc_cachelsz;
-	u8 sc_nbcnvaps;
-	u16 sc_nvaps;
-	u8 sc_tx_chainmask;
-	u8 sc_rx_chainmask;
-	u32 sc_keymax;
-	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
-	u8 sc_splitmic;
-	atomic_t ps_usecount;
-	enum ath9k_int sc_imask;
-	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
-	enum ath9k_ht_macmode tx_chan_width;
-
-	struct ath_config sc_config;
-	struct ath_rx rx;
-	struct ath_tx tx;
-	struct ath_beacon beacon;
-	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
-	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
-	struct ath_rate_table *cur_rate_table;
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-
-	struct ath_led radio_led;
-	struct ath_led assoc_led;
-	struct ath_led tx_led;
-	struct ath_led rx_led;
-	struct delayed_work ath_led_blink_work;
-	int led_on_duration;
-	int led_off_duration;
-	int led_on_cnt;
-	int led_off_cnt;
-
-	struct ath_rfkill rf_kill;
-	struct ath_ani sc_ani;
-	struct ath9k_node_stats sc_halstats;
-#ifdef CONFIG_ATH9K_DEBUG
-	struct ath9k_debug sc_debug;
-#endif
-	struct ath_bus_ops *bus_ops;
-};
-
-int ath_reset(struct ath_softc *sc, bool retry_tx);
-int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
-int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
-int ath_cabq_update(struct ath_softc *);
-
-static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
-{
-	sc->bus_ops->read_cachesize(sc, csz);
-}
-
-static inline void ath_bus_cleanup(struct ath_softc *sc)
-{
-	sc->bus_ops->cleanup(sc);
-}
-
-extern struct ieee80211_ops ath9k_ops;
-
-irqreturn_t ath_isr(int irq, void *dev);
-void ath_cleanup(struct ath_softc *sc);
-int ath_attach(u16 devid, struct ath_softc *sc);
-void ath_detach(struct ath_softc *sc);
-const char *ath_mac_bb_name(u32 mac_bb_version);
-const char *ath_rf_name(u16 rf_version);
-
-#ifdef CONFIG_PCI
-int ath_pci_init(void);
-void ath_pci_exit(void);
-#else
-static inline int ath_pci_init(void) { return 0; };
-static inline void ath_pci_exit(void) {};
-#endif
-
-#ifdef CONFIG_ATHEROS_AR71XX
-int ath_ahb_init(void);
-void ath_ahb_exit(void);
-#else
-static inline int ath_ahb_init(void) { return 0; };
-static inline void ath_ahb_exit(void) {};
-#endif
-
-static inline void ath9k_ps_wakeup(struct ath_softc *sc)
-{
-	if (atomic_inc_return(&sc->ps_usecount) == 1)
-		if (sc->sc_ah->ah_power_mode !=  ATH9K_PM_AWAKE) {
-			sc->sc_ah->ah_restore_mode = sc->sc_ah->ah_power_mode;
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-		}
-}
-
-static inline void ath9k_ps_restore(struct ath_softc *sc)
-{
-	if (atomic_dec_and_test(&sc->ps_usecount))
-		if (sc->hw->conf.flags & IEEE80211_CONF_PS)
-			ath9k_hw_setpower(sc->sc_ah,
-					  sc->sc_ah->ah_restore_mode);
-}
-#endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 2de1b8a..c9b47b3 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -14,9 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "reg.h"
-#include "hw.h"
+#include "ath9k.h"
 
 static unsigned int ath9k_debug = DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
diff --git a/drivers/net/wireless/ath9k/debug.h b/drivers/net/wireless/ath9k/debug.h
new file mode 100644
index 0000000..61e9698
--- /dev/null
+++ b/drivers/net/wireless/ath9k/debug.h
@@ -0,0 +1,153 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#ifndef DEBUG_H
+#define DEBUG_H
+
+enum ATH_DEBUG {
+	ATH_DBG_RESET		= 0x00000001,
+	ATH_DBG_REG_IO		= 0x00000002,
+	ATH_DBG_QUEUE		= 0x00000004,
+	ATH_DBG_EEPROM		= 0x00000008,
+	ATH_DBG_CALIBRATE	= 0x00000010,
+	ATH_DBG_CHANNEL		= 0x00000020,
+	ATH_DBG_INTERRUPT	= 0x00000040,
+	ATH_DBG_REGULATORY	= 0x00000080,
+	ATH_DBG_ANI		= 0x00000100,
+	ATH_DBG_POWER_MGMT	= 0x00000200,
+	ATH_DBG_XMIT		= 0x00000400,
+	ATH_DBG_BEACON		= 0x00001000,
+	ATH_DBG_CONFIG		= 0x00002000,
+	ATH_DBG_KEYCACHE	= 0x00004000,
+	ATH_DBG_FATAL		= 0x00008000,
+	ATH_DBG_ANY		= 0xffffffff
+};
+
+#define DBG_DEFAULT (ATH_DBG_FATAL)
+
+#ifdef CONFIG_ATH9K_DEBUG
+
+/**
+ * struct ath_interrupt_stats - Contains statistics about interrupts
+ * @total: Total no. of interrupts generated so far
+ * @rxok: RX with no errors
+ * @rxeol: RX with no more RXDESC available
+ * @rxorn: RX FIFO overrun
+ * @txok: TX completed at the requested rate
+ * @txurn: TX FIFO underrun
+ * @mib: MIB regs reaching its threshold
+ * @rxphyerr: RX with phy errors
+ * @rx_keycache_miss: RX with key cache misses
+ * @swba: Software Beacon Alert
+ * @bmiss: Beacon Miss
+ * @bnr: Beacon Not Ready
+ * @cst: Carrier Sense TImeout
+ * @gtt: Global TX Timeout
+ * @tim: RX beacon TIM occurrence
+ * @cabend: RX End of CAB traffic
+ * @dtimsync: DTIM sync lossage
+ * @dtim: RX Beacon with DTIM
+ */
+struct ath_interrupt_stats {
+	u32 total;
+	u32 rxok;
+	u32 rxeol;
+	u32 rxorn;
+	u32 txok;
+	u32 txeol;
+	u32 txurn;
+	u32 mib;
+	u32 rxphyerr;
+	u32 rx_keycache_miss;
+	u32 swba;
+	u32 bmiss;
+	u32 bnr;
+	u32 cst;
+	u32 gtt;
+	u32 tim;
+	u32 cabend;
+	u32 dtimsync;
+	u32 dtim;
+};
+
+struct ath_legacy_rc_stats {
+	u32 success;
+};
+
+struct ath_11n_rc_stats {
+	u32 success;
+	u32 retries;
+	u32 xretries;
+};
+
+struct ath_stats {
+	struct ath_interrupt_stats istats;
+	struct ath_legacy_rc_stats legacy_rcstats[12]; /* max(11a,11b,11g) */
+	struct ath_11n_rc_stats n_rcstats[16]; /* 0..15 MCS rates */
+};
+
+struct ath9k_debug {
+	int debug_mask;
+	struct dentry *debugfs_root;
+	struct dentry *debugfs_phy;
+	struct dentry *debugfs_dma;
+	struct dentry *debugfs_interrupt;
+	struct dentry *debugfs_rcstat;
+	struct ath_stats stats;
+};
+
+void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
+int ath9k_init_debug(struct ath_softc *sc);
+void ath9k_exit_debug(struct ath_softc *sc);
+void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
+void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
+void ath_debug_stat_retries(struct ath_softc *sc, int rix,
+			    int xretries, int retries);
+
+#else
+
+static inline void DPRINTF(struct ath_softc *sc, int dbg_mask,
+			   const char *fmt, ...)
+{
+}
+
+static inline int ath9k_init_debug(struct ath_softc *sc)
+{
+	return 0;
+}
+
+static inline void ath9k_exit_debug(struct ath_softc *sc)
+{
+}
+
+static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
+					    enum ath9k_int status)
+{
+}
+
+static inline void ath_debug_stat_rc(struct ath_softc *sc,
+				     struct sk_buff *skb)
+{
+}
+
+static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
+					  int xretries, int retries)
+{
+}
+
+#endif /* CONFIG_ATH9K_DEBUG */
+
+#endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 5038907..aa62409 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 
 static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
 				      u32 reg, u32 mask,
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
new file mode 100644
index 0000000..9eb7774
--- /dev/null
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -0,0 +1,484 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#ifndef EEPROM_H
+#define EEPROM_H
+
+#define AH_USE_EEPROM   0x1
+
+#ifdef __BIG_ENDIAN
+#define AR5416_EEPROM_MAGIC 0x5aa5
+#else
+#define AR5416_EEPROM_MAGIC 0xa55a
+#endif
+
+#define CTRY_DEBUG   0x1ff
+#define	CTRY_DEFAULT 0
+
+#define AR_EEPROM_EEPCAP_COMPRESS_DIS   0x0001
+#define AR_EEPROM_EEPCAP_AES_DIS        0x0002
+#define AR_EEPROM_EEPCAP_FASTFRAME_DIS  0x0004
+#define AR_EEPROM_EEPCAP_BURST_DIS      0x0008
+#define AR_EEPROM_EEPCAP_MAXQCU         0x01F0
+#define AR_EEPROM_EEPCAP_MAXQCU_S       4
+#define AR_EEPROM_EEPCAP_HEAVY_CLIP_EN  0x0200
+#define AR_EEPROM_EEPCAP_KC_ENTRIES     0xF000
+#define AR_EEPROM_EEPCAP_KC_ENTRIES_S   12
+
+#define AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND   0x0040
+#define AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN    0x0080
+#define AR_EEPROM_EEREGCAP_EN_KK_U2         0x0100
+#define AR_EEPROM_EEREGCAP_EN_KK_MIDBAND    0x0200
+#define AR_EEPROM_EEREGCAP_EN_KK_U1_ODD     0x0400
+#define AR_EEPROM_EEREGCAP_EN_KK_NEW_11A    0x0800
+
+#define AR_EEPROM_EEREGCAP_EN_KK_U1_ODD_PRE4_0  0x4000
+#define AR_EEPROM_EEREGCAP_EN_KK_NEW_11A_PRE4_0 0x8000
+
+#define AR5416_EEPROM_MAGIC_OFFSET  0x0
+#define AR5416_EEPROM_S             2
+#define AR5416_EEPROM_OFFSET        0x2000
+#define AR5416_EEPROM_MAX           0xae0
+
+#define AR5416_EEPROM_START_ADDR \
+	(AR_SREV_9100(ah)) ? 0x1fff1000 : 0x503f1200
+
+#define SD_NO_CTL               0xE0
+#define NO_CTL                  0xff
+#define CTL_MODE_M              7
+#define CTL_11A                 0
+#define CTL_11B                 1
+#define CTL_11G                 2
+#define CTL_2GHT20              5
+#define CTL_5GHT20              6
+#define CTL_2GHT40              7
+#define CTL_5GHT40              8
+
+#define EXT_ADDITIVE (0x8000)
+#define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
+#define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
+#define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
+
+#define SUB_NUM_CTL_MODES_AT_5G_40 2
+#define SUB_NUM_CTL_MODES_AT_2G_40 3
+
+#define AR_EEPROM_MAC(i)	(0x1d+(i))
+#define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
+#define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
+#define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
+
+#define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
+#define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
+#define AR_EEPROM_RFSILENT_POLARITY     0x0002
+#define AR_EEPROM_RFSILENT_POLARITY_S   1
+
+#define EEP_RFSILENT_ENABLED        0x0001
+#define EEP_RFSILENT_ENABLED_S      0
+#define EEP_RFSILENT_POLARITY       0x0002
+#define EEP_RFSILENT_POLARITY_S     1
+#define EEP_RFSILENT_GPIO_SEL       0x001c
+#define EEP_RFSILENT_GPIO_SEL_S     2
+
+#define AR5416_OPFLAGS_11A           0x01
+#define AR5416_OPFLAGS_11G           0x02
+#define AR5416_OPFLAGS_N_5G_HT40     0x04
+#define AR5416_OPFLAGS_N_2G_HT40     0x08
+#define AR5416_OPFLAGS_N_5G_HT20     0x10
+#define AR5416_OPFLAGS_N_2G_HT20     0x20
+
+#define AR5416_EEP_NO_BACK_VER       0x1
+#define AR5416_EEP_VER               0xE
+#define AR5416_EEP_VER_MINOR_MASK    0x0FFF
+#define AR5416_EEP_MINOR_VER_2       0x2
+#define AR5416_EEP_MINOR_VER_3       0x3
+#define AR5416_EEP_MINOR_VER_7       0x7
+#define AR5416_EEP_MINOR_VER_9       0x9
+#define AR5416_EEP_MINOR_VER_16      0x10
+#define AR5416_EEP_MINOR_VER_17      0x11
+#define AR5416_EEP_MINOR_VER_19      0x13
+#define AR5416_EEP_MINOR_VER_20      0x14
+
+#define AR5416_NUM_5G_CAL_PIERS         8
+#define AR5416_NUM_2G_CAL_PIERS         4
+#define AR5416_NUM_5G_20_TARGET_POWERS  8
+#define AR5416_NUM_5G_40_TARGET_POWERS  8
+#define AR5416_NUM_2G_CCK_TARGET_POWERS 3
+#define AR5416_NUM_2G_20_TARGET_POWERS  4
+#define AR5416_NUM_2G_40_TARGET_POWERS  4
+#define AR5416_NUM_CTLS                 24
+#define AR5416_NUM_BAND_EDGES           8
+#define AR5416_NUM_PD_GAINS             4
+#define AR5416_PD_GAINS_IN_MASK         4
+#define AR5416_PD_GAIN_ICEPTS           5
+#define AR5416_EEPROM_MODAL_SPURS       5
+#define AR5416_MAX_RATE_POWER           63
+#define AR5416_NUM_PDADC_VALUES         128
+#define AR5416_BCHAN_UNUSED             0xFF
+#define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
+#define AR5416_MAX_CHAINS               3
+#define AR5416_PWR_TABLE_OFFSET         -5
+
+/* Rx gain type values */
+#define AR5416_EEP_RXGAIN_23DB_BACKOFF     0
+#define AR5416_EEP_RXGAIN_13DB_BACKOFF     1
+#define AR5416_EEP_RXGAIN_ORIG             2
+
+/* Tx gain type values */
+#define AR5416_EEP_TXGAIN_ORIGINAL         0
+#define AR5416_EEP_TXGAIN_HIGH_POWER       1
+
+#define AR5416_EEP4K_START_LOC                64
+#define AR5416_EEP4K_NUM_2G_CAL_PIERS         3
+#define AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS 3
+#define AR5416_EEP4K_NUM_2G_20_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_2G_40_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_CTLS                 12
+#define AR5416_EEP4K_NUM_BAND_EDGES           4
+#define AR5416_EEP4K_NUM_PD_GAINS             2
+#define AR5416_EEP4K_PD_GAINS_IN_MASK         4
+#define AR5416_EEP4K_PD_GAIN_ICEPTS           5
+#define AR5416_EEP4K_MAX_CHAINS               1
+
+enum eeprom_param {
+	EEP_NFTHRESH_5,
+	EEP_NFTHRESH_2,
+	EEP_MAC_MSW,
+	EEP_MAC_MID,
+	EEP_MAC_LSW,
+	EEP_REG_0,
+	EEP_REG_1,
+	EEP_OP_CAP,
+	EEP_OP_MODE,
+	EEP_RF_SILENT,
+	EEP_OB_5,
+	EEP_DB_5,
+	EEP_OB_2,
+	EEP_DB_2,
+	EEP_MINOR_REV,
+	EEP_TX_MASK,
+	EEP_RX_MASK,
+	EEP_RXGAIN_TYPE,
+	EEP_TXGAIN_TYPE,
+	EEP_DAC_HPWR_5G,
+};
+
+enum ar5416_rates {
+	rate6mb, rate9mb, rate12mb, rate18mb,
+	rate24mb, rate36mb, rate48mb, rate54mb,
+	rate1l, rate2l, rate2s, rate5_5l,
+	rate5_5s, rate11l, rate11s, rateXr,
+	rateHt20_0, rateHt20_1, rateHt20_2, rateHt20_3,
+	rateHt20_4, rateHt20_5, rateHt20_6, rateHt20_7,
+	rateHt40_0, rateHt40_1, rateHt40_2, rateHt40_3,
+	rateHt40_4, rateHt40_5, rateHt40_6, rateHt40_7,
+	rateDupCck, rateDupOfdm, rateExtCck, rateExtOfdm,
+	Ar5416RateSize
+};
+
+enum ath9k_hal_freq_band {
+	ATH9K_HAL_FREQ_BAND_5GHZ = 0,
+	ATH9K_HAL_FREQ_BAND_2GHZ = 1
+};
+
+struct base_eep_header {
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
+	u8 futureBase_1[2];
+	u8 rxGainType;
+	u8 dacHiPwrMode_5G;
+	u8 futureBase_2;
+	u8 dacLpMode;
+	u8 txGainType;
+	u8 rcChainMask;
+	u8 desiredScaleCCK;
+	u8 futureBase_3[23];
+} __packed;
+
+struct base_eep_header_4k {
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
+	u8 futureBase[1];
+} __packed;
+
+
+struct spur_chan {
+	u16 spurChan;
+	u8 spurRangeLow;
+	u8 spurRangeHigh;
+} __packed;
+
+struct modal_eep_header {
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
+	    force_xpaon:1,
+	    local_bias:1,
+	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
+	u8 miscBits;
+	u16 xpaBiasLvlFreq[3];
+	u8 futureModal[6];
+
+	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
+} __packed;
+
+struct modal_eep_4k_header {
+	u32  antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
+	u32  antCtrlCommon;
+	u8   antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   switchSettling;
+	u8   txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   adcDesiredSize;
+	u8   pgaDesiredSize;
+	u8   xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   txEndToXpaOff;
+	u8   txEndToRxOn;
+	u8   txFrameToXpaOn;
+	u8   thresh62;
+	u8   noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   xpdGain;
+	u8   xpd;
+	u8   iqCalICh[AR5416_EEP4K_MAX_CHAINS];
+	u8   iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
+	u8   pdGainOverlap;
+	u8   ob_01;
+	u8   db1_01;
+	u8   xpaBiasLvl;
+	u8   txFrameToDataStart;
+	u8   txFrameToPaOn;
+	u8   ht40PowerIncForPdadc;
+	u8   bswAtten[AR5416_EEP4K_MAX_CHAINS];
+	u8   bswMargin[AR5416_EEP4K_MAX_CHAINS];
+	u8   swSettleHt40;
+	u8   xatten2Db[AR5416_EEP4K_MAX_CHAINS];
+	u8   xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
+	u8   db2_01;
+	u8   version;
+	u16  ob_234;
+	u16  db1_234;
+	u16  db2_234;
+	u8   futureModal[4];
+
+	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
+} __packed;
+
+
+struct cal_data_per_freq {
+	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+} __packed;
+
+struct cal_data_per_freq_4k {
+	u8 pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
+} __packed;
+
+struct cal_target_power_leg {
+	u8 bChannel;
+	u8 tPow2x[4];
+} __packed;
+
+struct cal_target_power_ht {
+	u8 bChannel;
+	u8 tPow2x[8];
+} __packed;
+
+
+#ifdef __BIG_ENDIAN_BITFIELD
+struct cal_ctl_edges {
+	u8 bChannel;
+	u8 flag:2, tPower:6;
+} __packed;
+#else
+struct cal_ctl_edges {
+	u8 bChannel;
+	u8 tPower:6, flag:2;
+} __packed;
+#endif
+
+struct cal_ctl_data {
+	struct cal_ctl_edges
+	ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
+} __packed;
+
+struct cal_ctl_data_4k {
+	struct cal_ctl_edges
+	ctlEdges[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_BAND_EDGES];
+} __packed;
+
+struct ar5416_eeprom_def {
+	struct base_eep_header baseEepHeader;
+	u8 custData[64];
+	struct modal_eep_header modalHeader[2];
+	u8 calFreqPier5G[AR5416_NUM_5G_CAL_PIERS];
+	u8 calFreqPier2G[AR5416_NUM_2G_CAL_PIERS];
+	struct cal_data_per_freq
+	 calPierData5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS];
+	struct cal_data_per_freq
+	 calPierData2G[AR5416_MAX_CHAINS][AR5416_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	 calTargetPower5G[AR5416_NUM_5G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower5GHT20[AR5416_NUM_5G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower5GHT40[AR5416_NUM_5G_40_TARGET_POWERS];
+	struct cal_target_power_leg
+	 calTargetPowerCck[AR5416_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	 calTargetPower2G[AR5416_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT20[AR5416_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT40[AR5416_NUM_2G_40_TARGET_POWERS];
+	u8 ctlIndex[AR5416_NUM_CTLS];
+	struct cal_ctl_data ctlData[AR5416_NUM_CTLS];
+	u8 padding;
+} __packed;
+
+struct ar5416_eeprom_4k {
+	struct base_eep_header_4k baseEepHeader;
+	u8 custData[20];
+	struct modal_eep_4k_header modalHeader;
+	u8 calFreqPier2G[AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_data_per_freq_4k
+	calPierData2G[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	calTargetPowerCck[AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	calTargetPower2G[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT20[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT40[AR5416_EEP4K_NUM_2G_40_TARGET_POWERS];
+	u8 ctlIndex[AR5416_EEP4K_NUM_CTLS];
+	struct cal_ctl_data_4k ctlData[AR5416_EEP4K_NUM_CTLS];
+	u8 padding;
+} __packed;
+
+enum reg_ext_bitmap {
+	REG_EXT_JAPAN_MIDBAND = 1,
+	REG_EXT_FCC_DFS_HT40 = 2,
+	REG_EXT_JAPAN_NONDFS_HT40 = 3,
+	REG_EXT_JAPAN_DFS_HT40 = 4
+};
+
+struct ath9k_country_entry {
+	u16 countryCode;
+	u16 regDmnEnum;
+	u16 regDmn5G;
+	u16 regDmn2G;
+	u8 isMultidomain;
+	u8 iso[3];
+};
+
+enum hal_eep_map {
+	EEP_MAP_DEFAULT = 0x0,
+	EEP_MAP_4KBITS,
+	EEP_MAP_MAX
+};
+
+#define ar5416_get_eep_ver(_ahp) \
+	(((_ahp)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
+#define ar5416_get_eep_rev(_ahp) \
+	(((_ahp)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
+#define ar5416_get_ntxchains(_txchainmask)			\
+	(((_txchainmask >> 2) & 1) +				\
+	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
+
+#define ar5416_get_eep4k_ver(_ahp) \
+	(((_ahp)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
+#define ar5416_get_eep4k_rev(_ahp) \
+	(((_ahp)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
+
+int ath9k_hw_set_txpower(struct ath_hal *ah, struct ath9k_channel *chan,
+			 u16 cfgCtl, u8 twiceAntennaReduction,
+			 u8 twiceMaxRegulatoryPower, u8 powerLimit);
+void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan);
+bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
+		       struct ath9k_channel *chan, int16_t *ratesArray,
+		       u16 cfgCtl, u8 AntennaReduction,
+		       u8 twiceMaxRegulatoryPower, u8 powerLimit);
+bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
+				  struct ath9k_channel *chan,
+				  int16_t *pTxPowerIndexOffset);
+bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
+				      struct ath9k_channel *chan);
+u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+				    struct ath9k_channel *chan);
+u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
+			       enum ieee80211_band freq_band);
+u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz);
+u32 ath9k_hw_get_eeprom(struct ath_hal *ah, enum eeprom_param param);
+int ath9k_hw_eeprom_attach(struct ath_hal *ah);
+
+#endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 00ed44a..075ddc5 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -17,10 +17,7 @@
 #include <linux/io.h>
 #include <asm/unaligned.h>
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 #include "initvals.h"
 
 static int btcoex_enable;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 087c571..2b72e75 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -19,337 +19,392 @@
 
 #include <linux/if_ether.h>
 #include <linux/delay.h>
+#include <linux/io.h>
+
+#include "mac.h"
+#include "ani.h"
+#include "eeprom.h"
+#include "calib.h"
+#include "regd.h"
+#include "reg.h"
+#include "phy.h"
+
+#define ATHEROS_VENDOR_ID	0x168c
+#define AR5416_DEVID_PCI	0x0023
+#define AR5416_DEVID_PCIE	0x0024
+#define AR9160_DEVID_PCI	0x0027
+#define AR9280_DEVID_PCI	0x0029
+#define AR9280_DEVID_PCIE	0x002a
+#define AR9285_DEVID_PCIE	0x002b
+#define AR5416_AR9100_DEVID	0x000b
+#define	AR_SUBVENDOR_ID_NOG	0x0e11
+#define AR_SUBVENDOR_ID_NEW_A	0x7065
+#define AR5416_MAGIC		0x19641014
+
+/* Register read/write primitives */
+#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
+#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
+
+#define SM(_v, _f)  (((_v) << _f##_S) & _f)
+#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
+#define REG_RMW(_a, _r, _set, _clr)    \
+	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
+#define REG_RMW_FIELD(_a, _r, _f, _v) \
+	REG_WRITE(_a, _r, \
+	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
+#define REG_SET_BIT(_a, _r, _f) \
+	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
+#define REG_CLR_BIT(_a, _r, _f) \
+	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
 
-extern const struct hal_percal_data iq_cal_multi_sample;
-extern const struct hal_percal_data iq_cal_single_sample;
-extern const struct hal_percal_data adc_gain_cal_multi_sample;
-extern const struct hal_percal_data adc_gain_cal_single_sample;
-extern const struct hal_percal_data adc_dc_cal_multi_sample;
-extern const struct hal_percal_data adc_dc_cal_single_sample;
-extern const struct hal_percal_data adc_init_dc_cal;
-
-struct ar5416_desc {
-	u32 ds_link;
-	u32 ds_data;
-	u32 ds_ctl0;
-	u32 ds_ctl1;
-	union {
-		struct {
-			u32 ctl2;
-			u32 ctl3;
-			u32 ctl4;
-			u32 ctl5;
-			u32 ctl6;
-			u32 ctl7;
-			u32 ctl8;
-			u32 ctl9;
-			u32 ctl10;
-			u32 ctl11;
-			u32 status0;
-			u32 status1;
-			u32 status2;
-			u32 status3;
-			u32 status4;
-			u32 status5;
-			u32 status6;
-			u32 status7;
-			u32 status8;
-			u32 status9;
-		} tx;
-		struct {
-			u32 status0;
-			u32 status1;
-			u32 status2;
-			u32 status3;
-			u32 status4;
-			u32 status5;
-			u32 status6;
-			u32 status7;
-			u32 status8;
-		} rx;
-	} u;
-} __packed;
-
-#define AR5416DESC(_ds)         ((struct ar5416_desc *)(_ds))
-#define AR5416DESC_CONST(_ds)   ((const struct ar5416_desc *)(_ds))
-
-#define ds_ctl2     u.tx.ctl2
-#define ds_ctl3     u.tx.ctl3
-#define ds_ctl4     u.tx.ctl4
-#define ds_ctl5     u.tx.ctl5
-#define ds_ctl6     u.tx.ctl6
-#define ds_ctl7     u.tx.ctl7
-#define ds_ctl8     u.tx.ctl8
-#define ds_ctl9     u.tx.ctl9
-#define ds_ctl10    u.tx.ctl10
-#define ds_ctl11    u.tx.ctl11
-
-#define ds_txstatus0    u.tx.status0
-#define ds_txstatus1    u.tx.status1
-#define ds_txstatus2    u.tx.status2
-#define ds_txstatus3    u.tx.status3
-#define ds_txstatus4    u.tx.status4
-#define ds_txstatus5    u.tx.status5
-#define ds_txstatus6    u.tx.status6
-#define ds_txstatus7    u.tx.status7
-#define ds_txstatus8    u.tx.status8
-#define ds_txstatus9    u.tx.status9
-
-#define ds_rxstatus0    u.rx.status0
-#define ds_rxstatus1    u.rx.status1
-#define ds_rxstatus2    u.rx.status2
-#define ds_rxstatus3    u.rx.status3
-#define ds_rxstatus4    u.rx.status4
-#define ds_rxstatus5    u.rx.status5
-#define ds_rxstatus6    u.rx.status6
-#define ds_rxstatus7    u.rx.status7
-#define ds_rxstatus8    u.rx.status8
-
-#define AR_FrameLen         0x00000fff
-#define AR_VirtMoreFrag     0x00001000
-#define AR_TxCtlRsvd00      0x0000e000
-#define AR_XmitPower        0x003f0000
-#define AR_XmitPower_S      16
-#define AR_RTSEnable        0x00400000
-#define AR_VEOL             0x00800000
-#define AR_ClrDestMask      0x01000000
-#define AR_TxCtlRsvd01      0x1e000000
-#define AR_TxIntrReq        0x20000000
-#define AR_DestIdxValid     0x40000000
-#define AR_CTSEnable        0x80000000
-
-#define AR_BufLen           0x00000fff
-#define AR_TxMore           0x00001000
-#define AR_DestIdx          0x000fe000
-#define AR_DestIdx_S        13
-#define AR_FrameType        0x00f00000
-#define AR_FrameType_S      20
-#define AR_NoAck            0x01000000
-#define AR_InsertTS         0x02000000
-#define AR_CorruptFCS       0x04000000
-#define AR_ExtOnly          0x08000000
-#define AR_ExtAndCtl        0x10000000
-#define AR_MoreAggr         0x20000000
-#define AR_IsAggr           0x40000000
-
-#define AR_BurstDur         0x00007fff
-#define AR_BurstDur_S       0
-#define AR_DurUpdateEna     0x00008000
-#define AR_XmitDataTries0   0x000f0000
-#define AR_XmitDataTries0_S 16
-#define AR_XmitDataTries1   0x00f00000
-#define AR_XmitDataTries1_S 20
-#define AR_XmitDataTries2   0x0f000000
-#define AR_XmitDataTries2_S 24
-#define AR_XmitDataTries3   0xf0000000
-#define AR_XmitDataTries3_S 28
-
-#define AR_XmitRate0        0x000000ff
-#define AR_XmitRate0_S      0
-#define AR_XmitRate1        0x0000ff00
-#define AR_XmitRate1_S      8
-#define AR_XmitRate2        0x00ff0000
-#define AR_XmitRate2_S      16
-#define AR_XmitRate3        0xff000000
-#define AR_XmitRate3_S      24
-
-#define AR_PacketDur0       0x00007fff
-#define AR_PacketDur0_S     0
-#define AR_RTSCTSQual0      0x00008000
-#define AR_PacketDur1       0x7fff0000
-#define AR_PacketDur1_S     16
-#define AR_RTSCTSQual1      0x80000000
-
-#define AR_PacketDur2       0x00007fff
-#define AR_PacketDur2_S     0
-#define AR_RTSCTSQual2      0x00008000
-#define AR_PacketDur3       0x7fff0000
-#define AR_PacketDur3_S     16
-#define AR_RTSCTSQual3      0x80000000
-
-#define AR_AggrLen          0x0000ffff
-#define AR_AggrLen_S        0
-#define AR_TxCtlRsvd60      0x00030000
-#define AR_PadDelim         0x03fc0000
-#define AR_PadDelim_S       18
-#define AR_EncrType         0x0c000000
-#define AR_EncrType_S       26
-#define AR_TxCtlRsvd61      0xf0000000
-
-#define AR_2040_0           0x00000001
-#define AR_GI0              0x00000002
-#define AR_ChainSel0        0x0000001c
-#define AR_ChainSel0_S      2
-#define AR_2040_1           0x00000020
-#define AR_GI1              0x00000040
-#define AR_ChainSel1        0x00000380
-#define AR_ChainSel1_S      7
-#define AR_2040_2           0x00000400
-#define AR_GI2              0x00000800
-#define AR_ChainSel2        0x00007000
-#define AR_ChainSel2_S      12
-#define AR_2040_3           0x00008000
-#define AR_GI3              0x00010000
-#define AR_ChainSel3        0x000e0000
-#define AR_ChainSel3_S      17
-#define AR_RTSCTSRate       0x0ff00000
-#define AR_RTSCTSRate_S     20
-#define AR_TxCtlRsvd70      0xf0000000
-
-#define AR_TxRSSIAnt00      0x000000ff
-#define AR_TxRSSIAnt00_S    0
-#define AR_TxRSSIAnt01      0x0000ff00
-#define AR_TxRSSIAnt01_S    8
-#define AR_TxRSSIAnt02      0x00ff0000
-#define AR_TxRSSIAnt02_S    16
-#define AR_TxStatusRsvd00   0x3f000000
-#define AR_TxBaStatus       0x40000000
-#define AR_TxStatusRsvd01   0x80000000
-
-#define AR_FrmXmitOK            0x00000001
-#define AR_ExcessiveRetries     0x00000002
-#define AR_FIFOUnderrun         0x00000004
-#define AR_Filtered             0x00000008
-#define AR_RTSFailCnt           0x000000f0
-#define AR_RTSFailCnt_S         4
-#define AR_DataFailCnt          0x00000f00
-#define AR_DataFailCnt_S        8
-#define AR_VirtRetryCnt         0x0000f000
-#define AR_VirtRetryCnt_S       12
-#define AR_TxDelimUnderrun      0x00010000
-#define AR_TxDataUnderrun       0x00020000
-#define AR_DescCfgErr           0x00040000
-#define AR_TxTimerExpired       0x00080000
-#define AR_TxStatusRsvd10       0xfff00000
-
-#define AR_SendTimestamp    ds_txstatus2
-#define AR_BaBitmapLow      ds_txstatus3
-#define AR_BaBitmapHigh     ds_txstatus4
-
-#define AR_TxRSSIAnt10      0x000000ff
-#define AR_TxRSSIAnt10_S    0
-#define AR_TxRSSIAnt11      0x0000ff00
-#define AR_TxRSSIAnt11_S    8
-#define AR_TxRSSIAnt12      0x00ff0000
-#define AR_TxRSSIAnt12_S    16
-#define AR_TxRSSICombined   0xff000000
-#define AR_TxRSSICombined_S 24
-
-#define AR_TxEVM0           ds_txstatus5
-#define AR_TxEVM1           ds_txstatus6
-#define AR_TxEVM2           ds_txstatus7
-
-#define AR_TxDone           0x00000001
-#define AR_SeqNum           0x00001ffe
-#define AR_SeqNum_S         1
-#define AR_TxStatusRsvd80   0x0001e000
-#define AR_TxOpExceeded     0x00020000
-#define AR_TxStatusRsvd81   0x001c0000
-#define AR_FinalTxIdx       0x00600000
-#define AR_FinalTxIdx_S     21
-#define AR_TxStatusRsvd82   0x01800000
-#define AR_PowerMgmt        0x02000000
-#define AR_TxStatusRsvd83   0xfc000000
+#define DO_DELAY(x) do {			\
+		if ((++(x) % 64) == 0)          \
+			udelay(1);		\
+	} while (0)
 
-#define AR_RxCTLRsvd00  0xffffffff
+#define REG_WRITE_ARRAY(iniarray, column, regWr) do {                   \
+		int r;							\
+		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
+			REG_WRITE(ah, INI_RA((iniarray), (r), 0),	\
+				  INI_RA((iniarray), r, (column)));	\
+			DO_DELAY(regWr);				\
+		}							\
+	} while (0)
 
-#define AR_BufLen       0x00000fff
-#define AR_RxCtlRsvd00  0x00001000
-#define AR_RxIntrReq    0x00002000
-#define AR_RxCtlRsvd01  0xffffc000
+#define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
+#define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
+#define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
+#define AR_GPIO_OUTPUT_MUX_AS_TX_FRAME           3
+#define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
+#define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
 
-#define AR_RxRSSIAnt00      0x000000ff
-#define AR_RxRSSIAnt00_S    0
-#define AR_RxRSSIAnt01      0x0000ff00
-#define AR_RxRSSIAnt01_S    8
-#define AR_RxRSSIAnt02      0x00ff0000
-#define AR_RxRSSIAnt02_S    16
-#define AR_RxRate           0xff000000
-#define AR_RxRate_S         24
-#define AR_RxStatusRsvd00   0xff000000
+#define AR_GPIOD_MASK               0x00001FFF
+#define AR_GPIO_BIT(_gpio)          (1 << (_gpio))
 
-#define AR_DataLen          0x00000fff
-#define AR_RxMore           0x00001000
-#define AR_NumDelim         0x003fc000
-#define AR_NumDelim_S       14
-#define AR_RxStatusRsvd10   0xff800000
+#define BASE_ACTIVATE_DELAY         100
+#define RTC_PLL_SETTLE_DELAY        1000
+#define COEF_SCALE_S                24
+#define HT40_CHANNEL_CENTER_SHIFT   10
 
-#define AR_RcvTimestamp     ds_rxstatus2
+#define ATH9K_ANTENNA0_CHAINMASK    0x1
+#define ATH9K_ANTENNA1_CHAINMASK    0x2
+
+#define ATH9K_NUM_DMA_DEBUG_REGS    8
+#define ATH9K_NUM_QUEUES            10
+
+#define MAX_RATE_POWER              63
+#define AH_TIMEOUT                  100000
+#define AH_TIME_QUANTUM             10
+#define AR_KEYTABLE_SIZE            128
+#define POWER_UP_TIME               200000
+#define SPUR_RSSI_THRESH            40
+
+#define CAB_TIMEOUT_VAL             10
+#define BEACON_TIMEOUT_VAL          10
+#define MIN_BEACON_TIMEOUT_VAL      1
+#define SLEEP_SLOP                  3
+
+#define INIT_CONFIG_STATUS          0x00000000
+#define INIT_RSSI_THR               0x00000700
+#define INIT_BCON_CNTRL_REG         0x00000000
+
+#define TU_TO_USEC(_tu)             ((_tu) << 10)
+
+enum wireless_mode {
+	ATH9K_MODE_11A = 0,
+	ATH9K_MODE_11B = 2,
+	ATH9K_MODE_11G = 3,
+	ATH9K_MODE_11NA_HT20 = 6,
+	ATH9K_MODE_11NG_HT20 = 7,
+	ATH9K_MODE_11NA_HT40PLUS = 8,
+	ATH9K_MODE_11NA_HT40MINUS = 9,
+	ATH9K_MODE_11NG_HT40PLUS = 10,
+	ATH9K_MODE_11NG_HT40MINUS = 11,
+	ATH9K_MODE_MAX
+};
 
-#define AR_GI               0x00000001
-#define AR_2040             0x00000002
-#define AR_Parallel40       0x00000004
-#define AR_Parallel40_S     2
-#define AR_RxStatusRsvd30   0x000000f8
-#define AR_RxAntenna	    0xffffff00
-#define AR_RxAntenna_S	    8
+enum ath9k_hw_caps {
+	ATH9K_HW_CAP_CHAN_SPREAD		= BIT(0),
+	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(1),
+	ATH9K_HW_CAP_MIC_CKIP                   = BIT(2),
+	ATH9K_HW_CAP_MIC_TKIP                   = BIT(3),
+	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(4),
+	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(5),
+	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(6),
+	ATH9K_HW_CAP_VEOL                       = BIT(7),
+	ATH9K_HW_CAP_BSSIDMASK                  = BIT(8),
+	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(9),
+	ATH9K_HW_CAP_CHAN_HALFRATE              = BIT(10),
+	ATH9K_HW_CAP_CHAN_QUARTERRATE           = BIT(11),
+	ATH9K_HW_CAP_HT                         = BIT(12),
+	ATH9K_HW_CAP_GTT                        = BIT(13),
+	ATH9K_HW_CAP_FASTCC                     = BIT(14),
+	ATH9K_HW_CAP_RFSILENT                   = BIT(15),
+	ATH9K_HW_CAP_WOW                        = BIT(16),
+	ATH9K_HW_CAP_CST                        = BIT(17),
+	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(18),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(19),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(20),
+	ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT     = BIT(21),
+	ATH9K_HW_CAP_BT_COEX			= BIT(22)
+};
 
-#define AR_RxRSSIAnt10            0x000000ff
-#define AR_RxRSSIAnt10_S          0
-#define AR_RxRSSIAnt11            0x0000ff00
-#define AR_RxRSSIAnt11_S          8
-#define AR_RxRSSIAnt12            0x00ff0000
-#define AR_RxRSSIAnt12_S          16
-#define AR_RxRSSICombined         0xff000000
-#define AR_RxRSSICombined_S       24
+enum ath9k_capability_type {
+	ATH9K_CAP_CIPHER = 0,
+	ATH9K_CAP_TKIP_MIC,
+	ATH9K_CAP_TKIP_SPLIT,
+	ATH9K_CAP_PHYCOUNTERS,
+	ATH9K_CAP_DIVERSITY,
+	ATH9K_CAP_TXPOW,
+	ATH9K_CAP_PHYDIAG,
+	ATH9K_CAP_MCAST_KEYSRCH,
+	ATH9K_CAP_TSF_ADJUST,
+	ATH9K_CAP_WME_TKIPMIC,
+	ATH9K_CAP_RFSILENT,
+	ATH9K_CAP_ANT_CFG_2GHZ,
+	ATH9K_CAP_ANT_CFG_5GHZ
+};
 
-#define AR_RxEVM0           ds_rxstatus4
-#define AR_RxEVM1           ds_rxstatus5
-#define AR_RxEVM2           ds_rxstatus6
+struct ath9k_hw_capabilities {
+	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
+	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */
+	u16 total_queues;
+	u16 keycache_size;
+	u16 low_5ghz_chan, high_5ghz_chan;
+	u16 low_2ghz_chan, high_2ghz_chan;
+	u16 num_mr_retries;
+	u16 rts_aggr_limit;
+	u8 tx_chainmask;
+	u8 rx_chainmask;
+	u16 tx_triglevel_max;
+	u16 reg_cap;
+	u8 num_gpio_pins;
+	u8 num_antcfg_2ghz;
+	u8 num_antcfg_5ghz;
+};
 
-#define AR_RxDone           0x00000001
-#define AR_RxFrameOK        0x00000002
-#define AR_CRCErr           0x00000004
-#define AR_DecryptCRCErr    0x00000008
-#define AR_PHYErr           0x00000010
-#define AR_MichaelErr       0x00000020
-#define AR_PreDelimCRCErr   0x00000040
-#define AR_RxStatusRsvd70   0x00000080
-#define AR_RxKeyIdxValid    0x00000100
-#define AR_KeyIdx           0x0000fe00
-#define AR_KeyIdx_S         9
-#define AR_PHYErrCode       0x0000ff00
-#define AR_PHYErrCode_S     8
-#define AR_RxMoreAggr       0x00010000
-#define AR_RxAggr           0x00020000
-#define AR_PostDelimCRCErr  0x00040000
-#define AR_RxStatusRsvd71   0x3ff80000
-#define AR_DecryptBusyErr   0x40000000
-#define AR_KeyMiss          0x80000000
+struct ath9k_ops_config {
+	int dma_beacon_response_time;
+	int sw_beacon_response_time;
+	int additional_swba_backoff;
+	int ack_6mb;
+	int cwm_ignore_extcca;
+	u8 pcie_powersave_enable;
+	u8 pcie_l1skp_enable;
+	u8 pcie_clock_req;
+	u32 pcie_waen;
+	int pcie_power_reset;
+	u8 pcie_restore;
+	u8 analog_shiftreg;
+	u8 ht_enable;
+	u32 ofdm_trig_low;
+	u32 ofdm_trig_high;
+	u32 cck_trig_high;
+	u32 cck_trig_low;
+	u32 enable_ani;
+	u8 noise_immunity_level;
+	u32 ofdm_weaksignal_det;
+	u32 cck_weaksignal_thr;
+	u8 spur_immunity_level;
+	u8 firstep_level;
+	int8_t rssi_thr_high;
+	int8_t rssi_thr_low;
+	u16 diversity_control;
+	u16 antenna_switch_swap;
+	int serialize_regmode;
+	int intr_mitigation;
+#define SPUR_DISABLE        	0
+#define SPUR_ENABLE_IOCTL   	1
+#define SPUR_ENABLE_EEPROM  	2
+#define AR_EEPROM_MODAL_SPURS   5
+#define AR_SPUR_5413_1      	1640
+#define AR_SPUR_5413_2      	1200
+#define AR_NO_SPUR      	0x8000
+#define AR_BASE_FREQ_2GHZ   	2300
+#define AR_BASE_FREQ_5GHZ   	4900
+#define AR_SPUR_FEEQ_BOUND_HT40 19
+#define AR_SPUR_FEEQ_BOUND_HT20 10
+	int spurmode;
+	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
+};
 
-#define AR5416_MAGIC        0x19641014
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
+};
 
-#define RXSTATUS_RATE(ah, ads)  (AR_SREV_5416_V20_OR_LATER(ah) ?	\
-				 MS(ads->ds_rxstatus0, AR_RxRate) :	\
-				 (ads->ds_rxstatus3 >> 2) & 0xFF)
+#define CHANNEL_CW_INT    0x00002
+#define CHANNEL_CCK       0x00020
+#define CHANNEL_OFDM      0x00040
+#define CHANNEL_2GHZ      0x00080
+#define CHANNEL_5GHZ      0x00100
+#define CHANNEL_PASSIVE   0x00200
+#define CHANNEL_DYN       0x00400
+#define CHANNEL_HALF      0x04000
+#define CHANNEL_QUARTER   0x08000
+#define CHANNEL_HT20      0x10000
+#define CHANNEL_HT40PLUS  0x20000
+#define CHANNEL_HT40MINUS 0x40000
+
+#define CHANNEL_INTERFERENCE    0x01
+#define CHANNEL_DFS             0x02
+#define CHANNEL_4MS_LIMIT       0x04
+#define CHANNEL_DFS_CLEAR       0x08
+#define CHANNEL_DISALLOW_ADHOC  0x10
+#define CHANNEL_PER_11D_ADHOC   0x20
+
+#define CHANNEL_A           (CHANNEL_5GHZ|CHANNEL_OFDM)
+#define CHANNEL_B           (CHANNEL_2GHZ|CHANNEL_CCK)
+#define CHANNEL_G           (CHANNEL_2GHZ|CHANNEL_OFDM)
+#define CHANNEL_G_HT20      (CHANNEL_2GHZ|CHANNEL_HT20)
+#define CHANNEL_A_HT20      (CHANNEL_5GHZ|CHANNEL_HT20)
+#define CHANNEL_G_HT40PLUS  (CHANNEL_2GHZ|CHANNEL_HT40PLUS)
+#define CHANNEL_G_HT40MINUS (CHANNEL_2GHZ|CHANNEL_HT40MINUS)
+#define CHANNEL_A_HT40PLUS  (CHANNEL_5GHZ|CHANNEL_HT40PLUS)
+#define CHANNEL_A_HT40MINUS (CHANNEL_5GHZ|CHANNEL_HT40MINUS)
+#define CHANNEL_ALL				\
+	(CHANNEL_OFDM|				\
+	 CHANNEL_CCK|				\
+	 CHANNEL_2GHZ |				\
+	 CHANNEL_5GHZ |				\
+	 CHANNEL_HT20 |				\
+	 CHANNEL_HT40PLUS |			\
+	 CHANNEL_HT40MINUS)
+
+struct ath9k_channel {
+	struct ieee80211_channel *chan;
+	u16 channel;
+	u32 channelFlags;
+	u32 chanmode;
+	int32_t CalValid;
+	bool oneTimeCalsDone;
+	int8_t iCoff;
+	int8_t qCoff;
+	int16_t rawNoiseFloor;
+};
 
-#define set11nTries(_series, _index) \
-	(SM((_series)[_index].Tries, AR_XmitDataTries##_index))
+#define IS_CHAN_A(_c) ((((_c)->channelFlags & CHANNEL_A) == CHANNEL_A) || \
+       (((_c)->channelFlags & CHANNEL_A_HT20) == CHANNEL_A_HT20) || \
+       (((_c)->channelFlags & CHANNEL_A_HT40PLUS) == CHANNEL_A_HT40PLUS) || \
+       (((_c)->channelFlags & CHANNEL_A_HT40MINUS) == CHANNEL_A_HT40MINUS))
+#define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
+       (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
+       (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
+       (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
+#define IS_CHAN_OFDM(_c) (((_c)->channelFlags & CHANNEL_OFDM) != 0)
+#define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
+#define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
+#define IS_CHAN_PASSIVE(_c) (((_c)->channelFlags & CHANNEL_PASSIVE) != 0)
+#define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
+#define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
+#define IS_CHAN_A_5MHZ_SPACED(_c)			\
+	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
+	 (((_c)->channel % 20) != 0) &&			\
+	 (((_c)->channel % 10) != 0))
+
+/* These macros check chanmode and not channelFlags */
+#define IS_CHAN_B(_c) ((_c)->chanmode == CHANNEL_B)
+#define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT20))
+#define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
+			  ((_c)->chanmode == CHANNEL_A_HT40MINUS) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT40PLUS) ||	\
+			  ((_c)->chanmode == CHANNEL_G_HT40MINUS))
+#define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
+
+enum ath9k_power_mode {
+	ATH9K_PM_AWAKE = 0,
+	ATH9K_PM_FULL_SLEEP,
+	ATH9K_PM_NETWORK_SLEEP,
+	ATH9K_PM_UNDEFINED
+};
 
-#define set11nRate(_series, _index) \
-	(SM((_series)[_index].Rate, AR_XmitRate##_index))
+enum ath9k_ant_setting {
+	ATH9K_ANT_VARIABLE = 0,
+	ATH9K_ANT_FIXED_A,
+	ATH9K_ANT_FIXED_B
+};
 
-#define set11nPktDurRTSCTS(_series, _index)				\
-	(SM((_series)[_index].PktDuration, AR_PacketDur##_index) |	\
-	((_series)[_index].RateFlags & ATH9K_RATESERIES_RTS_CTS   ?	\
-		AR_RTSCTSQual##_index : 0))
+enum ath9k_tp_scale {
+	ATH9K_TP_SCALE_MAX = 0,
+	ATH9K_TP_SCALE_50,
+	ATH9K_TP_SCALE_25,
+	ATH9K_TP_SCALE_12,
+	ATH9K_TP_SCALE_MIN
+};
 
-#define set11nRateFlags(_series, _index)				\
-	(((_series)[_index].RateFlags & ATH9K_RATESERIES_2040 ?		\
-	  AR_2040_##_index : 0)						\
-	 |((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ?	\
-	   AR_GI##_index : 0)						\
-	 |SM((_series)[_index].ChSel, AR_ChainSel##_index))
+enum ser_reg_mode {
+	SER_REG_MODE_OFF = 0,
+	SER_REG_MODE_ON = 1,
+	SER_REG_MODE_AUTO = 2,
+};
 
-#define AR_SREV_9100(ah) ((ah->ah_macVersion) == AR_SREV_VERSION_9100)
+struct ath9k_beacon_state {
+	u32 bs_nexttbtt;
+	u32 bs_nextdtim;
+	u32 bs_intval;
+#define ATH9K_BEACON_PERIOD       0x0000ffff
+#define ATH9K_BEACON_ENA          0x00800000
+#define ATH9K_BEACON_RESET_TSF    0x01000000
+	u32 bs_dtimperiod;
+	u16 bs_cfpperiod;
+	u16 bs_cfpmaxduration;
+	u32 bs_cfpnext;
+	u16 bs_timoffset;
+	u16 bs_bmissthreshold;
+	u32 bs_sleepduration;
+};
 
-#define INIT_CONFIG_STATUS  0x00000000
-#define INIT_RSSI_THR       0x00000700
-#define INIT_BCON_CNTRL_REG 0x00000000
+struct chan_centers {
+	u16 synth_center;
+	u16 ctl_center;
+	u16 ext_center;
+};
 
-#define MIN_TX_FIFO_THRESHOLD   0x1
-#define MAX_TX_FIFO_THRESHOLD   ((4096 / 64) - 1)
-#define INIT_TX_FIFO_THRESHOLD  MIN_TX_FIFO_THRESHOLD
+enum {
+	ATH9K_RESET_POWER_ON,
+	ATH9K_RESET_WARM,
+	ATH9K_RESET_COLD,
+};
 
 struct ar5416AniState {
 	struct ath9k_channel c;
@@ -378,447 +433,52 @@ struct ar5416AniState {
 	int16_t cckErrRssi[2];
 };
 
-#define HAL_PROCESS_ANI     0x00000001
-#define DO_ANI(ah) \
-	((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
-
-struct ar5416Stats {
-	u32 ast_ani_niup;
-	u32 ast_ani_nidown;
-	u32 ast_ani_spurup;
-	u32 ast_ani_spurdown;
-	u32 ast_ani_ofdmon;
-	u32 ast_ani_ofdmoff;
-	u32 ast_ani_cckhigh;
-	u32 ast_ani_ccklow;
-	u32 ast_ani_stepup;
-	u32 ast_ani_stepdown;
-	u32 ast_ani_ofdmerrs;
-	u32 ast_ani_cckerrs;
-	u32 ast_ani_reset;
-	u32 ast_ani_lzero;
-	u32 ast_ani_lneg;
-	struct ath9k_mib_stats ast_mibstats;
-	struct ath9k_node_stats ast_nodestats;
+struct ath_hal {
+	u32 ah_magic;
+	u16 ah_devid;
+	u16 ah_subvendorid;
+	u32 ah_macVersion;
+	u16 ah_macRev;
+	u16 ah_phyRev;
+	u16 ah_analog5GhzRev;
+	u16 ah_analog2GhzRev;
+
+	void __iomem *ah_sh;
+	struct ath_softc *ah_sc;
+
+	enum nl80211_iftype ah_opmode;
+	struct ath9k_ops_config ah_config;
+	struct ath9k_hw_capabilities ah_caps;
+
+	u16 ah_countryCode;
+	u32 ah_flags;
+	int16_t ah_powerLimit;
+	u16 ah_maxPowerLevel;
+	u32 ah_tpScale;
+	u16 ah_currentRD;
+	u16 ah_currentRDExt;
+	u16 ah_currentRDInUse;
+	char alpha2[2];
+	struct reg_dmn_pair_mapping *regpair;
+	enum ath9k_power_mode ah_power_mode;
+	enum ath9k_power_mode ah_restore_mode;
+
+	struct ath9k_channel ah_channels[38];
+	struct ath9k_channel *ah_curchan;
+
+	bool ah_isPciExpress;
+	u16 ah_txTrigLevel;
+	u16 ah_rfsilent;
+	u32 ah_rfkill_gpio;
+	u32 ah_rfkill_polarity;
+	u32 ah_btactive_gpio;
+	u32 ah_wlanactive_gpio;
+
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
+
+	bool sw_mgmt_crypto;
 };
 
-#define AR5416_OPFLAGS_11A           0x01
-#define AR5416_OPFLAGS_11G           0x02
-#define AR5416_OPFLAGS_N_5G_HT40     0x04
-#define AR5416_OPFLAGS_N_2G_HT40     0x08
-#define AR5416_OPFLAGS_N_5G_HT20     0x10
-#define AR5416_OPFLAGS_N_2G_HT20     0x20
-
-#define EEP_RFSILENT_ENABLED        0x0001
-#define EEP_RFSILENT_ENABLED_S      0
-#define EEP_RFSILENT_POLARITY       0x0002
-#define EEP_RFSILENT_POLARITY_S     1
-#define EEP_RFSILENT_GPIO_SEL       0x001c
-#define EEP_RFSILENT_GPIO_SEL_S     2
-
-#define AR5416_EEP_NO_BACK_VER       0x1
-#define AR5416_EEP_VER               0xE
-#define AR5416_EEP_VER_MINOR_MASK    0x0FFF
-#define AR5416_EEP_MINOR_VER_2       0x2
-#define AR5416_EEP_MINOR_VER_3       0x3
-#define AR5416_EEP_MINOR_VER_7       0x7
-#define AR5416_EEP_MINOR_VER_9       0x9
-#define AR5416_EEP_MINOR_VER_16      0x10
-#define AR5416_EEP_MINOR_VER_17      0x11
-#define AR5416_EEP_MINOR_VER_19      0x13
-#define AR5416_EEP_MINOR_VER_20      0x14
-
-#define AR5416_NUM_5G_CAL_PIERS         8
-#define AR5416_NUM_2G_CAL_PIERS         4
-#define AR5416_NUM_5G_20_TARGET_POWERS  8
-#define AR5416_NUM_5G_40_TARGET_POWERS  8
-#define AR5416_NUM_2G_CCK_TARGET_POWERS 3
-#define AR5416_NUM_2G_20_TARGET_POWERS  4
-#define AR5416_NUM_2G_40_TARGET_POWERS  4
-#define AR5416_NUM_CTLS                 24
-#define AR5416_NUM_BAND_EDGES           8
-#define AR5416_NUM_PD_GAINS             4
-#define AR5416_PD_GAINS_IN_MASK         4
-#define AR5416_PD_GAIN_ICEPTS           5
-#define AR5416_EEPROM_MODAL_SPURS       5
-#define AR5416_MAX_RATE_POWER           63
-#define AR5416_NUM_PDADC_VALUES         128
-#define AR5416_BCHAN_UNUSED             0xFF
-#define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
-#define AR5416_MAX_CHAINS               3
-#define AR5416_PWR_TABLE_OFFSET         -5
-
-/* Rx gain type values */
-#define AR5416_EEP_RXGAIN_23DB_BACKOFF     0
-#define AR5416_EEP_RXGAIN_13DB_BACKOFF     1
-#define AR5416_EEP_RXGAIN_ORIG             2
-
-/* Tx gain type values */
-#define AR5416_EEP_TXGAIN_ORIGINAL         0
-#define AR5416_EEP_TXGAIN_HIGH_POWER       1
-
-#define AR5416_EEP4K_START_LOC         64
-#define AR5416_EEP4K_NUM_2G_CAL_PIERS      3
-#define AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS 3
-#define AR5416_EEP4K_NUM_2G_20_TARGET_POWERS  3
-#define AR5416_EEP4K_NUM_2G_40_TARGET_POWERS  3
-#define AR5416_EEP4K_NUM_CTLS              12
-#define AR5416_EEP4K_NUM_BAND_EDGES        4
-#define AR5416_EEP4K_NUM_PD_GAINS          2
-#define AR5416_EEP4K_PD_GAINS_IN_MASK      4
-#define AR5416_EEP4K_PD_GAIN_ICEPTS        5
-#define AR5416_EEP4K_MAX_CHAINS            1
-
-enum eeprom_param {
-	EEP_NFTHRESH_5,
-	EEP_NFTHRESH_2,
-	EEP_MAC_MSW,
-	EEP_MAC_MID,
-	EEP_MAC_LSW,
-	EEP_REG_0,
-	EEP_REG_1,
-	EEP_OP_CAP,
-	EEP_OP_MODE,
-	EEP_RF_SILENT,
-	EEP_OB_5,
-	EEP_DB_5,
-	EEP_OB_2,
-	EEP_DB_2,
-	EEP_MINOR_REV,
-	EEP_TX_MASK,
-	EEP_RX_MASK,
-	EEP_RXGAIN_TYPE,
-	EEP_TXGAIN_TYPE,
-	EEP_DAC_HPWR_5G,
-};
-
-enum ar5416_rates {
-	rate6mb, rate9mb, rate12mb, rate18mb,
-	rate24mb, rate36mb, rate48mb, rate54mb,
-	rate1l, rate2l, rate2s, rate5_5l,
-	rate5_5s, rate11l, rate11s, rateXr,
-	rateHt20_0, rateHt20_1, rateHt20_2, rateHt20_3,
-	rateHt20_4, rateHt20_5, rateHt20_6, rateHt20_7,
-	rateHt40_0, rateHt40_1, rateHt40_2, rateHt40_3,
-	rateHt40_4, rateHt40_5, rateHt40_6, rateHt40_7,
-	rateDupCck, rateDupOfdm, rateExtCck, rateExtOfdm,
-	Ar5416RateSize
-};
-
-enum ath9k_hal_freq_band {
-	ATH9K_HAL_FREQ_BAND_5GHZ = 0,
-	ATH9K_HAL_FREQ_BAND_2GHZ = 1
-};
-
-struct base_eep_header {
-	u16 length;
-	u16 checksum;
-	u16 version;
-	u8 opCapFlags;
-	u8 eepMisc;
-	u16 regDmn[2];
-	u8 macAddr[6];
-	u8 rxMask;
-	u8 txMask;
-	u16 rfSilent;
-	u16 blueToothOptions;
-	u16 deviceCap;
-	u32 binBuildNumber;
-	u8 deviceType;
-	u8 pwdclkind;
-	u8 futureBase_1[2];
-	u8 rxGainType;
-	u8 dacHiPwrMode_5G;
-	u8 futureBase_2;
-	u8 dacLpMode;
-	u8 txGainType;
-	u8 rcChainMask;
-	u8 desiredScaleCCK;
-	u8 futureBase_3[23];
-} __packed;
-
-struct base_eep_header_4k {
-	u16 length;
-	u16 checksum;
-	u16 version;
-	u8 opCapFlags;
-	u8 eepMisc;
-	u16 regDmn[2];
-	u8 macAddr[6];
-	u8 rxMask;
-	u8 txMask;
-	u16 rfSilent;
-	u16 blueToothOptions;
-	u16 deviceCap;
-	u32 binBuildNumber;
-	u8 deviceType;
-	u8 futureBase[1];
-} __packed;
-
-
-struct spur_chan {
-	u16 spurChan;
-	u8 spurRangeLow;
-	u8 spurRangeHigh;
-} __packed;
-
-struct modal_eep_header {
-	u32 antCtrlChain[AR5416_MAX_CHAINS];
-	u32 antCtrlCommon;
-	u8 antennaGainCh[AR5416_MAX_CHAINS];
-	u8 switchSettling;
-	u8 txRxAttenCh[AR5416_MAX_CHAINS];
-	u8 rxTxMarginCh[AR5416_MAX_CHAINS];
-	u8 adcDesiredSize;
-	u8 pgaDesiredSize;
-	u8 xlnaGainCh[AR5416_MAX_CHAINS];
-	u8 txEndToXpaOff;
-	u8 txEndToRxOn;
-	u8 txFrameToXpaOn;
-	u8 thresh62;
-	u8 noiseFloorThreshCh[AR5416_MAX_CHAINS];
-	u8 xpdGain;
-	u8 xpd;
-	u8 iqCalICh[AR5416_MAX_CHAINS];
-	u8 iqCalQCh[AR5416_MAX_CHAINS];
-	u8 pdGainOverlap;
-	u8 ob;
-	u8 db;
-	u8 xpaBiasLvl;
-	u8 pwrDecreaseFor2Chain;
-	u8 pwrDecreaseFor3Chain;
-	u8 txFrameToDataStart;
-	u8 txFrameToPaOn;
-	u8 ht40PowerIncForPdadc;
-	u8 bswAtten[AR5416_MAX_CHAINS];
-	u8 bswMargin[AR5416_MAX_CHAINS];
-	u8 swSettleHt40;
-	u8 xatten2Db[AR5416_MAX_CHAINS];
-	u8 xatten2Margin[AR5416_MAX_CHAINS];
-	u8 ob_ch1;
-	u8 db_ch1;
-	u8 useAnt1:1,
-	    force_xpaon:1,
-	    local_bias:1,
-	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
-	u8 miscBits;
-	u16 xpaBiasLvlFreq[3];
-	u8 futureModal[6];
-
-	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
-} __packed;
-
-struct modal_eep_4k_header {
-    u32  antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
-    u32  antCtrlCommon;
-    u8   antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   switchSettling;
-    u8   txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   adcDesiredSize;
-    u8   pgaDesiredSize;
-    u8   xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   txEndToXpaOff;
-    u8   txEndToRxOn;
-    u8   txFrameToXpaOn;
-    u8   thresh62;
-    u8   noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   xpdGain;
-    u8   xpd;
-    u8   iqCalICh[AR5416_EEP4K_MAX_CHAINS];
-    u8   iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
-    u8   pdGainOverlap;
-    u8   ob_01;
-    u8   db1_01;
-    u8   xpaBiasLvl;
-    u8   txFrameToDataStart;
-    u8   txFrameToPaOn;
-    u8   ht40PowerIncForPdadc;
-    u8   bswAtten[AR5416_EEP4K_MAX_CHAINS];
-    u8   bswMargin[AR5416_EEP4K_MAX_CHAINS];
-    u8   swSettleHt40;
-    u8   xatten2Db[AR5416_EEP4K_MAX_CHAINS];
-    u8   xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
-    u8   db2_01;
-    u8   version;
-    u16  ob_234;
-    u16  db1_234;
-    u16  db2_234;
-    u8   futureModal[4];
-
-    struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
-} __packed;
-
-
-struct cal_data_per_freq {
-	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
-	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
-} __packed;
-
-struct cal_data_per_freq_4k {
-	u8 pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
-	u8 vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
-} __packed;
-
-struct cal_target_power_leg {
-	u8 bChannel;
-	u8 tPow2x[4];
-} __packed;
-
-struct cal_target_power_ht {
-	u8 bChannel;
-	u8 tPow2x[8];
-} __packed;
-
-
-#ifdef __BIG_ENDIAN_BITFIELD
-struct cal_ctl_edges {
-	u8 bChannel;
-	u8 flag:2, tPower:6;
-} __packed;
-#else
-struct cal_ctl_edges {
-	u8 bChannel;
-	u8 tPower:6, flag:2;
-} __packed;
-#endif
-
-struct cal_ctl_data {
-	struct cal_ctl_edges
-	ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
-} __packed;
-
-struct cal_ctl_data_4k {
-	struct cal_ctl_edges
-	ctlEdges[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_BAND_EDGES];
-} __packed;
-
-struct ar5416_eeprom_def {
-	struct base_eep_header baseEepHeader;
-	u8 custData[64];
-	struct modal_eep_header modalHeader[2];
-	u8 calFreqPier5G[AR5416_NUM_5G_CAL_PIERS];
-	u8 calFreqPier2G[AR5416_NUM_2G_CAL_PIERS];
-	struct cal_data_per_freq
-	 calPierData5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS];
-	struct cal_data_per_freq
-	 calPierData2G[AR5416_MAX_CHAINS][AR5416_NUM_2G_CAL_PIERS];
-	struct cal_target_power_leg
-	 calTargetPower5G[AR5416_NUM_5G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	 calTargetPower5GHT20[AR5416_NUM_5G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	 calTargetPower5GHT40[AR5416_NUM_5G_40_TARGET_POWERS];
-	struct cal_target_power_leg
-	 calTargetPowerCck[AR5416_NUM_2G_CCK_TARGET_POWERS];
-	struct cal_target_power_leg
-	 calTargetPower2G[AR5416_NUM_2G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	 calTargetPower2GHT20[AR5416_NUM_2G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	 calTargetPower2GHT40[AR5416_NUM_2G_40_TARGET_POWERS];
-	u8 ctlIndex[AR5416_NUM_CTLS];
-	struct cal_ctl_data ctlData[AR5416_NUM_CTLS];
-	u8 padding;
-} __packed;
-
-struct ar5416_eeprom_4k {
-	struct base_eep_header_4k baseEepHeader;
-	u8 custData[20];
-	struct modal_eep_4k_header modalHeader;
-	u8 calFreqPier2G[AR5416_EEP4K_NUM_2G_CAL_PIERS];
-	struct cal_data_per_freq_4k
-	calPierData2G[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_2G_CAL_PIERS];
-	struct cal_target_power_leg
-	calTargetPowerCck[AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS];
-	struct cal_target_power_leg
-	calTargetPower2G[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	calTargetPower2GHT20[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
-	struct cal_target_power_ht
-	calTargetPower2GHT40[AR5416_EEP4K_NUM_2G_40_TARGET_POWERS];
-	u8 ctlIndex[AR5416_EEP4K_NUM_CTLS];
-	struct cal_ctl_data_4k ctlData[AR5416_EEP4K_NUM_CTLS];
-	u8 padding;
-} __packed;
-
-struct ar5416IniArray {
-	u32 *ia_array;
-	u32 ia_rows;
-	u32 ia_columns;
-};
-
-#define INIT_INI_ARRAY(iniarray, array, rows, columns) do {	\
-		(iniarray)->ia_array = (u32 *)(array);		\
-		(iniarray)->ia_rows = (rows);			\
-		(iniarray)->ia_columns = (columns);		\
-	} while (0)
-
-#define INI_RA(iniarray, row, column) \
-	(((iniarray)->ia_array)[(row) *	((iniarray)->ia_columns) + (column)])
-
-#define INIT_CAL(_perCal) do {				\
-		(_perCal)->calState = CAL_WAITING;	\
-		(_perCal)->calNext = NULL;		\
-	} while (0)
-
-#define INSERT_CAL(_ahp, _perCal)					\
-	do {								\
-		if ((_ahp)->ah_cal_list_last == NULL) {			\
-			(_ahp)->ah_cal_list =				\
-				(_ahp)->ah_cal_list_last = (_perCal);	\
-			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
-		} else {						\
-			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
-			(_ahp)->ah_cal_list_last = (_perCal);		\
-			(_perCal)->calNext = (_ahp)->ah_cal_list;	\
-		}							\
-	} while (0)
-
-enum hal_cal_types {
-	ADC_DC_INIT_CAL = 0x1,
-	ADC_GAIN_CAL = 0x2,
-	ADC_DC_CAL = 0x4,
-	IQ_MISMATCH_CAL = 0x8
-};
-
-enum hal_cal_state {
-	CAL_INACTIVE,
-	CAL_WAITING,
-	CAL_RUNNING,
-	CAL_DONE
-};
-
-#define MIN_CAL_SAMPLES     1
-#define MAX_CAL_SAMPLES    64
-#define INIT_LOG_COUNT      5
-#define PER_MIN_LOG_COUNT   2
-#define PER_MAX_LOG_COUNT  10
-
-struct hal_percal_data {
-	enum hal_cal_types calType;
-	u32 calNumSamples;
-	u32 calCountMax;
-	void (*calCollect) (struct ath_hal *);
-	void (*calPostProc) (struct ath_hal *, u8);
-};
-
-struct hal_cal_list {
-	const struct hal_percal_data *calData;
-	enum hal_cal_state calState;
-	struct hal_cal_list *calNext;
-};
-
-/*
- * Enum to indentify the eeprom mappings
- */
-enum hal_eep_map {
-	EEP_MAP_DEFAULT = 0x0,
-	EEP_MAP_4KBITS,
-	EEP_MAP_MAX
-};
-
-
 struct ath_hal_5416 {
 	struct ath_hal ah;
 	union {
@@ -952,142 +612,85 @@ struct ath_hal_5416 {
 };
 #define AH5416(_ah) ((struct ath_hal_5416 *)(_ah))
 
-#define FREQ2FBIN(x, y) ((y) ? ((x) - 2300) : (((x) - 4800) / 5))
-
-#define ar5416RfDetach(ah) do {					\
-		if (AH5416(ah)->ah_rfHal.rfDetach != NULL)	\
-			AH5416(ah)->ah_rfHal.rfDetach(ah);	\
-	} while (0)
-
-#define ath9k_hw_use_flash(_ah)			\
-	(!(_ah->ah_flags & AH_USE_EEPROM))
-
-
-#define DO_DELAY(x) do {			\
-		if ((++(x) % 64) == 0)          \
-			udelay(1);		\
-	} while (0)
-
-#define REG_WRITE_ARRAY(iniarray, column, regWr) do {                   \
-		int r;							\
-		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
-			REG_WRITE(ah, INI_RA((iniarray), (r), 0),	\
-				  INI_RA((iniarray), r, (column)));	\
-			DO_DELAY(regWr);				\
-		}							\
-	} while (0)
-
-#define BASE_ACTIVATE_DELAY         100
-#define RTC_PLL_SETTLE_DELAY        1000
-#define COEF_SCALE_S                24
-#define HT40_CHANNEL_CENTER_SHIFT   10
-
-#define AR5416_EEPROM_MAGIC_OFFSET  0x0
-
-#define AR5416_EEPROM_S             2
-#define AR5416_EEPROM_OFFSET        0x2000
-#define AR5416_EEPROM_START_ADDR \
-	(AR_SREV_9100(ah)) ? 0x1fff1000 : 0x503f1200
-#define AR5416_EEPROM_MAX           0xae0
-#define ar5416_get_eep_ver(_ahp) \
-	(((_ahp)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep_rev(_ahp) \
-	(((_ahp)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
-#define ar5416_get_ntxchains(_txchainmask) \
-	(((_txchainmask >> 2) & 1) + \
-		((_txchainmask >> 1) & 1) + (_txchainmask & 1))
-
-/* EEPROM 4K bit map definations */
-#define ar5416_get_eep4k_ver(_ahp)   \
-    (((_ahp)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep4k_rev(_ahp)   \
-    (((_ahp)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
-
-
-#ifdef __BIG_ENDIAN
-#define AR5416_EEPROM_MAGIC 0x5aa5
-#else
-#define AR5416_EEPROM_MAGIC 0xa55a
+/* Attach, Detach, Reset */
+const char *ath9k_hw_probe(u16 vendorid, u16 devid);
+void ath9k_hw_detach(struct ath_hal *ah);
+struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
+				void __iomem *mem, int *error);
+void ath9k_hw_rfdetach(struct ath_hal *ah);
+int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+		   bool bChannelChange);
+bool ath9k_hw_fill_cap_info(struct ath_hal *ah);
+bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+			    u32 capability, u32 *result);
+bool ath9k_hw_setcapability(struct ath_hal *ah, enum ath9k_capability_type type,
+			    u32 capability, u32 setting, int *status);
+
+/* Key Cache Management */
+bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry);
+bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac);
+bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
+				 const struct ath9k_keyval *k,
+				 const u8 *mac, int xorKey);
+bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry);
+
+/* GPIO / RFKILL / Antennae */
+void ath9k_hw_cfg_gpio_input(struct ath_hal *ah, u32 gpio);
+u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
+void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
+			 u32 ah_signal_type);
+void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+void ath9k_enable_rfkill(struct ath_hal *ah);
 #endif
-
-#define ATH9K_POW_SM(_r, _s)     (((_r) & 0x3f) << (_s))
-
-#define ATH9K_ANTENNA0_CHAINMASK        0x1
-#define ATH9K_ANTENNA1_CHAINMASK        0x2
-
-#define ATH9K_NUM_DMA_DEBUG_REGS        8
-#define ATH9K_NUM_QUEUES                10
-
-#define HAL_NOISE_IMMUNE_MAX            4
-#define HAL_SPUR_IMMUNE_MAX             7
-#define HAL_FIRST_STEP_MAX              2
-
-#define ATH9K_ANI_OFDM_TRIG_HIGH          500
-#define ATH9K_ANI_OFDM_TRIG_LOW           200
-#define ATH9K_ANI_CCK_TRIG_HIGH           200
-#define ATH9K_ANI_CCK_TRIG_LOW            100
-#define ATH9K_ANI_NOISE_IMMUNE_LVL        4
-#define ATH9K_ANI_USE_OFDM_WEAK_SIG       true
-#define ATH9K_ANI_CCK_WEAK_SIG_THR        false
-#define ATH9K_ANI_SPUR_IMMUNE_LVL         7
-#define ATH9K_ANI_FIRSTEP_LVL             0
-#define ATH9K_ANI_RSSI_THR_HIGH           40
-#define ATH9K_ANI_RSSI_THR_LOW            7
-#define ATH9K_ANI_PERIOD                  100
-
-#define AR_GPIOD_MASK                   0x00001FFF
-#define AR_GPIO_BIT(_gpio)              (1 << (_gpio))
-
-#define HAL_EP_RND(x, mul) \
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-#define BEACON_RSSI(ahp) \
-	HAL_EP_RND(ahp->ah_stats.ast_nodestats.ns_avgbrssi, \
-		ATH9K_RSSI_EP_MULTIPLIER)
-
-#define ah_mibStats     ah_stats.ast_mibstats
-
-#define AH_TIMEOUT         100000
-#define AH_TIME_QUANTUM        10
-
-#define AR_KEYTABLE_SIZE 128
-#define POWER_UP_TIME    200000
-
-#define EXT_ADDITIVE (0x8000)
-#define CTL_11A_EXT (CTL_11A | EXT_ADDITIVE)
-#define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
-#define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
-
-#define SUB_NUM_CTL_MODES_AT_5G_40 2
-#define SUB_NUM_CTL_MODES_AT_2G_40 3
-#define SPUR_RSSI_THRESH 40
-
-#define TU_TO_USEC(_tu)         ((_tu) << 10)
-
-#define CAB_TIMEOUT_VAL         10
-#define BEACON_TIMEOUT_VAL      10
-#define MIN_BEACON_TIMEOUT_VAL   1
-#define SLEEP_SLOP               3
-
-#define CCK_SIFS_TIME        10
-#define CCK_PREAMBLE_BITS   144
-#define CCK_PLCP_BITS        48
-
-#define OFDM_SIFS_TIME        16
-#define OFDM_PREAMBLE_TIME    20
-#define OFDM_PLCP_BITS        22
-#define OFDM_SYMBOL_TIME      4
-
-#define OFDM_SIFS_TIME_HALF     32
-#define OFDM_PREAMBLE_TIME_HALF 40
-#define OFDM_PLCP_BITS_HALF     22
-#define OFDM_SYMBOL_TIME_HALF   8
-
-#define OFDM_SIFS_TIME_QUARTER      64
-#define OFDM_PREAMBLE_TIME_QUARTER  80
-#define OFDM_PLCP_BITS_QUARTER      22
-#define OFDM_SYMBOL_TIME_QUARTER    16
-
-u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
-			enum eeprom_param param);
+u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
+void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna);
+bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
+			       enum ath9k_ant_setting settings,
+			       struct ath9k_channel *chan,
+			       u8 *tx_chainmask, u8 *rx_chainmask,
+			       u8 *antenna_cfgd);
+
+/* General Operation */
+bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val);
+u32 ath9k_hw_reverse_bits(u32 val, u32 n);
+bool ath9k_get_channel_edges(struct ath_hal *ah, u16 flags, u16 *low, u16 *high);
+u16 ath9k_hw_computetxtime(struct ath_hal *ah, struct ath_rate_table *rates,
+			   u32 frameLen, u16 rateix, bool shortPreamble);
+void ath9k_hw_get_channel_centers(struct ath_hal *ah,
+				  struct ath9k_channel *chan,
+				  struct chan_centers *centers);
+u32 ath9k_hw_getrxfilter(struct ath_hal *ah);
+void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits);
+bool ath9k_hw_phy_disable(struct ath_hal *ah);
+bool ath9k_hw_disable(struct ath_hal *ah);
+bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
+void ath9k_hw_getmac(struct ath_hal *ah, u8 *mac);
+bool ath9k_hw_setmac(struct ath_hal *ah, const u8 *mac);
+void ath9k_hw_setopmode(struct ath_hal *ah);
+void ath9k_hw_setmcastfilter(struct ath_hal *ah, u32 filter0, u32 filter1);
+void ath9k_hw_getbssidmask(struct ath_hal *ah, u8 *mask);
+bool ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask);
+void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid, u16 assocId);
+u64 ath9k_hw_gettsf64(struct ath_hal *ah);
+void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64);
+void ath9k_hw_reset_tsf(struct ath_hal *ah);
+bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting);
+bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us);
+void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
+void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period);
+void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
+				    const struct ath9k_beacon_state *bs);
+bool ath9k_hw_setpower(struct ath_hal *ah,
+		       enum ath9k_power_mode mode);
+void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
+
+/* Interrupt Handling */
+bool ath9k_hw_intrpend(struct ath_hal *ah);
+bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked);
+enum ath9k_int ath9k_hw_intrget(struct ath_hal *ah);
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints);
+
+void ath9k_hw_btcoex_enable(struct ath_hal *ah);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index 2427c44..b375a29 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 					struct ath9k_tx_queue_info *qi)
diff --git a/drivers/net/wireless/ath9k/mac.h b/drivers/net/wireless/ath9k/mac.h
new file mode 100644
index 0000000..9012af2
--- /dev/null
+++ b/drivers/net/wireless/ath9k/mac.h
@@ -0,0 +1,676 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#ifndef MAC_H
+#define MAC_H
+
+#define RXSTATUS_RATE(ah, ads) (AR_SREV_5416_V20_OR_LATER(ah) ?		\
+				MS(ads->ds_rxstatus0, AR_RxRate) :	\
+				(ads->ds_rxstatus3 >> 2) & 0xFF)
+
+#define set11nTries(_series, _index) \
+	(SM((_series)[_index].Tries, AR_XmitDataTries##_index))
+
+#define set11nRate(_series, _index) \
+	(SM((_series)[_index].Rate, AR_XmitRate##_index))
+
+#define set11nPktDurRTSCTS(_series, _index)				\
+	(SM((_series)[_index].PktDuration, AR_PacketDur##_index) |	\
+	 ((_series)[_index].RateFlags & ATH9K_RATESERIES_RTS_CTS   ?	\
+	  AR_RTSCTSQual##_index : 0))
+
+#define set11nRateFlags(_series, _index)				\
+	(((_series)[_index].RateFlags & ATH9K_RATESERIES_2040 ?		\
+	  AR_2040_##_index : 0)						\
+	 |((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ?	\
+	   AR_GI##_index : 0)						\
+	 |SM((_series)[_index].ChSel, AR_ChainSel##_index))
+
+#define CCK_SIFS_TIME        10
+#define CCK_PREAMBLE_BITS   144
+#define CCK_PLCP_BITS        48
+
+#define OFDM_SIFS_TIME        16
+#define OFDM_PREAMBLE_TIME    20
+#define OFDM_PLCP_BITS        22
+#define OFDM_SYMBOL_TIME      4
+
+#define OFDM_SIFS_TIME_HALF     32
+#define OFDM_PREAMBLE_TIME_HALF 40
+#define OFDM_PLCP_BITS_HALF     22
+#define OFDM_SYMBOL_TIME_HALF   8
+
+#define OFDM_SIFS_TIME_QUARTER      64
+#define OFDM_PREAMBLE_TIME_QUARTER  80
+#define OFDM_PLCP_BITS_QUARTER      22
+#define OFDM_SYMBOL_TIME_QUARTER    16
+
+#define INIT_AIFS       2
+#define INIT_CWMIN      15
+#define INIT_CWMIN_11B  31
+#define INIT_CWMAX      1023
+#define INIT_SH_RETRY   10
+#define INIT_LG_RETRY   10
+#define INIT_SSH_RETRY  32
+#define INIT_SLG_RETRY  32
+
+#define ATH9K_SLOT_TIME_6 6
+#define ATH9K_SLOT_TIME_9 9
+#define ATH9K_SLOT_TIME_20 20
+
+#define ATH9K_TXERR_XRETRY         0x01
+#define ATH9K_TXERR_FILT           0x02
+#define ATH9K_TXERR_FIFO           0x04
+#define ATH9K_TXERR_XTXOP          0x08
+#define ATH9K_TXERR_TIMER_EXPIRED  0x10
+
+#define ATH9K_TX_BA                0x01
+#define ATH9K_TX_PWRMGMT           0x02
+#define ATH9K_TX_DESC_CFG_ERR      0x04
+#define ATH9K_TX_DATA_UNDERRUN     0x08
+#define ATH9K_TX_DELIM_UNDERRUN    0x10
+#define ATH9K_TX_SW_ABORTED        0x40
+#define ATH9K_TX_SW_FILTERED       0x80
+
+#define MIN_TX_FIFO_THRESHOLD   0x1
+#define MAX_TX_FIFO_THRESHOLD   ((4096 / 64) - 1)
+#define INIT_TX_FIFO_THRESHOLD  MIN_TX_FIFO_THRESHOLD
+
+struct ath_tx_status {
+	u32 ts_tstamp;
+	u16 ts_seqnum;
+	u8 ts_status;
+	u8 ts_ratecode;
+	u8 ts_rateindex;
+	int8_t ts_rssi;
+	u8 ts_shortretry;
+	u8 ts_longretry;
+	u8 ts_virtcol;
+	u8 ts_antenna;
+	u8 ts_flags;
+	int8_t ts_rssi_ctl0;
+	int8_t ts_rssi_ctl1;
+	int8_t ts_rssi_ctl2;
+	int8_t ts_rssi_ext0;
+	int8_t ts_rssi_ext1;
+	int8_t ts_rssi_ext2;
+	u8 pad[3];
+	u32 ba_low;
+	u32 ba_high;
+	u32 evm0;
+	u32 evm1;
+	u32 evm2;
+};
+
+struct ath_rx_status {
+	u32 rs_tstamp;
+	u16 rs_datalen;
+	u8 rs_status;
+	u8 rs_phyerr;
+	int8_t rs_rssi;
+	u8 rs_keyix;
+	u8 rs_rate;
+	u8 rs_antenna;
+	u8 rs_more;
+	int8_t rs_rssi_ctl0;
+	int8_t rs_rssi_ctl1;
+	int8_t rs_rssi_ctl2;
+	int8_t rs_rssi_ext0;
+	int8_t rs_rssi_ext1;
+	int8_t rs_rssi_ext2;
+	u8 rs_isaggr;
+	u8 rs_moreaggr;
+	u8 rs_num_delims;
+	u8 rs_flags;
+	u32 evm0;
+	u32 evm1;
+	u32 evm2;
+};
+
+#define ATH9K_RXERR_CRC           0x01
+#define ATH9K_RXERR_PHY           0x02
+#define ATH9K_RXERR_FIFO          0x04
+#define ATH9K_RXERR_DECRYPT       0x08
+#define ATH9K_RXERR_MIC           0x10
+
+#define ATH9K_RX_MORE             0x01
+#define ATH9K_RX_MORE_AGGR        0x02
+#define ATH9K_RX_GI               0x04
+#define ATH9K_RX_2040             0x08
+#define ATH9K_RX_DELIM_CRC_PRE    0x10
+#define ATH9K_RX_DELIM_CRC_POST   0x20
+#define ATH9K_RX_DECRYPT_BUSY     0x40
+
+#define ATH9K_RXKEYIX_INVALID	((u8)-1)
+#define ATH9K_TXKEYIX_INVALID	((u32)-1)
+
+struct ath_desc {
+	u32 ds_link;
+	u32 ds_data;
+	u32 ds_ctl0;
+	u32 ds_ctl1;
+	u32 ds_hw[20];
+	union {
+		struct ath_tx_status tx;
+		struct ath_rx_status rx;
+		void *stats;
+	} ds_us;
+	void *ds_vdata;
+} __packed;
+
+#define	ds_txstat	ds_us.tx
+#define	ds_rxstat	ds_us.rx
+#define ds_stat		ds_us.stats
+
+#define ATH9K_TXDESC_CLRDMASK		0x0001
+#define ATH9K_TXDESC_NOACK		0x0002
+#define ATH9K_TXDESC_RTSENA		0x0004
+#define ATH9K_TXDESC_CTSENA		0x0008
+/* ATH9K_TXDESC_INTREQ forces a tx interrupt to be generated for
+ * the descriptor its marked on.  We take a tx interrupt to reap
+ * descriptors when the h/w hits an EOL condition or
+ * when the descriptor is specifically marked to generate
+ * an interrupt with this flag. Descriptors should be
+ * marked periodically to insure timely replenishing of the
+ * supply needed for sending frames. Defering interrupts
+ * reduces system load and potentially allows more concurrent
+ * work to be done but if done to aggressively can cause
+ * senders to backup. When the hardware queue is left too
+ * large rate control information may also be too out of
+ * date. An Alternative for this is TX interrupt mitigation
+ * but this needs more testing. */
+#define ATH9K_TXDESC_INTREQ		0x0010
+#define ATH9K_TXDESC_VEOL		0x0020
+#define ATH9K_TXDESC_EXT_ONLY		0x0040
+#define ATH9K_TXDESC_EXT_AND_CTL	0x0080
+#define ATH9K_TXDESC_VMF		0x0100
+#define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
+#define ATH9K_TXDESC_CAB		0x0400
+
+#define ATH9K_RXDESC_INTREQ		0x0020
+
+struct ar5416_desc {
+	u32 ds_link;
+	u32 ds_data;
+	u32 ds_ctl0;
+	u32 ds_ctl1;
+	union {
+		struct {
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
+		} tx;
+		struct {
+			u32 status0;
+			u32 status1;
+			u32 status2;
+			u32 status3;
+			u32 status4;
+			u32 status5;
+			u32 status6;
+			u32 status7;
+			u32 status8;
+		} rx;
+	} u;
+} __packed;
+
+#define AR5416DESC(_ds)         ((struct ar5416_desc *)(_ds))
+#define AR5416DESC_CONST(_ds)   ((const struct ar5416_desc *)(_ds))
+
+#define ds_ctl2     u.tx.ctl2
+#define ds_ctl3     u.tx.ctl3
+#define ds_ctl4     u.tx.ctl4
+#define ds_ctl5     u.tx.ctl5
+#define ds_ctl6     u.tx.ctl6
+#define ds_ctl7     u.tx.ctl7
+#define ds_ctl8     u.tx.ctl8
+#define ds_ctl9     u.tx.ctl9
+#define ds_ctl10    u.tx.ctl10
+#define ds_ctl11    u.tx.ctl11
+
+#define ds_txstatus0    u.tx.status0
+#define ds_txstatus1    u.tx.status1
+#define ds_txstatus2    u.tx.status2
+#define ds_txstatus3    u.tx.status3
+#define ds_txstatus4    u.tx.status4
+#define ds_txstatus5    u.tx.status5
+#define ds_txstatus6    u.tx.status6
+#define ds_txstatus7    u.tx.status7
+#define ds_txstatus8    u.tx.status8
+#define ds_txstatus9    u.tx.status9
+
+#define ds_rxstatus0    u.rx.status0
+#define ds_rxstatus1    u.rx.status1
+#define ds_rxstatus2    u.rx.status2
+#define ds_rxstatus3    u.rx.status3
+#define ds_rxstatus4    u.rx.status4
+#define ds_rxstatus5    u.rx.status5
+#define ds_rxstatus6    u.rx.status6
+#define ds_rxstatus7    u.rx.status7
+#define ds_rxstatus8    u.rx.status8
+
+#define AR_FrameLen         0x00000fff
+#define AR_VirtMoreFrag     0x00001000
+#define AR_TxCtlRsvd00      0x0000e000
+#define AR_XmitPower        0x003f0000
+#define AR_XmitPower_S      16
+#define AR_RTSEnable        0x00400000
+#define AR_VEOL             0x00800000
+#define AR_ClrDestMask      0x01000000
+#define AR_TxCtlRsvd01      0x1e000000
+#define AR_TxIntrReq        0x20000000
+#define AR_DestIdxValid     0x40000000
+#define AR_CTSEnable        0x80000000
+
+#define AR_BufLen           0x00000fff
+#define AR_TxMore           0x00001000
+#define AR_DestIdx          0x000fe000
+#define AR_DestIdx_S        13
+#define AR_FrameType        0x00f00000
+#define AR_FrameType_S      20
+#define AR_NoAck            0x01000000
+#define AR_InsertTS         0x02000000
+#define AR_CorruptFCS       0x04000000
+#define AR_ExtOnly          0x08000000
+#define AR_ExtAndCtl        0x10000000
+#define AR_MoreAggr         0x20000000
+#define AR_IsAggr           0x40000000
+
+#define AR_BurstDur         0x00007fff
+#define AR_BurstDur_S       0
+#define AR_DurUpdateEna     0x00008000
+#define AR_XmitDataTries0   0x000f0000
+#define AR_XmitDataTries0_S 16
+#define AR_XmitDataTries1   0x00f00000
+#define AR_XmitDataTries1_S 20
+#define AR_XmitDataTries2   0x0f000000
+#define AR_XmitDataTries2_S 24
+#define AR_XmitDataTries3   0xf0000000
+#define AR_XmitDataTries3_S 28
+
+#define AR_XmitRate0        0x000000ff
+#define AR_XmitRate0_S      0
+#define AR_XmitRate1        0x0000ff00
+#define AR_XmitRate1_S      8
+#define AR_XmitRate2        0x00ff0000
+#define AR_XmitRate2_S      16
+#define AR_XmitRate3        0xff000000
+#define AR_XmitRate3_S      24
+
+#define AR_PacketDur0       0x00007fff
+#define AR_PacketDur0_S     0
+#define AR_RTSCTSQual0      0x00008000
+#define AR_PacketDur1       0x7fff0000
+#define AR_PacketDur1_S     16
+#define AR_RTSCTSQual1      0x80000000
+
+#define AR_PacketDur2       0x00007fff
+#define AR_PacketDur2_S     0
+#define AR_RTSCTSQual2      0x00008000
+#define AR_PacketDur3       0x7fff0000
+#define AR_PacketDur3_S     16
+#define AR_RTSCTSQual3      0x80000000
+
+#define AR_AggrLen          0x0000ffff
+#define AR_AggrLen_S        0
+#define AR_TxCtlRsvd60      0x00030000
+#define AR_PadDelim         0x03fc0000
+#define AR_PadDelim_S       18
+#define AR_EncrType         0x0c000000
+#define AR_EncrType_S       26
+#define AR_TxCtlRsvd61      0xf0000000
+
+#define AR_2040_0           0x00000001
+#define AR_GI0              0x00000002
+#define AR_ChainSel0        0x0000001c
+#define AR_ChainSel0_S      2
+#define AR_2040_1           0x00000020
+#define AR_GI1              0x00000040
+#define AR_ChainSel1        0x00000380
+#define AR_ChainSel1_S      7
+#define AR_2040_2           0x00000400
+#define AR_GI2              0x00000800
+#define AR_ChainSel2        0x00007000
+#define AR_ChainSel2_S      12
+#define AR_2040_3           0x00008000
+#define AR_GI3              0x00010000
+#define AR_ChainSel3        0x000e0000
+#define AR_ChainSel3_S      17
+#define AR_RTSCTSRate       0x0ff00000
+#define AR_RTSCTSRate_S     20
+#define AR_TxCtlRsvd70      0xf0000000
+
+#define AR_TxRSSIAnt00      0x000000ff
+#define AR_TxRSSIAnt00_S    0
+#define AR_TxRSSIAnt01      0x0000ff00
+#define AR_TxRSSIAnt01_S    8
+#define AR_TxRSSIAnt02      0x00ff0000
+#define AR_TxRSSIAnt02_S    16
+#define AR_TxStatusRsvd00   0x3f000000
+#define AR_TxBaStatus       0x40000000
+#define AR_TxStatusRsvd01   0x80000000
+
+#define AR_FrmXmitOK            0x00000001
+#define AR_ExcessiveRetries     0x00000002
+#define AR_FIFOUnderrun         0x00000004
+#define AR_Filtered             0x00000008
+#define AR_RTSFailCnt           0x000000f0
+#define AR_RTSFailCnt_S         4
+#define AR_DataFailCnt          0x00000f00
+#define AR_DataFailCnt_S        8
+#define AR_VirtRetryCnt         0x0000f000
+#define AR_VirtRetryCnt_S       12
+#define AR_TxDelimUnderrun      0x00010000
+#define AR_TxDataUnderrun       0x00020000
+#define AR_DescCfgErr           0x00040000
+#define AR_TxTimerExpired       0x00080000
+#define AR_TxStatusRsvd10       0xfff00000
+
+#define AR_SendTimestamp    ds_txstatus2
+#define AR_BaBitmapLow      ds_txstatus3
+#define AR_BaBitmapHigh     ds_txstatus4
+
+#define AR_TxRSSIAnt10      0x000000ff
+#define AR_TxRSSIAnt10_S    0
+#define AR_TxRSSIAnt11      0x0000ff00
+#define AR_TxRSSIAnt11_S    8
+#define AR_TxRSSIAnt12      0x00ff0000
+#define AR_TxRSSIAnt12_S    16
+#define AR_TxRSSICombined   0xff000000
+#define AR_TxRSSICombined_S 24
+
+#define AR_TxEVM0           ds_txstatus5
+#define AR_TxEVM1           ds_txstatus6
+#define AR_TxEVM2           ds_txstatus7
+
+#define AR_TxDone           0x00000001
+#define AR_SeqNum           0x00001ffe
+#define AR_SeqNum_S         1
+#define AR_TxStatusRsvd80   0x0001e000
+#define AR_TxOpExceeded     0x00020000
+#define AR_TxStatusRsvd81   0x001c0000
+#define AR_FinalTxIdx       0x00600000
+#define AR_FinalTxIdx_S     21
+#define AR_TxStatusRsvd82   0x01800000
+#define AR_PowerMgmt        0x02000000
+#define AR_TxStatusRsvd83   0xfc000000
+
+#define AR_RxCTLRsvd00  0xffffffff
+
+#define AR_BufLen       0x00000fff
+#define AR_RxCtlRsvd00  0x00001000
+#define AR_RxIntrReq    0x00002000
+#define AR_RxCtlRsvd01  0xffffc000
+
+#define AR_RxRSSIAnt00      0x000000ff
+#define AR_RxRSSIAnt00_S    0
+#define AR_RxRSSIAnt01      0x0000ff00
+#define AR_RxRSSIAnt01_S    8
+#define AR_RxRSSIAnt02      0x00ff0000
+#define AR_RxRSSIAnt02_S    16
+#define AR_RxRate           0xff000000
+#define AR_RxRate_S         24
+#define AR_RxStatusRsvd00   0xff000000
+
+#define AR_DataLen          0x00000fff
+#define AR_RxMore           0x00001000
+#define AR_NumDelim         0x003fc000
+#define AR_NumDelim_S       14
+#define AR_RxStatusRsvd10   0xff800000
+
+#define AR_RcvTimestamp     ds_rxstatus2
+
+#define AR_GI               0x00000001
+#define AR_2040             0x00000002
+#define AR_Parallel40       0x00000004
+#define AR_Parallel40_S     2
+#define AR_RxStatusRsvd30   0x000000f8
+#define AR_RxAntenna	    0xffffff00
+#define AR_RxAntenna_S	    8
+
+#define AR_RxRSSIAnt10            0x000000ff
+#define AR_RxRSSIAnt10_S          0
+#define AR_RxRSSIAnt11            0x0000ff00
+#define AR_RxRSSIAnt11_S          8
+#define AR_RxRSSIAnt12            0x00ff0000
+#define AR_RxRSSIAnt12_S          16
+#define AR_RxRSSICombined         0xff000000
+#define AR_RxRSSICombined_S       24
+
+#define AR_RxEVM0           ds_rxstatus4
+#define AR_RxEVM1           ds_rxstatus5
+#define AR_RxEVM2           ds_rxstatus6
+
+#define AR_RxDone           0x00000001
+#define AR_RxFrameOK        0x00000002
+#define AR_CRCErr           0x00000004
+#define AR_DecryptCRCErr    0x00000008
+#define AR_PHYErr           0x00000010
+#define AR_MichaelErr       0x00000020
+#define AR_PreDelimCRCErr   0x00000040
+#define AR_RxStatusRsvd70   0x00000080
+#define AR_RxKeyIdxValid    0x00000100
+#define AR_KeyIdx           0x0000fe00
+#define AR_KeyIdx_S         9
+#define AR_PHYErrCode       0x0000ff00
+#define AR_PHYErrCode_S     8
+#define AR_RxMoreAggr       0x00010000
+#define AR_RxAggr           0x00020000
+#define AR_PostDelimCRCErr  0x00040000
+#define AR_RxStatusRsvd71   0x3ff80000
+#define AR_DecryptBusyErr   0x40000000
+#define AR_KeyMiss          0x80000000
+
+enum ath9k_tx_queue {
+	ATH9K_TX_QUEUE_INACTIVE = 0,
+	ATH9K_TX_QUEUE_DATA,
+	ATH9K_TX_QUEUE_BEACON,
+	ATH9K_TX_QUEUE_CAB,
+	ATH9K_TX_QUEUE_UAPSD,
+	ATH9K_TX_QUEUE_PSPOLL
+};
+
+#define	ATH9K_NUM_TX_QUEUES 10
+
+enum ath9k_tx_queue_subtype {
+	ATH9K_WME_AC_BK = 0,
+	ATH9K_WME_AC_BE,
+	ATH9K_WME_AC_VI,
+	ATH9K_WME_AC_VO,
+	ATH9K_WME_UPSD
+};
+
+enum ath9k_tx_queue_flags {
+	TXQ_FLAG_TXOKINT_ENABLE = 0x0001,
+	TXQ_FLAG_TXERRINT_ENABLE = 0x0001,
+	TXQ_FLAG_TXDESCINT_ENABLE = 0x0002,
+	TXQ_FLAG_TXEOLINT_ENABLE = 0x0004,
+	TXQ_FLAG_TXURNINT_ENABLE = 0x0008,
+	TXQ_FLAG_BACKOFF_DISABLE = 0x0010,
+	TXQ_FLAG_COMPRESSION_ENABLE = 0x0020,
+	TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE = 0x0040,
+	TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE = 0x0080,
+};
+
+#define ATH9K_TXQ_USEDEFAULT ((u32) -1)
+#define ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS 0x00000001
+
+#define ATH9K_DECOMP_MASK_SIZE     128
+#define ATH9K_READY_TIME_LO_BOUND  50
+#define ATH9K_READY_TIME_HI_BOUND  96
+
+enum ath9k_pkt_type {
+	ATH9K_PKT_TYPE_NORMAL = 0,
+	ATH9K_PKT_TYPE_ATIM,
+	ATH9K_PKT_TYPE_PSPOLL,
+	ATH9K_PKT_TYPE_BEACON,
+	ATH9K_PKT_TYPE_PROBE_RESP,
+	ATH9K_PKT_TYPE_CHIRP,
+	ATH9K_PKT_TYPE_GRP_POLL,
+};
+
+struct ath9k_tx_queue_info {
+	u32 tqi_ver;
+	enum ath9k_tx_queue tqi_type;
+	enum ath9k_tx_queue_subtype tqi_subtype;
+	enum ath9k_tx_queue_flags tqi_qflags;
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
+};
+
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
+};
+
+#define ATH9K_RATESERIES_RTS_CTS  0x0001
+#define ATH9K_RATESERIES_2040     0x0002
+#define ATH9K_RATESERIES_HALFGI   0x0004
+
+struct ath9k_11n_rate_series {
+	u32 Tries;
+	u32 Rate;
+	u32 PktDuration;
+	u32 ChSel;
+	u32 RateFlags;
+};
+
+struct ath9k_keyval {
+	u8 kv_type;
+	u8 kv_pad;
+	u16 kv_len;
+	u8 kv_val[16];
+	u8 kv_mic[8];
+	u8 kv_txmic[8];
+};
+
+enum ath9k_key_type {
+	ATH9K_KEY_TYPE_CLEAR,
+	ATH9K_KEY_TYPE_WEP,
+	ATH9K_KEY_TYPE_AES,
+	ATH9K_KEY_TYPE_TKIP,
+};
+
+enum ath9k_cipher {
+	ATH9K_CIPHER_WEP = 0,
+	ATH9K_CIPHER_AES_OCB = 1,
+	ATH9K_CIPHER_AES_CCM = 2,
+	ATH9K_CIPHER_CKIP = 3,
+	ATH9K_CIPHER_TKIP = 4,
+	ATH9K_CIPHER_CLR = 5,
+	ATH9K_CIPHER_MIC = 127
+};
+
+enum ath9k_ht_macmode {
+	ATH9K_HT_MACMODE_20 = 0,
+	ATH9K_HT_MACMODE_2040 = 1,
+};
+
+enum ath9k_ht_extprotspacing {
+	ATH9K_HT_EXTPROTSPACING_20 = 0,
+	ATH9K_HT_EXTPROTSPACING_25 = 1,
+};
+
+struct ath_hal;
+struct ath9k_channel;
+struct ath_rate_table;
+
+u32 ath9k_hw_gettxbuf(struct ath_hal *ah, u32 q);
+bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp);
+bool ath9k_hw_txstart(struct ath_hal *ah, u32 q);
+u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q);
+bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel);
+bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q);
+bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
+			 u32 segLen, bool firstSeg,
+			 bool lastSeg, const struct ath_desc *ds0);
+void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
+int ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds);
+void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
+			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
+			    u32 keyIx, enum ath9k_key_type keyType, u32 flags);
+void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
+				  struct ath_desc *lastds,
+				  u32 durUpdateEn, u32 rtsctsRate,
+				  u32 rtsctsDuration,
+				  struct ath9k_11n_rate_series series[],
+				  u32 nseries, u32 flags);
+void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
+				u32 aggrLen);
+void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
+				 u32 numDelims);
+void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds);
+void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds);
+void ath9k_hw_set11n_burstduration(struct ath_hal *ah, struct ath_desc *ds,
+				   u32 burstDuration);
+void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah, struct ath_desc *ds,
+				     u32 vmf);
+void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u32 *txqs);
+bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
+			    const struct ath9k_tx_queue_info *qinfo);
+bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
+			    struct ath9k_tx_queue_info *qinfo);
+int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
+			  const struct ath9k_tx_queue_info *qinfo);
+bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q);
+bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q);
+int ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
+			u32 pa, struct ath_desc *nds, u64 tsf);
+bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
+			  u32 size, u32 flags);
+bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
+void ath9k_hw_putrxbuf(struct ath_hal *ah, u32 rxdp);
+void ath9k_hw_rxena(struct ath_hal *ah);
+void ath9k_hw_startpcureceive(struct ath_hal *ah);
+void ath9k_hw_stoppcurecv(struct ath_hal *ah);
+bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
+
+#endif /* MAC_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 4095fec..2ed0bd2 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -15,9 +15,7 @@
  */
 
 #include <linux/nl80211.h>
-#include "core.h"
-#include "reg.h"
-#include "hw.h"
+#include "ath9k.h"
 
 #define ATH_PCI_VERSION "0.1"
 
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 05612bf..aa3ac20 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -16,9 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/pci.h>
-#include "core.h"
-#include "reg.h"
-#include "hw.h"
+#include "ath9k.h"
 
 static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0023) }, /* PCI   */
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 766982a..ea29941 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -14,10 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
-#include "hw.h"
-#include "reg.h"
-#include "phy.h"
+#include "ath9k.h"
 
 void
 ath9k_hw_write_regs(struct ath_hal *ah, u32 modesIndex, u32 freqIndex,
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 69a4ca4..060a7cf 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -15,7 +15,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
+#include "ath9k.h"
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index a987cb9..d688ec5 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -19,13 +19,12 @@
 #ifndef RC_H
 #define RC_H
 
-#include "ath9k.h"
-
 struct ath_softc;
 
 #define ATH_RATE_MAX     30
 #define RATE_TABLE_SIZE  64
 #define MAX_TX_RATE_PHY  48
+#define WLAN_CTRL_FRAME_SIZE (2+2+6+4)
 
 /* VALID_ALL - valid for 20/40/Legacy,
  * VALID - Legacy only,
@@ -39,6 +38,20 @@ struct ath_softc;
 #define VALID_2040 (VALID_20|VALID_40)
 #define VALID_ALL  (VALID_2040|VALID)
 
+enum {
+	WLAN_RC_PHY_OFDM,
+	WLAN_RC_PHY_CCK,
+	WLAN_RC_PHY_HT_20_SS,
+	WLAN_RC_PHY_HT_20_DS,
+	WLAN_RC_PHY_HT_40_SS,
+	WLAN_RC_PHY_HT_40_DS,
+	WLAN_RC_PHY_HT_20_SS_HGI,
+	WLAN_RC_PHY_HT_20_DS_HGI,
+	WLAN_RC_PHY_HT_40_SS_HGI,
+	WLAN_RC_PHY_HT_40_DS_HGI,
+	WLAN_RC_PHY_MAX
+};
+
 #define WLAN_RC_PHY_DS(_phy)   ((_phy == WLAN_RC_PHY_HT_20_DS)		\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
 				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)	\
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 630fa57..69dd5e2 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
+#include "ath9k.h"
 
 /*
  * Setup and link descriptors.
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index c967b79..45b9fbf 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -160,6 +160,7 @@
 
 #define AR_SREV_VERSION_9100                  0x014
 
+#define AR_SREV_9100(ah) ((ah->ah_macVersion) == AR_SREV_VERSION_9100)
 #define AR_SREV_5416_V20_OR_LATER(_ah) \
 	(AR_SREV_9100((_ah)) || AR_SREV_5416_20_OR_LATER(_ah))
 #define AR_SREV_5416_V22_OR_LATER(_ah) \
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index fe08a4f..819feb9 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -16,9 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include "core.h"
-#include "hw.h"
-#include "regd.h"
+#include "ath9k.h"
 #include "regd_common.h"
 
 /*
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index ba2d2df..d1c4457 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -17,8 +17,6 @@
 #ifndef REGD_H
 #define REGD_H
 
-#include "ath9k.h"
-
 #define COUNTRY_ERD_FLAG        0x8000
 #define WORLDWIDE_ROAMING_FLAG  0x4000
 
@@ -229,6 +227,16 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
+u16 ath9k_regd_get_rd(struct ath_hal *ah);
+bool ath9k_is_world_regd(struct ath_hal *ah);
+const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah);
+const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
+void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby);
+void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
+int ath9k_regd_init(struct ath_hal *ah);
+bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah);
+u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
+int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
 void ath9k_regd_get_current_country(struct ath_hal *ah,
 				    struct ath9k_country_entry *ctry);
 
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index d5f15e7..7a3ea92 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "core.h"
+#include "ath9k.h"
 
 #define BITS_PER_BYTE           8
 #define OFDM_PLCP_BITS          22
-- 
1.6.1

