Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291851;
	b=rPJfXhc10ny7FJp7TkiOFvv5loT8vx5By5CrpI1mYXRlobfeJrUfcEojTdIrSVNOKiVt
	 NpnOFfgSzincJieDD2RDzbd1XvszDxB+YSCdX5FFGjUwIlv30chzvQL60Ci6AUQ1ti8Hn
	 fiaBWvJX2pSrTHF2xai86WIqp5uzCo/DeaJ5NvRqLEvAXv3R3U7PjsCbpaK6RwzTXa9Iw
	 S2wc0NGnjnMd73Tel3cOl+z/rXZPCZLxFEOPVdBQ0XNiCLygYPAmUS5pAmeQpDhaDXomI
	 Cs0pJl01qiFdn/FtMIwXY+VgYNTqI85J8OLXqBqpLsdUTHE0J4lKUjV9oB3E0jlNrEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291851;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=60oBdK7pSBMfkj8btrUeLXs/eWEM8pNj/zNxGpSWBnU=;
	b=mV9lce6Vowq4y2xNG6qcmNOQ4Iyg7fcq+cRim6aIhnDZMc90G/NeN0up1As5Z6dNop6w
	 Ct+UnaC4nXUMwUrqE44FXhAtcVPysvhaZzupBHcKa59sfYy+Amv/QwEjxQ+PbwOQ+8vVC
	 dOZZAJFWmnsNfbIKsg8XgrytjdS4nKW9+ZvSi5W4u87k2obWKOWCz4P7nOuNZTBiH766S
	 FBc9SHAE4Vzshv0xpo2KVBoFQjYFQR6bz/+J26N0iiAEX0RvTVRH7V6b+bu1mDEqvpcsk
	 EtxwR8QSapGKe96skBV7lUoPdbltEnPBziQyLOgEsfjmESeuYqonm/k0VaOGmrLGRCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q4ijLiv7;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26132606A322
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26132606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Q4ijLiv7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=60oBdK7pSBMfkj8btrUeLXs/eWEM8pNj/zNxGpSWBnU=;
	b=Q4ijLiv7QAsBiPzdy1/Tbm16tGTn3/60Kc56UTQJfSMtD7CKMPLMLx+T7UaQKqujJ4kxTb
	tv6LEo+nx79CcmfJdX1u4WkiX8jMPmBE88uih/T0OsLu4Ne8S8p/cFKpwxfWyaiT5pz5se
	aS5mtqnbYkzgYD8ZDr7caZsuBOwlXXY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-93ymQZXkP_6lq8rkYhGv0A-1; Thu,
 29 Oct 2026 12:37:26 -0400
X-MC-Unique: 93ymQZXkP_6lq8rkYhGv0A-1
X-Mimecast-MFC-AGG-ID: 93ymQZXkP_6lq8rkYhGv0A_1793291844
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B424180AEBD;
	Thu, 29 Oct 2026 16:37:24 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BAD91956088;
	Thu, 29 Oct 2026 16:37:17 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	robh@kernel.org,
	vkuznets@redhat.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 0/8] PCI/KVM/VFIO: MSI address passthrough for Qualcomm WiFi devices
Date: Thu, 29 Oct 2026 17:37:05 +0100
Message-ID: <20261029163713.1366077-1-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This series enables Qualcomm ath11k/ath12k WiFi devices to work in VM
passthrough scenarios, addressing a long-standing issue where these
devices fail to initialize when passed through to VMs via VFIO.

Qualcomm ath11k/ath12k WiFi devices have been broken in VM passthrough
since they were introduced. These devices have embedded firmware that
programs MSI target addresses directly into device BAR registers,
bypassing the standard PCI config MSI path. The driver extracts the
addr/data from the MSI descriptor and programs the firmware's private
registers. In a VM, the driver only sees the guest's virtual APIC
address instead of the host's physical IRTE address. The firmware
programs the guest address into the BAR registers, and the resulting
MSI writes hit a stale or invalid IRTE in the host's interrupt
remapping table, causing DMAR faults:

  DMAR: DRHD: ... INTR-REMAP
  DMAR: [INTR-REMAP] ... Present field in the IRTE entry is clear

Standard VFIO MSI virtualization handles PCI config space MSI
correctly (MHI interrupts work fine), but has no visibility into
firmware-managed BAR-level MSI programming.

