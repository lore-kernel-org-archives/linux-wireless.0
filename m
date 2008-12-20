Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43317 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYLTKBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:01:54 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457082ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:53 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/15] rt2x00: Move link tuning into seperate file
Date: Sat, 20 Dec 2008 10:53:29 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201052.43061.IvDoorn@gmail.com>
In-Reply-To: <200812201052.43061.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201053.29348.IvDoorn@gmail.com> (sfid-20081220_110206_933869_C59518CC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move link and antenna tuning into a seperate file named rt2x00link.c,
this makes the interface to the link tuner a lot cleaner.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Makefile       |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h       |   29 +--
 drivers/net/wireless/rt2x00/rt2x00config.c |    5 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c  |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  303 +--------------------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   81 ++++++-
 drivers/net/wireless/rt2x00/rt2x00link.c   |  402 ++++++++++++++++++++++++++++
 7 files changed, 494 insertions(+), 331 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00link.c

diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index 917cb4f..f22d808 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -2,6 +2,7 @@ rt2x00lib-y				+= rt2x00dev.o
 rt2x00lib-y				+= rt2x00mac.o
 rt2x00lib-y				+= rt2x00config.o
 rt2x00lib-y				+= rt2x00queue.o
+rt2x00lib-y				+= rt2x00link.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_DEBUGFS)	+= rt2x00debug.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_CRYPTO)	+= rt2x00crypto.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_RFKILL)	+= rt2x00rfkill.o
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 39ecf3b..19c0687 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -212,7 +212,7 @@ struct link_qual {
 	 *                       (WEIGHT_TX * tx_percentage) +
 	 *                       (WEIGHT_RX * rx_percentage)) / 100
 	 *
-	 * This value should then be checked to not be greated then 100.
+	 * This value should then be checked to not be greater then 100.
 	 */
 	int rx_percentage;
 	int rx_success;
@@ -318,33 +318,6 @@ static inline int rt2x00_get_link_rssi(struct link *link)
 	return DEFAULT_RSSI;
 }
 
-static inline int rt2x00_get_link_ant_rssi(struct link *link)
-{
-	if (link->ant.rssi_ant && link->qual.rx_success)
-		return link->ant.rssi_ant;
-	return DEFAULT_RSSI;
-}
-
-static inline void rt2x00_reset_link_ant_rssi(struct link *link)
-{
-	link->ant.rssi_ant = 0;
-}
-
-static inline int rt2x00_get_link_ant_rssi_history(struct link *link,
-						   enum antenna ant)
-{
-	if (link->ant.rssi_history[ant - ANTENNA_A])
-		return link->ant.rssi_history[ant - ANTENNA_A];
-	return DEFAULT_RSSI;
-}
-
-static inline int rt2x00_update_ant_rssi(struct link *link, int rssi)
-{
-	int old_rssi = link->ant.rssi_history[link->ant.active.rx - ANTENNA_A];
-	link->ant.rssi_history[link->ant.active.rx - ANTENNA_A] = rssi;
-	return old_rssi;
-}
-
 /*
  * Interface structure
  * Per interface configuration details, this structure
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index e66fb31..2f4cb8d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -152,8 +152,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00dev->ops->lib->config_ant(rt2x00dev, ant);
 
-	rt2x00lib_reset_link_tuner(rt2x00dev);
-	rt2x00_reset_link_ant_rssi(&rt2x00dev->link);
+	rt2x00link_reset_tuner(rt2x00dev, true);
 
 	memcpy(active, ant, sizeof(*ant));
 
@@ -191,7 +190,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	 * which means we need to reset the link tuner.
 	 */
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
-		rt2x00lib_reset_link_tuner(rt2x00dev);
+		rt2x00link_reset_tuner(rt2x00dev, false);
 
 	rt2x00dev->curr_band = conf->channel->band;
 	rt2x00dev->tx_power = conf->power_level;
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 54dd100..cc19406 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -130,9 +130,11 @@ struct rt2x00debug_intf {
 };
 
 void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
