Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42511 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753140Ab1KZB17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 20:27:59 -0500
Date: Fri, 25 Nov 2011 20:27:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hauke Mehrtens <hauke@hauke-m.de>
cc: Arend van Spriel <arend@broadcom.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma USB Host driver
In-Reply-To: <4ED02B1D.7030409@hauke-m.de>
Message-ID: <Pine.LNX.4.44L0.1111252022490.14777-100000@netrider.rowland.org> (sfid-20111126_022807_118681_909B9AA7)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Nov 2011, Hauke Mehrtens wrote:

> > Main question would be whether a linux device driver can provide
> > multiple system functions. I tend to say it can. So I would suggest to
> > have a single device driver providing OHCI and EHCI functionality.
> 
> @USB guys, how do I design a driver for a linux device providing ohci
> and ehci functionality at the same time. The device has two address
> spaces one for ehci and one for ohci functions.

How many IRQ lines?

And incidentally, in what sense is this _one_ device?  Are you sure 
it's not _two_ devices in one package?

> I thought about registering one controller (ehci or ohci) with
> usb_create_shared_hcd(). The code then will be in an own module and not
> in echi_hcd.ko and ochi_hcd.ko like for pci, I hope this works.
> Is there a better solution to do this, is there an other driver with the
> same problem already solved?

I don't know of any other driver that does this.  Your best solution is 
probably write a driver that registers two child platform devices, and 
write two corresponding platform drivers, one for the EHCI part and one 
for the OHCI part.

Alan Stern

