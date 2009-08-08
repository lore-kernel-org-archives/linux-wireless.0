Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:38598 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZHHV4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:10 -0400
Received: by ewy7 with SMTP id 7so1937875ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Remove usage of deprecated radio_enabled & IEEE80211_CONF_CHANGE_RADIO_ENABLED
Date: Sat, 8 Aug 2009 23:53:04 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082353.04274.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the config() callback function the fields radio_enabled and
the change flag IEEE80211_CONF_CHANGE_RADIO_ENABLED have been
deprecated. This removes the usage of those fields by improving
antenna change detection in the antenna configuration function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |   22 ++++++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    7 ++++
 drivers/net/wireless/rt2x00/rt2x00link.c   |   12 ++++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   54 ++++++++++------------------
 4 files changed, 50 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 3845316..3501788 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -124,8 +124,9 @@ enum antenna rt2x00lib_config_antenna_check(enum antenna current_ant,
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
-			      struct antenna_setup ant)
+			      struct antenna_setup config)
 {
+	struct link_ant *ant = &rt2x00dev->link.ant;
 	struct antenna_setup *def = &rt2x00dev->default_ant;
 	struct antenna_setup *active = &rt2x00dev->link.ant.active;
 
@@ -134,14 +135,23 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * ANTENNA_SW_DIVERSITY state to the driver.
 	 * If that happens, fallback to hardware defaults,
 	 * or our own default.
+	 * If diversity handling is active for a particular antenna,
+	 * we shouldn't overwrite that antenna.
 	 * The calls to rt2x00lib_config_antenna_check()
 	 * might have caused that we restore back to the already
 	 * active setting. If that has happened we can quit.
 	 */
-	ant.rx = rt2x00lib_config_antenna_check(ant.rx, def->rx);
-	ant.tx = rt2x00lib_config_antenna_check(ant.tx, def->tx);
+	if (!(ant->flags & ANTENNA_RX_DIVERSITY))
+		config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
+	else
+		config.rx = active->rx;
 
-	if (ant.rx == active->rx && ant.tx == active->tx)
+	if (!(ant->flags & ANTENNA_TX_DIVERSITY))
+		config.tx = rt2x00lib_config_antenna_check(config.tx, def->tx);
+	else
+		config.tx = active->tx;
+
+	if (config.rx == active->rx && config.tx == active->tx)
 		return;
 
 	/*
@@ -156,11 +166,11 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * The latter is required since we need to recalibrate the
 	 * noise-sensitivity ratio for the new setup.
 	 */
-	rt2x00dev->ops->lib->config_ant(rt2x00dev, &ant);
+	rt2x00dev->ops->lib->config_ant(rt2x00dev, &config);
 
 	rt2x00link_reset_tuner(rt2x00dev, true);
 
-	memcpy(active, &ant, sizeof(ant));
+	memcpy(active, &config, sizeof(config));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index db54fcc..e0348cc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -785,6 +785,13 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_sta_count = 0;
 	rt2x00dev->intf_associated = 0;
 
+	/* Enable the radio */
+	retval = rt2x00lib_enable_radio(rt2x00dev);
+	if (retval) {
+		rt2x00queue_uninitialize(rt2x00dev);
+		return retval;
+	}
+
 	set_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 9178316..fe951dc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -219,6 +219,7 @@ static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
 static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
+	unsigned int flags = ant->flags;
 
 	/*
 	 * Determine if software diversity is enabled for
@@ -226,13 +227,13 @@ static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 	 * Always perform this check since within the link
 	 * tuner interval the configuration might have changed.
 	 */
-	ant->flags &= ~ANTENNA_RX_DIVERSITY;
-	ant->flags &= ~ANTENNA_TX_DIVERSITY;
+	flags &= ~ANTENNA_RX_DIVERSITY;
+	flags &= ~ANTENNA_TX_DIVERSITY;
 
 	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
-		ant->flags |= ANTENNA_RX_DIVERSITY;
+		flags |= ANTENNA_RX_DIVERSITY;
 	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-		ant->flags |= ANTENNA_TX_DIVERSITY;
+		flags |= ANTENNA_TX_DIVERSITY;
 
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY) &&
 	    !(ant->flags & ANTENNA_TX_DIVERSITY)) {
@@ -240,6 +241,9 @@ static void rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
+	/* Update flags */
+	ant->flags = flags;
+
 	/*
 	 * If we have only sampled the data over the last period
 	 * we should now harvest the data. Otherwise just evaluate
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 81febdf..4164fce 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -338,7 +338,6 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	int status;
 
 	/*
 	 * mac80211 might be calling this function while we are trying
@@ -348,44 +347,29 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 		return 0;
 
 	/*
-	 * Only change device state when the radio is enabled. It does not
-	 * matter what parameters we have configured when the radio is disabled
-	 * because we won't be able to send or receive anyway. Also note that
-	 * some configuration parameters (e.g. channel and antenna values) can
-	 * only be set when the radio is enabled.
+	 * Some configuration parameters (e.g. channel and antenna values) can
+	 * only be set when the radio is enabled, but do require the RX to
+	 * be off.
 	 */
-	if (conf->radio_enabled) {
-		/* For programming the values, we have to turn RX off */
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 
-		/* Enable the radio */
-		status = rt2x00lib_enable_radio(rt2x00dev);
-		if (unlikely(status))
-			return status;
+	/*
+	 * When we've just turned on the radio, we want to reprogram
+	 * everything to ensure a consistent state
+	 */
+	rt2x00lib_config(rt2x00dev, conf, changed);
 
-		/*
-		 * When we've just turned on the radio, we want to reprogram
-		 * everything to ensure a consistent state
-		 */
-		rt2x00lib_config(rt2x00dev, conf, changed);
+	/*
+	 * After the radio has been enabled we need to configure
+	 * the antenna to the default settings. rt2x00lib_config_antenna()
+	 * should determine if any action should be taken based on
+	 * checking if diversity has been enabled or no antenna changes
+	 * have been made since the last configuration change.
+	 */
+	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
-		/*
-		 * The radio was enabled, configure the antenna to the
-		 * default settings, the link tuner will later start
-		 * continue configuring the antenna based on the software
-		 * diversity. But for non-diversity configurations, we need
-		 * to have configured the correct state now.
-		 */
-		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED)
-			rt2x00lib_config_antenna(rt2x00dev,
-						 rt2x00dev->default_ant);
-
-		/* Turn RX back on */
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-	} else {
-		/* Disable the radio */
-		rt2x00lib_disable_radio(rt2x00dev);
-	}
+	/* Turn RX back on */
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 
 	return 0;
 }
-- 
1.6.3.3

