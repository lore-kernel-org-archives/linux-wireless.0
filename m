Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43736 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1EFWL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:11:57 -0400
Received: by pvg12 with SMTP id 12so1606275pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 15:11:57 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Fabrice Deyber <fabricedeyber@agilemesh.com>,
	Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Only process mesh PREPs with equal seq number if metric is better.
Date: Fri,  6 May 2011 15:11:51 -0700
Message-Id: <1304719911-22636-1-git-send-email-javier@cozybit.com> (sfid-20110507_001201_929354_D77207DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabrice Deyber <fabricedeyber@agilemesh.com>

This fixes routing loops in PREP propagation and is in accordance with Draft
11, Section: 11C.9.8.4.

Signed-off-by: Fabrice Deyber <fabricedeyber@agilemesh.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e57f2e7..849fecd 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -391,7 +391,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			    (mpath->flags & MESH_PATH_SN_VALID)) {
 				if (SN_GT(mpath->sn, orig_sn) ||
 				    (mpath->sn == orig_sn &&
-				     action == MPATH_PREQ &&
 				     new_metric >= mpath->metric)) {
 					process = false;
 					fresh_info = false;
-- 
1.7.1

