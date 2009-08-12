Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:38253 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZHLSPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:15:25 -0400
Received: by rv-out-0506.google.com with SMTP id f6so67731rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:15:26 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: David Woo <xinhua_wu@realsil.com.cn>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 1/2] mac80211: Mark a destination sequence number as valid when a PREQ is received.
Date: Wed, 12 Aug 2009 11:03:43 -0700
Message-Id: <1250100224-23832-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1250100224-23832-1-git-send-email-javier@cozybit.com>
References: <4A82639F.6000908@realsil.com.cn>
 <1250100224-23832-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woo <xinhua_wu@realsil.com.cn>

If a PREQ frame is received giving us a fresher DSN than what we have, record
the new dsn and mark it as valid.  This patch fixes a bug in the setting of the
MESH_PATH_DSN_VALID flag.

Also, minor fix to coding style on that file.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 1cd1e72..ef1efd3 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -397,7 +397,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *preq_elem, u32 metric) {
+				    u8 *preq_elem, u32 metric)
+{
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
@@ -430,7 +431,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
 					DSN_LT(mpath->dsn, dst_dsn)) {
 				mpath->dsn = dst_dsn;
-				mpath->flags &= MESH_PATH_DSN_VALID;
+				mpath->flags |= MESH_PATH_DSN_VALID;
 			} else if ((!(dst_flags & MP_F_DO)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
-- 
1.5.4.3

