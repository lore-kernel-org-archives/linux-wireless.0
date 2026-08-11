Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39AE42D746
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469107; cv=none; b=Q0KqyQtJ6bQA3TplIxGOrpEi/Wi+omyZIhzASUl0QqzTyrT4Vqjd2J9Tybihx8GLRo9fNqD7juCxIQipJrdK5t/2s8ShxORt2Ksm1XQX/WaiCdAGNt5AgFSOzPmIzQyBKxZjFZBB+FXL9q2DEn5/bM4uh0+17BNlEV5yI+u0HlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469107; c=relaxed/simple;
	bh=i2o6oIjcOCdIjj8jd4y69ppfTzT+QNT3Ti7tgPwrQHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFbl0jRbpAjngyTukHRSLP2ebfjKbdEseq6srb0WrrU/VyOKHClxpI1qmL5shPdXJWOjOTe+M56yNg4xYd+Dbu6J8xpiOfVH5aQHpFBgLVWsgYSQgwP7YwktHS5aagbOkhvkfNZLRHWrUv3fbdqp0GMbdrwU0a+dYMqcwMEmX7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMOm9xQ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMOm9xQ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786469104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HCyLJ79pv8hWz92QYpLkmP/lyG1DEx6jUegxaEtrzZE=;
	b=NMOm9xQ/J45Cwfopxyv/zT+JlYaN03d49VZ5t6T7Qa0fUbVQuHDI8V3RoaimE9PVWtl6SZ
	6yj7Vjoxd0AYPSnxnj1T0VcUHCYW5LL20os6jveoVqooYhKMeAlgj7sE4oHqycJuOIEff7
	VtzbXLh/Vl4KsEJgRWJk3jAfdRAxdks=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-vC2qugwaMWGxgDLnZY2Iig-1; Tue,
 11 Aug 2026 13:25:00 -0400
X-MC-Unique: vC2qugwaMWGxgDLnZY2Iig-1
X-Mimecast-MFC-AGG-ID: vC2qugwaMWGxgDLnZY2Iig_1786469099
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC0F418001CD;
	Tue, 11 Aug 2026 17:24:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 499C4180049F;
	Tue, 11 Aug 2026 17:24:57 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v6 3/4] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Tue, 11 Aug 2026 19:24:34 +0200
Message-ID: <20260811172435.616200-4-jtornosm@redhat.com>
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

Under heavy traffic, ath11k experiences frequent -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
This issue is more commonly observed in VMs with PCIe passthrough but
also occurs on bare metal systems. It is particularly problematic on
devices with a single shared TCL ring where all traffic classes
compete for the same 512 descriptor slots.

Implement a custom wake_tx_queue operation that:

1. Checks hardware ring space before dequeuing packets from mac80211
2. Uses per-ring locking (wake_tx_lock with spin_lock_bh) to serialize
   concurrent wake_tx_queue calls targeting the same ring and to ensure
   bottom halves are disabled as required by ieee80211_tx_dequeue()
3. Syncs with hardware state to get accurate free slot count
4. Resolves the target TCL ring using get_ring_selector(txq->ac),
   which selects the ring based on the access category
5. Returns early during firmware crash in the same way as other
   tx paths

This approach follows the pattern used in the iwlwifi driver, adapted
for ath11k's hardware ring architecture.

This eliminates -ENOMEM errors and improves throughput by optimizing
resource usage and preventing unnecessary packet drops.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v6: Address comments from Jeff Johnson:
  - remove unnecessary `if (!ar) return;` (hw->priv is always valid when hw is valid)
  - add Tested-on tag
v5: https://lore.kernel.org/all/20260807105843.20203-4-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/dp.c  |  1 +
 drivers/net/wireless/ath/ath11k/dp.h  |  2 ++
 drivers/net/wireless/ath/ath11k/mac.c | 49 ++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index f389b97acbdd..2e5978ec2b05 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -1087,6 +1087,7 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
 		idr_init(&dp->tx_ring[i].txbuf_idr);
 		spin_lock_init(&dp->tx_ring[i].tx_idr_lock);
+		spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 84f66839f0c6..6d99501aa269 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -87,6 +87,8 @@ struct dp_tx_ring {
 	struct idr txbuf_idr;
 	/* Protects txbuf_idr and num_pending */
 	spinlock_t tx_idr_lock;
+	/* Serializes wake_tx_queue operations for this ring */
+	spinlock_t wake_tx_lock;
 	struct hal_wbm_release_ring *tx_status;
 	int tx_status_head;
 	int tx_status_tail;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..da006ae5ea79 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10065,9 +10065,56 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					struct ieee80211_txq *txq)
+{
+	struct ieee80211_tx_control control = {
+		.sta = txq->sta,
+	};
+	struct ath11k *ar = hw->priv;
+	struct dp_tx_ring *tx_ring;
+	struct hal_srng *tcl_ring;
+	struct sk_buff *skb;
+	u32 ring_selector;
+	int num_free;
+	u8 ring_id;
+
+	ring_selector = ar->ab->hw_params.hw_ops->get_ring_selector(txq->ac);
+	ring_id = ring_selector % ar->ab->hw_params.hal_params->num_tx_rings;
+	tx_ring = &ar->ab->dp.tx_ring[ring_id];
+	tcl_ring = &ar->ab->hal.srng_list[tx_ring->tcl_data_ring.ring_id];
+
+	while (1) {
+		if (unlikely(test_bit(ATH11K_FLAG_CRASH_FLUSH,
+				      &ar->ab->dev_flags)))
+			break;
+
+		spin_lock_bh(&tx_ring->wake_tx_lock);
+
+		spin_lock(&tcl_ring->lock);
+		num_free = ath11k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
+		spin_unlock(&tcl_ring->lock);
+
+		if (num_free == 0) {
+			spin_unlock_bh(&tx_ring->wake_tx_lock);
+			break;
+		}
+
+		skb = ieee80211_tx_dequeue(hw, txq);
+		if (!skb) {
+			spin_unlock_bh(&tx_ring->wake_tx_lock);
+			break;
+		}
+
+		ath11k_mac_op_tx(hw, &control, skb);
+
+		spin_unlock_bh(&tx_ring->wake_tx_lock);
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
-- 
2.54.0

