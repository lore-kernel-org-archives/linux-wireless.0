Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7164D502545
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790961057; cv=none; b=AxlyNeSskZIM/THPDlV0XNUSAYIj6VnhjGHe7cfSc6Uh9drxNBTF9X52qgtl6RLKq1lSvM8iongqTeC0azh8GF07KhGuZ9GSZeY3M+7SkItERJ+bV3yEFPJwHaulyqpkxAvo1qnwxxjADHb6/vyr3CRtSKxxuIGiV+ZXVZPgpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790961057; c=relaxed/simple;
	bh=mrxPXIId1qTShZKGlHGgNQz6PnSRa6+MIliC3LYulx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNSqz0NHTQ1lgZt64XTj8AlGufE8Sh5wwdjqkb/joN2ifQsLkIo0a/VPBwhFw0DXddJ8rnX7HAtOG6GlpUfcTVtm5KtXG2NShgEYzDEAnYSlVdd1IFmxYcY0J0f+CrTYw8lvrskLgO7ELrG36/qQJGcC57BExVO3lifoPWGiHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jIsrR6ZC; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jIsrR6ZC"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34d2d25127aso1780226eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790961048; x=1791565848; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BgakvInNsjTIuwI/HruggHJb8c52XKSKFB4qu//ilyk=;
        b=jIsrR6ZCYoXUg62SeoHiJ6U1qQmTUvfmHWogxM0qjQgpdxTBR38CREigK8nBVg837B
         KemCEloefIFs0d6V2TsfLG+gXof4Lczn1A3R8NHqVJVEIGVHb/IebK+RpIye8M3zMs8i
         YTJWrFKclhx7CxJS5QL7+5f//INbWiK4y09jMHkcmwqjDq7GovOeOKTKri8BnYz4SJ/F
         Wb6KjoEp6g56AjVLR/e/dFRyT7rfM39Ade1CK3Dx+VZ1t0EdbRskxub4VkpZ+yFH9FCS
         4N5joGr5LsAuBrkxXGtJbCwSMI+3e4PJkLhKF7HnXpwKcgm3GyDvhTJqShefFqKWZr60
         C7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790961048; x=1791565848;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BgakvInNsjTIuwI/HruggHJb8c52XKSKFB4qu//ilyk=;
        b=ThtvTefXHfRyJOqdD9yFIougCv90zrPJShcBz2hFG4qn5wYr+0MyZTF5H064cVmfV0
         +q7Hm1BHvrlGfBAy9kaNFC3kLjcgH04sriE8Upf63bpSR/AZeGrNk8txCjofC6yDkdXc
         HSw/dpPke0nE01kA0U7rwERBb9vfD6xy3MvWIGI4fSL35bzDDWprFkRAhB7p9dBZMq7n
         u7TXkp1cMtDdjRoOCFXbAEAxyYUDNVbDRDEPy3GqjZWdZjgWk/nhCMZxTo7qspWCksxC
         +cMqL6ytojuzzYYuamNesSDcY3q90HfIpe1uU6SficQ53pRaZITv4cU6bfza28IZbceW
         ssWw==
X-Forwarded-Encrypted: i=1; AKwUvByCo6bbGBlZViy8q5flPUyH6S9gnIOCF92B5S3Qg4XmPsPlAKxPq6ZobjmsugWeVXeSFrYHwtjJ8mLWmcwPYw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLGw92jfTQSvYqtMKCLmnCk5Waj/dQQDO+eCbY3vSRO9XM+O0Lt
	IOUqFJyMUY54tlAGOUy/+NFgctVEVs//cdp3NdAe7FTgkEam7iWiK7tRzbi+QKXcqJ4=
