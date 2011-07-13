Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50751 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1GMXqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:16 -0400
Received: by iwn6 with SMTP id 6so6060378iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 16:46:15 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
Date: Wed, 13 Jul 2011 16:45:47 -0700
Message-Id: <1310600747-9583-6-git-send-email-thomas@cozybit.com> (sfid-20110714_014621_447397_E1F3DF5B)
In-Reply-To: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though we don't currently implement PS for mesh points, the
standard asks us to include a TIM element in beacons. Include an empty
element for now.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/tx.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1389e8..174db68 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2251,6 +2251,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+		u8 *pos;
 #ifdef CONFIG_MAC80211_MESH
 		if (!sdata->u.mesh.mesh_id_len)
 			goto out;
@@ -2269,6 +2270,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			memcpy(skb_put(skb, beacon->head_len), beacon->head,
 			       beacon->head_len);
 
+			pos = skb_put(skb, 6);
+			*pos++ = WLAN_EID_TIM;
+			*pos++ = 4;
+			*pos++ = 0;	/* DTIM count */
+			*pos++ = 0;	/* DTIM period */
+			*pos++ = 0;	/* Bitmap control */
+			*pos++ = 0;	/* Part Virt Bitmap */
+
 			if (beacon->tail && beacon->tail_len)
 				memcpy(skb_put(skb, beacon->tail_len),
 				       beacon->tail, beacon->tail_len);
-- 
1.7.6

