Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64141 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbAPGSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 01:18:54 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so22323671pab.7
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 22:18:54 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] mac80211: Avoid STA expiration timer truncation to u32
Date: Fri, 16 Jan 2015 15:18:41 +0900
Message-Id: <1421389121-2841-1-git-send-email-masashi.honma@gmail.com> (sfid-20150116_071906_004801_7605EEB2)
In-Reply-To: <CAFk-A4kzcC9BhCtwqxjprRiXZeVPepBDXr3TvqvL6hn6J37UGw@mail.gmail.com>
References: <CAFk-A4kzcC9BhCtwqxjprRiXZeVPepBDXr3TvqvL6hn6J37UGw@mail.gmail.com>
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

