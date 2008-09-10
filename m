Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39899 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYIJNYy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:24:54 -0400
Date: Wed, 10 Sep 2008 18:49:27 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/2] ath9k: Re-order functions in main.c
Message-ID: <20080910131927.GA7779@vasanth-lnx.users.atheros.com> (sfid-20080910_152459_310921_67003F28)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the functions in main.c are re-ordered in such
a way that all local functions are defined before mac80211
and pci callbacks.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |  938 ++++++++++++++++++------------------
 1 files changed, 469 insertions(+), 469 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 57d7cc8..07e5b5d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -325,6 +325,475 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
+static void ath9k_ht_conf(struct ath_softc *sc,
+			  struct ieee80211_bss_conf *bss_conf)
+{
+#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
+	struct ath_ht_info *ht_info = &sc->sc_ht_info;
+
+	if (bss_conf->assoc_ht) {
+		ht_info->ext_chan_offset =
+			bss_conf->ht_bss_conf->bss_cap &
+				IEEE80211_HT_IE_CHA_SEC_OFFSET;
+
+		if (!(bss_conf->ht_conf->cap &
+			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+			    (bss_conf->ht_bss_conf->bss_cap &
+				IEEE80211_HT_IE_CHA_WIDTH))
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
+		else
+			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
+
+		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
+		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+					bss_conf->ht_conf->ampdu_factor);
+		ht_info->mpdudensity =
+			parse_mpdudensity(bss_conf->ht_conf->ampdu_density);
+
+	}
+
+#undef IEEE80211_HT_CAP_40MHZ_INTOLERANT
+}
+
+static void ath9k_bss_assoc_info(struct ath_softc *sc,
+				 struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ath_vap *avp;
+	int pos;
+	DECLARE_MAC_BUF(mac);
+
+	if (bss_conf->assoc) {
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
+			__func__,
+			bss_conf->aid);
+
+		avp = sc->sc_vaps[0];
+		if (avp == NULL) {
+			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
+				__func__);
+			return;
+		}
+
+		/* New association, store aid */
+		if (avp->av_opmode == ATH9K_M_STA) {
+			sc->sc_curaid = bss_conf->aid;
+			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
+					       sc->sc_curaid);
+		}
+
+		/* Configure the beacon */
+		ath_beacon_config(sc, 0);
+		sc->sc_flags |= SC_OP_BEACONS;
+
+		/* Reset rssi stats */
+		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
+
+		/* Update chainmask */
+		ath_update_chainmask(sc, bss_conf->assoc_ht);
+
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"%s: bssid %s aid 0x%x\n",
+			__func__,
+			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
+
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
+			__func__,
+			curchan->center_freq);
+
+		pos = ath_get_channel(sc, curchan);
+		if (pos == -1) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Invalid channel\n", __func__);
+			return;
+		}
+
+		if (hw->conf.ht_conf.ht_supported)
+			sc->sc_ah->ah_channels[pos].chanmode =
+				ath_get_extchanmode(sc, curchan);
+		else
+			sc->sc_ah->ah_channels[pos].chanmode =
+				(curchan->band == IEEE80211_BAND_2GHZ) ?
+				CHANNEL_G : CHANNEL_A;
+
+		/* set h/w channel */
+		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Unable to set channel\n",
+				__func__);
+
+		ath_rate_newstate(sc, avp);
+		/* Update ratectrl about the new state */
+		ath_rc_node_update(hw, avp->rc_node);
+	} else {
+		DPRINTF(sc, ATH_DBG_CONFIG,
+		"%s: Bss Info DISSOC\n", __func__);
+		sc->sc_curaid = 0;
+	}
+}
+
+void ath_get_beaconconfig(struct ath_softc *sc,
+			  int if_id,
+			  struct ath_beacon_config *conf)
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
+void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
+		     struct ath_xmit_status *tx_status, struct ath_node *an)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+
+	DPRINTF(sc, ATH_DBG_XMIT,
+		"%s: TX complete: skb: %p\n", __func__, skb);
+
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
+		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
+		/* free driver's private data area of tx_info */
+		if (tx_info->driver_data[0] != NULL)
+			kfree(tx_info->driver_data[0]);
+			tx_info->driver_data[0] = NULL;
+	}
+
+	if (tx_status->flags & ATH_TX_BAR) {
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		tx_status->flags &= ~ATH_TX_BAR;
+	}
+
+	if (tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY)) {
+		if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			/* Frame was not ACKed, but an ACK was expected */
+			tx_info->status.excessive_retries = 1;
+		}
+	} else {
+		/* Frame was ACKed */
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	tx_info->status.retry_count = tx_status->retries;
+
+	ieee80211_tx_status(hw, skb);
+	if (an)
+		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
+}
+
+int _ath_rx_indicate(struct ath_softc *sc,
+		     struct sk_buff *skb,
+		     struct ath_recv_status *status,
+		     u16 keyix)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_node *an = NULL;
+	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	int padsize;
+	enum ATH_RX_TYPE st;
+
+	/* see if any padding is done by the hw and remove it */
+	if (hdrlen & 3) {
+		padsize = hdrlen % 4;
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
+	/* Prepare rx status */
+	ath9k_rx_prepare(sc, skb, status, &rx_status);
+
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
+	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
+		   && !(status->flags & ATH_RX_DECRYPT_ERROR)
+		   && skb->len >= hdrlen + 4) {
+		keyix = skb->data[hdrlen + 3] >> 6;
+
+		if (test_bit(keyix, sc->sc_keymap))
+			rx_status.flag |= RX_FLAG_DECRYPTED;
+	}
+
+	spin_lock_bh(&sc->node_lock);
+	an = ath_node_find(sc, hdr->addr2);
+	spin_unlock_bh(&sc->node_lock);
+
+	if (an) {
+		ath_rx_input(sc, an,
+			     hw->conf.ht_conf.ht_supported,
+			     skb, status, &st);
+	}
+	if (!an || (st != ATH_RX_CONSUMED))
+		__ieee80211_rx(hw, skb, &rx_status);
+
+	return 0;
+}
+
+int ath_rx_subframe(struct ath_node *an,
+		    struct sk_buff *skb,
+		    struct ath_recv_status *status)
+{
+	struct ath_softc *sc = an->an_sc;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_rx_status rx_status;
+
+	/* Prepare rx status */
+	ath9k_rx_prepare(sc, skb, status, &rx_status);
+	if (!(status->flags & ATH_RX_DECRYPT_ERROR))
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+
+	__ieee80211_rx(hw, skb, &rx_status);
+
+	return 0;
+}
+
+/********************************/
+/*	 LED functions		*/
+/********************************/
+
+static void ath_led_brightness(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
+	struct ath_softc *sc = led->sc;
+
+	switch (brightness) {
+	case LED_OFF:
+		if (led->led_type == ATH_LED_ASSOC ||
+		    led->led_type == ATH_LED_RADIO)
+			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+				(led->led_type == ATH_LED_RADIO) ? 1 :
+				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
+		break;
+	case LED_FULL:
+		if (led->led_type == ATH_LED_ASSOC)
+			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+		break;
+	default:
+		break;
+	}
+}
+
+static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
+			    char *trigger)
+{
+	int ret;
+
+	led->sc = sc;
+	led->led_cdev.name = led->name;
+	led->led_cdev.default_trigger = trigger;
+	led->led_cdev.brightness_set = ath_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
+	if (ret)
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to register led:%s", led->name);
+	else
+		led->registered = 1;
+	return ret;
+}
+
+static void ath_unregister_led(struct ath_led *led)
+{
+	if (led->registered) {
+		led_classdev_unregister(&led->led_cdev);
+		led->registered = 0;
+	}
+}
+
+static void ath_deinit_leds(struct ath_softc *sc)
+{
+	ath_unregister_led(&sc->assoc_led);
+	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+	ath_unregister_led(&sc->tx_led);
+	ath_unregister_led(&sc->rx_led);
+	ath_unregister_led(&sc->radio_led);
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+}
+
+static void ath_init_leds(struct ath_softc *sc)
+{
+	char *trigger;
+	int ret;
+
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
+	trigger = ieee80211_get_radio_led_name(sc->hw);
+	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
+		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->radio_led, trigger);
+	sc->radio_led.led_type = ATH_LED_RADIO;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_assoc_led_name(sc->hw);
+	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
+		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->assoc_led, trigger);
+	sc->assoc_led.led_type = ATH_LED_ASSOC;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_tx_led_name(sc->hw);
+	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
+		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->tx_led, trigger);
+	sc->tx_led.led_type = ATH_LED_TX;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_rx_led_name(sc->hw);
+	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
+		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->rx_led, trigger);
+	sc->rx_led.led_type = ATH_LED_RX;
+	if (ret)
+		goto fail;
+
+	return;
+
+fail:
+	ath_deinit_leds(sc);
+}
+
+static int ath_detach(struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
+
+	/* Deinit LED control */
+	ath_deinit_leds(sc);
+
+	/* Unregister hw */
+
+	ieee80211_unregister_hw(hw);
+
+	/* unregister Rate control */
+	ath_rate_control_unregister();
+
+	/* tx/rx cleanup */
+
+	ath_rx_cleanup(sc);
+	ath_tx_cleanup(sc);
+
+	/* Deinit */
+
+	ath_deinit(sc);
+
+	return 0;
+}
+
+static int ath_attach(u16 devid,
+		      struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	int error = 0;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
+
+	error = ath_init(devid, sc);
+	if (error != 0)
+		return error;
+
+	/* Init nodes */
+
+	INIT_LIST_HEAD(&sc->node_list);
+	spin_lock_init(&sc->node_lock);
+
+	/* get mac address from hardware and set in mac80211 */
+
+	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
+
+	/* setup channels and rates */
+
+	sc->sbands[IEEE80211_BAND_2GHZ].channels =
+		sc->channels[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
+		sc->rates[IEEE80211_BAND_2GHZ];
+	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+		/* Setup HT capabilities for 2.4Ghz*/
+		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		&sc->sbands[IEEE80211_BAND_2GHZ];
+
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_5GHZ].channels =
+			sc->channels[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			sc->rates[IEEE80211_BAND_5GHZ];
+		sc->sbands[IEEE80211_BAND_5GHZ].band =
+			IEEE80211_BAND_5GHZ;
+
+		if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
+			/* Setup HT capabilities for 5Ghz*/
+			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
+
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&sc->sbands[IEEE80211_BAND_5GHZ];
+	}
+
+	/* FIXME: Have to figure out proper hw init values later */
+
+	hw->queues = 4;
+	hw->ampdu_queues = 1;
+
+	/* Register rate control */
+	hw->rate_control_algorithm = "ath9k_rate_control";
+	error = ath_rate_control_register();
+	if (error != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: Unable to register rate control "
+			"algorithm:%d\n", __func__, error);
+		ath_rate_control_unregister();
+		goto bad;
+	}
+
+	error = ieee80211_register_hw(hw);
+	if (error != 0) {
+		ath_rate_control_unregister();
+		goto bad;
+	}
+
+	/* Initialize LED control */
+	ath_init_leds(sc);
+
+	/* initialize tx/rx engine */
+
+	error = ath_tx_init(sc, ATH_TXBUF);
+	if (error != 0)
+		goto detach;
+
+	error = ath_rx_init(sc, ATH_RXBUF);
+	if (error != 0)
+		goto detach;
+
+	return 0;
+detach:
+	ath_detach(sc);
+bad:
+	return error;
+}
+
 static int ath9k_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
