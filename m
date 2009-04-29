Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZD2Vg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 17:36:26 -0400
Subject: [PATCH 2.6.30] mac80211: correct fragmentation threshold check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 23:35:56 +0200
Message-Id: <1241040956.5067.1.camel@johannes.local> (sfid-20090429_233630_328421_1F126A82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fragmentation threshold is defined to be including the
FCS, and the code that sets the TX_FRAGMENTED flag correctly
accounts for those four bytes. The code that verifies this
doesn't though, which could lead to spurious warnings and
frames being dropped although everything is ok. Correct the
code by accounting for the FCS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-04-29 22:27:51.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-04-29 22:28:35.000000000 +0200
@@ -788,7 +788,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	/* internal error, why is TX_FRAGMENTED set? */
-	if (WARN_ON(skb->len <= frag_threshold))
+	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
 		return TX_DROP;
 
 	/*


