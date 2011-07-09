Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14168 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1GIERx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:17:53 -0400
Subject: [PATCH 2/2] ath5k: fix typos,
 bad comment formatting and GHz in place of MHz
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 09 Jul 2011 00:17:51 -0400
Message-ID: <20110709041751.22099.67506.stgit@mj.roinet.com> (sfid-20110709_061756_668220_7EC25B23)
In-Reply-To: <20110709041745.22099.12306.stgit@mj.roinet.com>
References: <20110709041745.22099.12306.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ani.c          |    2 +
 drivers/net/wireless/ath/ath5k/ath5k.h        |   26 ++++++++-------
 drivers/net/wireless/ath/ath5k/attach.c       |    4 +-
 drivers/net/wireless/ath/ath5k/base.c         |   14 ++++----
 drivers/net/wireless/ath/ath5k/base.h         |    4 +-
 drivers/net/wireless/ath/ath5k/caps.c         |    4 +-
 drivers/net/wireless/ath/ath5k/desc.h         |    4 +-
 drivers/net/wireless/ath/ath5k/dma.c          |    6 ++--
 drivers/net/wireless/ath/ath5k/eeprom.c       |    8 ++---
 drivers/net/wireless/ath/ath5k/eeprom.h       |   10 +++---
 drivers/net/wireless/ath/ath5k/initvals.c     |    2 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    4 +-
 drivers/net/wireless/ath/ath5k/pci.c          |   12 ++++---
 drivers/net/wireless/ath/ath5k/pcu.c          |   12 ++++---
 drivers/net/wireless/ath/ath5k/phy.c          |   18 +++++------
 drivers/net/wireless/ath/ath5k/reg.h          |   42 +++++++++++++------------
 drivers/net/wireless/ath/ath5k/reset.c        |   10 +++---
 drivers/net/wireless/ath/ath5k/rfgain.h       |    6 ++--
 18 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index b88d10c..2f0b967 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -74,7 +74,7 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	static const s8 fr[] = { -78, -80 };
 #endif
 	if (level < 0 || level >= ARRAY_SIZE(sz)) {
-		ATH5K_ERR(ah->ah_sc, "noise immuniy level %d out of range",
+		ATH5K_ERR(ah->ah_sc, "noise immunity level %d out of range",
 			  level);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index b1de4a0..50d7580 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -18,9 +18,9 @@
 #ifndef _ATH5K_H
 #define _ATH5K_H
 
-/* TODO: Clean up channel debuging -doesn't work anyway- and start
+/* TODO: Clean up channel debugging (doesn't work anyway) and start
  * working on reg. control code using all available eeprom information
- * -rev. engineering needed- */
+ * (rev. engineering needed) */
 #define CHAN_DEBUG	0
 
 #include <linux/io.h>
@@ -156,7 +156,7 @@
 } while (0)
 
 /*
- * Some tuneable values (these should be changeable by the user)
+ * Some tunable values (these should be changeable by the user)
  * TODO: Make use of them and add more options OR use debug/configfs
  */
 #define AR5K_TUNE_DMA_BEACON_RESP		2
@@ -171,8 +171,8 @@
 #define AR5K_TUNE_RSSI_THRES			129
 /* This must be set when setting the RSSI threshold otherwise it can
  * prevent a reset. If AR5K_RSSI_THR is read after writing to it
- * the BMISS_THRES will be seen as 0, seems harware doesn't keep
- * track of it. Max value depends on harware. For AR5210 this is just 7.
+ * the BMISS_THRES will be seen as 0, seems hardware doesn't keep
+ * track of it. Max value depends on hardware. For AR5210 this is just 7.
  * For AR5211+ this seems to be up to 255. */
 #define AR5K_TUNE_BMISS_THRES			7
 #define AR5K_TUNE_REGISTER_DWELL_TIME		20000
@@ -380,7 +380,7 @@ struct ath5k_srev_name {
  * Modulation for Atheros' Turbo G and Turbo A, its supposed to provide a
  * throughput transmission speed up to 40Mbit/s-60Mbit/s at a 108Mbit/s
  * signaling rate achieved through the bonding of two 54Mbit/s 802.11g
- * channels. To use this feature your Access Point must also suport it.
+ * channels. To use this feature your Access Point must also support it.
  * There is also a distinction between "static" and "dynamic" turbo modes:
  *
  * - Static: is the dumb version: devices set to this mode stick to it until
@@ -496,7 +496,7 @@ enum ath5k_tx_queue {
  */
 enum ath5k_tx_queue_subtype {
 	AR5K_WME_AC_BK = 0,	/*Background traffic*/
-	AR5K_WME_AC_BE,		/*Best-effort (normal) traffic)*/
+	AR5K_WME_AC_BE,		/*Best-effort (normal) traffic*/
 	AR5K_WME_AC_VI,		/*Video traffic*/
 	AR5K_WME_AC_VO,		/*Voice traffic*/
 };
@@ -690,7 +690,7 @@ struct ath5k_gain {
 #define CHANNEL_MODES		CHANNEL_ALL
 
 /*
- * Used internaly for reset_tx_queue).
+ * Used internally for ath5k_hw_reset_tx_queue().
  * Also see struct struct ieee80211_channel.
  */
 #define IS_CHAN_XR(_c)	((_c->hw_value & CHANNEL_XR) != 0)
@@ -712,7 +712,7 @@ struct ath5k_athchan_2ghz {
 \******************/
 
 /**
- * Seems the ar5xxx harware supports up to 32 rates, indexed by 1-32.
+ * Seems the ar5xxx hardware supports up to 32 rates, indexed by 1-32.
  *
  * The rate code is used to get the RX rate or set the TX rate on the
  * hardware descriptors. It is also used for internal modulation control
@@ -802,7 +802,7 @@ extern int ath5k_modparam_nohwcrypt;
  *	http://www.freepatentsonline.com/20030225739.html
  * @AR5K_INT_RXORN: Indicates we got RX overrun (eg. no more descriptors).
  *	Note that Rx overrun is not always fatal, on some chips we can continue
- *	operation without reseting the card, that's why int_fatal is not
+ *	operation without resetting the card, that's why int_fatal is not
  *	common for all chips.
  * @AR5K_INT_TX: mask to identify received frame interrupts, of type
  *	AR5K_ISR_TXOK or AR5K_ISR_TXERR
@@ -832,13 +832,13 @@ extern int ath5k_modparam_nohwcrypt;
  *	AR5K_SIMR2_MCABT, AR5K_SIMR2_SSERR and AR5K_SIMR2_DPERR.
  * @AR5K_INT_GLOBAL: Used to clear and set the IER
  * @AR5K_INT_NOCARD: signals the card has been removed
- * @AR5K_INT_COMMON: common interrupts shared amogst MACs with the same
+ * @AR5K_INT_COMMON: common interrupts shared among MACs with the same
  *	bit value
  *
  * These are mapped to take advantage of some common bits
  * between the MACs, to be able to set intr properties
  * easier. Some of them are not used yet inside hw.c. Most map
- * to the respective hw interrupt value as they are common amogst different
+ * to the respective hw interrupt value as they are common among different
  * MACs.
  */
 enum ath5k_int {
@@ -1358,7 +1358,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 				u8 mode, bool fast);
 
 /*
- * Functions used internaly
+ * Functions used internally
  */
 
 static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index d6fbb57..14dc52e 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -244,7 +244,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	}
 
 
-	/* Return on unsuported chips (unsupported eeprom etc) */
+	/* Return on unsupported chips (unsupported eeprom etc) */
 	if ((srev >= AR5K_SREV_AR5416) && (srev < AR5K_SREV_AR2425)) {
 		ATH5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
@@ -285,7 +285,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 		ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
 		ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
 
-		/* If serdes programing is enabled, increase PCI-E
+		/* If serdes programming is enabled, increase PCI-E
 		 * tx power for systems with long trace from host
 		 * to minicard connector. */
 		if (ee->ee_serdes)
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 28113e0..3e5e9b7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -531,7 +531,7 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 	if (iter_data.n_stas > 1) {
 		/* If you have multiple STA interfaces connected to
 		 * different APs, ARPs are not received (most of the time?)
-		 * Enabling PROMISC appears to fix that probem.
+		 * Enabling PROMISC appears to fix that problem.
 		 */
 		sc->filter_flags |= AR5K_RX_FILTER_PROM;
 	}
@@ -1349,7 +1349,7 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	 * timestamp (beginning of phy frame, data frame, end of rx?).
 	 * The only thing we know is that it is hardware specific...
 	 * On AR5213 it seems the rx timestamp is at the end of the
-	 * frame, but i'm not sure.
+	 * frame, but I'm not sure.
 	 *
 	 * NOTE: mac80211 defines mactime at the beginning of the first
 	 * data symbol. Since we don't have any time references it's
@@ -1764,7 +1764,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * 4 beacons to make sure everybody hears our AP.
 	 * When a client tries to associate, hw will keep
 	 * track of the tx antenna to be used for this client
-	 * automaticaly, based on ACKed packets.
+	 * automatically, based on ACKed packets.
 	 *
 	 * Note: AP still listens and transmits RTS on the
 	 * default antenna which is supposed to be an omni.
@@ -2099,11 +2099,11 @@ static void ath5k_tasklet_beacon(unsigned long data)
 	 *
 	 * In IBSS mode we use this interrupt just to
 	 * keep track of the next TBTT (target beacon
-	 * transmission time) in order to detect wether
+	 * transmission time) in order to detect whether
 	 * automatic TSF updates happened.
 	 */
 	if (sc->opmode == NL80211_IFTYPE_ADHOC) {
-		/* XXX: only if VEOL suppported */
+		/* XXX: only if VEOL supported */
 		u64 tsf = ath5k_hw_get_tsf64(sc->ah);
 		sc->nexttbtt += sc->bintval;
 		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
@@ -2466,7 +2466,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 						sc->ah->ah_radio_5ghz_revision),
 						sc->ah->ah_radio_5ghz_revision);
 			/* No 2GHz support (5110 and some
-			 * 5Ghz only cards) -> report 5Ghz radio */
+			 * 5GHz only cards) -> report 5GHz radio */
 			} else if (!test_bit(AR5K_MODE_11B,
 				sc->ah->ah_capabilities.cap_mode)) {
 				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
@@ -2796,7 +2796,7 @@ ath5k_init(struct ieee80211_hw *hw)
 
 	/*
 	 * Collect the channel list.  The 802.11 layer
-	 * is resposible for filtering this list based
+	 * is responsible for filtering this list based
 	 * on settings like the phy mode and regulatory
 	 * domain restrictions.
 	 */
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index e71494ee..0a98777 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -121,7 +121,7 @@ struct ath5k_statistics {
 	/* frame errors */
 	unsigned int rx_all_count;	/* all RX frames, including errors */
 	unsigned int tx_all_count;	/* all TX frames, including errors */
-	unsigned int rx_bytes_count;	/* all RX bytes, including errored pks
+	unsigned int rx_bytes_count;	/* all RX bytes, including errored pkts
 					 * and the MAC headers for each packet
 					 */
 	unsigned int tx_bytes_count;	/* all TX bytes, including errored pkts
@@ -250,7 +250,7 @@ struct ath5k_softc {
 	unsigned int		nexttbtt;	/* next beacon time in TU */
 	struct ath5k_txq	*cabq;		/* content after beacon */
 
-	int			power_level;	/* Requested tx power in dbm */
+	int			power_level;	/* Requested tx power in dBm */
 	bool			assoc;		/* associate state */
 	bool			enable_beacon;	/* true if beacons are on */
 
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 7dd88e1..c752982 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -52,8 +52,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		__set_bit(AR5K_MODE_11A, caps->cap_mode);
 	} else {
 		/*
-		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
-		 * XXX and from 2312 to 2732GHz. There are problems with the
+		 * XXX The transceiver supports frequencies from 4920 to 6100MHz
+		 * XXX and from 2312 to 2732MHz. There are problems with the
 		 * XXX current ieee80211 implementation because the IEEE
 		 * XXX channel mapping does not support negative channel
 		 * XXX numbers (2312MHz is channel -19). Of course, this
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 2509d0b..cfd529b5 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -58,11 +58,11 @@ struct ath5k_hw_rx_status {
 #define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002 /* reception success */
 #define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004 /* CRC error */
 #define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN_5210	0x00000008 /* [5210] FIFO overrun */
-#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010 /* decyption CRC failure */
+#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010 /* decryption CRC failure */
 #define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0 /* PHY error */
 #define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR_S		5
 #define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100 /* key index valid */
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00 /* decyption key index */
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00 /* decryption key index */
 #define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_S		9
 #define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000 /* 13 bit of TSF */
 #define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 02e2e3f..b788ecf 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -25,7 +25,7 @@
  *
  * Here we setup descriptor pointers (rxdp/txdp) start/stop dma engine and
  * handle queue setup for 5210 chipset (rest are handled on qcu.c).
- * Also we setup interrupt mask register (IMR) and read the various iterrupt
+ * Also we setup interrupt mask register (IMR) and read the various interrupt
  * status registers (ISR).
  *
  * TODO: Handle SISR on 5211+ and introduce a function to return the queue
@@ -726,7 +726,7 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 			int_mask |= AR5K_IMR_RXDOPPLER;
 
 		/* Note: Per queue interrupt masks
-		 * are set via reset_tx_queue (qcu.c) */
+		 * are set via ath5k_hw_reset_tx_queue() (qcu.c) */
 		ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
 		ath5k_hw_reg_write(ah, simr2, AR5K_SIMR2);
 
@@ -783,7 +783,7 @@ void ath5k_hw_dma_init(struct ath5k_hw *ah)
 	 * for all PCI-E cards to be safe).
 	 *
 	 * XXX: need to check 5210 for this
-	 * TODO: Check out tx triger level, it's always 64 on dumps but I
+	 * TODO: Check out tx trigger level, it's always 64 on dumps but I
 	 * guess we can tweak it and see how it goes ;-)
 	 */
 	if (ah->ah_version != AR5K_AR5210) {
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index f97a540..d9e605e 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -634,7 +634,7 @@ ath5k_eeprom_init_11bg_2413(struct ath5k_hw *ah, unsigned int mode, int offset)
 /* Used to match PCDAC steps with power values on RF5111 chips
  * (eeprom versions < 4). For RF5111 we have 11 pre-defined PCDAC
  * steps that match with the power values we read from eeprom. On
- * older eeprom versions (< 3.2) these steps are equaly spaced at
+ * older eeprom versions (< 3.2) these steps are equally spaced at
  * 10% of the pcdac curve -until the curve reaches its maximum-
  * (11 steps from 0 to 100%) but on newer eeprom versions (>= 3.2)
  * these 11 steps are spaced in a different way. This function returns
@@ -764,7 +764,7 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 
 		/* Fill raw dataset
 		 * (convert power to 0.25dB units
-		 * for RF5112 combatibility) */
+		 * for RF5112 compatibility) */
 		for (point = 0; point < pd->pd_points; point++) {
 
 			/* Absolute values */
@@ -884,7 +884,7 @@ ath5k_eeprom_read_pcal_info_5111(struct ath5k_hw *ah, int mode)
  * Read power calibration for RF5112 chips
  *
  * For RF5112 we have 4 XPD -eXternal Power Detector- curves
- * for each calibrated channel on 0, -6, -12 and -18dbm but we only
+ * for each calibrated channel on 0, -6, -12 and -18dBm but we only
  * use the higher (3) and the lower (0) curves. Each curve has 0.5dB
  * power steps on x axis and PCDAC steps on y axis and looks like a
  * linear function. To recreate the curve and pass the power values
@@ -1241,7 +1241,7 @@ ath5k_eeprom_convert_pcal_info_2413(struct ath5k_hw *ah, int mode,
 
 			/* Fill raw dataset
 			 * convert all pwr levels to
-			 * quarter dB for RF5112 combatibility */
+			 * quarter dB for RF5112 compatibility */
 			pd->pd_step[0] = pcinfo->pddac_i[pdg];
 			pd->pd_pwr[0] = 4 * pcinfo->pwr_i[pdg];
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 6d440e0..dc2bcfe 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -50,7 +50,7 @@
 
 #define AR5K_EEPROM_VERSION		AR5K_EEPROM_INFO(1)	/* EEPROM Version */
 #define AR5K_EEPROM_VERSION_3_0		0x3000	/* No idea what's going on before this version */
-#define AR5K_EEPROM_VERSION_3_1		0x3001	/* ob/db values for 2Ghz (ar5211_rfregs) */
+#define AR5K_EEPROM_VERSION_3_1		0x3001	/* ob/db values for 2GHz (ar5211_rfregs) */
 #define AR5K_EEPROM_VERSION_3_2		0x3002	/* different frequency representation (eeprom_bin2freq) */
 #define AR5K_EEPROM_VERSION_3_3		0x3003	/* offsets changed, has 32 CTLs (see below) and ee_false_detect (eeprom_read_modes) */
 #define AR5K_EEPROM_VERSION_3_4		0x3004	/* has ee_i_gain, ee_cck_ofdm_power_delta (eeprom_read_modes) */
@@ -75,11 +75,11 @@
 #define AR5K_EEPROM_HDR_11A(_v)		(((_v) >> AR5K_EEPROM_MODE_11A) & 0x1)
 #define AR5K_EEPROM_HDR_11B(_v)		(((_v) >> AR5K_EEPROM_MODE_11B) & 0x1)
 #define AR5K_EEPROM_HDR_11G(_v)		(((_v) >> AR5K_EEPROM_MODE_11G) & 0x1)
-#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz */
+#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2GHz */
 #define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for < 2W power consumption */
 #define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)	/* Device type (1 Cardbus, 2 PCI, 3 MiniPCI, 4 AP) */
 #define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
-#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz */
+#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5GHz */
 
 /* Newer EEPROMs are using a different offset */
 #define AR5K_EEPROM_OFF(_v, _v3_0, _v3_3) \
@@ -120,7 +120,7 @@
 #define AR5K_EEPROM_FF_DIS(_v)		(((_v) >> 2) & 0x1)	/* disable fast frames */
 #define AR5K_EEPROM_BURST_DIS(_v)	(((_v) >> 3) & 0x1)	/* disable bursting */
 #define AR5K_EEPROM_MAX_QCU(_v)		(((_v) >> 4) & 0xf)	/* max number of QCUs. defaults to 10 */
-#define AR5K_EEPROM_HEAVY_CLIP_EN(_v)	(((_v) >> 8) & 0x1)	/* enable heayy clipping */
+#define AR5K_EEPROM_HEAVY_CLIP_EN(_v)	(((_v) >> 8) & 0x1)	/* enable heavy clipping */
 #define AR5K_EEPROM_KEY_CACHE_SIZE(_v)	(((_v) >> 12) & 0xf)	/* key cache size. defaults to 128 */
 
 #define AR5K_EEPROM_MISC6		AR5K_EEPROM_INFO(10)
@@ -270,7 +270,7 @@ enum ath5k_ctl_mode {
 
 /* Per channel calibration data, used for power table setup */
 struct ath5k_chan_pcal_info_rf5111 {
-	/* Power levels in half dbm units
+	/* Power levels in half dBm units
 	 * for one power curve. */
 	u8 pwr[AR5K_EEPROM_N_PWR_POINTS_5111];
 	/* PCDAC table steps
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 4bfdc2e..855d1af 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -1409,7 +1409,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool skip_pcu)
 	 * Write initial register settings
 	 */
 
-	/* For AR5212 and combatible */
+	/* For AR5212 and compatible */
 	if (ah->ah_version == AR5K_AR5212) {
 
 		/* First set of mode-specific settings */
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 4939082..0d5ab34 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -348,7 +348,7 @@ ath5k_prepare_multicast(struct ieee80211_hw *hw,
 		mfilt[pos / 32] |= (1 << (pos % 32));
 		/* XXX: we might be able to just do this instead,
 		* but not sure, needs testing, if we do use this we'd
-		* neet to inform below to not reset the mcast */
+		* need to inform below not to reset the mcast */
 		/* ath5k_hw_set_mcast_filterindex(ah,
 		 *      ha->addr[5]); */
 	}
@@ -471,7 +471,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	if (iter_data.n_stas > 1) {
 		/* If you have multiple STA interfaces connected to
 		 * different APs, ARPs are not received (most of the time?)
-		 * Enabling PROMISC appears to fix that probem.
+		 * Enabling PROMISC appears to fix that problem.
 		 */
 		rfilt |= AR5K_RX_FILTER_PROM;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index cd60f0a..aac5b78 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -34,12 +34,12 @@ static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
 	{ PCI_VDEVICE(3COM_2,  0x0013) }, /* 3com 5212 */
 	{ PCI_VDEVICE(3COM,    0x0013) }, /* 3com 3CRDAG675 5212 */
 	{ PCI_VDEVICE(ATHEROS, 0x1014) }, /* IBM minipci 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x0014) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0015) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0016) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0017) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0018) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0014) }, /* 5212 compatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0015) }, /* 5212 compatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0016) }, /* 5212 compatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0017) }, /* 5212 compatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0018) }, /* 5212 compatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 compatible */
 	{ PCI_VDEVICE(ATHEROS, 0x001a) }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index aecd724..618ee54 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -32,7 +32,7 @@
 #include "base.h"
 
 /*
- * AR5212+ can use higher rates for ack transmition
+ * AR5212+ can use higher rates for ack transmission
  * based on current tx rate instead of the base rate.
  * It does this to better utilize channel usage.
  * This is a mapping between G rates (that cover both
@@ -643,14 +643,14 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/* Flush any pending BMISS interrupts on ISR by
 	 * performing a clear-on-write operation on PISR
 	 * register for the BMISS bit (writing a bit on
-	 * ISR togles a reset for that bit and leaves
-	 * the rest bits intact) */
+	 * ISR toggles a reset for that bit and leaves
+	 * the remaining bits intact) */
 	if (ah->ah_version == AR5K_AR5210)
 		ath5k_hw_reg_write(ah, AR5K_ISR_BMISS, AR5K_ISR);
 	else
 		ath5k_hw_reg_write(ah, AR5K_ISR_BMISS, AR5K_PISR);
 
-	/* TODO: Set enchanced sleep registers on AR5212
+	/* TODO: Set enhanced sleep registers on AR5212
 	 * based on vif->bss_conf params, until then
 	 * disable power save reporting.*/
 	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, AR5K_STA_ID1_PWR_SV);
@@ -738,7 +738,7 @@ ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
 	dma = ath5k_hw_reg_read(ah, AR5K_TIMER1) >> 3;
 
 	/* NOTE: SWBA is different. Having a wrong window there does not
-	 * stop us from sending data and this condition is catched thru
+	 * stop us from sending data and this condition is caught by
 	 * other means (SWBA interrupt) */
 
 	if (ath5k_check_timer_win(nbtt, atim, 1, intval) &&
@@ -896,7 +896,7 @@ void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/* Set RSSI/BRSSI thresholds
 	 *
 	 * Note: If we decide to set this value
-	 * dynamicaly, have in mind that when AR5K_RSSI_THR
+	 * dynamically, have in mind that when AR5K_RSSI_THR
 	 * register is read it might return 0x40 if we haven't
 	 * wrote anything to it plus BMISS RSSI threshold is zeroed.
 	 * So doing a save/restore procedure here isn't the right
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 7e28676..e00ab5a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -363,7 +363,7 @@ int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah)
 	return 0;
 }
 
-/* Schedule a gain probe check on the next transmited packet.
+/* Schedule a gain probe check on the next transmitted packet.
  * That means our next packet is going to be sent with lower
  * tx power and a Peak to Average Power Detector (PAPD) will try
  * to measure the gain.
@@ -620,7 +620,7 @@ enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah)
 
 		/* Check if measurement is ok and if we need
 		 * to adjust gain, schedule a gain adjustment,
-		 * else switch back to the acive state */
+		 * else switch back to the active state */
 		if (ath5k_hw_rf_check_gainf_readback(ah) &&
 		AR5K_GAIN_CHECK_ADJUST(&ah->ah_gain) &&
 		ath5k_hw_rf_gainf_adjust(ah)) {
@@ -807,7 +807,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 		 * use b_OB and b_DB parameters stored
 		 * in eeprom on ee->ee_ob[ee_mode][0]
 		 *
-		 * For all other chips we use OB/DB for 2Ghz
+		 * For all other chips we use OB/DB for 2GHz
 		 * stored in the b/g modal section just like
 		 * 802.11a on ee->ee_ob[ee_mode][1] */
 		if ((ah->ah_radio == AR5K_RF5111) ||
@@ -1259,7 +1259,7 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 {
 	int ret;
 	/*
-	 * Check bounds supported by the PHY (we don't care about regultory
+	 * Check bounds supported by the PHY (we don't care about regulatory
 	 * restrictions at this point). Note: hw_value already has the band
 	 * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
 	 * of the band by that */
@@ -1815,7 +1815,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 
 	} else if (ath5k_hw_reg_read(ah, AR5K_PHY_IQ) &
 	AR5K_PHY_IQ_SPUR_FILT_EN) {
-		/* Clean up spur mitigation settings and disable fliter */
+		/* Clean up spur mitigation settings and disable filter */
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_BIN_MASK_CTL,
 					AR5K_PHY_BIN_MASK_CTL_RATE, 0);
 		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_IQ,
@@ -2510,8 +2510,8 @@ ath5k_combine_linear_pcdac_curves(struct ath5k_hw *ah, s16* table_min,
 	s16	max_pwr_idx;
 	s16	min_pwr_idx;
 	s16	mid_pwr_idx = 0;
-	/* Edge flag turs on the 7nth bit on the PCDAC
-	 * to delcare the higher power curve (force values
+	/* Edge flag turns on the 7nth bit on the PCDAC
+	 * to declare the higher power curve (force values
 	 * to be greater than 64). If we only have one curve
 	 * we don't need to set this, if we have 2 curves and
 	 * fill the table backwards this can also be used to
@@ -2568,7 +2568,7 @@ ath5k_combine_linear_pcdac_curves(struct ath5k_hw *ah, s16* table_min,
 		}
 
 		/* Don't go below 1, extrapolate below if we have
-		 * already swithced to the lower power curve -or
+		 * already switched to the lower power curve -or
 		 * we only have one curve and edge_flag is zero
 		 * anyway */
 		if (pcdac_tmp[pwr] < 1 && (edge_flag == 0x00)) {
@@ -2805,7 +2805,7 @@ ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
 /*
  * This is the main function that uses all of the above
  * to set PCDAC/PDADC table on hw for the current channel.
- * This table is used for tx power calibration on the basband,
+ * This table is used for tx power calibration on the baseband,
  * without it we get weird tx power levels and in some cases
  * distorted spectral mask
  */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 994d29a..f5c1000 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -170,7 +170,7 @@
 #define AR5K_TXCFG_SDMAMR_S		0
 #define AR5K_TXCFG_B_MODE		0x00000008	/* Set b mode for 5111 (enable 2111) */
 #define AR5K_TXCFG_TXFSTP		0x00000008	/* TX DMA full Stop [5210] */
-#define AR5K_TXCFG_TXFULL		0x000003f0	/* TX Triger level mask */
+#define AR5K_TXCFG_TXFULL		0x000003f0	/* TX Trigger level mask */
 #define AR5K_TXCFG_TXFULL_S		4
 #define AR5K_TXCFG_TXFULL_0B		0x00000000
 #define AR5K_TXCFG_TXFULL_64B		0x00000010
@@ -283,16 +283,16 @@
  */
 #define AR5K_ISR		0x001c			/* Register Address [5210] */
 #define AR5K_PISR		0x0080			/* Register Address [5211+] */
-#define AR5K_ISR_RXOK		0x00000001	/* Frame successfuly received */
+#define AR5K_ISR_RXOK		0x00000001	/* Frame successfully received */
 #define AR5K_ISR_RXDESC		0x00000002	/* RX descriptor request */
 #define AR5K_ISR_RXERR		0x00000004	/* Receive error */
 #define AR5K_ISR_RXNOFRM	0x00000008	/* No frame received (receive timeout) */
 #define AR5K_ISR_RXEOL		0x00000010	/* Empty RX descriptor */
 #define AR5K_ISR_RXORN		0x00000020	/* Receive FIFO overrun */
-#define AR5K_ISR_TXOK		0x00000040	/* Frame successfuly transmited */
+#define AR5K_ISR_TXOK		0x00000040	/* Frame successfully transmitted */
 #define AR5K_ISR_TXDESC		0x00000080	/* TX descriptor request */
 #define AR5K_ISR_TXERR		0x00000100	/* Transmit error */
-#define AR5K_ISR_TXNOFRM	0x00000200	/* No frame transmited (transmit timeout) */
+#define AR5K_ISR_TXNOFRM	0x00000200	/* No frame transmitted (transmit timeout) */
 #define AR5K_ISR_TXEOL		0x00000400	/* Empty TX descriptor */
 #define AR5K_ISR_TXURN		0x00000800	/* Transmit FIFO underrun */
 #define AR5K_ISR_MIB		0x00001000	/* Update MIB counters */
@@ -377,16 +377,16 @@
  */
 #define	AR5K_IMR		0x0020			/* Register Address [5210] */
 #define AR5K_PIMR		0x00a0			/* Register Address [5211+] */
-#define AR5K_IMR_RXOK		0x00000001	/* Frame successfuly received*/
+#define AR5K_IMR_RXOK		0x00000001	/* Frame successfully received*/
 #define AR5K_IMR_RXDESC		0x00000002	/* RX descriptor request*/
 #define AR5K_IMR_RXERR		0x00000004	/* Receive error*/
 #define AR5K_IMR_RXNOFRM	0x00000008	/* No frame received (receive timeout)*/
 #define AR5K_IMR_RXEOL		0x00000010	/* Empty RX descriptor*/
 #define AR5K_IMR_RXORN		0x00000020	/* Receive FIFO overrun*/
-#define AR5K_IMR_TXOK		0x00000040	/* Frame successfuly transmited*/
+#define AR5K_IMR_TXOK		0x00000040	/* Frame successfully transmitted*/
 #define AR5K_IMR_TXDESC		0x00000080	/* TX descriptor request*/
 #define AR5K_IMR_TXERR		0x00000100	/* Transmit error*/
-#define AR5K_IMR_TXNOFRM	0x00000200	/* No frame transmited (transmit timeout)*/
+#define AR5K_IMR_TXNOFRM	0x00000200	/* No frame transmitted (transmit timeout)*/
 #define AR5K_IMR_TXEOL		0x00000400	/* Empty TX descriptor*/
 #define AR5K_IMR_TXURN		0x00000800	/* Transmit FIFO underrun*/
 #define AR5K_IMR_MIB		0x00001000	/* Update MIB counters*/
@@ -601,7 +601,7 @@
  * QCU misc registers
  */
 #define AR5K_QCU_MISC_BASE		0x09c0			/* Register Address -Queue0 MISC */
-#define	AR5K_QCU_MISC_FRSHED_M		0x0000000f	/* Frame sheduling mask */
+#define	AR5K_QCU_MISC_FRSHED_M		0x0000000f	/* Frame scheduling mask */
 #define	AR5K_QCU_MISC_FRSHED_ASAP		0	/* ASAP */
 #define	AR5K_QCU_MISC_FRSHED_CBR		1	/* Constant Bit Rate */
 #define	AR5K_QCU_MISC_FRSHED_DBA_GT		2	/* DMA Beacon alert gated */
@@ -653,13 +653,13 @@
  * registers [5211+]
  *
  * These registers control the various characteristics of each queue
- * for 802.11e (WME) combatibility so they go together with
+ * for 802.11e (WME) compatibility so they go together with
  * QCU registers in pairs. For each queue we have a QCU mask register,
  * (0x1000 - 0x102c), a local-IFS settings register (0x1040 - 0x106c),
  * a retry limit register (0x1080 - 0x10ac), a channel time register
  * (0x10c0 - 0x10ec), a misc-settings register (0x1100 - 0x112c) and
  * a sequence number register (0x1140 - 0x116c). It seems that "global"
- * registers here afect all queues (see use of DCU_GBL_IFS_SLOT in ar5k).
+ * registers here affect all queues (see use of DCU_GBL_IFS_SLOT in ar5k).
  * We use the same macros here for easier register access.
  *
  */
@@ -779,7 +779,7 @@
  * and it's used for generating pseudo-random
  * number sequences.
  *
- * (If i understand corectly, random numbers are
+ * (If i understand correctly, random numbers are
  * used for idle sensing -multiplied with cwmin/max etc-)
  */
 #define AR5K_DCU_GBL_IFS_MISC			0x10f0			/* Register Address */
@@ -1007,7 +1007,7 @@
 #define	AR5K_PCIE_WAEN	0x407c
 
 /*
- * PCI-E Serializer/Desirializer
+ * PCI-E Serializer/Deserializer
  * registers
  */
 #define	AR5K_PCIE_SERDES	0x4080
@@ -1227,7 +1227,7 @@
 					AR5K_USEC_5210 : AR5K_USEC_5211)
 #define AR5K_USEC_1			0x0000007f	/* clock cycles for 1us */
 #define AR5K_USEC_1_S			0
-#define AR5K_USEC_32			0x00003f80	/* clock cycles for 1us while on 32Mhz clock */
+#define AR5K_USEC_32			0x00003f80	/* clock cycles for 1us while on 32MHz clock */
 #define AR5K_USEC_32_S			7
 #define AR5K_USEC_TX_LATENCY_5211	0x007fc000
 #define AR5K_USEC_TX_LATENCY_5211_S	14
@@ -1632,7 +1632,7 @@
 #define AR5K_SLEEP0_NEXT_DTIM		0x0007ffff	/* Mask for next DTIM (?) */
 #define AR5K_SLEEP0_NEXT_DTIM_S		0
 #define AR5K_SLEEP0_ASSUME_DTIM		0x00080000	/* Assume DTIM */
-#define AR5K_SLEEP0_ENH_SLEEP_EN	0x00100000	/* Enable enchanced sleep control */
+#define AR5K_SLEEP0_ENH_SLEEP_EN	0x00100000	/* Enable enhanced sleep control */
 #define AR5K_SLEEP0_CABTO		0xff000000	/* Mask for CAB Time Out */
 #define AR5K_SLEEP0_CABTO_S		24
 
@@ -1657,7 +1657,7 @@
 /*
  * TX power control (TPC) register
  *
- * XXX: PCDAC steps (0.5dbm) or DBM ?
+ * XXX: PCDAC steps (0.5dBm) or dBm ?
  *
  */
 #define AR5K_TXPC			0x80e8			/* Register Address */
@@ -1673,7 +1673,7 @@
 /*
  * Profile count registers
  *
- * These registers can be cleared and freezed with ATH5K_MIBC, but they do not
+ * These registers can be cleared and frozen with ATH5K_MIBC, but they do not
  * generate a MIB interrupt.
  * Instead of overflowing, they shift by one bit to the right. All registers
  * shift together, i.e. when one reaches the max, all shift at the same time by
@@ -1838,7 +1838,7 @@
 #define AR5K_PHY_TST2_TRIG_SEL		0x00000007	/* Trigger select (?)*/
 #define AR5K_PHY_TST2_TRIG		0x00000010	/* Trigger (?) */
 #define AR5K_PHY_TST2_CBUS_MODE		0x00000060	/* Cardbus mode (?) */
-#define AR5K_PHY_TST2_CLK32		0x00000400	/* CLK_OUT is CLK32 (32Khz external) */
+#define AR5K_PHY_TST2_CLK32		0x00000400	/* CLK_OUT is CLK32 (32kHz external) */
 #define AR5K_PHY_TST2_CHANCOR_DUMP_EN	0x00000800	/* Enable Chancor dump (?) */
 #define AR5K_PHY_TST2_EVEN_CHANCOR_DUMP	0x00001000	/* Even Chancor dump (?) */
 #define AR5K_PHY_TST2_RFSILENT_EN	0x00002000	/* Enable RFSILENT */
@@ -2002,7 +2002,7 @@
 #define	AR5K_PHY_AGCCTL_OFDM_DIV_DIS	0x00000008	/* Disable antenna diversity on OFDM modes */
 #define	AR5K_PHY_AGCCTL_NF_EN		0x00008000	/* Enable nf calibration to happen (?) */
 #define	AR5K_PHY_AGCTL_FLTR_CAL		0x00010000	/* Allow filter calibration (?) */
-#define	AR5K_PHY_AGCCTL_NF_NOUPDATE	0x00020000	/* Don't update nf automaticaly */
+#define	AR5K_PHY_AGCCTL_NF_NOUPDATE	0x00020000	/* Don't update nf automatically */
 
 /*
  * PHY noise floor status register (CCA = Clear Channel Assessment)
@@ -2089,7 +2089,7 @@
  *
  * It's obvious from the code that 0x989c is the buffer register but
  * for the other special registers that we write to after sending each
- * packet, i have no idea. So i'll name them BUFFER_CONTROL_X registers
+ * packet, i have no idea. So I'll name them BUFFER_CONTROL_X registers
  * for now. It's interesting that they are also used for some other operations.
  */
 
@@ -2340,7 +2340,7 @@
 #define AR5K_PHY_RESTART_DIV_GC_S	18
 
 /*
- * RF Bus access request register (for synth-oly channel switching)
+ * RF Bus access request register (for synth-only channel switching)
  */
 #define AR5K_PHY_RFBUS_REQ		0x997C
 #define AR5K_PHY_RFBUS_REQ_REQUEST	0x00000001
@@ -2382,7 +2382,7 @@
  */
 #define	AR5K_BB_GAIN_BASE		0x9b00	/* BaseBand Amplifier Gain table base address */
 #define AR5K_BB_GAIN(_n)		(AR5K_BB_GAIN_BASE + ((_n) << 2))
-#define	AR5K_RF_GAIN_BASE		0x9a00	/* RF Amplrifier Gain table base address */
+#define	AR5K_RF_GAIN_BASE		0x9a00	/* RF Amplifier Gain table base address */
 #define AR5K_RF_GAIN(_n)		(AR5K_RF_GAIN_BASE + ((_n) << 2))
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 19aefdb..57f2e56 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -213,7 +213,7 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 	usec_reg = (usec | sclock | txlat | rxlat);
 	ath5k_hw_reg_write(ah, usec_reg, AR5K_USEC);
 
-	/* On 5112 set tx frane to tx data start delay */
+	/* On 5112 set tx frame to tx data start delay */
 	if (ah->ah_radio == AR5K_RF5112) {
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RF_CTL2,
 					AR5K_PHY_RF_CTL2_TXF2TXD_START,
@@ -539,7 +539,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	 *
 	 * Note: putting PCI core on warm reset on PCI-E cards
 	 * results card to hang and always return 0xffff... so
-	 * we ingore that flag for PCI-E cards. On PCI cards
+	 * we ignore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
 	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
@@ -596,7 +596,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	 *
 	 * Note: putting PCI core on warm reset on PCI-E cards
 	 * results card to hang and always return 0xffff... so
-	 * we ingore that flag for PCI-E cards. On PCI cards
+	 * we ignore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
 	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
@@ -627,7 +627,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		return ret;
 	}
 
-	/* ...reset configuration regiter on Wisoc ...
+	/* ...reset configuration register on Wisoc ...
 	 * ...clear reset control register and pull device out of
 	 * warm reset on others */
 	if (ath5k_get_bus_type(ah) == ATH_AHB)
@@ -704,7 +704,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 		/*XXX: Can bwmode be used with dynamic mode ?
 		 * (I don't think it supports 44MHz) */
-		/* On 2425 initvals TURBO_SHORT is not pressent */
+		/* On 2425 initvals TURBO_SHORT is not present */
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
 			turbo = AR5K_PHY_TURBO_MODE |
 				(ah->ah_radio == AR5K_RF2425) ? 0 :
diff --git a/drivers/net/wireless/ath/ath5k/rfgain.h b/drivers/net/wireless/ath/ath5k/rfgain.h
index 70c9a45..ebfae05 100644
--- a/drivers/net/wireless/ath/ath5k/rfgain.h
+++ b/drivers/net/wireless/ath/ath5k/rfgain.h
@@ -30,7 +30,7 @@ struct ath5k_ini_rfgain {
 
 /* Initial RF Gain settings for RF5111 */
 static const struct ath5k_ini_rfgain rfgain_5111[] = {
-	/*			      5Ghz	2Ghz	*/
+	/*			      5GHz	2GHz	*/
 	{ AR5K_RF_GAIN(0),	{ 0x000001a9, 0x00000000 } },
 	{ AR5K_RF_GAIN(1),	{ 0x000001e9, 0x00000040 } },
 	{ AR5K_RF_GAIN(2),	{ 0x00000029, 0x00000080 } },
@@ -99,7 +99,7 @@ static const struct ath5k_ini_rfgain rfgain_5111[] = {
 
 /* Initial RF Gain settings for RF5112 */
 static const struct ath5k_ini_rfgain rfgain_5112[] = {
-	/*			      5Ghz	2Ghz	*/
+	/*			      5GHz	2GHz	*/
 	{ AR5K_RF_GAIN(0),	{ 0x00000007, 0x00000007 } },
 	{ AR5K_RF_GAIN(1),	{ 0x00000047, 0x00000047 } },
 	{ AR5K_RF_GAIN(2),	{ 0x00000087, 0x00000087 } },
@@ -305,7 +305,7 @@ static const struct ath5k_ini_rfgain rfgain_2316[] = {
 
 /* Initial RF Gain settings for RF5413 */
 static const struct ath5k_ini_rfgain rfgain_5413[] = {
-	/*			      5Ghz	2Ghz	*/
+	/*			      5GHz	2GHz	*/
 	{ AR5K_RF_GAIN(0),	{ 0x00000000, 0x00000000 } },
 	{ AR5K_RF_GAIN(1),	{ 0x00000040, 0x00000040 } },
 	{ AR5K_RF_GAIN(2),	{ 0x00000080, 0x00000080 } },
