Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1JUIR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:17:56 -0400
Subject: [PATCH] mac80211: exit cooked monitor RX early if there are none
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 10:17:51 +0200
Message-ID: <1319185071.3964.5.camel@jlt3.sipsolutions.net> (sfid-20111021_101800_770366_7AA6D934)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are no cooked monitor interfaces, there's
no point in building the radiotap RX header for the
frame and iterating the interface list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/rx.c	2011-10-20 22:03:03.000000000 +0200
+++ b/net/mac80211/rx.c	2011-10-21 10:15:27.000000000 +0200
@@ -2496,6 +2496,10 @@ static void ieee80211_rx_cooked_monitor(
 		goto out_free_skb;
 	rx->flags |= IEEE80211_RX_CMNTR;
 
+	/* If there are no cooked monitor interfaces, just free the SKB */
+	if (!local->>cooked_mntrs)
+		goto out_free_skb;
+
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
 		goto out_free_skb;


