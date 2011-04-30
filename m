Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34058 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab1D3PSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:18:53 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1390654eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:18:52 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/6] rt2x00: Add autowake support for USB hardware
Date: Sat, 30 Apr 2011 17:18:18 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104301713.47545.IvDoorn@gmail.com> <201104301715.13753.IvDoorn@gmail.com> <201104301715.38080.IvDoorn@gmail.com>
In-Reply-To: <201104301715.38080.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104301718.19358.IvDoorn@gmail.com> (sfid-20110430_171859_299848_4A7C87BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB drivers don't support automatically waking up when in powersaving mode,
add a work object which will wakeup the device in time to receive the next beacon.
Based on that beacon, we either go back into powersaving mode, or we remain awake
to receive the buffered frames for our station.

Some part of the code, especially rt2x00lib_find_ie and rt2x00lib_rxdone_check_ps
are inspired on the code from carl9170.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c    |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c    |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h       |   17 +++++
 drivers/net/wireless/rt2x00/rt2x00config.c |   31 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   88 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c      |    1 +
 6 files changed, 139 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b21f812..15237c2 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1797,6 +1797,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(REQUIRE_COPY_IV, &rt2x00dev->cap_flags);
 	}
 	__set_bit(REQUIRE_SW_SEQNO, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b5d5f22..0eb44cf 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -634,6 +634,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
 
 	setup_timer(&rt2x00dev->txstatus_timer,
 		    rt2800usb_tx_sta_fifo_timeout,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 86e1410..73d3332 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -662,6 +662,7 @@ enum rt2x00_state_flags {
 	 * Driver configuration
 	 */
 	CONFIG_CHANNEL_HT40,
+	CONFIG_POWERSAVING,
 };
 
 /*
@@ -681,6 +682,7 @@ enum rt2x00_capability_flags {
 	REQUIRE_TASKLET_CONTEXT,
 	REQUIRE_SW_SEQNO,
 	REQUIRE_HT_TX_DESC,
+	REQUIRE_PS_AUTOWAKE,
 
 	/*
 	 * Capabilities
@@ -875,10 +877,20 @@ struct rt2x00_dev {
 	u8 calibration[2];
 
 	/*
+	 * Association id.
+	 */
+	u16 aid;
+
+	/*
 	 * Beacon interval.
 	 */
 	u16 beacon_int;
 
+	/**
+	 * Timestamp of last received beacon
+	 */
+	unsigned long last_beacon;
+
 	/*
 	 * Low level statistics which will have
 	 * to be kept up to date while device is running.
@@ -907,6 +919,11 @@ struct rt2x00_dev {
 	struct work_struct txdone_work;
 
 	/*
+	 * Powersaving work
+	 */
+	struct delayed_work autowakeup_work;
+
+	/*
 	 * Data queue arrays for RX, TX, Beacon and ATIM.
 	 */
 	unsigned int data_queues;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 2a313b6..edebbf0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -100,6 +100,10 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	erp.basic_rates = bss_conf->basic_rates;
 	erp.beacon_int = bss_conf->beacon_int;
 
+	/* Update the AID, this is needed for dynamic PS support */
+	rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
+	rt2x00dev->last_beacon = bss_conf->timestamp;
+
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
 
@@ -204,6 +208,9 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 {
 	struct rt2x00lib_conf libconf;
 	u16 hw_value;
+	u16 autowake_timeout;
+	u16 beacon_int;
+	u16 beacon_diff;
 
 	memset(&libconf, 0, sizeof(libconf));
 
@@ -227,6 +234,10 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		       sizeof(libconf.channel));
 	}
 
+	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
+	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS))
+		cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
+
 	/*
 	 * Start configuration.
 	 */
@@ -239,6 +250,26 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
 		rt2x00link_reset_tuner(rt2x00dev, false);
 
