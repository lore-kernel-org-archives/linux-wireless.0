Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYAQPJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:09:58 -0500
Subject: [PATCH] mac80211: fix RCU locking in __ieee80211_rx_handle_packet
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 21:47:40 +0100
Message-Id: <1200516460.8007.2.camel@johannes.berg> (sfid-20080117_151006_239830_5CC6D0C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit c7a51bda ("mac80211: restructure __ieee80211_rx") extracted
__ieee80211_rx_handle_packet out of __ieee80211_rx and hence changed
the locking rules for __ieee80211_rx_handle_packet(), it is now
invoked under RCU lock. There is, however, one instance left where
it contains an rcu_read_unlock() in an error path, which is a bug.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
sparse actually detected this.... oh well

 net/mac80211/rx.c |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/net/mac80211/rx.c	2008-01-16 21:15:17.532295846 +0100
+++ everything/net/mac80211/rx.c	2008-01-16 21:15:44.002272517 +0100
@@ -1730,7 +1730,6 @@ void __ieee80211_rx_handle_packet(struct
 		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
 					     rx.sta);
 		sta_info_put(sta);
-		rcu_read_unlock();
 		return;
 	}
 


