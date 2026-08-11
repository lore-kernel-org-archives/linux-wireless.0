Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF80439F7E
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469116; cv=none; b=N30njdDZgnkARHIlFgksLvGXLa+zEnkJ7m4WIznbmnNw1BKR13IC0ubUDkCQ7rPhVP2uApxZ2B2mucGfqpiMttIx1HCOp4/8BHq0gnSlcUkX+T6AkSWQFcpdP6GOlYGLAmTG8NpqdjUMNLf/h9mLnjbmmmzC6axlP4l1lBFv6UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469116; c=relaxed/simple;
	bh=sP1S1xus9PhCbt16W/rwt3D3oWLAK1+6HVR2ySWSQLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaazbwOsAF6vGK+NQckh7wC1gdpeNCTtEOP5DV9OjfzFTchuDYSxQijLPoduZx+/oVqBSvXjyikKOQdMUjEFLORWRFaAEw4ejYa56A5xo71qEgkZXkV9TH6+QjzcNp+WsHSkUmm88ZAf/lY8LX1t9AhW6kgJsmVAcJNj58uULto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWYRkoEF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWYRkoEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786469114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFY6qN/TPylLUj/ILI28XVKRFII3WhSeiVrKQM0T2VA=;
	b=BWYRkoEFzLr9VriDuloNALVCI16AmSqmplSmDYtSVx6JQkEFZ1SdtKjZhL+UmmTZgy2hOM
	19Z6Hld+KXsJHe5r625Th58pheiUuRW0gealN3FsEsyEhtPYmiDvI7WdAUHC5fvSFRh1y0
	TjsPJONNYccrd93s7Mtde1uMAtK9kp4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-0dnF9LnUNyiPNQNqlRx9IQ-1; Tue,
 11 Aug 2026 13:25:05 -0400
X-MC-Unique: 0dnF9LnUNyiPNQNqlRx9IQ-1
X-Mimecast-MFC-AGG-ID: 0dnF9LnUNyiPNQNqlRx9IQ_1786469104
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 670CA19560BB;
	Tue, 11 Aug 2026 17:25:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E74791800577;
	Tue, 11 Aug 2026 17:25:01 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v6 4/4] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Tue, 11 Aug 2026 19:24:35 +0200
Message-ID: <20260811172435.616200-5-jtornosm@redhat.com>
In-Reply-To: <20260811172435.616200-1-jtornosm@redhat.com>
References: <20260811172435.616200-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Under heavy traffic, ath12k can hang and experiences -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
This issue is more commonly observed in VMs with PCIe passthrough but
also occurs on bare metal systems.

Implement a custom wake_tx_queue operation that:

1. Checks hardware ring space before dequeuing packets from mac80211
2. Uses per-ring locking (wake_tx_lock with spin_lock_bh) to serialize
   concurrent wake_tx_queue calls targeting the same ring and to ensure
   bottom halves are disabled as required by ieee80211_tx_dequeue()
3. Syncs with hardware state to get accurate free slot count
4. Resolves the target TCL ring once using get_ring_selector(txq->ac),
   which selects the ring based on the access category
5. Returns early during firmware crash in the same way as other
   tx paths

This approach follows the pattern used in the iwlwifi driver, adapted
for ath12k's hardware ring architecture.

This prevents hangs, eliminates -ENOMEM errors, and improves throughput
by optimizing resource usage and preventing unnecessary packet drops.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v6: Address comments from Jeff Johnson:
  - use EXPORT_SYMBOL instead of EXPORT_SYMBOL_GPL
    (ath12k uses BSD-3-Clause-Clear license)
  - replace manual spin_lock_bh/spin_unlock_bh with guard(spinlock_bh)
  - add Tested-on tag
v5: https://lore.kernel.org/all/20260807105843.20203-5-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/dp.c       |  1 +
 drivers/net/wireless/ath/ath12k/dp.h       |  2 +
 drivers/net/wireless/ath/ath12k/hal.c      |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 69 +++++++++++++++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f9b37d75956d..e62fa416b992 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1537,6 +1537,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 	}
 
 	for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
+		spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560..4bf8a8a6d76c 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -58,6 +58,8 @@ struct dp_tx_ring {
 	u8 tcl_data_ring_id;
 	struct dp_srng tcl_data_ring;
 	struct dp_srng tcl_comp_ring;
+	/* Serializes wake_tx_queue operations for this ring */
+	spinlock_t wake_tx_lock;
 	struct hal_wbm_completion_ring_tx *tx_status;
 	int tx_status_head;
 	int tx_status_tail;
diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index c0c3d2f047ef..fbe4dc41e34b 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -390,6 +390,7 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *ab, struct hal_srng *srng,
 	else
 		return ((srng->ring_size - hp + tp) / srng->entry_size) - 1;
 }
+EXPORT_SYMBOL(ath12k_hal_srng_src_num_free);
 
 void *ath12k_hal_srng_src_next_peek(struct ath12k_base *ab,
 				    struct hal_srng *srng)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 678c512a2199..7bfeb9397465 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1160,9 +1160,76 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath12k_wifi7_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					      struct ieee80211_txq *txq)
+{
+	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(txq->vif);
+	struct ieee80211_tx_control control = {
+		.sta = txq->sta,
+	};
+	struct ieee80211_vif *vif = txq->vif;
+	struct ath12k_link_vif *arvif;
+	struct dp_tx_ring *tx_ring;
+	struct hal_srng *tcl_ring;
+	struct ath12k_sta *ahsta;
+	struct ath12k_dp *dp;
+	struct sk_buff *skb;
+	struct ath12k *ar;
+	u8 ring_selector;
+	int num_free;
+	u8 ring_id;
+	u8 link_id;
+
+	if (ieee80211_vif_is_mld(vif) && txq->sta) {
+		ahsta = ath12k_sta_to_ahsta(txq->sta);
+		link_id = ahsta->assoc_link_id;
+	} else {
+		link_id = ahvif->deflink.link_id;
+	}
+
+	rcu_read_lock();
+
+	arvif = rcu_dereference(ahvif->link[link_id]);
+	if (!arvif || !arvif->ar) {
+		rcu_read_unlock();
+		return;
+	}
+
+	ar = arvif->ar;
+	dp = ar->ab->dp;
+
+	ring_selector = dp->hw_params->hw_ops->get_ring_selector(txq->ac);
+	ring_id = ring_selector % dp->hw_params->max_tx_ring;
+	tx_ring = &dp->tx_ring[ring_id];
+	tcl_ring = &dp->hal->srng_list[tx_ring->tcl_data_ring.ring_id];
+
+	while (1) {
+		if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH,
+				      &ar->ab->dev_flags)))
+			break;
+
+		guard(spinlock_bh)(&tx_ring->wake_tx_lock);
+
+		spin_lock(&tcl_ring->lock);
+		num_free = ath12k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
+		spin_unlock(&tcl_ring->lock);
+
+		if (num_free == 0)
+			break;
+
+		skb = ieee80211_tx_dequeue(hw, txq);
+		if (!skb)
+			break;
+
+		ath12k_wifi7_mac_op_tx(hw, &control, skb);
+	}
+
+	rcu_read_unlock();
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