Multiple attempts have been made to solve this over the past 2 years:

March 2024: Workaround using module parameters [1]
  - Required manually copying MSI values from host to VM
  - Rejected by Johannes Berg as too manual, suggested VMM solution

August 2024: QEMU + kernel solution by Alex Williamson [2]
  - Kernel disables MSI virtualization, QEMU intercepts config writes
  - Uses brute force pattern matching to infer MSI data writes
  - Stuck as RFC - no progress in 14+ months

No action from Qualcomm: Despite multiple reports [4], no vendor
solution.

The PCI reset support for these devices has already landed in mainline
(commit f8522a518e59 "PCI: Add device-specific reset for Qualcomm
WCN6855/WCN7850 WLAN") [3], solving the device reset path for VFIO
passthrough. This MSI series is the remaining piece, with both in
place, these Qualcomm WiFi devices would be fully operational in VMs
for the first time.

v1/v2 explored passing the host MSI address through VFIO extended
config space. Jason Gunthorpe pointed out [5] that a guest-initiated
approach via KVM paravirtualization would be cleaner, avoid VFIO
internal coupling, and generalize better to other devices with
similar firmware behavior. The proposal here is a new guest module
that tries to address this by creating a custom MSI domain that
provides the physical host values instead.

v3 implements this as a 3-piece kernel-only solution:

  1. Host side (KVM + VFIO): A new KVM hypercall
     (KVM_HC_PCI_MSI_ALLOC) dispatches to a VFIO handler that reads
     the host's physical MSI address/data for the passthrough device.
     Connected via function pointer in struct kvm to avoid hard
     subsystem dependencies.

  2. Guest side (PCI controller): A new MSI IRQ domain module
     (pci-kvm-msi, taking pci-hyperv.c as a reference as Jason
     suggested) that intercepts MSI composition for matched devices.
     In order to sync host initialization with the guest driver, it
     provides kvm_pci_msi_wait_ready() to poll the hypercall until the
     host MSI is configured, and kvm_pci_msi_get_address() to read
     cached values.

  3. Driver changes (ath11k, ath12k): Guarded with
     IS_ENABLED(CONFIG_PCI_KVM_MSI_DOMAIN). Call wait_ready after
     msi_enable in power_up, then use get_address where needed.
     Zero overhead on baremetal (kvm_para_available() returns false).

The solution requires no QEMU changes. Tested with WCN6855 (ath11k),
WCN7850 (ath12k), and QCN9274 (ath12k) on host with KVM/VFIO
passthrough, all three create fully working WiFi interfaces in
the guest VM.

Patches:
  1-3: Core infrastructure (VFIO helpers, KVM handler, guest module)
  4-5: ath11k support (link retry + KVM MSI integration)
  6-7: ath12k support (link retry + KVM MSI integration)
    8: QCN9274 device support (reset quirks + KVM MSI ID)

[1] https://lore.kernel.org/all/20240322104912.94811-1-jtornosm@redhat.com/
[2] https://lore.kernel.org/kvm/20240812170014.1583783-1-alex.williamson@redhat.com/
[3] https://lore.kernel.org/all/20261005105436.83962-1-jtornosm@redhat.com/
[4] https://lore.kernel.org/all/fc6bd06f-d52b-4dee-ab1b-4bb845cc0b95@quicinc.com/
[5] https://lore.kernel.org/all/20261014150047.GO14213@ziepe.ca/

---
v3: KVM paravirtualization approach based on Jason Gunthorpe feedback.
    New hypercall + guest MSI domain module replaces VFIO variant
    driver.
    Added QCN9274 support.
v2: https://lore.kernel.org/all/20261014142606.418972-1-jtornosm@redhat.com/
v1: https://lore.kernel.org/all/20260930140833.576941-1-jtornosm@redhat.com/

Jose Ignacio Tornos Martinez (8):
  vfio: add helper to find PCI device by vendor/device ID
  KVM: add PCI MSI hypercall for VFIO passthrough
  PCI: add KVM MSI domain guest module
  ath11k: add PCIe link recovery retry
  ath11k: use KVM MSI domain for VM passthrough
  ath12k: add PCIe link recovery retry
  ath12k: use KVM MSI domain for VM passthrough
  PCI: add QCN9274 to reset quirks and KVM MSI domain

