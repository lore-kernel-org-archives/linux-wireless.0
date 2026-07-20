Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB85B3AFD00
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 07:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531361; cv=none; b=IS2al9lxhNWxrhfjyylKj0pffy9h6+QjKSJdlsBV0LsPWhaUkLdHUlQRroXUj9wb6+uvPpBloCu6AualTfxDBqhci3B/XPvhA9EA2CMF9b7Na/H+c3Do1vj9WeEJQznLeSGiSP1VBRESYWJUBhwqp8CuG1DxawItaQ/RyYErA7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531361; c=relaxed/simple;
	bh=qCZYdt2Fpv0bYeGUs7urqVS70LiOaGHYaleh4hPBm8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfjNvK+P1DVENK+25J4cHg+brszFJvPA9w1P7Gs6BcK1E3uJEf0O0BI2zVJute8TVrcIuXDFNwsLXSJfrnM5cfgY5C8QueWhLxMOZDtMCH10q0fJCLUbX1uI4A3pmgy8qbLg5g33Uuu2QxFFFPJgVzwgjkZRmoNAtq8UYCUlXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBsGXmZ0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBsGXmZ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784531358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76WUS4y9G8N+M15DI58hZKJO0HW9L3tuGSU3+bl3J/4=;
	b=GBsGXmZ0x9HRzKvR/+LrQS++0ciN2GUHnqmC5bKJNKTzWeUnteoIlHH9j5krTmochz01KB
	5rbw7dd4Isc8N3r1d4y42VSrgy+nVCD6gIZI6o2Un3qYUpth1YIx915mRYiISLKIk93gs9
	/Toor6MaFf6BxoVzFTL5Y5f0NlUY5rY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-A46j4p8jNL-wo8oCJ2WW4g-1; Mon,
 20 Jul 2026 03:09:15 -0400
X-MC-Unique: A46j4p8jNL-wo8oCJ2WW4g-1
X-Mimecast-MFC-AGG-ID: A46j4p8jNL-wo8oCJ2WW4g_1784531354
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA7D31944B2E;
	Mon, 20 Jul 2026 07:09:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.69])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8A9A180034F;
	Mon, 20 Jul 2026 07:09:11 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 2/3] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Mon, 20 Jul 2026 09:08:50 +0200
Message-ID: <20260720070852.206495-3-jtornosm@redhat.com>
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

Under heavy traffic, ath11k experiences frequent -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
This issue is more commonly observed in VMs with PCIe passthrough but
also occurs on bare metal systems. It is particularly problematic on
devices with a single shared TCL ring where all traffic classes
compete for the same 512 descriptor slots.

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
for ath11k's hardware ring architecture.

This eliminates -ENOMEM errors and improves throughput by optimizing
resource usage and preventing unnecessary packet drops.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: Address the review comments from Tamizh Raja:
    - Replace per-ring wake_tx_lock with per-txq spinlock via
      txq->drv_priv to fix race condition between ieee80211_tx_peek() and
      ieee80211_tx_dequeue() when multiple CPUs process the same txq
v2: https://lore.kernel.org/all/20260715125017.277242-3-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/mac.c | 80 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath11k/mac.h |  5 ++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..1eb5edca4ee6 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7079,6 +7079,7 @@ static int ath11k_mac_op_add_interface(struct ieee80211_hw *hw,
 	struct vdev_create_params vdev_param = {};
 	struct peer_create_params peer_param;
 	u32 param_id, param_value;
+	struct ath11k_txq *atxq;
 	u16 nss;
 	int i;
 	int ret, fbret;
