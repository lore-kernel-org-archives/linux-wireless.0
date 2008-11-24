Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11582 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYKXGlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 01:41:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 22:41:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18730.19395.12503.376750@gargle.gargle.HOWL> (sfid-20081124_074114_682091_422151E7)
Date: Mon, 24 Nov 2008 12:07:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/2] ath9k: Code scrub
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge core.c and base.c
Remove Antenna Diversity (unused now).
Remove unused chainmask handling code.
Comment, indentation scrub.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/Makefile |    3 +-
 drivers/net/wireless/ath9k/beacon.c |   80 +--
 drivers/net/wireless/ath9k/core.c   | 1610 -----------------------------------
 drivers/net/wireless/ath9k/core.h   |  155 +----
 drivers/net/wireless/ath9k/main.c   | 1195 +++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/rc.c     |    9 +-
 drivers/net/wireless/ath9k/recv.c   |   22 +
 drivers/net/wireless/ath9k/xmit.c   |   22 +-
 8 files changed, 1231 insertions(+), 1865 deletions(-)

diff --git a/drivers/net/wireless/ath9k/Makefile b/drivers/net/wireless/ath9k/Makefile
index c58cfde..c741e8d 100644
--- a/drivers/net/wireless/ath9k/Makefile
+++ b/drivers/net/wireless/ath9k/Makefile
@@ -9,7 +9,6 @@ ath9k-y +=	hw.o \
 		main.o \
 		recv.o \
 		xmit.o \
