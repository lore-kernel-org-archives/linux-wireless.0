Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793889880;
	b=XSQiNwUw+vt9mjOUKSLVr4N9hfbbpLjKdIrLLP8OnWOh5aAw+2KYkDrZUJq2I+5HlV25
	 DvvgTGx8ez0GMqXhHQeLvAlWMFfdhyJGkgoqC+WDNf78DWZQ3I7FgAcVOjP0/cxOx6y20
	 AL0uCTQzK13hNNEBrP1k4UFVRUuxMGSH9U3Jx6r41STiVS1dWcdWnzApAmtEBk4PdLbi9
	 F9nJoa6qtYs1+Qup/26iK8oqueSq7+mycyLd7zaKd3Mp579VQDAqSBGS8bwPwU26uz+Dj
	 NyH76mGop5JVOE9Pc5G6ka6UqRRWt75OkwMGgsX5YiF9S3mk1Ad0XzLQgjdSZw1YTkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793889880;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=EWwMu9gaBRMOSzV/4G3fbg1rV1925IYruXnqky/bmUo=;
	b=dOVEF8o4HCndzhOjHvCbYtqD3UbschVxLm0Yrl+PIodB6FzgxlNCX7TO96zcQe6jKHsh
	 d67zS9BLvZ6n33sc6kRj6GdAJAh4h5CkUFS4T8UPy7ABN16wAxEbnYycfmGL13ZKkNffB
	 7rNarXRBe0wb8SwYWGc/nTk12dHR2M8SUu7WuEBlwdd909l7KIK7+uRosM/BruFaQ51cg
	 uDOvXRAJY2LKj8fFMZbXS8HBFCtT22wPyYfxPLPF2W31nPGUAWUsYYnMIcfrrUhvzSm7V
	 jGulQ8xONsLtru1z6WZaxiMYN64RsMcSxLmtcyf+JUT9MvSYLuOgGIiFd61hgdq2DLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97C4606A332;
	Thu,  5 Nov 2026 14:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B97C4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=EWwMu9gaBRMOSzV/4G3fbg1rV1925IYruXnqky/bmUo=; b=uh6gWGZxzH/waVbLrmPklKtBNJ
	6wOYmWomrUFQ8/UkMzR1teAAUIA0Mk0RyK2H2lwMScPZHQEUXeBgTnViHak2nIWwJ/yLMZgKiJUko
	wxGiKspttlJq1BnxyjVTEGK1dnHu06AaKVR2E5Gdk0zcAzNZEkey2bfbvx3nyPNoTYT0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xOygz-00EaZR-NP; Thu, 05 Nov 2026 15:43:53 +0100
Date: Thu, 5 Nov 2026 15:43:53 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <54c9476c-9f76-4ea1-a73a-c9937d6b463c@lunn.ch>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
 <2026110514-bunkhouse-handset-6a3a@gregkh>
 <20261105132729.GB8298@unreal>
 <2026110535-engulf-precut-cf10@gregkh>
 <9d896ebb-6892-4cac-a7c5-41def47f0be0@arm.com>
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
In-Reply-To: <9d896ebb-6892-4cac-a7c5-41def47f0be0@arm.com>

> Yup, and that's true even in the PCI TDISP case - there's a major amount of
> "communication" and "configuration" involved in that. The principle which
> should (hopefully) generalise is that a bus/host controller driver can
> always interrogate its child device to perform whatever attestation and
> general configuration is appropriate, but we won't hand off any _control_ of
> that device to a specific device driver (nor enable potentially-impactful
> bus-level features like DMA, interrupts, etc. if relevant) without the
> requisite agreement between the bus code and the user.

Maybe it would be good to list subsystems which the bus driver can
use, and cannot use.

You list interrupts as potentially being dangerous. What about reset
controllers, GPIOs, regulators? At least in the embedded world, the
bus driver might need to enable power, set a clock ticking, and take
the device out of reset via a GPIO, before the device pops into
existence and will enumerate on the bus.

I don't see why interrupts are dangerous, which makes it hard for me
to determine if GPIOs and clocks, and regulators are also dangerous?

   Andrew
