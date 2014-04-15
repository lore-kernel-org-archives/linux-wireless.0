Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37106 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaDOOoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 10:44:17 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so11024187oag.27
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2014 07:44:16 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>,
	Bob Copeland <bob@cozybit.com>
Subject: [PATCH 3/3] mac80211: mesh: always use the latest target_sn
Date: Tue, 15 Apr 2014 10:43:08 -0400
Message-Id: <1397572988-3181-3-git-send-email-me@bobcopeland.com> (sfid-20140415_164424_923794_30F285E5)
In-Reply-To: <1397572988-3181-1-git-send-email-me@bobcopeland.com>
References: <1397572988-3181-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a path target responds to a path request, its response
always contains the most up-to-date information; accordingly,
it should use the latest target_sn, regardless of
net_traversal_jiffies().  Otherwise, only the first path
response is considered when constructing a path, as it will
have the highest target_sn of all replies during that period.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_hwmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 03ff5ea..94758b9 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -544,9 +544,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		if (time_after(jiffies, ifmsh->last_sn_update +
 					net_traversal_jiffies(sdata)) ||
 		    time_before(jiffies, ifmsh->last_sn_update)) {
-			target_sn = ++ifmsh->sn;
+			++ifmsh->sn;
 			ifmsh->last_sn_update = jiffies;
 		}
+		target_sn = ifmsh->sn;
 	} else if (is_broadcast_ether_addr(target_addr) &&
 		   (target_flags & IEEE80211_PREQ_TO_FLAG)) {
 		rcu_read_lock();
-- 
1.9.1

