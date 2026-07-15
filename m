Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6534921B3
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784119864; cv=none; b=HZfwvSZrfBUwP4KAZhJRFAR9Lm8Gz0oiyejCJLyYL/Nsbb8QZLswabAQwPBaki/zqNBuCK5L5EBnwKrJzXpf7PoJMvXllTswuLbBe5V36ZmGwX+qWvyBOIZXvEDT9IlVkGkT4ga1vC6c92nZIITPUdCVxq0PscWgb7O44u4ZtH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784119864; c=relaxed/simple;
	bh=GyKuxCsnrg84ZDjgCeHJpb6FXmNkP+hkGiUaRMN7ohs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqNTAlKjLF7ogXSi3XkS7KvAxV2FRZ7HJI7c6CQ6kP4wWj9P6ELU8fXIpo+DUR669jS5eZDXWu79wCDyIBgZZP4QINyxcY2uDmZCV0iqLJp23kLF7ub9M+x7Cukawn2Fzmw5Y/DgluRvDO1q1IjW4hkL1eIrDfDAbcxow582ORs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AS4dnpjh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AS4dnpjh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784119851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxnkyzJDoAKMDhHYsJea70mstN7dUKPust/4lleKlEU=;
	b=AS4dnpjhRRGfO0zm1ADdJY0+bIrZxeFrF3ooJPFBWlx+lkaaWpIwp6EL/UiAGPdH5lLo0h
	0gwl9GDydUJKyq1hGIxbGMBoiVTsrk7u2DpYxQWbTa+8p9IIxOzdIvNmb5Yn5HgU+nZVxH
	rQZozKHt8xle333ohcAEMgx8ku7R4NI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-7y5kdcVgMn6KesJOpEYI3Q-1; Wed,
 15 Jul 2026 08:50:48 -0400
X-MC-Unique: 7y5kdcVgMn6KesJOpEYI3Q-1
X-Mimecast-MFC-AGG-ID: 7y5kdcVgMn6KesJOpEYI3Q_1784119847
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CF021955F22;
	Wed, 15 Jul 2026 12:50:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.52])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 458D818004D4;
	Wed, 15 Jul 2026 12:50:45 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 3/3] wifi: ath12k: implement custom wake_tx_queue with flow control
Date: Wed, 15 Jul 2026 14:50:16 +0200
Message-ID: <20260715125017.277242-4-jtornosm@redhat.com>
In-Reply-To: <20260715125017.277242-1-jtornosm@redhat.com>
References: <20260715125017.277242-1-jtornosm@redhat.com>
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
2. Uses per-ring locking to serialize ring access and prevent races
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
v2: Address feedback from Zhi-Jun You:
    - Add ieee80211_tx_peek() API in mac80211 to peek at the next frame
      without dequeuing, enabling accurate ring selection before dequeue
    - Use get_ring_selector() on the peeked skb to determine the exact
      target ring matching dp_tx, fixing ring mismatch on multi-ring
      platforms (ipq8074, wcn6750, qcn9274, wcn7850)
    Address feedback from Tamizh Chelvam Raja:
    - Fix ath12k radio assignment: obtain ar from txq->vif through the
      arvif chain instead of ah->radio flexible array
    Move CRASH_FLUSH check inside the TX loop
v1: https://lore.kernel.org/all/20260710155443.1761760-3-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/dp.c       |  1 +
 drivers/net/wireless/ath/ath12k/dp.h       |  2 +
 drivers/net/wireless/ath/ath12k/hal.c      |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 65 +++++++++++++++++++++-
 4 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index af5f11fc1d84..3d46cfbf0a1c 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1539,6 +1539,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 	}
 
 	for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
+		spin_lock_init(&dp->tx_ring[i].wake_tx_lock);
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index f8cfc7bb29dd..68d2020be9b8 100644
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
index a164563fff28..c1c656e4550b 100644
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
index d9fdd2fc8298..306d51da3ea1 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1100,9 +1100,72 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath12k_wifi7_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					      struct ieee80211_txq *txq)
+{
+	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(txq->vif);
+	struct ath12k_link_vif *arvif = &ahvif->deflink;
+	struct ieee80211_tx_control control = {
+		.sta = txq->sta,
+	};
+	const struct sk_buff *peek_skb;
+	struct dp_tx_ring *tx_ring;
+	struct hal_srng *tcl_ring;
+	struct ath12k_dp *dp;
+	struct sk_buff *skb;
+	struct ath12k *ar;
+	u32 ring_selector;
+	int num_free;
+	u8 ring_id;
+
+	ar = arvif->ar;
+	if (!ar)
+		return;
+
+	dp = ar->ab->dp;
+
+	while (1) {
+		if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH,
+				      &ar->ab->dev_flags)))
+			break;
+
+		peek_skb = ieee80211_tx_peek(hw, txq);
+		if (!peek_skb)
+			break;
+
+		ring_selector = dp->hw_params->hw_ops->get_ring_selector(
+					(struct sk_buff *)peek_skb);
+		ring_id = ring_selector % dp->hw_params->max_tx_ring;
+
+		tx_ring = &dp->tx_ring[ring_id];
+		tcl_ring = &dp->hal->srng_list[tx_ring->tcl_data_ring.ring_id];
+
+		spin_lock_bh(&tx_ring->wake_tx_lock);
+
+		spin_lock(&tcl_ring->lock);
+		num_free = ath12k_hal_srng_src_num_free(ar->ab, tcl_ring, true);
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
+		ath12k_wifi7_mac_op_tx(hw, &control, skb);
+
+		spin_unlock_bh(&tx_ring->wake_tx_lock);
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

