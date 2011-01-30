Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab1A3MY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:26 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:25 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/21] rt2x00: Limit beacon updates in bss_info_changed to USB devices
Date: Sun, 30 Jan 2011 13:16:52 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301316.29086.IvDoorn@gmail.com>
In-Reply-To: <201101301316.29086.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301316.53532.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Currently there are two places that trigger a beacon update on PCI
devices. The bss_info_changed callback and the periodic update
triggered by the TBTT or PRETBTT interrupt.

Since the next TBTT or PRETBTT interrupt will periodically fetch an
updated beacon remove the update_beacon call in the bss_info_changed
callback for PCI devices.

In the worst case it will take one beacon interval longer to fetch
the new beacon then before. For devices that have a PRETBTT interrupt
there should be no change at all.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7d33167..6a66021 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -617,9 +617,10 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->bssid);
 
 	/*
-	 * Update the beacon.
+	 * Update the beacon. This is only required on USB devices. PCI
+	 * devices fetch beacons periodically.
 	 */
-	if (changes & BSS_CHANGED_BEACON)
+	if (changes & BSS_CHANGED_BEACON && rt2x00_is_usb(rt2x00dev))
 		rt2x00queue_update_beacon(rt2x00dev, vif);
 
 	/*
-- 
1.7.2.3

