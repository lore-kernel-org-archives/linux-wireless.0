Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:42986 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYFZCgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 22:36:04 -0400
Date: Wed, 25 Jun 2008 22:35:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, mickflemm@gmail.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath5k: convert LED code to use mac80211 triggers
Message-ID: <20080626023528.GA16068@hash.localnet> (sfid-20080626_043629_504061_FF609497)
References: <20080622181134.GA26571@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0806250656r7c7437e8o5bc629f4c9c30b67@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change cleans up the ath5k LED code and converts it to use
the standard LED device class along with the rx/tx LED triggers
provided by mac80211.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Final version with small correction to led_enable and select NEW_LEDS

 drivers/net/wireless/ath5k/Kconfig |    3 +
 drivers/net/wireless/ath5k/base.c  |  255 ++++++++++++++++--------------------
 drivers/net/wireless/ath5k/base.h  |   32 +++--
 3 files changed, 134 insertions(+), 156 deletions(-)

diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath5k/Kconfig
index f1f2aea..75383a5 100644
--- a/drivers/net/wireless/ath5k/Kconfig
+++ b/drivers/net/wireless/ath5k/Kconfig
@@ -1,6 +1,9 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 85045af..c6e0a93 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -58,11 +58,6 @@
 #include "reg.h"
 #include "debug.h"
 
-enum {
-	ATH_LED_TX,
-	ATH_LED_RX,
-};
-
 static int ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
 
 
@@ -309,13 +304,10 @@ static void 	ath5k_tasklet_reset(unsigned long data);
 
 static void 	ath5k_calibrate(unsigned long data);
 /* LED functions */
-static void 	ath5k_led_off(unsigned long data);
-static void 	ath5k_led_blink(struct ath5k_softc *sc,
-				unsigned int on,
-				unsigned int off);
-static void 	ath5k_led_event(struct ath5k_softc *sc,
-				int event);
-
+static int	ath5k_init_leds(struct ath5k_softc *sc);
+static void	ath5k_led_enable(struct ath5k_softc *sc);
+static void	ath5k_led_off(struct ath5k_softc *sc);
+static void	ath5k_unregister_leds(struct ath5k_softc *sc);
 
 /*
  * Module init/exit functions
@@ -596,8 +588,7 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
 
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status))
-		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 1);
+	ath5k_led_off(sc);
 
 	ath5k_stop_hw(sc);
 	pci_save_state(pdev);
@@ -632,10 +623,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x41, 0);
 
 	ath5k_init(sc);
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-		ath5k_hw_set_gpio_output(ah, sc->led_pin);
-		ath5k_hw_set_gpio(ah, sc->led_pin, 0);
-	}
+	ath5k_led_enable(sc);
 
 	/*
 	 * Reset the key cache since some parts do not
@@ -742,27 +730,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
 	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
 	setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)sc);
-	setup_timer(&sc->led_tim, ath5k_led_off, (unsigned long)sc);
-
-	sc->led_on = 0; /* low true */
-	/*
-	 * Auto-enable soft led processing for IBM cards and for
-	 * 5211 minipci cards.
-	 */
-	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
-			pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 0;
-	}
-	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
-	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = 0;
-	}
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-		ath5k_hw_set_gpio_output(ah, sc->led_pin);
-		ath5k_hw_set_gpio(ah, sc->led_pin, !sc->led_on);
-	}
 
 	ath5k_hw_get_lladdr(ah, mac);
 	SET_IEEE80211_PERM_ADDR(hw, mac);
@@ -776,6 +743,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err_queues;
 	}
 
+	ath5k_init_leds(sc);
+
 	return 0;
 err_queues:
 	ath5k_txq_release(sc);
