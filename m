Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414BF4F93DB
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781163; cv=none; b=j+LfoukMpmil/GKt90W62A5KRyij+JW/Ewx6hRYw7CX6CXnRCDH9fAELPCngCGRd8DGYGUeLTtFL7pUeCjxY7fhLa8/CU03bh+yjcKf1VS93oc8H9ty7++AZfma6xyRghcx+jktwIC65mxiO+sDQEvWh3sxUlUeb84/kSeve+zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781163; c=relaxed/simple;
	bh=N5TwGmCOg73FQhkQUlqK26vGWZ+6twK0jOc1jidbG9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=se5A/DY+TNusn38aZU+Srm0i8oupD7AJvmtcQ5ULQkS3MW0s5Trq5Wib7tjVPPBUlR1HVJT3GYDW+j41Xv7O7GdrL45KZqxOKX5xMLrpwSY/CPk1LOr5/djIhCxLeoUAug+YjOAlXW4AJRWUFTMejYs/YumR0KkH6Wp7Iy38mC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=F2LynHut; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="F2LynHut"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c3b639adbcso5291502b6e.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790781152; x=1791385952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i3zztcZwHv33xTSBhcuuRwUuO/mC2YE/oPR+7vCHXWU=;
        b=F2LynHutv0ZOmuF8vmFQU0cyqiI4GB5kyNhWNIcFmTm03ZYDlIdoeMvOS1ol6pHe7P
         1opniFMp9w/1hoNxwBw1abApRh1Po/j0x2ZuaQZgt0r7WvI/GTEHkvv7KKThQRNgUeDk
         U3vhG4nOcBSBbCwSBzxPAF2/N9kbmWUuQeOCbbHXQ+GZ3OEDXh8iCi7m7OhysGURcFuR
         MYdYJN3ZhgKPd9PQq1QsBlgi+KBVppXhOjswSN+K42z+R3efFI3SH3JDdd9Kub164vap
         FKr2jNuW6GBhqs4aVFIb+0YT7DujIACVvy1vKyp41BAFenyWoJ63gl+3RGCO5hghcRCU
         QQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781152; x=1791385952;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i3zztcZwHv33xTSBhcuuRwUuO/mC2YE/oPR+7vCHXWU=;
        b=nZ0tB7WtrKOBwB6spqusd7n+OjvfxfV90FLF0TizhAsOXpMV8tp0g1NuHfX2Ij5C3k
         AnITx4pEgzEQExSXNq2VQfnzT+/sYStoC/Rx+CeSV9es9YK98v/qD65Pk/VktttItXsL
         5w2uutc9ItsnsTF4Qyu11P676pAzfXSu3Vl3bT1nCuqIU+8R37i8CFr9+qBKO3BzyHQG
         x2KgOsvE9xgEtr3amZfZy4P0AMBPYc452Ol8SBURwPks457tLEMQLRYSoYmkpm1inLK9
         NRhFgyoviaWCCte9Ap1jPFTzE7BplvbgInv3HdlZYZDPguZoNpSpqkGtRdIFMEMur6cv
         5TVg==
X-Forwarded-Encrypted: i=1; AKwUvByayc2NLzRe6qRHZb9+PqJqivPfp2uJIsvEZSbbZXmCaHmN+cAZdtLH9q19qzWmJaj9t8JeMyQYvk7DDBstGA==@vger.kernel.org
X-Gm-Message-State: AFuF++l+9NubeHjYZuRYNarfuCr/Aa7PpY45Vv9wC5Z+fQlROubM96kV
	9lN8ahfJ2QGR+wiAVsSKHcH0X7yAVE5uptLvPBd0gHHNq9uFKfN6YBEVrWAUAPsGNMI=
