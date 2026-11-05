Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898126;
	b=eW8EPLhMWdq4IbDFoWPAtcngl06DEjsf/Ky7Z6QsI4gDyvQx6lCTnqUvAd8WwemZN0Tj
	 nOEtnUdOH4v2aSE3jYEl+FTbAPrYplbZRzqh08z/9V5t9zotnpk5q+kUpvsmy2iCnukjH
	 1zMchprSyRd3UKXq2wFV+tJmjMGYxCTMLaozJrvJ52J8sLP+hxuH5sHKNF1oZmylyytww
	 Uipn+bDmEwNwIk1hRc0hhU6rbQYBT2OUEsC8lspvW5pPo2f39QAQLiYGDKP0s5yTBco1Q
	 7JT6qYS2gr43kzKd7b6nxjN/7DtQ0zRXWRdiTbM5i96GAtChZfQQofwzi4mYjO3+LBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=E1zVtHMFtNJFSrWULrvIbtVVqDsU9/hCEAvj/Fm4m+Y=;
	b=GR2auUWLW0WStGvVXGE758oSNjSmEe/AE1I+t4IpbI1BcdLmMrmLBRypWB5cAEC9H2HS
	 /V4mzk1Y0SOSu2GMLHn+otek5zIpf+PsMy41DXKD0x9PW/ZhUD115He/pEZtuGwsT//lH
	 tO4y8MUdz2OrVlpHi6+daymk6QQwXBhzJRhnE7IoZ0/h3HbGh9Lbg7LwSt6RFOr+tt4SY
	 WkayHST/umXGmguuJQvKTna+8B976MNMlz9jZaUrpDRryjpRYP6mGAILyXaBWrpBk/6uD
	 yRNCs92yF6DSHr1mKUNlKBN7b/zCq3us6+Mb63kpZmEsOFz/Z3FMLAvtkuYc+PU0ojw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="UT/D8aSt";
	arc=none smtp.remote-ip=209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F5606A32F
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F5F5606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=UT/D8aSt
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-990703f817fso1030009241.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793898125; x=1794502925; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E1zVtHMFtNJFSrWULrvIbtVVqDsU9/hCEAvj/Fm4m+Y=;
        b=UT/D8aStYb7dPEp/Z1PTR1znD76pBm0Z1nPlORuFlgDbzwSX/aHEaMIKgxREgduhMs
         7b184i+9WuyWU3kP4ECdvxL5tqJCBp+sE58xftFr07RVMuYSe2D0AHX1L8wkHJuC4lcP
         6d7IEtulMVc64pTkfBc/dFTnsuyCXdHVpF//V/K2Xgp9mPmSNI4/p7tLi2H5V42yljeY
         GtO1ChQ2JjqDeaKC4B9biWxL+z3aUuPX/f+FWBrD4U/FW4Q80YjAWhMK/Up13oskn2O3
         3V6ObKXKjzYpPS1tL8mHYVexmV3sD/kfJUj7ToJWfvaytzTBimAL6fO0bssiuf+AQf9l
         4B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793898125; x=1794502925;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E1zVtHMFtNJFSrWULrvIbtVVqDsU9/hCEAvj/Fm4m+Y=;
        b=nIqTMaC2ql826OPOHXwNx7AxmVJYwDgDFFBawFItjKIl2Dk5p5NxP15Op8wIv7eC9/
         BCTRzZRm3ZYFm6Pth6SipGLCr4/LmPJ5OKFh0pL6GItF8CGcQymlm+VWh2CazHGAJKl9
         Yx8vtfGlng/LaOnm9R7aL2GBB/XAbGHp4QLyOHGi7ykgTGwHRZyqwdBSt/woSOLtPRIu
         y3ffoDmTcP7YybHG2cnwUmeLLK+K3iemn+pYSk8xPefPwcIsBgG2r35YD4UcV538rFuF
         7fBq7ERiVdUJNMACxbyrSZrdfMOZNNuJCbqz4joLXZkNhDABcCHDPkfkJklL48f79EVX
         CWuA==
