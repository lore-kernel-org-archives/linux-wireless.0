Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58402 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZLVXPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:15:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rtl8187: remove priv->mode
Date: Tue, 22 Dec 2009 18:13:05 -0500
Message-Id: <1261523585-20635-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1261523585-20635-1-git-send-email-linville@tuxdriver.com>
References: <1261523585-20635-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is checked in add_interface, but there it is easily replaced with
a check of priv->vif.  If that information should become necessary,
it is available in vif->type anyway.

It is also checked in led_turn_on and led_turn_off, where I made the
substitutions as described above.  Of course, these checks seem to
have been incorrect since the driver was using NL80211_IFTYPE_MONITOR
to indicate no interface rather than NL80211_IFTYPE_UNSPECIFIED.
Anyway, I think these checks may be extraneous...?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187.h      |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    5 +----
 drivers/net/wireless/rtl818x/rtl8187_leds.c |    4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index 6af0f3f..6bb3211 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -92,7 +92,7 @@ struct rtl8187_priv {
 	struct rtl818x_csr *map;
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
-	int mode;
+
 	/* The mutex protects the TX loopback state.
 	 * Any attempt to set channels concurrently locks the device.
 	 */
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index bc5726d..76da3e6 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1025,12 +1025,11 @@ static int rtl8187_add_interface(struct ieee80211_hw *dev,
 	int ret = -EOPNOTSUPP;
 
 	mutex_lock(&priv->conf_mutex);
-	if (priv->mode != NL80211_IFTYPE_MONITOR)
+	if (priv->vif != NULL)
 		goto exit;
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		priv->mode = conf->type;
 		break;
 	default:
 		goto exit;
@@ -1055,7 +1054,6 @@ static void rtl8187_remove_interface(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	mutex_lock(&priv->conf_mutex);
-	priv->mode = NL80211_IFTYPE_MONITOR;
 	priv->vif = NULL;
 	mutex_unlock(&priv->conf_mutex);
 }
@@ -1365,7 +1363,6 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 
-	priv->mode = NL80211_IFTYPE_MONITOR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index ded44c0..f82aa8b 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -33,7 +33,7 @@ static void led_turn_on(struct work_struct *work)
 	struct rtl8187_led *led = &priv->led_tx;
 
 	/* Don't change the LED, when the device is down. */
-	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+	if (!priv->vif || priv->vif->type == NL80211_IFTYPE_UNSPECIFIED)
 		return ;
 
 	/* Skip if the LED is not registered. */
@@ -71,7 +71,7 @@ static void led_turn_off(struct work_struct *work)
 	struct rtl8187_led *led = &priv->led_tx;
 
 	/* Don't change the LED, when the device is down. */
-	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+	if (!priv->vif || priv->vif->type == NL80211_IFTYPE_UNSPECIFIED)
 		return ;
 
 	/* Skip if the LED is not registered. */
-- 
1.6.2.5

