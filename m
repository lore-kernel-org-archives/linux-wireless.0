Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D18313293
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777481; cv=none; b=YtM1cJ6Q22T9XHfE1N15gX9rBarToE+Qf8eqqAuLKJ0XKZdHRkWzM58wKzZ2xeiabpboEtXzg/Fn1/TTCCGokprfnEq3K1C6xU86TChe5yB41hRJJU5eyPvXIoUOXAy6kOlEyUPIztFV56zvaCMBOfK1OhjizVCLs7zMG7ACYHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777481; c=relaxed/simple;
	bh=u/sYFJ0IFoVAn4mTeL9RLHFvHzVSFq6mlMEPEuqFX/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MnJEKHQUCXSHj6N3sLSoHatSiuUt1Ecf17tJfC2EXP90CRFkKopAFNFhjZGLdnF7Bd9rTOYxaf3rFbvjyZBwbQGQkYmbi4qoDNycD92cc+6X35+On8FR88D9OPs0kVhzoIb4csDelDzCNqoFGSNaMgog2dNpMQjVtdS5yF+XWeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aFppREF5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aFppREF5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790777456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kog7asmMh6wog1adNQUGIn243OW/BEgANRMVLg38o7k=;
	b=aFppREF54KingHqSYMXXK8CqSuRg3vGmH8wVsDgVbIz1h/i4v/xZpcylOCBxMH2PdnDLZe
	UYu6g4CRlHYcZuPCD14f3S4V/Gtsq0gPdEshxkxXNbI5kZE6Q7Wx6lQVo3/SvRO62niZ8Z
	H2gmWyydK5HnudFD/e8p1k3ctflteGE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-DJl6E92WOv2gFGzQ13y3SA-1; Wed,
 30 Sep 2026 10:10:53 -0400
X-MC-Unique: DJl6E92WOv2gFGzQ13y3SA-1
X-Mimecast-MFC-AGG-ID: DJl6E92WOv2gFGzQ13y3SA_1790777451
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF668197700A;
	Wed, 30 Sep 2026 14:10:50 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18C2C1956044;
	Wed, 30 Sep 2026 14:10:46 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	jgg@ziepe.ca,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
Date: Wed, 30 Sep 2026 16:10:45 +0200
Message-ID: <20260930141045.577212-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This series enables Qualcomm ath11k/ath12k WiFi devices to work in VM
passthrough scenarios, addressing a long-standing issue where these
devices fail to initialize when passed through to VMs via VFIO.

Qualcomm ath11k/ath12k WiFi devices have been broken in VM passthrough
since they were introduced. The devices use an embedded interrupt
controller that requires physical host MSI addresses programmed to
device registers, but in VMs the driver only sees virtualized guest
addresses. This causes firmware initialization to fail with errors like
"BHI offset: 0xffffffff is out of range".

Multiple attempts have been made to solve this over the past 2 years:

March 2024: Workaround using module parameters [1]
  - Required manually copying MSI values from host to VM
  - Rejected by Johannes Berg as too manual, suggested VMM solution

August 2024: QEMU + kernel solution by Alex Williamson [2]
  - Kernel disables MSI virtualization, QEMU intercepts config writes
  - Uses brute force pattern matching to infer MSI data writes
  - Stuck as RFC - no progress in 8+ months

No action from Qualcomm: Despite multiple reports, no vendor solution

The solution in this series provides a clean, kernel-only solution that
addresses the previous concerns.

Architecture:
1. qcom-vfio-pci variant driver caches physical host MSI values and
   exposes them via extended config space with magic signature "QMSI"
   In this way, device-specific hardware quirks belong only in kernel
   drivers, not userspace, independent of the tools used.
   This follows the established VFIO variant driver pattern used by
   other drivers like mlx5-vfio-pci (netdev tree) and nvgrace-gpu (platform
   tree).
2. VM drivers (ath11k/ath12k) automatically discover and use cached values
3. PCIe link recovery handles VM timing variations

Thoroughly tested: 3 VMs across 2 WiFi generations, all devices successfully
initialized and are ready for use.
- VM1: ath11k (WCN6855)
- VM2: ath11k (WCN6855)
- VM3: ath12k (WCN7850)

[1] https://lore.kernel.org/all/20240322104912.94811-1-jtornosm@redhat.com/
[2] https://lore.kernel.org/kvm/20240812170014.1583783-1-alex.williamson@redhat.com/
[3] Original problem report:
    https://lore.kernel.org/all/fc6bd06f-d52b-4dee-ab1b-4bb845cc0b95@quicinc.com/

Jose Ignacio Tornos Martinez (7):
  PCI: Add pci_find_free_ext_cap_offset() helper
  vfio: Add qcom_vfio.h header for MSI cache protocol
  vfio/pci: Add qcom-vfio-pci variant driver
  ath11k: Add PCIe link recovery retry for VMs
  ath11k: Use VFIO MSI cache when available
  ath12k: Add PCIe link recovery retry for VMs
  ath12k: Use VFIO MSI cache when available
--
2.53.0

