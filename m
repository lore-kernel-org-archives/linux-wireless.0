Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3944 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab2GaKtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 06:49:40 -0400
Message-ID: <5017B83A.9000207@broadcom.com> (sfid-20120731_124945_527951_3E3AEE18)
Date: Tue, 31 Jul 2012 12:49:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Paul Hackett" <paulfxhackett@gmail.com>
cc: "brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac (USB) driver for Linksys AE1200 donle in Ubuntu
 12.04
References: <CAP5Eh2wSyXQ7sMu+W9KSTrjBUZqAucaUUSk=K67q8F9LL9Ag0Q@mail.gmail.com>
In-Reply-To: <CAP5Eh2wSyXQ7sMu+W9KSTrjBUZqAucaUUSk=K67q8F9LL9Ag0Q@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2012 05:02 PM, Paul Hackett wrote:
> Hi
> 
> I'm writing to you from Ireland and taking you up on your kind offer to
> "feel free to contact the developers listed below" in this
> site<http://linuxwireless.org/en/users/Drivers/brcm80211?highlight=%28broadcom%29%7C%2843235%29>
> .

I will try to be kind in my reply as well ;-)

> I'm running Ubuntu 12.04 (kernel 3.2.0-23-generic-pae) on a Dell E520 (CPU
> C2D 1,86 GHz)
> 
> I recently bought a Linksys AE1200 wifi dongle (Broadcom 43235 chipset) for
> use on another machine (which I'll explain shortly).
> 
> In Ubuntu, the brcmfmac.ko driver is already present in
> 
> /lib/modules/3.2.0-23-generic-pae/kernel/drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
> 

For the 3.2 kernel the brcmfmac only supported SDIO devices. USB support
was added in 3.4 kernel. However, the Linksys AE1200 needs a different
driver model that is not supported. So the only option for x86 is using
ndiswrapper.

> 
> Two questions:
> 
> 1. Should I have been able to get the brcmfmac driver working in Ubuntu
> 12.04 or is it still in development? If yes, what am I missing?

So the answer is no for the two reasons above. The brcmfmac support
BCM43235 only for chip revision 3 and higher. The Linksys AE1200 has an
older revision that requires a driver model that is not supported.

> 2. Are we likely to soon see an ARM version of a brcmfmac driver for the
> Raspberry Pi with which I can running my RPi wirelessly using the Linksys
> dongle?

The brcmfmac driver is already working for ARM platforms. We have both
SDIO and USB running on Pandaboard platform.

> 
> Thank you for reading this.
> I hope you may have some time to respond.
> 
> Very many thanks and best wishes
> 
> Paul

Sorry my response may be disappointing.

Gr. AvS


