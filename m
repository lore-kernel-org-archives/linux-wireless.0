Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64327 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HXTCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:02:44 -0400
Received: by yxj19 with SMTP id 19so1102250yxj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 12:02:43 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [RFC 3/3] mac80211: set HT capabilities for mesh peer
Date: Wed, 24 Aug 2011 12:02:19 -0700
Message-Id: <1314212539-23669-4-git-send-email-thomas@cozybit.com> (sfid-20110824_210247_482564_DD2743E1)
In-Reply-To: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
References: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8f068b1..e9dd761 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -76,11 +76,15 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
  *       on it in the lifecycle management section!
  */
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-					 u8 *hw_addr, u32 rates)
+					 u8 *hw_addr, u32 rates,
+					 struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
@@ -90,6 +94,9 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	if (elems->ht_cap_elem)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband, elems->ht_cap_elem,
+						  &sta->sta.ht_cap);
 	rate_control_rate_init(sta);
 
 	return sta;
@@ -251,8 +258,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata,
-		struct ieee802_11_elems *elems)
+			   struct ieee80211_sub_if_data *sdata,
+			   struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -269,7 +276,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 					elems->ie_start, elems->total_len,
 					GFP_KERNEL);
 		else
-			sta = mesh_plink_alloc(sdata, hw_addr, rates);
+			sta = mesh_plink_alloc(sdata, hw_addr, rates, elems);
 		if (!sta)
 			return;
 		if (sta_info_insert_rcu(sta)) {
@@ -560,7 +567,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 
 		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
-		sta = mesh_plink_alloc(sdata, mgmt->sa, rates);
+		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, &elems);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
 			return;
-- 
1.7.4.1