-		rc.o \
-		core.o
+		rc.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 8b94635..e80d9b9 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -14,13 +14,9 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
- /* Implementation of beacon processing. */
-
 #include "core.h"
 
 /*
- *  Configure parameters for the beacon queue
- *
  *  This function will modify certain transmit queue properties depending on
  *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
  *  settings and channel width min/max
@@ -54,9 +50,15 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	}
 }
 
+static void ath_bstuck_process(struct ath_softc *sc)
+{
+	DPRINTF(sc, ATH_DBG_BEACON,
+		"%s: stuck beacon; resetting (bmiss count %u)\n",
+		__func__, sc->sc_bmisscount);
+	ath_reset(sc, false);
+}
+
 /*
- *  Setup the beacon frame for transmit.
- *
  *  Associates the beacon frame buffer with a transmit descriptor.  Will set
  *  up all required antenna switch parameters, rate codes, and channel flags.
  *  Beacons are always sent out at the lowest rate, and are not retried.
@@ -138,14 +140,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		ctsrate, ctsduration, series, 4, 0);
 }
 
-/*
- *  Generate beacon frame and queue cab data for a vap.
- *
- *  Updates the contents of the beacon frame.  It is assumed that the buffer for
- *  the beacon frame has been allocated in the ATH object, and simply needs to
- *  be filled for this cycle.  Also, any CAB (crap after beacon?) traffic will
- *  be added to the beacon frame at this point.
-*/
+/* Generate beacon frame and queue cab data for a vap */
 static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 {
 	struct ath_buf *bf;
@@ -275,14 +270,6 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 		sc->sc_bhalq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
-/*
- *  Setup a h/w transmit queue for beacons.
- *
- *  This function allocates an information structure (struct ath9k_txq_info)
- *  on the stack, sets some specific parameters (zero out channel width
- *  min/max, and enable aifs). The info structure does not need to be
- *  persistant.
-*/
 int ath_beaconq_setup(struct ath_hal *ah)
 {
 	struct ath9k_tx_queue_info qi;
@@ -295,14 +282,6 @@ int ath_beaconq_setup(struct ath_hal *ah)
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 
-
-/*
- *  Allocate and setup an initial beacon frame.
- *
- *  Allocate a beacon state variable for a specific VAP instance created on
- *  the ATH interface.  This routine also calculates the beacon "slot" for
- *  staggared beacons in the mBSSID case.
-*/
 int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 {
 	struct ieee80211_vif *vif;
@@ -321,7 +300,6 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	if (!avp->av_bcbuf) {
 		/* Allocate beacon state for hostap/ibss.  We know
 		 * a buffer is available. */
-
 		avp->av_bcbuf = list_first_entry(&sc->sc_bbuf,
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
@@ -427,12 +405,6 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	return 0;
 }
 
-/*
- *  Reclaim beacon resources and return buffer to the pool.
- *
- *  Checks the VAP to put the beacon frame buffer back to the ATH object
- *  queue, and de-allocates any skbs that were sent as CAB traffic.
-*/
 void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 {
 	if (avp->av_bcbuf != NULL) {
@@ -458,13 +430,6 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 	}
 }
 
-/*
- * Tasklet for Sending Beacons
- *
- * Transmit one or more beacon frames at SWBA.  Dynamic updates to the frame
- * contents are done as needed and the slot time is also adjusted based on
- * current state.
-*/
 void ath9k_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -481,9 +446,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 
 	if (sc->sc_flags & SC_OP_NO_RESET) {
 		show_cycles = ath9k_hw_GetMibCycleCountsPct(ah,
-							    &rx_clear,
-							    &rx_frame,
-							    &tx_frame);
+					    &rx_clear, &rx_frame, &tx_frame);
 	}
 
 	/*
@@ -605,9 +568,10 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if (sc->sc_updateslot == UPDATE) {
 		sc->sc_updateslot = COMMIT; /* commit next beacon */
 		sc->sc_slotupdate = slot;
-	} else if (sc->sc_updateslot == COMMIT && sc->sc_slotupdate == slot)
-		ath_setslottime(sc);        /* commit change to hardware */
-
+	} else if (sc->sc_updateslot == COMMIT && sc->sc_slotupdate == slot) {
+		ath9k_hw_setslottime(sc->sc_ah, sc->sc_slottime);
+		sc->sc_updateslot = OK;
+	}
 	if (bfaddr != 0) {
 		/*
 		 * Stop any current dma and put the new frame(s) on the queue.
@@ -630,20 +594,6 @@ void ath9k_beacon_tasklet(unsigned long data)
 }
 
 /*
- *  Tasklet for Beacon Stuck processing
- *
- *  Processing for Beacon Stuck.
- *  Basically resets the chip.
-*/
-void ath_bstuck_process(struct ath_softc *sc)
-{
-	DPRINTF(sc, ATH_DBG_BEACON,
-		"%s: stuck beacon; resetting (bmiss count %u)\n",
-		__func__, sc->sc_bmisscount);
-	ath_reset(sc, false);
-}
-
-/*
  * Configure the beacon and sleep timers.
  *
  * When operating as an AP this resets the TSF and sets
@@ -886,8 +836,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	}
 }
 
-/* Function to collect beacon rssi data and resync beacon if necessary */
-
 void ath_beacon_sync(struct ath_softc *sc, int if_id)
 {
 	/*
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index fb6a013..e69de29 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1,1610 +0,0 @@
-/*
- * Copyright (c) 2008, Atheros Communications Inc.
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
-#include "core.h"
-#include "regd.h"
-
-static u32 ath_chainmask_sel_up_rssi_thres =
-	ATH_CHAINMASK_SEL_UP_RSSI_THRES;
-static u32 ath_chainmask_sel_down_rssi_thres =
-	ATH_CHAINMASK_SEL_DOWN_RSSI_THRES;
-static u32 ath_chainmask_sel_period =
-	ATH_CHAINMASK_SEL_TIMEOUT;
-
-/* return bus cachesize in 4B word units */
-
-static void bus_read_cachesize(struct ath_softc *sc, int *csz)
-{
-	u8 u8tmp;
-
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u8 *)&u8tmp);
-	*csz = (int)u8tmp;
-
-	/*
-	 * This check was put in to avoid "unplesant" consequences if
-	 * the bootrom has not fully initialized all PCI devices.
-	 * Sometimes the cache line size register is not set
-	 */
-
-	if (*csz == 0)
-		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
-}
-
-static u8 parse_mpdudensity(u8 mpdudensity)
-{
-	/*
-	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
-	 *   0 for no restriction
-	 *   1 for 1/4 us
-	 *   2 for 1/2 us
-	 *   3 for 1 us
-	 *   4 for 2 us
-	 *   5 for 4 us
-	 *   6 for 8 us
-	 *   7 for 16 us
-	 */
-	switch (mpdudensity) {
-	case 0:
-		return 0;
-	case 1:
-	case 2:
-	case 3:
-		/* Our lower layer calculations limit our precision to
-		   1 microsecond */
-		return 1;
-	case 4:
-		return 2;
-	case 5:
-		return 4;
-	case 6:
-		return 8;
-	case 7:
-		return 16;
-	default:
-		return 0;
-	}
-}
-
-/*
- *  Set current operating mode
-*/
-static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
-{
-	sc->sc_curmode = mode;
-	/*
-	 * All protection frames are transmited at 2Mb/s for
-	 * 11g, otherwise at 1Mb/s.
-	 * XXX select protection rate index from rate table.
-	 */
-	sc->sc_protrix = (mode == ATH9K_MODE_11G ? 1 : 0);
-}
-
-/*
- * Set up rate table (legacy rates)
- */
-static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
-{
-	struct ath_rate_table *rate_table = NULL;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
-	int i, maxrates;
-
-	switch (band) {
-	case IEEE80211_BAND_2GHZ:
-		rate_table = sc->hw_rate_table[ATH9K_MODE_11G];
-		break;
-	case IEEE80211_BAND_5GHZ:
-		rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
-		break;
-	default:
-		break;
-	}
-
-	if (rate_table == NULL)
-		return;
-
-	sband = &sc->sbands[band];
-	rate = sc->rates[band];
-
-	if (rate_table->rate_cnt > ATH_RATE_MAX)
-		maxrates = ATH_RATE_MAX;
-	else
-		maxrates = rate_table->rate_cnt;
-
-	for (i = 0; i < maxrates; i++) {
-		rate[i].bitrate = rate_table->info[i].ratekbps / 100;
-		rate[i].hw_value = rate_table->info[i].ratecode;
-		sband->n_bitrates++;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: Rate: %2dMbps, ratecode: %2d\n",
-			__func__,
-			rate[i].bitrate / 10,
-			rate[i].hw_value);
-	}
-}
-
-/*
- *  Set up channel list
- */
-static int ath_setup_channels(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int nchan, i, a = 0, b = 0;
-	u8 regclassids[ATH_REGCLASSIDS_MAX];
-	u32 nregclass = 0;
-	struct ieee80211_supported_band *band_2ghz;
-	struct ieee80211_supported_band *band_5ghz;
-	struct ieee80211_channel *chan_2ghz;
-	struct ieee80211_channel *chan_5ghz;
-	struct ath9k_channel *c;
-
-	/* Fill in ah->ah_channels */
-	if (!ath9k_regd_init_channels(ah, ATH_CHAN_MAX, (u32 *)&nchan,
-				      regclassids, ATH_REGCLASSIDS_MAX,
-				      &nregclass, CTRY_DEFAULT, false, 1)) {
-		u32 rd = ah->ah_currentRD;
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to collect channel list; "
-			"regdomain likely %u country code %u\n",
-			__func__, rd, CTRY_DEFAULT);
-		return -EINVAL;
-	}
-
-	band_2ghz = &sc->sbands[IEEE80211_BAND_2GHZ];
-	band_5ghz = &sc->sbands[IEEE80211_BAND_5GHZ];
-	chan_2ghz = sc->channels[IEEE80211_BAND_2GHZ];
-	chan_5ghz = sc->channels[IEEE80211_BAND_5GHZ];
-
-	for (i = 0; i < nchan; i++) {
-		c = &ah->ah_channels[i];
-		if (IS_CHAN_2GHZ(c)) {
-			chan_2ghz[a].band = IEEE80211_BAND_2GHZ;
-			chan_2ghz[a].center_freq = c->channel;
-			chan_2ghz[a].max_power = c->maxTxPower;
-
-			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
-			if (c->channelFlags & CHANNEL_PASSIVE)
-				chan_2ghz[a].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-			band_2ghz->n_channels = ++a;
-
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"%s: 2MHz channel: %d, "
-				"channelFlags: 0x%x\n",
-				__func__, c->channel, c->channelFlags);
-		} else if (IS_CHAN_5GHZ(c)) {
-			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
-			chan_5ghz[b].center_freq = c->channel;
-			chan_5ghz[b].max_power = c->maxTxPower;
-
-			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
-			if (c->channelFlags & CHANNEL_PASSIVE)
-				chan_5ghz[b].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-			band_5ghz->n_channels = ++b;
-
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"%s: 5MHz channel: %d, "
-				"channelFlags: 0x%x\n",
-				__func__, c->channel, c->channelFlags);
-		}
-	}
-
-	return 0;
-}
-
-/*
- *  Determine mode from channel flags
- *
- *  This routine will provide the enumerated WIRELESSS_MODE value based
- *  on the settings of the channel flags.  If no valid set of flags
- *  exist, the lowest mode (11b) is selected.
-*/
-
-static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
-{
-	if (chan->chanmode == CHANNEL_A)
-		return ATH9K_MODE_11A;
-	else if (chan->chanmode == CHANNEL_G)
-		return ATH9K_MODE_11G;
-	else if (chan->chanmode == CHANNEL_B)
-		return ATH9K_MODE_11B;
-	else if (chan->chanmode == CHANNEL_A_HT20)
-		return ATH9K_MODE_11NA_HT20;
-	else if (chan->chanmode == CHANNEL_G_HT20)
-		return ATH9K_MODE_11NG_HT20;
-	else if (chan->chanmode == CHANNEL_A_HT40PLUS)
-		return ATH9K_MODE_11NA_HT40PLUS;
-	else if (chan->chanmode == CHANNEL_A_HT40MINUS)
-		return ATH9K_MODE_11NA_HT40MINUS;
-	else if (chan->chanmode == CHANNEL_G_HT40PLUS)
-		return ATH9K_MODE_11NG_HT40PLUS;
-	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
-		return ATH9K_MODE_11NG_HT40MINUS;
-
-	WARN_ON(1); /* should not get here */
-
-	return ATH9K_MODE_11B;
-}
-
-/*
- * Set the current channel
- *
- * Set/change channels.  If the channel is really being changed, it's done
- * by reseting the chip.  To accomplish this we must first cleanup any pending
- * DMA, then restart stuff after a la ath_init.
-*/
-int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	bool fastcc = true, stopped;
-
-	if (sc->sc_flags & SC_OP_INVALID) /* the device is invalid or removed */
-		return -EIO;
-
-	DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: %u (%u MHz) -> %u (%u MHz), cflags:%x\n",
-		__func__,
-		ath9k_hw_mhz2ieee(ah, sc->sc_ah->ah_curchan->channel,
-				  sc->sc_ah->ah_curchan->channelFlags),
-		sc->sc_ah->ah_curchan->channel,
-		ath9k_hw_mhz2ieee(ah, hchan->channel, hchan->channelFlags),
-		hchan->channel, hchan->channelFlags);
-
-	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
-	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
-	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
-	    (sc->sc_flags & SC_OP_FULL_RESET)) {
-		int status;
-		/*
-		 * This is only performed if the channel settings have
-		 * actually changed.
-		 *
-		 * To switch channels clear any pending DMA operations;
-		 * wait long enough for the RX fifo to drain, reset the
-		 * hardware at the new frequency, and then re-enable
-		 * the relevant bits of the h/w.
-		 */
-		ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-		ath_draintxq(sc, false);	/* clear pending tx frames */
-		stopped = ath_stoprecv(sc);	/* turn off frame recv */
-
-		/* XXX: do not flush receive queue here. We don't want
-		 * to flush data frames already in queue because of
-		 * changing channel. */
-
-		if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
-			fastcc = false;
-
-		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, hchan,
-				    sc->sc_ht_info.tx_chan_width,
-				    sc->sc_tx_chainmask,
-				    sc->sc_rx_chainmask,
-				    sc->sc_ht_extprotspacing,
-				    fastcc, &status)) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: unable to reset channel %u (%uMhz) "
-				"flags 0x%x hal status %u\n", __func__,
-				ath9k_hw_mhz2ieee(ah, hchan->channel,
-						  hchan->channelFlags),
-				hchan->channel, hchan->channelFlags, status);
-			spin_unlock_bh(&sc->sc_resetlock);
-			return -EIO;
-		}
-		spin_unlock_bh(&sc->sc_resetlock);
-
-		sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
-		sc->sc_flags &= ~SC_OP_FULL_RESET;
-
-		/* Re-enable rx framework */
-		if (ath_startrecv(sc) != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: unable to restart recv logic\n", __func__);
-			return -EIO;
-		}
-		/*
-		 * Change channels and update the h/w rate map
-		 * if we're switching; e.g. 11a to 11b/g.
-		 */
-		ath_setcurmode(sc, ath_chan2mode(hchan));
-
-		ath_update_txpow(sc);	/* update tx power state */
-		/*
-		 * Re-enable interrupts.
-		 */
-		ath9k_hw_set_interrupts(ah, sc->sc_imask);
-	}
-	return 0;
-}
-
-/**********************/
-/* Chainmask Handling */
-/**********************/
-
-static void ath_chainmask_sel_timertimeout(unsigned long data)
-{
-	struct ath_chainmask_sel *cm = (struct ath_chainmask_sel *)data;
-	cm->switch_allowed = 1;
-}
-
-/* Start chainmask select timer */
-static void ath_chainmask_sel_timerstart(struct ath_chainmask_sel *cm)
-{
-	cm->switch_allowed = 0;
-	mod_timer(&cm->timer, ath_chainmask_sel_period);
-}
-
-/* Stop chainmask select timer */
-static void ath_chainmask_sel_timerstop(struct ath_chainmask_sel *cm)
-{
-	cm->switch_allowed = 0;
-	del_timer_sync(&cm->timer);
-}
-
-static void ath_chainmask_sel_init(struct ath_softc *sc, struct ath_node *an)
-{
-	struct ath_chainmask_sel *cm = &an->an_chainmask_sel;
-
-	memset(cm, 0, sizeof(struct ath_chainmask_sel));
-
-	cm->cur_tx_mask = sc->sc_tx_chainmask;
-	cm->cur_rx_mask = sc->sc_rx_chainmask;
-	cm->tx_avgrssi = ATH_RSSI_DUMMY_MARKER;
-	setup_timer(&cm->timer,
-		ath_chainmask_sel_timertimeout, (unsigned long) cm);
-}
-
-int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
-{
-	struct ath_chainmask_sel *cm = &an->an_chainmask_sel;
-
-	/*
-	 * Disable auto-swtiching in one of the following if conditions.
-	 * sc_chainmask_auto_sel is used for internal global auto-switching
-	 * enabled/disabled setting
-	 */
-	if (sc->sc_ah->ah_caps.tx_chainmask != ATH_CHAINMASK_SEL_3X3) {
-		cm->cur_tx_mask = sc->sc_tx_chainmask;
-		return cm->cur_tx_mask;
-	}
-
-	if (cm->tx_avgrssi == ATH_RSSI_DUMMY_MARKER)
-		return cm->cur_tx_mask;
-
-	if (cm->switch_allowed) {
-		/* Switch down from tx 3 to tx 2. */
-		if (cm->cur_tx_mask == ATH_CHAINMASK_SEL_3X3 &&
-		    ATH_RSSI_OUT(cm->tx_avgrssi) >=
-		    ath_chainmask_sel_down_rssi_thres) {
-			cm->cur_tx_mask = sc->sc_tx_chainmask;
-
-			/* Don't let another switch happen until
-			 * this timer expires */
-			ath_chainmask_sel_timerstart(cm);
-		}
-		/* Switch up from tx 2 to 3. */
-		else if (cm->cur_tx_mask == sc->sc_tx_chainmask &&
-			 ATH_RSSI_OUT(cm->tx_avgrssi) <=
-			 ath_chainmask_sel_up_rssi_thres) {
-			cm->cur_tx_mask = ATH_CHAINMASK_SEL_3X3;
-
-			/* Don't let another switch happen
-			 * until this timer expires */
-			ath_chainmask_sel_timerstart(cm);
-		}
-	}
-
-	return cm->cur_tx_mask;
-}
-
-/*
- * Update tx/rx chainmask. For legacy association,
- * hard code chainmask to 1x1, for 11n association, use
- * the chainmask configuration.
- */
-
-void ath_update_chainmask(struct ath_softc *sc, int is_ht)
-{
-	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
-	if (is_ht) {
-		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
-		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
-	} else {
-		sc->sc_tx_chainmask = 1;
-		sc->sc_rx_chainmask = 1;
-	}
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: tx chmask: %d, rx chmask: %d\n",
-		__func__, sc->sc_tx_chainmask, sc->sc_rx_chainmask);
-}
-
-/*******/
-/* ANI */
-/*******/
-
-/*
- *  This routine performs the periodic noise floor calibration function
- *  that is used to adjust and optimize the chip performance.  This
- *  takes environmental changes (location, temperature) into account.
- *  When the task is complete, it reschedules itself depending on the
- *  appropriate interval that was calculated.
- */
-
-static void ath_ani_calibrate(unsigned long data)
-{
-	struct ath_softc *sc;
-	struct ath_hal *ah;
-	bool longcal = false;
-	bool shortcal = false;
-	bool aniflag = false;
-	unsigned int timestamp = jiffies_to_msecs(jiffies);
-	u32 cal_interval;
-
-	sc = (struct ath_softc *)data;
-	ah = sc->sc_ah;
-
-	/*
-	* don't calibrate when we're scanning.
-	* we are most likely not on our home channel.
-	*/
-	if (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)
-		return;
-
-	/* Long calibration runs independently of short calibration. */
-	if ((timestamp - sc->sc_ani.sc_longcal_timer) >= ATH_LONG_CALINTERVAL) {
-		longcal = true;
-		DPRINTF(sc, ATH_DBG_ANI, "%s: longcal @%lu\n",
-			__func__, jiffies);
-		sc->sc_ani.sc_longcal_timer = timestamp;
-	}
-
-	/* Short calibration applies only while sc_caldone is false */
-	if (!sc->sc_ani.sc_caldone) {
-		if ((timestamp - sc->sc_ani.sc_shortcal_timer) >=
-		    ATH_SHORT_CALINTERVAL) {
-			shortcal = true;
-			DPRINTF(sc, ATH_DBG_ANI, "%s: shortcal @%lu\n",
-			       __func__, jiffies);
-			sc->sc_ani.sc_shortcal_timer = timestamp;
-			sc->sc_ani.sc_resetcal_timer = timestamp;
-		}
-	} else {
-		if ((timestamp - sc->sc_ani.sc_resetcal_timer) >=
-		    ATH_RESTART_CALINTERVAL) {
-			ath9k_hw_reset_calvalid(ah, ah->ah_curchan,
-						&sc->sc_ani.sc_caldone);
-			if (sc->sc_ani.sc_caldone)
-				sc->sc_ani.sc_resetcal_timer = timestamp;
-		}
-	}
-
-	/* Verify whether we must check ANI */
-	if ((timestamp - sc->sc_ani.sc_checkani_timer) >=
-	   ATH_ANI_POLLINTERVAL) {
-		aniflag = true;
-		sc->sc_ani.sc_checkani_timer = timestamp;
-	}
-
-	/* Skip all processing if there's nothing to do. */
-	if (longcal || shortcal || aniflag) {
-		/* Call ANI routine if necessary */
-		if (aniflag)
-			ath9k_hw_ani_monitor(ah, &sc->sc_halstats,
-					     ah->ah_curchan);
-
-		/* Perform calibration if necessary */
-		if (longcal || shortcal) {
-			bool iscaldone = false;
-
-			if (ath9k_hw_calibrate(ah, ah->ah_curchan,
-					       sc->sc_rx_chainmask, longcal,
-					       &iscaldone)) {
-				if (longcal)
-					sc->sc_ani.sc_noise_floor =
-						ath9k_hw_getchan_noise(ah,
-							       ah->ah_curchan);
-
-				DPRINTF(sc, ATH_DBG_ANI,
-					"%s: calibrate chan %u/%x nf: %d\n",
-					 __func__,
-					ah->ah_curchan->channel,
-					ah->ah_curchan->channelFlags,
-					sc->sc_ani.sc_noise_floor);
-			} else {
-				DPRINTF(sc, ATH_DBG_ANY,
-					"%s: calibrate chan %u/%x failed\n",
-					 __func__,
-					ah->ah_curchan->channel,
-					ah->ah_curchan->channelFlags);
-			}
-			sc->sc_ani.sc_caldone = iscaldone;
-		}
-	}
-
-	/*
-	* Set timer interval based on previous results.
-	* The interval must be the shortest necessary to satisfy ANI,
-	* short calibration and long calibration.
-	*/
-
-	cal_interval = ATH_ANI_POLLINTERVAL;
-	if (!sc->sc_ani.sc_caldone)
-		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
-
-	mod_timer(&sc->sc_ani.timer, jiffies + msecs_to_jiffies(cal_interval));
-}
-
-/********/
-/* Core */
-/********/
-
-int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int status;
-	int error = 0;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n",
-		__func__, sc->sc_ah->ah_opmode);
-
-	/* Reset SERDES registers */
-	ath9k_hw_configpcipowersave(ah, 0);
-
-	/*
-	 * The basic interface to setting the hardware in a good
-	 * state is ``reset''.  On return the hardware is known to
-	 * be powered up and with interrupts disabled.  This must
-	 * be followed by initialization of the appropriate bits
-	 * and then setup of the interrupt mask.
-	 */
-
-	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, initial_chan,
-			    sc->sc_ht_info.tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset hardware; hal status %u "
-			"(freq %u flags 0x%x)\n", __func__, status,
-			initial_chan->channel, initial_chan->channelFlags);
-		error = -EIO;
-		spin_unlock_bh(&sc->sc_resetlock);
-		goto done;
-	}
-	spin_unlock_bh(&sc->sc_resetlock);
-
-	/*
-	 * This is needed only to setup initial state
-	 * but it's best done after a reset.
-	 */
-	ath_update_txpow(sc);
-
-	/*
-	 * Setup the hardware after reset:
-	 * The receive engine is set going.
-	 * Frame transmit is handled entirely
-	 * in the frame output path; there's nothing to do
-	 * here except setup the interrupt mask.
-	 */
-	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to start recv logic\n", __func__);
-		error = -EIO;
-		goto done;
-	}
-
-	/* Setup our intr mask. */
-	sc->sc_imask = ATH9K_INT_RX | ATH9K_INT_TX
-		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
-		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
-
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_GTT)
-		sc->sc_imask |= ATH9K_INT_GTT;
-
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-		sc->sc_imask |= ATH9K_INT_CST;
-
-	/*
-	 * Enable MIB interrupts when there are hardware phy counters.
-	 * Note we only do this (at the moment) for station mode.
-	 */
-	if (ath9k_hw_phycounters(ah) &&
-	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
-	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
-		sc->sc_imask |= ATH9K_INT_MIB;
-	/*
-	 * Some hardware processes the TIM IE and fires an
-	 * interrupt when the TIM bit is set.  For hardware
-	 * that does, if not overridden by configuration,
-	 * enable the TIM interrupt when operating as station.
-	 */
-	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
-	    !sc->sc_config.swBeaconProcess)
-		sc->sc_imask |= ATH9K_INT_TIM;
-
-	ath_setcurmode(sc, ath_chan2mode(initial_chan));
-
-	sc->sc_flags &= ~SC_OP_INVALID;
-
-	/* Disable BMISS interrupt when we're not associated */
-	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(sc->sc_ah,sc->sc_imask);
-
-	ieee80211_wake_queues(sc->hw);
-done:
-	return error;
-}
-
-void ath_stop(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Cleaning up\n", __func__);
-
-	ieee80211_stop_queues(sc->hw);
-
-	/* make sure h/w will not generate any interrupt
-	 * before setting the invalid flag. */
-	ath9k_hw_set_interrupts(ah, 0);
-
-	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		ath_draintxq(sc, false);
-		ath_stoprecv(sc);
-		ath9k_hw_phy_disable(ah);
-	} else
-		sc->sc_rxlink = NULL;
-
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
-#endif
-	/* disable HAL and put h/w to sleep */
-	ath9k_hw_disable(sc->sc_ah);
-	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
-
-	sc->sc_flags |= SC_OP_INVALID;
-}
-
-int ath_reset(struct ath_softc *sc, bool retry_tx)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int status;
-	int error = 0;
-
-	ath9k_hw_set_interrupts(ah, 0);
-	ath_draintxq(sc, retry_tx);
-	ath_stoprecv(sc);
-	ath_flushrecv(sc);
-
-	/* Reset chip */
-	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
-			    sc->sc_ht_info.tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset hardware; hal status %u\n",
-			__func__, status);
-		error = -EIO;
-	}
-	spin_unlock_bh(&sc->sc_resetlock);
-
-	if (ath_startrecv(sc) != 0)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to start recv logic\n", __func__);
-
-	/*
-	 * We may be doing a reset in response to a request
-	 * that changes the channel so update any state that
-	 * might change as a result.
-	 */
-	ath_setcurmode(sc, ath_chan2mode(sc->sc_ah->ah_curchan));
-
-	ath_update_txpow(sc);
-
-	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
-
-	ath9k_hw_set_interrupts(ah, sc->sc_imask);
-
-	/* Restart the txq */
-	if (retry_tx) {
-		int i;
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (ATH_TXQ_SETUP(sc, i)) {
-				spin_lock_bh(&sc->sc_txq[i].axq_lock);
-				ath_txq_schedule(sc, &sc->sc_txq[i]);
-				spin_unlock_bh(&sc->sc_txq[i].axq_lock);
-			}
-		}
-	}
-
-	return error;
-}
-
-/* Interrupt handler.  Most of the actual processing is deferred.
- * It's the caller's responsibility to ensure the chip is awake. */
-
-irqreturn_t ath_isr(int irq, void *dev)
-{
-	struct ath_softc *sc = dev;
-	struct ath_hal *ah = sc->sc_ah;
-	enum ath9k_int status;
-	bool sched = false;
-
-	do {
-		if (sc->sc_flags & SC_OP_INVALID) {
-			/*
-			 * The hardware is not ready/present, don't
-			 * touch anything. Note this can happen early
-			 * on if the IRQ is shared.
-			 */
-			return IRQ_NONE;
-		}
-		if (!ath9k_hw_intrpend(ah)) {	/* shared irq, not for us */
-			return IRQ_NONE;
-		}
-
-		/*
-		 * Figure out the reason(s) for the interrupt.  Note
-		 * that the hal returns a pseudo-ISR that may include
-		 * bits we haven't explicitly enabled so we mask the
-		 * value to insure we only process bits we requested.
-		 */
-		ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
-
-		status &= sc->sc_imask;	/* discard unasked-for bits */
-
-		/*
-		 * If there are no status bits set, then this interrupt was not
-		 * for me (should have been caught above).
-		 */
-
-		if (!status)
-			return IRQ_NONE;
-
-		sc->sc_intrstatus = status;
-
-		if (status & ATH9K_INT_FATAL) {
-			/* need a chip reset */
-			sched = true;
-		} else if (status & ATH9K_INT_RXORN) {
-			/* need a chip reset */
-			sched = true;
-		} else {
-			if (status & ATH9K_INT_SWBA) {
-				/* schedule a tasklet for beacon handling */
-				tasklet_schedule(&sc->bcon_tasklet);
-			}
-			if (status & ATH9K_INT_RXEOL) {
-				/*
-				 * NB: the hardware should re-read the link when
-				 *     RXE bit is written, but it doesn't work
-				 *     at least on older hardware revs.
-				 */
-				sched = true;
-			}
-
-			if (status & ATH9K_INT_TXURN)
-				/* bump tx trigger level */
-				ath9k_hw_updatetxtriglevel(ah, true);
-			/* XXX: optimize this */
-			if (status & ATH9K_INT_RX)
-				sched = true;
-			if (status & ATH9K_INT_TX)
-				sched = true;
-			if (status & ATH9K_INT_BMISS)
-				sched = true;
-			/* carrier sense timeout */
-			if (status & ATH9K_INT_CST)
-				sched = true;
-			if (status & ATH9K_INT_MIB) {
-				/*
-				 * Disable interrupts until we service the MIB
-				 * interrupt; otherwise it will continue to
-				 * fire.
-				 */
-				ath9k_hw_set_interrupts(ah, 0);
-				/*
-				 * Let the hal handle the event. We assume
-				 * it will clear whatever condition caused
-				 * the interrupt.
-				 */
-				ath9k_hw_procmibevent(ah, &sc->sc_halstats);
-				ath9k_hw_set_interrupts(ah, sc->sc_imask);
-			}
-			if (status & ATH9K_INT_TIM_TIMER) {
-				if (!(ah->ah_caps.hw_caps &
-				      ATH9K_HW_CAP_AUTOSLEEP)) {
-					/* Clear RxAbort bit so that we can
-					 * receive frames */
-					ath9k_hw_setrxabort(ah, 0);
-					sched = true;
-				}
-			}
-		}
-	} while (0);
-
-	if (sched) {
-		/* turn off every interrupt except SWBA */
-		ath9k_hw_set_interrupts(ah, (sc->sc_imask & ATH9K_INT_SWBA));
-		tasklet_schedule(&sc->intr_tq);
-	}
-
-	return IRQ_HANDLED;
-}
-
-/* Deferred interrupt processing  */
-
-static void ath9k_tasklet(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *)data;
-	u32 status = sc->sc_intrstatus;
-
-	if (status & ATH9K_INT_FATAL) {
-		/* need a chip reset */
-		ath_reset(sc, false);
-		return;
-	} else {
-
-		if (status &
-		    (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
-			/* XXX: fill me in */
-			/*
-			if (status & ATH9K_INT_RXORN) {
-			}
-			if (status & ATH9K_INT_RXEOL) {
-			}
-			*/
-			spin_lock_bh(&sc->sc_rxflushlock);
-			ath_rx_tasklet(sc, 0);
-			spin_unlock_bh(&sc->sc_rxflushlock);
-		}
-		/* XXX: optimize this */
-		if (status & ATH9K_INT_TX)
-			ath_tx_tasklet(sc);
-		/* XXX: fill me in */
-		/*
-		if (status & ATH9K_INT_BMISS) {
-		}
-		if (status & (ATH9K_INT_TIM | ATH9K_INT_DTIMSYNC)) {
-			if (status & ATH9K_INT_TIM) {
-			}
-			if (status & ATH9K_INT_DTIMSYNC) {
-			}
-		}
-		*/
-	}
-
-	/* re-enable hardware interrupt */
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
-}
-
-int ath_init(u16 devid, struct ath_softc *sc)
-{
-	struct ath_hal *ah = NULL;
-	int status;
-	int error = 0, i;
-	int csz = 0;
-
-	/* XXX: hardware will not be ready until ath_open() being called */
-	sc->sc_flags |= SC_OP_INVALID;
-	sc->sc_debug = DBG_DEFAULT;
-
-	spin_lock_init(&sc->sc_resetlock);
-	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
-		     (unsigned long)sc);
-
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	bus_read_cachesize(sc, &csz);
-	/* XXX assert csz is non-zero */
-	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
-
-	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
-	if (ah == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to attach hardware; HAL status %u\n",
-			__func__, status);
-		error = -ENXIO;
-		goto bad;
-	}
-	sc->sc_ah = ah;
-
-	/* Get the hardware key cache size. */
-	sc->sc_keymax = ah->ah_caps.keycache_size;
-	if (sc->sc_keymax > ATH_KEYMAX) {
-		DPRINTF(sc, ATH_DBG_KEYCACHE,
-			"%s: Warning, using only %u entries in %u key cache\n",
-			__func__, ATH_KEYMAX, sc->sc_keymax);
-		sc->sc_keymax = ATH_KEYMAX;
-	}
-
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < sc->sc_keymax; i++)
-		ath9k_hw_keyreset(ah, (u16) i);
-	/*
-	 * Mark key cache slots associated with global keys
-	 * as in use.  If we knew TKIP was not to be used we
-	 * could leave the +32, +64, and +32+64 slots free.
-	 * XXX only for splitmic.
-	 */
-	for (i = 0; i < IEEE80211_WEP_NKID; i++) {
-		set_bit(i, sc->sc_keymap);
-		set_bit(i + 32, sc->sc_keymap);
-		set_bit(i + 64, sc->sc_keymap);
-		set_bit(i + 32 + 64, sc->sc_keymap);
-	}
-
-	/* Collect the channel list using the default country code */
-
-	error = ath_setup_channels(sc);
-	if (error)
-		goto bad;
-
-	/* default to MONITOR mode */
-	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
-
-	/* Setup rate tables */
-
-	ath_rate_attach(sc);
-	ath_setup_rates(sc, IEEE80211_BAND_2GHZ);
-	ath_setup_rates(sc, IEEE80211_BAND_5GHZ);
-
-	/*
-	 * Allocate hardware transmit queues: one queue for
-	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that the hal handles reseting
-	 * these queues at the needed time.
-	 */
-	sc->sc_bhalq = ath_beaconq_setup(ah);
-	if (sc->sc_bhalq == -1) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup a beacon xmit queue\n", __func__);
-		error = -EIO;
-		goto bad2;
-	}
-	sc->sc_cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
-	if (sc->sc_cabq == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup CAB xmit queue\n", __func__);
-		error = -EIO;
-		goto bad2;
-	}
-
-	sc->sc_config.cabqReadytime = ATH_CABQ_READY_TIME;
-	ath_cabq_update(sc);
-
-	for (i = 0; i < ARRAY_SIZE(sc->sc_haltype2q); i++)
-		sc->sc_haltype2q[i] = -1;
-
-	/* Setup data queues */
-	/* NB: ensure BK queue is the lowest priority h/w queue */
-	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for BK traffic\n",
-			__func__);
-		error = -EIO;
-		goto bad2;
-	}
-
-	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for BE traffic\n",
-			__func__);
-		error = -EIO;
-		goto bad2;
-	}
-	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for VI traffic\n",
-			__func__);
-		error = -EIO;
-		goto bad2;
-	}
-	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for VO traffic\n",
-			__func__);
-		error = -EIO;
-		goto bad2;
-	}
-
-	/* Initializes the noise floor to a reasonable default value.
-	 * Later on this will be updated during ANI processing. */
-
-	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
-	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
-
-	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)) {
-		/*
-		 * Whether we should enable h/w TKIP MIC.
-		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-		 * report WMM capable, so it's always safe to turn on
-		 * TKIP MIC in this case.
-		 */
-		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC,
-				       0, 1, NULL);
-	}
-
-	/*
-	 * Check whether the separate key cache entries
-	 * are required to handle both tx+rx MIC keys.
-	 * With split mic keys the number of stations is limited
-	 * to 27 otherwise 59.
-	 */
-	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				      ATH9K_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
-				      0, NULL))
-		sc->sc_splitmic = 1;
-
-	/* turn on mcast key search if possible */
-	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
-		(void)ath9k_hw_setcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 1,
-					     1, NULL);
-
-	sc->sc_config.txpowlimit = ATH_TXPOWER_MAX;
-	sc->sc_config.txpowlimit_override = 0;
-
-	/* 11n Capabilities */
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
-		sc->sc_flags |= SC_OP_TXAGGR;
-		sc->sc_flags |= SC_OP_RXAGGR;
-	}
-
-	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
-	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
-
-	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
-	sc->sc_defant = ath9k_hw_getdefantenna(ah);
-
-	ath9k_hw_getmac(ah, sc->sc_myaddr);
-	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
-		ath9k_hw_getbssidmask(ah, sc->sc_bssidmask);
-		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
-		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
-	}
-
-	sc->sc_slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
-
-	/* initialize beacon slots */
-	for (i = 0; i < ARRAY_SIZE(sc->sc_bslot); i++)
-		sc->sc_bslot[i] = ATH_IF_ID_ANY;
-
-	/* save MISC configurations */
-	sc->sc_config.swBeaconProcess = 1;
-
-#ifdef CONFIG_SLOW_ANT_DIV
-	/* range is 40 - 255, we use something in the middle */
-	ath_slow_ant_div_init(&sc->sc_antdiv, sc, 0x127);
-#endif
-
-	/* setup channels and rates */
-
-	sc->sbands[IEEE80211_BAND_2GHZ].channels =
-		sc->channels[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
-		sc->rates[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels =
-			sc->channels[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			sc->rates[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-	}
-
-	return 0;
-bad2:
-	/* cleanup tx queues */
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
-bad:
-	if (ah)
-		ath9k_hw_detach(ah);
-
-	return error;
-}
-
-/*******************/
-/* Node Management */
-/*******************/
-
-void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
-{
-	struct ath_node *an;
-
-	an = (struct ath_node *)sta->drv_priv;
-
-	if (sc->sc_flags & SC_OP_TXAGGR)
-		ath_tx_node_init(sc, an);
-
-	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-			     sta->ht_cap.ampdu_factor);
-	an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
-
-	ath_chainmask_sel_init(sc, an);
-	ath_chainmask_sel_timerstart(&an->an_chainmask_sel);
-}
-
-void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
-{
-	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-
-	ath_chainmask_sel_timerstop(&an->an_chainmask_sel);
-
-	if (sc->sc_flags & SC_OP_TXAGGR)
-		ath_tx_node_cleanup(sc, an);
-}
-
-/*
- * Set up New Node
- *
- * Setup driver-specific state for a newly associated node.  This routine
- * really only applies if compression or XR are enabled, there is no code
- * covering any other cases.
-*/
-
-void ath_newassoc(struct ath_softc *sc,
-	struct ath_node *an, int isnew, int isuapsd)
-{
-	int tidno;
-
-	/* if station reassociates, tear down the aggregation state. */
-	if (!isnew) {
-		for (tidno = 0; tidno < WME_NUM_TID; tidno++) {
-			if (sc->sc_flags & SC_OP_TXAGGR)
-				ath_tx_aggr_teardown(sc, an, tidno);
-		}
-	}
-}
-
-/**************/
-/* Encryption */
-/**************/
-
-void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot)
-{
-	ath9k_hw_keyreset(sc->sc_ah, keyix);
-	if (freeslot)
-		clear_bit(keyix, sc->sc_keymap);
-}
-
-int ath_keyset(struct ath_softc *sc,
-	       u16 keyix,
-	       struct ath9k_keyval *hk,
-	       const u8 mac[ETH_ALEN])
-{
-	bool status;
-
-	status = ath9k_hw_set_keycache_entry(sc->sc_ah,
-		keyix, hk, mac, false);
-
-	return status != false;
-}
-
-/***********************/
-/* TX Power/Regulatory */
-/***********************/
-
-/*
- *  Set Transmit power in HAL
- *
- *  This routine makes the actual HAL calls to set the new transmit power
- *  limit.
-*/
-
-void ath_update_txpow(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	u32 txpow;
-
-	if (sc->sc_curtxpow != sc->sc_config.txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, sc->sc_config.txpowlimit);
-		/* read back in case value is clamped */
-		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
-		sc->sc_curtxpow = txpow;
-	}
-}
-
-/**************************/
-/* Slow Antenna Diversity */
-/**************************/
-
-void ath_slow_ant_div_init(struct ath_antdiv *antdiv,
-			   struct ath_softc *sc,
-			   int32_t rssitrig)
-{
-	int trig;
-
-	/* antdivf_rssitrig can range from 40 - 0xff */
-	trig = (rssitrig > 0xff) ? 0xff : rssitrig;
-	trig = (rssitrig < 40) ? 40 : rssitrig;
-
-	antdiv->antdiv_sc = sc;
-	antdiv->antdivf_rssitrig = trig;
-}
-
-void ath_slow_ant_div_start(struct ath_antdiv *antdiv,
-			    u8 num_antcfg,
-			    const u8 *bssid)
-{
-	antdiv->antdiv_num_antcfg =
-		num_antcfg < ATH_ANT_DIV_MAX_CFG ?
-		num_antcfg : ATH_ANT_DIV_MAX_CFG;
-	antdiv->antdiv_state = ATH_ANT_DIV_IDLE;
-	antdiv->antdiv_curcfg = 0;
-	antdiv->antdiv_bestcfg = 0;
-	antdiv->antdiv_laststatetsf = 0;
-
-	memcpy(antdiv->antdiv_bssid, bssid, sizeof(antdiv->antdiv_bssid));
-
-	antdiv->antdiv_start = 1;
-}
-
-void ath_slow_ant_div_stop(struct ath_antdiv *antdiv)
-{
-	antdiv->antdiv_start = 0;
-}
-
-static int32_t ath_find_max_val(int32_t *val,
-	u8 num_val, u8 *max_index)
-{
-	u32 MaxVal = *val++;
-	u32 cur_index = 0;
-
-	*max_index = 0;
-	while (++cur_index < num_val) {
-		if (*val > MaxVal) {
-			MaxVal = *val;
-			*max_index = cur_index;
-		}
-
-		val++;
-	}
-
-	return MaxVal;
-}
-
-void ath_slow_ant_div(struct ath_antdiv *antdiv,
-		      struct ieee80211_hdr *hdr,
-		      struct ath_rx_status *rx_stats)
-{
-	struct ath_softc *sc = antdiv->antdiv_sc;
-	struct ath_hal *ah = sc->sc_ah;
-	u64 curtsf = 0;
-	u8 bestcfg, curcfg = antdiv->antdiv_curcfg;
-	__le16 fc = hdr->frame_control;
-
-	if (antdiv->antdiv_start && ieee80211_is_beacon(fc)
-	    && !compare_ether_addr(hdr->addr3, antdiv->antdiv_bssid)) {
-		antdiv->antdiv_lastbrssi[curcfg] = rx_stats->rs_rssi;
-		antdiv->antdiv_lastbtsf[curcfg] = ath9k_hw_gettsf64(sc->sc_ah);
-		curtsf = antdiv->antdiv_lastbtsf[curcfg];
-	} else {
-		return;
-	}
-
-	switch (antdiv->antdiv_state) {
-	case ATH_ANT_DIV_IDLE:
-		if ((antdiv->antdiv_lastbrssi[curcfg] <
-		     antdiv->antdivf_rssitrig)
-		    && ((curtsf - antdiv->antdiv_laststatetsf) >
-			ATH_ANT_DIV_MIN_IDLE_US)) {
-
-			curcfg++;
-			if (curcfg == antdiv->antdiv_num_antcfg)
-				curcfg = 0;
-
-			if (!ath9k_hw_select_antconfig(ah, curcfg)) {
-				antdiv->antdiv_bestcfg = antdiv->antdiv_curcfg;
-				antdiv->antdiv_curcfg = curcfg;
-				antdiv->antdiv_laststatetsf = curtsf;
-				antdiv->antdiv_state = ATH_ANT_DIV_SCAN;
-			}
-		}
-		break;
-
-	case ATH_ANT_DIV_SCAN:
-		if ((curtsf - antdiv->antdiv_laststatetsf) <
-		    ATH_ANT_DIV_MIN_SCAN_US)
-			break;
-
-		curcfg++;
-		if (curcfg == antdiv->antdiv_num_antcfg)
-			curcfg = 0;
-
-		if (curcfg == antdiv->antdiv_bestcfg) {
-			ath_find_max_val(antdiv->antdiv_lastbrssi,
-				   antdiv->antdiv_num_antcfg, &bestcfg);
-			if (!ath9k_hw_select_antconfig(ah, bestcfg)) {
-				antdiv->antdiv_bestcfg = bestcfg;
-				antdiv->antdiv_curcfg = bestcfg;
-				antdiv->antdiv_laststatetsf = curtsf;
-				antdiv->antdiv_state = ATH_ANT_DIV_IDLE;
-			}
-		} else {
-			if (!ath9k_hw_select_antconfig(ah, curcfg)) {
-				antdiv->antdiv_curcfg = curcfg;
-				antdiv->antdiv_laststatetsf = curtsf;
-				antdiv->antdiv_state = ATH_ANT_DIV_SCAN;
-			}
-		}
-
-		break;
-	}
-}
-
-/***********************/
-/* Descriptor Handling */
-/***********************/
-
-/*
- *  Set up DMA descriptors
- *
- *  This function will allocate both the DMA descriptor structure, and the
- *  buffers it contains.  These are used to contain the descriptors used
- *  by the system.
-*/
-
-int ath_descdma_setup(struct ath_softc *sc,
-		      struct ath_descdma *dd,
-		      struct list_head *head,
-		      const char *name,
-		      int nbuf,
-		      int ndesc)
-{
-#define	DS2PHYS(_dd, _ds)						\
-	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
-#define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
-#define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
-
-	struct ath_desc *ds;
-	struct ath_buf *bf;
-	int i, bsize, error;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA: %u buffers %u desc/buf\n",
-		__func__, name, nbuf, ndesc);
-
-	/* ath_desc must be a multiple of DWORDs */
-	if ((sizeof(struct ath_desc) % 4) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: ath_desc not DWORD aligned\n",
-			__func__);
-		ASSERT((sizeof(struct ath_desc) % 4) == 0);
-		error = -ENOMEM;
-		goto fail;
-	}
-
-	dd->dd_name = name;
-	dd->dd_desc_len = sizeof(struct ath_desc) * nbuf * ndesc;
-
-	/*
-	 * Need additional DMA memory because we can't use
-	 * descriptors that cross the 4K page boundary. Assume
-	 * one skipped descriptor per 4K page.
-	 */
-	if (!(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_4KB_SPLITTRANS)) {
-		u32 ndesc_skipped =
-			ATH_DESC_4KB_BOUND_NUM_SKIPPED(dd->dd_desc_len);
-		u32 dma_len;
-
-		while (ndesc_skipped) {
-			dma_len = ndesc_skipped * sizeof(struct ath_desc);
-			dd->dd_desc_len += dma_len;
-
-			ndesc_skipped = ATH_DESC_4KB_BOUND_NUM_SKIPPED(dma_len);
-		};
-	}
-
-	/* allocate descriptors */
-	dd->dd_desc = pci_alloc_consistent(sc->pdev,
-			      dd->dd_desc_len,
-			      &dd->dd_desc_paddr);
-	if (dd->dd_desc == NULL) {
-		error = -ENOMEM;
-		goto fail;
-	}
-	ds = dd->dd_desc;
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
-		__func__, dd->dd_name, ds, (u32) dd->dd_desc_len,
-		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
-
-	/* allocate buffers */
-	bsize = sizeof(struct ath_buf) * nbuf;
-	bf = kmalloc(bsize, GFP_KERNEL);
-	if (bf == NULL) {
-		error = -ENOMEM;
-		goto fail2;
-	}
-	memset(bf, 0, bsize);
-	dd->dd_bufptr = bf;
-
-	INIT_LIST_HEAD(head);
-	for (i = 0; i < nbuf; i++, bf++, ds += ndesc) {
-		bf->bf_desc = ds;
-		bf->bf_daddr = DS2PHYS(dd, ds);
-
-		if (!(sc->sc_ah->ah_caps.hw_caps &
-		      ATH9K_HW_CAP_4KB_SPLITTRANS)) {
-			/*
-			 * Skip descriptor addresses which can cause 4KB
-			 * boundary crossing (addr + length) with a 32 dword
-			 * descriptor fetch.
-			 */
-			while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
-				ASSERT((caddr_t) bf->bf_desc <
-				       ((caddr_t) dd->dd_desc +
-					dd->dd_desc_len));
-
-				ds += ndesc;
-				bf->bf_desc = ds;
-				bf->bf_daddr = DS2PHYS(dd, ds);
-			}
-		}
-		list_add_tail(&bf->list, head);
-	}
-	return 0;
-fail2:
-	pci_free_consistent(sc->pdev,
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
-fail:
-	memset(dd, 0, sizeof(*dd));
-	return error;
-#undef ATH_DESC_4KB_BOUND_CHECK
-#undef ATH_DESC_4KB_BOUND_NUM_SKIPPED
-#undef DS2PHYS
-}
-
-/*
- *  Cleanup DMA descriptors
- *
- *  This function will free the DMA block that was allocated for the descriptor
- *  pool.  Since this was allocated as one "chunk", it is freed in the same
- *  manner.
-*/
-
-void ath_descdma_cleanup(struct ath_softc *sc,
-			 struct ath_descdma *dd,
-			 struct list_head *head)
-{
-	/* Free memory associated with descriptors */
-	pci_free_consistent(sc->pdev,
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
-
-	INIT_LIST_HEAD(head);
-	kfree(dd->dd_bufptr);
-	memset(dd, 0, sizeof(*dd));
-}
-
-/*************/
-/* Utilities */
-/*************/
-
-int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
-{
-	int qnum;
-
-	switch (queue) {
-	case 0:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VO];
-		break;
-	case 1:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VI];
-		break;
-	case 2:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
-		break;
-	case 3:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BK];
-		break;
-	default:
-		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
-		break;
-	}
-
-	return qnum;
-}
-
-int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
-{
-	int qnum;
-
-	switch (queue) {
-	case ATH9K_WME_AC_VO:
-		qnum = 0;
-		break;
-	case ATH9K_WME_AC_VI:
-		qnum = 1;
-		break;
-	case ATH9K_WME_AC_BE:
-		qnum = 2;
-		break;
-	case ATH9K_WME_AC_BK:
-		qnum = 3;
-		break;
-	default:
-		qnum = -1;
-		break;
-	}
-
-	return qnum;
-}
-
-
-/*
- *  Expand time stamp to TSF
- *
- *  Extend 15-bit time stamp from rx descriptor to
- *  a full 64-bit TSF using the current h/w TSF.
-*/
-
-u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
-{
-	u64 tsf;
-
-	tsf = ath9k_hw_gettsf64(sc->sc_ah);
-	if ((tsf & 0x7fff) < rstamp)
-		tsf -= 0x8000;
-	return (tsf & ~0x7fff) | rstamp;
-}
-
-/*
- *  Set Default Antenna
- *
- *  Call into the HAL to set the default antenna to use.  Not really valid for
- *  MIMO technology.
-*/
-
-void ath_setdefantenna(void *context, u32 antenna)
-{
-	struct ath_softc *sc = (struct ath_softc *)context;
-	struct ath_hal *ah = sc->sc_ah;
-
-	/* XXX block beacon interrupts */
-	ath9k_hw_setantenna(ah, antenna);
-	sc->sc_defant = antenna;
-	sc->sc_rxotherant = 0;
-}
-
-/*
- * Set Slot Time
- *
- * This will wake up the chip if required, and set the slot time for the
- * frame (maximum transmit time).  Slot time is assumed to be already set
- * in the ATH object member sc_slottime
-*/
-
-void ath_setslottime(struct ath_softc *sc)
-{
-	ath9k_hw_setslottime(sc->sc_ah, sc->sc_slottime);
-	sc->sc_updateslot = OK;
-}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index e672556..21ee0c2 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -47,10 +47,6 @@
 
 struct ath_node;
 
