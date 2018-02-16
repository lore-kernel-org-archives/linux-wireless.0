Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59074 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756813AbeBPQNL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 11:13:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Feb 2018 18:12:51 +0200
Message-Id: <20180216161301.29339-4-luca@coelho.fi> (sfid-20180216_171316_572978_3B2330D8)
In-Reply-To: <20180216161301.29339-1-luca@coelho.fi>
References: <20180216161301.29339-1-luca@coelho.fi>
Subject: [PATCH 03/13] mac80211: fix calling sleeping function in atomic context
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

sta_info_alloc can be called from atomic paths (such as RX path)
so we need to call pcpu_alloc with the correct gfp.

Fixes: c9c5962b56c1 ("mac80211: enable collecting station statistics per-CPU")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8d7e3732bb61..af0b608ee8ed 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -314,7 +314,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	if (ieee80211_hw_check(hw, USES_RSS)) {
 		sta->pcpu_rx_stats =
-			alloc_percpu(struct ieee80211_sta_rx_stats);
+			alloc_percpu_gfp(struct ieee80211_sta_rx_stats, gfp);
 		if (!sta->pcpu_rx_stats)
 			goto free;
 	}
-- 
2.15.1
