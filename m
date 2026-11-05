Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906383;
	b=rqEjoeBpdmISyp+f1AV0ZuCgI1OUW60VVGykwFVLItSoyQ4kz15Qdt7muA6P1Jags5Jn
	 LHoLShzB7961HdEhPlXUpqytGMb7ZvKuSIeSTRw06RBNf/ZStKDhI+ts3ECW2PQWDoc4A
	 t0OHYhHiQzXcV0zDjsAtOoZ6GeTR+CXlhQzFzCWm5AMTEDU5rQghCHHAneiwDfSw7XCYl
	 fBd9O/ZqdLY6CQ6HuWOpu4FHK82vkKAbEYW6y6HujtjzTLYZ55ISuCdDj4sKr7gL5YPqF
	 CKyd6J0/LxlutgWPyXNiiuJF6GCQhIHmOHObciNtZWQLBuMhs8JIIHrU7Isec1rz7sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906383;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z/2gVRqDIy8aB19su2IOPKcJY2mNZmdhA03swHLZjYQ=;
	b=cXnInZHsCibHY3+JyEDByQvS/OXbWrYvtEvEz5qD0r8kRfLFuBU2xcJH2UcQmWhnlbyv
	 LxOf9zzSO1g/Q8/Yy+FiBneRB96EC5ljU5eZRNeD+YOVs35x/b6g0m8CHIOxNafAdrwiv
	 QEz8N/cdKRpqckOPJavL8OekG6uA2p3zOBpa3SaOlNKd9fdNTHgLCaMA8Vh1of/SMpgNZ
	 h2DfgREj0kryqZplYBWTeIMynYUgg6qjLqxrTh0xm+JOIK+Y25W4Y27ZGItEDseO/0CWw
	 5IF8Ce1+kbgwAFoN8qz8h2NB+aojEIpv9R6jCIhZaUZLQpylKUiPUZif2+Z5aKf/XjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkEVYl84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98297606A31B;
	Thu,  5 Nov 2026 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkEVYl84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E871F000C1;
	Thu,  5 Nov 2026 19:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906383;
	bh=z/2gVRqDIy8aB19su2IOPKcJY2mNZmdhA03swHLZjYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jkEVYl845iO1BRjDNjs7l3aLV0DOTx2Xh4dkDtjEQRAG/szywJJ5iA7F7EBeoCv3/
	 Xr/XPb+CiVQa81KxX4rWfb+Ey7BCQrq8ZgEJKW4tmKtvqc9XOhUvqI6GMjdGyv5wa/
	 fFT42EqhuLoCYvx7kmlRnDtoWkdemyj50Ko8jo+RL8euRPtleHPXYSTL2guiYPygpR
	 LmQAT9/JCG5RJdfVN5vfVW2kDcNKd8AzICxKZa2tpcTEwInZ2buqjtKKyH4CQ2de5i
	 NVLEPe8RHtRdddRsaEMdYbNggz8TadkiapRYLGxK2b9KrUeCLhPUE/vb3Yg0OCtBC2
	 7ZypycQhGTlGQ==
Date: Thu, 5 Nov 2026 21:19:40 +0200
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
Message-ID: <20261105191940.GI8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-2-1e536825b4eb@nvidia.com>
 <auy2plYVi723Qt42@google.com>
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
In-Reply-To: <auy2plYVi723Qt42@google.com>

On Thu, Nov 05, 2026 at 09:05:29AM -0800, Dmitry Torokhov wrote:
> On Thu, Nov 05, 2026 at 01:42:15PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Manual serio binding connects a driver before driver core can admit the
> > device. A rejected binding therefore arrives after functional setup.
> > 
> > Keep the port ID check and use device_driver_attach() for the existing bus
> > probe path. Driver core then serializes admission and handles probe failure
> > before publishing the binding.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/input/serio/serio.c | 24 +++---------------------
> >  1 file changed, 3 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> > index 54dd26249b027..604440244c1ca 100644
> > --- a/drivers/input/serio/serio.c
> > +++ b/drivers/input/serio/serio.c
> > @@ -81,28 +81,10 @@ static int serio_match_port(const struct serio_device_id *ids, struct serio *ser
> >  
> >  static int serio_bind_driver(struct serio *serio, struct serio_driver *drv)
> >  {
> > -	int error;
> > -
> > -	if (serio_match_port(drv->id_table, serio)) {
> > -
> > -		serio->dev.driver = &drv->driver;
> > -		if (serio_connect_driver(serio, drv)) {
> > -			serio->dev.driver = NULL;
> > -			return -ENODEV;
> > -		}
> > +	if (!serio_match_port(drv->id_table, serio))
> > +		return 0;
> >  
> > -		error = device_bind_driver(&serio->dev);
> > -		if (error) {
> > -			dev_warn(&serio->dev,
> > -				 "device_bind_driver() failed for %s (%s) and %s, error: %d\n",
> > -				 serio->phys, serio->name,
> > -				 drv->description, error);
> > -			serio_disconnect_driver(serio);
> > -			serio->dev.driver = NULL;
> > -			return error;
> > -		}
> > -	}
> > -	return 0;
> > +	return device_driver_attach(&drv->driver, &serio->dev);
> 
> I am not sure how safe it is, serio (and gameport) have pretty elaborate
> structure and locking rules because they can recurse into themselves (to
> support case of Synaptics touch-pads with pass-through PS/2 ports).
> 
> But this call is for user-initiated probing anyways, I am not sure if it
> even needs "trust" handling.

This patch does not change the locking; the lock was already held on paths such
as the rescan path. This change makes that explicit.

Thanks

> 
> ... And I even thinking if we really need to keep these custom
> attributes or if I can rip them out in the future ...
> 
> Thanks.
> 
> -- 
> Dmitry
> 