-			       enum cipher cipher, enum rx_crypto status)
+			       struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00debug_intf *intf = rt2x00dev->debugfs_intf;
+	enum cipher cipher = rxdesc->cipher;
+	enum rx_crypto status = rxdesc->cipher_status;
 
 	if (cipher == CIPHER_TKIP_NO_MIC)
 		cipher = CIPHER_TKIP;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6d92542..1c49a9c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -30,60 +30,6 @@
 #include "rt2x00lib.h"
 
 /*
- * Link tuning handlers
- */
-void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
-	/*
-	 * Reset link information.
-	 * Both the currently active vgc level as well as
-	 * the link tuner counter should be reset. Resetting
-	 * the counter is important for devices where the
-	 * device should only perform link tuning during the
-	 * first minute after being enabled.
-	 */
-	rt2x00dev->link.count = 0;
-	rt2x00dev->link.vgc_level = 0;
-
-	/*
-	 * Reset the link tuner.
-	 */
-	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
-}
-
-static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
-{
-	/*
-	 * Clear all (possibly) pre-existing quality statistics.
-	 */
-	memset(&rt2x00dev->link.qual, 0, sizeof(rt2x00dev->link.qual));
-
-	/*
-	 * The RX and TX percentage should start at 50%
-	 * this will assure we will get at least get some
-	 * decent value when the link tuner starts.
-	 * The value will be dropped and overwritten with
-	 * the correct (measured )value anyway during the
-	 * first run of the link tuner.
-	 */
-	rt2x00dev->link.qual.rx_percentage = 50;
-	rt2x00dev->link.qual.tx_percentage = 50;
-
-	rt2x00lib_reset_link_tuner(rt2x00dev);
-
-	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
-}
-
-static void rt2x00lib_stop_link_tuner(struct rt2x00_dev *rt2x00dev)
-{
-	cancel_delayed_work_sync(&rt2x00dev->link.work);
-}
-
-/*
  * Radio control handlers.
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
@@ -161,238 +107,15 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	 * When we are disabling the RX, we should also stop the link tuner.
 	 */
 	if (state == STATE_RADIO_RX_OFF)
-		rt2x00lib_stop_link_tuner(rt2x00dev);
+		rt2x00link_stop_tuner(rt2x00dev);
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 
 	/*
 	 * When we are enabling the RX, we should also start the link tuner.
 	 */
