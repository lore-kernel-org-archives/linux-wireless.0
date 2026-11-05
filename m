Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884376;
	b=EMWDXFMZymxALkpCn+13OjG4vDJ5XAqvRsltNWocjL/yQSVZKrGRnwKIuOt6OQTWOh5o
	 zNvAz5k78RHU30KNYXYtfestWZ8ic+SiiEs03WMJRN5/nEYCwhjwSzDxoR4geYePu3wCp
	 uu4RVN5TdKe7CR7hNZpw9KrfiIy2sWQdPJ4/wOyEVR17ZI9H2ew/e7eDNOutyCD9P1P/r
	 07+Fi2pIBV8ylueupsM27fBpACHD8sDgplIoGoQ2tQmtaNp+nSWq6MloQOCnhtXp3d+lr
	 syTw9Js3mauM5StjSBlVhg5jaeBgLCs0kH4ebR5iCPOuBhGr9Va6RfSLSJy79ixY/BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884376;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=swiKzUgFoctRN+T88E71sWvVJYZoLY7NkpHnIWDgcMY=;
	b=fp5yENuyXd0lXdjbod77Zq07W8GMg5HOR5MhioUhUTGomYvxdGIC6ZeeU+ArXHp9jvU/
	 Z9LTu4shHGVZat14eHMNjY6fabcb01jw3vT/5zsLrLDESWx8pUA9ywRmvg5ME0rsqOO2m
	 E/5lBII9Gbwf9P6Wk1Ysra9ITBqMkKBTOSAzYKYC5MKUTlmNrpv6cuv1YFfZeabE2gMDL
	 veSKCuN7qN1aaB2C/YrNAePMOVmLppTXu686FQNGtZkjcZjJ6QKTs6mXLt61PVMLREokH
	 K7FvCGQpNsA4HWIcT1/zoCXMaTFDO3vjWO77/hbKGnyuCL/8vw2bMLTYrF8sR8SzQdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdbBLgXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB9D606A32D;
	Thu,  5 Nov 2026 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdbBLgXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284341F000C1;
	Thu,  5 Nov 2026 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793884375;
	bh=swiKzUgFoctRN+T88E71sWvVJYZoLY7NkpHnIWDgcMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TdbBLgXr8bDktN0hHOY2Pzjg6mOxuEZNpCKq1KvcxoCQfV9Wnx/qEhukgNrvB95lI
	 S87Sl3q+/JhurIZglvBlEc6kOuzqcODlfO69tYyV1G8Kgpi6kFkKIPQLXG53SOJQQs
	 DiebjZb6eh3Thgp0qS+xBDRJtwqw3dqGfYeXpQ/4=
Date: Thu, 5 Nov 2026 08:12:51 -0500
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
Message-ID: <2026110526-aerobics-correct-4c06@gregkh>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
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
In-Reply-To: <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>

On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Convert the PCI specific untrusted to use the common device trust
> level. Adversarial means the same thing untrusted does.

What about for USB?  Will that "move" to use this common trust level?
If not, I don't think it's very "common" :)

thanks,

greg k-h
