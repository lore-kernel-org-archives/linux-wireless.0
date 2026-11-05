Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903188;
	b=cFM0+pzysVFTp+ZQ5cSZTjmmpwFyMz3EpbFRkvFuDpyCin/F5No5Ml/nEDhIeer/MV6J
	 po2TvQq+RHCW+nZEBYxCUfbbkyEF8xpaWCPnAV0MxID6+fBFZg6d6QnC5qDrPLg0vpLeX
	 Mli8SmHCE66PPt1WLy/wBeAc+srP2oURiQBTYhS0pUeuqczi/V0IlhguDu2DE390Tl4DA
	 XMcmHnKdBW8VvT6FJD0GbEEXs2jhBAmHlKpb+dhJ7bT6dv7X1JHpy9ZFgmhDM6+mrBZYO
	 lQpYA6SifEHIy4IoCYtqCHDxq0mSEVzcadB7DYdPxkIuBKR1z5VkbuWyAuO2ZDOXhww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903188;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/R0hL4pC4E1+M4yPEUjAb9DEswCGIx3z9hc5cmLnrn8=;
	b=RYbn3/hxRfDGlhYufbFPel9k+IJBb/WkzM6TuPi74pX12Y/kSUV5CDcdqK8c3kzBx71Z
	 TYIrcpzOQpzdxPcOSpEHVq16URrYuDRVOGWqeSEv3NQEmKnzU9iTCqMmkzWkofnbCB/5+
	 AJTrFn+5nOXPdEo1aenNb7O/W7T5Gt6MvndMHAZvsFBvVXta3q4sNDnNX2QyqSMCKpFwR
	 dpPyPm6M7QaH6/RP/veODloWicMlvhHqzrJw9CIBj7UkrzxafIgFw4qoXaI4P6GT1rLbo
	 aP0irO+QEPK2WP/WDHgYoGn308x6xFAFKODSynwujMSV+1Yr7vIzAXeoQQzL2lreKuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WSADaA2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D977D606A31B;
	Thu,  5 Nov 2026 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WSADaA2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AEC1F000C1;
	Thu,  5 Nov 2026 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903187;
	bh=/R0hL4pC4E1+M4yPEUjAb9DEswCGIx3z9hc5cmLnrn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WSADaA2/B0njymg1oF8Zt+aQWjkjZp7YNB/CPyp9J98Lqyl4v6ZjN9fdw7/g/aDHs
	 chIL9JCou1TsxyZomGHv2ZBjLQZ9Z1DMWTUjRpmHis5a1j1jVyAEUyc+4ePcQsFPhd
	 OPBs016zO1yFXnt4RNHofu1Kp5EDvzii20mg9cT1xiXd9rLrrVGa/442/RYi2She4m
	 EYJhTmYBt2Rvig1iLH8Imhje9jvJRWYRfaZbM8Jt178SF2ils406aYXkle+Zdk/FLn
	 gDUCaggZAfj1BLbk+EODCjDPXj1SZjVg3T1elHfRmQ6s3AYErm9i4G5kIxtD/aXjgb
	 Fehrul5E5Cuyg==
Date: Thu, 5 Nov 2026 20:26:22 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "Rafael J. Wysocki" <rafael@kernel.org>,
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
Message-ID: <20261105182622.GD8298@unreal>
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
> On Thu, Nov 05, 2026 at 10:03:52AM -0400, Jason Gunthorpe wrote:
> > On Thu, Nov 05, 2026 at 03:18:56PM +0200, Leon Romanovsky wrote:
> > > On Thu, Nov 05, 2026 at 08:12:51AM -0500, Greg Kroah-Hartman wrote:
> > > > On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > Convert the PCI specific untrusted to use the common device trust
> > > > > level. Adversarial means the same thing untrusted does.
> > > > 
> > > > What about for USB?  Will that "move" to use this common trust level?
> > > > If not, I don't think it's very "common" :)
> > > 
> > > It supposed to work for all buses out-of-the box, at least this is the
> > > intention.
> > 
> > You mean DISABLED/FULL should work with this patch series on USB
> > right? Meaning the core code will not bind a USB driver when DISABLED?
> > 
> > I was wondering if some of the broader things we are doing on PCIe
> > also apply to USB, like device authentication. I don't know alot about
> > USB, but I got AI to help me find some relavent spec information.
> > 
> >  https://usb.org/authentication
> > 
> > This looks like the parallel to PCIe SPDM device authentication. I
> > would expect it to work broadly the same way as PCIe if anyone wanted
> > to implement it:
> 
> No real need to as no one actually made a USB device with that spec :)
> 
> There was some patches on the linux-usb list 6 months or so ago to try
> to implement it, but it stalled due to there not even be any devices to
> test it for.
> 
> > 1) USB discovery discovers authentication support and creates an
> >    attestation subsystem device for it
> > 2) The struct device starts up with trust = DISABLED
> > 3) Userspace runs the crypto flow through attestation subsystem. This
> >    is extremely similar looking to PCIe SPDM:
> >     1. GET_DIGESTS -> device returns a hash for each certificate chain
> >        slot it has.
> >     2. GET_CERTIFICATE -> device returns its certificate chain, read
> >        in pieces.
> >     3. CHALLENGE (nonce) -> device returns CHALLENGE_AUTH: the chain
> >        hash, a salt, a hash of its descriptors, and a signature over the
> >        challenge and the response.
> > 4) Userspace inspects the above and approves the device
> > 5) trust = FULL, driver is probed.
> > 
> > But I supposed Greg is asking about /sys/bus/usb/devices/DEVICE/authorized ..
> 
> Yes, that is exactly what I am asking about.

I used AI assistance to create the conversion, which produced two patches.
The first exports `device_trust_set_policy()` to support
`/sys/,,,/authorized` and `/sys/.../interface_authorized_default`.
The second adds calls to the `device_trust_*()` functions.

https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=device-trust-core-v2&id=98f5d11580d736a7878323dfb7238cd08c6c76af
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=device-trust-core-v2&id=f10f8e448540982699438dce369fef6cbfabcba5

Thanks
