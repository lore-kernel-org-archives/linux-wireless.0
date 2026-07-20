Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58C43B7756
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 07:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531366; cv=none; b=R+A+avwEbejI4M6DCh7yFCUiOsZInBqUGkBh0CZgW0aSGvgTeAyXBezUirI/eayDAQQVWeS2rtDPlJpRMfeq4b78jV5IIj6saTF+EIVLLDtS8aGhdo74aTL16BIZ4ReSMAdUZkRipnzkyphD5fALVarBpE4MmBIK1S6OwYVFxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531366; c=relaxed/simple;
	bh=PCt2uuCyK/gIRYFPGgmteAhY0F6S4OPMSLaGabX0acc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcTp9XGNUUeVn0hW/32rqLzhRIBNaSvXOhOmGDHHgx91qsOh1iVJZ8hsbzEEArPGYuyfr/WvaI8Kvw75nbDYLD12Lc1sd5pNjvW7nIjowhqJ3HSa2Z+KvFrqNHSQ3rIVTEN4lRKRhJdJao/W7JVgJbWb2/L5JT8hE3f+YtouNA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CIPOZ1si; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CIPOZ1si"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784531363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ItVte48j2cfPO1m44LhBPhM+Ix/JT2D7ZKzubkk1kfg=;
	b=CIPOZ1si9+4lg0o3Ss7szieosT1Pfh4ZgCai/mqPYbZcchV0Nk1GZRZEQrT9ekvSAgELMP
	X3KDK3KTVc4oLbjsDjGbtaXREGTGXtt2GV9yMs5MqPIA3KBxecMpgsNyLwpk1XT7MicfTS
	TyKzAb2U+7ka2E79wOVAnblLo31EPnM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-d72ivhm9POeYtwKMbp4s_w-1; Mon,
 20 Jul 2026 03:09:20 -0400
X-MC-Unique: d72ivhm9POeYtwKMbp4s_w-1
X-Mimecast-MFC-AGG-ID: d72ivhm9POeYtwKMbp4s_w_1784531359
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14D5A1953961;
	Mon, 20 Jul 2026 07:09:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.69])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ADC06180034F;
	Mon, 20 Jul 2026 07:09:15 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 3/3] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Mon, 20 Jul 2026 09:08:51 +0200
Message-ID: <20260720070852.206495-4-jtornosm@redhat.com>
In-Reply-To: <20260720070852.206495-1-jtornosm@redhat.com>
References: <20260720070852.206495-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Under heavy traffic, ath12k can hang and experiences -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
This issue is more commonly observed in VMs with PCIe passthrough but
also occurs on bare metal systems.

Implement a custom wake_tx_queue operation that:

1. Checks hardware ring space before dequeuing packets from mac80211
2. Uses per-txq locking via txq->drv_priv to serialize peek and
   dequeue operations for the same txq, preventing use-after-free
   races between ieee80211_tx_peek() and ieee80211_tx_dequeue() when
   multiple CPUs process the same txq concurrently, while keeping
   different txqs fully parallel
3. Syncs with hardware state to get accurate free slot count
4. Uses ieee80211_tx_peek() to determine the exact target ring via
   get_ring_selector(), matching dp_tx on all platforms
5. Returns early during firmware crash in the same way as other
   tx paths

This approach follows the pattern used in the iwlwifi driver, adapted
for ath12k's hardware ring architecture.

This prevents hangs, eliminates -ENOMEM errors, and improves throughput
by optimizing resource usage and preventing unnecessary packet drops.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: Address the review comments from Tamizh Raja:
    - Replace per-ring wake_tx_lock with per-txq spinlock via
      txq->drv_priv to fix race condition between ieee80211_tx_peek() and
      ieee80211_tx_dequeue() when multiple CPUs process the same txq
    - Fix MLO link selection in wake_tx_queue to use
      rcu_dereference(ahvif->link[link_id]) instead of deflink, matching
      the link selection logic in op_tx
v2: https://lore.kernel.org/all/20260715125017.277242-4-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/hal.c      |  1 +
 drivers/net/wireless/ath/ath12k/mac.c      | 17 +++++
 drivers/net/wireless/ath/ath12k/mac.h      |  5 ++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 87 +++++++++++++++++++++-
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index a164563fff28..c1c656e4550b 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -390,6 +390,7 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *ab, struct hal_srng *srng,
 	else
 		return ((srng->ring_size - hp + tp) / srng->entry_size) - 1;
 }
+EXPORT_SYMBOL_GPL(ath12k_hal_srng_src_num_free);
 
 void *ath12k_hal_srng_src_next_peek(struct ath12k_base *ab,
 				    struct hal_srng *srng)
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 51c4df32e716..03618a8d3e65 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7705,10 +7705,12 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	struct ath12k_link_vif *arvif;
 	struct ath12k_link_sta *arsta;
 	unsigned long valid_links;
+	struct ath12k_txq *atxq;
 	u16 selected_links = 0;
 	u8 link_id = 0, i;
 	struct ath12k *ar;
 	int ret = -EINVAL;
+	int tid;
 	struct ath12k_dp_peer_create_params dp_params = {};
 
 	lockdep_assert_wiphy(hw->wiphy);
@@ -7728,6 +7730,14 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 		memset(ahsta, 0, sizeof(*ahsta));
 		ahsta->free_logical_link_idx_map = U16_MAX;
 
