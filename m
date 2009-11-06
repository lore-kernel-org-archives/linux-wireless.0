Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40431 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbZKFWBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:01:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mwl8k: use integral index instead of pointer for driver_data
Date: Fri, 6 Nov 2009 23:01:23 +0100
Cc: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@marvell.com>
References: <1257543727-5449-1-git-send-email-linville@tuxdriver.com> <200911062257.01590.mb@bu3sch.de>
In-Reply-To: <200911062257.01590.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911062301.24871.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 22:56:59 Michael Buesch wrote:
> On Friday 06 November 2009 22:42:07 John W. Linville wrote:
> > @@ -3379,7 +3378,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
> >  	priv = hw->priv;
> >  	priv->hw = hw;
> >  	priv->pdev = pdev;
> > -	priv->device_info = (void *)id->driver_data;
> > +	priv->device_info = &mwl8k_info_tbl[id->driver_data];
> >  	priv->rxd_ops = priv->device_info->rxd_ops;
> >  	priv->sniffer_enabled = false;
> >  	priv->wmm_enabled = false;
> 
> What about a sanity check for id->driver_data on the array range? Otherwise one could crash
> the kernel with sysfs/new_id by accident, as far as I can tell.
> 

Ok docs say that:
> Note that driver_data must match the value used by any of the pci_device_id
> entries defined in the driver. 

So ignore me.

-- 
Greetings, Michael.
