Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909063;
	b=tXGkOk2HwQr07EvjqxwTK4Ng29ELXvMj/zb/OOhLgV2yJzbKulHZHQ5HeXlEYpmDMcky
	 eTk/fiHAGPQlgpjJi9iS0xUCvI4w/hIqwHCwVg4l2tKdbbJ+cWZ5bp9qEcPZiSJtl/2E9
	 93u1BuDTMrXF5PTnzX0lvgE0TXxh1ELG12t8L0OhkntoUhzC/HoQXH9eterNAZ7rP9EJz
	 IjXsjOkDEp0E9eu2/alKBb07GmnZjhkPLeZAya2mD3vn3mwAV6S8JvIa/bnUs9F2qJnp9
	 ysOB4Dv+/cVJiLFTQahWTTMgv4JdZTr2pXI6yqrBayud2R37bOaQhqKcZ5NMrh5e2zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909063;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Aw5degZrQHo3V3rpws5+g22RRHe/seP3Fa1C54u6MN0=;
	b=JrsDpPgLWnd+b2Q6yWrBrOWr5lOBPuwHAUFa92+w776fPAUaGxosVc1ghhi4WAL4vXRc
	 kYAwzqci1hOeNcxfoWUNv9kFb75bbHXkwsFD/wVeEUMDfnQA46F4yJtEyzf+McqdVnVdo
	 gDRfWXhRwiH/JTp5yN7QVUucRUojtiYCrj6O2Hu9M+30DwaO7Oqkbe1jXEr5rggbDoHRh
	 dsFp2nlOSrunZY8gpWGLoHNGfganRg0F6wFXlN6zKQRIkglg5Nck/YWxdufivSmD1ssGT
	 A3Xr6TMVD088xfJ+Xu4G5UDI240HEgLDPDt0OWCpoD9FhlPkSZy7Oq5qL511ngbh3Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rowland.harvard.edu;
	spf=fail smtp.mailfrom=g.harvard.edu;
	dkim=pass header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b="l7XvB/r0";
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADA4606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 20:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ADA4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=l7XvB/r0
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53397554beaso21893541cf.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 12:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1793909062; x=1794513862; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Aw5degZrQHo3V3rpws5+g22RRHe/seP3Fa1C54u6MN0=;
        b=l7XvB/r0EAsfmkvKwLXi9U+FCv4znlZ1uWBgyBwXXZBCaUNdokUJy53RUHWJ+2kEWT
         BpwprXNHONWGHOvIsaDTpZHtcB6XsAeWhewDJaNhuiB2euiyoU1AbjQlFtg5R3UAb8Zl
         j9ild+5nUdzM5UZbj7mYag8Dctagcxk6YhEm1Nh61f0Vznb26vlUpjb7sFwe3CVlNOPl
         SyOS6Mi1UVvjAAp7m7mMB3CBgWNbht54CQ+BOwi4rfm1nRGeYFie5joT1aagUt7j+5ki
         VjKs1rKf0ER8mcU7zk1mritepu2DeojMvspSrsP6rAbky9P1uX094nTddzM3XtqlzsCQ
         csmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793909062; x=1794513862;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aw5degZrQHo3V3rpws5+g22RRHe/seP3Fa1C54u6MN0=;
        b=ld4L0MErfJ4UnTfCETjpjVbaDnHFPjWUDD9ZtSi7tXyz5DLqo8DhLorqnzV/hjPWJC
         C1cymRfKGj21qZ4VzEiN6HXWF79u+Vk4xjcVzGzNKUSu6SwJmvVUFNam0jMjRqAZNRgN
         9al5CGyrViVI8h4Yaux68nrSuH19Am3KAaBh02yU9Np+23qgEsXX2w4jJfsG9i9dNhXl
         8dAbjZwO2IkBAputUo6NJxz6+RX6T0WyNYbTXS1KVYVe42nesITEGDPXdpPYh5nwsrib
         ufG/iSY8M5cH7pWANThga3uKx2q/FzZjc8JPhKpErunOToOdn71pMh/I3aW85udsVq5e
         jTWw==
X-Forwarded-Encrypted: i=1; AKwUvBwM/k69tZ07UIDPZkjd2PCI92ETadBLuOHw2KXzOs/w9qj0Yu6TwlVRolbY77fY7I5ecK9fWo96BX4ySZGBCg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/bYjjHkw7B4b4ETyDvInzIquSrfu02fs5LezFuImqULdgkFpgk
	Mg3l3nprrfmBbFfGWOqcTGiMzr94k1NTYbeJlGSg2TxSg2mp1W9y3GSf8BnAZY583g==
X-Gm-Gg: AYBFou22jNmh6T6JH7KVtNgEKN1ThbS79gjyc+GCfIQcLUzlZcp8jImkdfL7JPzELpa
	KRwQSVIV2U3vsnIbEaRNOmVAci0GAR9N7CE1pez1+k4GjZ9r+VaUdNPOzRNhcoWgoon6lFxs/Yt
	xhL3REiAjSwKPcySwum7385RTxMthxBP6xp6DUQiIButSEls5VdDdSVMKA+DsMI29N8N6bO/iiW
	qctDCQV314fRhAlOEMrAzBWvm/sJeZveN4brfmLkQomqaAgn+50/HXhLBfLu4CZGTVajW9drpUD
	+2NOUJOQEua0Syg3d6Ox9IwnH5qj+Nnw3nLoFhWWvmBG1gzitUzfS3zJ+xIVzynCtHklT/nWoE+
	UGiuKO8Uf9KgL6m6z7OLQrgt5h80aPaICU9Djr/Uk3O92Fclqljq3xXYmhJrL8Uq0nOYfTlv9mE
	rkPhZ0jisom0x5BzG0KHBjKMTbwxVoroIzzJpPRB9dTkw58f5ciLI4EqQTNP8Glo0yIqpMZDh08
	CA0hEv762qQ4KpCOaa+2mBkgnXKITD+ET1zxiYcK8ySbUAp48uocxfINnSWdBBFAUGXw6+Q+YgH
	cDn/fbyWN9D02EtbYrfsVKGz8aYo