-/******************/
-/* Utility macros */
-/******************/
-
 /* Macro to expand scalars to 64-bit objects */
 
 #define	ito64(x) (sizeof(x) == 8) ?			\
@@ -86,11 +82,6 @@ struct ath_node;
 
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->sc_txqsetup & (1<<i))
 
-static inline unsigned long get_timestamp(void)
-{
-	return ((jiffies / HZ) * 1000) + (jiffies % HZ) * (1000 / HZ);
-}
-
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 /*************/
@@ -141,34 +132,6 @@ struct ath_config {
 	u8 swBeaconProcess; /* Process received beacons in SW (vs HW) */
 };
 
-/***********************/
-/* Chainmask Selection */
-/***********************/
-
-#define ATH_CHAINMASK_SEL_TIMEOUT	   6000
-/* Default - Number of last RSSI values that is used for
- * chainmask selection */
-#define ATH_CHAINMASK_SEL_RSSI_CNT	   10
-/* Means use 3x3 chainmask instead of configured chainmask */
-#define ATH_CHAINMASK_SEL_3X3		   7
-/* Default - Rssi threshold below which we have to switch to 3x3 */
-#define ATH_CHAINMASK_SEL_UP_RSSI_THRES	   20
-/* Default - Rssi threshold above which we have to switch to
- * user configured values */
-#define ATH_CHAINMASK_SEL_DOWN_RSSI_THRES  35
-/* Struct to store the chainmask select related info */
-struct ath_chainmask_sel {
-	struct timer_list timer;
-	int cur_tx_mask; 	/* user configured or 3x3 */
-	int cur_rx_mask; 	/* user configured or 3x3 */
-	int tx_avgrssi;
-	u8 switch_allowed:1, 	/* timer will set this */
-	   cm_sel_enabled : 1;
-};
-
-int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an);
-void ath_update_chainmask(struct ath_softc *sc, int is_ht);
-
 /*************************/
 /* Descriptor Management */
 /*************************/
