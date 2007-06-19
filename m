Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbXFSL7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 07:59:20 -0400
Subject: Re: Update about libertas CompactFlash 8585 driver
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <200706190959.53476.hs4233@mail.mn-solutions.de>
References: <200706190959.53476.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 08:00:59 -0400
Message-Id: <1182254459.18364.11.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-19 at 09:59 +0200, Holger Schurig wrote:
> My CF driver for the 8385 now can associate. But currently I also 
> have a bunch of serious and not-so-serious bugs:

FYI, I re-did the libertas-2.6 tree on infradead per Linville's
suggestion.  You'll want to use the 'libertas' branch of libertas-2.6,
which is also where I pushed all your recent patches from libertas-dev.
The 'libertas' branch will exist until sometime around 2.6.23 when all
the cleanups are done, and then we'll switch to just pushing most
patches directly to linux-wireless@vger.

> Associating
> -----------
> Sometimes, this command sequence is enought:
> 
>     ifconfig eth1 up
>     iwconfig eth1 essid key BLAHBLAH
>     iwconfig eth1 key s:BLAH1
> 
> But sometimes I have to do that to get a an association:
> 
>     ifconfig eth1 up
>     iwconfig eth1 essid key BLAHBLAH
>     iwconfig eth1 key s:BLAH1
>     iwconfig eth1 essid key BLAHBLAH
> 
> This does not happen with the 8388 USB dongle, so I guess there 
> is an issue between firmware v5.0 vica v5.1.

It would be useful to get a full debug of the driver with the following
set for libertas_debug:

ENTER, LEAVE, MAIN, WEXT, SCAN, ASSOC, JOIN, CMD, FW

The association code batches up WEXT calls and commits them to firmware
after a timeout.  I'd like to see the traces to see exactly when the
driver calls each of the hardware commands.

> Not re-associating
> ------------------
> When I am associated from to an Access Point, and actively 
> de-associate the client on the AP, then I get the dissassociate 
> event back ... but then the driver stays where it is. It does no 
> re-scan and try to re-associate to the best AP it can find.
> 
> This happens also with the reference 8388 USB dongle, so it's a 
> general bug in libertas.

This behavior is expected; usually when you get a forced disassociation
from an external source, the driver will report the disassociation and
wait to be told what to do.  Some firmware tries to reassociate, but in
general the drivers shouldn't be doing this sort of thing, that's what
userspace tools are for.  For example, how do you do a driver-level
reassociation when you're doing WPA or Dynamic WEP?  You can't unless
you have userspace tools to handle the EAP exchanges for you.  I don't
see why open/WEP should be that much different.  However, I'm not
dead-set against trying 1 or 2 reassociations in open/static-WEP.

> Some softirq problem
> --------------------
> Sometimes I get the kernel error "NOHZ: local_softirq_pending 
> 08". This line comes out 5 or 10 times. That nonwithstanding, 
> the driver works.
> 
> My system has lots of other devices on IRQ 11: yenta, yenta, 
> ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4 and 
> libertas_cs. There are no USB devices attached, Kernel is from 
> the libertas2.6 tree, so it's similar to 2.6.22-rc4. Oh, and I 
> don't have hyperthreading.
> 
> 
> 
> Power management is hosed
> -------------------------
> After "iwconfig eth1 power on" almost nothing works anymore. 
> Sometimes one or two pings came throught, but with extremely 
> long delays. And then I get "libertas: tx watch dog timeout"
> 
> The reference USB 8388 dongle doesn't have this problem.

Hmm; no idea on this one, but obviously your firmware doesn't like power
save mode as the current driver does it :)  Does the Marvell 8686 SDIO
driver have anything you can use to debug this or maybe see if the
non-USB devices use slightly different code?

Dan

