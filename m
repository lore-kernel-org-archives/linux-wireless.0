Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37854 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab0CAJRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:44 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:43 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35501.467215.380773@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] ath9k: Add common code to lib
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move a few macros to the common library to be shared
between ath9k and ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile  |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |   33 +-------------
 drivers/net/wireless/ath/ath9k/lib.h     |    1 +
 drivers/net/wireless/ath/ath9k/main.c    |   70 +-----------------------------
 drivers/net/wireless/ath/ath9k/virtual.c |    3 +-
 5 files changed, 8 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index b1af5d5..518ebb7 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -5,7 +5,8 @@ ath9k-y +=	beacon.o \
 		recv.o \
 		xmit.o \
 		virtual.o \
-		rc.o
+		rc.o \
+		lib.o
 
 ath9k-$(CONFIG_PCI) += pci.o
 ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83c7ea4..d3acf1c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -23,6 +23,7 @@
 
 #include "debug.h"
 #include "common.h"
+#include "lib.h"
 
 /*
  * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
@@ -55,9 +56,6 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
 
 struct ath_config {
@@ -294,8 +292,6 @@ struct ath_vif {
 #define BSTUCK_THRESH           	(9 * ATH_BCBUF)
 #define	ATH_BCBUF               	4
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
-#define ATH_DEFAULT_BMISS_LIMIT 	10
-#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 struct ath_beacon_config {
 	u16 beacon_interval;
@@ -332,18 +328,6 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
 
-/*******/
-/* ANI */
-/*******/
-
-#define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
-#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
-#define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
-#define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
-#define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
-
-void ath_ani_calibrate(unsigned long data);
-
 /**********/
 /* BTCOEX */
 /**********/
@@ -377,18 +361,6 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 /*   LED Control    */
 /********************/
 
-#define ATH_LED_PIN_DEF 		1
-#define ATH_LED_PIN_9287		8
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
 struct ath_led {
 	struct ath_softc *sc;
 	struct led_classdev led_cdev;
@@ -549,8 +521,6 @@ void ath9k_deinit_device(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan);
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
@@ -599,6 +569,7 @@ void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue);
 void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
+void ath_ani_calibrate(unsigned long data);
 
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/lib.h b/drivers/net/wireless/ath/ath9k/lib.h
index 815d265..86dc86d 100644
--- a/drivers/net/wireless/ath/ath9k/lib.h
+++ b/drivers/net/wireless/ath/ath9k/lib.h
@@ -22,6 +22,7 @@
 #define IEEE80211_WEP_NKID 4
 
 #define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
+#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
 #define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 67ca4e5..050baf2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -105,7 +105,7 @@ static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
 
 	chan_idx = curchan->hw_value;
 	channel = &sc->sc_ah->channels[chan_idx];
-	ath9k_update_ichannel(sc, hw, channel);
+	ath9k_update_ichannel(hw, channel);
 	return channel;
 }
 
@@ -545,48 +545,6 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static u32 ath_get_extchanmode(struct ath_softc *sc,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type)
-{
-	u32 chanmode = 0;
-
-	switch (chan->band) {
-	case IEEE80211_BAND_2GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_G_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_G_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_G_HT40MINUS;
-			break;
-		}
-		break;
-	case IEEE80211_BAND_5GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_A_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_A_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_A_HT40MINUS;
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return chanmode;
-}
-
 static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
 			   struct ath9k_keyval *hk, const u8 *addr,
 			   bool authenticator)
@@ -1048,30 +1006,6 @@ int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
 	return qnum;
 }
 
-/* XXX: Remove me once we don't depend on ath9k_channel for all
- * this redundant data */
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan)
-{
-	struct ieee80211_channel *chan = hw->conf.channel;
-	struct ieee80211_conf *conf = &hw->conf;
-
-	ichan->channel = chan->center_freq;
-	ichan->chan = chan;
-
-	if (chan->band == IEEE80211_BAND_2GHZ) {
-		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
-	} else {
-		ichan->chanmode = CHANNEL_A;
-		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-	}
-
-	if (conf_is_ht(conf))
-		ichan->chanmode = ath_get_extchanmode(sc, chan,
-					    conf->channel_type);
-}
-
 /**********************/
 /* mac80211 callbacks */
 /**********************/
@@ -1619,7 +1553,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			  curchan->center_freq);
 
 		/* XXX: remove me eventualy */
-		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
+		ath9k_update_ichannel(hw, &sc->sc_ah->channels[pos]);
 
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index a43fbf8..2b6ecf7 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -312,8 +312,7 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
 	/* Change channels */
 	mutex_lock(&sc->mutex);
 	/* XXX: remove me eventually */
-	ath9k_update_ichannel(sc, aphy->hw,
-			      &sc->sc_ah->channels[sc->chan_idx]);
+	ath9k_update_ichannel(aphy->hw, &sc->sc_ah->channels[sc->chan_idx]);
 
 	/* sync hw configuration for hw code */
 	common->hw = aphy->hw;
-- 
1.7.0.1