X-Gm-Gg: AYBFou1fw9J44smYilgc1E4iXohU/34Wp+nAhTl+On1aFB4f1R8Y1Hgdv3gyDZ/EVZk
	hdXJaWQ5Eu0IUqSwu9xvqQHLv8NJ+q8Y5mcgg2tgM6adH2UiCzAQlLdi4r3uPr/5jQfu9g9IFhs
	cm9jgr56XKbv/yUmgWSbGaIPxPCWQosIAUxV50uE/01GgV29zw4faHmuyqBMcEo7wcYxpXfA4je
	HGvUH5bMYlhOHcebx6pwa88B+G8bNen5Dxyw1nJjiXzEj55YT3sxFARslZlyk1SlDwP6+iddXLB
	b7Wx0dWqiwsfAnd1HJQCkckpTwIOg7AJTxHnG2kSIUyWeuU4ir4f9oH1fz/45+hxaortkrnPXXj
	fUAlqrJiCP/zzPwZamyUUTKPGjXiRxCvjuVkkuz5oW9AN6C40SLp5XwcFZYaSs/w8bAMSaBURNh
	M158ULnjoRmvZNJ0ayHXlzz+f+juEfragxuxniAKrCT25o
X-Received: by 2002:a05:6808:23cd:b0:4d6:90d3:e187 with SMTP id 5614622812f47-4f1b9a4dd1fmr1463609b6e.48.1790781151901;
        Wed, 30 Sep 2026 08:12:31 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4f1b61be7d8sm1076055b6e.17.2026.09.30.08.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:12:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xBvyv-0000000BwZW-3H3V;
	Wed, 30 Sep 2026 12:12:29 -0300
Date: Wed, 30 Sep 2026 12:12:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: bhelgaas@google.com, alex@shazbot.org, jjohnson@kernel.org,
	johannes@sipsolutions.net, mani@kernel.org, yishaih@nvidia.com,
	skolothumtho@nvidia.com, kevin.tian@intel.com,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] vfio/pci: Add qcom-vfio-pci variant driver
Message-ID: <20260930151229.GR163130@ziepe.ca>
References: <20260930140833.576941-1-jtornosm@redhat.com>
 <20260930140833.576941-4-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930140833.576941-4-jtornosm@redhat.com>

On Wed, Sep 30, 2026 at 04:08:29PM +0200, Jose Ignacio Tornos Martinez wrote:
> Add VFIO variant driver for Qualcomm PCIe devices that require
> MSI address passthrough for VM operation.
> 
> Qualcomm ath11k and ath12k WiFi devices have embedded interrupt
> controllers that require physical host MSI addresses programmed to
> device registers. In VMs, the driver only sees virtualized guest
> addresses, causing firmware initialization to fail.
> 
> This variant driver:
> 1. Caches physical host MSI values after allocation
> 2. Writes them to extended config space with magic signature "QMSI"
> 3. VM drivers discover and use these values automatically

You should probably explain a little be more here

1) Linux VM driver fills up the normal MSI-X table
2) HW has some non-MSI-X table registers
3) Linux VM driver pokes into the interrupt layer and extracts
   one of the MSX-X table entries addr/data pair
4) Linux VM driver now programs that copied addr/data pair into #2

This is, of course, all wrong. These days it should be using one of
our mechanisms to allow devices to have their own private MSI
registers.

I forget if this is the right way for PCI, but the driver can call

  platform_device_msi_init_and_alloc_irqs()

And directly program the MSI registers with their own special
interrupts vectors, no copying from MSI-X.

If the driver is fixed to work like this, as it should be, then it
fully breaks the scheme you propose here. That's not good.

The problem here is not really a qcom problem, and treating it as a
qcom quirk is why it keeps being stuck, IMHO.

The real issue is that this device MSI scheme does not work in VMs at
all. It does not work because the VM IRQ design requires the VM to
trap and modify all the MSI addr/data pairs at the register write.

The technically clean solution is to redo the VMMs so they don't
require that, ie use interrupt remapping so the VM's view of the
addr/data pair matches physical. That's super hard and will probably
never happen.

But! Now that we have these device MSI domains I wonder if there is
some half option to provide a hypercall so the device MSI domains can
call out to the hypervisor to get the true physical addr/data pair to
program?

This is fundamentally an irq layer issue in Linux, not a qcom one.

Jason
