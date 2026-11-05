Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903715;
	b=Z5pYD++vl6iO91Z3cgZkDRwREoyCNa7L/pAFkN03Zapl79e9Gd+kYQMigx4t78BogVkX
	 y6oPt32XwFsnZAdV8TZh0ESwsqGuQYwqGq1nVJpYDlERv9356qG8pmAuYDj642VFiwcEK
	 dRmEAGDeI03LU0/zX33ESfCEWRXOF9q5HqG0lciDQ3Gurn4DeB1TVpyZVJ3ZGC6RgFhkh
	 p7Sg8DmFWqAkr00YPGQToi2SeaTGtEuFp61Htth6ol6UPlUIGKDQG/yGFPVWu9oVAIJo5
	 VyHokX+n9nGERWSRBfW6INUFiMQtj03ftXY+aeqR5KMSGgd/WRej/bDmknI+3nUDKhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903715;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eu0Jx463SVZSBII0hnmMnU2aWA+n3XFJpC/YB1CnfNs=;
	b=zUAwMFFwI42T5qXTkF38FLb+wtix/cWstMdLopqcg4C/OFT/ztLaPBgA407jcaPNgJ0Y
	 /ouMnxWnZBY9KxeG6U118mRVLLJ6SLLb3XmyDkfeGbva07rnrfJdK8PaSS/msONNhy7MA
	 i8HNUY9uJ2w8/wMb+cltfeIIOvFf9RmOL/rYUWklRM7CD12fkz6QmMQsVawbifaOmhP9E
	 IZDXHBuI3IfyaHD4QwZWLPpF4W1kDIqahJCwUVpwFhqsFErpbTzdSQVPIZSLChxXKwTb0
	 zdVh/veeesm5Ab8GNu3nm8fMR78MJxHL6wZ5eFlFSsIQB3GIilLAYV5rxKMCmjmBsBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aLY3g30d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F6D606A31B;
	Thu,  5 Nov 2026 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aLY3g30d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8147E1F000C1;
	Thu,  5 Nov 2026 18:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903714;
	bh=eu0Jx463SVZSBII0hnmMnU2aWA+n3XFJpC/YB1CnfNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aLY3g30dLKBuWsWBkUMgULwEU6A7srUzOGRWXrQBpz1o9mVmcB0XEsZS9PgzsCskI
	 mTdR296HvEdvgv5e8dlypLleVdRgAieM1fqfROu89knGdcktbTpf2wPH0vieUv8Zaf
	 q7eTideU1qc7O/4NoJf5h6S203jDcddohITPddb/Ah2R7zJ9VSOLNa0XVgdsQGlTj7
	 FpmA0nj0w3H+/n/QBvZwX3Nzu6Yh6Wxa5DFnmxC63RoXrcgWmVycmheYAQIpy4wTn/
	 9ig2A747T+VoI19eE8rGolCQZ885lg2Jj8Wmj5RNXFOPAivQfPadCLbnwUFLW4/Oec
	 bewdzKyKGqJTQ==
Date: Thu, 5 Nov 2026 20:35:10 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Subject: Re: [PATCH 03/17] net: phy: Attach generic PHY drivers through the
 driver core
Message-ID: <20261105183510.GE8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-3-1e536825b4eb@nvidia.com>
 <9866a873-e71d-48cd-9153-be1bfce51eda@lunn.ch>
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
In-Reply-To: <9866a873-e71d-48cd-9153-be1bfce51eda@lunn.ch>

On Thu, Nov 05, 2026 at 03:50:35PM +0100, Andrew Lunn wrote:
> On Thu, Nov 05, 2026 at 01:42:16PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The generic PHY fallback probes directly before publishing its binding,
> > bypassing driver-core admission and supplier checks.
> > 
> > Attach through the driver core so admission precedes functional setup.
> > Callers hold RTNL, which a concurrent bind of a specific driver may wait
> > for with the device lock held, so for this flow let's add
> > device_driver_try_attach() so the attachment never waits for that lock.
> 
> FYI: This code is fragile, and causes issues. I will need to stare
> long and hard at it before accepting it. So i'm unlikely to do that
> until the basic idea is accepted.

In order to accept basic idea, we need to change PHY code hold device
lock when binding the driver.

> 
> I also wounder how a PHY is a threat. What is your threat model for an
> Ethernet PHY?

There is no special threat model for X or Y. Everything that requires
drivers to be bound are expected behave the same - honor trust level
policy.

Thanks

> 
>       Andrew
