Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:31294 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbZHHDne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:43:34 -0400
Received: by rv-out-0506.google.com with SMTP id f6so563117rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:43:36 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: Use 3-address format for mesh broadcast frames.
Date: Fri,  7 Aug 2009 20:31:50 -0700
Message-Id: <1249702314-32504-5-git-send-email-javier@cozybit.com>
In-Reply-To: <1249702314-32504-4-git-send-email-javier@cozybit.com>
References: <>
 <1249702314-32504-1-git-send-email-javier@cozybit.com>
 <1249702314-32504-2-git-send-email-javier@cozybit.com>
 <1249702314-32504-3-git-send-email-javier@cozybit.com>
 <1249702314-32504-4-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 11s task group recently changed the frame mesh multicast/broadcast frame
format to use 3-address.  This was done to avoid interactions with widely
deployed lazy-WDS access points.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/mesh.h |    5 +++-
 net/mac80211/rx.c   |   45 ++++++++++++++++++++++-------------
 net/mac80211/tx.c   |   64 +++++++++++++++++++++++++++------------------------
 net/wireless/util.c |   16 +++++++++---
 5 files changed, 136 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d9292a9..5202d7c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -399,21 +399,75 @@ endgrow:
 }
 
 /**
+ * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
+ * @hdr:    	802.11 frame header
+ * @fc:		frame control field
+ * @meshda:	destination address in the mesh
+ * @meshsa:	source address address in the mesh.  Same as TA, as frame is
+ *              locally originated.
+ *
+ * Return the length of the 802.11 (does not include a mesh control header)
+ */
+int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc, char
+		*meshda, char *meshsa) {
+	if (is_multicast_ether_addr(meshda)) {
+		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		/* DA TA SA */
+		memcpy(hdr->addr1, meshda, ETH_ALEN);
+		memcpy(hdr->addr2, meshsa, ETH_ALEN);
+		memcpy(hdr->addr3, meshsa, ETH_ALEN);
+		return 24;
+	} else {
+		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+				IEEE80211_FCTL_TODS);
+		/* RA TA DA SA */
+		memset(hdr->addr1, 0, ETH_ALEN);   /* RA is resolved later */
+		memcpy(hdr->addr2, meshsa, ETH_ALEN);
+		memcpy(hdr->addr3, meshda, ETH_ALEN);
+		memcpy(hdr->addr4, meshsa, ETH_ALEN);
+		return 30;
+	}
+}
+
+/**
  * ieee80211_new_mesh_header - create a new mesh header
  * @meshhdr:    uninitialized mesh header
  * @sdata:	mesh interface to be used
+ * @addr4:	addr4 of the mesh frame (1st in ae header)
+ *              may be NULL
+ * @addr5:	addr5 of the mesh frame (1st or 2nd in ae header)
+ *              may be NULL unless addr6 is present
+ * @addr6:	addr6 of the mesh frame (2nd or 3rd in ae header)
+ * 		may be NULL unless addr5 is present
  *
  * Return the header length.
  */
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata)
+		struct ieee80211_sub_if_data *sdata, char *addr4,
+		char *addr5, char *addr6)
 {
-	meshhdr->flags = 0;
+	int aelen = 0;
+	memset(meshhdr, 0, sizeof(meshhdr));
 	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
 	sdata->u.mesh.mesh_seqnum++;
-
-	return 6;
+	if (addr4) {
+		meshhdr->flags |= MESH_FLAGS_AE_A4;
+		aelen += ETH_ALEN;
+		memcpy(meshhdr->eaddr1, addr4, ETH_ALEN);
+	}
+	if (addr5 && addr6) {
+		meshhdr->flags |= MESH_FLAGS_AE_A5_A6;
+		aelen += 2 * ETH_ALEN;
+		if (!addr4) {
+			memcpy(meshhdr->eaddr1, addr5, ETH_ALEN);
+			memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
+		} else {
+			memcpy(meshhdr->eaddr2, addr5, ETH_ALEN);
+			memcpy(meshhdr->eaddr3, addr6, ETH_ALEN);
+		}
+	}
+	return 6 + aelen;
 }
 
 static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8e70dae..6cb3db8 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -193,8 +193,11 @@ struct mesh_rmc {
 
 /* Public interfaces */
 /* Various */
+int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
+		char *da, char *sa);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata);
+		struct ieee80211_sub_if_data *sdata, char *addr4,
+		char *addr5, char *addr6);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 		struct ieee80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 25a669c..e7d8895 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -489,12 +489,21 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	char *dev_addr = rx->dev->dev_addr;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
-		if (!ieee80211_has_a4(hdr->frame_control))
-			return RX_DROP_MONITOR;
-		if (memcmp(hdr->addr4, rx->dev->dev_addr, ETH_ALEN) == 0)
-			return RX_DROP_MONITOR;
+		if (is_multicast_ether_addr(hdr->addr1)) {
+			if (ieee80211_has_tods(hdr->frame_control) ||
+				!ieee80211_has_fromds(hdr->frame_control))
+				return RX_DROP_MONITOR;
+			if (memcmp(hdr->addr3, dev_addr, ETH_ALEN) == 0)
+				return RX_DROP_MONITOR;
+		} else {
+			if (!ieee80211_has_a4(hdr->frame_control))
+				return RX_DROP_MONITOR;
+			if (memcmp(hdr->addr4, dev_addr, ETH_ALEN) == 0)
+				return RX_DROP_MONITOR;
+		}
 	}
 
 	/* If there is not an established peer link and this is not a peer link
@@ -527,7 +536,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->sdata))
+	    mesh_rmc_check(hdr->addr3, msh_h_get(hdr, hdrlen), rx->sdata))
 		return RX_DROP_MONITOR;
 #undef msh_h_get
 
@@ -1495,7 +1504,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;
 
-	if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6){
+	if (!is_multicast_ether_addr(hdr->addr1) && 
+			(mesh_hdr->flags & MESH_FLAGS_AE_A5_A6)) {
 		struct mesh_path *mppath;
 
 		rcu_read_lock();
@@ -1512,7 +1522,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		rcu_read_unlock();
 	}
 
-	if (compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
+	/* Frame has reached destination.  Don't forward */
+	if (!is_multicast_ether_addr(hdr->addr1) &&
+			compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
 	mesh_hdr->ttl--;
@@ -1532,22 +1544,21 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 						   rx->dev->name);
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
-			/*
-			 * Save TA to addr1 to send TA a path error if a
-			 * suitable next hop is not found
-			 */
-			memcpy(fwd_hdr->addr1, fwd_hdr->addr2, ETH_ALEN);
 			memcpy(fwd_hdr->addr2, rx->dev->dev_addr, ETH_ALEN);
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->control.vif = &rx->sdata->vif;
 			ieee80211_select_queue(local, fwd_skb);
