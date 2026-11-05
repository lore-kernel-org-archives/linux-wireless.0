Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793904287;
	b=e20895yC01nIMzqjoW9F5PkWGJWkiCFKys/mI/Sy4HSXt9bfKKWKygzkWjZRtCPAGumn
	 BT4Avkn4xZ8mlpzxTDt1MCvabfCenXZGy4bSuN1DpYEa1IXMyMPZUEfTYxikmQVKh7XKM
	 LyaNKawTMefFQ4WKhDWuJ4/Wo9Cnp0yV+WpdsPvY7nX//rJhnGhQfGfBH2tFjupO19NYL
	 /QEnlC7XN3a4ArnWCrAsKGb0jjDT1Sj8yzl0TbYvI4kvCjJVsMU58J0uwBoWjIwf2iBQk
	 E9di7eT/qbHWdR7g5S2fOxeELhKNiwjKtDLCQ+bxwhIo8pIs1wnSo8wlBLXx0h4V9OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904287;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=o7Tf0Vl1HXrQW/KomSdCbhPIwR8sGoUxO+YGv2hwBkY=;
	b=lJlpcVmMqXarguSQMrWrsF35GCh+b4w3hPJ9NMq1Bjrfryc8w2OSyBpr42feQwA8C0kK
	 FMgNWSfG2wxMr/L6QbfWJTuuOMUUfguZK6+2iRVm3eHdSHfBvFO0g+u+yF060EksZGPxh
	 F6s07rxCInCR4h/90ec3B+ThOXY3kaXstF/BaAyIR5xmoIXCDOmECALRljM38cBBUbCuq
	 PF2eF/pIhHwABtiECDFhTc5svrhv0gJtQQxj5YC4i5KBQFVeXWdAcmJ4P+9xVFhGSmAlR
	 qIiGAMmBiVx3rNPT9FeK0V0i4ybrCJ0eFKZ+HrsFc9Lh9fwz+PdRj4zq6S3Jh20QN5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+YpoM4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D079606A31B;
	Thu,  5 Nov 2026 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+YpoM4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87701F000C1;
	Thu,  5 Nov 2026 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793904286;
	bh=o7Tf0Vl1HXrQW/KomSdCbhPIwR8sGoUxO+YGv2hwBkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y+YpoM4C1BVe/Yi1WqdxzeQMurpj+UUeVHzOIWGi4xhvlPs5Gco2X34yo5CuHzhgl
	 PMCr23a90J+k0uWhGmURNNPL5o1byCJ6BM6vmNMXI0I+nyFobEx+X24QnydwjXDxRp
	 ScVK3Mpcm86RPpuqvn9CENZZcGUEMitgoZOdzeD6FE4nU6n6jSYddWiOSvuDJ8MmI0
	 KWC+t/qzVw0V8JXY5QmfQs7nREntfjCIWhV+aqxEjEEOfYlx+5FGYNyla5xA5qJ6Rb
	 gJQ7elWxLbIDMJR5SRw7JanyJ2mPQTR2mAapDY4RjaNAUY4yZQrwNWSr14hUOC8Ksw
	 RPMqUsS7dJodA==
Date: Thu, 5 Nov 2026 20:44:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
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
Subject: Re: [PATCH 05/17] USB: Lock registered interfaces during manual
 driver binding
Message-ID: <20261105184442.GF8298@unreal>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-5-1e536825b4eb@nvidia.com>
 <bb83fe3c-cebb-4bc8-bfc9-24df1cf72b0b@rowland.harvard.edu>
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
In-Reply-To: <bb83fe3c-cebb-4bc8-bfc9-24df1cf72b0b@rowland.harvard.edu>

