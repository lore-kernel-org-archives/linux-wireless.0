Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A238F945
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100348; cv=none; b=lcTA/mAPosAhkzOuQ6rB8Ebcjfu4hS3yYZ3K01XjnhietYMwUeKKOZ9SbF2AWFlTyLFKagn1qY4zVIRahWA+lFmFgcR7H/JXAjahUG7usxWQlW7odxXN3Xg9Z88vdC7m4WqrMd6ZTxuelUJfr6GRZvBttcdq1sIoB4zxaiWrFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100348; c=relaxed/simple;
	bh=FOvceTNUL6AaStWmLlioNjhloiFT5sWMWyHR5dK0iXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=letWyqmYVZIdCva4uCvkOe0Iudp14msPPdip+skJ/Iq8ZuESMtpbl1ORS6oz+WaFR3GD1/rIQS9nQ7WKCiP9CFm8D90SF/aRJkpm5XrkRt/iE1uOyRi+hnKBvBRXcNs8QTE1z32tfDdbkOSeBJmRQiOSqgsLs26seytaUFvkGzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CoBSzlSm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoBSzlSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786100344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2uks6hn8TsE/jS0Ca5ryK/ZPaWu5PXeRNJN2WD99sMs=;
	b=CoBSzlSm60Gd48yhqEji/kQJSUgwq4t1+YNMQ73Xxx5owdQkYK7HsHt6AvUjk2iFzcMLg+
	eEpfnC8PEw/djmoKdLXGaICf2Vw+P5MCeUiSU6IGQLHHInqqjbrbiQci+PZVrN2mSuNR51
	Y38SK9W2hYcVOzogFrCakaHbcJhwafE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-380-J2S9uKdlOKGXCG6x2-Iq5g-1; Fri,
 07 Aug 2026 06:58:59 -0400
X-MC-Unique: J2S9uKdlOKGXCG6x2-Iq5g-1
X-Mimecast-MFC-AGG-ID: J2S9uKdlOKGXCG6x2-Iq5g_1786100338
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C64961956080;
	Fri,  7 Aug 2026 10:58:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.52])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96E32180049F;
	Fri,  7 Aug 2026 10:58:55 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v5 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
Date: Fri,  7 Aug 2026 12:58:40 +0200
Message-ID: <20260807105843.20203-2-jtornosm@redhat.com>
In-Reply-To: <20260807105843.20203-1-jtornosm@redhat.com>
References: <20260807105843.20203-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
v5: no modification
v4: https://lore.kernel.org/all/20260724053121.15759-2-jtornosm@redhat.com/

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

