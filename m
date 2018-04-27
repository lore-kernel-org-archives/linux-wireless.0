Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:39264
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758865AbeD0T0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 15:26:53 -0400
From: peter.oh@bowerswilkins.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Peter Oh <peter.oh@bowerswilkins.com>, johannes.berg@intel.com
Subject: [PATCH] mesh: don't process mesh channel switch unless csa ie provided
Date: Fri, 27 Apr 2018 12:26:36 -0700
Message-Id: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com> (sfid-20180427_212657_786960_82D0DC24)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <peter.oh@bowerswilkins.com>

There is no meaning to call ieee80211_mesh_process_chnswitch
without CSA IE provided, since the function will always return error.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 net/mac80211/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d51da26e9c18..8ced757dff8d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1196,7 +1196,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			stype, mgmt, &elems, rx_status);
 
 	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
-	    !sdata->vif.csa_active)
+	    !sdata->vif.csa_active && elems.ch_switch_ie)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
-- 
2.11.0 (Apple Git-81)
