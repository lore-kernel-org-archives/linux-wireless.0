Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZKGUTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:03 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 27/29] ath9k_common: add new module to share 802.11n driver helpers
Date: Sat,  7 Nov 2009 15:19:04 -0500
Message-Id: <1257625146-17971-28-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k and ath9k_htc share a lot of common hardware characteristics.
They only differ in that ath9k_htc works with a target CPU and ath9k
works directly with the hardware. ath9k_htc will do *some* things in
the firmware, but a lot of others on the host.

The common 802.11n hardware code is already shared through the ath9k_hw
module. Common helpers amongst all Atheros drivers can use the ath module,
this includes ath5k and ar9170 as users. But there is some common driver
specific helpers which are not exactly hardware code which ath9k and
ath9k_htc can share. We'll be using ath9k_common for this to avoid
bloating the ath module and the common 802.11n hardware module ath9k_hw.

We start by sharing skb pre and post processing in preparation for a hand
off to mac80211.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |    3 +
 drivers/net/wireless/ath/ath9k/Makefile |    3 +
 drivers/net/wireless/ath/ath9k/ath9k.h  |   95 +---------
 drivers/net/wireless/ath/ath9k/common.c |  326 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |  123 ++++++++++++
 drivers/net/wireless/ath/ath9k/rc.h     |    2 +
 drivers/net/wireless/ath/ath9k/recv.c   |  284 +--------------------------
 7 files changed, 467 insertions(+), 369 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common.h

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index b735fb3..006364f 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,5 +1,7 @@
 config ATH9K_HW
 	tristate
+config ATH9K_COMMON
+	tristate
 
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
@@ -8,6 +10,7 @@ config ATH9K
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
+	select ATH9K_COMMON
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 8caf2a8..e53f968 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -23,3 +23,6 @@ ath9k_hw-y:=	hw.o \
 		mac.o \
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
+
+obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
+ath9k_common-y:=	common.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 88969cb..d9bcc3a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -19,14 +19,16 @@
 
 #include <linux/etherdevice.h>
 #include <linux/device.h>
-#include <net/mac80211.h>
 #include <linux/leds.h>
 
-#include "hw.h"
 #include "rc.h"
 #include "debug.h"
-#include "../ath.h"
-#include "../debug.h"
+#include "common.h"
+
+/*
+ * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
+ * should rely on this file or its contents.
+ */
 
 struct ath_node;
 
@@ -99,18 +101,6 @@ enum buffer_type {
 	BUF_XRETRY		= BIT(5),
 };
 
-struct ath_buf_state {
-	int bfs_nframes;
-	u16 bfs_al;
-	u16 bfs_frmlen;
-	int bfs_seqno;
-	int bfs_tidno;
-	int bfs_retries;
-	u8 bf_type;
-	u32 bfs_keyix;
-	enum ath9k_key_type bfs_keytype;
-};
-
 #define bf_nframes      	bf_state.bfs_nframes
 #define bf_al           	bf_state.bfs_al
 #define bf_frmlen       	bf_state.bfs_frmlen
@@ -125,21 +115,6 @@ struct ath_buf_state {
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
-struct ath_buf {
-	struct list_head list;
-	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
-					   an aggregate) */
-	struct ath_buf *bf_next;	/* next subframe in the aggregate */
-	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
-	struct ath_desc *bf_desc;	/* virtual addr of desc */
-	dma_addr_t bf_daddr;		/* physical addr of desc */
-	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
-	bool bf_stale;
-	u16 bf_flags;
-	struct ath_buf_state bf_state;
-	dma_addr_t bf_dmacontext;
-};
-
 struct ath_descdma {
 	struct ath_desc *dd_desc;
 	dma_addr_t dd_desc_paddr;
@@ -159,13 +134,9 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 
 #define ATH_MAX_ANTENNA         3
 #define ATH_RXBUF               512
-#define WME_NUM_TID             16
 #define ATH_TXBUF               512
 #define ATH_TXMAXTRY            13
 #define ATH_MGT_TXMAXTRY        4
-#define WME_BA_BMP_SIZE         64
-#define WME_MAX_BA              WME_BA_BMP_SIZE
-#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
 
 #define TID_TO_WME_AC(_tid)				\
 	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
@@ -173,12 +144,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
 	 WME_AC_VO)
 
