Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab1DRNgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:24 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833934fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 23/23] rt2x00: Implement get_antenna and set_antenna callback functions
Date: Mon, 18 Apr 2011 15:35:12 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181534.23133.IvDoorn@gmail.com> <201104181534.42625.IvDoorn@gmail.com>
In-Reply-To: <201104181534.42625.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181535.12907.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Implement the get_antenna and set_antenna callback functions, which will
allow clients to control the antenna for all non-11n hardware (Antenna handling
in rt2800 is still a bit magical, so we can't use the set_antenna for those drivers
yet).

To best support the set_antenna callback some modifications are needed in the
diversity handling. We should never look at the default antenna settings to determine
if software diversity is enabled. Instead we should set the diversity flag when
possible, which will allow the link_tuner to automatically pick up the tuning.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    2 +
 drivers/net/wireless/rt2x00/rt2500pci.c    |    2 +
 drivers/net/wireless/rt2x00/rt2500usb.c    |    2 +
 drivers/net/wireless/rt2x00/rt2x00.h       |    2 +
 drivers/net/wireless/rt2x00/rt2x00config.c |   45 +++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00link.c   |   10 ----
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   65 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c      |    2 +
 drivers/net/wireless/rt2x00/rt73usb.c      |    2 +
 9 files changed, 103 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index bbe76f7..937f9e8 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1720,6 +1720,8 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.set_antenna		= rt2x00mac_set_antenna,
+	.get_antenna		= rt2x00mac_get_antenna,
 	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 6f48996..d27d7b8 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2013,6 +2013,8 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.set_antenna		= rt2x00mac_set_antenna,
+	.get_antenna		= rt2x00mac_get_antenna,
 	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5ef3386..b21f812 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1823,6 +1823,8 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.conf_tx		= rt2x00mac_conf_tx,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.set_antenna		= rt2x00mac_set_antenna,
+	.get_antenna		= rt2x00mac_get_antenna,
 	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index f1d8f55..acf561f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1254,6 +1254,8 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
 void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop);
+int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
+int rt2x00mac_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
 			     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index f70a2b4..2a313b6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -109,15 +109,6 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp, changed);
 }
 
