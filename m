Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37850 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab2KWCJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 21:09:47 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3202568pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 18:09:47 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: Fix macro definitions in Mesh
Date: Fri, 23 Nov 2012 09:59:18 +0800
Message-Id: <1353635958-12298-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20121123_030950_972359_65C3EA2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Macro definitions should be static inlines.

Reported by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 47aeee2..5d3e965 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -88,9 +88,9 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 	(msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval))
 #define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
 #define disc_timeout_jiff(s) \
-	msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
+	msecs_to_jiffies(s->u.mesh.mshcfg.min_discovery_timeout)
 #define root_path_confirmation_jiffies(s) \
-	msecs_to_jiffies(sdata->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
+	msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
 
 enum mpath_frame_type {
 	MPATH_PREQ = 0,
-- 
1.7.0.4

