Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZJ2JJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 05:09:56 -0400
Subject: [PATCH] mac80211: fix reason code output endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 10:09:28 +0100
Message-ID: <1256807368.3865.92.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When HT debugging is enabled and we receive a DelBA
frame we print out the reason code in the wrong byte
order. Fix that so we don't get weird values printed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ht.c	2009-10-29 10:07:41.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-10-29 10:07:49.000000000 +0100
@@ -153,7 +153,7 @@ void ieee80211_process_delba(struct ieee
 	if (net_ratelimit())
 		printk(KERN_DEBUG "delba from %pM (%s) tid %d reason code %d\n",
 			mgmt->sa, initiator ? "initiator" : "recipient", tid,
-			mgmt->u.action.u.delba.reason_code);
+			le16_to_cpu(mgmt->u.action.u.delba.reason_code));
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)


