Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab2FFWtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 18:49:08 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so9416638dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 15:49:08 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] mac80211: Remove unused variable
Date: Wed,  6 Jun 2012 15:48:48 -0700
Message-Id: <1339022932-14240-3-git-send-email-jason@cozybit.com> (sfid-20120607_004923_109644_43BD9DCC)
In-Reply-To: <1339022932-14240-1-git-send-email-jason@cozybit.com>
References: <1339022932-14240-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
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

