Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33641 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZJTUVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 16:21:47 -0400
Received: by fxm18 with SMTP id 18so6877661fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 13:21:51 -0700 (PDT)
Date: Tue, 20 Oct 2009 21:21:48 +0100
From: Rui Paulo <rpaulo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, John Linville <linville@tuxdriver.com>
Subject: [PATCH] mesh: use set_bit() to set MESH_WORK_HOUSEKEEPING.
Message-ID: <20091020202148.GA29602@asus-p5b.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the mesh housekeeping timer work properly on big endian
systems.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f7364e5..9a73389 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -50,7 +50,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	ifmsh->wrkq_flags |= MESH_WORK_HOUSEKEEPING;
+	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 
 	if (local->quiescing) {
 		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
@@ -480,7 +480,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 
-	ifmsh->wrkq_flags |= MESH_WORK_HOUSEKEEPING;
+	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_queue_work(&local->hw, &ifmsh->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
-- 
1.6.4.3

