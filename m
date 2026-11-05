Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892849;
	b=xBbIj35YH4GZxFj02vfjZnSqaiaW4nNnIsNfctHzHsXPzns+2hiGwOiMp7IKxC0GT2Pg
	 m+w1PcuxV/XpKci/sCPlsShVBD6smZvu6WOmDHcmh8guDWEL7mAH8yJfISwytaYUPc10B
	 pkTNVNbWh+3QhtRRn/F3QeVXMpdL16HfT8IBIX9oAkSMkO9omjXqzX+NvS253pIT+aeBA
	 RRhI4etGSBRXwXq0bZfDD4FjG4jLB94tXMTyl78q4RqAbs1Y0NF6D2PHHEGLwcgNunOq8
	 vVa1UZkUsRnpvVsxt5I9pua0DjNycZegS5xjd5LZbxO8sEDjl/Qoicxl5x3AwMqUQEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892849;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=ijr6F/dBUmRJj97spvBPIS7/tlKqEqMqai/iwQdyRCo=;
	b=EHqnnUZyMXl3w+Rb+YlP/xVlM8+ume0w251Avpb+OrsRqwpdKKlN4AJiD3iVNrGkWmp8
	 5lcoz8cFO+OXkIMxUk0zY7qqNNn+V/A+NUhhktfyRa5wveIM5L2A+SmHYXuOy/H6au6u8
	 ksW4oyt924NNeWoVyoJkKvViOaE3iIxyD6OlrVvagqFcXIHP7AccBiV6HT67uhWPlbqAA
	 clBqxxFkA/RuC9tNrZZbw/QswEZBpr1d8U6jFw9njPCvAW831l0DXkUoOJe2bfgQ0Kge3
	 ACloQ+PQKFI1l+szvOIRoHZ07OiG6Uw8iKvuomVUEN1NZ62YGIqOEkkgUa2SaQFktjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=XYxmIrQw;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF9606A330;
	Thu,  5 Nov 2026 15:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ADF9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=XYxmIrQw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ijr6F/dBUmRJj97spvBPIS7/tlKqEqMqai/iwQdyRCo=; b=XYxmIrQwIPbNsfXiPYIXrfExh8
	TUhoJNxex2yRRB1kXGbvIw7N+P+eaAOVQ56Zf9TUgqVKiPiyGZxgFyj4/X7cz2isAYd/krAZzgfq1
	dNENDmEZNwaZ4VXIAxHt4t15FKb+RFGgDvKNtgfPhvs4SpOoxBMeYyn81TpqE/fzj9UU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xOzTI-00Eb0G-OQ; Thu, 05 Nov 2026 16:33:48 +0100
Date: Thu, 5 Nov 2026 16:33:48 +0100
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
Message-ID: <ce4a9030-be44-42b6-ab5b-b830bce3502b@lunn.ch>
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

> +		if (err == -EBUSY) {
> +			/* Another bind owns the PHY, so nothing was probed here. */
> +			irq = phydev->irq;
> +			err = -EPROBE_DEFER;
> +		} else if (err == -EAGAIN) {
> +			err = -EPROBE_DEFER;

You cannot return -EPROBE_DEFER here. You are not guaranteed to be in
the context of a probe. Very likely, you are in the middle of the
ethernet drives open() call. Both probes happened a long time ago.

	Andrew