@@ -240,7 +203,6 @@ struct ath_buf {
 					   an aggregate) */
 	struct ath_buf *bf_lastfrm;	/* last buf of this frame */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
-	struct ath_buf *bf_rifslast;	/* last buf for RIFS burst */
 	void *bf_mpdu;			/* enclosing frame structure */
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
@@ -278,16 +240,10 @@ struct ath_descdma {
 	dma_addr_t dd_dmacontext;
 };
 
-int ath_descdma_setup(struct ath_softc *sc,
-		      struct ath_descdma *dd,
-		      struct list_head *head,
-		      const char *name,
-		      int nbuf,
-		      int ndesc);
-int ath_desc_alloc(struct ath_softc *sc);
-void ath_desc_free(struct ath_softc *sc);
-void ath_descdma_cleanup(struct ath_softc *sc,
-			 struct ath_descdma *dd,
+int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
+		      struct list_head *head, const char *name,
+		      int nbuf, int ndesc);
+void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 			 struct list_head *head);
 
 /***********/
@@ -452,7 +408,6 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 void ath_tx_tasklet(struct ath_softc *sc);
 u32 ath_txq_depth(struct ath_softc *sc, int qnum);
 u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
-void ath_notify_txq_status(struct ath_softc *sc, u16 queue_depth);
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 
 /**********************/
