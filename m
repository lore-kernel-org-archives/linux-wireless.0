Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36600 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbFOD7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 23:59:39 -0400
Received: by pabqy3 with SMTP id qy3so56924890pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 20:59:38 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: process the target only subfield for mesh hwmp accordingly
Date: Mon, 15 Jun 2015 11:58:53 +0800
Message-Id: <1434340733-10972-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150615_055943_160100_3D413C8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does the following:
- Remove unnecessary flags field used by PERR element.
- Use the per target flags defined in ./include/linux/ieee80211.h.
- Process the target only subfield based on case E2 of sec 13.10.9.3
  of IEEE 802.11-2012.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 085edc1..5573e21 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -19,15 +19,6 @@
 
 #define MAX_PREQ_QUEUE_LEN	64
 
-/* Destination only */
-#define MP_F_DO	0x1
-/* Reply and forward */
-#define MP_F_RF	0x2
-/* Unknown Sequence Number */
-#define MP_F_USN    0x01
-/* Reason code Present */
-#define MP_F_RCODE  0x02
-
 static void mesh_queue_preq(struct mesh_path *, u8);
 
 static inline u32 u32_field_get(const u8 *preq_elem, int offset, bool ae)
@@ -279,15 +270,10 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 	*pos++ = ttl;
 	/* number of destinations */
 	*pos++ = 1;
-	/*
-	 * flags bit, bit 1 is unset if we know the sequence number and
-	 * bit 2 is set if we have a reason code
+	/* Flags field has AE bit only as defined in
+	 * sec 8.4.2.117 IEEE802.11-2012
 	 */
 	*pos = 0;
-	if (!target_sn)
-		*pos |= MP_F_USN;
-	if (target_rcode)
-		*pos |= MP_F_RCODE;
 	pos++;
 	memcpy(pos, target, ETH_ALEN);
 	pos += ETH_ALEN;
@@ -570,15 +556,13 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 					SN_LT(mpath->sn, target_sn)) {
 				mpath->sn = target_sn;
 				mpath->flags |= MESH_PATH_SN_VALID;
-			} else if ((!(target_flags & MP_F_DO)) &&
+			} else if ((!(target_flags & IEEE80211_PREQ_TO_FLAG)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
 				target_metric = mpath->metric;
 				target_sn = mpath->sn;
-				if (target_flags & MP_F_RF)
-					target_flags |= MP_F_DO;
-				else
-					forward = false;
+				/* Case E2 of sec 13.10.9.3 IEEE 802.11-2012*/
+				target_flags |= IEEE80211_PREQ_TO_FLAG;
 			}
 		}
 		rcu_read_unlock();
@@ -974,7 +958,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
-	u8 ttl, target_flags;
+	u8 ttl, target_flags = 0;
 	const u8 *da;
 	u32 lifetime;
 
@@ -1033,9 +1017,9 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (preq_node->flags & PREQ_Q_F_REFRESH)
-		target_flags = MP_F_DO;
+		target_flags |= IEEE80211_PREQ_TO_FLAG;
 	else
-		target_flags = MP_F_RF;
+		target_flags &= ~IEEE80211_PREQ_TO_FLAG;
 
 	spin_unlock_bh(&mpath->state_lock);
 	da = (mpath->is_root) ? mpath->rann_snd_addr : broadcast_addr;
-- 
2.3.0