-	if (state == STATE_RADIO_RX_ON &&
-	    (rt2x00dev->intf_ap_count || rt2x00dev->intf_sta_count))
-		rt2x00lib_start_link_tuner(rt2x00dev);
-}
-
-static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
-{
-	struct antenna_setup ant;
-	int sample_a =
-	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_A);
-	int sample_b =
-	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_B);
-
-	memcpy(&ant, &rt2x00dev->link.ant.active, sizeof(ant));
-
-	/*
-	 * We are done sampling. Now we should evaluate the results.
-	 */
-	rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
-
-	/*
-	 * During the last period we have sampled the RSSI
-	 * from both antenna's. It now is time to determine
-	 * which antenna demonstrated the best performance.
-	 * When we are already on the antenna with the best
-	 * performance, then there really is nothing for us
-	 * left to do.
-	 */
-	if (sample_a == sample_b)
-		return;
-
-	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
-		ant.rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
-
-	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
-		ant.tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
-
-	rt2x00lib_config_antenna(rt2x00dev, &ant);
-}
-
-static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
-{
-	struct antenna_setup ant;
-	int rssi_curr = rt2x00_get_link_ant_rssi(&rt2x00dev->link);
-	int rssi_old = rt2x00_update_ant_rssi(&rt2x00dev->link, rssi_curr);
-
-	memcpy(&ant, &rt2x00dev->link.ant.active, sizeof(ant));
-
-	/*
-	 * Legacy driver indicates that we should swap antenna's
-	 * when the difference in RSSI is greater that 5. This
-	 * also should be done when the RSSI was actually better
-	 * then the previous sample.
-	 * When the difference exceeds the threshold we should
-	 * sample the rssi from the other antenna to make a valid
-	 * comparison between the 2 antennas.
-	 */
-	if (abs(rssi_curr - rssi_old) < 5)
-		return;
-
-	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
-
-	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
-		ant.rx = (ant.rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
-
-	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
-		ant.tx = (ant.tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
-
-	rt2x00lib_config_antenna(rt2x00dev, &ant);
-}
-
-static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
-{
-	/*
-	 * Determine if software diversity is enabled for
-	 * either the TX or RX antenna (or both).
-	 * Always perform this check since within the link
-	 * tuner interval the configuration might have changed.
-	 */
-	rt2x00dev->link.ant.flags &= ~ANTENNA_RX_DIVERSITY;
-	rt2x00dev->link.ant.flags &= ~ANTENNA_TX_DIVERSITY;
-
-	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
-		rt2x00dev->link.ant.flags |= ANTENNA_RX_DIVERSITY;
-	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-		rt2x00dev->link.ant.flags |= ANTENNA_TX_DIVERSITY;
-
-	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
-	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
-		rt2x00dev->link.ant.flags = 0;
-		return;
-	}
-
-	/*
-	 * If we have only sampled the data over the last period
-	 * we should now harvest the data. Otherwise just evaluate
-	 * the data. The latter should only be performed once
-	 * every 2 seconds.
-	 */
-	if (rt2x00dev->link.ant.flags & ANTENNA_MODE_SAMPLE)
-		rt2x00lib_evaluate_antenna_sample(rt2x00dev);
-	else if (rt2x00dev->link.count & 1)
-		rt2x00lib_evaluate_antenna_eval(rt2x00dev);
-}
-
-static void rt2x00lib_update_link_stats(struct link *link, int rssi)
-{
-	int avg_rssi = rssi;
-
-	/*
-	 * Update global RSSI
-	 */
-	if (link->qual.avg_rssi)
-		avg_rssi = MOVING_AVERAGE(link->qual.avg_rssi, rssi, 8);
-	link->qual.avg_rssi = avg_rssi;
-
-	/*
-	 * Update antenna RSSI
-	 */
-	if (link->ant.rssi_ant)
-		rssi = MOVING_AVERAGE(link->ant.rssi_ant, rssi, 8);
-	link->ant.rssi_ant = rssi;
-}
-
-static void rt2x00lib_precalculate_link_signal(struct link_qual *qual)
-{
-	if (qual->rx_failed || qual->rx_success)
-		qual->rx_percentage =
-		    (qual->rx_success * 100) /
-		    (qual->rx_failed + qual->rx_success);
-	else
-		qual->rx_percentage = 50;
-
-	if (qual->tx_failed || qual->tx_success)
-		qual->tx_percentage =
-		    (qual->tx_success * 100) /
-		    (qual->tx_failed + qual->tx_success);
-	else
-		qual->tx_percentage = 50;
-
-	qual->rx_success = 0;
-	qual->rx_failed = 0;
-	qual->tx_success = 0;
-	qual->tx_failed = 0;
-}
-
-static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev,
-					   int rssi)
-{
-	int rssi_percentage = 0;
-	int signal;
-
-	/*
-	 * We need a positive value for the RSSI.
-	 */
-	if (rssi < 0)
-		rssi += rt2x00dev->rssi_offset;
-
-	/*
-	 * Calculate the different percentages,
-	 * which will be used for the signal.
-	 */
-	if (rt2x00dev->rssi_offset)
-		rssi_percentage = (rssi * 100) / rt2x00dev->rssi_offset;
-
-	/*
-	 * Add the individual percentages and use the WEIGHT
-	 * defines to calculate the current link signal.
-	 */
-	signal = ((WEIGHT_RSSI * rssi_percentage) +
-		  (WEIGHT_TX * rt2x00dev->link.qual.tx_percentage) +
-		  (WEIGHT_RX * rt2x00dev->link.qual.rx_percentage)) / 100;
-
-	return (signal > 100) ? 100 : signal;
-}
-
-static void rt2x00lib_link_tuner(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, link.work.work);
-
-	/*
-	 * When the radio is shutting down we should
-	 * immediately cease all link tuning.
-	 */
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
-	/*
-	 * Update statistics.
-	 */
-	rt2x00dev->ops->lib->link_stats(rt2x00dev, &rt2x00dev->link.qual);
-	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
-	    rt2x00dev->link.qual.rx_failed;
-
-	/*
-	 * Only perform the link tuning when Link tuning
-	 * has been enabled (This could have been disabled from the EEPROM).
-	 */
-	if (!test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
-
-	/*
-	 * Precalculate a portion of the link signal which is
-	 * in based on the tx/rx success/failure counters.
-	 */
-	rt2x00lib_precalculate_link_signal(&rt2x00dev->link.qual);
-
-	/*
-	 * Send a signal to the led to update the led signal strength.
-	 */
-	rt2x00leds_led_quality(rt2x00dev, rt2x00dev->link.qual.avg_rssi);
-
-	/*
-	 * Evaluate antenna setup, make this the last step since this could
-	 * possibly reset some statistics.
-	 */
-	rt2x00lib_evaluate_antenna(rt2x00dev);
-
-	/*
-	 * Increase tuner counter, and reschedule the next link tuner run.
-	 */
-	rt2x00dev->link.count++;
-	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+	if (state == STATE_RADIO_RX_ON)
+		rt2x00link_start_tuner(rt2x00dev);
 }
 
 static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
