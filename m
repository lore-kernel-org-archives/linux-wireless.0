Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:43038 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2JFA5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 20:57:46 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so543933dak.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2012 17:57:46 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: call drv_get_tsf() in sleepable context
Date: Fri,  5 Oct 2012 17:57:40 -0700
Message-Id: <1349485060-8643-2-git-send-email-thomas@cozybit.com> (sfid-20121006_025755_665406_203B6C67)
In-Reply-To: <1349485060-8643-1-git-send-email-thomas@cozybit.com>
References: <1349485060-8643-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to drv_get/set_tsf() was put on the workqueue to perform tsf
adjustments since that function might sleep. However it ended up inside
a spinlock, whose critical section must be atomic. Do tsf adjustment
outside the spinlock instead, and get rid of a warning.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_sync.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index accfa00..a16b7b4 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -56,7 +56,6 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 	u64 tsfdelta;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
-
 	if (ifmsh->sync_offset_clockdrift_max < beacon_int_fraction) {
 		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting\n",
 			  (long long) ifmsh->sync_offset_clockdrift_max);
@@ -69,11 +68,11 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		tsfdelta = -beacon_int_fraction;
 		ifmsh->sync_offset_clockdrift_max -= beacon_int_fraction;
 	}
+	spin_unlock_bh(&ifmsh->sync_offset_lock);
 
 	tsf = drv_get_tsf(local, sdata);
 	if (tsf != -1ULL)
 		drv_set_tsf(local, sdata, tsf + tsfdelta);
-	spin_unlock_bh(&ifmsh->sync_offset_lock);
 }
 
 static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
-- 
1.7.5.4

