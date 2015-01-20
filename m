Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40537 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbATCrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 21:47:31 -0500
Received: by mail-pa0-f49.google.com with SMTP id hz1so11911864pad.8
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 18:47:31 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v3] mac80211: Avoid STA expiration timer truncation to u32
Date: Tue, 20 Jan 2015 11:47:03 +0900
Message-Id: <1421722023-4691-1-git-send-email-masashi.honma@gmail.com> (sfid-20150120_034734_203758_428E04AE)
In-Reply-To: <CAFk-A4nF4jPiFR1c9fx-+sa=YWUZseEOKtut7rKWHihmLWp02w@mail.gmail.com>
References: <CAFk-A4nF4jPiFR1c9fx-+sa=YWUZseEOKtut7rKWHihmLWp02w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some combination of plink_timeout and HZ, the STA expiration timer will be
unexpectedly truncated to u32. Maybe there is a question "Who sets such a large
number to plink_timeout ?". At least wpa_supplicant will set 0xffffffff to
plink_timeout to disable this timer because wpa_supplicant has it's own
expiration mechanism.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0c8b2a7..3c40894 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -573,8 +573,11 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
+	u64 exp_time;
 
-	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
+	exp_time = ifmsh->mshcfg.plink_timeout * (u64)HZ;
+	if (exp_time < 0x100000000)
+		ieee80211_sta_expire(sdata, exp_time);
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-- 
2.1.0

