Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35933 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbF2DvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2015 23:51:03 -0400
Received: by pdcu2 with SMTP id u2so108794177pdc.3
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2015 20:51:02 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: remove compilation warning on mesh
Date: Mon, 29 Jun 2015 11:50:47 +0800
Message-Id: <1435549847-18680-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150629_055118_943437_2BC05771)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the warning on the following:
mesh_hwmp.c: warning: ‘target_metric’ may be used
uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d80e0a4..1a1f652 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -530,7 +530,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	const u8 *target_addr, *orig_addr;
 	const u8 *da;
 	u8 target_flags, ttl, flags;
-	u32 orig_sn, target_sn, lifetime, target_metric;
+	u32 orig_sn, target_sn, lifetime, target_metric = 0;
 	bool reply = false;
 	bool forward = true;
 	bool root_is_gate;
@@ -551,7 +551,6 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		mhwmp_dbg(sdata, "PREQ is for us\n");
 		forward = false;
 		reply = true;
-		target_metric = 0;
 		if (time_after(jiffies, ifmsh->last_sn_update +
 					net_traversal_jiffies(sdata)) ||
 		    time_before(jiffies, ifmsh->last_sn_update)) {
@@ -568,7 +567,6 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				reply = true;
 				target_addr = sdata->vif.addr;
 				target_sn = ++ifmsh->sn;
-				target_metric = 0;
 				ifmsh->last_sn_update = jiffies;
 			}
 			if (root_is_gate)
-- 
2.3.0

