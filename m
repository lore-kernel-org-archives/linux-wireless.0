Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75374457C7
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469104; cv=none; b=bujIHIw6/4w6b6bm7EYYdbJBU8N/vgRMv1oloWNuernQHn9nMSMgcFs0f9XGXPNUEQIKGd8uVa0FbMsOX9JIQsLePrJ5SZxNEMVNSfQa3HBzS1FTUb8/m9YRjzZO2fuFCoPhN4HbBjr3acacB3UrlEy3zNZkPTeHKx3r5RVYkeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469104; c=relaxed/simple;
	bh=KtXIVmWJQjkW07bp79GlQ6QKUNFdAMat6iDXNQ9By9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMf5P9ps3w+wxecEWokgJpvqJ/VGv1UrsaDyuPoXkXQxcq28hjsPxILJ8R3+yCfnksWJDPA9SGHyAtbTbhmP474pVJwu8wIsKyAX/jRRLknbiyxXd6wPCI07cDpBAPsH9keeXU9StomGbA0NiudjmMoSlcs477rXFVJZ+alMG/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMHSWftL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMHSWftL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786469101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeWNsuQd6HXeIizMohj4EEQSIUOOmuJIZ6MNYX+Hlos=;
	b=VMHSWftLYeBV3MbCIzNcETNgodewpH5c0jHxBklkLq/lsn0ue7yxh4wJ8amyKKcuYhwZuT
	iD67CZdVf+REt/SjJcGUQ04DtSi7zAekmIJzKXcStQ3DAVrbaaMnRg1FvTAa2sb6r+gFwM
	2gizJO2AiZYsWf1elVwihAof/axeEdc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-AHujqnrLP-u-xa8ouV5yjg-1; Tue,
 11 Aug 2026 13:24:57 -0400
X-MC-Unique: AHujqnrLP-u-xa8ouV5yjg-1
X-Mimecast-MFC-AGG-ID: AHujqnrLP-u-xa8ouV5yjg_1786469095
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F40881955DEA;
	Tue, 11 Aug 2026 17:24:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0DB2E180049F;
	Tue, 11 Aug 2026 17:24:51 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v6 2/4] wifi: ath11k/ath12k: remove skb parameter from get_ring_selector
Date: Tue, 11 Aug 2026 19:24:33 +0200
Message-ID: <20260811172435.616200-3-jtornosm@redhat.com>
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

Change the get_ring_selector hw_ops callback signature from
get_ring_selector(struct sk_buff *skb) to get_ring_selector(u8 ac),
removing the dependency on the skb.

After the previous patch switched WCN6750 from skb_get_hash() to
skb_get_queue_mapping(), all get_ring_selector implementations fall
into two categories:
 - smp_processor_id(): ignores the skb entirely
 - skb_get_queue_mapping(): only reads the AC value from the skb

Since the AC is the only information extracted from the skb, pass it
directly as a u8 parameter instead. Callers in the dp_tx path now
pass skb_get_queue_mapping(skb), which preserves the exact same
behavior.

This change enables a subsequent patch to call get_ring_selector()
from wake_tx_queue using txq->ac, without needing access to the skb.
mac80211 guarantees that skb_get_queue_mapping(skb) == txq->ac
for any skb dequeued from a given txq, since both values are
derived from the same skb->priority through the same AC mapping.

No functional change.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v6: no modification
v5: https://lore.kernel.org/all/20260807105843.20203-3-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/dp_tx.c       |  2 +-
 drivers/net/wireless/ath/ath11k/hw.c          | 16 ++++------------
 drivers/net/wireless/ath/ath11k/hw.h          |  2 +-
 drivers/net/wireless/ath/ath12k/hw.h          |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |  6 +++---
 6 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index cac970c92806..083aca8ff355 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -108,7 +108,7 @@ int ath11k_dp_tx(struct ath11k *ar, struct ath11k_vif *arvif,
 
 	pool_id = skb_get_queue_mapping(skb) & (ATH11K_HW_MAX_QUEUES - 1);
 
-	ring_selector = ab->hw_params.hw_ops->get_ring_selector(skb);
+	ring_selector = ab->hw_params.hw_ops->get_ring_selector(skb_get_queue_mapping(skb));
 
 tcl_ring_sel:
 	tcl_ring_retry = false;
diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index d679e39dce03..8a28c1d4c17b 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -876,22 +876,14 @@ static bool ath11k_hw_wcn6855_rx_desc_get_ldpc_support(struct hal_rx_desc *desc)
 			 __le32_to_cpu(desc->u.wcn6855.msdu_start.info2));
 }
 
