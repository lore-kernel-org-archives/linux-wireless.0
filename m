Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1665F449B3E
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469099; cv=none; b=O0jFa2esOpxFhuABa+AiAB/rceLxej0hSNZdn+r6ACgWY5oPdfFQupXWElI9V5yoWFerw8X3zi5E+HnOX4h7ie0epZsqQhw56pezCSpnlFom818wi4FF2LAbL2b9jY+Q/aLvFfaxPBbQZtnrXmYRbkhCwF4kz16V5eyiICsLwkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469099; c=relaxed/simple;
	bh=indGZsctG0J7JENpI6bJLCCYCiFcLs/3cVSbDKdaH70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VrXBH8qnhy+lyT+m4+Kry1G24PQjpqfbuKZ3ancvWJ4XolYaFUYjhI8jC9fuN+Qsr1LRNpA74N383MOJ44pWPf+aqFUHuS3ksvFsMhqAUUIFt0hG6o+IGjmkcb9Chc33NgCWqmbu/WFtoNicROj9C6W0Xi+I1Yv44DKHhC3RhNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsJkK1lz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsJkK1lz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786469096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IPlqeWxM+x2WItnybXha9BD+uNfcp/QU8sKnK1YwN7s=;
	b=LsJkK1lzL0P5j8eBV/gDUeAirhX5Ooh/WgvdQMn4icmwkJkcaVVGx0heTJQyIgxn0Aqs4U
	OH/WIJMbDT70pdrxgE0x93zzz985vyeVTG3GfrR1cbyy/Z+W8t7zoZJ2FqM367r0lmoEke
	V7PHpw+xLgM67Sf5GSWroR15bL2FUMA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-489-q5Id0HgKPE2W7U1wNrFPkQ-1; Tue,
 11 Aug 2026 13:24:45 -0400
X-MC-Unique: q5Id0HgKPE2W7U1wNrFPkQ-1
X-Mimecast-MFC-AGG-ID: q5Id0HgKPE2W7U1wNrFPkQ_1786469084
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98E4B1800846;
	Tue, 11 Aug 2026 17:24:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65638180049F;
	Tue, 11 Aug 2026 17:24:40 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v6 0/4] ath11k/ath12k: implement TX flow control
Date: Tue, 11 Aug 2026 19:24:31 +0200
Message-ID: <20260811172435.616200-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

Note: I will have limited availability from mid-August to
mid-September. I will address any review feedback before then
or promptly after returning.

Jose Ignacio Tornos Martinez (4):
  wifi: ath11k: use queue mapping for WCN6750 ring selection
  wifi: ath11k/ath12k: remove skb parameter from get_ring_selector
  wifi: ath11k: implement custom wake_tx_queue with flow control
  wifi: ath12k: implement custom wake_tx_queue with flow control

v6: No modification in patches 1 and 2
    Address comments from Jeff Johnson:
      Patch 3: Remove unnecessary if (!ar) check, add Tested-on tag
      Patch 4: Use EXPORT_SYMBOL instead of EXPORT_SYMBOL_GPL,
               use guard(spinlock_bh), add Tested-on tag
v5: https://lore.kernel.org/all/20260807105843.20203-1-jtornosm@redhat.com/
--
2.49.0

