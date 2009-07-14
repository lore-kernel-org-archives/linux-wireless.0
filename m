Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:48958 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbZGMX57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 19:57:59 -0400
Received: by pxi15 with SMTP id 15so772692pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 16:57:59 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: use correct address for mesh Path Error
Date: Mon, 13 Jul 2009 17:00:10 -0700
Message-Id: <1247529610-21854-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

For forwarded frames, we save the precursor address in addr1 in case it
needs to be used to send a Path Error.  mesh_path_discard_frame,
however, was using addr2 instead of addr1 to send Path Error frames, so
correct that and also make the comment regarding this more clear.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 1981af9..1ede8cb 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -507,8 +507,10 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
  * @skb: frame to discard
  * @sdata: network subif the frame was to be sent through
  *
- * If the frame was beign forwarded from another MP, a PERR frame will be sent
- * to the precursor.
+ * If the frame was being forwarded from another MP, a PERR frame will be sent
+ * to the precursor.  The precursor's address (i.e. the previous hop) was saved
+ * in addr1 of the frame-to-be-forwarded, and would only be overwritten once
+ * the destination is successfully resolved.
  *
  * Locking: the function must me called within a rcu_read_lock region
  */
@@ -523,7 +525,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		u8 *ra, *da;
 
 		da = hdr->addr3;
-		ra = hdr->addr2;
+		ra = hdr->addr1;
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
-- 
1.5.6.3