X-Gm-Gg: AYBFou3Lj8YRy38QKKZBoMC5Nt8etew1UiUYaGzf3VEg1Nl+jk9QqIr8AS+SIR7KGYN
	rwSnGq0a2PoSLWMcZKAwzkzbloUaD10HtLYugokJTINeUnvY2lQGmJds56KLH7FVAWRUk9focan
	PnCgWQuhSaZgJpd8EuZSHlj1lkckzIzJCA2G2/+7F299VT7m8nSZunkrtpUno/5Q+EHsMKweXZN
	ZxpiiHyQrM7LxiOu8yAUii0GvLw8KWS7yPl5aSLA1ze6IU2spUob5xE2DSylnVP+Mop7v6QQfbq
	miOQDVzXeiMw86LSHSZvFCAVdLDuevi2I41fC4CQOhv6BeEbZbn7MmAxdljXtYauL+Z2d4hnwgA
	+lNXykCB78VUnFRc/KfIL9H23fvasxLNy1kUO8kfjr7teCSUzBKoyy2G9zq8nBd8JnU6dVYcnl0
	0ZOwj9ayZBaUjENiSYZbu1zf3IPip1ohJ0PC923IOgI8tf
X-Received: by 2002:a05:7300:e5c2:b0:34b:b410:9352 with SMTP id 5a478bee46e88-34f14f18c8cmr3725477eec.1.1790961048034;
        Fri, 02 Oct 2026 10:10:48 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3510850f86bsm4509703eec.11.2026.10.02.10.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 10:10:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xCgmU-00000000BiY-09Yw;
	Fri, 02 Oct 2026 14:10:46 -0300
Date: Fri, 2 Oct 2026 14:10:46 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, bhelgaas@google.com,
	jjohnson@kernel.org, johannes@sipsolutions.net,
	kevin.tian@intel.com, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	mani@kernel.org, skolothumtho@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH 3/7] vfio/pci: Add qcom-vfio-pci variant driver
Message-ID: <20261002171046.GA32083@ziepe.ca>
References: <20260930151229.GR163130@ziepe.ca>
 <20261001071945.83116-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001071945.83116-1-jtornosm@redhat.com>

On Thu, Oct 01, 2026 at 09:19:45AM +0200, Jose Ignacio Tornos Martinez wrote:

> Regarding platform_device_msi_init_and_alloc_irqs(), I agree that
> moving the driver to device MSI domains would be cleaner on the
> driver side. However, even with that change, I think the VM problem
> remains exactly the same: the device MSI domain in the VM would
> allocate virtual addr/data pairs, and the firmware's private interrupt
> controller still needs the physical host values.

Yes, I'm not saying it fixes the problem..

> Also, the VFIO variant driver scheme would not fully break if the
> driver moved to device MSI domains. The variant driver caches host
> MSI values from the MSI descriptor, regardless of the allocation
> method. The hook point may need adaptation, but the fundamental
> approach (host caches physical values, VM reads them) remains valid.

It breaks because VFIO will only cache *actual* MSI-X table entries,
it does not have visibility into anything that
platform_device_msi_init_and_alloc_irqs()

The only reason this works for you at all is because the driver
hackily copies the vectors from the real MSI-X table so it can look in
the "cache" to find their true physical versions.

Which is my general objection, I would like to see the driver to use
platform_device_msi_init_and_alloc_irqs() and don't want to get stuck
unable to do that because it would break this.

> Regarding the hypercall idea for device MSI domains, I think that
> would be an interesting direction worth exploring as a generic
> solution, but that's a multi-subsystem effort that will take time to
> design and land.

Yes, but it does actually solve the problem in all its forms..

> I completely agree that this could theoretically affect any device
> with private MSI registers. However, in practice, I'm only aware of
> this specific behavior in Qualcomm ath11k/ath12k firmware, where the
> device's interrupt controller requires the host physical MSI
> addresses to be programmed directly. 

Everyone else seems to know this stuff doesn't work for
virtualization and doesn't try to do something like that.

> It's also worth noting that the PCI reset support for these devices
> has already landed in linux-next (commit 290153d46d1a "PCI: Add
> device-specific reset for Qualcomm devices") [1], solving the
> device reset path for VFIO passthrough. This MSI series is the
> remaining piece, with both in place, these Qualcomm WiFi devices
> would be fully operational in VMs for the first time.

Why do people care so much about this? I always thought it was a bit
odd?

Jason
