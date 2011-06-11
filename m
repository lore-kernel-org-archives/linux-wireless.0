Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56298 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1FKWdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 18:33:42 -0400
Message-ID: <4DF3ED3D.6060003@hauke-m.de> (sfid-20110612_003346_910922_6F3F0531)
Date: Sun, 12 Jun 2011 00:33:33 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	George Kashperko <george@znau.edu.ua>,
	Greg KH <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>	<201106061503.14852.arnd@arndb.de>	<4DED48EA.7070001@hauke-m.de>	<201106062353.40470.arnd@arndb.de>	<4DEDF98C.6020905@broadcom.com>	<4DEE9BCD.1030304@hauke-m.de>	<BANLkTikUqj-R72XaOXnifhKv-n1ZSJMxDQ@mail.gmail.com> <20110608102001.294a4ff2@maggie>
In-Reply-To: <20110608102001.294a4ff2@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2011 10:20 AM, Michael Büsch wrote:
> On Wed, 8 Jun 2011 02:06:11 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
> 
>> Because full scanning needs one of the following:
>> 1) Working alloc - not possible for SoCs
> 
> Isn't there a bootmem allocator available on MIPS?

The bootmem allocator is working on mips, but it is initialized after
plat_mem_setup() was called. To use it we have to move the start of bcma
to some other place in the bcm47xx code.

We need access to the common and mips core for different functions in
the bcm47xx code and these functions are getting called by the mips
code, so we can not store these struct bcma_devices on the stack.

I would use this struct on the embedded device and use it in the text
segment of the bcm47xx code.

In include/linux/bcma/bcma.h:
struct bcma_soc {
	struct bcma_bus bus;
	struct bcma_device core_cc;
	struct bcma_device core_mips;
};

In arch/mips/bcm47xx/setup.c
struct bcma_soc bus;

The chipcommon and mips core can be initilized early without the need
use of any alloc. The bcm47xx code will call
bcma_bus_early_register(struct bcma_soc *soc) and this code will find
these two cores, add then to the list of cores in bcma_bus and run the
init code for them. After that we have all we need to boot up the
device. After the kernel page allocator is fully set up we would search
for all the other cores and add them to the list of cores and do the
initialization for them. The two cores in struct bcma_soc will never be
accessed directly but only through struct bcma_bus so that there is no
difference from early boot and normal mode.

Hauke
