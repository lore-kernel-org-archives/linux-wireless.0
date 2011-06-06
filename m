Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40750 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FFVjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 17:39:02 -0400
Message-ID: <4DED48EA.7070001@hauke-m.de> (sfid-20110606_233906_628247_CF37E131)
Date: Mon, 06 Jun 2011 23:38:50 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: George Kashperko <george@znau.edu.ua>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, mb@bu3sch.de, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <201106061332.51661.arnd@arndb.de> <1307363399.28734.25.camel@dev.znau.edu.ua> <201106061503.14852.arnd@arndb.de>
In-Reply-To: <201106061503.14852.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 03:03 PM, Arnd Bergmann wrote:
> On Monday 06 June 2011, George Kashperko wrote:
>>> For an interrupt controller, it should be ok to have it initialized
>>> late, as long as it's only responsible for the devices on the same
>>> bus and not for instance for IPI interrupts. Just make sure that you
>>> do the bus scan and the initialization of the IRQ driver before you
>>> initialize any drivers that rely in on the interrupts to be working.
>>
>> Without proper timer init (which requires both the chipcommon and mips
>> cores knowledge) kernel will get hung somewhere inside calibrate_delay.
>> It could get addressed if get bus scan called in arch_init_irq or
>> plat_time_init - both are executed before calibrate_delay and with slab
>> available.
> 
> Ok, so you need the interrupt controller to be working for the timer tick,
> right? I think another option (if that's not what you mean already) would
> be to have a simpler way to find a device on the bus that can be called
> before doing a full scan.
> 
> Early drivers would then have to know what is there and call a function
> like "bcma_find_device(BCMA_DEV_ID_IRQ)", while drivers that are not
> required to be up just register a regular device driver with a probe
> function that gets called after the bus scan creates device structures.
> 
> 	Arnd
Accessing chip common should be possible without scanning the hole bus
as it is at the first position and initializing most things just needs
chip common. For initializing the interrupts scanning is needed as we do
not know where the mips core is located.

As we can not use kalloc on early boot we could use a function which
uses kalloc under normal conditions and when on early boot the
architecture code which starts the bcma code should also provide a
function which returns a pointer to some memory in its text segment to
use. We need space for 16 cores in the architecture code.

In addition bcma_bus_register(struct bcma_bus *bus) has to be divided
into two parts. The first part will scan the bus and initialize chip
common and mips core. The second part will initialize pci core and
register the devices in the system. When using this under normal
conditions they will be called directly after each other.

Hauke
