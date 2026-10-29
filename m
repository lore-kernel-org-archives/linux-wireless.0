Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293128;
	b=aN8rf5oZVTo+peJFkNNwYEmhu4N/clGurn/femwCjJlDAj5tWwETr+p1BSKJwg2N4IuA
	 q3HgEGtHaCMKYNp0+ysZ7REpanIQOFqjRHBARju4d0QbCv715PSxIcFZrT4mcWm9QOpyw
	 Gf1PgmVlg2VQ/VzIKKeZCIG5cYBJzWzRZpk1JAWxtzvtvMmt2H70Xq4Roai2C+4Gvw1E9
	 8Ah3kB/molOsDzfXCjEkVMx3Tj+H2pEmQrklxTwstfvHYyT9le9SL4RcC8ynC/Ki/rsER
	 K/VusI20W5i7xof/xx6hJH3JwNFC5KuQLaaeQ1uyW2Cy69vTANT48qKeRq5DDKYADBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6bXwD83MIjcipNSA+r7WlJ6caQoTXebpCKMfW1alQus=;
	b=mqgnfLbUC3otp7Rlo1PMW0EUEloly2RLG2R4VflnvZDh6RgFWK9YKi/2vlBK3/ak3vZb
	 6BNx4IuBL/NCWYPxuieq3Yn8sB6sSKi0ZT/rrlhHrsJxNfMNyrnglUcdCmnqs3qyLGBlV
	 GRlrYOdqLTUGsMSzUBZlu/h/MjtqjngbnfzqgU84Oxyj1cQJhmkfmBDHXUrph1PMAsbCw
	 xsh7dVQtmrK2ILRq2Rx/DUP7HNu93cRJOLwoK3TuYHDO0tFBkwJpCe3bHseuPcyXxJwBD
	 oq+nO8TKCYS4L67ovX9k1VYL8KCOoDxjZhh9frEsBA8ai66pDw4ngAhUC0sNX9yFLAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="bD+Ng8/3";
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECDB606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CECDB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=bD+Ng8/3
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f1e5d7450so198165285a.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793293127; x=1793897927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6bXwD83MIjcipNSA+r7WlJ6caQoTXebpCKMfW1alQus=;
        b=bD+Ng8/3nCI/5cWKn4WtKDSPWVPk5hBHIuiXrkbElN6K0EOo4e5w1LTNRGXFCd00f3
         Jwfuew8Cj4qAcC63JhH+tGRH1YbHRvVxo6YW9k0/RoNCcXvNHdO3fsL+p7srQoYK9gCP
         dfIog/jvfA00buTc5IwNKM0mn0X83lr8anz+4kAo53fSHXwsNNNdjWFm0piYuWrBYoZT
         NEyIp44fVuFUY+ogZEPcdT044X6lvUV5KwJmKj0lUb1J7R9YDLAK8t4ELBxxSsUNCqeo
         tOzcJKDGtISKyS59KFnafl4w5KnGawAuTFyuO966T/FFgj03i6Xr3IlIcSNbesHZFjI3
         lwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293127; x=1793897927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6bXwD83MIjcipNSA+r7WlJ6caQoTXebpCKMfW1alQus=;
        b=y+u3CiuMmLSX1En+44/JOMiY5ZFS4PGjtPDxC4cuAYbhhYo0hpJZPv50MLNZyeAn+V
         gebBCLBpHt7wk68peZuSwGq9faLXnM32NXIvHu610FmZDXBu6sxLmKjZsA+PvskZjqTQ
         SOtIV5RJ0IvUvLqfU7vhva7xK6feqfnrP1iqnez23/mAtdTU1cRfMh+KJQQuJqYVa30d
         cqZQNeU+8AuQGDDrN1kiRlIZpMpUdvz0TRuHC2x1JkLd6kFz/IAWx79jDbO82SwbiBi2
         s6Dthp0w+DPB8RNx3rvxeqNAk4r3C+Oci3qsI1PpZlYsmjnM4tLosVa2lH1ynrqoURca
         Uhsg==
X-Forwarded-Encrypted: i=1; AKwUvByw0G6zSA5qjTZuMQqHfEjHwceWNqMkKTZwwoX1tEhlngI6T4i3g6bLfjrSw+LSU/F8inUT56lP2jS3KPXNEQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKo3jcsH+9GPDjvI+4x4kAbQsF5TOoOcb9gFMYVHeftB2oaFsPG
	ZFnkn+UqqQozI8yIX9V/RktpyEnHlbB6T55JKB27hDxkvClDPD3QvFyUFeh50TlPqXU=
