Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0IXJUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 05:20:50 -0400
Subject: [PATCH wireless-2.6] mac80211: fix use-after-free
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 11:20:47 +0200
Message-ID: <1285320047.3699.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 8c0c709eea5cbab97fb464cd68b06f24acc58ee1
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Nov 25 17:46:15 2009 +0100

    mac80211: move cmntr flag out of rx flags

moved the CMTR flag into the skb's status, and
in doing so introduced a use-after-free -- when
the skb has been handed to cooked monitors the
status setting will touch now invalid memory.

Additionally, moving it there has effectively
discarded the optimisation -- since the bit is
only ever set on freed SKBs, and those were a
copy, it could never be checked.

For the current release, fixing this properly
is a bit too involved, so let's just remove the
problematic code and leave userspace with one
copy of each frame for each virtual interface.

Cc: stable@kernel.org [2.6.33+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
NOTE: John, you either need to put this into wireless-2.6
      and then merge that into wireless-next-2.6 and revert
      this patch before applying my other patchset, or there
      will be merge issues (which should be fairly simple,
      but I haven't tried) when you later merge wireless-2.6
      into wireless-next-2.6 or this happens in linux-next.

 net/mac80211/rx.c |    4 ----
 1 file changed, 4 deletions(-)

--- iwlwifi-jo.orig/net/mac80211/rx.c	2010-09-24 11:13:33.000000000 +0200
+++ iwlwifi-jo/net/mac80211/rx.c	2010-09-24 11:14:28.000000000 +0200
@@ -2199,9 +2199,6 @@ static void ieee80211_rx_cooked_monitor(
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (status->flag & RX_FLAG_INTERNAL_CMTR)
-		goto out_free_skb;
-
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
 		goto out_free_skb;
@@ -2260,7 +2257,6 @@ static void ieee80211_rx_cooked_monitor(
 	} else
 		goto out_free_skb;
 
-	status->flag |= RX_FLAG_INTERNAL_CMTR;
 	return;
 
  out_free_skb:


