Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbYBRLMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 06:12:43 -0500
Subject: [PATCH] b43(legacy): include full timestamp in beacon frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 09:05:54 +0100
Message-Id: <1203321954.12783.30.camel@johannes.berg> (sfid-20080218_111247_946909_C77AC667)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having the full RX timestamp in beacons is necessary for IBSS
merge to work properly so extend the 16-bit timestamp to the
full 64 bits for beacon frames (as well as when monitor mode
is active.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
NB: I don't test IBSS, it doesn't interest me enough.

 drivers/net/wireless/b43/xmit.c       |   14 +++++++++-----
 drivers/net/wireless/b43legacy/xmit.c |   14 +++++++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

--- everything.orig/drivers/net/wireless/b43/xmit.c	2008-02-18 09:02:29.921823351 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2008-02-18 09:04:15.121823730 +0100
@@ -589,12 +589,16 @@ void b43_rx(struct b43_wldev *dev, struc
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
 
 	/*
-	 * If monitors are present get full 64-bit timestamp. This
-	 * code assumes we get to process the packet within 16 bits
-	 * of timestamp, i.e. about 65 milliseconds after the PHY
-	 * received the first symbol.
+	 * All frames on monitor interfaces and beacons always need a full
+	 * 64-bit timestamp. Monitor interfaces need it for diagnostic
+	 * purposes and beacons for IBSS merging.
+	 * This code assumes we get to process the packet within 16 bits
+	 * of timestamp, i.e. about 65 milliseconds after the PHY received
+	 * the first symbol.
 	 */
-	if (dev->wl->radiotap_enabled) {
+	if (((fctl & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
+	    == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) ||
+	    dev->wl->radiotap_enabled) {
 		u16 low_mactime_now;
 
 		b43_tsf_read(dev, &status.mactime);
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-02-06 17:38:25.416098905 +0100
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-02-18 09:04:40.471819824 +0100
@@ -546,12 +546,16 @@ void b43legacy_rx(struct b43legacy_wldev
 	status.antenna = !!(phystat0 & B43legacy_RX_PHYST0_ANT);
 
 	/*
-	 * If monitors are present get full 64-bit timestamp. This
-	 * code assumes we get to process the packet within 16 bits
-	 * of timestamp, i.e. about 65 milliseconds after the PHY
-	 * received the first symbol.
+	 * All frames on monitor interfaces and beacons always need a full
+	 * 64-bit timestamp. Monitor interfaces need it for diagnostic
+	 * purposes and beacons for IBSS merging.
+	 * This code assumes we get to process the packet within 16 bits
+	 * of timestamp, i.e. about 65 milliseconds after the PHY received
+	 * the first symbol.
 	 */
-	if (dev->wl->radiotap_enabled) {
+	if (((fctl & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
+	    == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) ||
+	    dev->wl->radiotap_enabled) {
 		u16 low_mactime_now;
 
 		b43legacy_tsf_read(dev, &status.mactime);