-static inline
-enum antenna rt2x00lib_config_antenna_check(enum antenna current_ant,
-					    enum antenna default_ant)
-{
-	if (current_ant != ANTENNA_SW_DIVERSITY)
-		return current_ant;
-	return (default_ant != ANTENNA_SW_DIVERSITY) ? default_ant : ANTENNA_B;
-}
-
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 			      struct antenna_setup config)
 {
@@ -126,19 +117,35 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	struct antenna_setup *active = &rt2x00dev->link.ant.active;
 
 	/*
-	 * Failsafe: Make sure we are not sending the
-	 * ANTENNA_SW_DIVERSITY state to the driver.
-	 * If that happens, fallback to hardware defaults,
-	 * or our own default.
+	 * When the caller tries to send the SW diversity,
+	 * we must update the ANTENNA_RX_DIVERSITY flag to
+	 * enable the antenna diversity in the link tuner.
+	 *
+	 * Secondly, we must guarentee we never send the
+	 * software antenna diversity command to the driver.
 	 */
-	if (!(ant->flags & ANTENNA_RX_DIVERSITY))
-		config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
-	else if (config.rx == ANTENNA_SW_DIVERSITY)
+	if (!(ant->flags & ANTENNA_RX_DIVERSITY)) {
+		if (config.rx == ANTENNA_SW_DIVERSITY) {
+			ant->flags |= ANTENNA_RX_DIVERSITY;
+
+			if (def->rx == ANTENNA_SW_DIVERSITY)
+				config.rx = ANTENNA_B;
+			else
+				config.rx = def->rx;
+		}
+	} else if (config.rx == ANTENNA_SW_DIVERSITY)
 		config.rx = active->rx;
 
-	if (!(ant->flags & ANTENNA_TX_DIVERSITY))
-		config.tx = rt2x00lib_config_antenna_check(config.tx, def->tx);
-	else if (config.tx == ANTENNA_SW_DIVERSITY)
+	if (!(ant->flags & ANTENNA_TX_DIVERSITY)) {
+		if (config.tx == ANTENNA_SW_DIVERSITY) {
+			ant->flags |= ANTENNA_TX_DIVERSITY;
+
+			if (def->tx == ANTENNA_SW_DIVERSITY)
+				config.tx = ANTENNA_B;
+			else
+				config.tx = def->tx;
+		}
+	} else if (config.tx == ANTENNA_SW_DIVERSITY)
 		config.tx = active->tx;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index ba0bb76..fa55399 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -192,17 +192,7 @@ static bool rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine if software diversity is enabled for
 	 * either the TX or RX antenna (or both).
-	 * Always perform this check since within the link
-	 * tuner interval the configuration might have changed.
 	 */
-	ant->flags &= ~ANTENNA_RX_DIVERSITY;
-	ant->flags &= ~ANTENNA_TX_DIVERSITY;
-
-	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
-		ant->flags |= ANTENNA_RX_DIVERSITY;
-	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-		ant->flags |= ANTENNA_TX_DIVERSITY;
-
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY) &&
 	    !(ant->flags & ANTENNA_TX_DIVERSITY)) {
 		ant->flags = 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 6d1d383..93bec14 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -738,6 +738,71 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
 
+int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	struct antenna_setup *def = &rt2x00dev->default_ant;
+	struct antenna_setup setup;
+
+	// The antenna value is not supposed to be 0,
+	// or exceed the maximum number of antenna's.
+	if (!tx_ant || (tx_ant & ~3) || !rx_ant || (rx_ant & ~3))
+		return -EINVAL;
+
+	// When the client tried to configure the antenna to or from
+	// diversity mode, we must reset the default antenna as well
+	// as that controls the diversity switch.
+	if (ant->flags & ANTENNA_TX_DIVERSITY && tx_ant != 3)
+		ant->flags &= ~ANTENNA_TX_DIVERSITY;
+	if (ant->flags & ANTENNA_RX_DIVERSITY && rx_ant != 3)
+		ant->flags &= ~ANTENNA_RX_DIVERSITY;
+
+	// If diversity is being enabled, check if we need hardware
+	// or software diversity. In the latter case, reset the value,
+	// and make sure we update the antenna flags to have the
+	// link tuner pick up the diversity tuning.
+	if (tx_ant == 3 && def->tx == ANTENNA_SW_DIVERSITY) {
+		tx_ant = ANTENNA_SW_DIVERSITY;
+		ant->flags |= ANTENNA_TX_DIVERSITY;
+	}
+
+	if (rx_ant == 3 && def->rx == ANTENNA_SW_DIVERSITY) {
+		rx_ant = ANTENNA_SW_DIVERSITY;
+		ant->flags |= ANTENNA_RX_DIVERSITY;
+	}
+
+	setup.tx = tx_ant;
+	setup.rx = rx_ant;
+
+	rt2x00lib_config_antenna(rt2x00dev, setup);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_set_antenna);
+
+int rt2x00mac_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct link_ant *ant = &rt2x00dev->link.ant;
+	struct antenna_setup *active = &rt2x00dev->link.ant.active;
+
+	// When software diversity is active, we must report this to the
+	// client and not the current active antenna state.
+	if (ant->flags & ANTENNA_TX_DIVERSITY)
+		*tx_ant = ANTENNA_HW_DIVERSITY;
+	else
+		*tx_ant = active->tx;
+
+	if (ant->flags & ANTENNA_RX_DIVERSITY)
+		*rx_ant = ANTENNA_HW_DIVERSITY;
+	else
+		*rx_ant = active->rx;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_get_antenna);
+
 void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
 			     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
 {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index eb54031..9d35ec1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2979,6 +2979,8 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.get_tsf		= rt61pci_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.set_antenna		= rt2x00mac_set_antenna,
+	.get_antenna		= rt2x00mac_get_antenna,
 	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index bf7fea4..a6ce7d6 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2310,6 +2310,8 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.get_tsf		= rt73usb_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.set_antenna		= rt2x00mac_set_antenna,
+	.get_antenna		= rt2x00mac_get_antenna,
 	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
-- 
1.7.2.3

