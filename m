Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884740;
	b=rPzj/V3u6DSJUR4rTi/nts9xBZXdQsOiETNvpVSxjoUbuaFYDJ9c6hy8UrZf2QfrDL8w
	 kzq8lG8G4SrHCMKzjoXHQamPumjHiKFruH1oCzq6NWsbHVYNShhLZQwkbHOrB9acg+qEX
	 wn7Rq2L8Yd3xAuhS5HjdxICXuI68rTPQglR9/VieMoXg6jKh0inUIK83RoWuWWAtLcCZB
	 7dYCwFWj7gXaqQbDERQMXD18iQKseCiezty/deBVMOuBoc5V7bSVPfqMtCd13vNAFdhmt
	 zAgtGiqR0mKgOnrReS455S3VnVgH8QPzxPMR2cvkTap9OJcVjWWNM+bvdnmlX1DWj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884740;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S6rz4FZj5rTnSNK8MJPlFsZu+Zeq6pEytkN6THvBd7k=;
	b=2WY4OX58CEYxfhjpChuEbnnF0m9MXni2Kr1mIehI/ElKtdmDdiCX9lyxGHaq9P+xQqa5
	 7eFD1QY/HApNwk7v/DTJ3y+xVPNh4L8+6vhWMUs/WJzQbktOJHN0PLoyeiFhFvzfEFoVo
	 /X+v4lysiit4h9S0BbVxNcuN/ChzKywmAP3CiUHOprbVToa3xJ+IuZtas1CHmrgKt92tg
	 ZYSQkck251GTGmY9s9s10Y/qetwMxJFI9Q4g/2TfJ1RfdulG1tVJYheS6tPq9g4B7fwed
	 GOZLWPZzekJwlZDxt60qHTNyilziTK6K/c9Hq6rsNXaOtqi+sMX53f3hnn3sFahl0xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uhwiifo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B410606A33F;
	Thu,  5 Nov 2026 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uhwiifo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E1B1F000C1;
	Thu,  5 Nov 2026 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884739;
	bh=S6rz4FZj5rTnSNK8MJPlFsZu+Zeq6pEytkN6THvBd7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uhwiifo0Hi+j1kx/dbDda7aCN7DTppcHCIzY7h/zM/Z1pAFHnebHqJSYNrbaD36DG
	 tDejXiN/viK0rOnz32UeKvtW1RosJ+aSUAmqKIGbf0hXcbZvMjlPD7bsnz6wrMp90+
	 2xGq9WBpCCgB3VNgGcqb0FWxjFp1trSuXD9IeiNXOx3L7OQNw6gB33p+8gm9qD9GBk
	 2aLam93FUFR/HAoBnrOCiKNp74ACiR/eg1U7WbopKhFM+UxOin49FcsHXcNh3445FC
	 MgANafQG/Q0TMHiEHrZOiYGpNacotloKsLybtuhA0mCCZTOY28eASo977WuxLJso73
	 iIOq8I/fyWk2A==
Date: Thu, 5 Nov 2026 15:18:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20261105131856.GA8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
 <2026110526-aerobics-correct-4c06@gregkh>
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
In-Reply-To: <2026110526-aerobics-correct-4c06@gregkh>

On Thu, Nov 05, 2026 at 08:12:51AM -0500, Greg Kroah-Hartman wrote:
> On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Convert the PCI specific untrusted to use the common device trust
> > level. Adversarial means the same thing untrusted does.
> 
> What about for USB?  Will that "move" to use this common trust level?
> If not, I don't think it's very "common" :)

It supposed to work for all buses out-of-the box, at least this is the
intention.

Thanks

> 
> thanks,
> 
> greg k-h
