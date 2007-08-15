Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765280AbXHOOw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:52:29 -0400
Message-Id: <20070815145041.402349000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 01/20] mac80211: fix showing transmitted frames on multiple  monitor interfaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net

---
 net/mac80211/ieee80211.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 13:39:27.816520121 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-15 13:39:40.476520121 +0200
@@ -1190,7 +1190,6 @@ void ieee80211_tx_status(struct ieee8021
 			memset(skb->cb, 0, sizeof(skb->cb));
 			netif_rx(skb);
 			skb = skb2;
-			break;
 		}
 	}
  out:

-- 

