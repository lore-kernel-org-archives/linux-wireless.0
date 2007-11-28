Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbXK1N34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:29:56 -0500
Subject: [PATCH (for #everything] mac80211: drop unencrypted frames if
	encryption is expected
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1196244477.6058.125.camel@johannes.berg>
References: <1196244477.6058.125.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 11:09:38 +0100
Message-Id: <1196244578.6058.128.camel@johannes.berg> (sfid-20071128_133000_056265_0498EE18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression I (most likely) introduced, namely that
unencrypted frames are right now accepted even if we have a key for that
specific sender. That has very bad security implications.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This applies after Ron's RX restructuring patch.

 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/rx.c	2007-11-28 10:59:13.068927951 +0100
+++ everything/net/mac80211/rx.c	2007-11-28 10:59:53.708922037 +0100
@@ -993,7 +993,7 @@ ieee80211_drop_unencrypted(struct ieee80
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     rx->sdata->drop_unencrypted &&
+		     (rx->key || rx->sdata->drop_unencrypted) &&
 		     (!rx->sdata->eapol ||
 		      !ieee80211_is_eapol(rx->skb, hdrlen)))) {
 		if (net_ratelimit())


