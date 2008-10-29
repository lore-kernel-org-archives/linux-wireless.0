Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJ2Etv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:49:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:49:51 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60113.63830.649458@gargle.gargle.HOWL> (sfid-20081029_060858_293563_4B299F66)
Date: Wed, 29 Oct 2008 10:17:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 10/16] ath9k: Streamline attach/detach
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify attach and detach routines by consolidating
the stop and suspend functions.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |  218 +++++++++++++------------------------
 drivers/net/wireless/ath9k/core.h |    3 +-
 drivers/net/wireless/ath9k/main.c |  185 +++++++++++++------------------
 3 files changed, 158 insertions(+), 248 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index b45953f..1826818 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -186,17 +186,10 @@ static int ath_setup_channels(struct ath_softc *sc)
 	struct ath9k_channel *c;
 
 	/* Fill in ah->ah_channels */
-	if (!ath9k_regd_init_channels(ah,
-				      ATH_CHAN_MAX,
-				      (u32 *)&nchan,
-				      regclassids,
-				      ATH_REGCLASSIDS_MAX,
-				      &nregclass,
-				      CTRY_DEFAULT,
-				      false,
-				      1)) {
+	if (!ath9k_regd_init_channels(ah, ATH_CHAN_MAX, (u32 *)&nchan,
+				      regclassids, ATH_REGCLASSIDS_MAX,
+				      &nregclass, CTRY_DEFAULT, false, 1)) {
 		u32 rd = ah->ah_currentRD;
-
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to collect channel list; "
 			"regdomain likely %u country code %u\n",
@@ -217,40 +210,32 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_2ghz[a].max_power = c->maxTxPower;
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-				chan_2ghz[a].flags |=
-					IEEE80211_CHAN_NO_IBSS;
+				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
 			if (c->channelFlags & CHANNEL_PASSIVE)
-				chan_2ghz[a].flags |=
-					IEEE80211_CHAN_PASSIVE_SCAN;
+				chan_2ghz[a].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 
 			band_2ghz->n_channels = ++a;
 
 			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: 2MHz channel: %d, "
 				"channelFlags: 0x%x\n",
-				__func__,
-				c->channel,
-				c->channelFlags);
+				__func__, c->channel, c->channelFlags);
 		} else if (IS_CHAN_5GHZ(c)) {
 			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
 			chan_5ghz[b].center_freq = c->channel;
 			chan_5ghz[b].max_power = c->maxTxPower;
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-				chan_5ghz[b].flags |=
-					IEEE80211_CHAN_NO_IBSS;
+				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
 			if (c->channelFlags & CHANNEL_PASSIVE)
-				chan_5ghz[b].flags |=
-					IEEE80211_CHAN_PASSIVE_SCAN;
+				chan_5ghz[b].flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 
 			band_5ghz->n_channels = ++b;
 
 			DPRINTF(sc, ATH_DBG_CONFIG,
 				"%s: 5MHz channel: %d, "
 				"channelFlags: 0x%x\n",
-				__func__,
-				c->channel,
-				c->channelFlags);
+				__func__, c->channel, c->channelFlags);
 		}
 	}
 
@@ -292,44 +277,6 @@ static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
 }
 
 /*
- * Stop the device, grabbing the top-level lock to protect
- * against concurrent entry through ath_init (which can happen
- * if another thread does a system call and the thread doing the
- * stop is preempted).
- */
-
-static int ath_stop(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: invalid %ld\n",
-		__func__, sc->sc_flags & SC_OP_INVALID);
-
-	/*
-	 * Shutdown the hardware and driver:
-	 *    stop output from above
-	 *    turn off timers
-	 *    disable interrupts
-	 *    clear transmit machinery
-	 *    clear receive machinery
-	 *    turn off the radio
-	 *    reclaim beacon resources
-	 *
-	 * Note that some of this work is not possible if the
-	 * hardware is gone (invalid).
-	 */
-
-	ath_draintxq(sc, false);
-	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		ath_stoprecv(sc);
-		ath9k_hw_phy_disable(ah);
-	} else
-		sc->sc_rxlink = NULL;
-
-	return 0;
-}
-
-/*
  * Set the current channel
  *
  * Set/change channels.  If the channel is really being changed, it's done
@@ -650,16 +597,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n",
 		__func__, sc->sc_ah->ah_opmode);
 
-	/*
-	 * Stop anything previously setup.  This is safe
-	 * whether this is the first time through or not.
-	 */
-	ath_stop(sc);
-
-	/* Initialize chanmask selection */
-	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
-	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
-
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, 0);
 
@@ -685,6 +622,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 		goto done;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
+
 	/*
 	 * This is needed only to setup initial state
 	 * but it's best done after a reset.
@@ -704,6 +642,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 		error = -EIO;
 		goto done;
 	}
+
 	/* Setup our intr mask. */
 	sc->sc_imask = ATH9K_INT_RX | ATH9K_INT_TX
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
@@ -733,30 +672,61 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	    (sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
+
+	ath_setcurmode(sc, ath_chan2mode(initial_chan));
+
 	/*
 	 *  Don't enable interrupts here as we've not yet built our
 	 *  vap and node data structures, which will be needed as soon
 	 *  as we start receiving.
 	 */
-	ath_setcurmode(sc, ath_chan2mode(initial_chan));
-
-	/* XXX: we must make sure h/w is ready and clear invalid flag
-	 * before turning on interrupt. */
 	sc->sc_flags &= ~SC_OP_INVALID;
+
+	ieee80211_wake_queues(sc->hw);
 done:
 	return error;
 }
 
+void ath_stop(struct ath_softc *sc)
+{
+	struct ath_hal *ah = sc->sc_ah;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Cleaning up\n", __func__);
+
+	ieee80211_stop_queues(sc->hw);
+
+	/* make sure h/w will not generate any interrupt
+	 * before setting the invalid flag. */
+	ath9k_hw_set_interrupts(ah, 0);
+
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
+		ath_draintxq(sc, false);
+		ath_stoprecv(sc);
+		ath9k_hw_phy_disable(ah);
+	} else
+		sc->sc_rxlink = NULL;
+
+#ifdef CONFIG_RFKILL
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
+#endif
+	/* disable HAL and put h/w to sleep */
+	ath9k_hw_disable(sc->sc_ah);
+	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
+
+	sc->sc_flags |= SC_OP_INVALID;
+}
+
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	int status;
 	int error = 0;
 
-	ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-	ath_draintxq(sc, retry_tx);	/* stop xmit */
-	ath_stoprecv(sc);		/* stop recv */
-	ath_flushrecv(sc);		/* flush recv queue */
+	ath9k_hw_set_interrupts(ah, 0);
+	ath_draintxq(sc, retry_tx);
+	ath_stoprecv(sc);
+	ath_flushrecv(sc);
 
 	/* Reset chip */
 	spin_lock_bh(&sc->sc_resetlock);
@@ -771,7 +741,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
-	if (ath_startrecv(sc) != 0)	/* restart recv */
+	if (ath_startrecv(sc) != 0)
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to start recv logic\n", __func__);
 
@@ -804,29 +774,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	return error;
 }
 
-int ath_suspend(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-
-	/* No I/O if device has been surprise removed */
-	if (sc->sc_flags & SC_OP_INVALID)
-		return -EIO;
-
-	/* Shut off the interrupt before setting sc->sc_invalid to '1' */
-	ath9k_hw_set_interrupts(ah, 0);
-
-	/* XXX: we must make sure h/w will not generate any interrupt
-	 * before setting the invalid flag. */
-	sc->sc_flags |= SC_OP_INVALID;
-
-	/* disable HAL and put h/w to sleep */
-	ath9k_hw_disable(sc->sc_ah);
-
-	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
-
-	return 0;
-}
-
 /* Interrupt handler.  Most of the actual processing is deferred.
  * It's the caller's responsibility to ensure the chip is awake. */
 
@@ -994,11 +941,9 @@ int ath_init(u16 devid, struct ath_softc *sc)
 
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
-
 	sc->sc_debug = DBG_DEFAULT;
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: devid 0x%x\n", __func__, devid);
 
-	/* Initialize tasklet */
+	spin_lock_init(&sc->sc_resetlock);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
 		     (unsigned long)sc);
@@ -1011,8 +956,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	/* XXX assert csz is non-zero */
 	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
 
-	spin_lock_init(&sc->sc_resetlock);
-
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -1023,10 +966,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	}
 	sc->sc_ah = ah;
 