@@ -798,117 +1267,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void ath9k_ht_conf(struct ath_softc *sc,
-			  struct ieee80211_bss_conf *bss_conf)
-{
-#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
-	struct ath_ht_info *ht_info = &sc->sc_ht_info;
-
-	if (bss_conf->assoc_ht) {
-		ht_info->ext_chan_offset =
-			bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_IE_CHA_SEC_OFFSET;
-
-		if (!(bss_conf->ht_conf->cap &
-			IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-			    (bss_conf->ht_bss_conf->bss_cap &
-				IEEE80211_HT_IE_CHA_WIDTH))
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
-		else
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
-
-		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
-		ht_info->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-					bss_conf->ht_conf->ampdu_factor);
-		ht_info->mpdudensity =
-			parse_mpdudensity(bss_conf->ht_conf->ampdu_density);
-
-	}
-
-#undef IEEE80211_HT_CAP_40MHZ_INTOLERANT
-}
-
-static void ath9k_bss_assoc_info(struct ath_softc *sc,
-				 struct ieee80211_bss_conf *bss_conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath_vap *avp;
-	int pos;
-	DECLARE_MAC_BUF(mac);
-
-	if (bss_conf->assoc) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
-			__func__,
-			bss_conf->aid);
-
-		avp = sc->sc_vaps[0];
-		if (avp == NULL) {
-			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
-				__func__);
-			return;
-		}
-
-		/* New association, store aid */
-		if (avp->av_opmode == ATH9K_M_STA) {
-			sc->sc_curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
-					       sc->sc_curaid);
-		}
-
-		/* Configure the beacon */
-		ath_beacon_config(sc, 0);
-		sc->sc_flags |= SC_OP_BEACONS;
-
-		/* Reset rssi stats */
-		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
-
-		/* Update chainmask */
-		ath_update_chainmask(sc, bss_conf->assoc_ht);
-
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: bssid %s aid 0x%x\n",
-			__func__,
-			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
-
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
-			__func__,
-			curchan->center_freq);
-
-		pos = ath_get_channel(sc, curchan);
-		if (pos == -1) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Invalid channel\n", __func__);
-			return;
-		}
-
-		if (hw->conf.ht_conf.ht_supported)
-			sc->sc_ah->ah_channels[pos].chanmode =
-				ath_get_extchanmode(sc, curchan);
-		else
-			sc->sc_ah->ah_channels[pos].chanmode =
-				(curchan->band == IEEE80211_BAND_2GHZ) ?
-				CHANNEL_G : CHANNEL_A;
-
-		/* set h/w channel */
-		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to set channel\n",
-				__func__);
-
-		ath_rate_newstate(sc, avp);
-		/* Update ratectrl about the new state */
-		ath_rc_node_update(hw, avp->rc_node);
-	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: Bss Info DISSOC\n", __func__);
-		sc->sc_curaid = 0;
-	}
-}
-
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *bss_conf,
@@ -1048,364 +1406,6 @@ static struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action
 };
 
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
-void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status, struct ath_node *an)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	DPRINTF(sc, ATH_DBG_XMIT,
-		"%s: TX complete: skb: %p\n", __func__, skb);
-
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
-		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		/* free driver's private data area of tx_info */
-		if (tx_info->driver_data[0] != NULL)
-			kfree(tx_info->driver_data[0]);
-			tx_info->driver_data[0] = NULL;
-	}
-
-	if (tx_status->flags & ATH_TX_BAR) {
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-		tx_status->flags &= ~ATH_TX_BAR;
-	}
-
-	if (tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY)) {
-		if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-			/* Frame was not ACKed, but an ACK was expected */
-			tx_info->status.excessive_retries = 1;
-		}
-	} else {
-		/* Frame was ACKed */
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
-	}
-
-	tx_info->status.retry_count = tx_status->retries;
-
-	ieee80211_tx_status(hw, skb);
-	if (an)
-		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
-}
-
-int _ath_rx_indicate(struct ath_softc *sc,
-		     struct sk_buff *skb,
-		     struct ath_recv_status *status,
-		     u16 keyix)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ath_node *an = NULL;
-	struct ieee80211_rx_status rx_status;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	int padsize;
-	enum ATH_RX_TYPE st;
-
-	/* see if any padding is done by the hw and remove it */
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
-	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
-		   && !(status->flags & ATH_RX_DECRYPT_ERROR)
-		   && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, sc->sc_keymap))
-			rx_status.flag |= RX_FLAG_DECRYPTED;
-	}
-
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, hdr->addr2);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (an) {
-		ath_rx_input(sc, an,
-			     hw->conf.ht_conf.ht_supported,
-			     skb, status, &st);
-	}
-	if (!an || (st != ATH_RX_CONSUMED))
-		__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
-int ath_rx_subframe(struct ath_node *an,
-		    struct sk_buff *skb,
-		    struct ath_recv_status *status)
-{
-	struct ath_softc *sc = an->an_sc;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_rx_status rx_status;
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-	if (!(status->flags & ATH_RX_DECRYPT_ERROR))
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-
-	__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
-/********************************/
-/*	 LED functions		*/
-/********************************/
-
-static void ath_led_brightness(struct led_classdev *led_cdev,
-			       enum led_brightness brightness)
-{
-	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
-	struct ath_softc *sc = led->sc;
-
-	switch (brightness) {
-	case LED_OFF:
-		if (led->led_type == ATH_LED_ASSOC ||
-		    led->led_type == ATH_LED_RADIO)
-			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
-				(led->led_type == ATH_LED_RADIO) ? 1 :
-				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
-		break;
-	case LED_FULL:
-		if (led->led_type == ATH_LED_ASSOC)
-			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
-		break;
-	default:
-		break;
-	}
-}
-
-static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
-			    char *trigger)
-{
-	int ret;
-
-	led->sc = sc;
-	led->led_cdev.name = led->name;
-	led->led_cdev.default_trigger = trigger;
-	led->led_cdev.brightness_set = ath_led_brightness;
-
-	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
-	if (ret)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"Failed to register led:%s", led->name);
-	else
-		led->registered = 1;
-	return ret;
-}
-
-static void ath_unregister_led(struct ath_led *led)
-{
-	if (led->registered) {
-		led_classdev_unregister(&led->led_cdev);
-		led->registered = 0;
-	}
-}
-
-static void ath_deinit_leds(struct ath_softc *sc)
-{
-	ath_unregister_led(&sc->assoc_led);
-	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
-	ath_unregister_led(&sc->tx_led);
-	ath_unregister_led(&sc->rx_led);
-	ath_unregister_led(&sc->radio_led);
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-}
-
-static void ath_init_leds(struct ath_softc *sc)
-{
-	char *trigger;
-	int ret;
-
-	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	/* LED off, active low */
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
-
-	trigger = ieee80211_get_radio_led_name(sc->hw);
-	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
-		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->radio_led, trigger);
-	sc->radio_led.led_type = ATH_LED_RADIO;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_assoc_led_name(sc->hw);
-	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
-		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->assoc_led, trigger);
-	sc->assoc_led.led_type = ATH_LED_ASSOC;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_tx_led_name(sc->hw);
-	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
-		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->tx_led, trigger);
-	sc->tx_led.led_type = ATH_LED_TX;
-	if (ret)
-		goto fail;
-
-	trigger = ieee80211_get_rx_led_name(sc->hw);
-	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
-		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
-	ret = ath_register_led(sc, &sc->rx_led, trigger);
-	sc->rx_led.led_type = ATH_LED_RX;
-	if (ret)
-		goto fail;
-
-	return;
-
-fail:
-	ath_deinit_leds(sc);
-}
-
-static int ath_detach(struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
-
-	/* Deinit LED control */
-	ath_deinit_leds(sc);
-
-	/* Unregister hw */
-
-	ieee80211_unregister_hw(hw);
-
-	/* unregister Rate control */
-	ath_rate_control_unregister();
-
-	/* tx/rx cleanup */
-
-	ath_rx_cleanup(sc);
-	ath_tx_cleanup(sc);
-
-	/* Deinit */
-
-	ath_deinit(sc);
-
-	return 0;
-}
-
-static int ath_attach(u16 devid,
-		      struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	int error = 0;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
-
-	error = ath_init(devid, sc);
-	if (error != 0)
-		return error;
-
-	/* Init nodes */
-
-	INIT_LIST_HEAD(&sc->node_list);
-	spin_lock_init(&sc->node_lock);
-
-	/* get mac address from hardware and set in mac80211 */
-
-	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
-
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
-		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
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
-			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
-
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&sc->sbands[IEEE80211_BAND_5GHZ];
-	}
-
-	/* FIXME: Have to figure out proper hw init values later */
-
-	hw->queues = 4;
-	hw->ampdu_queues = 1;
-
-	/* Register rate control */
-	hw->rate_control_algorithm = "ath9k_rate_control";
-	error = ath_rate_control_register();
-	if (error != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to register rate control "
-			"algorithm:%d\n", __func__, error);
-		ath_rate_control_unregister();
-		goto bad;
-	}
-
-	error = ieee80211_register_hw(hw);
-	if (error != 0) {
-		ath_rate_control_unregister();
-		goto bad;
-	}
-
-	/* Initialize LED control */
-	ath_init_leds(sc);
-
-	/* initialize tx/rx engine */
-
-	error = ath_tx_init(sc, ATH_TXBUF);
-	if (error != 0)
-		goto detach;
-
-	error = ath_rx_init(sc, ATH_RXBUF);
-	if (error != 0)
-		goto detach;
-
-	return 0;
-detach:
-	ath_detach(sc);
-bad:
-	return error;
-}
-
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
-- 
1.5.5.1

