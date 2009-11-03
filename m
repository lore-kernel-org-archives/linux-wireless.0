Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59801 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754599AbZKCUgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 15:36:12 -0500
Message-ID: <4AF09117.4040804@gmx.net>
Date: Tue, 03 Nov 2009 21:22:47 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org>	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>	 <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>	 <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>	 <4AEF3CAD.10809@gmx.net> <1257193115.1027.24.camel@localhost.localdomain>	 <20091102210519.7d309fb9@lxorguk.ukuu.org.uk> <1257198359.1027.67.camel@localhost.localdomain>
In-Reply-To: <1257198359.1027.67.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams schrieb:
> ...
> Maybe there's a better way as I said a bit lower in the thread; could we
> put the logic for ejection into the driver (and not usb_modeswitch or
> whatever) but put the decision into userspace in udev?
>
> Right now the kernel drivers know what hardware they support, and that's
> a great place to also put how to eject the fake driver CD.  So the
> mechanism could live in the kernel still (instead of in usb_modeswitch
> in userspace) while the actual decision still gets made in userspace
> with udev rules.  The rules would say something like "if this USB
> storage device has an 'fakecd' attribute, then touch the 'ejectmeharder'
> attribute" instead of complex rules to run usb_modeswitch that duplicate
> all the device IDs in userspace.  If you need to rummage around on the
> driver CD for whatever reason, you disable the udev rule.  Maybe?
> ...
That would make system-configuration much easier and would also reduce
the work for the distros.
Mode-switch-tools would be much easier to maintain, too.

How do you want to implement this policy-hint ?

Frank

