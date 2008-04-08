Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 90.144.36.72.static.reverse.ltdomains.com ([72.36.144.90]:44446
	"EHLO anubis.xasein.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYDHBCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 21:02:42 -0400
Message-ID: <47FAB829.9010304@latinsud.com> (sfid-20080408_020245_602188_C8B3076F)
Date: Tue, 08 Apr 2008 02:11:21 +0200
From: Alejandro Grijalba <sud@latinsud.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: [PATCH] mac80211: do not alter injected seq numbers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When injecting frames we should allow user to play with fields like
fragment or sequence numbers. This patch prevents mac80211 from modifying
those fields on injected frames.

Tested on 2.6.24.4 with aireplay-ng.

Signed-off-by: Alejandro Grijalba <sud@latinsud.com>
---
There is still a problem with some drivers (b43) that also modify seq numbers, 
and i cannot find there a clean way to tell whether the frame was injected.
An alternative way would be to create a radiotap flag meaning not to modify header.

--- linux-2.6.24.4/net/mac80211/tx.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24.4-sud/net/mac80211/tx.c	2008-04-05 16:43:19.000000000 +0200
@@ -281,6 +281,9 @@ ieee80211_tx_h_sequence(struct ieee80211
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
+	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
+		return TXRX_CONTINUE;
+
 	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
 		ieee80211_include_sequence(tx->sdata, hdr);
 


