Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2188 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0HORNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:18 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/6] ath5k: clean up some comments
Date: Sun, 15 Aug 2010 13:03:12 -0400
Message-Id: <1281891795-14718-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a few misspellings, word repetitions, and some grammar
nits in ath5k comments.  No code changes.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ani.c      |    6 +-
 drivers/net/wireless/ath/ath5k/attach.c   |    6 +-
 drivers/net/wireless/ath/ath5k/base.c     |   58 ++++++++++++++--------------
 drivers/net/wireless/ath/ath5k/dma.c      |    4 +-
 drivers/net/wireless/ath/ath5k/eeprom.c   |    4 +-
 drivers/net/wireless/ath/ath5k/phy.c      |   15 +++----
 drivers/net/wireless/ath/ath5k/reg.h      |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c    |   22 +++++-----
 drivers/net/wireless/ath/ath5k/rfbuffer.h |    4 +-
 9 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 26dbe65..e4a5f04 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -552,9 +552,9 @@ ath5k_ani_mib_intr(struct ath5k_hw *ah)
 	if (ah->ah_sc->ani_state.ani_mode != ATH5K_ANI_MODE_AUTO)
 		return;
 
-	/* if one of the errors triggered, we can get a superfluous second
-	 * interrupt, even though we have already reset the register. the
-	 * function detects that so we can return early */
+	/* If one of the errors triggered, we can get a superfluous second
+	 * interrupt, even though we have already reset the register. The
+	 * function detects that so we can return early. */
 	if (ath5k_ani_save_and_clear_phy_errors(ah, as) == 0)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index e72a1e5..aabad4f 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -139,12 +139,12 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	else
 		ah->ah_version = AR5K_AR5212;
 
-	/*Fill the ath5k_hw struct with the needed functions*/
+	/* Fill the ath5k_hw struct with the needed functions */
 	ret = ath5k_hw_init_desc_functions(ah);
 	if (ret)
 		goto err_free;
 
-	/* Bring device out of sleep and reset it's units */
+	/* Bring device out of sleep and reset its units */
 	ret = ath5k_hw_nic_wakeup(ah, 0, true);
 	if (ret)
 		goto err_free;
@@ -158,7 +158,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 			CHANNEL_5GHZ);
 	ah->ah_phy = AR5K_PHY(0);
 
-	/* Try to identify radio chip based on it's srev */
+	/* Try to identify radio chip based on its srev */
 	switch (ah->ah_radio_5ghz_revision & 0xf0) {
 	case AR5K_SREV_RAD_5111:
 		ah->ah_radio = AR5K_RF5111;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index efd9350..9c49b8d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -612,7 +612,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		goto err_free;
 	}
 