@@ -517,25 +472,18 @@ struct ath_node_aggr {
 /* driver-specific node state */
 struct ath_node {
 	struct ath_softc *an_sc;
-	struct ath_chainmask_sel an_chainmask_sel;
 	struct ath_node_aggr an_aggr;
 	u16 maxampdu;
 	u8 mpdudensity;
 };
 
-void ath_tx_resume_tid(struct ath_softc *sc,
-	struct ath_atx_tid *tid);
+void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-void ath_tx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u8 tidno);
+void ath_tx_aggr_teardown(struct ath_softc *sc,	struct ath_node *an, u8 tidno);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
-void ath_newassoc(struct ath_softc *sc,
-	struct ath_node *node, int isnew, int isuapsd);
-void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta);
-void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta);
 
 /********/
 /* VAPs */
@@ -593,49 +541,8 @@ void ath9k_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hal *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
-void ath_bstuck_process(struct ath_softc *sc);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp);
 void ath_beacon_sync(struct ath_softc *sc, int if_id);
-void ath_get_beaconconfig(struct ath_softc *sc,
-			  int if_id,
-			  struct ath_beacon_config *conf);
-/*********************/
-/* Antenna diversity */
-/*********************/
-
-#define ATH_ANT_DIV_MAX_CFG      2
-#define ATH_ANT_DIV_MIN_IDLE_US  1000000  /* us */
-#define ATH_ANT_DIV_MIN_SCAN_US  50000	  /* us */
-
-enum ATH_ANT_DIV_STATE{
-	ATH_ANT_DIV_IDLE,
-	ATH_ANT_DIV_SCAN,	/* evaluating antenna */
-};
-
-struct ath_antdiv {
-	struct ath_softc *antdiv_sc;
-	u8 antdiv_start;
-	enum ATH_ANT_DIV_STATE antdiv_state;
-	u8 antdiv_num_antcfg;
-	u8 antdiv_curcfg;
-	u8 antdiv_bestcfg;
-	int32_t antdivf_rssitrig;
-	int32_t antdiv_lastbrssi[ATH_ANT_DIV_MAX_CFG];
-	u64 antdiv_lastbtsf[ATH_ANT_DIV_MAX_CFG];
-	u64 antdiv_laststatetsf;
-	u8 antdiv_bssid[ETH_ALEN];
-};
-
-void ath_slow_ant_div_init(struct ath_antdiv *antdiv,
-	struct ath_softc *sc, int32_t rssitrig);
-void ath_slow_ant_div_start(struct ath_antdiv *antdiv,
-			    u8 num_antcfg,
-			    const u8 *bssid);
-void ath_slow_ant_div_stop(struct ath_antdiv *antdiv);
-void ath_slow_ant_div(struct ath_antdiv *antdiv,
-		      struct ieee80211_hdr *wh,
-		      struct ath_rx_status *rx_stats);
-void ath_setdefantenna(void *sc, u32 antenna);
 
 /*******/
 /* ANI */