-#define WME_AC_BE   0
-#define WME_AC_BK   1
-#define WME_AC_VI   2
-#define WME_AC_VO   3
-#define WME_NUM_AC  4
-
 #define ADDBA_EXCHANGE_ATTEMPTS    10
 #define ATH_AGGR_DELIM_SZ          4
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
@@ -252,30 +217,6 @@ struct ath_txq {
 #define AGGR_ADDBA_COMPLETE  BIT(2)
 #define AGGR_ADDBA_PROGRESS  BIT(3)
 
-struct ath_atx_tid {
-	struct list_head list;
-	struct list_head buf_q;
-	struct ath_node *an;
-	struct ath_atx_ac *ac;
-	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
-	u16 seq_start;
-	u16 seq_next;
-	u16 baw_size;
-	int tidno;
-	int baw_head;	/* first un-acked tx buffer */
-	int baw_tail;	/* next unused tx buffer slot */
-	int sched;
-	int paused;
-	u8 state;
-};
-
-struct ath_atx_ac {
-	int sched;
-	int qnum;
-	struct list_head list;
-	struct list_head tid_q;
-};
-
 struct ath_tx_control {
 	struct ath_txq *txq;
 	int if_id;
@@ -286,29 +227,6 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
-#define ATH_RSSI_LPF_LEN 		10
-#define RSSI_LPF_THRESHOLD		-20
-#define ATH_RSSI_EP_MULTIPLIER     (1<<7)
-#define ATH_EP_MUL(x, mul)         ((x) * (mul))
-#define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
-#define ATH_LPF_RSSI(x, y, len) \
-    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
-#define ATH_RSSI_LPF(x, y) do {                     			\
-    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
-	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
-} while (0)
-#define ATH_EP_RND(x, mul) 						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-
-struct ath_node {
-	struct ath_softc *an_sc;
-	struct ath_atx_tid tid[WME_NUM_TID];
-	struct ath_atx_ac ac[WME_NUM_AC];
-	u16 maxampdu;
-	u8 mpdudensity;
-	int last_rssi;
-};
-
 struct ath_tx {
 	u16 seq_no;
 	u32 txqsetup;
@@ -493,7 +411,6 @@ struct ath_led {
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
 
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
-#define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RATE_DUMMY_MARKER   0
 
 #define SC_OP_INVALID           BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
new file mode 100644
index 0000000..5fb164e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -0,0 +1,326 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+/*
+ * Module for common driver code between ath9k and ath9k_htc
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "common.h"
+
+MODULE_AUTHOR("Atheros Communications");
+MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
+MODULE_LICENSE("Dual BSD/GPL");
+
+/* Common RX processing */
+
+/* Assumes you've already done the endian to CPU conversion */
+static bool ath9k_rx_accept(struct ath_common *common,
+			    struct sk_buff *skb,
+			    struct ieee80211_rx_status *rxs,
+			    struct ath_rx_status *rx_stats,
+			    bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = hdr->frame_control;
+
+	if (!rx_stats->rs_datalen)
+		return false;
+        /*
+         * rs_status follows rs_datalen so if rs_datalen is too large
+         * we can take a hint that hardware corrupted it, so ignore
+         * those frames.
+         */
+	if (rx_stats->rs_datalen > common->rx_bufsize)
+		return false;
+
+	if (rx_stats->rs_more) {
+		/*
+		 * Frame spans multiple descriptors; this cannot happen yet
+		 * as we don't support jumbograms. If not in monitor mode,
+		 * discard the frame. Enable this if you want to see
+		 * error frames in Monitor mode.
+		 */
+		if (ah->opmode != NL80211_IFTYPE_MONITOR)
+			return false;
+	} else if (rx_stats->rs_status != 0) {
+		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
+			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
+		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
+			return false;
+
+		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
+			*decrypt_error = true;
+		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
+			if (ieee80211_is_ctl(fc))
+				/*
+				 * Sometimes, we get invalid
+				 * MIC failures on valid control frames.
+				 * Remove these mic errors.
+				 */
+				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
+			else
+				rxs->flag |= RX_FLAG_MMIC_ERROR;
+		}
+		/*
+		 * Reject error frames with the exception of
+		 * decryption and MIC failures. For monitor mode,
+		 * we also ignore the CRC error.
+		 */
+		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
+			if (rx_stats->rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+			      ATH9K_RXERR_CRC))
+				return false;
+		} else {
+			if (rx_stats->rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
+				return false;
+			}
+		}
+	}
+	return true;
+}
+
+static u8 ath9k_process_rate(struct ath_common *common,
+			     struct ieee80211_hw *hw,
+			     struct ath_rx_status *rx_stats,
+			     struct ieee80211_rx_status *rxs,
+			     struct sk_buff *skb)
+{
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
+	unsigned int i = 0;
+
+	band = hw->conf.channel->band;
+	sband = hw->wiphy->bands[band];
+
+	if (rx_stats->rs_rate & 0x80) {
+		/* HT rate */
+		rxs->flag |= RX_FLAG_HT;
+		if (rx_stats->rs_flags & ATH9K_RX_2040)
+			rxs->flag |= RX_FLAG_40MHZ;
+		if (rx_stats->rs_flags & ATH9K_RX_GI)
+			rxs->flag |= RX_FLAG_SHORT_GI;
+		return rx_stats->rs_rate & 0x7f;
+	}
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
+			return i;
+		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
+			rxs->flag |= RX_FLAG_SHORTPRE;
+			return i;
+		}
+	}
+
+	/* No valid hardware bitrate found -- we should not get here */
+	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
+		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
+	if ((common->debug_mask & ATH_DBG_XMIT))
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
+
+        return 0;
+}
+
+/*
+ * Theory for reporting quality:
+ *
+ * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
+ * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
+ * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
+ *
+ * MCS 7  is the highets MCS index usable by a 1-stream device.
+ * MCS 15 is the highest MCS index usable by a 2-stream device.
+ *
+ * All ath9k devices are either 1-stream or 2-stream.
+ *
+ * How many bars you see is derived from the qual reporting.
+ *
+ * A more elaborate scheme can be used here but it requires tables
+ * of SNR/throughput for each possible mode used. For the MCS table
+ * you can refer to the wireless wiki:
+ *
+ * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
+ *
+ */
+static int ath9k_compute_qual(struct ieee80211_hw *hw,
+			      struct ath_rx_status *rx_stats)
+{
+	int qual;
+
+	if (conf_is_ht(&hw->conf))
+		qual =  rx_stats->rs_rssi * 100 / 45;
+	else
+		qual =  rx_stats->rs_rssi * 100 / 35;
+
+	/*
+	 * rssi can be more than 45 though, anything above that
+	 * should be considered at 100%
+	 */
+	if (qual > 100)
+		qual = 100;
+
+	return qual;
+}
+
+static void ath9k_process_rssi(struct ath_common *common,
+			       struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct ath_rx_status *rx_stats)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr;
+	struct ath_node *an;
+	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	rcu_read_lock();
+	/*
+	 * XXX: use ieee80211_find_sta! This requires quite a bit of work
+	 * under the current ath9k virtual wiphy implementation as we have
+	 * no way of tying a vif to wiphy. Typically vifs are attached to
+	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
+	 * wiphy you'd have to iterate over every wiphy and each sdata.
+	 */
+	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
+	if (sta) {
+		an = (struct ath_node *) sta->drv_priv;
+		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
+		   !rx_stats->rs_moreaggr)
+			ATH_RSSI_LPF(an->last_rssi, rx_stats->rs_rssi);
+		last_rssi = an->last_rssi;
+	}
+	rcu_read_unlock();
+
+	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
+					      ATH_RSSI_EP_MULTIPLIER);
+	if (rx_stats->rs_rssi < 0)
+		rx_stats->rs_rssi = 0;
+	else if (rx_stats->rs_rssi > 127)
+		rx_stats->rs_rssi = 127;
+
+	/* Update Beacon RSSI, this is used by ANI. */
+	if (ieee80211_is_beacon(fc))
+		ah->stats.avgbrssi = rx_stats->rs_rssi;
+}
+
+/*
+ * For Decrypt or Demic errors, we only mark packet status here and always push
+ * up the frame up to let mac80211 handle the actual error case, be it no
+ * decryption key or real decryption error. This let us keep statistics there.
+ */
+int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
+				struct ieee80211_hw *hw,
+				struct sk_buff *skb,
+				struct ath_rx_status *rx_stats,
+				struct ieee80211_rx_status *rx_status,
+				bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+
+	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
+		return -EINVAL;
+
+	ath9k_process_rssi(common, hw, skb, rx_stats);
+
+	rx_status->rate_idx = ath9k_process_rate(common, hw,
+						 rx_stats, rx_status, skb);
+	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
+	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->noise = common->ani.noise_floor;
+	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
+	rx_status->antenna = rx_stats->rs_antenna;
+	rx_status->qual = ath9k_compute_qual(hw, rx_stats);
+	rx_status->flag |= RX_FLAG_TSFT;
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_cmn_rx_skb_preprocess);
+
+void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
+				  struct sk_buff *skb,
+				  struct ath_rx_status *rx_stats,
+				  struct ieee80211_rx_status *rxs,
+				  bool decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	int hdrlen, padsize;
+	u8 keyix;
+	__le16 fc;
+
+	/* see if any padding is done by the hw and remove it */
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+
+	/* The MAC header is padded to have 32-bit boundary if the
+	 * packet payload is non-zero. The general calculation for
+	 * padsize would take into account odd header lengths:
+	 * padsize = (4 - hdrlen % 4) % 4; However, since only
+	 * even-length headers are used, padding can only be 0 or 2
+	 * bytes and we can optimize this a bit. In addition, we must
+	 * not try to remove padding from short control frames that do
+	 * not have payload. */
+	padsize = hdrlen & 3;
+	if (padsize && hdrlen >= 24) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
+	keyix = rx_stats->rs_keyix;
+
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
+		rxs->flag |= RX_FLAG_DECRYPTED;
+	} else if (ieee80211_has_protected(fc)
+		   && !decrypt_error && skb->len >= hdrlen + 4) {
+		keyix = skb->data[hdrlen + 3] >> 6;
+
+		if (test_bit(keyix, common->keymap))
+			rxs->flag |= RX_FLAG_DECRYPTED;
+	}
+	if (ah->sw_mgmt_crypto &&
+	    (rxs->flag & RX_FLAG_DECRYPTED) &&
+	    ieee80211_is_mgmt(fc))
+		/* Use software decrypt for management frames. */
+		rxs->flag &= ~RX_FLAG_DECRYPTED;
+}
+EXPORT_SYMBOL(ath9k_cmn_rx_skb_postprocess);
+
+static int __init ath9k_cmn_init(void)
+{
+	return 0;
+}
+module_init(ath9k_cmn_init);
+
+static void __exit ath9k_cmn_exit(void)
+{
+	return;
+}
+module_exit(ath9k_cmn_exit);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
new file mode 100644
index 0000000..292e3d8
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+#include <net/mac80211.h>
+
+#include "../ath.h"
+#include "../debug.h"
+
+#include "hw.h"
+
+/* Common header for Atheros 802.11n base driver cores */
+
+#define WME_NUM_TID             16
+#define WME_BA_BMP_SIZE         64
+#define WME_MAX_BA              WME_BA_BMP_SIZE
+#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
+
+#define WME_AC_BE   0
+#define WME_AC_BK   1
+#define WME_AC_VI   2
+#define WME_AC_VO   3
+#define WME_NUM_AC  4
+
+#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RSSI_LPF_LEN 		10
+#define RSSI_LPF_THRESHOLD		-20
+#define ATH_RSSI_EP_MULTIPLIER     (1<<7)
+#define ATH_EP_MUL(x, mul)         ((x) * (mul))
+#define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
+#define ATH_LPF_RSSI(x, y, len) \
+    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
+#define ATH_RSSI_LPF(x, y) do {                     			\
+    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
+	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
+} while (0)
+#define ATH_EP_RND(x, mul) 						\
+	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
+
+struct ath_atx_ac {
+	int sched;
+	int qnum;
+	struct list_head list;
+	struct list_head tid_q;
+};
+
+struct ath_buf_state {
+	int bfs_nframes;
+	u16 bfs_al;
+	u16 bfs_frmlen;
+	int bfs_seqno;
+	int bfs_tidno;
+	int bfs_retries;
+	u8 bf_type;
+	u32 bfs_keyix;
+	enum ath9k_key_type bfs_keytype;
+};
+
+struct ath_buf {
+	struct list_head list;
+	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
+					   an aggregate) */
+	struct ath_buf *bf_next;	/* next subframe in the aggregate */
+	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
+	struct ath_desc *bf_desc;	/* virtual addr of desc */
+	dma_addr_t bf_daddr;		/* physical addr of desc */
+	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
+	bool bf_stale;
+	u16 bf_flags;
+	struct ath_buf_state bf_state;
+	dma_addr_t bf_dmacontext;
+};
+
+struct ath_atx_tid {
+	struct list_head list;
+	struct list_head buf_q;
+	struct ath_node *an;
+	struct ath_atx_ac *ac;
+	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
+	u16 seq_start;
+	u16 seq_next;
+	u16 baw_size;
+	int tidno;
+	int baw_head;   /* first un-acked tx buffer */
+	int baw_tail;   /* next unused tx buffer slot */
+	int sched;
+	int paused;
+	u8 state;
+};
+
+struct ath_node {
+	struct ath_common *common;
+	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_ac ac[WME_NUM_AC];
+	u16 maxampdu;
+	u8 mpdudensity;
+	int last_rssi;
+};
+
+int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
+				struct ieee80211_hw *hw,
+				struct sk_buff *skb,
+				struct ath_rx_status *rx_stats,
+				struct ieee80211_rx_status *rx_status,
+				bool *decrypt_error);
+
+void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
+				  struct sk_buff *skb,
+				  struct ath_rx_status *rx_stats,
+				  struct ieee80211_rx_status *rxs,
+				  bool decrypt_error);
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index fa21a62..94cb9f8 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -19,6 +19,8 @@
 #ifndef RC_H
 #define RC_H
 