-	/* Initializes the noise floor to a reasonable default value.
-	 * Later on this will be updated during ANI processing. */
-	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
-
 	/* Get the hardware key cache size. */
 	sc->sc_keymax = ah->ah_caps.keycache_size;
 	if (sc->sc_keymax > ATH_KEYMAX) {
@@ -1054,17 +993,14 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		set_bit(i + 64, sc->sc_keymap);
 		set_bit(i + 32 + 64, sc->sc_keymap);
 	}
-	/*
-	 * Collect the channel list using the default country
-	 * code and including outdoor channels.  The 802.11 layer
-	 * is resposible for filtering this list based on settings
-	 * like the phy mode.
-	 */
+
+	/* Collect the channel list using the default country code */
+
 	error = ath_setup_channels(sc);
 	if (error)
 		goto bad;
 
-	/* default to STA mode */
+	/* default to MONITOR mode */
 	sc->sc_ah->ah_opmode = ATH9K_M_MONITOR;
 
 	/* Setup rate tables */
@@ -1134,6 +1070,10 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
+	/* Initializes the noise floor to a reasonable default value.
+	 * Later on this will be updated during ANI processing. */
+
+	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
 	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	sc->sc_rc = ath_rate_attach(ah);
@@ -1194,6 +1134,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 	}
+
 	sc->sc_slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
 	/* initialize beacon slots */
@@ -1208,6 +1149,22 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	ath_slow_ant_div_init(&sc->sc_antdiv, sc, 0x127);
 #endif
 
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
 	return 0;
 bad2:
 	/* cleanup tx queues */
@@ -1217,27 +1174,8 @@ bad2:
 bad:
 	if (ah)
 		ath9k_hw_detach(ah);
-	return error;
-}
-
-void ath_deinit(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int i;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
-
-	tasklet_kill(&sc->intr_tq);
-	tasklet_kill(&sc->bcon_tasklet);
-	ath_stop(sc);
-	if (!(sc->sc_flags & SC_OP_INVALID))
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-	ath_rate_detach(sc->sc_rc);
-	/* cleanup tx queues */
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
-	ath9k_hw_detach(ah);
+	return error;
 }
 
 /*******************/
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index fdaecb1..49d2f89 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -997,9 +997,8 @@ struct ath_softc {
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
-void ath_deinit(struct ath_softc *sc);
 int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
-int ath_suspend(struct ath_softc *sc);
+void ath_stop(struct ath_softc *sc);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2587db8..b349e91 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -617,6 +617,7 @@ fail:
 }
 
 #ifdef CONFIG_RFKILL
+
 /*******************/
 /*	Rfkill	   */
 /*******************/
@@ -817,43 +818,72 @@ static void ath_deinit_rfkill(struct ath_softc *sc)
 		sc->rf_kill.rfkill = NULL;
 	}
 }
+
+static int ath_start_rfkill_poll(struct ath_softc *sc)
+{
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		queue_delayed_work(sc->hw->workqueue,
+				   &sc->rf_kill.rfkill_poll, 0);
+
+	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
+		if (rfkill_register(sc->rf_kill.rfkill)) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Unable to register rfkill\n");
+			rfkill_free(sc->rf_kill.rfkill);
+
+			/* Deinitialize the device */
+			if (sc->pdev->irq)
+				free_irq(sc->pdev->irq, sc);
+			ath_detach(sc);
+			pci_iounmap(sc->pdev, sc->mem);
+			pci_release_region(sc->pdev, 0);
+			pci_disable_device(sc->pdev);
+			ieee80211_free_hw(hw);
+			return -EIO;
+		} else {
+			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
+		}
+	}
+
+	return 0;
+}
 #endif /* CONFIG_RFKILL */
 
-static int ath_detach(struct ath_softc *sc)
+static void ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
+	int i = 0;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
 
-	/* Deinit LED control */
+	ieee80211_unregister_hw(hw);
+
 	ath_deinit_leds(sc);
 
 #ifdef CONFIG_RFKILL
-	/* deinit rfkill */
 	ath_deinit_rfkill(sc);
 #endif
-
-	/* Unregister hw */
-
-	ieee80211_unregister_hw(hw);
-
-	/* unregister Rate control */
 	ath_rate_control_unregister();
-
-	/* tx/rx cleanup */
+	ath_rate_detach(sc->sc_rc);
 
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 
-	/* Deinit */
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 
-	ath_deinit(sc);
+	if (!(sc->sc_flags & SC_OP_INVALID))
+		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 
-	return 0;
+	/* cleanup tx queues */
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
+
+	ath9k_hw_detach(sc->sc_ah);
 }
 