@@ -717,30 +624,8 @@ struct ath_rfkill {
 
 #define ATH_IF_ID_ANY   	0xff
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
-
-#define RSSI_LPF_THRESHOLD         -20
-#define ATH_RSSI_EP_MULTIPLIER     (1<<7)  /* pow2 to optimize out * and / */
-#define ATH_RATE_DUMMY_MARKER      0
-#define ATH_RSSI_LPF_LEN           10
-#define ATH_RSSI_DUMMY_MARKER      0x127
-
-#define ATH_EP_MUL(x, mul)         ((x) * (mul))
-#define ATH_EP_RND(x, mul)						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-#define ATH_RSSI_OUT(x)							\
-	(((x) != ATH_RSSI_DUMMY_MARKER) ?				\
-	 (ATH_EP_RND((x), ATH_RSSI_EP_MULTIPLIER)) : ATH_RSSI_DUMMY_MARKER)
-#define ATH_RSSI_IN(x)					\
-	(ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
-#define ATH_LPF_RSSI(x, y, len)						\
-	((x != ATH_RSSI_DUMMY_MARKER) ? \
-		(((x) * ((len) - 1) + (y)) / (len)) : (y))
-#define ATH_RSSI_LPF(x, y) do {						\
-		if ((y) >= RSSI_LPF_THRESHOLD)				\
-			x = ATH_LPF_RSSI((x), \
-				ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN); \
-	} while (0)
-
+#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RATE_DUMMY_MARKER   0
 
 enum PROT_MODE {
 	PROT_M_NONE = 0,
@@ -748,12 +633,6 @@ enum PROT_MODE {
 	PROT_M_CTSONLY
 };
 
-enum RATE_TYPE {
-	NORMAL_RATE = 0,
-	HALF_RATE,
-	QUARTER_RATE
-};
-
 struct ath_ht_info {
 	enum ath9k_ht_macmode tx_chan_width;
 	u8 ext_chan_offset;
@@ -881,27 +760,9 @@ struct ath_softc {
 	struct ath_ani sc_ani;
 };
 
-int ath_init(u16 devid, struct ath_softc *sc);
-int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
-void ath_stop(struct ath_softc *sc);
-irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
-int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
-
-/*********************/
-/* Utility Functions */
-/*********************/
-
-void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot);
-int ath_keyset(struct ath_softc *sc,
-	       u16 keyix,
-	       struct ath9k_keyval *hk,
-	       const u8 mac[ETH_ALEN]);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
-void ath_setslottime(struct ath_softc *sc);
-void ath_update_txpow(struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
-u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 27be0d9..8eccc20 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -14,8 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/* mac80211 and PCI callbacks */
-
 #include <linux/nl80211.h>
 #include "core.h"
 #include "reg.h"
@@ -40,6 +38,580 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 
 static void ath_detach(struct ath_softc *sc);
 
+/* return bus cachesize in 4B word units */
+
+static void bus_read_cachesize(struct ath_softc *sc, int *csz)
+{
+	u8 u8tmp;
+
+	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u8 *)&u8tmp);
+	*csz = (int)u8tmp;
+
+	/*
+	 * This check was put in to avoid "unplesant" consequences if
+	 * the bootrom has not fully initialized all PCI devices.
+	 * Sometimes the cache line size register is not set
+	 */
+
+	if (*csz == 0)
+		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
+}
+
+static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
+{
+	sc->sc_curmode = mode;
+	/*
+	 * All protection frames are transmited at 2Mb/s for
+	 * 11g, otherwise at 1Mb/s.
+	 * XXX select protection rate index from rate table.
+	 */
+	sc->sc_protrix = (mode == ATH9K_MODE_11G ? 1 : 0);
+}
+
+static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
+{
+	if (chan->chanmode == CHANNEL_A)
+		return ATH9K_MODE_11A;
+	else if (chan->chanmode == CHANNEL_G)
+		return ATH9K_MODE_11G;
+	else if (chan->chanmode == CHANNEL_B)
+		return ATH9K_MODE_11B;
+	else if (chan->chanmode == CHANNEL_A_HT20)
+		return ATH9K_MODE_11NA_HT20;
+	else if (chan->chanmode == CHANNEL_G_HT20)
+		return ATH9K_MODE_11NG_HT20;
+	else if (chan->chanmode == CHANNEL_A_HT40PLUS)
+		return ATH9K_MODE_11NA_HT40PLUS;
+	else if (chan->chanmode == CHANNEL_A_HT40MINUS)
+		return ATH9K_MODE_11NA_HT40MINUS;
+	else if (chan->chanmode == CHANNEL_G_HT40PLUS)
+		return ATH9K_MODE_11NG_HT40PLUS;
+	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
+		return ATH9K_MODE_11NG_HT40MINUS;
+
+	WARN_ON(1); /* should not get here */
+
+	return ATH9K_MODE_11B;
+}
+
+static void ath_update_txpow(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	u32 txpow;
+
+	if (sc->sc_curtxpow != sc->sc_config.txpowlimit) {
+		ath9k_hw_set_txpowerlimit(ah, sc->sc_config.txpowlimit);
+		/* read back in case value is clamped */
+		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
+		sc->sc_curtxpow = txpow;
+	}
+}
+
+static u8 parse_mpdudensity(u8 mpdudensity)
+{
+	/*
+	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
+	 *   0 for no restriction
+	 *   1 for 1/4 us
+	 *   2 for 1/2 us
+	 *   3 for 1 us
+	 *   4 for 2 us
+	 *   5 for 4 us
+	 *   6 for 8 us
+	 *   7 for 16 us
+	 */
+	switch (mpdudensity) {
+	case 0:
+		return 0;
+	case 1:
+	case 2:
+	case 3:
+		/* Our lower layer calculations limit our precision to
+		   1 microsecond */
+		return 1;
+	case 4:
+		return 2;
+	case 5:
+		return 4;
+	case 6:
+		return 8;
+	case 7:
+		return 16;
+	default:
+		return 0;
+	}
+}
+
+static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
+{
+	struct ath_rate_table *rate_table = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate;
+	int i, maxrates;
+
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
+		rate_table = sc->hw_rate_table[ATH9K_MODE_11G];
+		break;
+	case IEEE80211_BAND_5GHZ:
+		rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
+		break;
+	default:
+		break;
+	}
+
+	if (rate_table == NULL)
+		return;
+
+	sband = &sc->sbands[band];
+	rate = sc->rates[band];
+
+	if (rate_table->rate_cnt > ATH_RATE_MAX)
+		maxrates = ATH_RATE_MAX;
+	else
+		maxrates = rate_table->rate_cnt;
+
+	for (i = 0; i < maxrates; i++) {
+		rate[i].bitrate = rate_table->info[i].ratekbps / 100;
+		rate[i].hw_value = rate_table->info[i].ratecode;
+		sband->n_bitrates++;
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Rate: %2dMbps, ratecode: %2d\n",
+			__func__, rate[i].bitrate / 10,	rate[i].hw_value);
+	}
+}
+
+static int ath_setup_channels(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	int nchan, i, a = 0, b = 0;
+	u8 regclassids[ATH_REGCLASSIDS_MAX];
+	u32 nregclass = 0;
+	struct ieee80211_supported_band *band_2ghz;
+	struct ieee80211_supported_band *band_5ghz;
+	struct ieee80211_channel *chan_2ghz;
+	struct ieee80211_channel *chan_5ghz;
+	struct ath9k_channel *c;
+
+	/* Fill in ah->ah_channels */
+	if (!ath9k_regd_init_channels(ah, ATH_CHAN_MAX, (u32 *)&nchan,
+				      regclassids, ATH_REGCLASSIDS_MAX,
+				      &nregclass, CTRY_DEFAULT, false, 1)) {
+		u32 rd = ah->ah_currentRD;
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to collect channel list; "
+			"regdomain likely %u country code %u\n",
+			__func__, rd, CTRY_DEFAULT);
+		return -EINVAL;
+	}
+
+	band_2ghz = &sc->sbands[IEEE80211_BAND_2GHZ];
+	band_5ghz = &sc->sbands[IEEE80211_BAND_5GHZ];
+	chan_2ghz = sc->channels[IEEE80211_BAND_2GHZ];
+	chan_5ghz = sc->channels[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < nchan; i++) {
+		c = &ah->ah_channels[i];
+		if (IS_CHAN_2GHZ(c)) {
+			chan_2ghz[a].band = IEEE80211_BAND_2GHZ;
+			chan_2ghz[a].center_freq = c->channel;
+			chan_2ghz[a].max_power = c->maxTxPower;
+
+			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
+				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
+			if (c->channelFlags & CHANNEL_PASSIVE)
+				chan_2ghz[a].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
+			band_2ghz->n_channels = ++a;
+
+			DPRINTF(sc, ATH_DBG_CONFIG, "%s: 2MHz channel: %d, "
+				"channelFlags: 0x%x\n",
+				__func__, c->channel, c->channelFlags);
+		} else if (IS_CHAN_5GHZ(c)) {
+			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
+			chan_5ghz[b].center_freq = c->channel;
+			chan_5ghz[b].max_power = c->maxTxPower;
+
+			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
+				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
+			if (c->channelFlags & CHANNEL_PASSIVE)
+				chan_5ghz[b].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
+			band_5ghz->n_channels = ++b;
+
+			DPRINTF(sc, ATH_DBG_CONFIG, "%s: 5MHz channel: %d, "
+				"channelFlags: 0x%x\n",
+				__func__, c->channel, c->channelFlags);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Set/change channels.  If the channel is really being changed, it's done
+ * by reseting the chip.  To accomplish this we must first cleanup any pending
+ * DMA, then restart stuff.
+*/
+static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	bool fastcc = true, stopped;
+
+	if (sc->sc_flags & SC_OP_INVALID)
+		return -EIO;
+
+	DPRINTF(sc, ATH_DBG_CONFIG,
+		"%s: %u (%u MHz) -> %u (%u MHz), cflags:%x\n",
+		__func__,
+		ath9k_hw_mhz2ieee(ah, sc->sc_ah->ah_curchan->channel,
+				  sc->sc_ah->ah_curchan->channelFlags),
+		sc->sc_ah->ah_curchan->channel,
+		ath9k_hw_mhz2ieee(ah, hchan->channel, hchan->channelFlags),
+		hchan->channel, hchan->channelFlags);
+
+	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
+	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
+	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
+	    (sc->sc_flags & SC_OP_FULL_RESET)) {
+		int status;
+		/*
+		 * This is only performed if the channel settings have
+		 * actually changed.
+		 *
+		 * To switch channels clear any pending DMA operations;
+		 * wait long enough for the RX fifo to drain, reset the
+		 * hardware at the new frequency, and then re-enable
+		 * the relevant bits of the h/w.
+		 */
+		ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
+		ath_draintxq(sc, false);	/* clear pending tx frames */
+		stopped = ath_stoprecv(sc);	/* turn off frame recv */
+
+		/* XXX: do not flush receive queue here. We don't want
+		 * to flush data frames already in queue because of
+		 * changing channel. */
+
+		if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
+			fastcc = false;
+
+		spin_lock_bh(&sc->sc_resetlock);
+		if (!ath9k_hw_reset(ah, hchan, sc->sc_ht_info.tx_chan_width,
+				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+				    sc->sc_ht_extprotspacing, fastcc, &status)) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: unable to reset channel %u (%uMhz) "
+				"flags 0x%x hal status %u\n", __func__,
+				ath9k_hw_mhz2ieee(ah, hchan->channel,
+						  hchan->channelFlags),
+				hchan->channel, hchan->channelFlags, status);
+			spin_unlock_bh(&sc->sc_resetlock);
+			return -EIO;
+		}
+		spin_unlock_bh(&sc->sc_resetlock);
+
+		sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
+		sc->sc_flags &= ~SC_OP_FULL_RESET;
+
+		if (ath_startrecv(sc) != 0) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: unable to restart recv logic\n", __func__);
+			return -EIO;
+		}
+
+		ath_setcurmode(sc, ath_chan2mode(hchan));
+		ath_update_txpow(sc);
+		ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	}
+	return 0;
+}
+
+/*
+ *  This routine performs the periodic noise floor calibration function
+ *  that is used to adjust and optimize the chip performance.  This
+ *  takes environmental changes (location, temperature) into account.
+ *  When the task is complete, it reschedules itself depending on the
+ *  appropriate interval that was calculated.
+ */
+static void ath_ani_calibrate(unsigned long data)
+{
+	struct ath_softc *sc;
+	struct ath_hal *ah;
+	bool longcal = false;
+	bool shortcal = false;
+	bool aniflag = false;
+	unsigned int timestamp = jiffies_to_msecs(jiffies);
+	u32 cal_interval;
+
+	sc = (struct ath_softc *)data;
+	ah = sc->sc_ah;
+
+	/*
+	* don't calibrate when we're scanning.
+	* we are most likely not on our home channel.
+	*/
+	if (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)
+		return;
+
+	/* Long calibration runs independently of short calibration. */
+	if ((timestamp - sc->sc_ani.sc_longcal_timer) >= ATH_LONG_CALINTERVAL) {
+		longcal = true;
+		DPRINTF(sc, ATH_DBG_ANI, "%s: longcal @%lu\n",
+			__func__, jiffies);
+		sc->sc_ani.sc_longcal_timer = timestamp;
+	}
+
+	/* Short calibration applies only while sc_caldone is false */
+	if (!sc->sc_ani.sc_caldone) {
+		if ((timestamp - sc->sc_ani.sc_shortcal_timer) >=
+		    ATH_SHORT_CALINTERVAL) {
+			shortcal = true;
+			DPRINTF(sc, ATH_DBG_ANI, "%s: shortcal @%lu\n",
+			       __func__, jiffies);
+			sc->sc_ani.sc_shortcal_timer = timestamp;
+			sc->sc_ani.sc_resetcal_timer = timestamp;
+		}
+	} else {
+		if ((timestamp - sc->sc_ani.sc_resetcal_timer) >=
+		    ATH_RESTART_CALINTERVAL) {
+			ath9k_hw_reset_calvalid(ah, ah->ah_curchan,
+						&sc->sc_ani.sc_caldone);
+			if (sc->sc_ani.sc_caldone)
+				sc->sc_ani.sc_resetcal_timer = timestamp;
+		}
+	}
+
+	/* Verify whether we must check ANI */
+	if ((timestamp - sc->sc_ani.sc_checkani_timer) >=
+	   ATH_ANI_POLLINTERVAL) {
+		aniflag = true;
+		sc->sc_ani.sc_checkani_timer = timestamp;
+	}
+
+	/* Skip all processing if there's nothing to do. */
+	if (longcal || shortcal || aniflag) {
+		/* Call ANI routine if necessary */
+		if (aniflag)
+			ath9k_hw_ani_monitor(ah, &sc->sc_halstats,
+					     ah->ah_curchan);
+
+		/* Perform calibration if necessary */
+		if (longcal || shortcal) {
+			bool iscaldone = false;
+
+			if (ath9k_hw_calibrate(ah, ah->ah_curchan,
+					       sc->sc_rx_chainmask, longcal,
+					       &iscaldone)) {
+				if (longcal)
+					sc->sc_ani.sc_noise_floor =
+						ath9k_hw_getchan_noise(ah,
+							       ah->ah_curchan);
+
+				DPRINTF(sc, ATH_DBG_ANI,
+					"%s: calibrate chan %u/%x nf: %d\n",
+					 __func__,
+					ah->ah_curchan->channel,
+					ah->ah_curchan->channelFlags,
+					sc->sc_ani.sc_noise_floor);
+			} else {
+				DPRINTF(sc, ATH_DBG_ANY,
+					"%s: calibrate chan %u/%x failed\n",
+					 __func__,
+					ah->ah_curchan->channel,
+					ah->ah_curchan->channelFlags);
+			}
+			sc->sc_ani.sc_caldone = iscaldone;
+		}
+	}
+
+	/*
+	* Set timer interval based on previous results.
+	* The interval must be the shortest necessary to satisfy ANI,
+	* short calibration and long calibration.
+	*/
+
+	cal_interval = ATH_ANI_POLLINTERVAL;
+	if (!sc->sc_ani.sc_caldone)
+		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
+
+	mod_timer(&sc->sc_ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+}
+
+/*
+ * Update tx/rx chainmask. For legacy association,
+ * hard code chainmask to 1x1, for 11n association, use
+ * the chainmask configuration.
+ */
+static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
+{
+	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
+	if (is_ht) {
+		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
+		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
+	} else {
+		sc->sc_tx_chainmask = 1;
+		sc->sc_rx_chainmask = 1;
+	}
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: tx chmask: %d, rx chmask: %d\n",
+		__func__, sc->sc_tx_chainmask, sc->sc_rx_chainmask);
+}
+
+static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
+{
+	struct ath_node *an;
+
+	an = (struct ath_node *)sta->drv_priv;
+
+	if (sc->sc_flags & SC_OP_TXAGGR)
+		ath_tx_node_init(sc, an);
+
+	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+			     sta->ht_cap.ampdu_factor);
+	an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+}
+
+static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
+{
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+
+	if (sc->sc_flags & SC_OP_TXAGGR)
+		ath_tx_node_cleanup(sc, an);
+}
+
+static void ath9k_tasklet(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *)data;
+	u32 status = sc->sc_intrstatus;
+
+	if (status & ATH9K_INT_FATAL) {
+		/* need a chip reset */
+		ath_reset(sc, false);
+		return;
+	} else {
+
+		if (status &
+		    (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
+			spin_lock_bh(&sc->sc_rxflushlock);
+			ath_rx_tasklet(sc, 0);
+			spin_unlock_bh(&sc->sc_rxflushlock);
+		}
+		/* XXX: optimize this */
+		if (status & ATH9K_INT_TX)
+			ath_tx_tasklet(sc);
+	}
+
+	/* re-enable hardware interrupt */
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+}
+
+static irqreturn_t ath_isr(int irq, void *dev)
+{
+	struct ath_softc *sc = dev;
+	struct ath_hal *ah = sc->sc_ah;
+	enum ath9k_int status;
+	bool sched = false;
+
+	do {
+		if (sc->sc_flags & SC_OP_INVALID) {
+			/*
+			 * The hardware is not ready/present, don't
+			 * touch anything. Note this can happen early
+			 * on if the IRQ is shared.
+			 */
+			return IRQ_NONE;
+		}
+		if (!ath9k_hw_intrpend(ah)) {	/* shared irq, not for us */
+			return IRQ_NONE;
+		}
+
+		/*
+		 * Figure out the reason(s) for the interrupt.  Note
+		 * that the hal returns a pseudo-ISR that may include
+		 * bits we haven't explicitly enabled so we mask the
+		 * value to insure we only process bits we requested.
+		 */
+		ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
+
+		status &= sc->sc_imask;	/* discard unasked-for bits */
+
+		/*
+		 * If there are no status bits set, then this interrupt was not
+		 * for me (should have been caught above).
+		 */
+		if (!status)
+			return IRQ_NONE;
+
+		sc->sc_intrstatus = status;
+
+		if (status & ATH9K_INT_FATAL) {
+			/* need a chip reset */
+			sched = true;
+		} else if (status & ATH9K_INT_RXORN) {
+			/* need a chip reset */
+			sched = true;
+		} else {
+			if (status & ATH9K_INT_SWBA) {
+				/* schedule a tasklet for beacon handling */
+				tasklet_schedule(&sc->bcon_tasklet);
+			}
+			if (status & ATH9K_INT_RXEOL) {
+				/*
+				 * NB: the hardware should re-read the link when
+				 *     RXE bit is written, but it doesn't work
+				 *     at least on older hardware revs.
+				 */
+				sched = true;
+			}
+
+			if (status & ATH9K_INT_TXURN)
+				/* bump tx trigger level */
+				ath9k_hw_updatetxtriglevel(ah, true);
+			/* XXX: optimize this */
+			if (status & ATH9K_INT_RX)
+				sched = true;
+			if (status & ATH9K_INT_TX)
+				sched = true;
+			if (status & ATH9K_INT_BMISS)
+				sched = true;
+			/* carrier sense timeout */
+			if (status & ATH9K_INT_CST)
+				sched = true;
+			if (status & ATH9K_INT_MIB) {
+				/*
+				 * Disable interrupts until we service the MIB
+				 * interrupt; otherwise it will continue to
+				 * fire.
+				 */
+				ath9k_hw_set_interrupts(ah, 0);
+				/*
+				 * Let the hal handle the event. We assume
+				 * it will clear whatever condition caused
+				 * the interrupt.
+				 */
+				ath9k_hw_procmibevent(ah, &sc->sc_halstats);
+				ath9k_hw_set_interrupts(ah, sc->sc_imask);
+			}
+			if (status & ATH9K_INT_TIM_TIMER) {
+				if (!(ah->ah_caps.hw_caps &
+				      ATH9K_HW_CAP_AUTOSLEEP)) {
+					/* Clear RxAbort bit so that we can
+					 * receive frames */
+					ath9k_hw_setrxabort(ah, 0);
+					sched = true;
+				}
+			}
+		}
+	} while (0);
+
+	if (sched) {
+		/* turn off every interrupt except SWBA */
+		ath9k_hw_set_interrupts(ah, (sc->sc_imask & ATH9K_INT_SWBA));
+		tasklet_schedule(&sc->intr_tq);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int ath_get_channel(struct ath_softc *sc,
 			   struct ieee80211_channel *chan)
 {
@@ -90,6 +662,23 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
 	return chanmode;
 }
 
+static void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot)
+{
+	ath9k_hw_keyreset(sc->sc_ah, keyix);
+	if (freeslot)
+		clear_bit(keyix, sc->sc_keymap);
+}
+
+static int ath_keyset(struct ath_softc *sc, u16 keyix,
+	       struct ath9k_keyval *hk, const u8 mac[ETH_ALEN])
+{
+	bool status;
+
+	status = ath9k_hw_set_keycache_entry(sc->sc_ah,
+		keyix, hk, mac, false);
+
+	return status != false;
+}
 
 static int ath_setkey_tkip(struct ath_softc *sc,
 			   struct ieee80211_key_conf *key,
@@ -328,20 +917,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	}
 }
 