-static u32 ath11k_hw_ipq8074_get_tcl_ring_selector(struct sk_buff *skb)
-{
-	/* Let the default ring selection be based on current processor
-	 * number, where one of the 3 tcl rings are selected based on
-	 * the smp_processor_id(). In case that ring
-	 * is full/busy, we resort to other available rings.
-	 * If all rings are full, we drop the packet.
-	 *
-	 * TODO: Add throttling logic when all rings are full
-	 */
+static u32 ath11k_hw_ipq8074_get_tcl_ring_selector(u8 ac)
+{
 	return smp_processor_id();
 }
 
-static u32 ath11k_hw_wcn6750_get_tcl_ring_selector(struct sk_buff *skb)
+static u32 ath11k_hw_wcn6750_get_tcl_ring_selector(u8 ac)
 {
-	return skb_get_queue_mapping(skb);
+	return ac;
 }
 
 const struct ath11k_hw_ops ipq8074_ops = {
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 4996536fbd14..b6bc8b72d812 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -273,7 +273,7 @@ struct ath11k_hw_ops {
 	u16 (*mpdu_info_get_peerid)(struct hal_rx_mpdu_info *mpdu_info);
 	bool (*rx_desc_mac_addr2_valid)(struct hal_rx_desc *desc);
 	u8* (*rx_desc_mpdu_start_addr2)(struct hal_rx_desc *desc);
-	u32 (*get_ring_selector)(struct sk_buff *skb);
+	u32 (*get_ring_selector)(u8 ac);
 };
 
 extern const struct ath11k_hw_ops ipq8074_ops;
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 86fb8b719613..65caa7a2349f 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -243,7 +243,7 @@ struct ath12k_hw_ops {
 	int (*mac_id_to_pdev_id)(const struct ath12k_hw_params *hw, int mac_id);
 	int (*mac_id_to_srng_id)(const struct ath12k_hw_params *hw, int mac_id);
 	int (*rxdma_ring_sel_config)(struct ath12k_base *ab);
-	u8 (*get_ring_selector)(struct sk_buff *skb);
+	u8 (*get_ring_selector)(u8 ac);
 	bool (*dp_srng_is_tx_comp_ring)(int ring_num);
 	bool (*is_frame_link_agnostic)(struct ath12k_link_vif *arvif,
 				       struct ieee80211_mgmt *mgmt);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..74359e8eea47 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -111,7 +111,7 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	 * If all rings are full, we drop the packet.
 	 * TODO: Add throttling logic when all rings are full
 	 */
-	ring_selector = dp->hw_params->hw_ops->get_ring_selector(skb);
+	ring_selector = dp->hw_params->hw_ops->get_ring_selector(skb_get_queue_mapping(skb));
 
 tcl_ring_sel:
 	tcl_ring_retry = false;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index d9fdd2fc8298..7436cf70925a 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -49,7 +49,7 @@ ath12k_wifi7_hw_mac_id_to_srng_id_qcn9274(const struct ath12k_hw_params *hw,
 	return 0;
 }
 
-static u8 ath12k_wifi7_hw_get_ring_selector_qcn9274(struct sk_buff *skb)
+static u8 ath12k_wifi7_hw_get_ring_selector_qcn9274(u8 ac)
 {
 	return smp_processor_id();
 }
@@ -83,9 +83,9 @@ ath12k_wifi7_hw_mac_id_to_srng_id_wcn7850(const struct ath12k_hw_params *hw,
 	return mac_id;
 }
 
-static u8 ath12k_wifi7_hw_get_ring_selector_wcn7850(struct sk_buff *skb)
+static u8 ath12k_wifi7_hw_get_ring_selector_wcn7850(u8 ac)
 {
-	return skb_get_queue_mapping(skb);
+	return ac;
 }
 
 static bool ath12k_wifi7_dp_srng_is_comp_ring_wcn7850(int ring_num)
-- 
2.54.0