-static int ath_attach(u16 devid,
-		      struct ath_softc *sc)
+static int ath_attach(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	int error = 0;
@@ -868,36 +898,15 @@ static int ath_attach(u16 devid,
 
 	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
 
-	/* setup channels and rates */
-
-	sc->sbands[IEEE80211_BAND_2GHZ].channels =
-		sc->channels[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
-		sc->rates[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-		/* Setup HT capabilities for 2.4Ghz*/
-		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&sc->sbands[IEEE80211_BAND_2GHZ];
-
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels =
-			sc->channels[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			sc->rates[IEEE80211_BAND_5GHZ];
-		sc->sbands[IEEE80211_BAND_5GHZ].band =
-			IEEE80211_BAND_5GHZ;
-
-		if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-			/* Setup HT capabilities for 5Ghz*/
-			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_AMPDU_AGGREGATION;
 
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&sc->sbands[IEEE80211_BAND_5GHZ];
-	}
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->queues = 4;
 	hw->sta_data_size = sizeof(struct ath_node);
@@ -914,6 +923,17 @@ static int ath_attach(u16 devid,
 		goto bad;
 	}
 
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
+		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes))
+			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+	}
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =	&sc->sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes))
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&sc->sbands[IEEE80211_BAND_5GHZ];
+
 	error = ieee80211_register_hw(hw);
 	if (error != 0) {
 		ath_rate_control_unregister();
@@ -964,49 +984,26 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	pos = ath_get_channel(sc, curchan);
 	if (pos == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
-		return -EINVAL;
+		error = -EINVAL;
+		goto exit;
 	}
 
 	sc->sc_ah->ah_channels[pos].chanmode =
 		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
 
-	/* open ath_dev */
 	error = ath_open(sc, &sc->sc_ah->ah_channels[pos]);
 	if (error) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: Unable to complete ath_open\n", __func__);
-		return error;
+		goto exit;
 	}
 
 #ifdef CONFIG_RFKILL
-	/* Start rfkill polling */
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		queue_delayed_work(sc->hw->workqueue,
-				   &sc->rf_kill.rfkill_poll, 0);
-
-	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
-		if (rfkill_register(sc->rf_kill.rfkill)) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-					"Unable to register rfkill\n");
-			rfkill_free(sc->rf_kill.rfkill);
-
-			/* Deinitialize the device */
-			if (sc->pdev->irq)
-				free_irq(sc->pdev->irq, sc);
-			ath_detach(sc);
-			pci_iounmap(sc->pdev, sc->mem);
-			pci_release_region(sc->pdev, 0);
-			pci_disable_device(sc->pdev);
-			ieee80211_free_hw(hw);
-			return -EIO;
-		} else {
-			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
-		}
-	}
+	error = ath_start_rfkill_poll(sc);
 #endif
 
-	ieee80211_wake_queues(hw);
-	return 0;
+exit:
+	return error;
 }
 
 static int ath9k_tx(struct ieee80211_hw *hw,
@@ -1066,21 +1063,15 @@ exit:
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	int error;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Driver halt\n", __func__);
-
-	error = ath_suspend(sc);
-	if (error)
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: Device is no longer present\n", __func__);
+	if (sc->sc_flags & SC_OP_INVALID) {
+		DPRINTF(sc, ATH_DBG_ANY, "%s: Device not present\n", __func__);
+		return;
+	}
 
-	ieee80211_stop_queues(hw);
+	ath_stop(sc);
 
-#ifdef CONFIG_RFKILL
-	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
-#endif
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Driver halt\n", __func__);
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -1653,17 +1644,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad2;
 	}
 
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM |
-		IEEE80211_HW_AMPDU_AGGREGATION;
-
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
-
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
@@ -1711,17 +1691,10 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
-	enum ath9k_int status;
 
-	if (pdev->irq) {
-		ath9k_hw_set_interrupts(sc->sc_ah, 0);
-		/* clear the ISR */
-		ath9k_hw_getisr(sc->sc_ah, &status);
-		sc->sc_flags |= SC_OP_INVALID;
-		free_irq(pdev->irq, sc);
-	}
 	ath_detach(sc);
-
+	if (pdev->irq)
+		free_irq(pdev->irq, sc);
 	pci_iounmap(pdev, sc->mem);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-- 
1.6.0.3

