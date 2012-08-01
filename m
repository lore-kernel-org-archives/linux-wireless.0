Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54576 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2HAVPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 17:15:35 -0400
Received: by pbbrp8 with SMTP id rp8so1678211pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 14:15:35 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: improve cleanup when leaving mesh
Date: Wed,  1 Aug 2012 14:15:31 -0700
Message-Id: <1343855731-27920-1-git-send-email-thomas@cozybit.com> (sfid-20120801_231558_563505_96B4D073)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple improvements to cleanup when stopping a mesh:

 - flush mpath entries.
 - flush sta entries per-sdata so we don't remove entries belonging to
   other vifs on the same hw.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..21c02c6 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -618,7 +618,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->mesh_id_len = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
-	sta_info_flush(local, NULL);
+	sta_info_flush(local, sdata);
+	mesh_path_flush_by_iface(sdata);
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
-- 
1.7.5.4