+#include "hw.h"
+
 struct ath_softc;
 
 #define ATH_RATE_MAX     30
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8b7489d..477365e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -89,282 +89,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 	sc->rx.rxotherant = 0;
 }
 
-/* Assumes you've already done the endian to CPU conversion */
-static bool ath9k_rx_accept(struct ath_common *common,
-			    struct sk_buff *skb,
-			    struct ieee80211_rx_status *rxs,
-			    struct ath_rx_status *rx_stats,
-			    bool *decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = hdr->frame_control;
-
-	if (!rx_stats->rs_datalen)
-		return false;
-        /*
-         * rs_status follows rs_datalen so if rs_datalen is too large
-         * we can take a hint that hardware corrupted it, so ignore
-         * those frames.
-         */
-	if (rx_stats->rs_datalen > common->rx_bufsize)
-		return false;
-
-	if (rx_stats->rs_more) {
-		/*
-		 * Frame spans multiple descriptors; this cannot happen yet
-		 * as we don't support jumbograms. If not in monitor mode,
-		 * discard the frame. Enable this if you want to see
-		 * error frames in Monitor mode.
-		 */
-		if (ah->opmode != NL80211_IFTYPE_MONITOR)
-			return false;
-	} else if (rx_stats->rs_status != 0) {
-		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
-			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
-		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
-			return false;
-
-		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
-			*decrypt_error = true;
-		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
-			if (ieee80211_is_ctl(fc))
-				/*
-				 * Sometimes, we get invalid
-				 * MIC failures on valid control frames.
-				 * Remove these mic errors.
-				 */
-				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
-			else
-				rxs->flag |= RX_FLAG_MMIC_ERROR;
-		}
-		/*
-		 * Reject error frames with the exception of
-		 * decryption and MIC failures. For monitor mode,
-		 * we also ignore the CRC error.
-		 */
-		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-			      ATH9K_RXERR_CRC))
-				return false;
-		} else {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-				return false;
-			}
-		}
-	}
-	return true;
-}
-
-static u8 ath9k_process_rate(struct ath_common *common,
-			     struct ieee80211_hw *hw,
-			     struct ath_rx_status *rx_stats,
-			     struct ieee80211_rx_status *rxs,
-			     struct sk_buff *skb)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	band = hw->conf.channel->band;
-	sband = hw->wiphy->bands[band];
-
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		return rx_stats->rs_rate & 0x7f;
-	}
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
-			return i;
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return i;
-		}
-	}
-
-	/* No valid hardware bitrate found -- we should not get here */
-	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
-		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
-	if ((common->debug_mask & ATH_DBG_XMIT))
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
-
-        return 0;
-}
-
-/*
- * Theory for reporting quality:
- *
- * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
- * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
- * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
- *
- * MCS 7  is the highets MCS index usable by a 1-stream device.
- * MCS 15 is the highest MCS index usable by a 2-stream device.
- *
- * All ath9k devices are either 1-stream or 2-stream.
- *
- * How many bars you see is derived from the qual reporting.
- *
- * A more elaborate scheme can be used here but it requires tables
- * of SNR/throughput for each possible mode used. For the MCS table
- * you can refer to the wireless wiki:
- *
- * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
- *
- */
-static int ath9k_compute_qual(struct ieee80211_hw *hw,
-			      struct ath_rx_status *rx_stats)
-{
-	int qual;
-
-	if (conf_is_ht(&hw->conf))
-		qual =  rx_stats->rs_rssi * 100 / 45;
-	else
-		qual =  rx_stats->rs_rssi * 100 / 35;
-
-	/*
-	 * rssi can be more than 45 though, anything above that
-	 * should be considered at 100%
-	 */
-	if (qual > 100)
-		qual = 100;
-
-	return qual;
-}
-
-static void ath9k_process_rssi(struct ath_common *common,
-			       struct ieee80211_hw *hw,
-			       struct sk_buff *skb,
-			       struct ath_rx_status *rx_stats)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_sta *sta;
-	struct ieee80211_hdr *hdr;
-	struct ath_node *an;
-	int last_rssi = ATH_RSSI_DUMMY_MARKER;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	rcu_read_lock();
-	/* XXX: use ieee80211_find_sta! */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
-	if (sta) {
-		an = (struct ath_node *) sta->drv_priv;
-		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
-		   !rx_stats->rs_moreaggr)
-			ATH_RSSI_LPF(an->last_rssi, rx_stats->rs_rssi);
-		last_rssi = an->last_rssi;
-	}
-	rcu_read_unlock();
-
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
-					      ATH_RSSI_EP_MULTIPLIER);
-	if (rx_stats->rs_rssi < 0)
-		rx_stats->rs_rssi = 0;
-	else if (rx_stats->rs_rssi > 127)
-		rx_stats->rs_rssi = 127;
-
-	/* Update Beacon RSSI, this is used by ANI. */
-	if (ieee80211_is_beacon(fc))
-		ah->stats.avgbrssi = rx_stats->rs_rssi;
-}
-
-/*
- * For Decrypt or Demic errors, we only mark packet status here and always push
- * up the frame up to let mac80211 handle the actual error case, be it no
- * decryption key or real decryption error. This let us keep statistics there.
- */
-static int ath9k_rx_skb_preprocess(struct ath_common *common,
-				   struct ieee80211_hw *hw,
-				   struct sk_buff *skb,
-				   struct ath_rx_status *rx_stats,
-				   struct ieee80211_rx_status *rx_status,
-				   bool *decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-
-	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
-		return -EINVAL;
-
-	ath9k_process_rssi(common, hw, skb, rx_stats);
-
-	rx_status->rate_idx = ath9k_process_rate(common, hw,
-						 rx_stats, rx_status, skb);
-	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->noise = common->ani.noise_floor;
-	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
-	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->qual = ath9k_compute_qual(hw, rx_stats);
-	rx_status->flag |= RX_FLAG_TSFT;
-
-	return 0;
-}
-
-static void ath9k_rx_skb_postprocess(struct ath_common *common,
-				     struct sk_buff *skb,
-				     struct ath_rx_status *rx_stats,
-				     struct ieee80211_rx_status *rxs,
-				     bool decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	int hdrlen, padsize;
-	u8 keyix;
-	__le16 fc;
-
-	/* see if any padding is done by the hw and remove it */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-
-	/* The MAC header is padded to have 32-bit boundary if the
-	 * packet payload is non-zero. The general calculation for
-	 * padsize would take into account odd header lengths:
-	 * padsize = (4 - hdrlen % 4) % 4; However, since only
-	 * even-length headers are used, padding can only be 0 or 2
-	 * bytes and we can optimize this a bit. In addition, we must
-	 * not try to remove padding from short control frames that do
-	 * not have payload. */
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
-	keyix = rx_stats->rs_keyix;
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
-		rxs->flag |= RX_FLAG_DECRYPTED;
-	} else if (ieee80211_has_protected(fc)
-		   && !decrypt_error && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, common->keymap))
-			rxs->flag |= RX_FLAG_DECRYPTED;
-	}
-	if (ah->sw_mgmt_crypto &&
-	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-	    ieee80211_is_mgmt(fc))
-		/* Use software decrypt for management frames. */
-		rxs->flag &= ~RX_FLAG_DECRYPTED;
-}
-
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -854,8 +578,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, skb, rx_stats,
-						 rxs, &decrypt_error);
+		retval = ath9k_cmn_rx_skb_preprocess(common, hw, skb, rx_stats,
+						     rxs, &decrypt_error);
 		if (retval)
 			goto requeue;
 
@@ -877,8 +601,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		skb_put(skb, rx_stats->rs_datalen);
 
-		ath9k_rx_skb_postprocess(common, skb, rx_stats,
-					 rxs, decrypt_error);
+		ath9k_cmn_rx_skb_postprocess(common, skb, rx_stats,
+					     rxs, decrypt_error);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
-- 
1.6.5.2.143.g8cc62