X-Received: by 2002:a05:622a:418d:b0:536:60e1:c87d with SMTP id d75a77b69052e-54e14266a2dmr6509601cf.35.1793909061778;
        Thu, 05 Nov 2026 12:04:21 -0800 (PST)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::66b0])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e270167afsm1403061cf.25.2026.11.05.12.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 12:04:21 -0800 (PST)
Date: Thu, 5 Nov 2026 15:04:18 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Leon Romanovsky <leon@kernel.org>
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
Message-ID: <bf756e50-c77e-40f2-916d-e88887426806@rowland.harvard.edu>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-5-1e536825b4eb@nvidia.com>
 <bb83fe3c-cebb-4bc8-bfc9-24df1cf72b0b@rowland.harvard.edu>
 <20261105184442.GF8298@unreal>
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
In-Reply-To: <20261105184442.GF8298@unreal>

On Thu, Nov 05, 2026 at 08:44:42PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 12:24:33PM -0500, Alan Stern wrote:
> > On Thu, Nov 05, 2026 at 01:42:18PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Interface claims hold the USB device lock, but device_bind_driver()
> > > requires the target interface lock. Without it, trust-policy writes can
> > > race admission.
> > 
> > This says nothing about usb_driver_release_refused_claim() and the code 
> > related to it.  It is an incomplete description of the patch.
> > 
> > Note that nothing prevents drivers from using an interface they claim 
> > before that interface is registered.  For your scheme to work properly, 
> > you should make sure the claim is authorized when 
> > usb_driver_claim_interface() is called, not when the interface is 
> > registered.
> 
> This patch is unrelated to authorization;

I meant "authorization" in its generic sense.  When you don't trust 
something, you don't authorize it to do anything.  Pretend I had written 
"the interface being claimed is trusted" in place of "the claim is 
authorized" above.

>  it ensures that the lock is
> acquired when the driver is bound.

That may have been your intention when the patch was created, but if you 
read the patch you'll see that it includes a whole bunch of material 
not related to locking during binding.  Namely, this part:

> > > +/*
> > > + * The driver core refused to bind an interface that a sibling claimed before
> > > + * it was registered, and dropped the claim. Let the claimant release the
> > > + * interface instead of operating it with a bound interface but no driver.
> > > + */
> > > +void usb_driver_release_refused_claim(struct usb_interface *iface,
> > > +				      struct device_driver *claimant)
> > > +{
> > > +	struct device *dev = &iface->dev;
> > > +
> > > +	device_lock(dev);
> > > +	if (!dev->driver && iface->condition == USB_INTERFACE_BOUND) {
> > > +		dev->driver = claimant;
> > > +		usb_unbind_interface(dev);
> > > +		dev_set_drvdata(dev, NULL);
> > > +		dev->driver = NULL;
> > > +	}
> > > +	device_unlock(dev);
> > > +}
> > > +
> > >  /* returns 0 if no match, 1 if match */
> > >  int usb_match_device(struct usb_device *dev, const struct usb_device_id *id)
> > >  {
> > > diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> > > index a738d03c23eac..d35a7710c8ef4 100644
> > > --- a/drivers/usb/core/message.c
> > > +++ b/drivers/usb/core/message.c
> > > @@ -2264,6 +2264,7 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
> > >  	 */
> > >  	for (i = 0; i < nintf; ++i) {
> > >  		struct usb_interface *intf = cp->interface[i];
> > > +		struct device_driver *claimant;
> > >  
> > >  		if (intf->dev.of_node &&
> > >  		    !of_device_is_available(intf->dev.of_node)) {
> > > @@ -2277,7 +2278,14 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
> > >  			dev_name(&intf->dev), configuration,
> > >  			intf->cur_altsetting->desc.bInterfaceNumber);
> > >  		device_enable_async_suspend(&intf->dev);
> > > +		claimant = intf->dev.driver;
> > > +		if (claimant && !try_module_get(claimant->owner))
> > > +			claimant = NULL;
> > >  		ret = device_add(&intf->dev);
> > > +		if (!ret && claimant && !intf->dev.driver)
> > > +			usb_driver_release_refused_claim(intf, claimant);
> > > +		if (claimant)
> > > +			module_put(claimant->owner);
> > >  		if (ret != 0) {
> > >  			dev_err(&dev->dev, "device_add(%s) --> %d\n",
> > >  				dev_name(&intf->dev), ret);
> > > diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
> > > index a9b37aeb515be..293340a48b6c5 100644
> > > --- a/drivers/usb/core/usb.h
> > > +++ b/drivers/usb/core/usb.h
> > > @@ -49,6 +49,8 @@ extern int usb_set_isoch_delay(struct usb_device *dev);
> > >  extern int usb_get_bos_descriptor(struct usb_device *dev);
> > >  extern void usb_release_bos_descriptor(struct usb_device *dev);
> > >  extern int usb_set_configuration(struct usb_device *dev, int configuration);
> > > +void usb_driver_release_refused_claim(struct usb_interface *iface,
> > > +				      struct device_driver *claimant);
> > >  extern int usb_choose_configuration(struct usb_device *udev);
> > >  extern int usb_generic_driver_probe(struct usb_device *udev);
> > >  extern void usb_generic_driver_disconnect(struct usb_device *udev);

Was this meant to be two separate patches that somehow got combined into 
one?

Alan Stern