-	/*If we passed the test malloc a ath5k_hw struct*/
+	/* If we passed the test, malloc an ath5k_hw struct */
 	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
 	if (!sc->ah) {
 		ret = -ENOMEM;
@@ -786,8 +786,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Check if the MAC has multi-rate retry support.
 	 * We do this by trying to setup a fake extended
-	 * descriptor.  MAC's that don't have support will
-	 * return false w/o doing anything.  MAC's that do
+	 * descriptor.  MACs that don't have support will
+	 * return false w/o doing anything.  MACs that do
 	 * support it will return true w/o doing anything.
 	 */
 	ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
@@ -827,7 +827,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Allocate hardware transmit queues: one queue for
 	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that hw functions handle reseting
+	 * priority.  Note that hw functions handle resetting
 	 * these queues at the needed time.
 	 */
 	ret = ath5k_beaconq_setup(ah);
@@ -909,7 +909,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * NB: the order of these is important:
 	 * o call the 802.11 layer before detaching ath5k_hw to
-	 *   insure callbacks into the driver to delete global
+	 *   ensure callbacks into the driver to delete global
 	 *   key cache entries can be handled
 	 * o reclaim the tx queue data structures after calling
 	 *   the 802.11 layer as we'll get called back to reclaim
@@ -1514,7 +1514,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 	/*
 	 * Enable interrupts only for EOL and DESC conditions.
 	 * We mark tx descriptors to receive a DESC interrupt
-	 * when a tx queue gets deep; otherwise waiting for the
+	 * when a tx queue gets deep; otherwise we wait for the
 	 * EOL to reap descriptors.  Note that this is done to
 	 * reduce interrupt load and this only defers reaping
 	 * descriptors, never transmitting frames.  Aside from
@@ -1859,7 +1859,7 @@ ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int rssi)
 }
 
 /*
- * Compute padding position. skb must contains an IEEE 802.11 frame
+ * Compute padding position. skb must contain an IEEE 802.11 frame
  */
 static int ath5k_common_padpos(struct sk_buff *skb)
 {
@@ -1878,10 +1878,9 @@ static int ath5k_common_padpos(struct sk_buff *skb)
 }
 
 /*
- * This function expects a 802.11 frame and returns the number of
- * bytes added, or -1 if we don't have enought header room.
+ * This function expects an 802.11 frame and returns the number of
+ * bytes added, or -1 if we don't have enough header room.
  */
-
 static int ath5k_add_padding(struct sk_buff *skb)
 {
 	int padpos = ath5k_common_padpos(skb);
@@ -1901,10 +1900,18 @@ static int ath5k_add_padding(struct sk_buff *skb)
 }
 
 /*
- * This function expects a 802.11 frame and returns the number of
- * bytes removed
+ * The MAC header is padded to have 32-bit boundary if the
+ * packet payload is non-zero. The general calculation for
+ * padsize would take into account odd header lengths:
+ * padsize = 4 - (hdrlen & 3); however, since only
+ * even-length headers are used, padding can only be 0 or 2
+ * bytes and we can optimize this a bit.  We must not try to
+ * remove padding from short control frames that do not have a
+ * payload.
+ *
+ * This function expects an 802.11 frame and returns the number of
+ * bytes removed.
  */
-
 static int ath5k_remove_padding(struct sk_buff *skb)
 {
 	int padpos = ath5k_common_padpos(skb);
@@ -1925,14 +1932,6 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 {
 	struct ieee80211_rx_status *rxs;
 
-	/* The MAC header is padded to have 32-bit boundary if the
-	 * packet payload is non-zero. The general calculation for
-	 * padsize would take into account odd header lengths:
-	 * padsize = (4 - hdrlen % 4) % 4; However, since only
-	 * even-length headers are used, padding can only be 0 or 2
-	 * bytes and we can optimize this a bit. In addition, we must
-	 * not try to remove padding from short control frames that do
-	 * not have payload. */
 	ath5k_remove_padding(skb);
 
 	rxs = IEEE80211_SKB_RXCB(skb);
@@ -2281,10 +2280,11 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * default antenna which is supposed to be an omni.
 	 *
 	 * Note2: On sectored scenarios it's possible to have
-	 * multiple antennas (1omni -the default- and 14 sectors)
-	 * so if we choose to actually support this mode we need
-	 * to allow user to set how many antennas we have and tweak
-	 * the code below to send beacons on all of them.
+	 * multiple antennas (1 omni -- the default -- and 14
+	 * sectors), so if we choose to actually support this
+	 * mode, we need to allow the user to set how many antennas
+	 * we have and tweak the code below to send beacons
+	 * on all of them.
 	 */
 	if (ah->ah_ant_mode == AR5K_ANTMODE_SECTOR_AP)
 		antenna = sc->bsent & 4 ? 2 : 1;
@@ -2333,7 +2333,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	}
 	/*
 	 * Check if the previous beacon has gone out.  If
-	 * not don't don't try to post another, skip this
+	 * not, don't don't try to post another: skip this
 	 * period and wait for the next.  Missed beacons
 	 * indicate a problem and should not occur.  If we
 	 * miss too many consecutive beacons reset the device.
@@ -2905,8 +2905,8 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		ATH5K_DBG(sc, ATH5K_DEBUG_XMIT, "tx in monitor (scan?)\n");
 
 	/*
-	 * the hardware expects the header padded to 4 byte boundaries
-	 * if this is not the case we add the padding after the header
+	 * The hardware expects the header padded to 4 byte boundaries.
+	 * If this is not the case, we add the padding after the header.
 	 */
 	padsize = ath5k_add_padding(skb);
 	if (padsize < 0) {
@@ -3274,7 +3274,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	/* Set multicast bits */
 	ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
-	/* Set the cached hw filter flags, this will alter actually
+	/* Set the cached hw filter flags, this will later actually
 	 * be set in HW */
 	sc->filter_flags = rfilt;
 
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 484f318..58bb6c5 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -377,11 +377,11 @@ int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
  *
  * This function increases/decreases the tx trigger level for the tx fifo
  * buffer (aka FIFO threshold) that is used to indicate when PCU flushes
- * the buffer and transmits it's data. Lowering this results sending small
+ * the buffer and transmits its data. Lowering this results sending small
  * frames more quickly but can lead to tx underruns, raising it a lot can
  * result other problems (i think bmiss is related). Right now we start with
  * the lowest possible (64Bytes) and if we get tx underrun we increase it using
- * the increase flag. Returns -EIO if we have have reached maximum/minimum.
+ * the increase flag. Returns -EIO if we have reached maximum/minimum.
  *
  * XXX: Link this with tx DMA size ?
  * XXX: Use it to save interrupts ?
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index ae316fe..39722dd 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -661,7 +661,7 @@ ath5k_eeprom_init_11bg_2413(struct ath5k_hw *ah, unsigned int mode, int offset)
  * (eeprom versions < 4). For RF5111 we have 11 pre-defined PCDAC
  * steps that match with the power values we read from eeprom. On
  * older eeprom versions (< 3.2) these steps are equaly spaced at
- * 10% of the pcdac curve -until the curve reaches it's maximum-
+ * 10% of the pcdac curve -until the curve reaches its maximum-
  * (11 steps from 0 to 100%) but on newer eeprom versions (>= 3.2)
  * these 11 steps are spaced in a different way. This function returns
  * the pcdac steps based on eeprom version and curve min/max so that we
@@ -1113,7 +1113,7 @@ ath5k_eeprom_read_pcal_info_5112(struct ath5k_hw *ah, int mode)
  */
 
 /* For RF2413 power calibration data doesn't start on a fixed location and
- * if a mode is not supported, it's section is missing -not zeroed-.
+ * if a mode is not supported, its section is missing -not zeroed-.
  * So we need to calculate the starting offset for each section by using
  * these two functions */
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6284c38..c7c4465 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -115,7 +115,7 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
 \**********************/
 
 /*
- * This code is used to optimize rf gain on different environments
+ * This code is used to optimize RF gain on different environments
  * (temperature mostly) based on feedback from a power detector.
  *
  * It's only used on RF5111 and RF5112, later RF chips seem to have
@@ -302,7 +302,7 @@ static bool ath5k_hw_rf_check_gainf_readback(struct ath5k_hw *ah)
 }
 
 /* Perform gain_F adjustment by choosing the right set
- * of parameters from rf gain optimization ladder */
+ * of parameters from RF gain optimization ladder */
 static s8 ath5k_hw_rf_gainf_adjust(struct ath5k_hw *ah)
 {
 	const struct ath5k_gain_opt *go;
@@ -367,7 +367,7 @@ done:
 	return ret;
 }
 
-/* Main callback for thermal rf gain calibration engine
+/* Main callback for thermal RF gain calibration engine
  * Check for a new gain reading and schedule an adjustment
  * if needed.
  *
@@ -433,7 +433,7 @@ done:
 	return ah->ah_gain.g_state;
 }
 
-/* Write initial rf gain table to set the RF sensitivity
+/* Write initial RF gain table to set the RF sensitivity
  * this one works on all RF chips and has nothing to do
  * with gain_F calibration */
 int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
@@ -496,7 +496,7 @@ int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
 
 
 /*
- * Setup RF registers by writing rf buffer on hw
+ * Setup RF registers by writing RF buffer on hw
  */
 int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		unsigned int mode)
@@ -571,7 +571,7 @@ int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		return -EINVAL;
 	}
 
-	/* If it's the first time we set rf buffer, allocate
+	/* If it's the first time we set RF buffer, allocate
 	 * ah->ah_rf_banks based on ah->ah_rf_banks_size
 	 * we set above */
 	if (ah->ah_rf_banks == NULL) {
@@ -3035,9 +3035,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	/* Limit max power if we have a CTL available */
 	ath5k_get_max_ctl_power(ah, channel);
 
-	/* FIXME: Tx power limit for this regdomain
-	 * XXX: Mac80211/CRDA will do that anyway ? */
-
 	/* FIXME: Antenna reduction stuff */
 
 	/* FIXME: Limit power on turbo modes */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 55b4ac6..05ef587 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1911,7 +1911,7 @@
 #define	AR5K_PHY_TURBO			0x9804			/* Register Address */
 #define	AR5K_PHY_TURBO_MODE		0x00000001	/* Enable turbo mode */
 #define	AR5K_PHY_TURBO_SHORT		0x00000002	/* Set short symbols to turbo mode */
-#define	AR5K_PHY_TURBO_MIMO		0x00000004	/* Set turbo for mimo mimo */
+#define	AR5K_PHY_TURBO_MIMO		0x00000004	/* Set turbo for mimo */
 
 /*
  * PHY agility command register
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index f5434eb..4154959 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -959,7 +959,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 						AR5K_QUEUE_DCU_SEQNUM(0));
 			}
 
-			/* TSF accelerates on AR5211 durring reset
+			/* TSF accelerates on AR5211 during reset
 			 * As a workaround save it here and restore
 			 * it later so that it's back in time after
 			 * reset. This way it'll get re-synced on the
@@ -1080,7 +1080,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 				return ret;
 
 			/* Spur info is available only from EEPROM versions
-			 * bigger than 5.3 but but the EEPOM routines will use
+			 * greater than 5.3, but the EEPROM routines will use
 			 * static values for older versions */
 			if (ah->ah_mac_srev >= AR5K_SREV_AR5424)
 				ath5k_hw_set_spur_mitigation_filter(ah,
@@ -1173,11 +1173,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/* Set RSSI/BRSSI thresholds
 	 *
 	 * Note: If we decide to set this value
-	 * dynamicaly, have in mind that when AR5K_RSSI_THR
-	 * register is read it might return 0x40 if we haven't
-	 * wrote anything to it plus BMISS RSSI threshold is zeroed.
+	 * dynamically, keep in mind that when AR5K_RSSI_THR
+	 * register is read, it might return 0x40 if we haven't
+	 * written anything to it.  Also, BMISS RSSI threshold is zeroed.
 	 * So doing a save/restore procedure here isn't the right
-	 * choice. Instead store it on ath5k_hw */
+	 * choice. Instead, store it in ath5k_hw */
 	ath5k_hw_reg_write(ah, (AR5K_TUNE_RSSI_THRES |
 				AR5K_TUNE_BMISS_THRES <<
 				AR5K_RSSI_THR_BMISS_S),
@@ -1235,7 +1235,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	/*
 	 * Perform ADC test to see if baseband is ready
-	 * Set tx hold and check adc test register
+	 * Set TX hold and check ADC test register
 	 */
 	phy_tst1 = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
 	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
@@ -1254,15 +1254,15 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 *
 	 * This method is used to calibrate some static offsets
 	 * used together with on-the fly I/Q calibration (the
-	 * one performed via ath5k_hw_phy_calibrate), that doesn't
+	 * one performed via ath5k_hw_phy_calibrate), which doesn't
 	 * interrupt rx path.
 	 *
 	 * While rx path is re-routed to the power detector we also
-	 * start a noise floor calibration, to measure the
+	 * start a noise floor calibration to measure the
 	 * card's noise floor (the noise we measure when we are not
-	 * transmiting or receiving anything).
+	 * transmitting or receiving anything).
 	 *
-	 * If we are in a noisy environment AGC calibration may time
+	 * If we are in a noisy environment, AGC calibration may time
 	 * out and/or noise floor calibration might timeout.
 	 */
 	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
diff --git a/drivers/net/wireless/ath/ath5k/rfbuffer.h b/drivers/net/wireless/ath/ath5k/rfbuffer.h
index e50baff..3ac4cff 100644
--- a/drivers/net/wireless/ath/ath5k/rfbuffer.h
+++ b/drivers/net/wireless/ath/ath5k/rfbuffer.h
@@ -25,10 +25,10 @@
  *
  * We don't write on those registers directly but
  * we send a data packet on the chip, using a special register,
- * that holds all the settings we need. After we 've sent the
+ * that holds all the settings we need. After we've sent the
  * data packet, we write on another special register to notify hw
  * to apply the settings. This is done so that control registers
- * can be dynamicaly programmed during operation and the settings
+ * can be dynamically programmed during operation and the settings
  * are applied faster on the hw.
  *
  * We call each data packet an "RF Bank" and all the data we write
-- 
1.7.1.1