@@ -809,6 +778,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	ath5k_desc_free(sc, pdev);
 	ath5k_txq_release(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
+	ath5k_unregister_leds(sc);
 
 	/*
 	 * NB: can't reclaim these until after ieee80211_ifdetach
@@ -1060,65 +1030,9 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	return 0;
 }
 
-/*
- * TODO: CLEAN THIS !!!
- */
 static void
 ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 {
-	if (unlikely(test_bit(ATH_STAT_LEDSOFT, sc->status))) {
-		/* from Atheros NDIS driver, w/ permission */
-		static const struct {
-			u16 rate;	/* tx/rx 802.11 rate */
-			u16 timeOn;	/* LED on time (ms) */
-			u16 timeOff;	/* LED off time (ms) */
-		} blinkrates[] = {
-			{ 108,  40,  10 },
-			{  96,  44,  11 },
-			{  72,  50,  13 },
-			{  48,  57,  14 },
-			{  36,  67,  16 },
-			{  24,  80,  20 },
-			{  22, 100,  25 },
-			{  18, 133,  34 },
-			{  12, 160,  40 },
-			{  10, 200,  50 },
-			{   6, 240,  58 },
-			{   4, 267,  66 },
-			{   2, 400, 100 },
-			{   0, 500, 130 }
-		};
-		const struct ath5k_rate_table *rt =
-				ath5k_hw_get_rate_table(sc->ah, mode);
-		unsigned int i, j;
-
-		BUG_ON(rt == NULL);
-
-		memset(sc->hwmap, 0, sizeof(sc->hwmap));
-		for (i = 0; i < 32; i++) {
-			u8 ix = rt->rate_code_to_index[i];
-			if (ix == 0xff) {
-				sc->hwmap[i].ledon = msecs_to_jiffies(500);
-				sc->hwmap[i].ledoff = msecs_to_jiffies(130);
-				continue;
-			}
-			sc->hwmap[i].txflags = IEEE80211_RADIOTAP_F_DATAPAD;
-			/* receive frames include FCS */
-			sc->hwmap[i].rxflags = sc->hwmap[i].txflags |
-					IEEE80211_RADIOTAP_F_FCS;
-			/* setup blink rate table to avoid per-packet lookup */
-			for (j = 0; j < ARRAY_SIZE(blinkrates) - 1; j++)
-				if (blinkrates[j].rate == /* XXX why 7f? */
-						(rt->rates[ix].dot11_rate&0x7f))
-					break;
-
-			sc->hwmap[i].ledon = msecs_to_jiffies(blinkrates[j].
-					timeOn);
-			sc->hwmap[i].ledoff = msecs_to_jiffies(blinkrates[j].
-					timeOff);
-		}
-	}
-
 	sc->curmode = mode;
 
 	if (mode == AR5K_MODE_11A) {
@@ -1903,8 +1817,6 @@ accept:
 			ath5k_check_ibss_tsf(sc, skb, &rxs);
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
-		sc->led_rxrate = rs.rs_rate;
-		ath5k_led_event(sc, ATH_LED_RX);
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
 	} while (ath5k_rxbuf_setup(sc, bf) == 0);
@@ -1985,13 +1897,9 @@ ath5k_tasklet_tx(unsigned long data)
 	struct ath5k_softc *sc = (void *)data;
 
 	ath5k_tx_processq(sc, sc->txq);
-
-	ath5k_led_event(sc, ATH_LED_TX);
 }
 
 
-
-
 /*****************\
 * Beacon handling *
 \*****************/
@@ -2366,11 +2274,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	ieee80211_stop_queues(sc->hw);
 
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
-		if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-			del_timer_sync(&sc->led_tim);
-			ath5k_hw_set_gpio(ah, sc->led_pin, !sc->led_on);
-			__clear_bit(ATH_STAT_LEDBLINKING, sc->status);
-		}
+		ath5k_led_off(sc);
 		ath5k_hw_set_intr(ah, 0);
 	}
 	ath5k_txq_cleanup(sc);
@@ -2566,54 +2470,123 @@ ath5k_calibrate(unsigned long data)
 \***************/
 
 static void
-ath5k_led_off(unsigned long data)
+ath5k_led_enable(struct ath5k_softc *sc)
 {
-	struct ath5k_softc *sc = (void *)data;
-
-	if (test_bit(ATH_STAT_LEDENDBLINK, sc->status))
-		__clear_bit(ATH_STAT_LEDBLINKING, sc->status);
-	else {
-		__set_bit(ATH_STAT_LEDENDBLINK, sc->status);
-		ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);
-		mod_timer(&sc->led_tim, jiffies + sc->led_off);
+	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
+		ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
+		ath5k_led_off(sc);
 	}
 }
 
-/*
- * Blink the LED according to the specified on/off times.
- */
-static void
-ath5k_led_blink(struct ath5k_softc *sc, unsigned int on,
-		unsigned int off)
+static void 
+ath5k_led_on(struct ath5k_softc *sc)
 {
-	ATH5K_DBG(sc, ATH5K_DEBUG_LED, "on %u off %u\n", on, off);
+	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
+		return;
 	ath5k_hw_set_gpio(sc->ah, sc->led_pin, sc->led_on);
-	__set_bit(ATH_STAT_LEDBLINKING, sc->status);
-	__clear_bit(ATH_STAT_LEDENDBLINK, sc->status);
-	sc->led_off = off;
-	mod_timer(&sc->led_tim, jiffies + on);
 }
 
-static void
-ath5k_led_event(struct ath5k_softc *sc, int event)
+static void 
+ath5k_led_off(struct ath5k_softc *sc)
 {
-	if (likely(!test_bit(ATH_STAT_LEDSOFT, sc->status)))
+	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
 		return;
-	if (unlikely(test_bit(ATH_STAT_LEDBLINKING, sc->status)))
-		return; /* don't interrupt active blink */
-	switch (event) {
-	case ATH_LED_TX:
-		ath5k_led_blink(sc, sc->hwmap[sc->led_txrate].ledon,
-			sc->hwmap[sc->led_txrate].ledoff);
-		break;
-	case ATH_LED_RX:
-		ath5k_led_blink(sc, sc->hwmap[sc->led_rxrate].ledon,
-			sc->hwmap[sc->led_rxrate].ledoff);
-		break;
+	ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);
+}
+
+static void 
+ath5k_led_brightness_set(struct led_classdev *led_dev,
+	enum led_brightness brightness)
+{
+	struct ath5k_led *led = container_of(led_dev, struct ath5k_led, 
+		led_dev);
+
+	if (brightness == LED_OFF)
+		ath5k_led_off(led->sc);
+	else
+		ath5k_led_on(led->sc);
+}
+
+static int
+ath5k_register_led(struct ath5k_softc *sc, struct ath5k_led *led, 
+		   const char *name, char *trigger)
+{
+	int err;
+
+	led->sc = sc;
+	strncpy(led->name, name, sizeof(led->name));
+	led->led_dev.name = led->name;
+	led->led_dev.default_trigger = trigger;
+	led->led_dev.brightness_set = ath5k_led_brightness_set;
+
+	err = led_classdev_register(&sc->pdev->dev, &led->led_dev);
+	if (err)
+	{
+		ATH5K_WARN(sc, "could not register LED %s\n", name);
+		led->sc = NULL;
 	}
+	return err;
 }
 
+static void
+ath5k_unregister_led(struct ath5k_led *led)
+{
+	if (!led->sc)
+		return;
+	led_classdev_unregister(&led->led_dev);
+	ath5k_led_off(led->sc);
+	led->sc = NULL;
+}
 
