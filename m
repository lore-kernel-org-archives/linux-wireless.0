Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D27537E30F
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766401; cv=none; b=AW5dCvd3dQhjnG7v2sgGjs2BKLhYrZgGm3sd9jrXcBRKn+UTWkU7LIUz9g1aiIYbm22gl9IsFd0+P4I/C+KQmKWqQGx0CxmRSS49AlJyNfFUUAga3XsW+9XUPVrh/R1fiU2KlFOHRSvEtgrIeiof6uURwn6zr80gXVmnzVxbqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766401; c=relaxed/simple;
	bh=0v+wkPDkeLpLZTlzAUQNUGpu5T7KedweuFPSqDKHZnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVuZo6Rz5sfmpsxIdxZmZ0oRQRdWDr1EtDhzgP3v+0PuhGKRQ3I/7eUx1t8kIb7dpRSaQ+YoRnu4OkYuag6qnKtN7hndky+tACViwD0DgaKEoBuvMBwKyc+6NcODpbssCLmsA6JMpLZkqcT6Pw/fcOh6Riwj5Fcnrt8bk2yKOtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Cd6LJVj/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Cd6LJVj/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wMxo5dY05NfyXeOfFBwIyLSXPiUs7BiKvB8azkwdduM=;
	t=1785766399; x=1786975999; b=Cd6LJVj/riuZY4xIBfvtuQTrkvwqyR7SsgaiMpQ8uruN6z1
	sQXUb/rIUCRYa5zIX+k0l4VLgQS+6eUOih/NLNORmh6ERdHClMeSV7xKyh7SLj7fG64igwD3chOV9
	k5kOnzjqrF0T/bONsKu+PELfpTQNIQywTmjOLVpwvReG35nwUV6uLLnTyi1WK2WEExX5thioa+PDt
	BMxB8+8UJoOBoQXnl7W1+ttmTQzGbjobR3U7uCvFfAr7lxoKpL1mQR6URTg0QabSM71FattKNq4wJ
	DJWGMoxe6kHfzo0WFNTYi1Jp8JrV1BA7AxyQfKl6lohlrpJKcW68eaRLu+2dvpAw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPn-0000000G4Ws-3LEY;
	Mon, 03 Aug 2026 16:13:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/7] wifi: mac80211: remove cookie from __ieee80211_subif_start_xmit()
Date: Mon,  3 Aug 2026 16:08:39 +0200
Message-ID: <20260803141309.292711-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803141309.292711-9-johannes@sipsolutions.net>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This argument is now always zero, so no longer used. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 21 ++++++++-------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..85f72ad06ad7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2233,8 +2233,7 @@ netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
-				  u32 ctrl_flags,
-				  u64 cookie);
+				  u32 ctrl_flags);
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index dc2f662fe4c4..4f4cae9fd274 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1121,7 +1121,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, dev, flags,
-				     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, 0);
+				     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC);
 	local_bh_enable();
 
 	return ret;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 772350f485dd..28c60ae442c0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4367,8 +4367,7 @@ EXPORT_SYMBOL(ieee80211_txq_schedule_start);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
-				  u32 ctrl_flags,
-				  u64 cookie)
+				  u32 ctrl_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -4426,7 +4425,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			ctrl_flags |= IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
 
 		skb = ieee80211_build_hdr(sdata, skb, info_flags,
-					  sta, ctrl_flags, cookie);
+					  sta, ctrl_flags, 0);
 		if (IS_ERR(skb)) {
 			kfree_skb_list(next);
 			goto out;
@@ -4563,7 +4562,7 @@ static void ieee80211_mlo_multicast_tx_one(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ctrl_flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
-	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags, 0);
+	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags);
 }
 
 static void ieee80211_mlo_multicast_tx(struct net_device *dev,
@@ -4578,7 +4577,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
-		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags, 0);
+		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags);
 		return;
 	}
 
@@ -4619,8 +4618,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		ieee80211_convert_to_unicast(skb, dev, &queue);
 		while ((skb = __skb_dequeue(&queue)))
 			__ieee80211_subif_start_xmit(skb, dev, 0,
-						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     0);
+						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC);
 	} else if (ieee80211_vif_is_mld(&sdata->vif) &&
 		   ((sdata->vif.type == NL80211_IFTYPE_AP &&
 		     !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX)) ||
@@ -4630,8 +4628,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	} else {
 normal:
 		__ieee80211_subif_start_xmit(skb, dev, 0,
-					     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-					     0);
+					     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC);
 	}
 
 	return NETDEV_TX_OK;
@@ -4729,8 +4726,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			/* fall back to non-offload slow path */
 			__ieee80211_subif_start_xmit(skb, dev, 0,
-						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     0);
+						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC);
 			return;
 		}
 
@@ -6660,8 +6656,7 @@ int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
 
 	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, skb->dev, 0,
-				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP,
-				     0);
+				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP);
 	local_bh_enable();
 
 	return 0;
-- 
2.55.0

