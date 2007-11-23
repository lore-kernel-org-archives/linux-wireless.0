Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbXKWMQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:16:05 -0500
Subject: [PATCH] b43: include full 64-bit timestamp in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:46:08 +0100
Message-Id: <1195814768.4149.88.camel@johannes.berg> (sfid-20071123_121610_694009_AD68CCB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When monitor mode is enabled, this will make b43 read out the
full 64-bit MAC time from the chip for each received packet.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
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


