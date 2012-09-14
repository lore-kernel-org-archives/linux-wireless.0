Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2INGW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 02:22:29 -0400
Received: by pbbrr13 with SMTP id rr13so5139137pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2012 23:22:29 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: allow re-open the blocked peer link in mesh
Date: Fri, 14 Sep 2012 14:18:31 +0800
Message-Id: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120914_082233_593098_CEE8930E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peer link which is blocked using the "iw mesh0 station
set <MAC addr> plink_action block" is previously not able
to re-open using "iw mesh0 station set <MAC addr>
plink_action open". This patch is intended to solve this.

If the station plink state remains at OPN_SNT once open,
try block and open again should solve this problem.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_plink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9d7ad36..3ab34d8 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -537,7 +537,8 @@ int mesh_plink_open(struct sta_info *sta)
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
-	if (sta->plink_state != NL80211_PLINK_LISTEN) {
+	if (sta->plink_state != NL80211_PLINK_LISTEN &&
+	    sta->plink_state != NL80211_PLINK_BLOCKED) {
 		spin_unlock_bh(&sta->lock);
 		return -EBUSY;
 	}
-- 
1.7.0.4

