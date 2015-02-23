Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbbBWXeC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 18:34:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify station assignment in ieee80211_tx_prepare()
Date: Tue, 24 Feb 2015 00:33:58 +0100
Message-Id: <1424734438-18209-1-git-send-email-johannes@sipsolutions.net> (sfid-20150224_003406_438906_A7AC85CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the second conditional as the same will be
done immediately afterwards if there's no station assigned.

Remove the useless conditional, move fallback assignment into
the else branch and don't try to look up a multicast address
which cannot be found anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 88a18ffe2975..76b95ce23113 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1167,13 +1167,9 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
-				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
-		   tx->sdata->control_port_protocol == tx->skb->protocol) {
+	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
-	if (!tx->sta)
-		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
-- 
2.1.4

