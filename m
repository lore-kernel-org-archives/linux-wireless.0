Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZDPPE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:04:59 -0400
Subject: [PATCH] mac80211: document powersaving/beacon filter future
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 17:04:25 +0200
Message-Id: <1239894265.14169.2.camel@johannes.local> (sfid-20090416_170502_809421_20F13E45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document what mac80211 will do in the future to help save power.
We're not quite there yet, but a plan helps. Also, while at it,
fix the docs wrt. multicast traffic.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   60 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 10 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-16 16:23:44.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-16 16:59:16.000000000 +0200
@@ -1109,11 +1109,9 @@ ieee80211_get_alt_retry_rate(const struc
  * need software support for parsing the TIM bitmap. This is also supported
  * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS and
  * %IEEE80211_HW_PS_NULLFUNC_STACK flags. The hardware is of course still
- * required to pass up beacons. Additionally, in this case, mac80211 will
- * wake up the hardware when multicast traffic is announced in the beacon.
- *
- * FIXME: I don't think we can be fast enough in software when we want to
- *	  receive multicast traffic?
+ * required to pass up beacons. The hardware is still required to handle
+ * waking up for multicast traffic; if it cannot the driver must handle that
+ * as best as it can, mac80211 is too slow.
  *
  * Dynamic powersave mode is an extension to normal powersave mode in which
  * the hardware stays awake for a user-specified period of time after sending
@@ -1134,11 +1132,53 @@ ieee80211_get_alt_retry_rate(const struc
  * way the host will only receive beacons where some relevant information
  * (for example ERP protection or WMM settings) have changed.
  *
- * Beacon filter support is informed with %IEEE80211_HW_BEACON_FILTER flag.
- * The driver needs to enable beacon filter support whenever power save is
- * enabled, that is %IEEE80211_CONF_PS is set. When power save is enabled,
- * the stack will not check for beacon miss at all and the driver needs to
- * notify about complete loss of beacons with ieee80211_beacon_loss().
+ * Beacon filter support is advertised with the %IEEE80211_HW_BEACON_FILTER
+ * hardware capability. The driver needs to enable beacon filter support
+ * whenever power save is enabled, that is %IEEE80211_CONF_PS is set. When
+ * power save is enabled, the stack will not check for beacon loss and the
+ * driver needs to notify about loss of beacons with ieee80211_beacon_loss().
+ *
+ * The time (or number of beacons missed) until the firmware notifies the
+ * driver of a beacon loss event (which in turn causes the driver to call
+ * ieee80211_beacon_loss()) should be configurable and will be controlled
+ * by mac80211 and the roaming algorithm in the future.
+ *
+ * Since there may be constantly changing information elements that nothing
+ * in the software stack cares about, we will, in the future, have mac80211
+ * tell the driver which information elements are interesting in the sense
+ * that we want to see changes in them. This will include
+ *  - a list of information element IDs
+ *  - a list of OUIs for the vendor information element
+ *
+ * Ideally, the hardware would filter out any beacons without changes in the
+ * requested elements, but if it cannot support that it may, at the expense
+ * of some efficiency, filter out only a subset. For example, if the device
+ * doesn't support checking for OUIs it should pass up all changes in all
+ * vendor information elements.
+ *
+ * Note that change, for the sake of simplification, also includes information
+ * elements appearing or disappearing from the beacon.
+ *
+ * Some hardware supports an "ignore list" instead, just make sure nothing
+ * that was requested is on the ignore list, and include commonly changing
+ * information element IDs in the ignore list, for example 11 (BSS load) and
+ * the various vendor-assigned IEs with unknown contents (128, 129, 133-136,
+ * 149, 150, 155, 156, 173, 176, 178, 179, 219); for forward compatibility
+ * it could also include some currently unused IDs.
+ *
+ *
+ * In addition to these capabilities, hardware should support notifying the
+ * host of changes in the beacon RSSI. This is relevant to implement roaming
+ * when no traffic is flowing (when traffic is flowing we see the RSSI of
+ * the received data packets). This can consist in notifying the host when
+ * the RSSI changes significantly or when it drops below or rises above
+ * configurable thresholds. In the future these thresholds will also be
+ * configured by mac80211 (which gets them from userspace) to implement
+ * them as the roaming algorithm requires.
+ *
+ * If the hardware cannot implement this, the driver should ask it to
+ * periodically pass beacon frames to the host so that software can do the
+ * signal strength threshold checking.
  */
 
 /**


