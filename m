Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF399379C38
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 05:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871099; cv=none; b=g/+PogxLhjD//Y5DPauOSy3Kpc756QIWA0o1xdyGCZvKKRKHTxleu/9d7coOyycRiSK50XDQZQyzd7gfwMZDy0hdNUYFHBnTaVRX3PY49d/P96MOhITUm7Sgzqhcv4+CO4tI5keUwqkgSvORBuBoCYD8Px2SrQcwaeGeMA2dut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871099; c=relaxed/simple;
	bh=+ndOBclp9ELZhImSqCymXWEAvbQp54nGPZUanO9rufs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HibRZDixrSGEnKqmuUz0i9DE2BwF1B9yXLcLG9JLgbAf/SIRxwx7RsQlYjgS42JyDNhS+U61h3QVMW2VGl3i1JbYN98jsS9BhZ2COa5Hy/287IBKR0YNrunF6XXPE4zPjIj3XHL/eKaKcyTevGhpRmxz38y4dISJBGpGPQpLlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OiBxPRWE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OiBxPRWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784871096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P2dO43unXcYxFDlErvgykZBd8dhtT9NMkVEfA2VJujU=;
	b=OiBxPRWEWuk49/PmWPFwwCHoPlYeMmhvGJ4ukkKrB1A+h24a2GUYPNBuWKQYky0/t/TTo4
	MWbcbO6kumFkoCpZOqiznoEeg23r75HIME1qm3ife6TwEOfF6grjcJL/o3NMW43Jgxilhm
	1G6Yi6eOoh0WpuFQZFaIYi4M+8Az4q4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-kOXbVBLsM3iJcoilC06AlA-1; Fri,
 24 Jul 2026 01:31:31 -0400
X-MC-Unique: kOXbVBLsM3iJcoilC06AlA-1
X-Mimecast-MFC-AGG-ID: kOXbVBLsM3iJcoilC06AlA_1784871090
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14EFA1944D21;
	Fri, 24 Jul 2026 05:31:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.50])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7994C30002CE;
	Fri, 24 Jul 2026 05:31:26 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v4 0/4] ath11k/ath12k: implement TX flow control
Date: Fri, 24 Jul 2026 07:31:17 +0200
Message-ID: <20260724053121.15759-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This series implements custom wake_tx_queue operations for ath11k and
ath12k drivers to prevent hardware ring overflow issues under heavy
traffic.

Without proper flow control, both drivers experience -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
Additionally, ath12k can hang under sustained high throughput. These
issues are more commonly observed in VMs with PCIe passthrough but
also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
adapted for ath11k/ath12k hardware ring architecture, checking
hardware ring space before dequeuing packets from mac80211.

Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
and improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (4):
  wifi: ath11k: use queue mapping for WCN6750 ring selection
  wifi: ath11k/ath12k: remove skb parameter from get_ring_selector
  wifi: ath11k: implement custom wake_tx_queue with flow control
  wifi: ath12k: implement custom wake_tx_queue with flow control

v4: Address feedback from Johannes Berg:
  - Drop the ieee80211_tx_peek() mac80211 patch entirely due to the
    commented concerns.
  - Redesign as a consequence of dropping the peek API:
    - Patch 1: switch WCN6750 from skb_get_hash() to skb_get_queue_mapping()
      as a preparatory step, since the AC value is all that is needed.
      This aligns with the approach already used by ath12k WCN7850
      (which has the same ring count).
    - Patch 2: Instead of peeking the skb to call get_ring_selector(skb),
      pass txq->ac directly via get_ring_selector(u8 ac). This is safe
      because mac80211 guarantees skb_get_queue_mapping(skb) == txq->ac for
      any skb dequeued from a given txq.
    - Patch 3 and 4: adapt tx flow control to the new approach.
v3: https://lore.kernel.org/all/20260720070852.206495-1-jtornosm@redhat.com/
--
2.49.0

