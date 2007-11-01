Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:11133 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXKAEhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 00:37:25 -0400
Received: by an-out-0708.google.com with SMTP id b36so57724ana
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 21:37:24 -0700 (PDT)
Date: Thu, 1 Nov 2007 00:37:19 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 3/7] ath5k: Clean up ath5k rate duration settings
Message-ID: <20071101043718.GD21987@pogo> (sfid-20071101_043732_957484_CC9910C7)
References: <20071101043520.GC21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101043520.GC21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ath5k's rate duration computations for one using
mac80211's internals. Another consideration here is to simply
remove these and put them into initval values. They seem to be
static values based only on mode. We can do this later though once
we can physically confirm by trial and error these are indeed just
used for ACK timeout. The next puzzle is figuring out which registers
are actually setting the control rates.

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   80 --------------
 drivers/net/wireless/ath5k/hw.c    |  201 ++++++++++++++----------------------
 2 files changed, 76 insertions(+), 205 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 20567b1..3354b37 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -374,86 +374,6 @@ enum ath5k_pkt_type {
 )
 
 /*
- * Used to compute TX times
- */
-#define AR5K_CCK_SIFS_TIME		10
-#define AR5K_CCK_PREAMBLE_BITS		144
-#define AR5K_CCK_PLCP_BITS		48
-
-#define AR5K_OFDM_SIFS_TIME		16
-#define AR5K_OFDM_PREAMBLE_TIME		20
-#define AR5K_OFDM_PLCP_BITS		22
-#define AR5K_OFDM_SYMBOL_TIME		4
-
-#define AR5K_TURBO_SIFS_TIME		8
-#define AR5K_TURBO_PREAMBLE_TIME	14
-#define AR5K_TURBO_PLCP_BITS		22
-#define AR5K_TURBO_SYMBOL_TIME		4
-
-#define AR5K_XR_SIFS_TIME		16
-#define AR5K_XR_PLCP_BITS		22
-#define AR5K_XR_SYMBOL_TIME		4
-
-/* CCK */
-#define AR5K_CCK_NUM_BITS(_frmlen) (_frmlen << 3)
-
-#define AR5K_CCK_PHY_TIME(_sp) (_sp ?					\
-	((AR5K_CCK_PREAMBLE_BITS + AR5K_CCK_PLCP_BITS) >> 1) :		\
-	(AR5K_CCK_PREAMBLE_BITS + AR5K_CCK_PLCP_BITS))
-
-#define AR5K_CCK_TX_TIME(_kbps, _frmlen, _sp)				\
-	(AR5K_CCK_PHY_TIME(_sp) +					\
-	((AR5K_CCK_NUM_BITS(_frmlen) * 1000) / _kbps) +			\
-	AR5K_CCK_SIFS_TIME)
-
-/* OFDM */
-#define AR5K_OFDM_NUM_BITS(_frmlen) (AR5K_OFDM_PLCP_BITS + (_frmlen << 3))
-
-#define AR5K_OFDM_NUM_BITS_PER_SYM(_kbps) ((_kbps *			\
-	AR5K_OFDM_SYMBOL_TIME) / 1000)
-
-#define AR5K_OFDM_NUM_BITS(_frmlen) (AR5K_OFDM_PLCP_BITS + (_frmlen << 3))
-
-#define AR5K_OFDM_NUM_SYMBOLS(_kbps, _frmlen)				\
-	DIV_ROUND_UP(AR5K_OFDM_NUM_BITS(_frmlen),			\
-			AR5K_OFDM_NUM_BITS_PER_SYM(_kbps))
-
-#define AR5K_OFDM_TX_TIME(_kbps, _frmlen)				\
-	(AR5K_OFDM_PREAMBLE_TIME + AR5K_OFDM_SIFS_TIME +		\
-	(AR5K_OFDM_NUM_SYMBOLS(_kbps, _frmlen) * AR5K_OFDM_SYMBOL_TIME))
-
-/* TURBO */
-#define AR5K_TURBO_NUM_BITS(_frmlen) (AR5K_TURBO_PLCP_BITS + (_frmlen << 3))
-
-#define AR5K_TURBO_NUM_BITS_PER_SYM(_kbps) (((_kbps << 1) *		\
-	AR5K_TURBO_SYMBOL_TIME) / 1000)
-
-#define AR5K_TURBO_NUM_BITS(_frmlen) (AR5K_TURBO_PLCP_BITS + (_frmlen << 3))
-
-#define AR5K_TURBO_NUM_SYMBOLS(_kbps, _frmlen)				\
-	DIV_ROUND_UP(AR5K_TURBO_NUM_BITS(_frmlen),			\
-			AR5K_TURBO_NUM_BITS_PER_SYM(_kbps))
-
-#define AR5K_TURBO_TX_TIME(_kbps, _frmlen)				\
-	(AR5K_TURBO_PREAMBLE_TIME + AR5K_TURBO_SIFS_TIME +		\
-	(AR5K_TURBO_NUM_SYMBOLS(_kbps, _frmlen) * AR5K_TURBO_SYMBOL_TIME))
-
-/* eXtendent Range (?)*/
-#define AR5K_XR_PREAMBLE_TIME(_kbps) (((_kbps) < 1000) ? 173 : 76)
-
-#define AR5K_XR_NUM_BITS_PER_SYM(_kbps) ((_kbps *			\
-	AR5K_XR_SYMBOL_TIME) / 1000)
-
-#define AR5K_XR_NUM_BITS(_frmlen) (AR5K_XR_PLCP_BITS + (_frmlen << 3))
-
-#define AR5K_XR_NUM_SYMBOLS(_kbps, _frmlen)				\
-	DIV_ROUND_UP(AR5K_XR_NUM_BITS(_frmlen), AR5K_XR_NUM_BITS_PER_SYM(_kbps))
-
-#define AR5K_XR_TX_TIME(_kbps, _frmlen)					\
-	(AR5K_XR_PREAMBLE_TIME(_kbps) + AR5K_XR_SIFS_TIME +		\
-	(AR5K_XR_NUM_SYMBOLS(_kbps, _frmlen) * AR5K_XR_SYMBOL_TIME))
-
-/*
  * DMA size definitions (2^n+2)
  */
 enum ath5k_dmasize {
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 320e32e..17c46e1 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -74,76 +74,6 @@ static int ath5k_hw_disable_pspoll(struct ath5k_hw *);
   General Functions
 \*******************/
 
-
-/*
- * Calculate transmition time of a frame
- * TODO: Left here for combatibility, change it in ath5k
- */
-static u16 /*TODO: Is this really hardware dependent ?*/
-ath5k_computetxtime(struct ath5k_hw *ah, const struct ath5k_rate_table *rates,
-		u32 frame_length, u16 rate_index, bool short_preamble)
-{
-	const struct ath5k_rate *rate;
-	u32 value;
-
-	AR5K_ASSERT_ENTRY(rate_index, rates->rate_count);
-
-	/*
-	 * Get rate by index
-	 */
-	rate = &rates->rates[rate_index];
-
-	/*
-	 * Calculate the transmission time by operation (PHY) mode
-	 */
-	switch (rate->modulation) {
-	/* Standard rates */
-	case IEEE80211_RATE_CCK:
-		/*
-		 * CCK / DS mode (802.11b)
-		 */
-		value = AR5K_CCK_TX_TIME(rate->rate_kbps, frame_length,
-			short_preamble &&
-			rate->modulation == IEEE80211_RATE_CCK_2);
-		break;
-
-	case IEEE80211_RATE_OFDM:
-		/*
-		 * Orthogonal Frequency Division Multiplexing
-		 */
-		if (AR5K_OFDM_NUM_BITS_PER_SYM(rate->rate_kbps) == 0)
-			return 0;
-		value = AR5K_OFDM_TX_TIME(rate->rate_kbps, frame_length);
-		break;
-
-	/* Vendor-specific rates */
-	case MODULATION_TURBO:
-		/*
-		 * Orthogonal Frequency Division Multiplexing
-		 * Atheros "Turbo Mode" (doubled rates)
-		 */
-		if (AR5K_TURBO_NUM_BITS_PER_SYM(rate->rate_kbps) == 0)
-			return 0;
-		value = AR5K_TURBO_TX_TIME(rate->rate_kbps, frame_length);
-		break;
-
-	case MODULATION_XR:
-		/*
-		 * Orthogonal Frequency Division Multiplexing
-		 * Atheros "eXtended Range" (XR)
-		 */
-		if (AR5K_XR_NUM_BITS_PER_SYM(rate->rate_kbps) == 0)
-			return 0;
-		value = AR5K_XR_TX_TIME(rate->rate_kbps, frame_length);
-		break;
-
-	default:
-		return 0;
-	}
-
-	return value;
-}
-
 /*
  * Functions used internaly
  */
@@ -523,9 +453,80 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
 	kfree(ah);
 }
 
