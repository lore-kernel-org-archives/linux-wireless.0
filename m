Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269AbXHOOyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:54:40 -0400
Message-Id: <20070815145049.838935000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 19/20] mac80211: remove IEEE80211_HW_HOST_GEN_BEACON flag
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no point in setting that flag, drivers simply call
ieee80211_beacon_get() if they need it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/rt2400pci.c |    1 -
 drivers/net/wireless/rt2500pci.c |    1 -
 drivers/net/wireless/rt61pci.c   |    1 -
 include/net/mac80211.h           |   13 ++++++-------
 4 files changed, 6 insertions(+), 10 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:27:26.006516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:27:27.166516958 +0200
@@ -445,14 +445,13 @@ struct ieee80211_hw {
 
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
--- wireless-dev.orig/drivers/net/wireless/rt2400pci.c	2007-08-15 14:27:26.016516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2400pci.c	2007-08-15 14:27:27.176516958 +0200
@@ -1444,7 +1444,6 @@ static void rt2400pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
--- wireless-dev.orig/drivers/net/wireless/rt2500pci.c	2007-08-15 14:27:26.016516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2500pci.c	2007-08-15 14:27:27.176516958 +0200
@@ -1689,7 +1689,6 @@ static void rt2500pci_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |
--- wireless-dev.orig/drivers/net/wireless/rt61pci.c	2007-08-15 14:27:26.066516958 +0200
+++ wireless-dev/drivers/net/wireless/rt61pci.c	2007-08-15 14:27:27.176516958 +0200
@@ -2213,7 +2213,6 @@ static void rt61pci_probe_hw_mode(struct
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
 	    IEEE80211_HW_DATA_NULLFUNC_ACK |

-- 

