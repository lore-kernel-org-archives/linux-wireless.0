Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYKAXiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:38:25 -0400
Received: by ey-out-2122.google.com with SMTP id 6so664663eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 16:38:24 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4] rt2x00: Fix BUG_ON() with antenna handling
Date: Sun, 2 Nov 2008 00:38:10 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200811020036.40746.IvDoorn@gmail.com> <200811020037.09726.IvDoorn@gmail.com> <200811020037.25439.IvDoorn@gmail.com>
In-Reply-To: <200811020037.25439.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811020038.10589.IvDoorn@gmail.com> (sfid-20081102_003836_698789_66F7D77F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new configuration handling, and more specifically
splitting the configuration of the antenna from the normal
configuration steps allowed a BUG_ON() to be triggered
in the driver because the SW_DIVERSITY was send to the
driver. This fixes that by catching the value early in
rt2x00config.c and replacing it with a sensible value.

This also fixes a problem where the antenna is not being
initialized at all when the radio is enabled. Since it
no longer is part of the mac80211 configuration the
only place where rt2x00 configured it was the SW diversity
handler. Obviously this is broken for all non-diversity
hardware and breaks SW diversity due to a broken initialization.

When the radio is enabled the antenna will be configured
once as soon as the config() callback function is called.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |   35 ++++++++++++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   22 +++++++++--------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   13 ++++++++-
 5 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index f85eedb..8fa971c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -723,8 +723,7 @@ struct rt2x00_dev {
 
 	/*
 	 * This is the default TX/RX antenna setup as indicated
-	 * by the device's EEPROM. When mac80211 sets its
-	 * antenna value to 0 we should be using these values.
+	 * by the device's EEPROM.
 	 */
 	struct antenna_setup default_ant;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 3e4eee3..1059b4d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -109,15 +109,32 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
-			      enum antenna rx, enum antenna tx)
+			      struct antenna_setup *ant)
 {
-	struct antenna_setup ant;
-
-	ant.rx = rx;
-	ant.tx = tx;
+	/*
+	 * Failsafe: Make sure we are not sending the
+	 * ANTENNA_SW_DIVERSITY state to the driver.
+	 * If that happes fallback to hardware default,
+	 * or our own default.
+	 */
+	if (ant->rx == ANTENNA_SW_DIVERSITY) {
+		if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
+			ant->rx = ANTENNA_B;
+		else
+			ant->rx = rt2x00dev->default_ant.rx;
+	}
+	if (ant->tx == ANTENNA_SW_DIVERSITY) {
+		if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
+			ant->tx = ANTENNA_B;
+		else
+			ant->tx = rt2x00dev->default_ant.tx;
+	}
 
-	if (rx == rt2x00dev->link.ant.active.rx &&
-	    tx == rt2x00dev->link.ant.active.tx)
+	/*
+	 * Only reconfigure when something has changed.
+	 */
+	if (ant->rx == rt2x00dev->link.ant.active.rx &&
+	    ant->tx == rt2x00dev->link.ant.active.tx)
 		return;
 
 	/*
@@ -132,12 +149,12 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * The latter is required since we need to recalibrate the
 	 * noise-sensitivity ratio for the new setup.
 	 */
-	rt2x00dev->ops->lib->config_ant(rt2x00dev, &ant);
+	rt2x00dev->ops->lib->config_ant(rt2x00dev, ant);
 
 	rt2x00lib_reset_link_tuner(rt2x00dev);
 	rt2x00_reset_link_ant_rssi(&rt2x00dev->link);
 
-	memcpy(&rt2x00dev->link.ant.active, &ant, sizeof(ant));
+	memcpy(&rt2x00dev->link.ant.active, ant, sizeof(*ant));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a8fee68..e8ca1cb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -176,13 +176,14 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 
 static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
 {
-	enum antenna rx = rt2x00dev->link.ant.active.rx;
-	enum antenna tx = rt2x00dev->link.ant.active.tx;
+	struct antenna_setup ant;
 	int sample_a =
 	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_A);
 	int sample_b =
 	    rt2x00_get_link_ant_rssi_history(&rt2x00dev->link, ANTENNA_B);
 
+	memcpy(&ant, &rt2x00dev->link.ant.active, sizeof(ant));
+
 	/*
 	 * We are done sampling. Now we should evaluate the results.
 	 */
@@ -200,21 +201,22 @@ static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
-		rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+		ant.rx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
-		tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
+		ant.tx = (sample_a > sample_b) ? ANTENNA_A : ANTENNA_B;
 
-	rt2x00lib_config_antenna(rt2x00dev, rx, tx);
+	rt2x00lib_config_antenna(rt2x00dev, &ant);
 }
 
 static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
 {
-	enum antenna rx = rt2x00dev->link.ant.active.rx;
-	enum antenna tx = rt2x00dev->link.ant.active.tx;
+	struct antenna_setup ant;
 	int rssi_curr = rt2x00_get_link_ant_rssi(&rt2x00dev->link);
 	int rssi_old = rt2x00_update_ant_rssi(&rt2x00dev->link, rssi_curr);
 
+	memcpy(&ant, &rt2x00dev->link.ant.active, sizeof(ant));
+
 	/*
 	 * Legacy driver indicates that we should swap antenna's
 	 * when the difference in RSSI is greater that 5. This
@@ -230,12 +232,12 @@ static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY)
-		rx = (rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+		ant.rx = (ant.rx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)
-		tx = (tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
+		ant.tx = (ant.tx == ANTENNA_A) ? ANTENNA_B : ANTENNA_A;
 
-	rt2x00lib_config_antenna(rt2x00dev, rx, tx);
+	rt2x00lib_config_antenna(rt2x00dev, &ant);
 }
 
 static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index c52ee21..0c3a355 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -93,7 +93,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
 			  struct ieee80211_bss_conf *conf);
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
-			      enum antenna rx, enum antenna tx);
+			      struct antenna_setup *ant);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf,
 		      const unsigned int changed_flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 188f891..48636b0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -339,7 +339,6 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	int radio_on;
 	int status;
 
 	/*
@@ -356,7 +355,6 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 * some configuration parameters (e.g. channel and antenna values) can
 	 * only be set when the radio is enabled.
 	 */
-	radio_on = test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags);
 	if (conf->radio_enabled) {
 		/* For programming the values, we have to turn RX off */
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
@@ -372,6 +370,17 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 		 */
 		rt2x00lib_config(rt2x00dev, conf, changed);
 
+		/*
+		 * The radio was enabled, configure the antenna to the
+		 * default settings, the link tuner will later start
+		 * continue configuring the antenna based on the software
+		 * diversity. But for non-diversity configurations, we need
+		 * to have configured the correct state now.
+		 */
+		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED)
+			rt2x00lib_config_antenna(rt2x00dev,
+						 &rt2x00dev->default_ant);
+
 		/* Turn RX back on */
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 	} else {
-- 
1.5.6.1

