Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab1DGXJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:34 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so2935734iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:34 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com
Subject: [PATCH v8 6/9] mac80211: ignore peer link requests from unauthenticated stations.
Date: Thu,  7 Apr 2011 15:08:32 -0700
Message-Id: <1302214115-3688-7-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_plink.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index bafe255..5d0dd92 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -372,6 +372,9 @@ int mesh_plink_open(struct sta_info *sta)
 	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (!test_sta_flags(sta, WLAN_STA_AUTH))
+		return -EPERM;
+
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
@@ -484,6 +487,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
+	if (sta && !test_sta_flags(sta, WLAN_STA_AUTH)) {
+		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
+		rcu_read_unlock();
+		return;
+	}
+
 	if (sta && sta->plink_state == PLINK_BLOCKED) {
 		rcu_read_unlock();
 		return;
-- 
1.7.4.4