On Thu, Nov 05, 2026 at 12:24:33PM -0500, Alan Stern wrote:
> On Thu, Nov 05, 2026 at 01:42:18PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Interface claims hold the USB device lock, but device_bind_driver()
> > requires the target interface lock. Without it, trust-policy writes can
> > race admission.
> 
> This says nothing about usb_driver_release_refused_claim() and the code 
> related to it.  It is an incomplete description of the patch.
> 
> Note that nothing prevents drivers from using an interface they claim 
> before that interface is registered.  For your scheme to work properly, 
> you should make sure the claim is authorized when 
> usb_driver_claim_interface() is called, not when the interface is 
> registered.

This patch is unrelated to authorization; it ensures that the lock is
acquired when the driver is bound. The authorization flow will be handled
separately, as discussed here.
https://lore.kernel.org/linux-pci/20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com/T/#mb66dc792d2b8e5089df40ea8f08824e7d451088a

Thanks

> 
> Alan Stern
> 
> > +/*
> > + * The driver core refused to bind an interface that a sibling claimed before
> > + * it was registered, and dropped the claim. Let the claimant release the
> > + * interface instead of operating it with a bound interface but no driver.
> > + */
> > +void usb_driver_release_refused_claim(struct usb_interface *iface,
> > +				      struct device_driver *claimant)
> > +{
> > +	struct device *dev = &iface->dev;
> > +
> > +	device_lock(dev);
> > +	if (!dev->driver && iface->condition == USB_INTERFACE_BOUND) {
> > +		dev->driver = claimant;
> > +		usb_unbind_interface(dev);
> > +		dev_set_drvdata(dev, NULL);
> > +		dev->driver = NULL;
> > +	}
> > +	device_unlock(dev);
> > +}
> > +
> >  /* returns 0 if no match, 1 if match */
> >  int usb_match_device(struct usb_device *dev, const struct usb_device_id *id)
> >  {
> > diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> > index a738d03c23eac..d35a7710c8ef4 100644
> > --- a/drivers/usb/core/message.c
> > +++ b/drivers/usb/core/message.c
> > @@ -2264,6 +2264,7 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
> >  	 */
> >  	for (i = 0; i < nintf; ++i) {
> >  		struct usb_interface *intf = cp->interface[i];
> > +		struct device_driver *claimant;
> >  
> >  		if (intf->dev.of_node &&
> >  		    !of_device_is_available(intf->dev.of_node)) {
> > @@ -2277,7 +2278,14 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
> >  			dev_name(&intf->dev), configuration,
> >  			intf->cur_altsetting->desc.bInterfaceNumber);
> >  		device_enable_async_suspend(&intf->dev);
> > +		claimant = intf->dev.driver;
> > +		if (claimant && !try_module_get(claimant->owner))
> > +			claimant = NULL;
> >  		ret = device_add(&intf->dev);
> > +		if (!ret && claimant && !intf->dev.driver)
> > +			usb_driver_release_refused_claim(intf, claimant);
> > +		if (claimant)
> > +			module_put(claimant->owner);
> >  		if (ret != 0) {
> >  			dev_err(&dev->dev, "device_add(%s) --> %d\n",
> >  				dev_name(&intf->dev), ret);
> > diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
> > index a9b37aeb515be..293340a48b6c5 100644
> > --- a/drivers/usb/core/usb.h
> > +++ b/drivers/usb/core/usb.h
> > @@ -49,6 +49,8 @@ extern int usb_set_isoch_delay(struct usb_device *dev);
> >  extern int usb_get_bos_descriptor(struct usb_device *dev);
> >  extern void usb_release_bos_descriptor(struct usb_device *dev);
> >  extern int usb_set_configuration(struct usb_device *dev, int configuration);
> > +void usb_driver_release_refused_claim(struct usb_interface *iface,
> > +				      struct device_driver *claimant);
> >  extern int usb_choose_configuration(struct usb_device *udev);
> >  extern int usb_generic_driver_probe(struct usb_device *udev);
> >  extern void usb_generic_driver_disconnect(struct usb_device *udev);
> > 
> > -- 
> > 2.56.0
