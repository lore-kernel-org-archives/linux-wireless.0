Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ctb-mesg4.saix.net ([196.25.240.74]:33604 "EHLO
	ctb-mesg4.saix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYGRTZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 15:25:44 -0400
Message-ID: <4880EF70.508@kroon.co.za> (sfid-20080718_212547_470085_A98BB169)
Date: Fri, 18 Jul 2008 21:30:56 +0200
From: Jaco Kroon <jaco@kroon.co.za>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
References: <487FC561.3060104@kroon.co.za> <20080717191425.1vfvithrk0okcg84-cebfxv@webmail.spamcop.net>
In-Reply-To: <20080717191425.1vfvithrk0okcg84-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Subject: Re: AR242x wireless card (ath5k)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Quoting Jaco Kroon <jaco@kroon.co.za>:
> 
>> Hi,
>>
>> I've got a Toshiba Satellite 1i4 (P200 derivative) laptop with the
>> following wireless card:
>>
>> 05:00.0 Ethernet controller: Atheros Communications Inc. AR242x
>> 802.11abg Wireless PCI Express Adapter (rev 01)
> 
> That's not sufficient to identify your card.  ath5k should print more 
> detailed information to the kernel log, which is shown by the dmesg 
> command.  If it's AR5006 (MAC revision less than 14.2), the card should 
> work with MSI turned off.  Just add "pci=nomsi" to the kernel command 
> line in the bootloader.  Alternatively, disable CONFIG_PCI_MSI in 
> .config and recompile the kernel.

pci=nomsi doesn't work.

dijkstra ~ # dmesg | grep ath5k
ath5k_pci 0000:05:00.0: registered as 'phy0'
ath5k phy0: Support for RF2425 is under development.
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)

> If it's AR5007, the experimental code is being tested now:
> http://www.kernel.org/pub/linux/kernel/people/mickflemm/
> 
> Look for the latest compat-wireless.  Some people report build problems 
> due to unrelated code in compat-wireless.  It's a known problem, which 
> has nothing to do with the driver itself.

This does work for me against 2.6.26 kernel.  Time to remove the 
wireless support for the kernel and use this instead.  Thanks for the 
pointers.

>> What I would like to know is how I can assist?  I've got a little bit
>> of kernel coding experience and my C is at least reasonable.  I don't
>> have an abundance of time available but can probably nip in a couple of
>> hours worth of work on this.
> 
> I suggest that you subscribe to ath5k-devel, read the mailing list and 
> try dealing with the problems that are reported to the list.  You may 
> also want to see how to adapt madwifi tracing infrastructure to the new 
> mmiotrace code due to appear in Linux 2.6.27.

Subscribed.  Will see what I can do about the mmiotrace stuff ... time 
to go find some documentation.

Thanks for all the good work that you guys do.

Jaco
