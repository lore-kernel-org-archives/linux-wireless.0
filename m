Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33860 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755481AbcK3AGg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 19:06:36 -0500
Received: by mail-pg0-f65.google.com with SMTP id e9so17758184pgc.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 16:06:18 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Suppress NEW_PEER_CANDIDATE event if no room
Date: Wed, 30 Nov 2016 09:06:04 +0900
Message-Id: <1480464364-5054-1-git-send-email-masashi.honma@gmail.com> (sfid-20161130_010640_292510_2BC89B73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, kernel sends NEW_PEER_CANDIDATE event to user land even if
the found peer does not have any room to accept other peer. This causes
continuous connection trials.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh_plink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7fcdcf6..fcba70e5 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -505,12 +505,14 @@ mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
 
 	/* Userspace handles station allocation */
 	if (sdata->u.mesh.user_mpm ||
-	    sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
-		cfg80211_notify_new_peer_candidate(sdata->dev, addr,
-						   elems->ie_start,
-						   elems->total_len,
-						   GFP_KERNEL);
-	else
+	    sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
+		if (mesh_peer_accepts_plinks(elems) &&
+		    mesh_plink_availables(sdata))
+			cfg80211_notify_new_peer_candidate(sdata->dev, addr,
+							   elems->ie_start,
+							   elems->total_len,
+							   GFP_KERNEL);
+	} else
 		sta = __mesh_sta_info_alloc(sdata, addr);
 
 	return sta;
-- 
2.7.4
