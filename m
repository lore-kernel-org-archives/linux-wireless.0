Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64521 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HXTCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:02:35 -0400
Received: by ywf7 with SMTP id 7so1101813ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 12:02:35 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [RFC 1/3] mac80211: comment allocation of mesh frames
Date: Wed, 24 Aug 2011 12:02:17 -0700
Message-Id: <1314212539-23669-2-git-send-email-thomas@cozybit.com> (sfid-20110824_210238_590005_8D4109D8)
In-Reply-To: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
References: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

save a few bytes and hopefully improve readability.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_hwmp.c  |   10 ++++++++--
 net/mac80211/mesh_plink.c |   13 +++++++++++--
 net/mac80211/tx.c         |   12 +++++++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f09e5e8..d5f4a41 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -129,11 +129,14 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct sk_buff *skb = NULL;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	int ie_len;
 
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    25 + sizeof(mgmt->u.action.u.mesh_action) +
+			    2 + 37); /* HWMP IEs */
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -232,11 +235,14 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct sk_buff *skb = NULL;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	int ie_len;
 
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    25 + sizeof(mgmt->u.action.u.mesh_action) +
+			    2 + 15 /* PERR IE */);
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->hw.extra_tx_headroom);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1a00d0f..f8c9666 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -143,14 +143,23 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		enum ieee80211_self_protected_actioncode action,
 		u8 *da, __le16 llid, __le16 plid, __le16 reason) {
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
-			sdata->u.mesh.ie_len);
+	struct sk_buff *skb = NULL;
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
 	int ie_len = 4;
 	u16 peering_proto = 0;
 	u8 *pos;
 
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    25 + sizeof(mgmt->u.action.u.self_prot) +
+			    2 + /* capability info */
+			    2 + /* AID */
+			    2 + 8 + /* supported rates */
+			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+			    2 + sdata->u.mesh.mesh_id_len +
+			    2 + sizeof(struct ieee80211_meshconf_ie) +
+			    2 + 8 + /* peering IE */
+			    sdata->u.mesh.ie_len);
 	if (!skb)
 		return -1;
 	skb_reserve(skb, local->hw.extra_tx_headroom);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..ba1956a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2278,9 +2278,15 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			goto out;
 #endif
 
-		/* headroom, head length, tail length and maximum TIM length */
-		skb = dev_alloc_skb(local->tx_headroom + 400 +
-				sdata->u.mesh.ie_len);
+		skb = dev_alloc_skb(local->tx_headroom +
+				    24 + sizeof(mgmt->u.beacon) +
+				    2 + /* NULL SSID */
+				    2 + 8 + /* supported rates */
+				    2 + 3 + /* DS params */
+				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+				    2 + sdata->u.mesh.mesh_id_len +
+				    2 + sizeof(struct ieee80211_meshconf_ie) +
+				    sdata->u.mesh.ie_len);
 		if (!skb)
 			goto out;
 
-- 
1.7.4.1