X-Gm-Gg: AYBFou1h72akzowbUJPSBBiYvdCuSP7ujrhiZyflRg7rOO8TeejZ6ijBMLmFj5YClR9
	v+P9uyzjWF0tt5+S7qXA6qC8JOjewtSfPbb2cpUYRpBZPmxhKlIHnjhGitY+zGEs/kmUdcLUdgO
	KiU1BK73FTxp45Woy8SJxLI4CcQiXp+cl3iKEbi7rwmD0dq9u9jxGfLcUwT6mC88vPsvLsXL0QQ
	jdHdwpwU1/uREg4wTEr9wWQRhgmN23KY0WMBLW7Ir5ZVdSWv585c7k0Zo62L/6OjQ1BpuV6qSyt
	1WStk0VP2wiyHKu2a5Qj9ydNaq4pUAukVwxMysGcWcr75D24nmEuwk+B+heJ/8UYE5lR4VaKkM9
	AU8ZqtsGoYgWMFlEL0MjBKWXmqMKDyku4uYzd2QCruklOmJjqG5SsgM7nWS4/rzgcALD/d0FWU2
	NCqkdnTLRAMyXkv4VOC9mdro3cFNQw3BsCuINJxffCiwmmmqYzcRZoTA4bCAURJ79Dxz0Et0bhK
	+ndngbDjfbplZeepCp+joVM8ZppctYI6KfRvkeH2gzxOBwGOrl+FR66zDXFqwBweI/r6il0vBYW
	IMtlBhkt9wvgnRAlpY9ISWjjdY1N9vsGwXV2a4kF8f7HwxL8XhCDnGM1G3qR8dgV2ACIoa2xk1Y
	3N+qwYoM52nqT11VZsLj22DupXRMtPfUS
X-Received: by 2002:a05:620a:298c:b0:93f:38c7:70f4 with SMTP id af79cd13be357-94408aa100cmr927645385a.26.1793293126718;
        Thu, 29 Oct 2026 09:58:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-944209818c7sm8131885a.3.2026.10.29.09.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:58:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMTSf-0000000G2uI-1sK7;
	Thu, 29 Oct 2026 13:58:45 -0300
Date: Thu, 29 Oct 2026 13:58:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, pbonzini@redhat.com, seanjc@google.com,
	bhelgaas@google.com, jjohnson@kernel.org, johannes@sipsolutions.net,
	mani@kernel.org, lpieralisi@kernel.org, kwilczynski@kernel.org,
	robh@kernel.org, vkuznets@redhat.com, kevin.tian@intel.com,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
Message-ID: <20261029165845.GQ1685504@ziepe.ca>
References: <20261029163713.1366077-1-jtornosm@redhat.com>
 <20261029163713.1366077-3-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029163713.1366077-3-jtornosm@redhat.com>

On Thu, Oct 29, 2026 at 05:37:07PM +0100, Jose Ignacio Tornos Martinez wrote:
> Some PCI devices (e.g. Qualcomm WiFi adapters) have firmware that
> programs MSI addresses directly into device BAR registers, bypassing
> the standard PCI config MSI path. When these devices are passed
> through to VMs via VFIO, the firmware programs the guest virtual MSI
> address instead of the host physical IRTE address, causing DMAR faults
> and non-functional interrupts.
> 
> Add a KVM hypercall (KVM_HC_PCI_MSI_ALLOC) that allows a guest to
> request the host's physical MSI address/data for a VFIO-assigned PCI
> device. The hypercall is dispatched from the x86 hypercall handler to
> a VFIO backend that:
> 
> 1. Finds the host PCI device matching the guest's vendor:device ID
>    using vfio_file_find_pci_device() (introduced in a previous patch)
> 2. Reads the host MSI address/data from the device's msi_desc or
>    by walking the IRQ domain compose chain
> 3. Returns the result to the guest via a GPA response buffer

This is not quite what I suggested, this still relies on the host
setting up the msi using the trapped MSI emulation, which is the
primary hack..

Was it too hard to make this an 'allocate msi' operation?

> The VFIO handler is connected to the KVM instance via a function
> pointer (pci_msi_alloc) in struct kvm, set when the VFIO device is
> created and cleared on release. This avoids a hard dependency between
> KVM and VFIO subsystems.

I feel like VFIO shouldn't be involved here, for the purpose of MSI
all we need is to inform KVM what struct pci_device * is at a vBDF and
then KVM can do the interrupt bits. Maybe this is already happening?

> +	case KVM_HC_PCI_MSI_ALLOC: {
> +		struct msi_msg msg = {};
> +		struct {
> +			u32 address_lo;
> +			u32 address_hi;
> +			u32 data;
> +			u32 reserved;
> +		} resp;
> +
> +		if (vcpu->kvm->pci_msi_alloc == NULL) {
> +			ret = -KVM_ENOSYS;
> +			break;
> +		}

Yet here it is called alloc?

Nothing should use vendor/device ID either, it should all be drive on
vBDF.

> +	irq = pci_irq_vector(pdev, vector);
> +	if (irq <= 0) {
> +		memset(msg, 0, sizeof(*msg));
> +		return 0;
> +	}
> +
> +	irqd = irq_get_irq_data(irq);
> +	if (!irqd) {
> +		memset(msg, 0, sizeof(*msg));
> +		return 0;
> +	}
> +
> +	desc = irq_get_msi_desc(irq);
> +	if (desc) {
> +		*msg = desc->msg;

And this isn't alloc, it is some query..

I think kvm maintainers would insist on a complete API here if this is
the direction.

I probably would not have selected this, it is why I suggested
virtio-msi or something that could be optional and seperate from the
core KVM guest ABI.

But maybe there is interest in doing it this way?

Jason
