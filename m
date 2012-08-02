Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44689 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2HBXsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 19:48:04 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so134525ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 16:48:04 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/4] mac80211: don't request ack for peering close
Date: Thu,  2 Aug 2012 16:47:53 -0700
Message-Id: <1343951274-24956-3-git-send-email-thomas@cozybit.com> (sfid-20120803_014859_393862_47974CF3)
In-Reply-To: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
References: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make a lot of sense to wait for an ack in response to a
peering close frame since either peer in this exchange could be going
down.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..fba8d86 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -217,6 +217,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		u8 *da, __le16 llid, __le16 plid, __le16 reason) {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
 	u16 peering_proto = 0;
@@ -238,6 +239,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    sdata->u.mesh.ie_len);
 	if (!skb)
 		return -1;
+	info = IEEE80211_SKB_CB(skb);
 	skb_reserve(skb, local->tx_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
 	memset(mgmt, 0, hdr_len);
@@ -265,6 +267,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		    mesh_add_meshconf_ie(skb, sdata))
 			return -1;
 	} else {	/* WLAN_SP_MESH_PEERING_CLOSE */
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 		if (mesh_add_meshid_ie(skb, sdata))
 			return -1;
 	}
-- 
1.7.5.4

