Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39235 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3FUGxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 02:53:47 -0400
Received: by mail-pb0-f42.google.com with SMTP id un1so7349874pbc.15
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jun 2013 23:53:47 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>, marco@cozybit.com,
	Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/2] mac80211: initialize power mode for mesh STAs
Date: Thu, 20 Jun 2013 23:50:59 -0700
Message-Id: <1371797459-16585-2-git-send-email-thomas@cozybit.com> (sfid-20130621_085350_298875_3D27B183)
In-Reply-To: <1371797459-16585-1-git-send-email-thomas@cozybit.com>
References: <1371797459-16585-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the default mesh STA nonpeer power mode was
UNKNOWN (0) make the default mesh STA power mode ACTIVE,
to prevent unnecessary  frame buffering while peering is
not yet complete. Fixes a panic in ath9k_htc when adding
stations from userspace, and mcast buffered frames are
later released.

Thanks to Bob Copeland for his help debugging this.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/sta_info.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aaf68d2..aeb967a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -347,6 +347,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    !sdata->u.mesh.user_mpm)
 		init_timer(&sta->plink_timer);
+	sta->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 #endif
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
-- 
1.7.10.4

