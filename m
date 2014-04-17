Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaDQJKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 05:10:01 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH 1/2] rt2x00: fix beaconing on USB
Date: Thu, 17 Apr 2014 11:08:47 +0200
Message-Id: <1397725728-2786-1-git-send-email-sgruszka@redhat.com> (sfid-20140417_111009_699863_B9BE220D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disable beaconing we clear register with beacon and newer set it
back, what make we stop send beacons infinitely.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ddeb5a7..a87ee9b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -621,20 +621,18 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->bssid);
 
 	/*
-	 * Update the beacon. This is only required on USB devices. PCI
-	 * devices fetch beacons periodically.
-	 */
-	if (changes & BSS_CHANGED_BEACON && rt2x00_is_usb(rt2x00dev))
-		rt2x00queue_update_beacon(rt2x00dev, vif);
-
-	/*
 	 * Start/stop beaconing.
 	 */
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
 		if (!bss_conf->enable_beacon && intf->enable_beacon) {
-			rt2x00queue_clear_beacon(rt2x00dev, vif);
 			rt2x00dev->intf_beaconing--;
 			intf->enable_beacon = false;
+			/*
+			 * Clear beacon in the H/W for this vif. This is needed
+			 * to disable beaconing on this particular interface
+			 * and keep it running on other interfaces.
+			 */
+			rt2x00queue_clear_beacon(rt2x00dev, vif);
 
 			if (rt2x00dev->intf_beaconing == 0) {
 				/*
@@ -645,11 +643,15 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				rt2x00queue_stop_queue(rt2x00dev->bcn);
 				mutex_unlock(&intf->beacon_skb_mutex);
 			}
-
-
 		} else if (bss_conf->enable_beacon && !intf->enable_beacon) {
 			rt2x00dev->intf_beaconing++;
 			intf->enable_beacon = true;
+			/*
+			 * Upload beacon to the H/W. This is only required on
+			 * USB devices. PCI devices fetch beacons periodically.
+			 */
+			if (rt2x00_is_usb(rt2x00dev))
+				rt2x00queue_update_beacon(rt2x00dev, vif);
 
 			if (rt2x00dev->intf_beaconing == 1) {
 				/*
-- 
1.8.4.2

