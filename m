Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbXD0PKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:10:20 -0400
Subject: [PATCH] mac80211: optimise ieee80211_get_hdrlen
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <20070328191116.GJ6036@devicescape.com>
References: <1175011305.9282.10.camel@johannes.berg>
	 <20070328191116.GJ6036@devicescape.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 17:10:17 +0200
Message-Id: <1177686617.3565.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch optimises the ieee80211_get_hdrlen function by exploiting the
bit masks directly.

On powerpc, this decreases the function by 4 instructions, but more
importantly it kills 3 of the 5 branches it contained.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Looks like I forgot to resend this with the new comment. I think
optimising the control frames too is fine even if we don't use them,
it's not /that/ hard to understand.

 net/mac80211/ieee80211.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-04-27 12:03:38.334987898 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-04-27 12:03:43.034987898 +0200
@@ -255,21 +255,32 @@ int ieee80211_get_hdrlen(u16 fc)
 
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_DATA:
-		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
+		if (unlikely((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS)))
 			hdrlen = 30; /* Addr4 */
-		if (fc & IEEE80211_STYPE_QOS_DATA)
-			hdrlen += 2; /* QoS Control Field */
+		/*
+		 * The QoS Control field is two bytes and its presence is
+		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
+		 * hdrlen if that bit is set.
+		 * This works by masking out the bit and shifting it to
+		 * bit position 1 so the result has the value 0 or 2.
+		 */
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
 


