Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1JMLTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 07:19:24 -0400
Subject: [PATCH] mac80211: fix TID for null poll response
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 13:19:19 +0200
Message-ID: <1318504759.5612.16.camel@jlt3.sipsolutions.net> (sfid-20111013_131928_357709_56A2397C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue mapping/TID for non-QoS null data
responses to is never set, making it default
to BK. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/mac80211/sta_info.c	2011-10-07 10:43:31.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-10-13 13:16:57.000000000 +0200
@@ -1203,11 +1203,9 @@ static void ieee80211_send_null_response
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
 
+	skb->priority = tid;
+	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
 	if (qos) {
-		skb->priority = tid;
-
-		skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
-
 		nullfunc->qos_ctrl = cpu_to_le16(tid);
 
 		if (reason == IEEE80211_FRAME_RELEASE_UAPSD)


