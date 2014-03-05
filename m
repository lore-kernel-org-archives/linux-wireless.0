Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:47337 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaCEL12 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:27:28 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Thierry Moreau <thierry.moreau@connotech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning works
Date: Wed, 05 Mar 2014 11:51:07 +0100
Message-ID: <30326094.D3kKybyiI3@al> (sfid-20140305_122738_607935_77BD3B52)
In-Reply-To: <5316C602.8020504@connotech.com>
References: <5316C602.8020504@connotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 March 2014 06:36:50 Thierry Moreau wrote:
> I am using a kind-of "linux from scratch" (i.e. Crux 3.0, 64 bits
> Intel, kernel 3.10.32) and I am stuck with a EBUSY error return from
> the wireless driver I suspect it comes from the driver behavior since
> it is consistent either from the command
> 
> iw dev wlan1 set channel 2
> 
> or the comand
> 
> iwconfig wlan1 set channel 2
> 
> (it occurred also with "iw" with a kernel where the iwconfig support
> emulation is off -- CONFIG_CFG82011_WEXT). The EBUSY error return
> occurs as early as immediately after the initial module install, and
> consistently thereafter. The wireless scanning works (reporting a
> nearby beacon on channel 1).

It was not entirely clear for me, but have you enabled the interface
before changing the channel? I.e.

    ip link set wlan0 up
    iw dev wlan0 set channel 2

I suggest to try 3.13 or even 3.14(-rcish). Earlier kernels (3.10 being
the worst) had an issue[1] that impacted wireless stability.

> The system is a Shuttle XS36VL box
> (http://us.shuttle.com/barebone/Models/XS36VL.html). It does not have
> a physical wireless switch (a dmesg line above reports the switch
> position as "on").

The same box is operating in my neighbourhood (networking was not
required for its purpose). Good luck with getting multi-head working.
This box is running 3.14-rc2-something now with patches to get monitor
mode to function properly.

Kind regards,
Peter

 [1]: https://bugzilla.kernel.org/show_bug.cgi?id=60713
