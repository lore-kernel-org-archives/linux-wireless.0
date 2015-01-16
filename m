Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53055 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbAPFSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 00:18:09 -0500
Received: by mail-pd0-f173.google.com with SMTP id ft15so20600728pdb.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 21:18:08 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mesh: Avoid STA expiration timer truncation to u32
Date: Fri, 16 Jan 2015 14:17:40 +0900
Message-Id: <1421385460-3126-1-git-send-email-masashi.honma@gmail.com> (sfid-20150116_061833_559228_21852CD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some combination of plink_timeout and HZ, the STA expiration timer will be
unexpectedly truncated to u32. Maybe there is a question "Who sets such a large
number to plink_timeout ?". At least wpa_supplicant will set 0xffffffff to
plink_timeout to disable this timer because wpa_supplicant has it's own
expiration mechanism.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0c8b2a7..bb721a0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,8 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
 
-	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
+	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout *
+			     (unsigned long)HZ);
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-- 
2.1.0

