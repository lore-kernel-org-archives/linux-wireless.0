Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:43526 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0LPSgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:36:32 -0500
Received: by pxi20 with SMTP id 20so738796pxi.10
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 10:36:32 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Remove unused third address from mesh address extension header.
Date: Thu, 16 Dec 2010 10:30:41 -0800
Message-Id: <1292524241-14837-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Mesh Control header only includes 0, 1 or 2 addresses. If there is
one address, it should be interpreted as Address 4.  If there are 2,
they are interpreted as Addresses 5 and 6 (Address 4 being the 4th
address in the 802.11 header).

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    1 -
 net/mac80211/mesh.c       |   10 +++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cd68168..6042228 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -536,7 +536,6 @@ struct ieee80211s_hdr {
 	__le32 seqnum;
 	u8 eaddr1[6];
 	u8 eaddr2[6];
-	u8 eaddr3[6];
 } __attribute__ ((packed));
 
 /* Mesh flags */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 32d55d2..7de2119 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -423,6 +423,7 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 		char *addr5, char *addr6)
 {
 	int aelen = 0;
+	BUG_ON(addr4 && addr5 && addr6);
 	memset(meshhdr, 0, sizeof(*meshhdr));
 	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
@@ -435,13 +436,8 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 	if (addr5 && addr6) {
 		meshhdr->flags |= MESH_FLAGS_AE_A5_A6;
 		aelen += 2 * ETH_ALEN;
-		if (!addr4) {
-			memcpy(meshhdr->eaddr1, addr5, ETH_ALEN);
-			memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
-		} else {
-			memcpy(meshhdr->eaddr2, addr5, ETH_ALEN);
-			memcpy(meshhdr->eaddr3, addr6, ETH_ALEN);
-		}
+		memcpy(meshhdr->eaddr1, addr5, ETH_ALEN);
+		memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
 	}
 	return 6 + aelen;
 }
-- 
1.7.1

