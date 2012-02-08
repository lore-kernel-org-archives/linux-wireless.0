Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50517 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2BHFJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:39 -0500
Received: by daed14 with SMTP id d14so173281dae.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 21:09:39 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH] mac80211: rename mesh static path_lookup()
Date: Tue,  7 Feb 2012 21:09:25 -0800
Message-Id: <1328677765-21971-1-git-send-email-mcgrof@frijolero.org> (sfid-20120208_061534_612032_8CFCD87D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you want to use mesh support from mac80211 on a recent
kernel on 2.6.24 you'll run into a name clash when compiling
against include/linux/namei.h, so rename this routine.

/home/mcgrof/tmp/compat-wireless-3.2.5-1/net/mac80211/mesh_pathtbl.c: At top level:
/home/mcgrof/tmp/compat-wireless-3.2.5-1/net/mac80211/mesh_pathtbl.c:342:26: error: conflicting types for ‘path_lookup’
include/linux/namei.h:71:12: note: previous declaration of ‘path_lookup’ was here

Although this could sit as a separate patch in compat-wireless it seems
best to just merge upstream.

Cc: Javier Cardona <javier@cozybit.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 net/mac80211/mesh_pathtbl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index edf167e..dc51669 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -336,7 +336,7 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 }
 
 
-static struct mesh_path *path_lookup(struct mesh_table *tbl, u8 *dst,
+static struct mesh_path *mpath_lookup(struct mesh_table *tbl, u8 *dst,
 					  struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
@@ -371,12 +371,12 @@ static struct mesh_path *path_lookup(struct mesh_table *tbl, u8 *dst,
  */
 struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
-	return path_lookup(rcu_dereference(mesh_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
 }
 
 struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
-	return path_lookup(rcu_dereference(mpp_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(mpp_paths), dst, sdata);
 }
 
 
-- 
1.7.4.15.g7811d