-			if (is_multicast_ether_addr(fwd_hdr->addr3))
-				memcpy(fwd_hdr->addr1, fwd_hdr->addr3,
+			if (!is_multicast_ether_addr(fwd_hdr->addr1)) {
+				int err;
+				/*
+				 * Save TA to addr1 to send TA a path error if a
+				 * suitable next hop is not found
+				 */
+				memcpy(fwd_hdr->addr1, fwd_hdr->addr2,
 						ETH_ALEN);
-			else {
-				int err = mesh_nexthop_lookup(fwd_skb, sdata);
+				err = mesh_nexthop_lookup(fwd_skb, sdata);
 				/* Failed to immediately resolve next hop:
 				 * fwded frame was dropped or will be added
 				 * later to the pending skb queue.  */
@@ -1560,7 +1571,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		}
 	}
 
-	if (is_multicast_ether_addr(hdr->addr3) ||
+	if (is_multicast_ether_addr(hdr->addr1) ||
 	    rx->dev->flags & IFF_PROMISC)
 		return RX_CONTINUE;
 	else
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0df5a96..a97d541 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1461,9 +1461,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    ieee80211_is_data(hdr->frame_control)) {
-		if (is_multicast_ether_addr(hdr->addr3))
-			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
-		else
+		if (!is_multicast_ether_addr(hdr->addr1))
 			if (mesh_nexthop_lookup(skb, sdata)) {
 				dev_put(sdata->dev);
 				return;
@@ -1666,52 +1664,58 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
 			ret = 0;
 			goto fail;
 		}
-		memset(&mesh_hdr, 0, sizeof(mesh_hdr));
 
 		if (compare_ether_addr(dev->dev_addr,
 					  skb->data + ETH_ALEN) == 0) {
-			/* RA TA DA SA */
-			memset(hdr.addr1, 0, ETH_ALEN);
-			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-			memcpy(hdr.addr3, skb->data, ETH_ALEN);
-			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
-			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr, sdata);
+			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
+					skb->data, skb->data + ETH_ALEN);
+			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
+					sdata, NULL, NULL, NULL);
 		} else {
 			/* packet from other interface */
 			struct mesh_path *mppath;
+			int is_mesh_mcast = 1;
+			char *mesh_da;
 
-			memset(hdr.addr1, 0, ETH_ALEN);
-			memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-			memcpy(hdr.addr4, dev->dev_addr, ETH_ALEN);
-
+			rcu_read_lock();
 			if (is_multicast_ether_addr(skb->data))
-				memcpy(hdr.addr3, skb->data, ETH_ALEN);
+				/* DA TA mSA AE:SA */
+				mesh_da = skb->data;
 			else {
-				rcu_read_lock();
 				mppath = mpp_path_lookup(skb->data, sdata);
-				if (mppath)
-					memcpy(hdr.addr3, mppath->mpp, ETH_ALEN);
-				else
-					memset(hdr.addr3, 0xff, ETH_ALEN);
-				rcu_read_unlock();
+				if (mppath) {
+					/* RA TA mDA mSA AE:DA SA */
+					mesh_da = mppath->mpp;
+					is_mesh_mcast = 0;
+				} else
+					/* DA TA mSA AE:SA */
+					mesh_da = dev->broadcast;
 			}
+			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
+					mesh_da, dev->dev_addr);
+			rcu_read_unlock();
+			if (is_mesh_mcast)
+				meshhdrlen =
+					ieee80211_new_mesh_header(&mesh_hdr,
+							sdata,
+							skb->data + ETH_ALEN,
+							NULL,
+							NULL);
+			else
+				meshhdrlen =
+					ieee80211_new_mesh_header(&mesh_hdr,
+							sdata,
+							NULL,
+							skb->data,
+							skb->data + ETH_ALEN);
 
