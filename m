Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F7A489FB3
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790839211; cv=none; b=rTdQ1DTFZnfp/Y9BUxYKZ2VHcnAh1iq+Y7gDIDIqJHjGMB/evTnx22tA0DwbU0E8smYUTJC2cZI4yk1cbmOXvsSBcL9cKo9q5aveTBiRIUUJ4gwwT0Wid9M1hP/BBcS9WdsYPEVPxcfy6RyQY5cmdsgF/ai0dt8TAP1HEeF8I7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790839211; c=relaxed/simple;
	bh=v9FOpcXK4LkHcbJyyNWDWuCMQhtIwmwjXV3fOKhmq0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7o4poogM4eMckDqwFVsWB5YD2esbanGPz7lQ2ei1pQ7Vtue/hQ3CpiXptciqpZmePacFdN2XoZuzH/0M/vY20uKZJuXFQLClXrKI5A1p/EyRIAj0HZQCFLpOO2r3dvqrYyB+H9qSCmkVXZdfqyw9fcd3yJK1ooG1Q/xTR5EYBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hapbG2Y2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hapbG2Y2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790839199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Bmie9JTdC7GvOREgQKIaVbNDMTF41K5ZHDK/CLSZFA=;
	b=hapbG2Y2Q7VQbIk4kwLl9G7tsxcPe2rw6SZAlqkp+RuzKZbPewLJ8AyI7R6F1+MgvLjAIJ
	h1DI7AOer/53P1eQjwBvPMKXR5vrO9z/jMWq2ZMyZvk+l9o8mdCTs0zI761p5MZ10Menry
	xcGXGfLANExdkaEpFH9pyPBUEXdYpDY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-3KcQEm1XMWOnIp_ceFAq8Q-1; Thu,
 01 Oct 2026 03:19:55 -0400
X-MC-Unique: 3KcQEm1XMWOnIp_ceFAq8Q-1
X-Mimecast-MFC-AGG-ID: 3KcQEm1XMWOnIp_ceFAq8Q_1790839193
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 502561953977;
	Thu,  1 Oct 2026 07:19:52 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 59D061956089;
	Thu,  1 Oct 2026 07:19:47 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	johannes@sipsolutions.net,
	jtornosm@redhat.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	skolothumtho@nvidia.com,
	yishaih@nvidia.com
Subject: Re: [PATCH 3/7] vfio/pci: Add qcom-vfio-pci variant driver
Date: Thu,  1 Oct 2026 09:19:45 +0200
Message-ID: <20261001071945.83116-1-jtornosm@redhat.com>
In-Reply-To: <20260930151229.GR163130@ziepe.ca>
References: <20260930151229.GR163130@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Jason,

Thank you for the review.

You're right that the commit message should better explain the current
driver behavior. The flow today is:

1. Linux allocates MSI-X vectors (standard PCI MSI-X table)
2. The Qualcomm firmware has its own interrupt controller with
   private registers that need to be programmed with MSI addr/data
3. The ath11k/ath12k driver extracts the addr/data from the MSI
   descriptor and programs the firmware's private registers
4. In a VM, the driver only sees virtual (IOVA) addr/data, but
   the firmware's private writes bypass the IOMMU, so they need
   the physical host values

I'll improve the commit message.

Regarding platform_device_msi_init_and_alloc_irqs(), I agree that
moving the driver to device MSI domains would be cleaner on the
driver side. However, even with that change, I think the VM problem
remains exactly the same: the device MSI domain in the VM would
allocate virtual addr/data pairs, and the firmware's private interrupt
controller still needs the physical host values. The problem is not
how the driver allocates MSI vectors, but that the firmware writes
to its own registers bypassing the IOMMU.

Also, the VFIO variant driver scheme would not fully break if the
driver moved to device MSI domains. The variant driver caches host
MSI values from the MSI descriptor, regardless of the allocation
method. The hook point may need adaptation, but the fundamental
approach (host caches physical values, VM reads them) remains valid.

Regarding the hypercall idea for device MSI domains, I think that
would be an interesting direction worth exploring as a generic
solution, but that's a multi-subsystem effort that will take time to
design and land. If there is any existing work or design discussion
in this direction, I'd be happy to look into it and contribute.
In the meantime, the VFIO variant driver provides an immediate path
for users with deployed hardware, using an established kernel
pattern. For now, it could coexist and be replaced later on when
everything is ready.

I completely agree that this could theoretically affect any device
with private MSI registers. However, in practice, I'm only aware of
this specific behavior in Qualcomm ath11k/ath12k firmware, where the
device's interrupt controller requires the host physical MSI
addresses to be programmed directly. I haven't seen this in other
devices, which is why I think a device-specific approach seems
appropriate, and the VFIO variant driver pattern fits well for this,
following the same pattern as mlx5-vfio-pci and nvgrace-gpu for
their own device-specific needs. I'd be happy to incorporate any
ideas or suggestions to improve the approach, make it acceptable,
and allow finally to use these devices from VMs.

It's also worth noting that the PCI reset support for these devices
has already landed in linux-next (commit 290153d46d1a "PCI: Add
device-specific reset for Qualcomm devices") [1], solving the
device reset path for VFIO passthrough. This MSI series is the
remaining piece, with both in place, these Qualcomm WiFi devices
would be fully operational in VMs for the first time.

[1] https://lore.kernel.org/all/20260721081301.205374-1-jtornosm@redhat.com/

Thanks

Best regards
Jose Ignacio