-void ath_get_beaconconfig(struct ath_softc *sc,
-			  int if_id,
-			  struct ath_beacon_config *conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	/* fill in beacon config data */
-
-	conf->beacon_interval = hw->conf.beacon_int;
-	conf->listen_interval = 100;
-	conf->dtim_count = 1;
-	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
-}
-
 /********************************/
 /*	 LED functions		*/
 /********************************/
@@ -723,6 +1298,244 @@ static void ath_detach(struct ath_softc *sc)
 	ath9k_hw_detach(sc->sc_ah);
 }
 
+static int ath_init(u16 devid, struct ath_softc *sc)
+{
+	struct ath_hal *ah = NULL;
+	int status;
+	int error = 0, i;
+	int csz = 0;
+
+	/* XXX: hardware will not be ready until ath_open() being called */
+	sc->sc_flags |= SC_OP_INVALID;
+	sc->sc_debug = DBG_DEFAULT;
+
+	spin_lock_init(&sc->sc_resetlock);
+	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
+	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
+		     (unsigned long)sc);
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	bus_read_cachesize(sc, &csz);
+	/* XXX assert csz is non-zero */
+	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
+
+	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
+	if (ah == NULL) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to attach hardware; HAL status %u\n",
+			__func__, status);
+		error = -ENXIO;
+		goto bad;
+	}
+	sc->sc_ah = ah;
+
+	/* Get the hardware key cache size. */
+	sc->sc_keymax = ah->ah_caps.keycache_size;
+	if (sc->sc_keymax > ATH_KEYMAX) {
+		DPRINTF(sc, ATH_DBG_KEYCACHE,
+			"%s: Warning, using only %u entries in %u key cache\n",
+			__func__, ATH_KEYMAX, sc->sc_keymax);
+		sc->sc_keymax = ATH_KEYMAX;
+	}
+
+	/*
+	 * Reset the key cache since some parts do not
+	 * reset the contents on initial power up.
+	 */
+	for (i = 0; i < sc->sc_keymax; i++)
+		ath9k_hw_keyreset(ah, (u16) i);
+	/*
+	 * Mark key cache slots associated with global keys
+	 * as in use.  If we knew TKIP was not to be used we
+	 * could leave the +32, +64, and +32+64 slots free.
+	 * XXX only for splitmic.
+	 */
+	for (i = 0; i < IEEE80211_WEP_NKID; i++) {
+		set_bit(i, sc->sc_keymap);
+		set_bit(i + 32, sc->sc_keymap);
+		set_bit(i + 64, sc->sc_keymap);
+		set_bit(i + 32 + 64, sc->sc_keymap);
+	}
+
+	/* Collect the channel list using the default country code */
+
+	error = ath_setup_channels(sc);
+	if (error)
+		goto bad;
+
+	/* default to MONITOR mode */
+	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
+
+	/* Setup rate tables */
+
+	ath_rate_attach(sc);
+	ath_setup_rates(sc, IEEE80211_BAND_2GHZ);
+	ath_setup_rates(sc, IEEE80211_BAND_5GHZ);
+
+	/*
+	 * Allocate hardware transmit queues: one queue for
+	 * beacon frames and one data queue for each QoS
+	 * priority.  Note that the hal handles reseting
+	 * these queues at the needed time.
+	 */
+	sc->sc_bhalq = ath_beaconq_setup(ah);
+	if (sc->sc_bhalq == -1) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup a beacon xmit queue\n", __func__);
+		error = -EIO;
+		goto bad2;
+	}
+	sc->sc_cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
+	if (sc->sc_cabq == NULL) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup CAB xmit queue\n", __func__);
+		error = -EIO;
+		goto bad2;
+	}
+
+	sc->sc_config.cabqReadytime = ATH_CABQ_READY_TIME;
+	ath_cabq_update(sc);
+
+	for (i = 0; i < ARRAY_SIZE(sc->sc_haltype2q); i++)
+		sc->sc_haltype2q[i] = -1;
+
+	/* Setup data queues */
+	/* NB: ensure BK queue is the lowest priority h/w queue */
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup xmit queue for BK traffic\n",
+			__func__);
+		error = -EIO;
+		goto bad2;
+	}
+
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup xmit queue for BE traffic\n",
+			__func__);
+		error = -EIO;
+		goto bad2;
+	}
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup xmit queue for VI traffic\n",
+			__func__);
+		error = -EIO;
+		goto bad2;
+	}
+	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to setup xmit queue for VO traffic\n",
+			__func__);
+		error = -EIO;
+		goto bad2;
+	}
+
+	/* Initializes the noise floor to a reasonable default value.
+	 * Later on this will be updated during ANI processing. */
+
+	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
+
+	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)) {
+		/*
+		 * Whether we should enable h/w TKIP MIC.
+		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
+		 * report WMM capable, so it's always safe to turn on
+		 * TKIP MIC in this case.
+		 */
+		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC,
+				       0, 1, NULL);
+	}
+
+	/*
+	 * Check whether the separate key cache entries
+	 * are required to handle both tx+rx MIC keys.
+	 * With split mic keys the number of stations is limited
+	 * to 27 otherwise 59.
+	 */
+	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)
+	    && ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
+				      ATH9K_CIPHER_MIC, NULL)
+	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
+				      0, NULL))
+		sc->sc_splitmic = 1;
+
+	/* turn on mcast key search if possible */
+	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
+		(void)ath9k_hw_setcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 1,
+					     1, NULL);
+
+	sc->sc_config.txpowlimit = ATH_TXPOWER_MAX;
+	sc->sc_config.txpowlimit_override = 0;
+
+	/* 11n Capabilities */
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
+		sc->sc_flags |= SC_OP_TXAGGR;
+		sc->sc_flags |= SC_OP_RXAGGR;
+	}
+
+	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
+	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
+
+	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
+	sc->sc_defant = ath9k_hw_getdefantenna(ah);
+
+	ath9k_hw_getmac(ah, sc->sc_myaddr);
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
+		ath9k_hw_getbssidmask(ah, sc->sc_bssidmask);
+		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
+		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
+	}
+
+	sc->sc_slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
+
+	/* initialize beacon slots */
+	for (i = 0; i < ARRAY_SIZE(sc->sc_bslot); i++)
+		sc->sc_bslot[i] = ATH_IF_ID_ANY;
+
+	/* save MISC configurations */
+	sc->sc_config.swBeaconProcess = 1;
+
+#ifdef CONFIG_SLOW_ANT_DIV
+	/* range is 40 - 255, we use something in the middle */
+	ath_slow_ant_div_init(&sc->sc_antdiv, sc, 0x127);
+#endif
+
+	/* setup channels and rates */
+
+	sc->sbands[IEEE80211_BAND_2GHZ].channels =
+		sc->channels[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
+		sc->rates[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_5GHZ].channels =
+			sc->channels[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			sc->rates[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
+	}
+
+	return 0;
+bad2:
+	/* cleanup tx queues */
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
+bad:
+	if (ah)
+		ath9k_hw_detach(ah);
+
+	return error;
+}
+
 static int ath_attach(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -811,11 +1624,243 @@ bad:
 	return error;
 }
 
+int ath_reset(struct ath_softc *sc, bool retry_tx)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	int status;
+	int error = 0;
+
+	ath9k_hw_set_interrupts(ah, 0);
+	ath_draintxq(sc, retry_tx);
+	ath_stoprecv(sc);
+	ath_flushrecv(sc);
+
+	spin_lock_bh(&sc->sc_resetlock);
+	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing, false, &status)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to reset hardware; hal status %u\n",
+			__func__, status);
+		error = -EIO;
+	}
+	spin_unlock_bh(&sc->sc_resetlock);
+
+	if (ath_startrecv(sc) != 0)
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to start recv logic\n", __func__);
+
+	/*
+	 * We may be doing a reset in response to a request
+	 * that changes the channel so update any state that
+	 * might change as a result.
+	 */
+	ath_setcurmode(sc, ath_chan2mode(sc->sc_ah->ah_curchan));
+
+	ath_update_txpow(sc);
+
+	if (sc->sc_flags & SC_OP_BEACONS)
+		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
+
+	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+
+	if (retry_tx) {
+		int i;
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (ATH_TXQ_SETUP(sc, i)) {
+				spin_lock_bh(&sc->sc_txq[i].axq_lock);
+				ath_txq_schedule(sc, &sc->sc_txq[i]);
+				spin_unlock_bh(&sc->sc_txq[i].axq_lock);
+			}
+		}
+	}
+
+	return error;
+}
+
+/*
+ *  This function will allocate both the DMA descriptor structure, and the
+ *  buffers it contains.  These are used to contain the descriptors used
+ *  by the system.
+*/
+int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
+		      struct list_head *head, const char *name,
+		      int nbuf, int ndesc)
+{
+#define	DS2PHYS(_dd, _ds)						\
+	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
+#define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
+#define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
+
+	struct ath_desc *ds;
+	struct ath_buf *bf;
+	int i, bsize, error;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA: %u buffers %u desc/buf\n",
+		__func__, name, nbuf, ndesc);
+
+	/* ath_desc must be a multiple of DWORDs */
+	if ((sizeof(struct ath_desc) % 4) != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL, "%s: ath_desc not DWORD aligned\n",
+			__func__);
+		ASSERT((sizeof(struct ath_desc) % 4) == 0);
+		error = -ENOMEM;
+		goto fail;
+	}
+
+	dd->dd_name = name;
+	dd->dd_desc_len = sizeof(struct ath_desc) * nbuf * ndesc;
+
+	/*
+	 * Need additional DMA memory because we can't use
+	 * descriptors that cross the 4K page boundary. Assume
+	 * one skipped descriptor per 4K page.
+	 */
+	if (!(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_4KB_SPLITTRANS)) {
+		u32 ndesc_skipped =
+			ATH_DESC_4KB_BOUND_NUM_SKIPPED(dd->dd_desc_len);
+		u32 dma_len;
+
+		while (ndesc_skipped) {
+			dma_len = ndesc_skipped * sizeof(struct ath_desc);
+			dd->dd_desc_len += dma_len;
+
+			ndesc_skipped = ATH_DESC_4KB_BOUND_NUM_SKIPPED(dma_len);
+		};
+	}
+
+	/* allocate descriptors */
+	dd->dd_desc = pci_alloc_consistent(sc->pdev,
+			      dd->dd_desc_len,
+			      &dd->dd_desc_paddr);
+	if (dd->dd_desc == NULL) {
+		error = -ENOMEM;
+		goto fail;
+	}
+	ds = dd->dd_desc;
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
+		__func__, dd->dd_name, ds, (u32) dd->dd_desc_len,
+		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
+
+	/* allocate buffers */
+	bsize = sizeof(struct ath_buf) * nbuf;
+	bf = kmalloc(bsize, GFP_KERNEL);
+	if (bf == NULL) {
+		error = -ENOMEM;
+		goto fail2;
+	}
+	memset(bf, 0, bsize);
+	dd->dd_bufptr = bf;
+
+	INIT_LIST_HEAD(head);
+	for (i = 0; i < nbuf; i++, bf++, ds += ndesc) {
+		bf->bf_desc = ds;
+		bf->bf_daddr = DS2PHYS(dd, ds);
+
+		if (!(sc->sc_ah->ah_caps.hw_caps &
+		      ATH9K_HW_CAP_4KB_SPLITTRANS)) {
+			/*
+			 * Skip descriptor addresses which can cause 4KB
+			 * boundary crossing (addr + length) with a 32 dword
+			 * descriptor fetch.
+			 */
+			while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
+				ASSERT((caddr_t) bf->bf_desc <
+				       ((caddr_t) dd->dd_desc +
+					dd->dd_desc_len));
+
+				ds += ndesc;
+				bf->bf_desc = ds;
+				bf->bf_daddr = DS2PHYS(dd, ds);
+			}
+		}
+		list_add_tail(&bf->list, head);
+	}
+	return 0;
+fail2:
+	pci_free_consistent(sc->pdev,
+		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+fail:
+	memset(dd, 0, sizeof(*dd));
+	return error;
+#undef ATH_DESC_4KB_BOUND_CHECK
+#undef ATH_DESC_4KB_BOUND_NUM_SKIPPED
+#undef DS2PHYS
+}
+
+void ath_descdma_cleanup(struct ath_softc *sc,
+			 struct ath_descdma *dd,
+			 struct list_head *head)
+{
+	pci_free_consistent(sc->pdev,
+		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+
+	INIT_LIST_HEAD(head);
+	kfree(dd->dd_bufptr);
+	memset(dd, 0, sizeof(*dd));
+}
+
+int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
+{
+	int qnum;
+
+	switch (queue) {
+	case 0:
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VO];
+		break;
+	case 1:
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_VI];
+		break;
+	case 2:
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
+		break;
+	case 3:
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BK];
+		break;
+	default:
+		qnum = sc->sc_haltype2q[ATH9K_WME_AC_BE];
+		break;
+	}
+
+	return qnum;
+}
+
+int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
+{
+	int qnum;
+
+	switch (queue) {
+	case ATH9K_WME_AC_VO:
+		qnum = 0;
+		break;
+	case ATH9K_WME_AC_VI:
+		qnum = 1;
+		break;
+	case ATH9K_WME_AC_BE:
+		qnum = 2;
+		break;
+	case ATH9K_WME_AC_BK:
+		qnum = 3;
+		break;
+	default:
+		qnum = -1;
+		break;
+	}
+
+	return qnum;
+}
+
+/**********************/
+/* mac80211 callbacks */
+/**********************/
+
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
-	int error = 0, pos;
+	struct ath9k_channel *init_channel;
+	int error = 0, pos, status;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
 		"initial channel: %d MHz\n", __func__, curchan->center_freq);