+		for (tid = 0; tid < ARRAY_SIZE(sta->txq); tid++) {
+			if (!sta->txq[tid])
+				continue;
+
+			atxq = (void *)sta->txq[tid]->drv_priv;
+			spin_lock_init(&atxq->lock);
+		}
+
 		arsta = &ahsta->deflink;
 
 		/* ML sta */
@@ -10790,6 +10800,7 @@ int ath12k_mac_op_add_interface(struct ieee80211_hw *hw,
 	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
 	struct ath12k_reg_info *reg_info;
 	struct ath12k_link_vif *arvif;
+	struct ath12k_txq *atxq;
 	struct ath12k_base *ab;
 	struct ath12k *ar;
 	int i;
@@ -10802,6 +10813,11 @@ int ath12k_mac_op_add_interface(struct ieee80211_hw *hw,
 	ahvif->vif = vif;
 	arvif = &ahvif->deflink;
 
+	if (vif->txq) {
+		atxq = (void *)vif->txq->drv_priv;
+		spin_lock_init(&atxq->lock);
+	}
+
 	ath12k_mac_init_arvif(ahvif, arvif, -1);
 
 	/* Allocate Default Queue now and reassign during actual vdev create */
@@ -14899,6 +14915,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	hw->vif_data_size = sizeof(struct ath12k_vif);
 	hw->sta_data_size = sizeof(struct ath12k_sta);
+	hw->txq_data_size = sizeof(struct ath12k_txq);
 	hw->extra_tx_headroom = ab->hw_params->iova_mask;
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index aba98afd4365..2855d8fdb99d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -17,6 +17,11 @@ struct ath12k_hw;
 struct ath12k_hw_group;
 struct ath12k_pdev_map;
 
+struct ath12k_txq {
+	/* protects ieee80211_tx_peek/dequeue serialization per txq */
+	spinlock_t lock;
+};
+
 struct ath12k_generic_iter {
 	struct ath12k *ar;
 	int ret;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index d9fdd2fc8298..86c3e9a8b87c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1100,9 +1100,94 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath12k_wifi7_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					      struct ieee80211_txq *txq)
+{
+	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(txq->vif);
+	struct ath12k_txq *atxq = (void *)txq->drv_priv;
+	struct ath12k_hw *ah = ath12k_hw_to_ah(hw);
+	struct ieee80211_tx_control control = {
+		.sta = txq->sta,
+	};
+	struct ieee80211_vif *vif = txq->vif;
+	const struct ath12k_hw_ops *ops;
+	const struct sk_buff *peek_skb;
+	struct ath12k_link_vif *arvif;
+	struct dp_tx_ring *tx_ring;
+	struct hal_srng *tcl_ring;
+	struct ath12k_sta *ahsta;
+	struct ath12k_dp *dp;
+	struct sk_buff *skb;
+	struct ath12k *ar;
+	u32 ring_selector;
+	int num_free;
+	u8 ring_id;
+	u8 link_id;
+
+	while (1) {
+		if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH,
+				      &ah->radio[0].ab->dev_flags)))
+			break;
+
+		spin_lock_bh(&atxq->lock);
+
+		peek_skb = ieee80211_tx_peek(hw, txq);
+		if (!peek_skb) {
+			spin_unlock_bh(&atxq->lock);
+			break;
+		}
+
+		if (ieee80211_vif_is_mld(vif) && txq->sta) {
+			ahsta = ath12k_sta_to_ahsta(txq->sta);
+			link_id = ahsta->assoc_link_id;
+		} else {
+			link_id = ahvif->deflink.link_id;
+		}
+
+		rcu_read_lock();
+
+		arvif = rcu_dereference(ahvif->link[link_id]);
+		if (!arvif || !arvif->ar) {
+			rcu_read_unlock();
+			spin_unlock_bh(&atxq->lock);
+			break;
+		}
+
+		ar = arvif->ar;
+		dp = ar->ab->dp;
+
+		ops = dp->hw_params->hw_ops;
+		ring_selector = ops->get_ring_selector((struct sk_buff *)peek_skb);
+		ring_id = ring_selector % dp->hw_params->max_tx_ring;
+
+		tx_ring = &dp->tx_ring[ring_id];
+		tcl_ring = &dp->hal->srng_list[tx_ring->tcl_data_ring.ring_id];
+
+		spin_lock(&tcl_ring->lock);
+		num_free = ath12k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
+		spin_unlock(&tcl_ring->lock);
+
+		if (num_free == 0) {
+			rcu_read_unlock();
+			spin_unlock_bh(&atxq->lock);
+			break;
+		}
+
+		skb = ieee80211_tx_dequeue(hw, txq);
+
+		rcu_read_unlock();
+		spin_unlock_bh(&atxq->lock);
+
+		if (!skb)
+			break;
+
+		ath12k_wifi7_mac_op_tx(hw, &control, skb);
+	}
+}
+
 static const struct ieee80211_ops ath12k_ops_wifi7 = {
 	.tx				= ath12k_wifi7_mac_op_tx,
-	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
+	.wake_tx_queue			= ath12k_wifi7_mac_op_wake_tx_queue,
 	.start                          = ath12k_mac_op_start,
 	.stop                           = ath12k_mac_op_stop,
 	.reconfig_complete              = ath12k_mac_op_reconfig_complete,
-- 
2.54.0

