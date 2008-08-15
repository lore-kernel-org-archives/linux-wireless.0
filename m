Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:20144 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbYHOMtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 08:49:53 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644050nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2008 05:49:52 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Only configure hardware when radio is enabled
Date: Fri, 15 Aug 2008 14:48:53 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Mattias Nissler <mattias.nissler@gmx.de>
References: <200808151445.07795.IvDoorn@gmail.com> <200808151445.31803.IvDoorn@gmail.com> <200808151446.01043.IvDoorn@gmail.com>
In-Reply-To: <200808151446.01043.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200808151448.53934.IvDoorn@gmail.com> (sfid-20080815_144959_399745_5122C6BB)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Some hardware configuration registers such as antenna and channel configuration
can only be written when the radio is enabled. Previously, we didn't consider
this, so some configuration items could be set inconsistently after reenabling
the radio. This patch changes the config() handler to only reprogram the
hardware when the radio is enabled. Configuration changes that are made while
the radio is off are postponed until the radio is switched back on. We also
leave the radio turned off during initialization and only enable it when
requested by mac80211. This allows us to get rid of the DIRTY_CONFIG flag,
because the device is now guaranteed to be completely initialized when brought
up by mac80211.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please queue for 2.6.27 and 2.6.28
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00dev.c |   10 ------
 drivers/net/wireless/rt2x00/rt2x00mac.c |   50 +++++++++++++++---------------
 3 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7842524..0a6f35e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -636,7 +636,6 @@ enum rt2x00_flags {
 	DEVICE_STATE_STARTED_SUSPEND,
 	DEVICE_STATE_ENABLED_RADIO,
 	DEVICE_STATE_DISABLED_RADIO_HW,
-	DEVICE_STATE_DIRTY_CONFIG,
 
 	/*
 	 * Driver requirements
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 330ab77..5278ae2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1014,21 +1014,11 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	if (retval)
 		return retval;
 
-	/*
-	 * Enable radio.
-	 */
-	retval = rt2x00lib_enable_radio(rt2x00dev);
-	if (retval) {
-		rt2x00lib_uninitialize(rt2x00dev);
-		return retval;
-	}
-
 	rt2x00dev->intf_ap_count = 0;
 	rt2x00dev->intf_sta_count = 0;
 	rt2x00dev->intf_associated = 0;
 
 	set_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags);
-	set_bit(DEVICE_STATE_DIRTY_CONFIG, &rt2x00dev->flags);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 11be895..64292c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -338,7 +338,8 @@ EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int force_reconfig;
+	int radio_on;
+	int status;
 
 	/*
 	 * Mac80211 might be calling this function while we are trying
@@ -348,35 +349,34 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 		return 0;
 
 	/*
-	 * Check if we need to disable the radio,
-	 * if this is not the case, at least the RX must be disabled.
+	 * Only change device state when the radio is enabled. It does not
+	 * matter what parameters we have configured when the radio is disabled
+	 * because we won't be able to send or receive anyway. Also note that
+	 * some configuration parameters (e.g. channel and antenna values) can
+	 * only be set when the radio is enabled.
 	 */
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags)) {
-		if (!conf->radio_enabled)
-			rt2x00lib_disable_radio(rt2x00dev);
-		else
-			rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
-	}
+	radio_on = test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags);
+	if (conf->radio_enabled) {
+		/* For programming the values, we have to turn RX off */
+		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
 
-	/*
-	 * When the DEVICE_DIRTY_CONFIG flag is set, the device has recently
-	 * been started and the configuration must be forced upon the hardware.
-	 * Otherwise registers will not be intialized correctly and could
-	 * result in non-working hardware because essential registers aren't
-	 * initialized.
-	 */
-	force_reconfig =
-	    test_and_clear_bit(DEVICE_STATE_DIRTY_CONFIG, &rt2x00dev->flags);
+		/* Enable the radio */
+		status = rt2x00lib_enable_radio(rt2x00dev);
+		if (unlikely(status))
+			return status;
 
-	rt2x00lib_config(rt2x00dev, conf, force_reconfig);
+		/*
+		 * When we've just turned on the radio, we want to reprogram
+		 * everything to ensure a consistent state
+		 */
+		rt2x00lib_config(rt2x00dev, conf, !radio_on);
 
-	/*
-	 * Reenable RX only if the radio should be on.
-	 */
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		/* Turn RX back on */
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
-	else if (conf->radio_enabled)
-		return rt2x00lib_enable_radio(rt2x00dev);
+	} else {
+		/* Disable the radio */
+		rt2x00lib_disable_radio(rt2x00dev);
+	}
 
 	return 0;
 }
-- 
1.5.6.1

