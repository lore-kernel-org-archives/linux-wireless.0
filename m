Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab2JYT4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:56:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: drop invalid mesh address extension frames
Date: Thu, 25 Oct 2012 21:56:51 +0200
Message-Id: <1351195011-30148-1-git-send-email-johannes@sipsolutions.net> (sfid-20121025_215622_269216_205911A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mesh header can have address extension by a 4th
or a 5th and 6th address, but never both. Drop such
frames in 802.11 -> 802.3 conversion.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef35f4e..7296ec0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -312,18 +312,15 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & MESH_FLAGS_AE;
-	/* 7.1.3.5a.2 */
+	/* IEEE 802.11 - 8.2.4.7.3 */
 	switch (ae) {
+	default:
 	case 0:
 		return 6;
 	case MESH_FLAGS_AE_A4:
 		return 12;
 	case MESH_FLAGS_AE_A5_A6:
 		return 18;
-	case (MESH_FLAGS_AE_A4 | MESH_FLAGS_AE_A5_A6):
-		return 24;
-	default:
-		return 6;
 	}
 }
 
@@ -373,6 +370,11 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			/* reserved */
+			if ((meshdr->flags & MESH_FLAGS_AE) ==
+						(MESH_FLAGS_AE_A4 |
+						 MESH_FLAGS_AE_A5_A6))
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
@@ -397,6 +399,11 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			/* reserved */
+			if ((meshdr->flags & MESH_FLAGS_AE) ==
+						(MESH_FLAGS_AE_A4 |
+						 MESH_FLAGS_AE_A5_A6))
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A4)
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
-- 
1.7.10.4