@@ -7112,6 +7113,11 @@ static int ath11k_mac_op_add_interface(struct ieee80211_hw *hw,
 	INIT_DELAYED_WORK(&arvif->connection_loss_work,
 			  ath11k_mac_vif_sta_connection_loss_work);
 
+	if (vif->txq) {
+		atxq = (void *)vif->txq->drv_priv;
+		spin_lock_init(&atxq->lock);
+	}
+
 	for (i = 0; i < ARRAY_SIZE(arvif->bitrate_mask.control); i++) {
 		arvif->bitrate_mask.control[i].legacy = 0xffffffff;
 		arvif->bitrate_mask.control[i].gi = NL80211_TXRATE_FORCE_SGI;
@@ -9938,7 +9944,9 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	enum ieee80211_ap_reg_power power_type;
 	struct cur_regulatory_info *reg_info;
 	struct ath11k_peer *peer;
+	struct ath11k_txq *atxq;
 	int ret = 0;
+	int tid;
 
 	/* cancel must be done outside the mutex to avoid deadlock */
 	if ((old_state == IEEE80211_STA_NONE &&
@@ -9957,6 +9965,14 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 		INIT_WORK(&arsta->update_wk, ath11k_sta_rc_update_wk);
 		INIT_WORK(&arsta->set_4addr_wk, ath11k_sta_set_4addr_wk);
 
+		for (tid = 0; tid < ARRAY_SIZE(sta->txq); tid++) {
+			if (!sta->txq[tid])
+				continue;
+
+			atxq = (void *)sta->txq[tid]->drv_priv;
+			spin_lock_init(&atxq->lock);
+		}
+
 		ret = ath11k_mac_station_add(ar, vif, sta);
 		if (ret)
 			ath11k_warn(ar->ab, "Failed to add station: %pM for VDEV: %d\n",
@@ -10065,9 +10081,70 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					struct ieee80211_txq *txq)
+{
+	struct ath11k_txq *atxq = (void *)txq->drv_priv;
+	struct ieee80211_tx_control control = {
+		.sta = txq->sta,
+	};
+	const struct ath11k_hw_ops *ops;
+	const struct sk_buff *peek_skb;
+	struct ath11k *ar = hw->priv;
+	struct dp_tx_ring *tx_ring;
+	struct hal_srng *tcl_ring;
+	struct sk_buff *skb;
+	u32 ring_selector;
+	int num_free;
+	u8 ring_id;
+
+	if (!ar)
+		return;
+
+	while (1) {
+		if (unlikely(test_bit(ATH11K_FLAG_CRASH_FLUSH,
+				      &ar->ab->dev_flags)))
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
+		ops = ar->ab->hw_params.hw_ops;
+		ring_selector = ops->get_ring_selector((struct sk_buff *)peek_skb);
+		ring_id = ring_selector %
+			  ar->ab->hw_params.hal_params->num_tx_rings;
+
+		tx_ring = &ar->ab->dp.tx_ring[ring_id];
+		tcl_ring = &ar->ab->hal.srng_list[tx_ring->tcl_data_ring.ring_id];
+
+		spin_lock(&tcl_ring->lock);
+		num_free = ath11k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
+		spin_unlock(&tcl_ring->lock);
+
+		if (num_free == 0) {
+			spin_unlock_bh(&atxq->lock);
+			break;
+		}
+
+		skb = ieee80211_tx_dequeue(hw, txq);
+
+		spin_unlock_bh(&atxq->lock);
+
+		if (!skb)
+			break;
+
+		ath11k_mac_op_tx(hw, &control, skb);
+	}
+}
+
 static const struct ieee80211_ops ath11k_ops = {
 	.tx				= ath11k_mac_op_tx,
-	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
+	.wake_tx_queue			= ath11k_mac_op_wake_tx_queue,
 	.start                          = ath11k_mac_op_start,
 	.stop                           = ath11k_mac_op_stop,
 	.reconfig_complete              = ath11k_mac_op_reconfig_complete,
@@ -10590,6 +10667,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath11k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath11k_sta);
+	ar->hw->txq_data_size = sizeof(struct ath11k_txq);
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 59f83c7175fd..b0116ced9c67 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -14,6 +14,11 @@
 struct ath11k;
 struct ath11k_base;
 
+struct ath11k_txq {
+	/* protects ieee80211_tx_peek/dequeue serialization per txq */
+	spinlock_t lock;
+};
+
 struct ath11k_generic_iter {
 	struct ath11k *ar;
 	int ret;
-- 
2.54.0

