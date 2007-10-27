Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXJ0LZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:02 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973056nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:01 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/21] rt2x00: Implement SW diversity
Date: Sat, 27 Oct 2007 13:37:48 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271337.48426.IvDoorn@gmail.com> (sfid-20071027_122519_241110_55E54E27)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 indicates that the default antenna setup
should be used _and_ that this default setup is SW_DIVERSITY.

This requires sampling and storing the RSSI per antenna
and check once every 2 seconds to determine if the RSSI
has changed significantly. Once this is the case we should sample
the other antenna for a short period and evaluate if
we need to swap antenna or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |   87 ++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00config.c |   26 +++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  138 +++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    2 +
 4 files changed, 232 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index acf6f1c..c9df8f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -241,6 +241,43 @@ struct link_qual {
 };
 
 /*
+ * Antenna settings about the currently active link.
+ */
+struct link_ant {
+	/*
+	 * Antenna flags
+	 */
+	unsigned int flags;
+#define ANTENNA_RX_DIVERSITY	0x00000001
+#define ANTENNA_TX_DIVERSITY	0x00000002
+#define ANTENNA_MODE_SAMPLE	0x00000004
+
+	/*
+	 * Currently active TX/RX antenna setup.
+	 * When software diversity is used, this will indicate
+	 * which antenna is actually used at this time.
+	 */
+	struct antenna_setup active;
+
+	/*
+	 * RSSI information for the different antenna's.
+	 * These statistics are used to determine when
+	 * to switch antenna when using software diversity.
+	 *
+	 *        rssi[0] -> Antenna A RSSI
+	 *        rssi[1] -> Antenna B RSSI
+	 */
+	int rssi_history[2];
+
+	/*
+	 * Current RSSI average of the currently active antenna.
+	 * Similar to the avg_rssi in the link_qual structure
+	 * this value is updated by using the walking average.
+	 */
+	int rssi_ant;
+};
+
+/*
  * To optimize the quality of the link we need to store
  * the quality of received frames and periodically
  * optimize the link.
@@ -259,11 +296,9 @@ struct link {
 	struct link_qual qual;
 
 	/*
-	 * Currently active TX/RX antenna setup.
-	 * When software diversity is used, this will indicate
-	 * which antenna is actually used at this time.
+	 * TX/RX antenna setup.
 	 */
-	struct antenna_setup active_ant;
+	struct link_ant ant;
 
 	/*
 	 * Active VGC level
@@ -277,25 +312,47 @@ struct link {
 };
 
 /*
- * Update the rssi using the walking average approach.
+ * Small helper macro to work with moving/walking averages.
  */
-static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
-{
-	if (link->qual.avg_rssi)
-		rssi = ((link->qual.avg_rssi * 7) + rssi) / 8;
-	link->qual.avg_rssi = rssi;
-}
+#define MOVING_AVERAGE(__avg, __val, __samples) \
+	( (((__avg) * ((__samples) - 1)) + (__val)) / (__samples) )
+
+/*
+ * When we lack RSSI information return something less then -80 to
+ * tell the driver to tune the device to maximum sensitivity.
+ */
+#define DEFAULT_RSSI	( -128 )
 
 /*
- * When the avg_rssi is unset or no frames  have been received),
- * we need to return the default value which needs to be less
- * than -80 so the device will select the maximum sensitivity.
+ * Link quality access functions.
  */
 static inline int rt2x00_get_link_rssi(struct link *link)
 {
 	if (link->qual.avg_rssi && link->qual.rx_success)
 		return link->qual.avg_rssi;
-	return -128;
+	return DEFAULT_RSSI;
+}
+
+static inline int rt2x00_get_link_ant_rssi(struct link *link)
+{
+	if (link->ant.rssi_ant && link->qual.rx_success)
+		return link->ant.rssi_ant;
+	return DEFAULT_RSSI;
+}
+
+static inline int rt2x00_get_link_ant_rssi_history(struct link *link,
+						   enum antenna ant)
+{
+	if (link->ant.rssi_history[ant - ANTENNA_A])
+		return link->ant.rssi_history[ant - ANTENNA_A];
+	return DEFAULT_RSSI;
+}
+
+static inline int rt2x00_update_ant_rssi(struct link *link, int rssi)
+{
+	int old_rssi = link->ant.rssi_history[link->ant.active.rx - ANTENNA_A];
+	link->ant.rssi_history[link->ant.active.rx - ANTENNA_A] = rssi;
+	return old_rssi;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 04518b0..2b0edd2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -94,6 +94,26 @@ void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00dev->ops->lib->config_type(rt2x00dev, type, tsf_sync);
 }
 
+void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
+			      enum antenna rx, enum antenna tx)
+{
+	struct rt2x00lib_conf libconf;
+
+	libconf.ant.rx = rx;
+	libconf.ant.tx = tx;
+
+	/*
+	 * Write new antenna setup to device and reset the link tuner.
+	 * The latter is required since we need to recalibrate the
+	 * noise-sensitivity ratio for the new setup.
+	 */
+	rt2x00dev->ops->lib->config(rt2x00dev, CONFIG_UPDATE_ANTENNA, &libconf);
+	rt2x00lib_reset_link_tuner(rt2x00dev);
+
+	rt2x00dev->link.ant.active.rx = libconf.ant.rx;
+	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
+}
+
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf, const int force_config)
 {
@@ -101,7 +121,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 	struct antenna_setup *default_ant = &rt2x00dev->default_ant;
-	struct antenna_setup *active_ant = &rt2x00dev->link.active_ant;
+	struct antenna_setup *active_ant = &rt2x00dev->link.ant.active;
 	int flags = 0;
 	int short_slot_time;
 
@@ -247,6 +267,6 @@ config:
 	rt2x00dev->rx_status.freq = conf->freq;
 	rt2x00dev->rx_status.channel = conf->channel;
 	rt2x00dev->tx_power = conf->power_level;
-	rt2x00dev->link.active_ant.rx = libconf.ant.rx;
-	rt2x00dev->link.active_ant.tx = libconf.ant.tx;
+	rt2x00dev->link.ant.active.rx = libconf.ant.rx;
+	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0f824b2..360f03a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -193,6 +193,133 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 		rt2x00lib_start_link_tuner(rt2x00dev);
 }
 
