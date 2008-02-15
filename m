Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:29316 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYBOVYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:24:44 -0500
Received: by fk-out-0910.google.com with SMTP id z23so883042fkz.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 13:24:41 -0800 (PST)
To: Adam Turk <bofh1234@hotmail.com>
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Fri, 15 Feb 2008 22:24:33 +0100
Cc: linux-wireless@vger.kernel.org
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl> <200802152146.06364.IvDoorn@gmail.com> <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl>
In-Reply-To: <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802152224.34055.IvDoorn@gmail.com> (sfid-20080215_212458_728689_BC6337A0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 February 2008, Adam Turk wrote:
> 
> > You are completely missing the point of the concept "modules",
> > the module rt73usb is intended to support devices with the rt73 chipset.
> >
> > The rt73usb driver registers the device and creates an network interface
> > inside the kernel. This interface is visible to you as user. The name of this
> > interface is wlan, depending on the number of wireless network cards in
> > your system the interface number is attached to it so in your case wlan0.
> 
> Yep, I could be missing the concept of modules entirely.  
> 
> The driver I was using before had the interface name of rt73.  When I see 
> usbcore: registered new interface driver rt73usb

Seriously, I wonder with what driver you managed to pull that off.
As far as I know there is no rt73 driver that registers an interface called rt73.
Neither the Ralink drivers, the rt73 legacy driver or the rt73usb driver ever
did such a thing.

Granted the name did change. The Ralink driver and early legacy drivers
did create the interface with the name "rausb", this is still not the same
as "rt73".

Additionally:
> usbcore: registered new interface driver rt73usb

Using a different rt73 driver would also produce this line (replacing rt73usb
with rt73 or whatever the name of the driver was).
But like I said earlier, I know of no rt73 driver that registered a network
interface named rt73. It is either "wlan" or "rausb". Unless off course you
edited the /etc/modprobe.conf file to load the driver with the rt73 interface name,
but that can be considered "user configuration".

Ivo
