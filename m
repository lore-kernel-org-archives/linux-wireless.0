Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE43B6C01
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 07:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531353; cv=none; b=DoX8VPrsayvtjXfCIESflmhdo3lhha+kCNAJzo8qyh5VY9dv82oyNtkueMc5WSt8oNUqbiNj0JN5OVgbfpGcyvuHSIe4LPhiuWMe9PKD4TB7DFkvOTME88t9KAyX5iU0eGKfRPKh07YSrxo1TDfGIA7/MF5aqB7LzT0A2pACwWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531353; c=relaxed/simple;
	bh=0P6HOL5CqN9dUhhCk8SS3XK3iQzHK0s0I9z1bZQFWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YupN0HlhUhXOBlr3ZSSWvNSsmW/m4Fy9a1rE9T2+nNYwba5sk1/JD9bJjplFwtOxgJ4DZvbmwalGhDgKUukNezyDvgwKZ5jzyTQnOBm0V+X6LfCv3TuHzyzomcMcpOimHFSUbFLY8rnLF0w2MudJWFUNHkoz/hJUjPFvZ4KNvNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLqyjOj5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLqyjOj5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784531351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5ReTejzYKlz1Q/pR6RCyJpzicTdfuHHRGKFgTayNqu8=;
	b=HLqyjOj5mCubrEtnB1oSmvnn/9LjShCPtCbQPJVsbmcBNbhJdpbyWMgJb0HZK+1vZmUTkd
	eq/FGVCNjGHidrhQ345dhA2wCKl5PaPtT7oDbkusc05Mx1tltjrzB+xR9tmEgynJLt43HC
	AEBNocHd+wKerRERoaeaGgmxiTkeHUA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-lT1wsJElPq2vrKSro8jZaQ-1; Mon,
 20 Jul 2026 03:09:05 -0400
X-MC-Unique: lT1wsJElPq2vrKSro8jZaQ-1
X-Mimecast-MFC-AGG-ID: lT1wsJElPq2vrKSro8jZaQ_1784531344
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6113E1944B3C;
	Mon, 20 Jul 2026 07:09:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.69])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90F2F18005AE;
	Mon, 20 Jul 2026 07:09:01 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 0/3] wifi: ath11k/ath12k: implement TX flow control
Date: Mon, 20 Jul 2026 09:08:48 +0200
Message-ID: <20260720070852.206495-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This series implements custom wake_tx_queue operations for ath11k and
ath12k drivers to prevent hardware ring overflow issues under heavy
traffic.

Without proper flow control, both drivers experience -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
Additionally, ath12k can hang under sustained high throughput. These
issues are more commonly observed in VMs with PCIe passthrough but
also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
checking hardware ring space before dequeuing packets from mac80211.
Per-txq locking via txq->drv_priv serializes peek and dequeue
operations for the same txq, preventing use-after-free races while
keeping different txqs fully parallel.

Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
and improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (3):
  mac80211: add ieee80211_tx_peek API
  wifi: ath11k: implement custom wake_tx_queue with flow control
  wifi: ath12k: implement custom wake_tx_queue with flow control

v3: Address the review comments from Tamizh Raja:
    - ath11k/ath12k: replace per-ring wake_tx_lock with per-txq spinlock via
      txq->drv_priv to fix race condition between ieee80211_tx_peek() and
      ieee80211_tx_dequeue() when multiple CPUs process the same txq
    - ath12k: fix MLO link selection in wake_tx_queue to use
      rcu_dereference(ahvif->link[link_id]) instead of deflink, matching
      the link selection logic in op_tx
v2: https://lore.kernel.org/all/20260715125017.277242-1-jtornosm@redhat.com/

--
2.49.0