@@ -597,7 +320,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_hdr *hdr;
 	const struct rt2x00_rate *rate;
 	unsigned int header_length;
 	unsigned int align;
@@ -674,23 +396,14 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * Only update link status if this is a beacon frame carrying our bssid.
+	 * Update extra components
 	 */
-	hdr = (struct ieee80211_hdr *)entry->skb->data;
-	if (ieee80211_is_beacon(hdr->frame_control) &&
-	    (rxdesc.dev_flags & RXDONE_MY_BSS))
-		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc.rssi);
-
-	rt2x00debug_update_crypto(rt2x00dev,
-				  rxdesc.cipher,
-				  rxdesc.cipher_status);
-
-	rt2x00dev->link.qual.rx_success++;
+	rt2x00link_update_stats(rt2x00dev, entry->skb, &rxdesc);
+	rt2x00debug_update_crypto(rt2x00dev, &rxdesc);
 
 	rx_status->mactime = rxdesc.timestamp;
 	rx_status->rate_idx = idx;
-	rx_status->qual =
-	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc.rssi);
+	rx_status->qual = rt2x00link_calculate_signal(rt2x00dev, rxdesc.rssi);
 	rx_status->signal = rxdesc.rssi;
 	rx_status->flag = rxdesc.flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
@@ -1085,7 +798,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_WORK(&rt2x00dev->filter_work, rt2x00lib_packetfilter_scheduled);
-	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00lib_link_tuner);
 
 	/*
 	 * Allocate queue array.
@@ -1106,6 +818,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Register extra components.
 	 */
+	rt2x00link_register(rt2x00dev);
 	rt2x00leds_register(rt2x00dev);
 	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 0302432..a6b7e00 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -74,7 +74,6 @@ static inline int rt2x00_get_rate_preamble(const u16 hw_value)
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state);
-void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Initialization handlers.
@@ -165,6 +164,81 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev);
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev);
 void rt2x00queue_free(struct rt2x00_dev *rt2x00dev);
 
+/**
+ * rt2x00link_update_stats - Update link statistics from RX frame
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @skb: Received frame
+ * @rxdesc: Received frame descriptor
+ *
+ * Update link statistics based on the information from the
+ * received frame descriptor.
+ */
+void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
+			     struct sk_buff *skb,
+			     struct rxdone_entry_desc *rxdesc);
+
+/**
+ * rt2x00link_calculate_signal - Calculate signal quality
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @rssi: RX Frame RSSI
+ *
+ * Calculate the signal quality of a frame based on the rssi
+ * measured during the receiving of the frame and the global
+ * link quality statistics measured since the start of the
+ * link tuning. The result is a value between 0 and 100 which
+ * is an indication of the signal quality.
+ */
+int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi);
+
+/**
+ * rt2x00link_start_tuner - Start periodic link tuner work
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * This start the link tuner periodic work, this work will
+ * be executed periodically until &rt2x00link_stop_tuner has
+ * been called.
+ */
+void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev);
+
+/**
+ * rt2x00link_stop_tuner - Stop periodic link tuner work
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * After this function completed the link tuner will not
+ * be running until &rt2x00link_start_tuner is called.
+ */
+void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev);
+
+/**
+ * rt2x00link_reset_tuner - Reset periodic link tuner work
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @antenna: Should the antenna tuning also be reset
+ *
+ * The VGC limit configured in the hardware will be reset to 0
+ * which forces the driver to rediscover the correct value for
+ * the current association. This is needed when configuration
+ * options have changed which could drastically change the
+ * SNR level or link quality (i.e. changing the antenna setting).
+ *
+ * Resetting the link tuner will also cause the periodic work counter
+ * to be reset. Any driver which has a fixed limit on the number
+ * of rounds the link tuner is supposed to work will accept the
+ * tuner actions again if this limit was previously reached.
+ *
+ * If @antenna is set to true a the software antenna diversity
+ * tuning will also be reset.
+ */
+void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna);
+
+/**
+ * rt2x00link_register - Initialize link tuning functionality
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * Initialize work structure and all link tuning related
+ * paramters. This will not start the link tuning process itself.
+ */
+void rt2x00link_register(struct rt2x00_dev *rt2x00dev);
+
 /*
  * Firmware handlers.
  */
