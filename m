Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52422
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbXKWNv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 08:51:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: include full 64-bit timestamp in monitor mode
Date: Fri, 23 Nov 2007 14:50:51 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200711231450.52403.mb@bu3sch.de> (sfid-20071123_135200_286266_A1F3DBAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When monitor mode is enabled, this will make b43 read out the
full 64-bit MAC time from the chip for each received packet.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/net/wireless/b43/b43.h  |    2 ++
 drivers/net/wireless/b43/main.c |    2 ++
 drivers/net/wireless/b43/xmit.c |   18 +++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

--- everything.orig/drivers/net/wireless/b43/b43.h	2007-11-22 22:56:20.648678709 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-11-22 23:03:27.268675020 +0100
@@ -635,6 +635,8 @@ struct b43_wl {
 	/* List of all wireless devices on this chip */
 	struct list_head devlist;
 	u8 nr_devs;
+
+	bool radiotap_enabled;
 };
 
 /* Pointers to the firmware data and meta information about it. */
--- everything.orig/drivers/net/wireless/b43/main.c	2007-11-22 22:55:49.608678981 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-11-22 23:03:53.678676051 +0100
@@ -2853,6 +2853,8 @@ static int b43_op_config(struct ieee8021
 			b43_short_slot_timing_disable(dev);
 	}
 
+	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
+
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
 		if (conf->power_level != phy->power_level) {
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-22 22:54:33.498725965 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-11-22 23:15:44.808681966 +0100
@@ -526,7 +526,23 @@ void b43_rx(struct b43_wldev *dev, struc
 	else
 		status.rate = b43_plcp_get_bitrate_cck(plcp);
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
-	status.mactime = mactime;
+
+	/*
+	 * If monitors are present get full 64-bit timestamp. This
+	 * code assumes we get to process the packet within 16 bits
+	 * of timestamp, i.e. about 65 milliseconds after the PHY
+	 * received the first symbol.
+	 */
+	if (dev->wl->radiotap_enabled) {
+		u16 low_mactime_now;
+
+		b43_tsf_read(dev, &status.mactime);
+		low_mactime_now = status.mactime;
+		status.mactime = status.mactime & ~0xFFFFULL;
+		status.mactime += mactime;
+		if (low_mactime_now <= mactime)
+			status.mactime -= 0x10000;
+	}
 
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {




-------------------------------------------------------

-- 
Greetings Michael.
