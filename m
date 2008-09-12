Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYILUR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:17:59 -0400
Subject: Re: [PATCH v2] mac80211: fix virtual interfaces vs. injection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221173167.5956.16.camel@johannes.berg> (sfid-20080912_004647_949138_0EDBD3E9)
References: <1221172545.5956.7.camel@johannes.berg>
	 (sfid-20080912_003625_890683_38C8ADDA)  <1221173167.5956.16.camel@johannes.berg>
	 (sfid-20080912_004647_949138_0EDBD3E9)
Content-Type: text/plain
Date: Fri, 12 Sep 2008 16:53:56 +0200
Message-Id: <1221231237.5576.2.camel@johannes.berg> (sfid-20080912_221803_802287_33BFC808)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> waiting for the compile to finish (just in case it doesn't) is often
> useful...

This still has a bug! I suck. Here's an incremental fix.


Subject: mac80211: fix device refcount bug

mac80211 is releasing the reference of the wrong interface here.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/tx.c	2008-09-12 16:40:12.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-12 16:40:37.000000000 +0200
@@ -1381,8 +1381,8 @@ int ieee80211_master_start_xmit(struct s
 						       hdr->addr2)) {
 					dev_hold(sdata->dev);
 					dev_put(odev);
-					odev = osdata->dev;
 					osdata = sdata;
+					odev = osdata->dev;
 					skb->iif = sdata->dev->ifindex;
 					monitor_iface = FOUND_SDATA;
 					break;


