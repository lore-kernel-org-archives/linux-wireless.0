Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXHOKnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:43:32 -0400
Subject: [PATCH] mac80211 & drivers: remove IEEE80211_HW_HOST_GEN_BEACON
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 01:34:21 +0200
Message-Id: <1187134461.31200.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag is unused and not useful either since the driver just calls
ieee80211_beacon_get() if it needs a beacon.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 01:29:23.280200043 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 01:30:32.090200043 +0200
@@ -443,14 +443,13 @@ struct ieee80211_hw {
 
 	/* TODO: frame_type 802.11/802.3, sw_encryption requirements */
 
-	/* Some wireless LAN chipsets generate beacons in the hardware/firmware
-	 * and others rely on host generated beacons. This option is used to
-	 * configure the upper layer IEEE 802.11 module to generate beacons.
-	 * The low-level driver can use ieee80211_beacon_get() to fetch the
-	 * next beacon frame. */
-#define IEEE80211_HW_HOST_GEN_BEACON (1<<0)
+/* hole at 0 */
 
-	/* The device needs to be supplied with a beacon template only. */
+	/*
+	 * The device only needs to be supplied with a beacon template.
+	 * If you need the host to generate each beacon then don't use
+	 * this flag and use ieee80211_beacon_get().
+	 */
 #define IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE (1<<1)
 
 	/* Some devices handle decryption internally and do not
--- wireless-dev.orig/drivers/net/wireless/rt2400pci.c	2007-08-15 01:31:03.400200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2400pci.c	2007-08-15 01:32:17.070200043 +0200
@@ -1444,7 +1444,6 @@ static void rt2400pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
--- wireless-dev.orig/drivers/net/wireless/rt2500pci.c	2007-08-15 01:31:03.500200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2500pci.c	2007-08-15 01:32:20.650200043 +0200
@@ -1689,7 +1689,6 @@ static void rt2500pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
--- wireless-dev.orig/drivers/net/wireless/rt61pci.c	2007-08-15 01:31:03.300200043 +0200
+++ wireless-dev/drivers/net/wireless/rt61pci.c	2007-08-15 01:32:14.390200043 +0200
@@ -2213,7 +2213,6 @@ static void rt61pci_probe_hw_mode(struct
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |


