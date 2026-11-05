Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905615;
	b=1BK7SW/zkBSQca9hoU6akYQk/+KPL5WVh/8b8fa+G6gNArQ6XJUVWa8AFou6rkgCo3sl
	 0r2y2JKmNqGh0b5AayOKALS5PBN91PD0g80yPpZRta9Xvmq/xsLA6n+lfPew7IC59XMb/
	 vYRDQ3rq1hvqlHSklc5Kax1MiOfcEebdxaDrGoGUibgSmygkvdLiKCWFtFLkEqd6xOqtD
	 ipN+Uel2bpLSxEm09yJtrftBm+8/KYqevG4+H68EnGw2Y16p5mywVoON6xXz1YCAr85mP
	 SqUEKTP4iUj93MAs54cwUoxENcjmPtWdfl/Myo4TQ1F1zPea03+Z9NyLLzlEaWxKcRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905615;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4hceOEWXK31/wey4HLyhWUuIxdFlvO9JeZLDVyDyWrs=;
	b=S7+osLb5k7NeoOGTUVUEtXsbhgmdK8hwIpa3axma5452CC/oSh+Fe2xgpUbdM/dGt/RP
	 6FWglPNtKeTD+4eulHI+xxBVClIig/qvVUlIxpdxD246taauDotghXWQ1R77wwH6pVbKf
	 GAinVd5mcWOtxMPvw8+7INxkC7iI/1JxjF0MiPLorVJqnaf37EHoaUgr3l0wVl/shQBgC
	 JitZJN7bBMYU8BL4YGf3hk17I17aShlHJ5It2bjz69LTdMoue7hQunSM65pX7AVdY8Cf5
	 /nxAaAzfV3eUJjnv5N8mmGBka6FR6KUDHlAzoyYRtjYNnHWpPLQ/o+FNTsDKjJCxOYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cftU3XT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5F606A31B;
	Thu,  5 Nov 2026 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cftU3XT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1999C1F000C1;
	Thu,  5 Nov 2026 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793905614;
	bh=4hceOEWXK31/wey4HLyhWUuIxdFlvO9JeZLDVyDyWrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cftU3XT9IOjSS+GBFmrSkGjEb8wnNzMR1iXV4os2SjccwLQdeGIKHvwELRqoj1/Iy
	 0mxEvHz0cC7vQZHeTgAZmHgrACsGN5/rXfQGS3XX6pwM3kJohdWxjMAoMPTmGH+knR
	 7AJnj8TUJy7DiEYOMqqYtaG1oglQEG2VhA0Q2rwA9+NqOs+rUo0l9Z/r2kiBOR3/e+
	 FSwa14oxy6AzjGOckOkmDwqox9PgfBApaVtWJBhN8r7UFMiLLWfEX8zQwkru31QMfk
	 FGLK+UD266uWG2Xb+0HTnEYtg5/9AUhRzs/7+hCDLM35+AxqFCser0nvuQh/JOJurW
	 OLQRYg8t0MQDg==
Date: Thu, 5 Nov 2026 21:06:51 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <20261105190651.GH8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
 <20261105170203.GC663069@ziepe.ca>
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
In-Reply-To: <20261105170203.GC663069@ziepe.ca>

On Thu, Nov 05, 2026 at 01:02:03PM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2026 at 01:42:23PM +0200, Leon Romanovsky wrote:
> > +		(RW) The requested trust policy for the device. The initial
> > +		value may be selected by the bus before the device is
> > +		registered; otherwise it is "default". The policy is resolved
> > +		to an active trust level before the device is probed.
> > +
> > +		The values are "default", "disabled", "adversary", and
> > +		"full". "default" lets the bus select the active trust level.
> > +		"disabled" prevents a functional driver from binding.
> 
> For making this more general:
> 
> "disabled" prevents a driver from binding and informs the kernel to
> provide containment of the device. For example a PCIe device should be
> unable to DMA to memory.
> 
> > +		"adversary" requests operation with the restrictions that the
> > +		bus and DMA layers can enforce for a potentially malicious
> > +		device; it does not isolate DMA by itself. "full" requests
> > +		normal operation.
> 
> 
> "adversary" informs the kernel that the userspace wants to opt into
> any security defenses the kernel may have to restrict and further
> validate interactions with the device. This may have a performance or
> functional cost compared to "full". As an example the DMA API and
> IOMMU layers will avoid exposing unrelated nearby memory to the device
> during DMA.
> 
> > +		Successful resolution to an allowed level commits policy
> > +		and operating level before driver or DMA setup. Both remain
> 
> "before driver startup"
> 
> > +		fixed for the device object's lifetime, including through
> > +		failed or deferred probes, unbind, reset, and driver reload.
> > +		Later binds must resolve to the same level, including when
> > +		the policy is "default". A resolver error or disabled result
> > +		before commitment leaves the policy's writability unchanged.
> 
> Not sure what "resolver error" is.

The bus can provide custom logic for handling default policies through the
->trust_resolve() callback. This is "resolver".

Thanks

> 
> Jason
