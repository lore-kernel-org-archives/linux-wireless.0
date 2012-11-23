Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40326 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2KWUX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:23:27 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com,
	ashok@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix for mesh sync to indicate TBTT adjustment
Date: Fri, 23 Nov 2012 12:23:18 -0800
Message-Id: <1353702198-12865-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_212330_948675_F65BACEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the mesh sync code checks, whether peers indicate TBTT adjustment,
but it never sets the corresponding flag itself.

By setting ifmsh->tbtt_adjusting to true, it will set the corresponding field
in the mesh configuration IE of own beacons.
This indication will be set in the current beacon. The TBTT adjustment will be
performed afterwards, affecting the next beacon. Thus, the first beacon with
stable TBTT will not indicate adjustment anymore and peers will continue
tracking the new offset.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/mesh_sync.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 407c870..c0dc0a9 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -225,11 +225,15 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 			  ifmsh->sync_offset_clockdrift_max);
 		set_bit(MESH_WORK_DRIFT_ADJUST,
 			&ifmsh->wrkq_flags);
+
+		ifmsh->adjusting_tbtt = true;
 	} else {
 		msync_dbg(sdata,
 			  "TBTT : max clockdrift=%lld; too small to adjust\n",
 			  (long long)ifmsh->sync_offset_clockdrift_max);
 		ifmsh->sync_offset_clockdrift_max = 0;
+
+		ifmsh->adjusting_tbtt = false;
 	}
 	spin_unlock_bh(&ifmsh->sync_offset_lock);
 }
-- 
1.7.9.5

