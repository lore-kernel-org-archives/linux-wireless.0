Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbXHUPH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:07:59 -0400
Message-Id: <20070821150038.073643000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 01/27] mac80211: fix showing transmitted frames on multiple  monitor interfaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net

---
 net/mac80211/ieee80211.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-21 14:39:16.695923881 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-21 14:39:41.445923881 +0200
@@ -1190,7 +1190,6 @@ void ieee80211_tx_status(struct ieee8021
 			memset(skb->cb, 0, sizeof(skb->cb));
 			netif_rx(skb);
 			skb = skb2;
-			break;
 		}
 	}
  out:

-- 