-			mesh_hdr.flags |= MESH_FLAGS_AE_A5_A6;
-			mesh_hdr.ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
-			put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &mesh_hdr.seqnum);
-			memcpy(mesh_hdr.eaddr1, skb->data, ETH_ALEN);
-			memcpy(mesh_hdr.eaddr2, skb->data + ETH_ALEN, ETH_ALEN);
-			sdata->u.mesh.mesh_seqnum++;
-			meshhdrlen = 18;
 		}
-		hdrlen = 30;
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ba387d8..693275a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -274,11 +274,11 @@ static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 	switch (ae) {
 	case 0:
 		return 6;
-	case 1:
+	case MESH_FLAGS_AE_A4:
 		return 12;
-	case 2:
+	case MESH_FLAGS_AE_A5_A6:
 		return 18;
-	case 3:
+	case (MESH_FLAGS_AE_A4 | MESH_FLAGS_AE_A5_A6):
 		return 24;
 	default:
 		return 6;
@@ -333,10 +333,18 @@ int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
 		}
 		break;
 	case cpu_to_le16(IEEE80211_FCTL_FROMDS):
-		if (iftype != NL80211_IFTYPE_STATION ||
+		if ((iftype != NL80211_IFTYPE_STATION &&
+		    iftype != NL80211_IFTYPE_MESH_POINT) ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, addr)))
 			return -1;
+		if (iftype == NL80211_IFTYPE_MESH_POINT) {
+			struct ieee80211s_hdr *meshdr =
+				(struct ieee80211s_hdr *) (skb->data + hdrlen);
+			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
+			if (meshdr->flags & MESH_FLAGS_AE_A4)
+				memcpy(src, meshdr->eaddr1, ETH_ALEN);
+		}
 		break;
 	case cpu_to_le16(0):
 		if (iftype != NL80211_IFTYPE_ADHOC)
-- 
1.5.4.3

