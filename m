Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:64056 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZHKAfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 20:35:46 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1230603wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 17:35:47 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: Fix unresolved mesh frames queued without valid control.vif
Date: Mon, 10 Aug 2009 17:24:20 -0700
Message-Id: <1249950260-26536-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh frames that could not be immediately resolved were queued with a NULL
info->control.vif.  This patch moves the call to mesh_nexthop_lookup closer to
the point where it is handed over to ieee80211_tx().  This ensures that the
unresolved frames are ready to be sent once the path is resolved.
---
 net/mac80211/tx.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b9f5be6..56dc8df 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1413,14 +1413,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-	    ieee80211_is_data(hdr->frame_control)) {
-		if (!is_multicast_ether_addr(hdr->addr1))
-			if (mesh_nexthop_lookup(skb, sdata)) {
-				dev_put(sdata->dev);
-				return;
-			}
-	} else if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
+	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		int hdrlen;
 		u16 len_rthdr;
 
@@ -1477,6 +1470,15 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	info->control.vif = &sdata->vif;
 
+	if (ieee80211_vif_is_mesh(&sdata->vif) &&
+	    ieee80211_is_data(hdr->frame_control) &&
+		!is_multicast_ether_addr(hdr->addr1))
+			if (mesh_nexthop_lookup(skb, sdata)) {
+				/* skb queued: don't free */
+				dev_put(sdata->dev);
+				return;
+			}
+
 	ieee80211_select_queue(local, skb);
 	ieee80211_tx(sdata, skb, false);
 	dev_put(sdata->dev);
-- 
1.5.4.3

