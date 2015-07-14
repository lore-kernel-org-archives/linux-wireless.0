Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34121 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbGNMcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:32:16 -0400
Received: by iebmu5 with SMTP id mu5so9948216ieb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:32:16 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 5/5] mac80211: select an AID when creating new mesh STAs
Date: Tue, 14 Jul 2015 08:31:59 -0400
Message-Id: <1436877119-17577-6-git-send-email-me@bobcopeland.com> (sfid-20150714_143227_832790_AC27A2F3)
In-Reply-To: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using peer link id for AID, generate a new
AID when creating mesh STAs in the kernel peering manager.
This enables smaller TIM elements and more closely follows
the standard, and it also enables mesh to work on drivers
that require a valid AID when the STA is inserted (ath10k
firmware has this requirement, for example).

In the case of userspace-managed stations, we use the AID
from NL80211_CMD_NEW_STATION.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

v2: generate the bitmap as needed inside mesh_allocate_aid rather
than maintaining the whole time (Johannes)

v3: unchanged from v2

 net/mac80211/mesh_plink.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 3323413acb77..e12be2e4e8df 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -422,20 +422,54 @@ out:
 	spin_unlock_bh(&sta->mesh->plink_lock);
 }
 
+static int mesh_allocate_aid(struct ieee80211_sub_if_data *sdata)
+{
+	struct sta_info *sta;
+	unsigned long *aid_map;
+	int aid;
+
+	aid_map = kcalloc(BITS_TO_LONGS(IEEE80211_MAX_AID + 1),
+			  sizeof(*aid_map), GFP_KERNEL);
+	if (!aid_map)
+		return -ENOMEM;
+
+	/* reserve aid 0 for mcast indication */
+	__set_bit(0, aid_map);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list)
+		__set_bit(sta->sta.aid, aid_map);
+	rcu_read_unlock();
+
+	aid = find_first_zero_bit(aid_map, IEEE80211_MAX_AID + 1);
+	kfree(aid_map);
+
+	if (aid > IEEE80211_MAX_AID)
+		return -ENOBUFS;
+
+	return aid;
+}
+
 static struct sta_info *
 __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 {
 	struct sta_info *sta;
+	int aid;
 
 	if (sdata->local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
+	aid = mesh_allocate_aid(sdata);
+	if (aid < 0)
+		return NULL;
+
 	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
 	if (!sta)
 		return NULL;
 
 	sta->mesh->plink_state = NL80211_PLINK_LISTEN;
 	sta->sta.wme = true;
+	sta->sta.aid = aid;
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
@@ -659,8 +693,6 @@ static u16 mesh_get_new_llid(struct ieee80211_sub_if_data *sdata)
 
 	do {
 		get_random_bytes(&llid, sizeof(llid));
-		/* for mesh PS we still only have the AID range for TIM bits */
-		llid = (llid % IEEE80211_MAX_AID) + 1;
 	} while (llid_in_use(sdata, llid));
 
 	return llid;
@@ -1069,7 +1101,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			goto unlock_rcu;
 		}
 		sta->mesh->plid = plid;
-		sta->sta.aid = plid;
 	} else if (!sta && event == OPN_RJCT) {
 		mesh_plink_frame_tx(sdata, NULL, WLAN_SP_MESH_PEERING_CLOSE,
 				    mgmt->sa, 0, plid,
@@ -1082,10 +1113,8 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	if (event == CNF_ACPT) {
 		/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
-		if (!sta->mesh->plid) {
+		if (!sta->mesh->plid)
 			sta->mesh->plid = plid;
-			sta->sta.aid = sta->mesh->plid;
-		}
 
 		sta->mesh->aid = get_unaligned_le16(PLINK_CNF_AID(mgmt));
 	}
-- 
2.1.4

