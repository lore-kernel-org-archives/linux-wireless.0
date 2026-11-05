Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793890253;
	b=YaP/OSMxw07/YYvPoYskwYy09LKQ+VkcUBLm2sap8KhPagUvcASBwGAX5CbBS/8pMgo1
	 EXBu8vTh9DPwep2IzHBCjQrOpkgahLn2J4tNgR2LLMprj2nwONX4qgOZiWt50L2E09syZ
	 ewlTL8xmv6WuiMCCXkdgxqLU4UnH1Xkq/Wh88r8BPsVsSe3iD2OngAMCyKGEdENFN4Jmg
	 GZ/UH5JF2eSLs66f4T6QopIiAXHkVdCYyKxBgn2NecUCxjKv0srd67uzcqLF39hfsywVA
	 n4/7uY8b6Vbvrpc2ayupyCf2Xky22AYx6/mQbeOXOckX3dySoQGRv4o/V2dCLXKIbdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890253;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=0QVs4UmW82faR41mfhaV+h9cFqICsfNx9N9UbV3NoAI=;
	b=ra2CnasgvyUHBmR29AY4TKSkNzceAQhFfsISJ61slGBQ8mb7Mz6zDsV0Cd7Im6D/b9a1
	 YMclkrH4N5DgFwgdSbLePiFf8QL/LexwFaxBAi+ZA5/EUrxAMtzMTDVvbpyb8BPCGTLDz
	 0HKCPXcfwKxgtXotgDJ7mpxj7L0QBB782vG5G23qYmdEMwFfNQHNugIpBvAzOed3RtCBG
	 WQYVkmbCJdavs0dIbd8edC/VPoczBZmJhtPsVZfDX7bG6C3gqFxQ7etazzG4oeQoTWWs/
	 90lphiPYNDCTzo2VSB3rwmAAhs5bZgT4xK7Nfqto2dhQlG1mVi/l9f/a+cszECBNAlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=DNoY4vhi;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCD1606A31B;
	Thu,  5 Nov 2026 14:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCCD1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=DNoY4vhi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=0QVs4UmW82faR41mfhaV+h9cFqICsfNx9N9UbV3NoAI=; b=DNoY4vhiJHpefpc0K6k4ZEejnE
	z7BMrzdQ39NWlIM0NCy3i0azEyJUm7qdCzDTWvFOnHtGFFojpS2FV6+ZhBEddcut8CT3kNR7w9vtJ
	EbHP1y7vEIfqNZfBSV2OfralcPASt52j8xroqTNGzcNbawSyJl9tZWOJnJhANmXQBWjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xOynT-00Eacz-Jh; Thu, 05 Nov 2026 15:50:35 +0100
Date: Thu, 5 Nov 2026 15:50:35 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Leon Romanovsky <leon@kernel.org>
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
Message-ID: <9866a873-e71d-48cd-9153-be1bfce51eda@lunn.ch>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-3-1e536825b4eb@nvidia.com>
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
In-Reply-To: <20261105-device-trust-core-v1-3-1e536825b4eb@nvidia.com>

On Thu, Nov 05, 2026 at 01:42:16PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The generic PHY fallback probes directly before publishing its binding,
> bypassing driver-core admission and supplier checks.
> 
> Attach through the driver core so admission precedes functional setup.
> Callers hold RTNL, which a concurrent bind of a specific driver may wait
> for with the device lock held, so for this flow let's add
> device_driver_try_attach() so the attachment never waits for that lock.

FYI: This code is fragile, and causes issues. I will need to stare
long and hard at it before accepting it. So i'm unlikely to do that
until the basic idea is accepted.

I also wounder how a PHY is a threat. What is your threat model for an
Ethernet PHY?

      Andrew
