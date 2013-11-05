Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56337 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3KETXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:04 -0500
Received: by mail-pa0-f43.google.com with SMTP id hz1so9373402pad.30
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:23:03 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 13/17] mac80211: assign sta plid early
Date: Tue,  5 Nov 2013 11:17:01 -0800
Message-Id: <1383679025-7150-13-git-send-email-thomas@cozybit.com> (sfid-20131105_202309_365363_57E37F09)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we store the peer link ID right after initializing a
new neighbor, there is no need to do it later in the
peering FSM.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e70f490..fa86d35 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -844,6 +844,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			goto unlock_rcu;
 		}
+		sta->plid = plid;
 	}
 
 	mpl_dbg(sdata, "peer %pM in state %s got event %s\n", mgmt->sa,
@@ -857,7 +858,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			break;
 		case OPN_ACPT:
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			sta->plid = plid;
 			get_random_bytes(&llid, 2);
 			sta->llid = llid;
 			mesh_plink_timer_set(sta,
@@ -885,7 +885,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 		case OPN_ACPT:
 			/* retry timer is left untouched */
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
-			sta->plid = plid;
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
-- 
1.8.4.rc3

