Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56759 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061AbYLESnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 13:43:35 -0500
Date: Fri, 5 Dec 2008 20:43:27 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k: Disable staggered Beacon frame scheduling
Message-ID: <20081205184327.GB10596@jm.kir.nu> (sfid-20081205_194337_859285_415C95B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like there are some issues in the current ath9k version as
far as staggered Beacon frame scheduling is concerned. This results in
Beacon frame timestamp being off by 25 milliseconds or so which can
cause issues with multicast power save buffering in AP mode. Some
client stations fail to receive multicast frames when there is this
large an offset between TBTT and actual Beacon transmission time.

Since ath9k does not yet support multiple BSSes anyway, the staggered
Beacon frame scheduling is just increasing the number of interrupts at
this point. The easiest fix for the timestamp offset is to disable
staggered Beacon frames for now. We need to redesign beacon.c anyway
when adding multi-BSS support with mac80211 since the existing code
depends on different mechanism for Beacon frame transmission.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/ath9k/core.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.h	2008-12-05 20:31:39.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/core.h	2008-12-05 20:32:35.000000000 +0200
@@ -489,7 +489,7 @@
  * number of beacon intervals, the game's up.
  */
 #define BSTUCK_THRESH           	(9 * ATH_BCBUF)
-#define	ATH_BCBUF               	4
+#define	ATH_BCBUF               	1
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)

-- 
Jouni Malinen                                            PGP id EFC895FA