X-Forwarded-Encrypted: i=1; AKwUvBykz1aadidJsIOGVUIPmL+eEx+eEdoC8CcxP5FLk7YRKYLkF7Xckx8GNgWzLR9u7glvlCgD9en5Nai09/9R5A==@vger.kernel.org
X-Gm-Message-State: APuU4Z9F7JaKqv3tJUBFK18O3r1s3e6c0b/c8vbnUGqwW9Hkpa4l0ZJE
	2muBtQZ6v0KJIgCg4g9PsraIuGC1MnWyKn5PYyskhM5byHHc5eiFfkv4/WWbZYsIauY=
X-Gm-Gg: AYBFou0oHdpfxfGOrHRJ3lvX46dR0nLpah5dy5q/k/zWNHJwlvO9A1Ex2wCmvq/J356
	gRPh+H3uOwjy5iCWb7eiBUiDXpyYtdH5eOmNoZZaHsicI/gBbYYk2XqP2UGfIBkfZ43mWHyOePr
	+fVAGEV4teX/I3YhCaJc8x/6VKvg3EbbD1Ukk++egkvDND01Ac3gry0PpGBoPBtx6bq0cZPwt+M
	R+AsNyJ2dwavzXCyZvuAz82YIYUn4+r5p68+9loxwuExHbiInw34fyvYFjYmq6+Xj0oEt9AWNHN
	wQ5DXvHFBJW0C4REhQMfNuhhXQ6Gb/1MdK4CeJkK3+IwNb/MCQ2l3LCMIUKCuD3WIZL2nBI9+nG
	4xuRgb62sqnukh+sxc4MTHbpFm7WqoJUrw0nMymsWAcDPBqbcsoumGFwzA3dRDTh6RBJ6lD9Lnd
	Y9DOYCiO7ATcDemrQRuw/zKXuv8Bu6LDPnXBw9XlN3cETAALKWah+HfmWvkA86X3oRpNHKiZYEn
	XMBZkeC35wcuX+oc6/tFVVGEtY9G1qzBLo8THyT+7nROehsu0WVsfuNtEcZfVytkvjwkzkgJjqh
	c3fPL1tB//hCiPhTcHm2Jl833nNMpadiX5TFbB10Hnx6YYfPs2YLqRMRH9W5vRyttG8GaYGmKHZ
	363pX3oe6nfbF/UAcc07yB7rAgQ+ViQ8=
X-Received: by 2002:a05:6102:2c1b:b0:7cc:2bb7:1335 with SMTP id ada2fe7eead31-7d2a16c7f35mr120203137.33.1793898124846;
        Thu, 05 Nov 2026 09:02:04 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fd3e101sm4619225137.3.2026.11.05.09.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 09:02:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xP0qh-0000000388I-28Zd;
	Thu, 05 Nov 2026 13:02:03 -0400
Date: Thu, 5 Nov 2026 13:02:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Johan Hovold <johan@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-input@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH 10/17] driver core: Expose device trust authorization
 through sysfs
Message-ID: <20261105170203.GC663069@ziepe.ca>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
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
In-Reply-To: <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>

On Thu, Nov 05, 2026 at 01:42:23PM +0200, Leon Romanovsky wrote:
> +		(RW) The requested trust policy for the device. The initial
> +		value may be selected by the bus before the device is
> +		registered; otherwise it is "default". The policy is resolved
> +		to an active trust level before the device is probed.
> +
> +		The values are "default", "disabled", "adversary", and
> +		"full". "default" lets the bus select the active trust level.
> +		"disabled" prevents a functional driver from binding.

For making this more general:

"disabled" prevents a driver from binding and informs the kernel to
provide containment of the device. For example a PCIe device should be
unable to DMA to memory.

> +		"adversary" requests operation with the restrictions that the
> +		bus and DMA layers can enforce for a potentially malicious
> +		device; it does not isolate DMA by itself. "full" requests
> +		normal operation.


"adversary" informs the kernel that the userspace wants to opt into
any security defenses the kernel may have to restrict and further
validate interactions with the device. This may have a performance or
functional cost compared to "full". As an example the DMA API and
IOMMU layers will avoid exposing unrelated nearby memory to the device
during DMA.

> +		Successful resolution to an allowed level commits policy
> +		and operating level before driver or DMA setup. Both remain

"before driver startup"

> +		fixed for the device object's lifetime, including through
> +		failed or deferred probes, unbind, reset, and driver reload.
> +		Later binds must resolve to the same level, including when
> +		the policy is "default". A resolver error or disabled result
> +		before commitment leaves the policy's writability unchanged.

Not sure what "resolver error" is.

Jason