-/*******************************\
-	Reset Functions
-\*******************************/
+/*
+ * Reset function and helpers
+ */
+
+/**
+ * ath5k_hw_write_rate_duration - set rate duration during hw resets
+ *
+ * @ah: the &struct ath5k_hw
+ * @driver_mode: one of enum ieee80211_phymode or our one of our own 
+ *     vendor modes
+ *
+ * Write the rate duration table for the current mode upon hw reset. This
+ * is a helper for ath5k_hw_reset(). It seems all this is doing is setting
+ * an ACK timeout for the hardware for the current mode for each rate. The
+ * rates which are capable of short preamble (802.11b rates 2Mbps, 5.5Mbps,
+ * and 11Mbps) have another register for the short preamble ACK timeout
+ * calculation.
+ *
+ */
+static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
+       unsigned int driver_mode)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	const struct ath5k_rate_table *rt;
+	unsigned int i;
+
+	/* Get rate table for the current operating mode */
+	rt = ath5k_hw_get_rate_table(ah,
+		driver_mode);
+
+	/* Write rate duration table */
+	for (i = 0; i < rt->rate_count; i++) {
+		const struct ath5k_rate *rate, *control_rate;
+		u32 reg;
+		u16 tx_time;
+
+		rate = &rt->rates[i];
+		control_rate = &rt->rates[rate->control_rate];
+
+		/* Set ACK timeout */
+		reg = AR5K_RATE_DUR(rate->rate_code);
+
+		/* An ACK frame consists of 10 bytes. If you add the FCS,
+		 * which ieee80211_generic_frame_duration() adds, 
+		 * its 14 bytes. Note we use the control rate and not the
+		 * actual rate for this rate. See mac80211 tx.c 
+		 * ieee80211_duration() for a brief description of 
+		 * what rate we should choose to TX ACKs. */
+		tx_time = ieee80211_generic_frame_duration(sc->hw,
+			sc->iface_id, 10, control_rate->rate_kbps/100);
+
+		ath5k_hw_reg_write(ah, tx_time, reg);
+
+		if (!HAS_SHPREAMBLE(i))
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
 
 /*
  * Main reset function
@@ -533,7 +534,6 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
 int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
-	const struct ath5k_rate_table *rt;
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 data, s_seq, s_ant, s_led[3];
 	s32 noise_floor;
@@ -660,57 +660,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 		mdelay(1);
 
-		/*
-		 * Set rate duration table on 5212
-		 */
-		if (ah->ah_version == AR5K_AR5212) {
-
-			/*For 802.11b*/
-			if (driver_mode == MODE_IEEE80211B) {
-
-				/*Get rate table for this operation mode*/
-				rt = ath5k_hw_get_rate_table(ah,
-						MODE_IEEE80211B);
-				if (!rt)
-					return -EINVAL;
-
-				/*Write rate duration table*/
-				for (i = 0; i < rt->rate_count; i++) {
-					data = AR5K_RATE_DUR(rt->rates[i].rate_code);
-					ath5k_hw_reg_write(ah,
-						ath5k_computetxtime(ah, rt,
-						14, rt->rates[i].control_rate,
-						false), data);
-					if (HAS_SHPREAMBLE(i))
-						ath5k_hw_reg_write(ah,
-						    ath5k_computetxtime(ah,
-						    rt, 14,
-						    rt->rates[i].control_rate,
-						    false), data +
-						    (AR5K_SET_SHORT_PREAMBLE << 2));
-				}
-
-			} else {
-			/* For 802.11a/g Turbo/XR mode (AR5K_MODE_XR here is
-			 * O.K. for both a/g - OFDM) */
-
-				/* Get rate table for this operation mode */
-				rt = ath5k_hw_get_rate_table(ah,
-				    channel->val & CHANNEL_TURBO ?
-				    MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
-				if (!rt)
-					return -EINVAL;
-
-				/* Write rate duration table */
-				for (i = 0; i < rt->rate_count; i++)
-					ath5k_hw_reg_write(ah,
-						ath5k_computetxtime(ah, rt,
-						14, rt->rates[i].control_rate,
-						false),
-						AR5K_RATE_DUR(rt->rates[i].rate_code));
-
-			}
-		}
+		if (ah->ah_version == AR5K_AR5212)
+			ath5k_hw_write_rate_duration(ah, driver_mode);
 
 		/* Fix for first revision of the RF5112 RF chipset */
 		if (ah->ah_radio >= AR5K_RF5112 &&
-- 
1.5.2.5

