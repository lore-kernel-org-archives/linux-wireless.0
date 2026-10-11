Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A4827A92D
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704738; cv=none; b=T303BviIKAHr+cg0wILUF9IULiF3J3ryyg36OTLHGjsIRWJP/Bt2QgHqc+uYC7Y0PelMVSz+DWjI83w+VbF5xTikB24yUsziS8vJImMZEqq0OIcALumQpVnta4mUT593ATBtKG/UDpnF/QfeOWK5KSrLcfn/MKrfWcP6DGIFeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704738; c=relaxed/simple;
	bh=/hVrdXqoto1Ie+iFBeChY+lGD498CVDyx6LdUROrbNA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QK6nYOdc8ZQcse6CANtBifs+HK+Kzd/5ADg+NYJ8cTkPgHNpiwHJ+kZU2Qnevy7WSO3i/3LTtB2FuJTjb3fjNxaVgRzan9EV8Ff+DWsMgic34t4S19t2EM+AnooN/Adnx+Usj8KUsTDSbS0k72eXL0MDzqTIydAsHTadt5f47e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JCylOxlr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JCylOxlr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791704736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SDmCcuBy6PXbhLYIXrgXx2iBVfVCPr/Ovdrgh7KTbnw=;
	b=JCylOxlr9DyvNLDhC6LMWytk9ZMn1Ym7Dy7NySZoYTCvxEu00U4dtjyyVkZXRXOVB0R+wf
	TBfYCQ5WVGP9RowTe0Gpm9l1ipQ9LAwwNXCDbvZASgRfgTfRaJekAPfX3axcT4bw8Up0hR
	f9JIMhudEq+1pnKEg3DN5/cq9jJMemg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-owIeNwFMNXmEhA74ktZlIA-1; Sun,
 11 Oct 2026 07:45:30 +0000
X-MC-Unique: owIeNwFMNXmEhA74ktZlIA-1
X-Mimecast-MFC-AGG-ID: owIeNwFMNXmEhA74ktZlIA_1791704728
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 175E218011EA;
	Sun, 11 Oct 2026 07:45:27 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9A48F1956041;
	Sun, 11 Oct 2026 07:45:21 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
Date: Sun, 11 Oct 2026 09:45:07 +0200
Message-ID: <20261011074514.515894-1-jtornosm@redhat.com>
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
since they were introduced. The Qualcomm firmware has its own interrupt
controller with private registers that need to be programmed with MSI
addr/data. The driver extracts the addr/data from the MSI descriptor
and programs the firmware's private registers. In a VM, the driver
only sees virtual (IOVA) addr/data, but the firmware's private writes
bypass the IOMMU, so they need the physical host values. This causes
firmware initialization to fail with errors like "BHI offset:
0xffffffff is out of range".

Multiple attempts have been made to solve this over the past 2 years:

March 2024: Workaround using module parameters [1]
  - Required manually copying MSI values from host to VM
  - Rejected by Johannes Berg as too manual, suggested VMM solution

August 2024: QEMU + kernel solution by Alex Williamson [2]
  - Kernel disables MSI virtualization, QEMU intercepts config writes
  - Uses brute force pattern matching to infer MSI data writes
  - Stuck as RFC - no progress in 8+ months

No action from Qualcomm: Despite multiple reports, no vendor solution

The solution in this series provides a clean, kernel-only approach that
addresses the previous concerns. The PCI reset support for these devices
has already landed in linux-next (commit f8522a518e59 "PCI: Add device-
specific reset for Qualcomm WCN6855/WCN7850 WLAN") [3], solving the device
reset path for VFIO passthrough. This MSI series is the remaining
piece, with both in place, these Qualcomm WiFi devices would be fully
operational in VMs for the first time.

In practice, this specific behavior (firmware requiring physical host
MSI addresses in private registers, bypassing the IOMMU) has only
been observed in Qualcomm ath11k/ath12k devices. A device-specific
approach seems appropriate, and the VFIO variant driver pattern fits
well for this, following the same established pattern as mlx5-vfio-pci
and nvgrace-gpu for their own device-specific needs.

Architecture:
1. qcom-vfio-pci variant driver caches physical host MSI values and
   exposes them via extended config space with magic signature "QMSI".
   Device-specific hardware quirks belong only in kernel drivers, not
   userspace, independent of the tools used.
2. VM drivers (ath11k/ath12k) automatically discover and use cached values
3. PCIe link recovery handles VM timing variations

Thoroughly tested: 3 VMs across 2 WiFi generations, all devices
successfully initialized and are ready for use.
- VM1: ath11k (WCN6855)
- VM2: ath11k (WCN6855)
- VM3: ath12k (WCN7850)

Series structure:
  Patch 1/7: PCI helper to find free space in extended config space
    for device-specific data exchange between host and VM drivers
  Patch 2/7: Shared header defining the MSI cache protocol between
    the host variant driver and VM drivers
  Patch 3/7: qcom-vfio-pci variant driver that caches host physical
    MSI address/data and exposes them to VMs through extended config
    space
  Patch 4/7: ath11k PCIe link recovery retry to handle initialization
    timing variations in VM environments
  Patch 5/7: ath11k support to read cached host MSI values and
    configure firmware with correct physical addresses, making the
    device operational in VMs
  Patch 6/7: ath12k PCIe link recovery retry to handle initialization
    timing variations in VM environments
  Patch 7/7: ath12k support to read cached host MSI values and
    configure firmware with correct physical addresses, making the
    device operational in VMs

[1] https://lore.kernel.org/all/20240322104912.94811-1-jtornosm@redhat.com/
[2] https://lore.kernel.org/kvm/20240812170014.1583783-1-alex.williamson@redhat.com/
[3] https://lore.kernel.org/all/20261005105436.83962-1-jtornosm@redhat.com/
[4] Original problem report:
    https://lore.kernel.org/all/fc6bd06f-d52b-4dee-ab1b-4bb845cc0b95@quicinc.com/

---
v2: Complete cover letter with more information
    Address Sashiko comments
v1: https://lore.kernel.org/all/20260930140833.576941-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (7):
  PCI: Add pci_find_free_ext_cap_offset() helper
  vfio: Add qcom_vfio.h header for MSI cache protocol
  vfio/pci: Add qcom-vfio-pci variant driver
  ath11k: Add PCIe link recovery retry for VMs
  ath11k: Use VFIO MSI cache when available
  ath12k: Add PCIe link recovery retry for VMs
  ath12k: Use VFIO MSI cache when available

