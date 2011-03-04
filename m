Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37346 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab1CDDMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:12:03 -0500
Received: by mail-yw0-f46.google.com with SMTP id 3so612661ywj.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:12:02 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 7/7] mac80211: Check auth status before attempting to establish a peer link
Date: Thu,  3 Mar 2011 19:11:47 -0800
Message-Id: <1299208307-9428-8-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5a845fd..a89a90e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -378,6 +378,9 @@ int mesh_plink_open(struct sta_info *sta)
 	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (!test_sta_flags(sta, WLAN_STA_AUTH))
+		return -EPERM;
+
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
@@ -486,7 +489,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
-	if (sta && sta->plink_state == PLINK_BLOCKED) {
+	if (sta && (!test_sta_flags(sta, WLAN_STA_AUTH) ||
+					sta->plink_state == PLINK_BLOCKED)) {
+		mpl_dbg("Mesh plink: blocked or unauthenticated peer\n");
 		rcu_read_unlock();
 		return;
 	}
-- 
1.7.0.4

