Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886009;
	b=riNk18jN0Uk9EyG+K8oSXzTQLQ9shgoQIjRFQZxs52gpv3PTtUXPhRhwSVIpSC1o2yPX
	 1dz/88EKBqjfOOZ1YbFpJrl+YXkkK9HHuMVBfc39b/iLbpXTFBxBVYA2DB0QUpKrjHmY0
	 MjsljcKJV14SSp6EVPASUl329SLwzmEUpK3Pr66p6qvnf5QrOMLSOCYmuSuyK7Xti0y7+
	 nfJVUQqCHoToaAJWdghqZfjuE/keA5n7TyM4nN5yyy54yTOuxfuLecPaD3XFdRBgN8II8
	 X4tjowkBDiXZvXeVu2X68dfqPvMQc97LwF67seTZX4zaNa/lUSFBIch/C4B72Y3696w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886009;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9+UbOEVQarBwBm6b5bYOw2XOpuvruf9mn1tJnCVUVIk=;
	b=i6hFQe9727tBFAOnHmvxx4Z0kIbp+TQsWkgNqVfawWqVbrEOCD3wEd5MpSmLkn6SrkQU
	 V6snaUxdP4rGlIGtau03mYhW40PojMesO3csZSzZ48o9dzT6VE1skuC4jJNq0SR9Sx3j9
	 oj5E8M31DYb7PF1ft6ar55s42m7fJMrhf/Q6v+GhFDmo3SjKzITonu2ceSHoqJjnCR+V+
	 Rb8SAspNf8AdeXpVSo04VEs90ahihxrYqPv6H5cKaJCkIutGFgcAJ7cvBJusju4mCtiBO
	 krJnoCM2Q0gGFqmd3ObfijlrUObgVSNCJRWWEjO4CT17Gpe7CZOmFvzGomR+AJjJ5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBz8uxXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B08606A329;
	Thu,  5 Nov 2026 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBz8uxXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BDE1F00919;
	Thu,  5 Nov 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793886007;
	bh=9+UbOEVQarBwBm6b5bYOw2XOpuvruf9mn1tJnCVUVIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VBz8uxXNwa7SsiEgUvH+3f/5pzMeAXzuPJfJv7a3TMn+66NkgpJ44A/orn0fkJ2QS
	 yZw9C9UyZ7tniVuDeilS+rbpMsw5k/+W7UGEkOXOJlA1XIA0ZbDi+IvcuUobwIP7Pg
	 7XGWYDm0VJNw9T3Ljld4cEE/QGUaahpZg4+sR1RQ=
Date: Thu, 5 Nov 2026 08:40:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
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
	iommu@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 10/17] driver core: Expose device trust authorization
 through sysfs
Message-ID: <2026110535-engulf-precut-cf10@gregkh>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
 <2026110514-bunkhouse-handset-6a3a@gregkh>
 <20261105132729.GB8298@unreal>
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
In-Reply-To: <20261105132729.GB8298@unreal>

On Thu, Nov 05, 2026 at 03:27:29PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 08:10:14AM -0500, Greg Kroah-Hartman wrote:
> > On Thu, Nov 05, 2026 at 01:42:23PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > An initrd must authorize a disabled device after attestation even if a
> > > built-in driver already attempted to probe it.
> > > 
> > > Expose requested trust_policy and read-only active trust. Allow explicit
> > > disabled policy to advance once to adversary or full, fixing that decision
> > > immediately. Reject later policy changes, including for a device claimed
> > > before registration, while allowing same-value writes on live devices.
> > > Keep initial unrestricted selection separate from explicit authorization
> > > and bind-time commitment. Serialize writes with probing under the device
> > > lock. Include the attributes in device ownership changes.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-devices-trust |  51 +++++++++++++
> > >  MAINTAINERS                                   |   1 +
> > >  drivers/base/base.h                           |   6 ++
> > >  drivers/base/core.c                           |  15 +++-
> > >  drivers/base/trust.c                          | 102 ++++++++++++++++++++++++++
> > >  5 files changed, 174 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
> > > new file mode 100644
> > > index 0000000000000..97e07a174769c
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-devices-trust
> > > @@ -0,0 +1,51 @@
> > > +What:		/sys/devices/.../trust
> > > +Date:		September 2026
> > > +Contact:	driver-core@lists.linux.dev
> > > +Description:
> > > +		(RO) The active trust level for the device. The values are
> > > +		"disabled", "adversary", and "full". Driver core resolves
> > > +		the level before DMA configuration and probe, and retains it
> > > +		through removal and DMA cleanup. Outside a bind transaction
> > > +		the level is "disabled". This does not imply that policy is
> > > +		writable or that the device has never operated.
> > > +
> > > +What:		/sys/devices/.../trust_policy
> > > +Date:		September 2026
> > > +Contact:	driver-core@lists.linux.dev
> > > +Description:
> > > +		(RW) The requested trust policy for the device. The initial
> > > +		value may be selected by the bus before the device is
> > > +		registered; otherwise it is "default". The policy is resolved
> > > +		to an active trust level before the device is probed.
> > > +
> > > +		The values are "default", "disabled", "adversary", and
> > > +		"full". "default" lets the bus select the active trust level.
> > > +		"disabled" prevents a functional driver from binding.
> > > +		"adversary" requests operation with the restrictions that the
> > > +		bus and DMA layers can enforce for a potentially malicious
> > > +		device; it does not isolate DMA by itself. "full" requests
> > > +		normal operation.
> > > +
> > > +		Before an operating level is committed, policy may change
> > > +		freely until "disabled" is selected. Explicit "disabled"
> > > +		blocks binding while allowing a later write of "adversary" or
> > > +		"full". Repeated rejected probes preserve this opportunity.
> > > +		Authorization immediately fixes the requested policy.
> > > +		Returning to "default" or "disabled", or selecting another
> > > +		mode, fails.
> > > +
> > > +		Successful resolution to an allowed level commits policy
> > > +		and operating level before driver or DMA setup. Both remain
> > > +		fixed for the device object's lifetime, including through
> > > +		failed or deferred probes, unbind, reset, and driver reload.
> > > +		Later binds must resolve to the same level, including when
> > > +		the policy is "default". A resolver error or disabled result
> > > +		before commitment leaves the policy's writability unchanged.
> > 
> > I understand you are aproaching this from a PCI point-of-view, but many
> > busses do not care or have DMA at all, and need to actually talk to the
> > device before being able to even "add" it to the kernel.  So you are
> > making a driver core-specific policy based on mentioning DMA here, when
> > really that should only be a bus-specific thing, right?  Some busses
> > might require DMA to happen (i.e. USB needs their host controllers to
> > use DMA to even talk to the device at all).
> > 
> > So can this be written to be more vague and generic and then put the
> > specifics in the bus-specific portion?
> 
> Yes, of course. The main point is that drivers must not communicate with
> or configure hardware before attestation is approved. DMA is the PCI
> way to communicate with hardware.

That's a very vague statement of "must not communicate with".  Busses
HAVE to talk to the device to determine what the device even is before
it can add it to its internal bus list.  That's just how the hardware
works, you can't say "no talking at all" otherwise that means that you
never even know if a device is there (and for some busses, you'll miss
the device entirely as they can only be found when the "host controller"
tells the kernel that a device showed up, not later by manually
scanning.)

Think about reading PCI device ids, or USB configuration information,
that's a bus-core thing.  Are you really thinking that non of this can
be read from a device under this "policy"?

thanks,

greg k-h
