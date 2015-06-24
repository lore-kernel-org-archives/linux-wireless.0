Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33099 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbFXX1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 19:27:31 -0400
Received: by ieqy10 with SMTP id y10so43727874ieq.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2015 16:27:31 -0700 (PDT)
Message-ID: <558B3CD9.8020106@cococorp.com> (sfid-20150625_012735_924493_C58862EA)
Date: Wed, 24 Jun 2015 16:27:21 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: mesh - always do every discovery retry
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jesse Jones <jjones@cococorp.com>

Instead of stopping path discovery when a path is found continue
attempting to find paths until we hit the dot11MeshHWMPmaxPREQretries
limit.

This is important because path messages are not reliable and it is
relatively common to have a short bad path to the destination along with a
longer but better path. With the original code rather often a path message
along the long path would be lost so we would stick with the bad path.
With this change we have a greater chance to get messages over the longer
path allowing us to select the long path if it's better.

The standard doesn't seem to address this issue. All it says (13.10.8.5)
is that discovery should be limited to dot11MeshHWMPmaxPREQretries.

Signed-off-by: Alexis Green <agreen@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d80e0a4..3eec501 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1179,16 +1179,20 @@ void mesh_path_timer(unsigned long data)
 		return;
 
 	spin_lock_bh(&mpath->state_lock);
-	if (mpath->flags & MESH_PATH_RESOLVED ||
-			(!(mpath->flags & MESH_PATH_RESOLVING))) {
-		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
-		spin_unlock_bh(&mpath->state_lock);
-	} else if (mpath->discovery_retries < max_preq_retries(sdata)) {
+
+	if (mpath->discovery_retries < max_preq_retries(sdata)) {
 		++mpath->discovery_retries;
 		mpath->discovery_timeout *= 2;
 		mpath->flags &= ~MESH_PATH_REQ_QUEUED;
 		spin_unlock_bh(&mpath->state_lock);
 		mesh_queue_preq(mpath, 0);
+
+	} else if (
+		mpath->flags & MESH_PATH_RESOLVED ||
+			(!(mpath->flags & MESH_PATH_RESOLVING))) {
+		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
+		spin_unlock_bh(&mpath->state_lock);
+
 	} else {
 		mpath->flags &= ~(MESH_PATH_RESOLVING |
 				  MESH_PATH_RESOLVED |
