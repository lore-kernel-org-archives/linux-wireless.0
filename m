Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249Ab2FHUag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 16:30:36 -0400
Received: by pbbrp8 with SMTP id rp8so2994377pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 13:30:36 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: Remove unused variable
Date: Fri,  8 Jun 2012 13:30:24 -0700
Message-Id: <1339187425-12549-2-git-send-email-jason@cozybit.com> (sfid-20120608_223040_172011_873C2EC2)
In-Reply-To: <1339187425-12549-1-git-send-email-jason@cozybit.com>
References: <1339187425-12549-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
formerly sent as:
	[PATCH v3 2/5] mac80211: Remove unused variable

 net/mac80211/mesh_hwmp.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fa7c580..acbd1ad 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -323,7 +323,6 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
-	struct ieee80211_supported_band *sband;
 	struct rate_info rinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
@@ -333,8 +332,6 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	u32 tx_time, estimated_retx;
 	u64 result;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-- 
1.7.9.5

