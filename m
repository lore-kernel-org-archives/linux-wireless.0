Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC442643C
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169712; cv=none; b=VX8DUNAU/Z+sGosfFQMVbQ1FZEQBEe55B4sz6hDvZaXAxrJ00h3TJImZA/SHbBD3EmkcYrpYaWJp9EX0KJw0G3V2lJYxK3v2jNRcuTdQTep6ZTWOQRScFsTGQb7Wm5wezpBEjjmB/VnLDEVC+0/YXP9yPzrtdrnnNjASH3PkGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169712; c=relaxed/simple;
	bh=Ibv3+/eXrytXjixfOx230e/+1GYFnjzD8At/o4ba2d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlsjXa6ddiljWJOyjfXieG38TVtN+dkXImiPZkUvDV4aUEg3q9IxyKIH6nGUuEmTkjyClhUhSVo71mfoUoO16k8PcjWuMgaq0EGaUMmTQpDBiB/6OvWpEWptYiw40dBRkHwn5tbBpZ/mjVZbP/WqCq+JIMxO3RBwTbDgCHkQ5qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ht0Fpb1u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ht0Fpb1u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785169707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HdI4S3vG0B6JG9MD/SqL89Bsd0lNZG9q2eE5bXjCdw=;
	b=Ht0Fpb1uOWzdsw+65UtuQ66cdJ840RAcs1mdaEoGNkhF1Dj8zxPIcDMsOJPUnIeFhV8NNg
	lRIOsQ6353qkS0xQskQD+sCbxjr+BDruAt8UekA5PRr74HskEJtgx1Vr3IPeF4FyjHlO5O
	JTs150wcfAut1f9lewb5wn1/kqbZ6xc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-539-a8bPq0JSPrKhGKUGcUBcwg-1; Mon,
 27 Jul 2026 12:28:23 -0400
X-MC-Unique: a8bPq0JSPrKhGKUGcUBcwg-1
X-Mimecast-MFC-AGG-ID: a8bPq0JSPrKhGKUGcUBcwg_1785169693
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FB971956074;
	Mon, 27 Jul 2026 16:28:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B9B742B;
	Mon, 27 Jul 2026 16:28:10 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 3/5] wifi: ath12k: fix MLO dp_peer ID desync with firmware
Date: Mon, 27 Jul 2026 18:27:46 +0200
Message-ID: <20260727162748.963275-4-jtornosm@redhat.com>
In-Reply-To: <20260727162748.963275-1-jtornosm@redhat.com>
References: <20260727162748.963275-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

TX completions fail with:
  "dp_tx: failed to find the peer with peer_id <N>"

where <N> is an ML peer_id (host-assigned ml_peer_id OR'd with
ATH12K_PEER_ML_ID_VALID, BIT(13) = 0x2000). This happens because
the firmware uses an internal monotonic counter for ML peer IDs that
does not necessarily match the host-assigned ml_peer_id. The desync
has been observed in normal MLO operation and is particularly
reproducible after firmware crash recovery, where the
create-delete-create cycle guarantees the firmware increments its
internal counter.

