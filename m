Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43834 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab2AVT1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jan 2012 14:27:16 -0500
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 7A7F72050E
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jan 2012 14:27:15 -0500 (EST)
Date: Sun, 22 Jan 2012 14:23:46 -0500
From: Greg KH <greg@kroah.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, USB list <linux-usb@vger.kernel.org>,
	zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	george@znau.edu.ua
Subject: Re: [PATCH 4/7] USB: EHCI: Add a generic platform device driver
Message-ID: <20120122192346.GA1691@kroah.com> (sfid-20120122_202722_238729_5AADAB1A)
References: <Pine.LNX.4.44L0.1201212235050.32266-100000@netrider.rowland.org>
 <4F1C24F5.2020506@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F1C24F5.2020506@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 22, 2012 at 04:02:13PM +0100, Hauke Mehrtens wrote:
> On 01/22/2012 04:41 AM, Alan Stern wrote:
> > On Sat, 21 Jan 2012, Hauke Mehrtens wrote:
> > 
> >> This adds a generic driver for platform devices. It works like the PCI
> >> driver and is based on it. This is for devices which do not have an own
> >> bus but their EHCI controller works like a PCI controller. It will be
> >> used for the Broadcom bcma and ssb USB EHCI controller.
> > 
> > Before adding a generic platform driver for EHCI, you should give some
> > to thought to how it might be generalized.  There are a lot of EHCI
> > platform drivers, all differing in various major or minor respects.  
> > It should be possible to replace a lot of them with the generic driver, 
> > but first it will need some way to cope with a few minor quirks.
> > 
> > Please consider this, and think about which of the existing drivers 
> > could be replaced.
> 
> For now I just build this for bcma and ssb based SoCs. Yes there are
> some drivers which could be replaced with this one, but most (all ??) of
> them do something special in the device probing and this have to be
> moved to somewhere else e.g. where the platform device is created.
> I could rename it so it would not be generic any more, but I think it is
> the wrong approach. ;-)
> I am not able and do not have the time to convert all EHCI platform
> drivers, where it is possible  to this generic platform driver, as I do
> not have the devices to test this and time is limited.

Time is not limited for us, sorry, this seems like the correct thing to
do, and because of that, we (well I at least) will not accept this patch
as-is.

Please go rework it to be as Alan suggested.

> If someone else wants to improve something on these "generic" platform
> drivers to make them work with an other device I am totally fine with it.

I think that someone just became you :)

Yes, this isn't fair, but it's how Linux kernel development works,
sorry.

thanks,

greg k-h
