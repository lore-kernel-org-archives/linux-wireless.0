Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8349C477285
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 11:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791198105; cv=none; b=s5xzdN2opuOmvJAjBE01IgASOkmDTfToQuZdsknjYxSVPKKSSEfinCHBGy2slZFWbdmwvBc3G+q/x4XTzbVoV2/v86glFElr9/S4d6jAmQTWn8SF1WHkU9vyLqG8cieProSf/LNjRDOtfLIQ9qn9dWVCEFwCqk/+UoNng2wXW8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791198105; c=relaxed/simple;
	bh=VAKmTovVzb87d5A8hUeHQhkh9HG4yeL7dyz+l+PJrmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuDTRwhmeK27RsHG6OepKxEDSbKL0ezqRWagwaDZG/x1zTz4QKJE4iVOxe2XnLLZ+kiXu7LJudrziaYcKYyY5rW05taSaKrKqaboBaMN2fyP3eEu8vMMBz4w1cAcBo+bbVbTTym4JAA16Bhs7EasPxBfO4kIadBKcjq3Kcj64NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCt6UKg4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCt6UKg4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791198102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VAKmTovVzb87d5A8hUeHQhkh9HG4yeL7dyz+l+PJrmo=;
	b=gCt6UKg4MyEPKLtVb4PMp0Q2tPtr7DnlwBbdCy/nScQEuDDHE8Bm/fyYJJBlLLUS4aXaPm
	5x0CE9G65U4Noqi6JLaszqyF8fTFlidLRYzdXLjeVZmXJRdlt8++uyyonFkwuJCKBC/W77
	OeD33uC7TxqSyFFyxdUj2YavmOdnP4c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-uq9_KcWuNnGBqTT2Pu5KUw-1; Mon,
 05 Oct 2026 07:01:39 -0400
X-MC-Unique: uq9_KcWuNnGBqTT2Pu5KUw-1
X-Mimecast-MFC-AGG-ID: uq9_KcWuNnGBqTT2Pu5KUw_1791198096
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B6521801220;
	Mon,  5 Oct 2026 11:01:36 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A51F23001D2A;
	Mon,  5 Oct 2026 11:01:32 +0000 (UTC)
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
Date: Mon,  5 Oct 2026 13:01:31 +0200
Message-ID: <20261005110131.84545-1-jtornosm@redhat.com>
In-Reply-To: <20261002171046.GA32083@ziepe.ca>
References: <20261002171046.GA32083@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Jason,

Thanks for the follow-up.

> It breaks because VFIO will only cache *actual* MSI-X table entries,
> it does not have visibility into anything that
> platform_device_msi_init_and_alloc_irqs()

You're right, the current hook is on SET_IRQS which is tied to standard
PCI MSI allocation. If the driver moved to device MSI domains, this specific
hook would stop working.

However, and I was referring to this, the variant driver is a
self-contained module, it doesn't prevent anyone from moving
ath11k/ath12k to device MSI domains. If that work happens, the
variant driver can be adapted to hook the new allocation path, or
replaced entirely.

> The only reason this works for you at all is because the driver
> hackily copies the vectors from the real MSI-X table so it can look in
> the "cache" to find their true physical versions.
>
> Which is my general objection, I would like to see the driver to use
> platform_device_msi_init_and_alloc_irqs() and don't want to get stuck
> unable to do that because it would break this.

I understand the concern, but I haven't seen any active work on
moving ath11k/ath12k to device MSI domains, and the VM problem would
remain exactly the same after that move (as you acknowledged). It would
mean waiting for a refactoring that has no active work or timeline yet,
while users remain without a working solution.

> Yes, but it does actually solve the problem in all its forms..

From my research, there is currently no existing work on device
MSI domain virtualization in KVM. Building it would require
coordinated changes across multiple subsystems (KVM, QEMU, VFIO,
IRQ core, guest drivers, arch code) and several maintainer trees,
and there is no KVM hypercall that bridges to VFIO, so the
architecture would need to be designed from scratch.

In the meantime, the variant driver provides an immediate solution
using an established kernel pattern, for users with deployed hardware.
It can coexist and be replaced when a generic mechanism arrives.

That said, I'm open to restructuring the current approach as a more
generic VFIO mechanism for exposing host-side device metadata to VM
guests, where MSI address caching would be one quirk type rather than
a Qualcomm-specific driver. This way the framework would be reusable
for any device with similar needs. Would that direction be more
acceptable as an intermediate step?

> Everyone else seems to know this stuff doesn't work for
> virtualization and doesn't try to do something like that.

The firmware is what it is, and the hardware is deployed. The kernel
regularly supports devices with non-ideal firmware designs through
quirks and device-specific drivers, and this is what I am trying to
do with the VFIO variant driver pattern (as it was previously done
for other drivers).

> Why do people care so much about this? I always thought it was a bit
> odd?

WiFi passthrough to VMs is useful for network function virtualization,
security isolation (running the wireless stack in a separate VM),
edge computing, and development/testing environments. These are real
use cases with real users who have this hardware deployed today.
Qualcomm wireless cards are widely deployed, perform well, and could be
actively used in these scenarios.

Thanks

Best regards
Jose Ignacio

