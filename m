Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F934457DF
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789627727; cv=none; b=daxQeNgWm+tUvCWuHji8FN12kNbcxelGjjQXUqwGzIw43zglTb5lebReu4gXeJX7p/erL8p6Klu4oo9DR7Vm6yy9Ozi24QwmHZR/ZpHd1jCGZF/cfeIm1PISYgPU14oFyLtvWbdXM5HNAKWT8drArF+XdZUf2uo5m+FPx3/DJZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789627727; c=relaxed/simple;
	bh=Vaksf6mVkDt6qpn4MgBSFQTD9uTAPkA0fjL78cwCe78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvDbWWR/oeXRAy1SN4gAKTR6ut+7AJyadRKIddvFD6ZWUOcKhS+ljCuag9pdm1qVwRyZOOh0Ryb+WaTtM8NuB9UlRePLd5PVJkbrqOrYGnrehBUqrKJ9ToQh/Bev60kdBA0X01HeJE5HBkQdmvG2fjZ1AfuuF6GnlddLZzGYrKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OVTV6C1I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVTV6C1I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789627724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x33XW/wjXt6WHIS6oNPy0fJBTUtYpgjF1Fs3XuRG47o=;
	b=OVTV6C1IXegNp8UulnN29yFoM5tEi+VbUDdNeKw+JRi/Czrytb/bcTCSkGvm2vkQUhRXDW
	jdN/8412ukLwHCPd/MjtSPTKM15IFLdf9VPCC4URn5AhJ383EZ8+eT31O2/HxX0GW6yJtU
	P3mnMQuYhGnSTSyqkd3iCZvZmQwHCEk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-zgYYo98xPMa2CbqBBl4t5w-1; Thu,
 17 Sep 2026 02:48:41 -0400
X-MC-Unique: zgYYo98xPMa2CbqBBl4t5w-1
X-Mimecast-MFC-AGG-ID: zgYYo98xPMa2CbqBBl4t5w_1789627719
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9583195F140;
	Thu, 17 Sep 2026 06:48:36 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D02F33003EED;
	Thu, 17 Sep 2026 06:48:34 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v7 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
Date: Thu, 17 Sep 2026 08:48:22 +0200
Message-ID: <20260917064825.12747-2-jtornosm@redhat.com>
In-Reply-To: <20260917064825.12747-1-jtornosm@redhat.com>
References: <20260917064825.12747-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

WCN6750 selects the TCL ring using skb_get_hash() to distribute
flows across its 3 TX rings, as introduced in commit 7636c9a6e7d7
("wifi: ath11k: Add multi TX ring support for WCN6750"). The goal
was to prevent out-of-order packet delivery that could occur with
smp_processor_id()-based selection, where packets of the same flow
could end up on different rings depending on CPU scheduling.

Switch to skb_get_queue_mapping() instead, which returns the AC
(access category) assigned by mac80211 in ieee80211_select_queue().
This provides the same ordering guarantee: packets of the same TID
always map to the same AC and therefore always land on the same
ring, preventing reordering.

Using queue mapping for ring selection also provides QoS-aware
distribution, where each traffic class gets a deterministic ring
assignment, rather than the random distribution that flow hashing
produces. With 3 rings and 4 ACs (VO=0, VI=1, BE=2, BK=3), the
mapping becomes: VO and BK share ring 0, VI uses ring 1, and BE
uses ring 2.

This matches the approach already used by ath12k for WCN7850, which
has the same ring count and uses skb_get_queue_mapping() for its
ring selector.

This change also removes the dependency on skb_get_hash(), which
is relevant for a subsequent patch that removes the skb parameter
from the get_ring_selector hw_ops callback entirely, enabling
TX flow control in wake_tx_queue without requiring a complex peek
to inspect frames before dequeue.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v7: no modification
v6: https://lore.kernel.org/all/20260811172435.616200-2-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath11k/hw.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 93f9a03c48dc..d679e39dce03 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -891,13 +891,7 @@ static u32 ath11k_hw_ipq8074_get_tcl_ring_selector(struct sk_buff *skb)
 
 static u32 ath11k_hw_wcn6750_get_tcl_ring_selector(struct sk_buff *skb)
 {
-	/* Select the TCL ring based on the flow hash of the SKB instead
-	 * of CPU ID. Since applications pumping the traffic can be scheduled
-	 * on multiple CPUs, there is a chance that packets of the same flow
-	 * could end on different TCL rings, this could sometimes results in
-	 * an out of order arrival of the packets at the receiver.
-	 */
-	return skb_get_hash(skb);
+	return skb_get_queue_mapping(skb);
 }
 
 const struct ath11k_hw_ops ipq8074_ops = {
-- 
2.54.0

