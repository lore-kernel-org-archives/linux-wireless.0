Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57491
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965113AbXBTT5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 14:57:08 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] d80211: Fix max_signal values signedness bug
Date: Tue, 20 Feb 2007 20:45:01 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702202045.02075.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

char is not signed on all architectures.
This fixes a compiletime warning and bug on PPC.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/include/net/d80211.h
===================================================================
--- bu3sch-wireless-dev.orig/include/net/d80211.h	2007-02-20 20:35:17.000000000 +0100
+++ bu3sch-wireless-dev/include/net/d80211.h	2007-02-20 20:42:13.000000000 +0100
@@ -542,9 +542,9 @@ struct ieee80211_hw {
         int channel_change_time;
 	/* Maximum values for various statistics.
 	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
-	char max_rssi;
-	char max_signal;
-	char max_noise;
+	s8 max_rssi;
+	s8 max_signal;
+	s8 max_noise;
 
 	/* Number of available hardware TX queues for data packets.
 	 * WMM requires at least four queues. */

-- 
Greetings Michael.
