Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793904313;
	b=k1j6T7TCGNJZhJUxFcC9Tx33kQyoqGHuZDthqIznaUJknPbcbtgGfLqq3kR7of3yTZP9
	 8ham/Ed6NhU1DmO1Zf1/yDqFbYWD7X6XRChTfsqfNz0XtJ6Q7FZzOFvv34IFBZLvHUqXA
	 WA9CzZt97d6LCTGIFy1WDYyjennH2uP93blVmjMXvkDqGqo8mm7d1WBvYiEvl398yMXq5
	 MzNLhlTZDiv9+YN47THOIUCGl83fdOz7Yx1s0hdjuRN1sG+xfgOuNpgyq0MN1pIEb7+zV
	 i7VAuJp0Ee2lBFxjArOYaMwSuh7Fr83e3kKo1BIhn1IRVvZnLWj7PpiuR/Fj9HWqsCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904313;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jkpPiFVr7OW6ZEzjFrqd12ut3tCHk/x8MPG6zAwfo3U=;
	b=YLLeNP1MikpaEdsnHqnJwla+FrRltTlOrPZvW3dgLszOqI/84AS4WMWFUgEGy/GCDWzW
	 Is/QVa3yv24vdUffRu96Mz/SoDk0bT+Q+itifWA8JvQnqF65/a70nTqPI1OvHZvIMyaSc
	 3KkYwdyx7PjsUVBPeR0yGd1JUnD/EP5A8QF3yuj0lPfue8+m4WAg03FEco2oLhUIpwhOX
	 rI4Tw6+EZY7Bwya3R53ucUNrc/qJ9vui+RQfxHMDRgZGIoeY1S93YhZPWj6tCELmwD7Pv
	 0Y7+dKRyXa1hgTA64H7Q4NGsuheulwgrT6QLiMktq1JIEx4PCKPCPZ3McmdZ2py7K4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+7DYonu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DD6606A328;
	Thu,  5 Nov 2026 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+7DYonu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F951F000C1;
	Thu,  5 Nov 2026 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793904313;
	bh=jkpPiFVr7OW6ZEzjFrqd12ut3tCHk/x8MPG6zAwfo3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j+7DYonurptTS7RzehMTEgOf9wG1aTqlc3KnZ72twymaiKE+9aaBYh4ZR3xt9nwNf
	 iPjcUqWcJJ/TmuZv4J0TW/MfZzL1KxNLzAq7nsspdZ5FXIWfuTZOkiEAlZtR7n9DdW
	 ic9w1kQ20zqlN4LBXtj07ur5q/WWXz1omMrRq26pEHJDna0AFm7GyILUQ0FHnuOf+M
	 NQK5SJ63eAvkrMwx24rKRR8KylGEG42KDpwihrgODiDHvL4S+o+OKBmpU1n8U92Pth
	 Pn2qD0Tss9S/1Vhg/R897RmGAOSKMYMQlnIlTHfejgwSx9LkiSKJdcBI+9MDWSnnGH
	 mM0tVYrycArRQ==
Date: Thu, 5 Nov 2026 20:45:10 +0200
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
Message-ID: <20261105184510.GG8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-3-1e536825b4eb@nvidia.com>
 <ce4a9030-be44-42b6-ab5b-b830bce3502b@lunn.ch>
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
In-Reply-To: <ce4a9030-be44-42b6-ab5b-b830bce3502b@lunn.ch>

On Thu, Nov 05, 2026 at 04:33:48PM +0100, Andrew Lunn wrote:
> > +		if (err == -EBUSY) {
> > +			/* Another bind owns the PHY, so nothing was probed here. */
> > +			irq = phydev->irq;
> > +			err = -EPROBE_DEFER;
> > +		} else if (err == -EAGAIN) {
> > +			err = -EPROBE_DEFER;
> 
> You cannot return -EPROBE_DEFER here. You are not guaranteed to be in
> the context of a probe. Very likely, you are in the middle of the
> ethernet drives open() call. Both probes happened a long time ago.

You are right, thanks

> 
> 	Andrew
