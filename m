Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36543 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbANCX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 21:23:56 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so6834247pdb.10
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 18:23:56 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mesh: Skip STA expiration on user_mpm mode
Date: Wed, 14 Jan 2015 11:23:09 +0900
Message-Id: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com> (sfid-20150114_032400_064529_7F0D8181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh STA expiration processing works even if user_mpm mode. This causes
unexpected STA disconnection.

This patch skips STA expiration processing on user_mpm mode.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0c8b2a7..50174fd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,8 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
 
-	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
+	if (!ifmsh->user_mpm)
+		ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-- 
2.1.0