Currently, ath12k_dp_peer_create() stores the host-assigned
ml_peer_id (with ATH12K_PEER_ML_ID_VALID OR'd in) as dp_peer->peer_id
and immediately populates the dp_peers[] RCU lookup table at that
index. When the firmware later uses a different peer_id in its data
path descriptors, ath12k_dp_peer_find_by_peerid() looks up the wrong
index and returns NULL, causing the "failed to find peer" error on
every TX completion.

Fix this by initializing dp_peer->peer_id to ATH12K_DP_PEER_ID_INVALID
for MLO peers at creation time, deferring the dp_peers[] RCU table
population. When ath12k_dp_peer_find_by_peerid() encounters a lookup
miss for an ML peer_id (one with ATH12K_PEER_ML_ID_VALID set), it
walks dp_peers_list for an MLO peer whose peer_id is still INVALID,
syncs peer_id from the firmware's actual value, and populates the
dp_peers[] table. This lazy sync approach ensures the host always uses
the firmware's real ML peer_id regardless of any internal firmware
counter behavior.

Guard the dp_peers[] RCU table clear in ath12k_dp_peer_delete() and
ath12k_mac_dp_peer_cleanup() against ATH12K_DP_PEER_ID_INVALID to
avoid clearing uninitialized slots. Replace per-peer clear_bit() with
bitmap_zero() in ath12k_mac_dp_peer_cleanup() to avoid out-of-bounds
access when peer_id has not been synced yet.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/net/wireless/ath/ath12k/dp_peer.c | 45 ++++++++++++++++-------
 drivers/net/wireless/ath/ath12k/mac.c     |  7 +++-
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 2660b4c7449b..0a7ef81425f5 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -413,8 +413,10 @@ u16 ath12k_dp_peer_get_peerid_index(struct ath12k_dp *dp, u16 peer_id)
 struct ath12k_dp_peer *ath12k_dp_peer_find_by_peerid(struct ath12k_pdev_dp *dp_pdev,
 						     u16 peer_id)
 {
-	u16 index;
+	struct ath12k_dp_hw *dp_hw = dp_pdev->dp_hw;
+	struct ath12k_dp_peer *dp_peer, *tmp;
 	struct ath12k_dp *dp = dp_pdev->dp;
+	u16 index;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			 "ath12k dp peer find by peerid index called without rcu lock");
@@ -423,8 +425,23 @@ struct ath12k_dp_peer *ath12k_dp_peer_find_by_peerid(struct ath12k_pdev_dp *dp_p
 		return NULL;
 
 	index = ath12k_dp_peer_get_peerid_index(dp, peer_id);
+	dp_peer = rcu_dereference(dp_hw->dp_peers[index]);
+
+	if (!dp_peer && (peer_id & ATH12K_PEER_ML_ID_VALID)) {
+		spin_lock_bh(&dp_hw->peer_lock);
+		list_for_each_entry(tmp, &dp_hw->dp_peers_list, list) {
+			if (tmp->is_mlo &&
+			    tmp->peer_id == ATH12K_DP_PEER_ID_INVALID) {
+				tmp->peer_id = peer_id;
+				rcu_assign_pointer(dp_hw->dp_peers[index], tmp);
+				dp_peer = tmp;
+				break;
+			}
+		}
+		spin_unlock_bh(&dp_hw->peer_lock);
+	}
 
-	return rcu_dereference(dp_pdev->dp_hw->dp_peers[index]);
+	return dp_peer;
 }
 EXPORT_SYMBOL(ath12k_dp_peer_find_by_peerid);
 
@@ -472,11 +489,11 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	dp_peer->is_mlo = params->is_mlo;
 
 	/*
-	 * For MLO client, the host assigns the ML peer ID, so set peer_id in dp_peer
-	 * For non-MLO client, host gets link peer ID from firmware and will be
-	 * assigned at the time of link peer creation
+	 * peer_id starts as INVALID for both MLO and non-MLO clients.
+	 * For MLO: synced from firmware's first data path descriptor.
+	 * For non-MLO: assigned at the time of link peer creation.
 	 */
-	dp_peer->peer_id = params->is_mlo ? params->peer_id : ATH12K_DP_PEER_ID_INVALID;
+	dp_peer->peer_id = ATH12K_DP_PEER_ID_INVALID;
 	dp_peer->ucast_ra_only = params->ucast_ra_only;
 
 	dp_peer->sec_type = HAL_ENCRYPT_TYPE_OPEN;
@@ -488,15 +505,12 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	list_add(&dp_peer->list, &dp_hw->dp_peers_list);
 
 	/*
-	 * For MLO client, the peer_id for ath12k_dp_peer is allocated by host
-	 * and that peer_id is known at this point, and hence this ath12k_dp_peer
-	 * can be added to the RCU table using the peer_id.
+	 * For MLO client, the dp_peers[] RCU table entry will be populated
+	 * when the firmware's actual peer_id is learned from the first data
+	 * path descriptor (in ath12k_dp_peer_find_by_peerid).
 	 * For non-MLO client, this addition to RCU table shall be done at the
 	 * time of assignment of ath12k_dp_link_peer to ath12k_dp_peer.
 	 */
-	if (dp_peer->is_mlo)
-		rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], dp_peer);
-
 	spin_unlock_bh(&dp_hw->peer_lock);
 
 	return 0;
@@ -515,8 +529,11 @@ void ath12k_dp_peer_delete(struct ath12k_dp_hw *dp_hw, u8 *addr,
 		return;
 	}
 
-	if (dp_peer->is_mlo)
-		rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
+	if (dp_peer->is_mlo) {
+		if (dp_peer->peer_id != ATH12K_DP_PEER_ID_INVALID)
+			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id],
+					   NULL);
+	}
 
 	list_del(&dp_peer->list);
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 3fa62deb8186..aa03491fb59a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1287,13 +1287,16 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 	spin_lock_bh(&dp_hw->peer_lock);
 	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
 		if (dp_peer->is_mlo) {
-			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
-			clear_bit(dp_peer->peer_id, ah->free_ml_peer_id_map);
+			if (dp_peer->peer_id != ATH12K_DP_PEER_ID_INVALID)
+				rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id],
+						   NULL);
 		}
 
 		list_move(&dp_peer->list, &peers);
 	}
 
+	bitmap_zero(ah->free_ml_peer_id_map, ATH12K_MAX_MLO_PEERS);
+
 	spin_unlock_bh(&dp_hw->peer_lock);
 
 	synchronize_rcu();
-- 
2.54.0

