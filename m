Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZDVQrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 12:47:12 -0400
Subject: [PATCH] mac80211: calculate maximum sleep interval
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 18:44:37 +0200
Message-Id: <1240418677.30082.3.camel@johannes.local> (sfid-20090422_184717_098451_A27196BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maximum sleep interval, for powersave purposes, is
determined by the DTIM period (it may not be larger)
and the required networking latency (it must be small
enough to fulfil those constraints).

This makes mac80211 calculate the maximum sleep interval
based on those constraints, and pass it to the driver.
Then the driver should instruct the device to sleep at
most that long.

Note that the device is responsible for aligning the
maximum sleep interval between DTIMs, we make sure it's
not longer but it needs to make sure it's between them.

Also, group some powersave documentation together and
make it more explicit that we support managed mode only,
and no IBSS powersaving (yet).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   19 ++++++++++++++++---
 net/mac80211/mlme.c    |   20 ++++++++++++++++----
 2 files changed, 32 insertions(+), 7 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-22 18:01:10.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-22 18:24:12.000000000 +0200
@@ -517,7 +517,7 @@ struct ieee80211_rx_status {
  * Flags to define PHY configuration options
  *
  * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
- * @IEEE80211_CONF_PS: Enable 802.11 power save mode
+ * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only)
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_RADIOTAP		= (1<<0),
@@ -553,14 +553,26 @@ enum ieee80211_conf_changed {
  *
  * This struct indicates how the driver shall configure the hardware.
  *
+ * @flags: configuration flags defined above
+ *
  * @radio_enabled: when zero, driver is required to switch off the radio.
  * @beacon_int: beacon interval (TODO make interface config)
+ *
  * @listen_interval: listen interval in units of beacon interval
- * @flags: configuration flags defined above
+ * @max_sleep_interval: the maximum number of beacon intervals to sleep for
+ *	before checking the beacon for a TIM bit (managed mode only); this
+ *	value will be only achievable between DTIM frames, the hardware
+ *	needs to check for the multicast traffic bit in DTIM beacons.
+ *	This variable is valid only when the CONF_PS flag is set.
+ * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
+ *	powersave documentation below. This variable is valid only when
+ *	the CONF_PS flag is set.
+ *
  * @power_level: requested transmit power (in dBm)
- * @dynamic_ps_timeout: dynamic powersave timeout (in ms)
+ *
  * @channel: the channel to tune to
  * @channel_type: the channel (HT) type
+ *
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
  *    (a frame not RTS protected), called "dot11LongRetryLimit" in 802.11,
  *    but actually means the number of transmissions not the number of retries
@@ -572,6 +584,7 @@ struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
+	int max_sleep_interval;
 
 	u16 listen_interval;
 	bool radio_enabled;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 18:02:03.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 18:41:13.000000000 +0200
@@ -545,10 +545,19 @@ void ieee80211_recalc_ps(struct ieee8021
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
 
-		if (beaconint_us > latency)
+		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
-		else
+		} else {
+			u8 dtimper = found->vif.bss_conf.dtim_period;
+			int maxslp = 1;
+
+			if (dtimper > 1)
+				maxslp = min_t(int, dtimper,
+						    latency / beaconint_us);
+
+			local->hw.conf.max_sleep_interval = maxslp;
 			local->ps_sdata = found;
+		}
 	} else {
 		local->ps_sdata = NULL;
 	}
@@ -851,8 +860,11 @@ static void ieee80211_set_associated(str
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	/* will be same as sdata */
-	if (local->ps_sdata)
-		ieee80211_enable_ps(local, sdata);
+	if (local->ps_sdata) {
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
+	}
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);


