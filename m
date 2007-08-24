Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937AbXHXMbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:38 -0400
Message-Id: <20070824122902.074741000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/15] mac80211: improve key selection comment
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I changed the code there I forgot to mention what happens
with multicast frames in a regular BSS and keep wondering myself
if the code is correct. Add appropriate comments.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-24 14:05:53.619417211 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-24 14:06:02.669417211 +0200
@@ -338,16 +338,23 @@ ieee80211_rx_h_load_key(struct ieee80211
 	 * frames can also use key indizes like GTKs. Hence, if we don't
 	 * have a PTK/STK we check the key index for a WEP key.
 	 *
+	 * Note that in a regular BSS, multicast frames are sent by the
+	 * AP only, associated stations unicast the frame to the AP first
+	 * which then multicasts it on their behalf.
+	 *
 	 * There is also a slight problem in IBSS mode: GTKs are negotiated
 	 * with each station, that is something we don't currently handle.
+	 * The spec seems to expect that one negotiates the same key with
+	 * every station but there's no such requirement; VLANs could be
+	 * possible.
 	 */
 
 	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
 		return TXRX_CONTINUE;
 
 	/*
-	 * No point in finding a key if the frame is neither
-	 * addressed to us nor a multicast frame.
+	 * No point in finding a key if the frame is neither addressed to
+	 * us nor a multicast frame (ra_match is true for multicast frames.)
 	 */
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
 		return TXRX_DROP;

-- 

