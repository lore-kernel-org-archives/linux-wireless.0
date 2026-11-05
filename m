Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793896023;
	b=itM7tcoFKweCRLA4fpU50kV7Ua/MJRwkdZexSPTymVg46KrVG+qepVnkSQ4e8GilfoZD
	 GVut2SWFoaqEXNEPSkYUJ5DJfZ0vA2UHOYN0SZ6SnNr8jagoGPfHiQ3k0+TkgyE99nv2n
	 oHLJdBr5B+ojlzZNIOKq+xIaKh2aFEG3zAJMhiI+mjlhsravNpr92q3NH9vW3c8RaJJDP
	 waLV+dsPkkZTb98ItTUucu9VBVdwy3BcP5XnDSsnC1P3YPdf/biNwkxxIyLR/n+fhKFtl
	 7KXtKUlPUQ/OY6kgbR82QQrxcQ1c5NOF3NqGtVG0uFfLw0Ac/TrgJgwynWrp7LZKcyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793896023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=auiIKhbmoRZT4mFY+NhWtro4ChWc0LCFT6CcONkj2hM=;
	b=z1N9OkOo8EfmRIi45ePwV5m6vvh0SQbyH2RCLb+Trh1oOK8uPKcJYLc1gP6OlO5/4fm3
	 6SSD4NAsjoF3ysyxupHIJGeLsYhGKl+/M47VJaqUBiUiKUA67uzixLKm1mZgR4U0rxjMZ
	 Rq7I/m69gOviv6QTGKza9MIcClP7VPjo6e4PRsg8yP8M49gtxLngM7++P0zVNJ76NGin+
	 /zglSOUiFLInHjIze79GpCR0d4VvtNJyhLUcD+zPrAA2FszDp1bTq7jRco/4Otb0ipFOO
	 XZijMbRs1fPR/1gTOZtlsWz/nKzTnrxdBdTUPI/xH6G7aAlRvIn0ETauuA5J32OsNTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=TH080M2b;
	arc=none smtp.remote-ip=209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E5606D801
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 16:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A2E5606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=TH080M2b
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7cc1cf48a39so727134137.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 08:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793896021; x=1794500821; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=auiIKhbmoRZT4mFY+NhWtro4ChWc0LCFT6CcONkj2hM=;
        b=TH080M2b2W5GU83fC4bkAl8rc89cXnFJ2JUZ1DQM2E1G7nxV0uZ+iMHWJDX5M/hBR0
         v8Q4S1dZz9e+Wy709/pkQPJoJ382ui88GBuCa7YwB1Pwv+V08ySzbQGdCs4et9sFRxVX
         1a78LWa2r/qDmkC73yn92WJjnMydzWl2HaDmNekF7y5RHwsZB7YPGLTTr3xjjmuI4LbR
         sgpTrG1DSTm++FzIJZEq0knZSmQ9xxE9IezNyVfi/1ZtU95O+iPlQHI5LWAc3/YmXStT
         Vgy3IZE07Q/+XWoEa8k60w3BygO7yb8zhuyYBqBwOLPUaUevbalW8R2MAA5wjUpSFz6r
         zz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793896021; x=1794500821;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=auiIKhbmoRZT4mFY+NhWtro4ChWc0LCFT6CcONkj2hM=;
        b=PRirIch8n9Uj8lUBD9MMZE4zkShacOkI5B+NC1hpuodu4xGYQ2UqvNoSUG94+kJc7t
         wC/vDwC5KsAwrczFQ9mTJnqS+qz4RGZ2MBrqoVgolo3+1p4e1+YKEspqwNk9D1tZL11S
         c3Qx5BH9b1RjsIbM7PNZQykAMHGKMRKHtgpzDl9GUnPw7ZFw/QmbRTdw6k9VyXS3daQr
         fkFYCcE53wU5jqTsdUoS+NV+BI+83+lnqSxnVSiZydTLH5GALaFTh6v4OBK8Wuk1/ijb
         Ld7GiJ8tqug1aI9NR5oKPov0DHjz8x+wcOtMQSOMjuurLoQTNNFmGBw3zJdM+qNV3vjS
         gyLQ==
