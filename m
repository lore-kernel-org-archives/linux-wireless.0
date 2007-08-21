Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060AbXHUPLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:11:50 -0400
Message-Id: <20070821150041.663712000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 07/27] mac80211: remove IEEE80211_HW_HOST_GEN_BEACON flag
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag is never checked because drivers can simply call
ieee80211_beacon_get() regardless of setting this flag.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-21 16:25:25.135923881 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-21 16:25:30.415923881 +0200
@@ -462,14 +462,13 @@ struct ieee80211_hw {
 
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

-- 