+static void
+ath5k_unregister_leds(struct ath5k_softc *sc)
+{
+	ath5k_unregister_led(&sc->rx_led);
+	ath5k_unregister_led(&sc->tx_led);
+}
+		 	
+
+static int
+ath5k_init_leds(struct ath5k_softc *sc)
+{
+	int ret = 0;
+	struct ieee80211_hw *hw = sc->hw;
+	struct pci_dev *pdev = sc->pdev;
+	char name[ATH5K_LED_MAX_NAME_LEN + 1];
+
+	sc->led_on = 0;  /* active low */
+
+	/*
+	 * Auto-enable soft led processing for IBM cards and for
+	 * 5211 minipci cards.
+	 */
+	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
+	    pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {
+		__set_bit(ATH_STAT_LEDSOFT, sc->status);
+		sc->led_pin = 0;
+	}
+	/* Enable softled on PIN1 on HP Compaq nc6xx, nc4000 & nx5000 laptops */
+	if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ) {
+		__set_bit(ATH_STAT_LEDSOFT, sc->status);
+		sc->led_pin = 1;
+	}
+	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
+		goto out;
+
+	ath5k_led_enable(sc);
+
+	snprintf(name, sizeof(name), "ath5k-%s::rx", wiphy_name(hw->wiphy));
+	ret = ath5k_register_led(sc, &sc->rx_led, name, 
+		ieee80211_get_rx_led_name(hw));
+	if (ret)
+		goto out;
+
+	snprintf(name, sizeof(name), "ath5k-%s::tx", wiphy_name(hw->wiphy));
+	ret = ath5k_register_led(sc, &sc->tx_led, name, 
+		ieee80211_get_tx_led_name(hw));
+out:
+	return ret;
+}
 
 
 /********************\
@@ -2651,8 +2624,6 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		memmove(skb->data, skb->data+pad, hdrlen);
 	}
 
-	sc->led_txrate = ieee80211_get_tx_rate(hw, info)->hw_value;
-
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index bb4b26d..47f414b 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -45,6 +45,7 @@
 #include <linux/list.h>
 #include <linux/wireless.h>
 #include <linux/if_ether.h>
+#include <linux/leds.h>
 
 #include "ath5k.h"
 #include "debug.h"
@@ -79,6 +80,19 @@ struct ath5k_txq {
 	bool			setup;
 };
 
+#define ATH5K_LED_MAX_NAME_LEN 31
+
+/*
+ * State for LED triggers
+ */
+struct ath5k_led
+{
+	char name[ATH5K_LED_MAX_NAME_LEN + 1];	/* name of the LED in sysfs */
+	struct ath5k_softc *sc;			/* driver state */
+	struct led_classdev led_dev;		/* led classdev */
+};
+
+
 #if CHAN_DEBUG
 #define ATH_CHAN_MAX	(26+26+26+200+200)
 #else
@@ -118,13 +132,11 @@ struct ath5k_softc {
 	size_t			desc_len;	/* size of TX/RX descriptors */
 	u16			cachelsz;	/* cache line size */
 
-	DECLARE_BITMAP(status, 6);
+	DECLARE_BITMAP(status, 4);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
 #define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
 #define ATH_STAT_PROMISC	2
-#define ATH_STAT_LEDBLINKING	3		/* LED blink operation active */
-#define ATH_STAT_LEDENDBLINK	4		/* finish LED blink operation */
-#define ATH_STAT_LEDSOFT	5		/* enable LED gpio status */
+#define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */
@@ -132,13 +144,6 @@ struct ath5k_softc {
 
 	struct ieee80211_vif *vif;
 
-	struct {
-		u8	rxflags;	/* radiotap rx flags */
-		u8	txflags;	/* radiotap tx flags */
-		u16	ledon;		/* softled on time */
-		u16	ledoff;		/* softled off time */
-	} hwmap[32];				/* h/w rate ix mappings */
-
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
 	DECLARE_BITMAP(keymap, AR5K_KEYCACHE_SIZE); /* key use bit map */
@@ -148,9 +153,6 @@ struct ath5k_softc {
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
 				led_on,		/* pin setting for LED on */
 				led_off;	/* off time for current blink */
-	struct timer_list	led_tim;	/* led off timer */
-	u8			led_rxrate;	/* current rx rate for LED */
-	u8			led_txrate;	/* current tx rate for LED */
 
 	struct tasklet_struct	restq;		/* reset tasklet */
 
@@ -159,6 +161,7 @@ struct ath5k_softc {
 	spinlock_t		rxbuflock;
 	u32			*rxlink;	/* link ptr in last RX desc */
 	struct tasklet_struct	rxtq;		/* rx intr tasklet */
+	struct ath5k_led	rx_led;		/* rx led */
 
 	struct list_head	txbuf;		/* transmit buffer */
 	spinlock_t		txbuflock;
@@ -167,6 +170,7 @@ struct ath5k_softc {
 
 	struct ath5k_txq	*txq;		/* beacon and tx*/
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
+	struct ath5k_led	tx_led;		/* tx led */
 
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
-- 
1.5.4.2.182.gb3092


