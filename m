Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:44288 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYE3RGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 13:06:15 -0400
Date: Fri, 30 May 2008 20:05:36 +0300
From: Jouni Malinen <j@w1.fi>
To: Thomas Kunze <thommycheck@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: hostap oops
Message-ID: <20080530170535.GA9786@jm.kir.nu> (sfid-20080530_190618_460560_E779C2A4)
References: <48374F39.40904@gmx.de> <20080524061628.GE4932@jm.kir.nu> <4837FD8D.2010000@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4837FD8D.2010000@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 01:35:41PM +0200, Thomas Kunze wrote:

> Some logs:

Thanks!

> hostap_cs: Registered netdevice wifi0
> Unable to handle kernel NULL pointer dereference at virtual address 00000028
> pgd = c0004000
> [00000028] *pgd=00000000
> PC is at prism2_interrupt+0x64/0x8ec

It does indeed look like the interrupt handler is not prepared for
something at this point. However, I cannot reproduce this in my tests on
x86 for some reason.. I have even test code that ends up calling the
interrupt handler at the point when it is registered, i.e., when a real
interrupt could actually hit it. prism2_interrupt does not crash in this
case and I see no problems there. The interrupt handler is installed
only after the data structures have been initialized, so the pointers
should be valid at this point.

Unfortunately, I do not have an ARM-based system for testing something
closer to your configuration. It would be useful to figure out what
exactly is NULL in the case where this crash happens. Based on that PC
location, I would assume it is something that is being used close to the
beginning of prism2_interrupt(), but since I don't have the object file
used here, I cannot be sure. I would appreciate it if you could either
take a look at the hostap_cs code and see if you can find this location
or alternatively add some printk calls in the beginning of
prism2_interrupt() to figure out which pointer is NULL.

-- 
Jouni Malinen                                            PGP id EFC895FA
