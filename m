Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:34285 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZKJKJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:09:30 -0500
Date: Tue, 10 Nov 2009 11:09:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/28] mwl8k: change pci id table driver data to a structure pointer
Message-ID: <20091110100934.GQ18639@mail.wantstofly.org>
References: <20091022182046.GQ1583@mail.wantstofly.org> <20091106205724.GJ2782@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091106205724.GJ2782@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2009 at 03:57:25PM -0500, John W. Linville wrote:

> > To prepare for adding support for more device types, introduce a
> > new structure, mwl8k_device_info, where per-device information can
> > be stored, and change the pci id table driver data from an integer
> > indicating only the part number to a pointer to a mwl8k_device_info
> > structure.
> > 
> > Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> > ---
> >  drivers/net/wireless/mwl8k.c |   47 ++++++++++++++++++++++++++---------------
> >  1 files changed, 30 insertions(+), 17 deletions(-)
> 
> > @@ -2940,6 +2936,22 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
> >  	priv->beacon_skb = NULL;
> >  }
> >  
> > +static struct mwl8k_device_info di_8687 = {
> > +	.part_num	= 8687,
> > +};
> > +
> > +static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
> > +	{
> > +		PCI_VDEVICE(MARVELL, 0x2a2b),
> > +		.driver_data = (unsigned long)&di_8687,
> > +	}, {
> > +		PCI_VDEVICE(MARVELL, 0x2a30),
> > +		.driver_data = (unsigned long)&di_8687,
> > +	}, {
> > +	},
> > +};
> > +MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
> > +
> >  static int __devinit mwl8k_probe(struct pci_dev *pdev,
> >  				 const struct pci_device_id *id)
> >  {
> 
> My only complaint here is that using a pointer for
> driver_data make it difficult and potentially dangerous to use
> /sys/bus/pci/drivers/.../new_id to add a PCI ID to the device.

Hmmm, yeah, it would make doing that difficult.  (I don't see how it can
be dangerous, as the new_id handler verifies that the specified
driver_data field is used by at least one other existing id_table
entry).


> Using an integer instead makes that a bit safer and easier to use.
> drivers/net/3c59x.c provides a decent example.

I think it might be possible to autodetect the chip type, but this
sounds like a good compromise for now.

Thanks for the review.


thanks,
Lennert
