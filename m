Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63324 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab1AaPD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:03:58 -0500
Received: by eye27 with SMTP id 27so2504927eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 07:03:56 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in powersave mode
Date: Mon, 31 Jan 2011 16:00:38 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101311600.39486.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a delayed work structure which can be used to wakeup the device
just before a beacon from the AP is expected. This then allows the device
to receive the beacon, check if there are pending broadcast or multicast frames.

TODO: Split out mac80211 changes into a separate patch. We also need
to know if we need this check in mac80211 or in the driver. Personally I think the
check belongs in mac80211, but at this time that work has been deferred to the drivers.
However this means that a lot of logic is needed in the driver to check if the correct IE
is available, and then check the value, while mac80211 will obtains that exact IE anyway
during RX processing anyway...

I'm not familliar enough with the Powersaving mode in mac80211 to be sure this current
approach is completely correct, so please review carefully :)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5d91561..7b169c8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -561,6 +561,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 39bc2fa..fd4fe33 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -659,6 +659,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_L2PAD,
 	DRIVER_REQUIRE_TXSTATUS_FIFO,
 	DRIVER_REQUIRE_TASKLET_CONTEXT,
+	DRIVER_REQUIRE_PS_AUTOWAKE,
 
 	/*
 	 * Driver features
@@ -882,6 +883,11 @@ struct rt2x00_dev {
 	struct work_struct txdone_work;
 
 	/*
+	 * Powersaving work
+	 */
+	struct delayed_work autowakeup_work;
+
+	/*
 	 * Data queue arrays for RX, TX and Beacon.
 	 * The Beacon array also contains the Atim queue
 	 * if that is supported by the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index e7f67d5..efc8496 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -192,6 +192,11 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		       sizeof(libconf.channel));
 	}
 
+	if (test_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags) &&
+	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
+	    !(conf->flags & IEEE80211_CONF_PS))
+		cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);	
+
 	/*
 	 * Start configuration.
 	 */
@@ -204,6 +209,13 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
 		rt2x00link_reset_tuner(rt2x00dev, false);
 
+	if (test_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags) &&
+	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
+	    (conf->flags & IEEE80211_CONF_PS))
+		queue_delayed_work(rt2x00dev->workqueue,
+				   &rt2x00dev->autowakeup_work,
+				   msecs_to_jiffies(rt2x00dev->beacon_int) - 1);
+
 	rt2x00dev->curr_band = conf->channel->band;
 	rt2x00dev->curr_freq = conf->channel->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d91afbb..17022bf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -138,6 +138,16 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 					    rt2x00dev);
 }
 
+static void rt2x00lib_autowakeup(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, autowakeup_work.work);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE)) {
+		ERROR(rt2x00dev, "Device failed to wakeup.\n");
+	}
+}
+
 /*
  * Interrupt context handlers.
  */
@@ -1004,6 +1014,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	}
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
+	INIT_DELAYED_WORK(&rt2x00dev->autowakeup_work, rt2x00lib_autowakeup);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..9035f33 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1616,6 +1616,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
 	bool erp_valid, directed_tim = false;
+	bool ps_buffered = false;
 	u8 erp_value = 0;
 	u32 ncrc;
 	u8 *bssid;
@@ -1712,6 +1713,20 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
 						   ifmgd->aid);
 
+	if (likely(elems.tim && elems.tim_len >= sizeof(*elems.tim))) {
+		ps_buffered = !!(elems.tim->bitmap_ctrl & 0x01);
+
+		if (ps_buffered && local->hw.conf.flags & IEEE80211_CONF_PS) {
+			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+			ieee80211_hw_config(local,
+					    IEEE80211_CONF_CHANGE_PS);
+		} else if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+			local->hw.conf.flags |= IEEE80211_CONF_PS;
+			ieee80211_hw_config(local,
+					    IEEE80211_CONF_CHANGE_PS);
+		}
+	}
+
 	if (ncrc != ifmgd->beacon_crc || !ifmgd->beacon_crc_valid) {
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
 				      true);