+	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
+	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
+	    (conf->flags & IEEE80211_CONF_PS)) {
+		beacon_diff = (long)jiffies - (long)rt2x00dev->last_beacon;
+		beacon_int = msecs_to_jiffies(rt2x00dev->beacon_int);
+
+		if (beacon_diff > beacon_int)
+			beacon_diff = 0;
+
+		autowake_timeout = (conf->max_sleep_period * beacon_int) - beacon_diff;
+		queue_delayed_work(rt2x00dev->workqueue,
+				   &rt2x00dev->autowakeup_work,
+				   autowake_timeout - 15);
+	}
+
+	if (conf->flags & IEEE80211_CONF_PS)
+		set_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
+	else
+		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
+
 	rt2x00dev->curr_band = conf->channel->band;
 	rt2x00dev->curr_freq = conf->channel->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7776d9f..2eb5196 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -141,6 +141,16 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 					    rt2x00dev);
 }
 
+static void rt2x00lib_autowakeup(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, autowakeup_work.work);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
+		ERROR(rt2x00dev, "Device failed to wakeup.\n");
+	clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
+}
+
 /*
  * Interrupt context handlers.
  */
@@ -416,6 +426,77 @@ void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone_noinfo);
 
+static u8 *rt2x00lib_find_ie(u8 *data, unsigned int len, u8 ie)
+{
+	struct ieee80211_mgmt *mgmt = (void *)data;
+	u8 *pos, *end;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = data + len;
+	while (pos < end) {
+		if (pos + 2 + pos[1] > end)
+			return NULL;
+
+		if (pos[0] == ie)
+			return pos;
+
+		pos += 2 + pos[1];
+	}
+
+	return NULL;
+}
+
+static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
+				      struct sk_buff *skb,
+				      struct rxdone_entry_desc *rxdesc)
+{
+	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ieee80211_tim_ie *tim_ie;
+	u8 *tim;
+	u8 tim_len;
+	bool cam;
+
+	/* If this is not a beacon, or if mac80211 has no powersaving
+	 * configured, or if the device is already in powersaving mode
+	 * we can exit now. */
+	if (likely(!ieee80211_is_beacon(hdr->frame_control) ||
+		   !(rt2x00dev->hw->conf.flags & IEEE80211_CONF_PS)))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (skb->len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (!(rxdesc->dev_flags & RXDONE_MY_BSS) ||
+	    !rt2x00dev->aid)
+		return;
+
+	rt2x00dev->last_beacon = jiffies;
+
+	tim = rt2x00lib_find_ie(skb->data, skb->len - FCS_LEN, WLAN_EID_TIM);
+	if (!tim)
+		return;
+
+	if (tim[1] < sizeof(*tim_ie))
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	/* Check whenever the PHY can be turned off again. */
+
+	/* 1. What about buffered unicast traffic for our AID? */
+	cam = ieee80211_check_tim(tim_ie, tim_len, rt2x00dev->aid);
+
+	/* 2. Maybe the AP wants to send multicast/broadcast data? */
+	cam |= (tim_ie->bitmap_ctrl & 0x01);
+
+	if (!cam && !test_bit(CONFIG_POWERSAVING, &rt2x00dev->flags))
+		rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf,
+				 IEEE80211_CONF_CHANGE_PS);
+}
+
 static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 					struct rxdone_entry_desc *rxdesc)
 {
@@ -531,6 +612,12 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 		rxdesc.flags |= RX_FLAG_HT;
 
 	/*
+	 * Check if this is a beacon, and more frames have been
+	 * buffered while we were in powersaving mode.
+	 */
+	rt2x00lib_rxdone_check_ps(rt2x00dev, entry->skb, &rxdesc);
+
+	/*
 	 * Update extra components
 	 */
 	rt2x00link_update_stats(rt2x00dev, entry->skb, &rxdesc);
@@ -1017,6 +1104,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	}
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
+	INIT_DELAYED_WORK(&rt2x00dev->autowakeup_work, rt2x00lib_autowakeup);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a6ce7d6..ad20953 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2209,6 +2209,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
 	__set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
+	__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.7.2.3

