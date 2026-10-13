Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9C3EFFC5
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900231; cv=none; b=iTPChZx2Cwzcg2yFu98CEchh5VsjxEa/JxiBogmNAGlkZKPkQLk8deTl+gmOpvZu14YdwTPTBETTIR88TLB6I0Zs+cADSEPliC5BcXe9YxDX59Zj+e/Sme29bjTfi8+0U7y6DxZDbxT4w9DU2JzhHtBVgccTajKQru0/4Nd4M8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900231; c=relaxed/simple;
	bh=UHry0BPkquJw/CuJwnGhyuxl/slkjmr1qnD/xn81qew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5FWVtQVIPnWcESUZ7dwePHHNj0WI8HvFE8CQZIspdYtHg9jJ4ik4aFhY3d0D7mwkgUlV2Ed0pP2deNspvBL7inLcujA1z4n/ifrb/Jfw/xXxUgGXw7ailVSGY+Gec5W2PPfjcX00TzrdIdtNkvWoG+isyGW9widX9m/voijACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=CBEzo/4j; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CBEzo/4j"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-9828fee1b4bso602451241.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1791900229; x=1792505029; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sxRXmPGGOdI1+4/8LW6E01BCp/MjtS9NyfOV1SrhfSY=;
        b=CBEzo/4jeiz4WlID7U/njZM7AWjCMFsKhRPE2lZcPfdbjT5/IhMC7CPhAthUzS/zjC
         7JdpJuzrx/MaN0DflF6oAbENcPd/EKLzlkXO3xhW/4F5syHofVyYESUmZBXMOG8P4d/o
         U0+8nId/s3j8PBkkGKMw9+6JThitqmt/tGl1U5Nh1xq4Hd0djOAhqJt0lU/i0VlyiGGx
         3lIrp+VrVqteNUBHh72uss+6qHhfv911OjNj/lBhTo0M3tCp5OKbWWQv6+N+m74fPDOO
         CCafrXkio5dlBgBy0OeRosZpOR483gn1R9Bmc9hfkBJ3Hjq6TdOR8etcp4eTP7mIJR7u
         MRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791900229; x=1792505029;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sxRXmPGGOdI1+4/8LW6E01BCp/MjtS9NyfOV1SrhfSY=;
        b=qJ5Z7AAYjGUhLuwQ4SUc2b9JSGUC7eweTQxA9lsvC96BZhBOVQMGgapTYdWfCPAoJk
         xqKcOIkpOXNfEvAqDNkKrqjzA9NniO3nPMLAVdQVVZepGOYep4SNdmNMSVX2Nn2xoiTu
         xUx1q2rdf0N8k+jpK6cFbrj4hmRqJ4ILZwRGFCU9xYO5fM0lwCKNRBk0Qumzu73urDGK
         JMIWeCZbGcm9h05gGLERWehVlGUQCXmyKyqWL9XD/avdc9OttjXJyWTUuD2zL9Vk8LZE
         jFttcgj5mRj1GhWidJxRkil7KZRiyx31SgxZogcIVkf4Z2gZppYGy4UsESDiCJkhCQXg
         fnDw==
X-Forwarded-Encrypted: i=1; AKwUvBzFhWAsRaDt42O4j0LNypUFZOW+U+O/PYb/IyflznwMrh6lHZbM5csTZeDLj6ghBm1Sof9vN6IY9JNSToRwWQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJUAOswgfY0q/zyABknJ3rVH6f4tTq/zRLzPX0deBBB0lD1jO2R
	IinSxpUTiP0sP3Oo+hZ9A+HaJ8sV5Xy4eBsXyV/+eXj76dbonLa/zWOFEA9wnu0pkts=
X-Gm-Gg: AYBFou0D/tvydtVriwl112+547p8pReMO+Ll0+p/dAhiGroQOfQNmWmiJYhUBxtxCYs
	VIF6wIzGfbucPE9DCKYOZPf+f8GGynDPvK00hKIcoLolyPIxhHJ1AkxsuJTE78SWiaOKhLHOqoI
	0Dt+xjV5GtwcInZDCUfow/TbN6HpWMa6qRdBTv0sYHMsCJr5f/kRnltjxBkdRZo/17XneX8AbkS
	qlo9X8ULNaFOgmLFDWf5Bnh+Gt7CDWDMpNX8W1Xshvazh0weJdcJVI+fN6pT0bRfxD6AWlI17ml
	gExZBWcXMcM4c1TYOQp9Am+B62HIB+NY77iMIyXeZwTJw9EfBblNfr33t5IRIN60M8AD/bbhBjN
	x1DnHEqrFdtS63+LLTaopqXrd+pkcb6Sm06jk4dAVKOATk7mVnYr9Zxi7ekqKW//MeiVw8XrnmX
	SmR+HuMfioWJDBeVPSX/nfersZ1a7sufHlPk7wqzVZHvNMU3YQ3t2byty5XeK+zyeY5NckYk5lG
	tk0EwuX79TARdCoB0qI/teGVNORxTtr4kQAOvEhSCS1nTbWyPO9xyxgbw==
X-Received: by 2002:a05:6102:a48:b0:7c3:875e:593b with SMTP id ada2fe7eead31-7cb373fae29mr3183710137.32.1791900228555;
        Tue, 13 Oct 2026 07:03:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97bdfb89sm25903626d6.40.2026.10.13.07.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:03:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xGd6X-00000009i6J-387e;
	Tue, 13 Oct 2026 11:03:45 -0300
Date: Tue, 13 Oct 2026 11:03:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, bhelgaas@google.com,
	jjohnson@kernel.org, johannes@sipsolutions.net,
	kevin.tian@intel.com, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	mani@kernel.org, skolothumtho@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
Message-ID: <20261013140345.GK14213@ziepe.ca>
References: <20261011132558.GD14213@ziepe.ca>
 <20261013134317.174234-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261013134317.174234-1-jtornosm@redhat.com>

On Tue, Oct 13, 2026 at 03:43:13PM +0200, Jose Ignacio Tornos Martinez wrote:
> Hi Jason,
> 
> I understand the concern about compatibility implications, but to
> clarify, my intention is not to create an ABI or a "MSI caching
> concept". 

It very much is an ABI, you defined a new ABI in the config space a
layout between guest and host that we have to maintain forever.

Just for a hacky solution, it is not so nice.

> I can explore converting ath11k/ath12k to
> platform_device_msi_init_and_alloc_irqs(). However, if I understood
> correctly, the VM problem remains identical after that change — the
> firmware still needs physical host addresses, and device MSI domains
> in the VM would still provide virtual ones.

Yes, but it removes the solution of copying data from the existing
MSI-X table from consideration, which is the primary hacky thing here.

> I'm happy to do this refactoring if it opens a path to get these
> devices working in VMs. What VM mechanism would you accept for
> exposing physical MSI values through device MSI domains?

Once you have a MSI domain you just need a driver wired into it that
can request and get the physical addresses from the hypervisor. Then
when that domain is in use the guest will always see true physical.

That part is easy enough, it already exists and you don't need any
driver changes.

The bit that isn't clear is how you get the domain in the first
place. I suppose something like a virtio-msi is a good starting point,
but I don't know enough about ACPI/etc to imagine how to wire it into
the flow.

IIRC hyperv does this, so maybe there is something to follow there..

> Jeff is escalating to Qualcomm engineering again (thank you for
> that), but users with deployed hardware need something working in a
> reasonable timeframe.

Yes, but it has already been years, and Qualcomm doesn't seem to care
about these uses cases, so I'm not sure I see the urgency to do a bad
ABI hack..

Jason
