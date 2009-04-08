Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZDHKzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 06:55:21 -0400
Subject: [PATCH] mac80211: update injection documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 12:54:41 +0200
Message-Id: <1239188081.8456.43.camel@johannes.local> (sfid-20090408_125524_314796_12500AA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't currently support antenna or rate setting, so remove
that. Also update the link -- the current one is dead and the
wiki can be kept updated easier.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/networking/mac80211-injection.txt |   28 +++++-------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

--- wireless-testing.orig/Documentation/networking/mac80211-injection.txt	2009-04-08 12:48:30.000000000 +0200
+++ wireless-testing/Documentation/networking/mac80211-injection.txt	2009-04-08 12:52:31.000000000 +0200
@@ -12,38 +12,22 @@ following format:
 The radiotap format is discussed in
 ./Documentation/networking/radiotap-headers.txt.
 
-Despite 13 radiotap argument types are currently defined, most only make sense
+Despite many radiotap parameters being currently defined, most only make sense
 to appear on received packets.  The following information is parsed from the
 radiotap headers and used to control injection:
 
- * IEEE80211_RADIOTAP_RATE
-
-   rate in 500kbps units, automatic if invalid or not present
-
-
- * IEEE80211_RADIOTAP_ANTENNA
-
-   antenna to use, automatic if not present
-
-
- * IEEE80211_RADIOTAP_DBM_TX_POWER
-
-   transmit power in dBm, automatic if not present
-
-
  * IEEE80211_RADIOTAP_FLAGS
 
    IEEE80211_RADIOTAP_F_FCS: FCS will be removed and recalculated
    IEEE80211_RADIOTAP_F_WEP: frame will be encrypted if key available
    IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
-			      current fragmentation threshold. Note that
-			      this flag is only reliable when software
-			      fragmentation is enabled)
+			      current fragmentation threshold.
+
 
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
 
-Here is an example valid radiotap header defining these three parameters
+Here is an example valid radiotap header defining some parameters
 
 	0x00, 0x00, // <-- radiotap version
 	0x0b, 0x00, // <- radiotap header length
@@ -72,8 +56,8 @@ interface), along the following lines:
 ...
 	r = pcap_inject(ppcap, u8aSendBuffer, nLength);
 
-You can also find sources for a complete inject test applet here:
+You can also find a link to a complete inject application here:
 
-http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer
+http://wireless.kernel.org/en/users/Documentation/packetspammer
 
 Andy Green <andy@warmcat.com>