@@ -190,7 +264,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev);
 void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 			    enum rt2x00_dump_type type, struct sk_buff *skb);
 void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
-			       enum cipher cipher, enum rx_crypto status);
+			       struct rxdone_entry_desc *rxdesc);
 #else
 static inline void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -207,8 +281,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 }
 
 static inline void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
-					     enum cipher cipher,
-					     enum rx_crypto status)
+					     struct rxdone_entry_desc *rxdesc)
 {
 }
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
new file mode 100644
index 0000000..0462d5a
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -0,0 +1,402 @@
+/*
+	Copyright (C) 2004 - 2008 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 generic link tuning routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+static int rt2x00link_antenna_get_link_rssi(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+
+	if (ant->rssi_ant && rt2x00dev->link.qual.rx_success)
+		return ant->rssi_ant;
+	return DEFAULT_RSSI;
+}
+
+static int rt2x00link_antenna_get_rssi_history(struct rt2x00_dev *rt2x00dev,
+					       enum antenna antenna)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+
+	if (ant->rssi_history[antenna - ANTENNA_A])
+		return ant->rssi_history[antenna - ANTENNA_A];
+	return DEFAULT_RSSI;
+}
+/* Small wrapper for rt2x00link_antenna_get_rssi_history() */
+#define rt2x00link_antenna_get_rssi_rx_history(__dev) \
+	rt2x00link_antenna_get_rssi_history((__dev), \
+					    (__dev)->link.ant.active.rx)
+#define rt2x00link_antenna_get_rssi_tx_history(__dev) \
+	rt2x00link_antenna_get_rssi_history((__dev), \
+					    (__dev)->link.ant.active.tx)
+
+static void rt2x00link_antenna_update_rssi_history(struct rt2x00_dev *rt2x00dev,
+						   enum antenna antenna,
+						   int rssi)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	ant->rssi_history[ant->active.rx - ANTENNA_A] = rssi;
+}
+/* Small wrapper for rt2x00link_antenna_get_rssi_history() */
+#define rt2x00link_antenna_update_rssi_rx_history(__dev, __rssi) \
+	rt2x00link_antenna_update_rssi_history((__dev), \
+					       (__dev)->link.ant.active.rx, \
+					       (__rssi))
+#define rt2x00link_antenna_update_rssi_tx_history(__dev, __rssi) \
+	rt2x00link_antenna_update_rssi_history((__dev), \
+					       (__dev)->link.ant.active.tx, \
+					       (__rssi))
+
+static void rt2x00link_antenna_reset(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->link.ant.rssi_ant = 0;
+}
+
+static void rt2x00lib_antenna_diversity_sample(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	struct antenna_setup new_ant;
+	int sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev, ANTENNA_A);
+	int sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev, ANTENNA_B);
+
+	memcpy(&new_ant, &ant->active, sizeof(new_ant));
+
+	/*
+	 * We are done sampling. Now we should evaluate the results.
+	 */
+	ant->flags &= ~ANTENNA_MODE_SAMPLE;
+
+	/*
+	 * During the last period we have sampled the RSSI
+	 * from both antenna's. It now is time to determine
+	 * which antenna demonstrated the best performance.
+	 * When we are already on the antenna with the best
+	 * performance, then there really is nothing for us
+	 * left to do.
+	 */
+	if (sample_a == sample_b)
+		return;
+
+	if (ant->flags & ANTENNA_RX_DIVERSITY)
+		new_ant.rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+
+	if (ant->flags & ANTENNA_TX_DIVERSITY)
+		new_ant.tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+
+	rt2x00lib_config_antenna(rt2x00dev, &new_ant);
+}
+
+static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	struct antenna_setup new_ant;
+	int rssi_curr;
+	int rssi_old;
+
+	memcpy(&new_ant, &ant->active, sizeof(new_ant));
+
+	/*
+	 * Get current RSSI value along with the historical value,
+	 * after that update the history with the current value.
+	 */
+	rssi_curr = rt2x00link_antenna_get_link_rssi(rt2x00dev);
+	rssi_old = rt2x00link_antenna_get_rssi_rx_history(rt2x00dev);
+	rt2x00link_antenna_update_rssi_rx_history(rt2x00dev, rssi_curr);
+
+	/*
+	 * Legacy driver indicates that we should swap antenna's
+	 * when the difference in RSSI is greater that 5. This
+	 * also should be done when the RSSI was actually better
+	 * then the previous sample.
+	 * When the difference exceeds the threshold we should
+	 * sample the rssi from the other antenna to make a valid
+	 * comparison between the 2 antennas.
+	 */
+	if (abs(rssi_curr - rssi_old) < 5)
+		return;
+
+	ant->flags |= ANTENNA_MODE_SAMPLE;
+
+	if (ant->flags & ANTENNA_RX_DIVERSITY)
+		new_ant.rx = (new_ant.rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+
+	if (ant->flags & ANTENNA_TX_DIVERSITY)
+		new_ant.tx = (new_ant.tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+
+	rt2x00lib_config_antenna(rt2x00dev, &new_ant);
+}
+
+static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_ant *ant = &rt2x00dev->link.ant;
+
+	/*
+	 * Determine if software diversity is enabled for
+	 * either the TX or RX antenna (or both).
+	 * Always perform this check since within the link
+	 * tuner interval the configuration might have changed.
+	 */
+	ant->flags &= ~ANTENNA_RX_DIVERSITY;
+	ant->flags &= ~ANTENNA_TX_DIVERSITY;
+
+	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
+		ant->flags |= ANTENNA_RX_DIVERSITY;
+	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
+		ant->flags |= ANTENNA_TX_DIVERSITY;
+
+	if (!(ant->flags & ANTENNA_RX_DIVERSITY) &&
+	    !(ant->flags & ANTENNA_TX_DIVERSITY)) {
+		ant->flags = 0;
+		return;
+	}
+
+	/*
+	 * If we have only sampled the data over the last period
+	 * we should now harvest the data. Otherwise just evaluate
+	 * the data. The latter should only be performed once
+	 * every 2 seconds.
+	 */
+	if (ant->flags & ANTENNA_MODE_SAMPLE)
+		rt2x00lib_antenna_diversity_sample(rt2x00dev);
+	else if (rt2x00dev->link.count & 1)
+		rt2x00lib_antenna_diversity_eval(rt2x00dev);
+}
+
+void rt2x00link_update_stats(struct rt2x00_dev *rt2x00dev,
+			     struct sk_buff *skb,
+			     struct rxdone_entry_desc *rxdesc)
+{
+	struct link_qual *qual = &rt2x00dev->link.qual;
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int avg_rssi = rxdesc->rssi;
+	int ant_rssi = rxdesc->rssi;
+
+	/*
+	 * Frame was received successfully since non-succesfull
+	 * frames would have been dropped by the hardware.
+	 */
+	qual->rx_success++;
+
+	/*
+	 * We are only interested in quality statistics from
+	 * beacons which came from the BSS which we are
+	 * associated with.
+	 */
+	if (!ieee80211_is_beacon(hdr->frame_control) ||
+	    !(rxdesc->dev_flags & RXDONE_MY_BSS))
+		return;
+
+	/*
+	 * Update global RSSI
+	 */
+	if (qual->avg_rssi)
+		avg_rssi = MOVING_AVERAGE(qual->avg_rssi, rxdesc->rssi, 8);
+	qual->avg_rssi = avg_rssi;
+
+	/*
+	 * Update antenna RSSI
+	 */
+	if (ant->rssi_ant)
+		ant_rssi = MOVING_AVERAGE(ant->rssi_ant, rxdesc->rssi, 8);
+	ant->rssi_ant = ant_rssi;
+}
+
+static void rt2x00link_precalculate_signal(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_qual *qual = &rt2x00dev->link.qual;
+
+	if (qual->rx_failed || qual->rx_success)
+		qual->rx_percentage =
+		    (qual->rx_success * 100) /
+		    (qual->rx_failed + qual->rx_success);
+	else
+		qual->rx_percentage = 50;
+
+	if (qual->tx_failed || qual->tx_success)
+		qual->tx_percentage =
+		    (qual->tx_success * 100) /
+		    (qual->tx_failed + qual->tx_success);
+	else
+		qual->tx_percentage = 50;
+
+	qual->rx_success = 0;
+	qual->rx_failed = 0;
+	qual->tx_success = 0;
+	qual->tx_failed = 0;
+}
+
+int rt2x00link_calculate_signal(struct rt2x00_dev *rt2x00dev, int rssi)
+{
+	struct link_qual *qual = &rt2x00dev->link.qual;
+	int rssi_percentage = 0;
+	int signal;
+
+	/*
+	 * We need a positive value for the RSSI.
+	 */
+	if (rssi < 0)
+		rssi += rt2x00dev->rssi_offset;
+
+	/*
+	 * Calculate the different percentages,
+	 * which will be used for the signal.
+	 */
+	rssi_percentage = (rssi * 100) / rt2x00dev->rssi_offset;
+
+	/*
+	 * Add the individual percentages and use the WEIGHT
+	 * defines to calculate the current link signal.
+	 */
+	signal = ((WEIGHT_RSSI * rssi_percentage) +
+		  (WEIGHT_TX * qual->tx_percentage) +
+		  (WEIGHT_RX * qual->rx_percentage)) / 100;
+
+	return max_t(int, signal, 100);
+}
+
+void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	struct link_qual *qual = &rt2x00dev->link.qual;
+
+	/*
+	 * Link tuning should only be performed when
+	 * an active sta or master interface exists.
+	 * Single monitor mode interfaces should never have
+	 * work with link tuners.
+	 */
+	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
+		return;
+
+	/*
+	 * Clear all (possibly) pre-existing quality statistics.
+	 */
+	memset(qual, 0, sizeof(*qual));
+
+	/*
+	 * The RX and TX percentage should start at 50%
+	 * this will assure we will get at least get some
+	 * decent value when the link tuner starts.
+	 * The value will be dropped and overwritten with
+	 * the correct (measured) value anyway during the
+	 * first run of the link tuner.
+	 */
+	qual->rx_percentage = 50;
+	qual->tx_percentage = 50;
+
+	rt2x00link_reset_tuner(rt2x00dev, false);
+
+	queue_delayed_work(rt2x00dev->hw->workqueue,
+			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+}
+
+void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	cancel_delayed_work_sync(&rt2x00dev->link.work);
+}
+
+void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna)
+{
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Reset link information.
+	 * Both the currently active vgc level as well as
+	 * the link tuner counter should be reset. Resetting
+	 * the counter is important for devices where the
+	 * device should only perform link tuning during the
+	 * first minute after being enabled.
+	 */
+	rt2x00dev->link.count = 0;
+	rt2x00dev->link.vgc_level = 0;
+
+	/*
+	 * Reset the link tuner.
+	 */
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+
+	if (antenna)
+		rt2x00link_antenna_reset(rt2x00dev);
+}
+
+static void rt2x00link_tuner(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, link.work.work);
+	struct link_qual *qual = &rt2x00dev->link.qual;
+
+	/*
+	 * When the radio is shutting down we should
+	 * immediately cease all link tuning.
+	 */
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Update statistics.
+	 */
+	rt2x00dev->ops->lib->link_stats(rt2x00dev, qual);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount += qual->rx_failed;
+
+	/*
+	 * Only perform the link tuning when Link tuning
+	 * has been enabled (This could have been disabled from the EEPROM).
+	 */
+	if (!test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
+		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
+
+	/*
+	 * Precalculate a portion of the link signal which is
+	 * in based on the tx/rx success/failure counters.
+	 */
+	rt2x00link_precalculate_signal(rt2x00dev);
+
+	/*
+	 * Send a signal to the led to update the led signal strength.
+	 */
+	rt2x00leds_led_quality(rt2x00dev, qual->avg_rssi);
+
+	/*
+	 * Evaluate antenna setup, make this the last step since this could
+	 * possibly reset some statistics.
+	 */
+	rt2x00lib_antenna_diversity(rt2x00dev);
+
+	/*
+	 * Increase tuner counter, and reschedule the next link tuner run.
+	 */
+	rt2x00dev->link.count++;
+	queue_delayed_work(rt2x00dev->hw->workqueue,
+			   &rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+}
+
+void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
+{
+	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
+}
-- 
1.5.6.1

