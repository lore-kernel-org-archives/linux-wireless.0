Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXK1N3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:29:46 -0500
Subject: [PATCH (2.6.24)] mac80211: drop unencrypted frames if encryption
	is expected
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 11:07:57 +0100
Message-Id: <1196244477.6058.125.camel@johannes.berg> (sfid-20071128_132950_856419_855BAF5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression I (most likely) introduced, namely that
unencrypted frames are right now accepted even if we have a key for that
specific sender. That has very bad security implications.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This applies to 2.6.24.

 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/net/mac80211/rx.c	2007-11-28 10:59:56.988928439 +0100
+++ linux-2.6/net/mac80211/rx.c	2007-11-28 11:00:21.718922363 +0100
@@ -997,7 +997,7 @@ ieee80211_rx_h_drop_unencrypted(struct i
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     rx->sdata->drop_unencrypted &&
+		     (rx->key || rx->sdata->drop_unencrypted) &&
 		     (rx->sdata->eapol == 0 || !ieee80211_is_eapol(rx->skb)))) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "


