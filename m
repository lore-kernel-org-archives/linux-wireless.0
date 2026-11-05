Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793885208;
	b=SOnnaYLODBYMb+jdSM/5spVGeQcBaSHlYbpsTRhT3Qk796EtK0L6BUivQk+NL2pIaCxT
	 xgxr7vjmE54RkRqTkZnqxbek9WeEk6Ct+xzvzdqkzEdDVnsTpQix7aBckUvieCj1m1e8n
	 ZQjXHWJdbEjsXNoD3D9wNAi+6oFqGinOmqwXqRu6ufHmRaJBKyNdp4S1nBRyC0x3C7WEa
	 b7hmHCHOOVb5ikHDwbTkIQwwqO2FPWG9VajWbpgZGRUp+J0wC9TYeI0PccQ3+GAwIgQ5/
	 0nGnY483ykqi+kQiJ4LVMq0/JBtkUL2jEii0fRNdFgDHBSEynyKkGpe5Uw3Lt/ken+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793885208;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K8lbO90vzy6olFUe9lmPis5mVLiZe2cP2PRWjkppNDY=;
	b=p5Mwm8fNekwgSreZIxQyAXEPjPA7mXxujOJKwaPb+BLTxzVLvV3SoSFlz8C/sfQAvZ2R
	 rcI/0N2VnT9h5YHm6KL2mjRP7pGTYKYW2vzh6oxdl8HMezriEo+udowBV2bxDTDLB8CzB
	 thNCjWbm0yfM3y5SxrOa0UrFKPdXGZ/KLf+8HBg+sjVqlVsAqKZDiXI5dy3ZG4RkQZ9Xs
	 Jn36WmHpkg+skT/G5+yCS/vTbg1shJwLJg+yDlJ3qVqL+kXESffD4lwUb2vwf8YNmmFB8
	 MzyaBsarIgewwy93Z8Zrs3Vm2AOp5fp3NVoY1GHzElD8j6mi1xW4BMSR+sBRJVYlhNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7ThB9ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4802606A31B;
	Thu,  5 Nov 2026 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7ThB9ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5541F00919;
	Thu,  5 Nov 2026 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793885207;
	bh=K8lbO90vzy6olFUe9lmPis5mVLiZe2cP2PRWjkppNDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D7ThB9ayPdl2LJnqoFtsjCmnzSoG5Gqhu7NLtObacUyrY9zpyXDpg38NCbfszRpZL
	 jf2nqznFFI2FxF0X4oRKHOE/93FDRhv7xLdzk4G5QXJOJcrv7OKx+ua/p5q6y4dfKj
	 ZhF+jHvFG9z9rebHSvb89Dvk8lxDUh4Y5Z6k4skc=
Date: Thu, 5 Nov 2026 08:26:43 -0500
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
Subject: Re: [PATCH 17/17] PCI: Replace untrusted state with device trust
Message-ID: <2026110557-outshine-surcharge-9ef8@gregkh>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
 <2026110526-aerobics-correct-4c06@gregkh>
 <20261105131856.GA8298@unreal>
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
In-Reply-To: <20261105131856.GA8298@unreal>

On Thu, Nov 05, 2026 at 03:18:56PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 08:12:51AM -0500, Greg Kroah-Hartman wrote:
> > On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Convert the PCI specific untrusted to use the common device trust
> > > level. Adversarial means the same thing untrusted does.
> > 
> > What about for USB?  Will that "move" to use this common trust level?
> > If not, I don't think it's very "common" :)
> 
> It supposed to work for all buses out-of-the box, at least this is the
> intention.

Great, did I miss that patch in this series?  USB already has a "trust
model" so how is that being handled here?

Note, I just skimmed this, sorry, am at a conference right now, so odds
are I missed something...

thanks,

greg k-h
