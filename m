Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40497 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3FAAoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 20:44:08 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so270776pad.30
        for <linux-wireless@vger.kernel.org>; Fri, 31 May 2013 17:44:08 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: don't check local mesh TTL on TX
Date: Fri, 31 May 2013 17:41:47 -0700
Message-Id: <1370047307-19248-1-git-send-email-thomas@cozybit.com> (sfid-20130601_024413_296853_D14E2A5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211 has already verified the mesh TTL on setting the
mesh config, so no need to check it again in mac80211.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/tx.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 34be933..4105d0c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1790,12 +1790,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
-			/* Do not send frames with mesh_ttl == 0 */
-			sdata->u.mesh.mshstats.dropped_frames_ttl++;
-			goto fail_rcu;
-		}
-
 		if (!is_multicast_ether_addr(skb->data)) {
 			struct sta_info *next_hop;
 			bool mpp_lookup = true;
-- 
1.7.10.4

