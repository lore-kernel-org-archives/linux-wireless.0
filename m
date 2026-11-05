Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893388;
	b=nnymrAyhTRU9hQ8zpM146IBogJ3oZUwcSLlkFoeBiF9d0WErbzGOkWJs2q6xn7JWgxP4
	 Db9gTZ/RANMK4NK60JpqOwyMI2NsoQo3x0/ar0vOq2fw/i1PLZME/hxWMVdGgXqA9jt8R
	 3E94wX16lub52foGfzfKyM37Q9wnQhsA1S/LDGb0PcBjBTYuoXNXeXJZL2Kota47eo+jL
	 FcqdWZTyOu5dU7guE89JUpl4CJmsDNzfElqNARUzfhkk2U4Tmm6KVQHds2hQjtygzTLdC
	 HX+sxukwlOE26V78c1Ss34B7eht565sJrnU+EaJz9yiwbhFwAh/4uNYBsViQ9P/2dNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893388;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bAXawh5S7drxX+EPOw/4ofsw6RsYMvWUKGvcLmgP8Ek=;
	b=PggESxxb08Y84SgrTOUVcSCsEI/cEheZorYtPIOVSGReR6xhsd+4b2gEiP0TmoBhYJ8l
	 WMH/AezzLpM/j0R4Msmi9MVFcZKCJcWoeFlVfXuCIXe+xnue+ZUZE09qAO4SED4Y/sjh/
	 XWqcUJCIW8/Qy2fk5jyrayZGQFVZF/1j4isnn/xGKa0VYmmOEw2FvurRCcyK+0tsnKm7E
	 eY9Z8jNNFAdHWu1bJbTigyEbPv7ikFAL7C/X/sSmA8NEbBamVzhikB6r+8Yk9mvv1KcVk
	 9rW6sZML2EGxO6+AjUpVILoQh7hFkV8nRjOP9PrDW69mIXxGpDKYulpnhmtk3w9Tvng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZftKnKd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5A606A331;
	Thu,  5 Nov 2026 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZftKnKd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561001F000C1;
	Thu,  5 Nov 2026 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793893382;
	bh=bAXawh5S7drxX+EPOw/4ofsw6RsYMvWUKGvcLmgP8Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZftKnKdao7RxlcKmAMQj/7v1zV4B+S+AvQU83UluXGtJL+gdu9lCohzUdr9uMq2I
	 wY42yu0ojqRZ06s2I6UpjYx3AAmvIBt020+sTEZhcSo/hNjVB7+yf80COY7aUtPl7/
	 RHCG3Kd3PF8FIo6k0DURa+ngYQJpCLA1WbGxqx7E=
Date: Thu, 5 Nov 2026 10:43:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <2026110558-tartar-juicy-036a@gregkh>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
 <2026110526-aerobics-correct-4c06@gregkh>
 <20261105131856.GA8298@unreal>
 <20261105140352.GF3889730@ziepe.ca>
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
In-Reply-To: <20261105140352.GF3889730@ziepe.ca>

On Thu, Nov 05, 2026 at 10:03:52AM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2026 at 03:18:56PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 05, 2026 at 08:12:51AM -0500, Greg Kroah-Hartman wrote:
> > > On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Convert the PCI specific untrusted to use the common device trust
> > > > level. Adversarial means the same thing untrusted does.
> > > 
> > > What about for USB?  Will that "move" to use this common trust level?
> > > If not, I don't think it's very "common" :)
> > 
> > It supposed to work for all buses out-of-the box, at least this is the
> > intention.
> 
> You mean DISABLED/FULL should work with this patch series on USB
> right? Meaning the core code will not bind a USB driver when DISABLED?
> 
> I was wondering if some of the broader things we are doing on PCIe
> also apply to USB, like device authentication. I don't know alot about
> USB, but I got AI to help me find some relavent spec information.
> 
>  https://usb.org/authentication
> 
> This looks like the parallel to PCIe SPDM device authentication. I
> would expect it to work broadly the same way as PCIe if anyone wanted
> to implement it:

No real need to as no one actually made a USB device with that spec :)

There was some patches on the linux-usb list 6 months or so ago to try
to implement it, but it stalled due to there not even be any devices to
test it for.

> 1) USB discovery discovers authentication support and creates an
>    attestation subsystem device for it
> 2) The struct device starts up with trust = DISABLED
> 3) Userspace runs the crypto flow through attestation subsystem. This
>    is extremely similar looking to PCIe SPDM:
>     1. GET_DIGESTS -> device returns a hash for each certificate chain
>        slot it has.
>     2. GET_CERTIFICATE -> device returns its certificate chain, read
>        in pieces.
>     3. CHALLENGE (nonce) -> device returns CHALLENGE_AUTH: the chain
>        hash, a salt, a hash of its descriptors, and a signature over the
>        challenge and the response.
> 4) Userspace inspects the above and approves the device
> 5) trust = FULL, driver is probed.
> 
> But I supposed Greg is asking about /sys/bus/usb/devices/DEVICE/authorized ..

Yes, that is exactly what I am asking about.

And I know there are other types of devices that will want to use this
type of thing (i.e. SPDM seems to be spreading to other new bus types),
so it's good to have and get right.

thanks,

greg k-h
