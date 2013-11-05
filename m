Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58129 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3KETWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:52 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so9474682pab.28
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:51 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 07/17] mac80211: mesh_plink: collapse the two switch statements together
Date: Tue,  5 Nov 2013 11:16:55 -0800
Message-Id: <1383679025-7150-7-git-send-email-thomas@cozybit.com> (sfid-20131105_202303_037028_9AB3932C)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

The matches_local check can just be done when looking at the
individual action types.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 36b6cff..8e23395 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -821,33 +821,25 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
-	if (!matches_local) {
-		switch (ftype) {
-		case WLAN_SP_MESH_PEERING_OPEN:
-			event = OPN_RJCT;
-			break;
-		case WLAN_SP_MESH_PEERING_CONFIRM:
-			event = CNF_RJCT;
-			break;
-		default:
-			break;
-		}
-	}
 
 	if (!sta)
 		event = OPN_ACPT;
-	else if (matches_local) {
+	else {
 		switch (ftype) {
 		case WLAN_SP_MESH_PEERING_OPEN:
-			if (!mesh_plink_free_count(sdata) ||
-			    (sta->plid && sta->plid != plid))
+			if (!matches_local)
+				event = OPN_RJCT;
+			else if (!mesh_plink_free_count(sdata) ||
+				 (sta->plid && sta->plid != plid))
 				event = OPN_IGNR;
 			else
 				event = OPN_ACPT;
 			break;
 		case WLAN_SP_MESH_PEERING_CONFIRM:
-			if (!mesh_plink_free_count(sdata) ||
-			    (sta->llid != llid || sta->plid != plid))
+			if (!matches_local)
+				event = CNF_RJCT;
+			else if (!mesh_plink_free_count(sdata) ||
+				 (sta->llid != llid || sta->plid != plid))
 				event = CNF_IGNR;
 			else
 				event = CNF_ACPT;
-- 
1.8.4.rc3

