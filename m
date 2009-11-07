Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/29] ath9k: move struct ath_ani to common area
Date: Sat,  7 Nov 2009 15:18:48 -0500
Message-Id: <1257625146-17971-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be shared between ath9k and ath9k_htc. It will also
help with sharing routine helpers on the RX path.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |   12 +++++++
 drivers/net/wireless/ath/ath9k/ath9k.h |   11 ------
 drivers/net/wireless/ath/ath9k/main.c  |   56 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/recv.c  |    3 +-
 4 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 5e19a73..b3c8ee0 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -23,6 +23,16 @@
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
+struct ath_ani {
+	bool caldone;
+	int16_t noise_floor;
+	unsigned int longcal_timer;
+	unsigned int shortcal_timer;
+	unsigned int resetcal_timer;
+	unsigned int checkani_timer;
+	struct timer_list timer;
+};
+
 enum ath_device_state {
 	ATH_HW_UNAVAILABLE,
 	ATH_HW_INITIALIZED,
@@ -66,6 +76,8 @@ struct ath_common {
 	int debug_mask;
 	enum ath_device_state state;
 
+	struct ath_ani ani;
+
 	u16 cachelsz;
 	u16 curaid;
 	u8 macaddr[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4169d2b..24f61fd 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -434,16 +434,6 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
-struct ath_ani {
-	bool caldone;
-	int16_t noise_floor;
-	unsigned int longcal_timer;
-	unsigned int shortcal_timer;
-	unsigned int resetcal_timer;
-	unsigned int checkani_timer;
-	struct timer_list timer;
-};
-
 /* Defines the BT AR_BT_COEX_WGHT used */
 enum ath_stomp_type {
 	ATH_BTCOEX_NO_STOMP,
@@ -601,7 +591,6 @@ struct ath_softc {
 
 	int beacon_interval;
 
-	struct ath_ani ani;
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 11aaa7d..01ac897 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -405,34 +405,34 @@ static void ath_ani_calibrate(unsigned long data)
 	ath9k_ps_wakeup(sc);
 
 	/* Long calibration runs independently of short calibration. */
-	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
+	if ((timestamp - common->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
 		ath_print(common, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
-		sc->ani.longcal_timer = timestamp;
+		common->ani.longcal_timer = timestamp;
 	}
 
 	/* Short calibration applies only while caldone is false */
-	if (!sc->ani.caldone) {
-		if ((timestamp - sc->ani.shortcal_timer) >= short_cal_interval) {
+	if (!common->ani.caldone) {
+		if ((timestamp - common->ani.shortcal_timer) >= short_cal_interval) {
 			shortcal = true;
 			ath_print(common, ATH_DBG_ANI,
 				  "shortcal @%lu\n", jiffies);
-			sc->ani.shortcal_timer = timestamp;
-			sc->ani.resetcal_timer = timestamp;
+			common->ani.shortcal_timer = timestamp;
+			common->ani.resetcal_timer = timestamp;
 		}
 	} else {
-		if ((timestamp - sc->ani.resetcal_timer) >=
+		if ((timestamp - common->ani.resetcal_timer) >=
 		    ATH_RESTART_CALINTERVAL) {
-			sc->ani.caldone = ath9k_hw_reset_calvalid(ah);
-			if (sc->ani.caldone)
-				sc->ani.resetcal_timer = timestamp;
+			common->ani.caldone = ath9k_hw_reset_calvalid(ah);
+			if (common->ani.caldone)
+				common->ani.resetcal_timer = timestamp;
 		}
 	}
 
 	/* Verify whether we must check ANI */
-	if ((timestamp - sc->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
+	if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
 		aniflag = true;
-		sc->ani.checkani_timer = timestamp;
+		common->ani.checkani_timer = timestamp;
 	}
 
 	/* Skip all processing if there's nothing to do. */
@@ -443,21 +443,21 @@ static void ath_ani_calibrate(unsigned long data)
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
-			sc->ani.caldone =
+			common->ani.caldone =
 				ath9k_hw_calibrate(ah,
 						   ah->curchan,
 						   common->rx_chainmask,
 						   longcal);
 
 			if (longcal)
-				sc->ani.noise_floor = ath9k_hw_getchan_noise(ah,
+				common->ani.noise_floor = ath9k_hw_getchan_noise(ah,
 								     ah->curchan);
 
 			ath_print(common, ATH_DBG_ANI,
 				  " calibrate chan %u/%x nf: %d\n",
 				  ah->curchan->channel,
 				  ah->curchan->channelFlags,
-				  sc->ani.noise_floor);
+				  common->ani.noise_floor);
 		}
 	}
 
@@ -473,21 +473,21 @@ set_timer:
 	cal_interval = ATH_LONG_CALINTERVAL;
 	if (sc->sc_ah->config.enable_ani)
 		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
-	if (!sc->ani.caldone)
+	if (!common->ani.caldone)
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
-	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
 
-static void ath_start_ani(struct ath_softc *sc)
+static void ath_start_ani(struct ath_common *common)
 {
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
 
-	sc->ani.longcal_timer = timestamp;
-	sc->ani.shortcal_timer = timestamp;
-	sc->ani.checkani_timer = timestamp;
+	common->ani.longcal_timer = timestamp;
+	common->ani.shortcal_timer = timestamp;
+	common->ani.checkani_timer = timestamp;
 
-	mod_timer(&sc->ani.timer,
+	mod_timer(&common->ani.timer,
 		  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 }
 
@@ -1023,12 +1023,12 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		/* Reset rssi stats */
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-		ath_start_ani(sc);
+		ath_start_ani(common);
 	} else {
 		ath_print(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		common->curaid = 0;
 		/* Stop ANI */
-		del_timer_sync(&sc->ani.timer);
+		del_timer_sync(&common->ani.timer);
 	}
 }
 
@@ -1761,8 +1761,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	/* Initializes the noise floor to a reasonable default value.
 	 * Later on this will be updated during ANI processing. */
 
-	sc->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
-	setup_timer(&sc->ani.timer, ath_ani_calibrate, (unsigned long)sc);
+	common->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)) {
@@ -2634,7 +2634,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (conf->type == NL80211_IFTYPE_AP    ||
 	    conf->type == NL80211_IFTYPE_ADHOC ||
 	    conf->type == NL80211_IFTYPE_MONITOR)
-		ath_start_ani(sc);
+		ath_start_ani(common);
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -2655,7 +2655,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	/* Stop ANI */
-	del_timer_sync(&sc->ani.timer);
+	del_timer_sync(&common->ani.timer);
 
 	/* Reclaim beacon resources */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b27ea89..403debb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -102,6 +102,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	struct ieee80211_sta *sta;
 	struct ath_node *an;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
@@ -212,7 +213,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	rx_status->mactime = ath9k_hw_extend_tsf(sc->sc_ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->noise = sc->ani.noise_floor;
+	rx_status->noise = common->ani.noise_floor;
 	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 
-- 
1.6.5.2.143.g8cc62

