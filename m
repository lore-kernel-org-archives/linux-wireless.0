Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:51770 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYEETit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:38:49 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1339016wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 12:38:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 5 May 2008 12:02:35 -0700
Subject: [PATCH] mac80211: fix incorrect mesh header length
Message-ID: <481f6246.20038e0a.0ff3.fffff3d4@mx.google.com> (sfid-20080505_213806_846782_12B6148D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should have been updated at the same time we were transitioning from 3 byte
to 4 byte mesh sequence number. Pointed out by Johannes Berg.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.c |    2 +-
 net/mac80211/util.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f76bc26..697ef67 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -397,7 +397,7 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 	put_unaligned(cpu_to_le32(sdata->u.sta.mesh_seqnum), &meshhdr->seqnum);
 	sdata->u.sta.mesh_seqnum++;
 
-	return 5;
+	return 6;
 }
 
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cc9f715..24a465c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -153,15 +153,15 @@ int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 	/* 7.1.3.5a.2 */
 	switch (ae) {
 	case 0:
-		return 5;
+		return 6;
 	case 1:
-		return 11;
+		return 12;
 	case 2:
-		return 17;
+		return 18;
 	case 3:
-		return 23;
+		return 24;
 	default:
-		return 5;
+		return 6;
 	}
 }
 
-- 
1.5.4.3



