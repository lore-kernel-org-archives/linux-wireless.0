Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57066 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250Ab3FUIaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 04:30:02 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so7471372pbb.36
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jun 2013 01:30:01 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the kernel panic on ath_tx_aggr_wakeup on mesh
Date: Fri, 21 Jun 2013 16:26:55 +0800
Message-Id: <1371803215-2685-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130621_103011_261159_4B5D8C23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The is to fix the kernel panic happens if user space inserts the mesh
STA and not proceed with the SAE and AMPE, and later the same mesh STA
is detected again. The sta_state of the mesh STA remains at
IEEE80211_STA_NONE and if the ieee80211_sta_ps_deliver_wakeup
is called and subsequently the ath_tx_aggr_wakeup, the kernel panic due
to ath_tx_node_init is not called before to initialize the require data
structures.

This issue is reported by Cedric Voncken before.
http://www.spinics.net/lists/linux-wireless/msg106342.html

[<831ea6b4>] ath_tx_aggr_wakeup+0x44/0xcc [ath9k]
[<83084214>] ieee80211_sta_ps_deliver_wakeup+0xb8/0x208 [mac80211]
[<830b9824>] ieee80211_mps_sta_status_update+0x94/0x108 [mac80211]
[<83099398>] ieee80211_sta_ps_transition+0xc94/0x34d8 [mac80211]
[<8022399c>] nf_iterate+0x98/0x104
[<8309bb60>] ieee80211_sta_ps_transition+0x345c/0x34d8 [mac80211]

Thomas Perdersen also mentioned that this patch has fixed the
bad sta magic warning in mac80211_hwsim_set_tim() when applied to
mac80211-next/master

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_ps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..0e42758 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -251,7 +251,8 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 		mps_dbg(sta->sdata, "start PS buffering frames towards %pM\n",
 			sta->sta.addr);
 	} else {
-		ieee80211_sta_ps_deliver_wakeup(sta);
+		if (sta->sta_state >= IEEE80211_STA_ASSOC)
+			ieee80211_sta_ps_deliver_wakeup(sta);
 	}
 
 	/* clear the MPSP flags for non-peers or active STA */
-- 
1.7.0.4

