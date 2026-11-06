Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975626;
	b=Z7c2hVuIBjcSvK6tHze21UzbNXrNQwRYF9S8sd5qgmNl4zvF5ZyD7sgsyuBSCdnmjVY0
	 Hp/bUXCansnt/zILvVc4ibJGot6vh6Ymrv5iY6YNYDaQD4XKG5KrcWalb19nCU3adJ682
	 yjN40tFwO39qfUrJ/17wF5o8oSIlqdXeUpJjS2bkhKOAvhZvb1qLJF7vWBLPDWl5061R7
	 56/3ZJRWzI3K7607pFqhMF9E1Rfq8hW89dlPoFWcD6f7ufHBDEEseE1DLENtPyQKWzQKZ
	 ZZSVcoZK7VQKMIv/uT8wLITK5y6+ExFKWX/Dz2Akp+CijXtk78HYYXRaYcVhaoeMlrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975626;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wtqvUty3awL+WV2C4Bd+4jjQ8JiJNaHCJXSR0TJ5v3A=;
	b=yQzm4CfK2F9ZYjA2mIbjoeprcosHEdNNYxr3L1jgrtO4GxgMaTdKcDgd0UTpHBltDfJa
	 ztMhbK3nfnpX+vEilGUwKtzNysu0wPRgSa7R3ovGzSuvI4q085TzzJsYn04ZGMjOrkrzi
	 2B771f91iFKJwlsDgj73cRdrR/U2oswgItNA35M+zz4FwbG/Tq3Sxup4bhnYVzKPWba98
	 oL9SHgc72QDyZL+41/14kb8wJEyGeYJ861q0z2aSBx4lA9bsj/qqjbK7ewW0rOgmU7Ucy
	 ahW+TYvzrjcpLWGapc/60DhflNyRrkyFs6k7kFbujgN43nKwnZt1fzyoQjFBqrrwkTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b2r2H5Bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED22606A32C;
	Fri,  6 Nov 2026 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b2r2H5Bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EA81F0089F;
	Fri,  6 Nov 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975625;
	bh=wtqvUty3awL+WV2C4Bd+4jjQ8JiJNaHCJXSR0TJ5v3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b2r2H5BdxpXdgNiFxLfKLsliHD1aW/wDAEDaKEhpVM3EC5rk9Xr6npFA/IH2FuBji
	 UDxYAgdQaJNICIZINw9Ilbfw8bLsyrsQzWp+NoPqhA/+jsoa6GKznm54YiNoZU+9oJ
	 sKCs6bWl1EjHh98hGORYkKB0GcOkK/HjEQjgTReSqakMKK6efSYleyQ6zh8ZhPS7y0
	 0wS9qzyBqM/XWz66nB/U7xvUJNcHVDCJop7XlyB7M2TSiH7wu9UstnvOKKmLIrUiaj
	 f3Nh+j2TKg+aNrfLE9k32yn/pJAm68XoJQeSANboxqzmkjEzD0Fm3hpnEuFuKwhEfE
	 9n14k2PzJGEaQ==
Date: Fri, 6 Nov 2026 16:33:40 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH 02/17] Input: serio - attach manual drivers through the
 driver core
Message-ID: <20261106143340.GL8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-2-1e536825b4eb@nvidia.com>
 <auy2plYVi723Qt42@google.com>
 <20261105191940.GI8298@unreal>
 <auzno3uoL5Pfojfl@google.com>
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
In-Reply-To: <auzno3uoL5Pfojfl@google.com>

On Thu, Nov 05, 2026 at 12:34:53PM -0800, Dmitry Torokhov wrote:
> On Thu, Nov 05, 2026 at 09:19:40PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 05, 2026 at 09:05:29AM -0800, Dmitry Torokhov wrote:
> > > On Thu, Nov 05, 2026 at 01:42:15PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Manual serio binding connects a driver before driver core can admit the
> > > > device. A rejected binding therefore arrives after functional setup.
> > > > 
> > > > Keep the port ID check and use device_driver_attach() for the existing bus
> > > > probe path. Driver core then serializes admission and handles probe failure
> > > > before publishing the binding.
> > > > 
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  drivers/input/serio/serio.c | 24 +++---------------------
> > > >  1 file changed, 3 insertions(+), 21 deletions(-)
> > > > 
> > > > diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> > > > index 54dd26249b027..604440244c1ca 100644
> > > > --- a/drivers/input/serio/serio.c
> > > > +++ b/drivers/input/serio/serio.c
> > > > @@ -81,28 +81,10 @@ static int serio_match_port(const struct serio_device_id *ids, struct serio *ser
> > > >  
> > > >  static int serio_bind_driver(struct serio *serio, struct serio_driver *drv)
> > > >  {
> > > > -	int error;
> > > > -
> > > > -	if (serio_match_port(drv->id_table, serio)) {
> > > > -
> > > > -		serio->dev.driver = &drv->driver;
> > > > -		if (serio_connect_driver(serio, drv)) {
> > > > -			serio->dev.driver = NULL;
> > > > -			return -ENODEV;
> > > > -		}
> > > > +	if (!serio_match_port(drv->id_table, serio))
> > > > +		return 0;
> > > >  
> > > > -		error = device_bind_driver(&serio->dev);
> > > > -		if (error) {
> > > > -			dev_warn(&serio->dev,
> > > > -				 "device_bind_driver() failed for %s (%s) and %s, error: %d\n",
> > > > -				 serio->phys, serio->name,
> > > > -				 drv->description, error);
> > > > -			serio_disconnect_driver(serio);
> > > > -			serio->dev.driver = NULL;
> > > > -			return error;
> > > > -		}
> > > > -	}
> > > > -	return 0;
> > > > +	return device_driver_attach(&drv->driver, &serio->dev);
> > > 
> > > I am not sure how safe it is, serio (and gameport) have pretty elaborate
> > > structure and locking rules because they can recurse into themselves (to
> > > support case of Synaptics touch-pads with pass-through PS/2 ports).
> > > 
> > > But this call is for user-initiated probing anyways, I am not sure if it
> > > even needs "trust" handling.
> > 
> > This patch does not change the locking; the lock was already held on paths such
> > as the rescan path. This change makes that explicit.
> 
> Does this enforce synchronous probing?

No, it ensures that a device is bound to only one driver at a time,
without races.

> 
> Anyway, I would like to get rid of this special probing in serio core.
> Given that the code path is only triggered by explicit user request I do
> not believe we need to worry about supporting trust notion here, so
> please drop it from the series.

Technically, this is exactly the flow we should be concerned about. Users
attempting to load the driver generally don't know whether their device is
trusted; attestation software is responsible for determining that. I modified
serio to ensure that driver attachment happens under the driver core lock.

One idea I had over the weekend was to introduce a special API for driver
attachment that says, "I don't care." It would allow attachment only in
"full" mode, as it does now, and fail in any other trust mode.

Thanks.
> 
> Thanks.
> 
> -- 
> Dmitry
> 
