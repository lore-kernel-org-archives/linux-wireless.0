Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:50704 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0LQBXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 20:23:48 -0500
Received: by pxi20 with SMTP id 20so36683pxi.10
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:23:48 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: Remove unused third address from mesh address extension header.
Date: Thu, 16 Dec 2010 17:23:34 -0800
Message-Id: <1292549014-1489-1-git-send-email-javier@cozybit.com>
In-Reply-To: <AANLkTimpmCdAx_8OqfqALwbWkX3NVaP98FzbxS4yJUFm@mail.gmail.com>
References: <AANLkTimpmCdAx_8OqfqALwbWkX3NVaP98FzbxS4yJUFm@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Mesh Control header only includes 0, 1 or 2 addresses. If there is
one address, it should be interpreted as Address 4.  If there are 2,
they are interpreted as Addresses 5 and 6 (Address 4 being the 4th
address in the 802.11 header).

The address extension used to hold up to 3 addresses instead of the current 2.
I'm not sure which draft version changed this, but it is very unlikely that it
will change again given the state of the approval process of this draft.  See
section 7.1.3.6.3 in current draft (8.0).

Also, note that the extra address that I'm removing was not being used, so this
change has no effect on over-the-air frame formats.  But I thought I better
remove it before someone does start using it.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: - more detailed patch description
    - changed ieee80211_fill_mesh_addresses() to just accept at most 2
      addresses and avoid confusions.

 include/linux/ieee80211.h |    1 -
 net/mac80211/mesh.c       |   32 +++++++++++++-------------------
 net/mac80211/mesh.h       |    4 ++--
 net/mac80211/tx.c         |    4 +---
 4 files changed, 16 insertions(+), 25 deletions(-)

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
index 8b5906c..ca3af46 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -410,39 +410,33 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
  * ieee80211_new_mesh_header - create a new mesh header
  * @meshhdr:    uninitialized mesh header
  * @sdata:	mesh interface to be used
- * @addr4:	addr4 of the mesh frame (1st in ae header)
- *              may be NULL
- * @addr5:	addr5 of the mesh frame (1st or 2nd in ae header)
- *              may be NULL unless addr6 is present
- * @addr6:	addr6 of the mesh frame (2nd or 3rd in ae header)
- * 		may be NULL unless addr5 is present
+ * @addr4or5:   1st address in the ae header, which may correspond to address 4
+ *              (if addr6 is NULL) or address 5 (if addr6 is present). It may
+ *              be NULL.
+ * @addr6:	2nd address in the ae header, which corresponds to addr6 of the
+ *              mesh frame
  *
  * Return the header length.
  */
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4,
-		char *addr5, char *addr6)
+		struct ieee80211_sub_if_data *sdata, char *addr4or5,
+		char *addr6)
 {
 	int aelen = 0;
+	BUG_ON(!addr4or5 && addr6);
 	memset(meshhdr, 0, sizeof(*meshhdr));
 	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
 	sdata->u.mesh.mesh_seqnum++;
-	if (addr4) {
+	if (addr4or5 && !addr6) {
 		meshhdr->flags |= MESH_FLAGS_AE_A4;
 		aelen += ETH_ALEN;
-		memcpy(meshhdr->eaddr1, addr4, ETH_ALEN);
-	}
-	if (addr5 && addr6) {
+		memcpy(meshhdr->eaddr1, addr4or5, ETH_ALEN);
+	} else if (addr4or5 && addr6) {
 		meshhdr->flags |= MESH_FLAGS_AE_A5_A6;
 		aelen += 2 * ETH_ALEN;
-		if (!addr4) {
-			memcpy(meshhdr->eaddr1, addr5, ETH_ALEN);
-			memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
-		} else {
-			memcpy(meshhdr->eaddr2, addr5, ETH_ALEN);
-			memcpy(meshhdr->eaddr3, addr6, ETH_ALEN);
-		}
+		memcpy(meshhdr->eaddr1, addr4or5, ETH_ALEN);
+		memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
 	}
 	return 6 + aelen;
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 890dd19..b99e230 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -187,8 +187,8 @@ struct mesh_rmc {
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 				  const u8 *da, const u8 *sa);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4,
-		char *addr5, char *addr6);
+		struct ieee80211_sub_if_data *sdata, char *addr4or5,
+		char *addr6);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 		struct ieee80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b97f603..10a81b8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1814,7 +1814,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
-					sdata, NULL, NULL, NULL);
+					sdata, NULL, NULL);
 		} else {
 			/* packet from other interface */
 			struct mesh_path *mppath;
@@ -1847,13 +1847,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 					ieee80211_new_mesh_header(&mesh_hdr,
 							sdata,
 							skb->data + ETH_ALEN,
-							NULL,
 							NULL);
 			else
 				meshhdrlen =
 					ieee80211_new_mesh_header(&mesh_hdr,
 							sdata,
-							NULL,
 							skb->data,
 							skb->data + ETH_ALEN);
 
-- 
1.7.1