X-Forwarded-Encrypted: i=1; AKwUvBze2ffJCK4Kwj5b+D5NLzA3jjhDbeQBefXce67TNTeSSy04RgRDTcH79aq610ilTMvLnNBdJij71j8xQPJyIg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+aKcpFnErOSFi8thA3Y7NAyU2/MG1NEGzhu2YnteMVGPnY5OmR
	2eZPAnCVKklX7cISu46wCT6VuTTLsVIyHBw7HA0r1DJj3kl+1V9hqhRfOO6R9V0PJtM=
X-Gm-Gg: AYBFou13nHI56mTtpb+WbIVh6oTViL+0TSQhVN+88a/Ym9CTONjceh3NV0Ch/R+UWR6
	CLrYZkdDNWgVSnW33SAEjRyffZJEBzfFSj3UIqwvD677oIkF+y+KORFmIj+oEiDxfOZCU9wY+LD
	7U9vzwnZqsX71itSfSCKNKI66wXO9m5S+FN79rkXt/RNy+MIaRE11lMYXZ5O2+QRhH2+XjGnhI3
	7Jr6060hwRokYxLtTXpCdqR2KaEetIIlwPNu/DbKo7WhWgUJEiJprJyXltf5JoIczFDaAc2b+fp
	dU6YvQSqdE4AxfdNwXA1DEYaqKVRlesqdN8CyE0B/eW1N0cDvrNoK/A2DjNju/YvDPa2G4DShZP
	cSRgiwUBkb54YZC0Om1i0NdeZ5Az7O2bnHhVYcRS1v0A/hvM6ebqrCiiSUlLgBNwgKC2MWk05qu
	n7JJflOGyQmmBr1kKx/Xbre4KJMgbjUKNlDg6mHeO0ZZ5oe23BuTnG+RUIZd7K05Drs7r+0j6UB
	7uOG3hJMs+Dt3m7abD7kNeDih4v/yz5hpWz/ak8vudhbfuyGeiLWOtStOAm2KxmUOxAZrNBNDNa
	/911t5NJva9fyewthB031G8+UjxKep0vKDWp3uMFko2baLVd8oCV5NV3LjevFx+PevhmOmMnKjI
	/Hi/dZsjgh/oGQCE7KE1aNxCSoIEXk2A=
X-Received: by 2002:a05:6102:3f9f:b0:7cc:174b:f7bc with SMTP id ada2fe7eead31-7d2a15715c3mr29296137.15.1793896021174;
        Thu, 05 Nov 2026 08:27:01 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fef4ed3sm4667110137.11.2026.11.05.08.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 08:27:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xP0Il-000000032XP-37xT;
	Thu, 05 Nov 2026 12:26:59 -0400
Date: Thu, 5 Nov 2026 12:26:59 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [PATCH 17/17] PCI: Replace untrusted state with device trust
Message-ID: <20261105162659.GB663069@ziepe.ca>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
 <2026110526-aerobics-correct-4c06@gregkh>
 <20261105131856.GA8298@unreal>
 <20261105140352.GF3889730@ziepe.ca>
 <2026110558-tartar-juicy-036a@gregkh>
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
In-Reply-To: <2026110558-tartar-juicy-036a@gregkh>

On Thu, Nov 05, 2026 at 10:43:00AM -0500, Greg Kroah-Hartman wrote:

> > But I supposed Greg is asking about /sys/bus/usb/devices/DEVICE/authorized ..
> 
> Yes, that is exactly what I am asking about.

It looks like that does the same basic idea of delaying driver binding
that this series does. Hopefully Leon can harmonize it to use the
shared trust level flag instead of a usb specific flag and retain all
the uABI around it.

But, even with this v1 the user can choose to use the generic trust
level and ignore the USB specific authorized and get the same
functional outcome.

> And I know there are other types of devices that will want to use this
> type of thing (i.e. SPDM seems to be spreading to other new bus types),
> so it's good to have and get right.

Yes, we are investing alot of time right now in trying to get SPDM
uAPI right when we bring the general framework into the
kernel. Everyone needing SPDM should be able to re-use it.

Jason
