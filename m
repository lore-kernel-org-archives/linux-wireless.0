Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D4431A56
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 10:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100350; cv=none; b=fkrfWDfZnXUdu37jDbsGec9f9tYltF6sqDAFIw2Sg6ypeXj9m9UhhQpIvkHg643BoWP1dKP5NBlRqBkQCDRjP00uxfQq1KDnoo+poZnHbwyptYALzkYuyKnxz2j2W7KKHRhaHnMm24VuCfsw824NILe6P70sokzDDVpvmIS5Cr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100350; c=relaxed/simple;
	bh=O8EJ16TW7GvHuGD2EInYTfisk92cLsEWq0mZMWzxNNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eYpIAG1pG5WdHLTVsLo7myh8/AU1V4nxgKXnndmK1L76qrbHn6mu4lupt1DL2w5fj21o+5qY2k+b/QHy7z7ny/alNDPMzamj3VAqxGSZIBEFWFCE778Dgv3GJ/HLF5lY1ikAOX+dvjwPVmwhPe46dRjD8qtfiNQJqdGdrB4Pu2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lrx7gB5Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lrx7gB5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786100347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lbe9xYGQF7MxxngD6GwpHij7lEf9Aywcs+3bJ2Be0Uc=;
	b=Lrx7gB5Yr5wsqY7GPRprzlpQkoa4K9NbZzRfzwsqp2EtMc4hwLMMXRgqdyOJdXry5PKWIW
	+kCPcD0X0E8vcVrlAjx/8xO9pBgeZ/HdSljkzHw0Zz7Be7zYyEzCSmQVMVA3/EvsdVXwS+
	OjIM5OGKZGSnVNldx/ZuqkiZORd6UO0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-nR0bDJalPhmZFZ05DUiFaw-1; Fri,
 07 Aug 2026 06:58:54 -0400
X-MC-Unique: nR0bDJalPhmZFZ05DUiFaw-1
X-Mimecast-MFC-AGG-ID: nR0bDJalPhmZFZ05DUiFaw_1786100333
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A95F19560AD;
	Fri,  7 Aug 2026 10:58:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.52])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE349180049F;
	Fri,  7 Aug 2026 10:58:48 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v5 0/4] ath11k/ath12k: implement TX flow control
Date: Fri,  7 Aug 2026 12:58:39 +0200
Message-ID: <20260807105843.20203-1-jtornosm@redhat.com>
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

v5: No modification in patches 1,2 and 3
    Remove an unused variable in patch 4
v4: https://lore.kernel.org/all/20260724053121.15759-1-jtornosm@redhat.com/
--
2.49.0

