Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaAVJRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:17:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5tvs-0001VA-IF
	for linux-wireless@vger.kernel.org; Wed, 22 Jan 2014 10:17:12 +0100
Message-ID: <1390382230.4334.21.camel@jlt4.sipsolutions.net> (sfid-20140122_101723_090174_FF052C46)
Subject: [PATCH] mac80211: use local mesh_id_len instead of wdev's
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 10:17:10 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we copy the mesh_id_len into our own data structures,
use it consistently and don't sometimes use cfg80211's copy.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b02ac33..836ec01 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1216,7 +1216,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	sdata_lock(sdata);
 
 	/* mesh already went down */
-	if (!sdata->wdev.mesh_id_len)
+	if (!sdata->u.mesh.mesh_id_len)
 		goto out;
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
@@ -1269,7 +1269,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 	sdata_lock(sdata);
 
 	/* mesh already went down */
-	if (!sdata->wdev.mesh_id_len)
+	if (!sdata->u.mesh.mesh_id_len)
 		goto out;
 
 	if (ifmsh->preq_queue_len &&
-- 
1.8.5.1



