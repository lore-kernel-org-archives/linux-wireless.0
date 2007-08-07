Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbXHGJq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:46:26 -0400
Subject: [PATCH] mac80211: fix tx status frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jbenc <jbenc@suse.cz>, "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 10:23:57 +0200
Message-Id: <1186475037.4067.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I added the monitor for outgoing frames somehow a break
statement slipped in. Remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net

---
Against wireless-dev, but should be trivial to apply against mac80211
the tree :)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-06 20:10:47.770049363 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-06 20:34:00.090049363 +0200
@@ -4875,7 +4877,6 @@ void ieee80211_tx_status(struct ieee8021
 			memset(skb->cb, 0, sizeof(skb->cb));
 			netif_rx(skb);
 			skb = skb2;
-			break;
 		}
 	}
  out:


