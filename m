Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1A3MY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:27 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:27 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/21] rt2x00: Make periodic beacon updates for PCI devices atomic
Date: Sun, 30 Jan 2011 13:17:29 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301316.29086.IvDoorn@gmail.com> <201101301316.53532.IvDoorn@gmail.com>
In-Reply-To: <201101301316.53532.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301317.30813.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Allow the beacondone and pretbtt functions to update the beacon from
atomic context by using the beacon update functions with caller locking.

This is a preparation for moving the periodic beacon handling into
tasklets that require atomic context.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2c65038..50b379a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -174,7 +174,13 @@ static void rt2x00lib_beaconupdate_iter(void *data, u8 *mac,
 	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
-	rt2x00queue_update_beacon(rt2x00dev, vif);
+	/*
+	 * Update the beacon without locking. This is safe on PCI devices
+	 * as they only update the beacon periodically here. This should
+	 * never be called for USB devices.
+	 */
+	WARN_ON(rt2x00_is_usb(rt2x00dev));
+	rt2x00queue_update_beacon_locked(rt2x00dev, vif);
 }
 
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
@@ -183,9 +189,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* send buffered bc/mc frames out for every bssid */
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_bc_buffer_iter,
-					    rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00lib_bc_buffer_iter,
+						   rt2x00dev);
 	/*
 	 * Devices with pre tbtt interrupt don't need to update the beacon
 	 * here as they will fetch the next beacon directly prior to
@@ -195,9 +201,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* fetch next beacon */
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_beaconupdate_iter,
-					    rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00lib_beaconupdate_iter,
+						   rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
@@ -207,9 +213,9 @@ void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* fetch next beacon */
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_beaconupdate_iter,
-					    rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00lib_beaconupdate_iter,
+						   rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 
-- 
1.7.2.3

