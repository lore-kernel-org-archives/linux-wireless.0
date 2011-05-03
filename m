Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab1ECX5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:36 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so260225pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:36 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 04/13] open80211s: Stop using zero for address 3 in mesh plink mgmt frames
Date: Tue,  3 May 2011 16:57:10 -0700
Message-Id: <1304467039-7730-5-git-send-email-javier@cozybit.com> (sfid-20110504_015741_295263_47DCAF9E)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous versions of 11s draft used the all zeroes address.  Current
draft uses the same address as address 2.

Also, use the ANA-approved action category code for peer establishment frames.

Note: This breaks compatibility with previous mesh protocol instances.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_plink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0120e9e..2c37bee 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -43,7 +43,7 @@
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
 enum plink_frame_type {
-	PLINK_OPEN = 0,
+	PLINK_OPEN = 1,
 	PLINK_CONFIRM,
 	PLINK_CLOSE
 };
@@ -181,7 +181,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 					  IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	/* BSSID is left zeroed, wildcard value */
+	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
 	mgmt->u.action.u.plink_action.action_code = action;
 
-- 
1.7.1

