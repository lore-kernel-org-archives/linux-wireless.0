Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44083 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3KETXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:02 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so9361220pab.14
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:01 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 12/17] mac80211: consolidate rcu unlocks in plink frame rx
Date: Tue,  5 Nov 2013 11:17:00 -0800
Message-Id: <1383679025-7150-12-git-send-email-thomas@cozybit.com> (sfid-20131105_202308_680891_31FEF240)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c234ddb..e70f490 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -757,40 +757,33 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	    !rssi_threshold_check(sdata, sta)) {
 		mpl_dbg(sdata, "Mesh plink: %pM does not meet rssi threshold\n",
 			mgmt->sa);
-		rcu_read_unlock();
-		return;
+		goto unlock_rcu;
 	}
 
 	if (!sta) {
 		if (ftype != WLAN_SP_MESH_PEERING_OPEN) {
 			mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
-			rcu_read_unlock();
-			return;
+			goto unlock_rcu;
 		}
 		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
 		if (!mesh_plink_free_count(sdata)) {
 			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
-			rcu_read_unlock();
-			return;
+			goto unlock_rcu;
 		}
 		/* deny open request from non-matching peer */
 		if (!matches_local) {
-			rcu_read_unlock();
 			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 					    mgmt->sa, 0, plid,
 					    cpu_to_le16(WLAN_REASON_MESH_CONFIG));
-			return;
+			goto unlock_rcu;
 		}
 	} else {
 		if (!test_sta_flag(sta, WLAN_STA_AUTH)) {
 			mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
-			rcu_read_unlock();
-			return;
-		}
-		if (sta->plink_state == NL80211_PLINK_BLOCKED) {
-			rcu_read_unlock();
-			return;
+			goto unlock_rcu;
 		}
+		if (sta->plink_state == NL80211_PLINK_BLOCKED)
+			goto unlock_rcu;
 	}
 
 	/* Now we will figure out the appropriate event... */
@@ -839,8 +832,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			break;
 		default:
 			mpl_dbg(sdata, "Mesh plink: unknown frame subtype\n");
-			rcu_read_unlock();
-			return;
+			goto unlock_rcu;
 		}
 	}
 
@@ -850,8 +842,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
 		if (!sta) {
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
-			rcu_read_unlock();
-			return;
+			goto unlock_rcu;
 		}
 	}
 
@@ -998,6 +989,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+unlock_rcu:
 	rcu_read_unlock();
 
 	if (changed)
-- 
1.8.4.rc3