+static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
+{
+	enum antenna rx = rt2x00dev->link.ant.active.rx;
+	enum antenna tx = rt2x00dev->link.ant.active.tx;
+	int sample_a =
+	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_A);
+	int sample_b =
+	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_B);
+
+	/*
+	 * We are done sampling. Now we should evaluate the results.
+	 */
+	rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
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
+	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) {
+		if (sample_a > sample_b && rx == ANTENNA_B)
+			rx = ANTENNA_A;
+		else if (rx == ANTENNA_A)
+			rx = ANTENNA_B;
+	}
+
+	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY) {
+		if (sample_a > sample_b && tx == ANTENNA_B)
+			tx = ANTENNA_A;
+		else if (tx == ANTENNA_A)
+			tx = ANTENNA_B;
+	}
+
+	rt2x00lib_config_antenna(rt2x00dev, rx, tx);
+}
+
+static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
+{
+	enum antenna rx = rt2x00dev->link.ant.active.rx;
+	enum antenna tx = rt2x00dev->link.ant.active.tx;
+	int rssi_curr = rt2x00_get_link_ant_rssi(&rt2x00dev->link);
+	int rssi_old = rt2x00_update_ant_rssi(&rt2x00dev->link, rssi_curr);
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
+	if ((rssi_curr - rssi_old) > -5 || (rssi_curr - rssi_old) < 5)
+		return;
+
+	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
+
+	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
+		rx = (rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+
+	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
+		tx = (tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+
+	rt2x00lib_config_antenna(rt2x00dev, rx, tx);
+}
+
+static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
+{
+	/*
+	 * Determine if software diversity is enabled for
+	 * either the TX or RX antenna (or both).
+	 * Always perform this check since within the link
+	 * tuner interval the configuration might have changed.
+	 */
+	rt2x00dev->link.ant.flags &= ~ANTENNA_RX_DIVERSITY;
+	rt2x00dev->link.ant.flags &= ~ANTENNA_TX_DIVERSITY;
+
+	if (rt2x00dev->hw->conf.antenna_sel_rx == 0 &&
+	    rt2x00dev->default_ant.rx != ANTENNA_SW_DIVERSITY)
+		rt2x00dev->link.ant.flags |= ANTENNA_RX_DIVERSITY;
+	if (rt2x00dev->hw->conf.antenna_sel_tx == 0 &&
+	    rt2x00dev->default_ant.tx != ANTENNA_SW_DIVERSITY)
+		rt2x00dev->link.ant.flags |= ANTENNA_TX_DIVERSITY;
+
+	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
+	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
+		rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
+		return;
+	}
+
+	/*
+	 * If we have only sampled the data over the last period
+	 * we should now harvest the data. Otherwise just evaluate
+	 * the data. The latter should only be performed once
+	 * every 2 seconds.
+	 */
+	if (rt2x00dev->link.ant.flags & ANTENNA_MODE_SAMPLE)
+		rt2x00lib_evaluate_antenna_sample(rt2x00dev);
+	else if (rt2x00dev->link.count & 1)
+		rt2x00lib_evaluate_antenna_eval(rt2x00dev);
+}
+
+static void rt2x00lib_update_link_stats(struct link *link, int rssi)
+{
+	int avg_rssi = rssi;
+
+	/*
+	 * Update global RSSI
+	 */
+	if (link->qual.avg_rssi)
+		avg_rssi = MOVING_AVERAGE(link->qual.avg_rssi, rssi, 8);
+	link->qual.avg_rssi = avg_rssi;
+
+	/*
+	 * Update antenna RSSI
+	 */
+	if (link->ant.rssi_ant)
+		rssi = MOVING_AVERAGE(link->ant.rssi_ant, rssi, 8);
+	link->ant.rssi_ant = rssi;
+}
+
 static void rt2x00lib_precalculate_link_signal(struct link_qual *qual)
 {
 	if (qual->rx_failed || qual->rx_success)
@@ -261,7 +388,6 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	 * Update statistics.
 	 */
 	rt2x00dev->ops->lib->link_stats(rt2x00dev, &rt2x00dev->link.qual);
-
 	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
 	    rt2x00dev->link.qual.rx_failed;
 
@@ -273,6 +399,11 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
+	 * Evaluate antenna setup.
+	 */
+	rt2x00lib_evaluate_antenna(rt2x00dev);
+
+	/*
 	 * Precalculate a portion of the link signal which is
 	 * in based on the tx/rx success/failure counters.
 	 */
@@ -426,14 +557,15 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		}
 	}
 
-	rt2x00_update_link_rssi(&rt2x00dev->link, desc->rssi);
+	rt2x00lib_update_link_stats(&rt2x00dev->link, desc->rssi);
 	rt2x00dev->link.qual.rx_success++;
+
 	rx_status->rate = val;
 	rx_status->signal =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, desc->rssi);
 	rx_status->ssi = desc->rssi;
 	rx_status->flag = desc->flags;
-	rx_status->antenna = rt2x00dev->link.active_ant.rx;
+	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	/*
 	 * Send frame to mac80211
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 06d9bc0..7319411 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -53,6 +53,8 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type);
+void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
+			      enum antenna rx, enum antenna tx);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf, const int force_config);
 
-- 
1.5.3.4

