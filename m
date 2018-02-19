Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59702 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752897AbeBSMs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:48:56 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:35 +0200
Message-Id: <20180219124847.27169-2-luca@coelho.fi> (sfid-20180219_134903_224965_00D604A5)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 01/13] mac80211: fix a possible leak of station stats
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

If sta_info_alloc fails after allocating the per CPU statistics,
they are not properly freed.

Fixes: c9c5962b56c1 ("mac80211: enable collecting station statistics per-CPU")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0c5627f8a104..8d7e3732bb61 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -433,6 +433,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (sta->sta.txq[0])
 		kfree(to_txq_info(sta->sta.txq[0]));
 free:
+	free_percpu(sta->pcpu_rx_stats);
 #ifdef CONFIG_MAC80211_MESH
 	kfree(sta->mesh);
 #endif
-- 
2.15.1
