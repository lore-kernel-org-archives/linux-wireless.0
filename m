Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbXC1JMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:19 -0400
Subject: [PATCH] mac80211: optimise ieee80211_get_hdrlen
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 18:01:45 +0200
Message-Id: <1175011305.9282.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch optimises the ieee80211_get_hdrlen function by exploiting the
bit masks directly.

On powerpc, this decreases the function by 4 instructions, but more
importantly it kills 4 of the 5 branches it contained.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
And don't ask me how the compiler actually gets by with a single branch
now!

It was fun to do but in my userspace test program on powerpc doesn't
seem to change much, CPU time goes down by like 2%...

 net/mac80211/ieee80211.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-27 16:33:47.163155480 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-27 16:33:48.473155480 +0200
@@ -258,19 +258,24 @@ int ieee80211_get_hdrlen(u16 fc)
 	case IEEE80211_FTYPE_DATA:
 		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
 			hdrlen = 30; /* Addr4 */
-		if (fc & IEEE80211_STYPE_QOS_DATA)
-			hdrlen += 2; /* QoS Control Field */
+		/* QoS Control Field */
+		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
+				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
 		break;
 	case IEEE80211_FTYPE_CTL:
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_CTS:
-		case IEEE80211_STYPE_ACK:
+		/*
+		 * ACK and CTS are 10 bytes, all others 16. To see how
+		 * to get this condition consider
+		 *   subtype mask:   0b0000000011110000 (0x00F0)
+		 *   ACK subtype:    0b0000000011010000 (0x00D0)
+		 *   CTS subtype:    0b0000000011000000 (0x00C0)
+		 *   bits that matter:         ^^^      (0x00E0)
+		 *   value of those: 0b0000000011000000 (0x00C0)
+		 */
+		if ((fc & 0xE0) == 0xC0)
 			hdrlen = 10;
-			break;
-		default:
+		else
 			hdrlen = 16;
-			break;
-		}
 		break;
 	}
 