@@ -828,24 +1873,103 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (pos == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
 		error = -EINVAL;
-		goto exit;
+		goto error;
 	}
 
 	sc->sc_ah->ah_channels[pos].chanmode =
 		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
+	init_channel = &sc->sc_ah->ah_channels[pos];
 
-	error = ath_open(sc, &sc->sc_ah->ah_channels[pos]);
-	if (error) {
+	/* Reset SERDES registers */
+	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
+
+	/*
+	 * The basic interface to setting the hardware in a good
+	 * state is ``reset''.  On return the hardware is known to
+	 * be powered up and with interrupts disabled.  This must
+	 * be followed by initialization of the appropriate bits
+	 * and then setup of the interrupt mask.
+	 */
+	spin_lock_bh(&sc->sc_resetlock);
+	if (!ath9k_hw_reset(sc->sc_ah, init_channel,
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to complete ath_open\n", __func__);
-		goto exit;
+			"%s: unable to reset hardware; hal status %u "
+			"(freq %u flags 0x%x)\n", __func__, status,
+			init_channel->channel, init_channel->channelFlags);
+		error = -EIO;
+		spin_unlock_bh(&sc->sc_resetlock);
+		goto error;
 	}
+	spin_unlock_bh(&sc->sc_resetlock);
+
+	/*
+	 * This is needed only to setup initial state
+	 * but it's best done after a reset.
+	 */
+	ath_update_txpow(sc);
+
+	/*
+	 * Setup the hardware after reset:
+	 * The receive engine is set going.
+	 * Frame transmit is handled entirely
+	 * in the frame output path; there's nothing to do
+	 * here except setup the interrupt mask.
+	 */
+	if (ath_startrecv(sc) != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to start recv logic\n", __func__);
+		error = -EIO;
+		goto error;
+	}
+
+	/* Setup our intr mask. */
+	sc->sc_imask = ATH9K_INT_RX | ATH9K_INT_TX
+		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
+		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
+
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_GTT)
+		sc->sc_imask |= ATH9K_INT_GTT;
+
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+		sc->sc_imask |= ATH9K_INT_CST;
+
+	/*
+	 * Enable MIB interrupts when there are hardware phy counters.
+	 * Note we only do this (at the moment) for station mode.
+	 */
+	if (ath9k_hw_phycounters(sc->sc_ah) &&
+	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
+	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
+		sc->sc_imask |= ATH9K_INT_MIB;
+	/*
+	 * Some hardware processes the TIM IE and fires an
+	 * interrupt when the TIM bit is set.  For hardware
+	 * that does, if not overridden by configuration,
+	 * enable the TIM interrupt when operating as station.
+	 */
+	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
+	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
+	    !sc->sc_config.swBeaconProcess)
+		sc->sc_imask |= ATH9K_INT_TIM;
+
+	ath_setcurmode(sc, ath_chan2mode(init_channel));
+
+	sc->sc_flags &= ~SC_OP_INVALID;
+
+	/* Disable BMISS interrupt when we're not associated */
+	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+
+	ieee80211_wake_queues(sc->hw);
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	error = ath_start_rfkill_poll(sc);
 #endif
 
-exit:
+error:
 	return error;
 }
 
@@ -912,7 +2036,30 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
-	ath_stop(sc);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Cleaning up\n", __func__);
+
+	ieee80211_stop_queues(sc->hw);
+
+	/* make sure h/w will not generate any interrupt
+	 * before setting the invalid flag. */
+	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
+		ath_draintxq(sc, false);
+		ath_stoprecv(sc);
+		ath9k_hw_phy_disable(sc->sc_ah);
+	} else
+		sc->sc_rxlink = NULL;
+
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
+	/* disable HAL and put h/w to sleep */
+	ath9k_hw_disable(sc->sc_ah);
+	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
+
+	sc->sc_flags |= SC_OP_INVALID;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Driver halt\n", __func__);
 }
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 7d1913d..93dfea8 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1401,7 +1401,6 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	struct ath_tx_info_priv *tx_info_priv = NULL;
-	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
 	int final_ts_idx, tx_status = 0, is_underrun = 0;
@@ -1410,21 +1409,15 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-	an = (struct ath_node *)sta->drv_priv;
 	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 
-	if (!an || !priv_sta || !ieee80211_is_data(fc) ||
+	if (!priv_sta || !ieee80211_is_data(fc) ||
 	    !tx_info_priv->update_rc)
 		goto exit;
 
 	if (tx_info_priv->tx.ts_status & ATH9K_TXERR_FILT)
 		goto exit;
 
-	if (tx_info_priv->tx.ts_rssi > 0) {
-		ATH_RSSI_LPF(an->an_chainmask_sel.tx_avgrssi,
-			     tx_info_priv->tx.ts_rssi);
-	}
-
 	/*
 	 * If underrun error is seen assume it as an excessive retry only
 	 * if prefetch trigger level have reached the max (0x3f for 5416)
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 0cd2a91..e0e345e 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -57,6 +57,28 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ath9k_hw_rxena(ah);
 }
 
+static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
+{
+	/* XXX block beacon interrupts */
+	ath9k_hw_setantenna(sc->sc_ah, antenna);
+	sc->sc_defant = antenna;
+	sc->sc_rxotherant = 0;
+}
+
+/*
+ *  Extend 15-bit time stamp from rx descriptor to
+ *  a full 64-bit TSF using the current h/w TSF.
+*/
+static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
+{
+	u64 tsf;
+
+	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	if ((tsf & 0x7fff) < rstamp)
+		tsf -= 0x8000;
+	return (tsf & ~0x7fff) | rstamp;
+}
+
 static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index dad81a9..3de60c5 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -147,6 +147,19 @@ static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 		return 0;
 }
 
+static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
+				 struct ath_beacon_config *conf)
+{
+	struct ieee80211_hw *hw = sc->hw;
+
+	/* fill in beacon config data */
+
+	conf->beacon_interval = hw->conf.beacon_int;
+	conf->listen_interval = 100;
+	conf->dtim_count = 1;
+	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
+}
+
 /* Calculate Atheros packet type from IEEE80211 packet header */
 
 static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
@@ -522,7 +535,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_desc *ds = bf->bf_desc;
 	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
 	struct ath9k_11n_rate_series series[4];
-	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
@@ -540,9 +552,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 
-	if (tx_info->control.sta)
-		an = (struct ath_node *)tx_info->control.sta->drv_priv;
-
 	if (ieee80211_has_morefrags(fc) ||
 	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
 		rates[1].count = rates[2].count = rates[3].count = 0;
@@ -632,10 +641,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			 (rates[i].flags & IEEE80211_TX_RC_SHORT_GI),
 			 bf_isshpreamble(bf));
 
-		if (bf_isht(bf) && an)
-			series[i].ChSel = ath_chainmask_sel_logic(sc, an);
-		else
-			series[i].ChSel = sc->sc_tx_chainmask;
+		series[i].ChSel = sc->sc_tx_chainmask;
 
 		if (rtsctsena)
 			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-- 
1.6.0.3

