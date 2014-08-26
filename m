Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59422 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaHZQmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 12:42:51 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so4809596igc.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2014 09:42:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 18:42:51 +0200
Message-ID: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com> (sfid-20140826_184255_535176_7368A069)
Subject: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[cross-list: linux-mips@ and linux-wireless@]

We're working on another Broadcom platform, SoC with an ARM CPU,
platform called bcm53xx. It shares many things with the older (MIPS
based) bcm47xx, so we need to figure out how to modify some of the
drivers.

Hauke recently proposed sharing code for NVRAM support as a separated
driver. In his RFC patch it was added as a new platform driver. I
liked this idea (I'd simply prefer to modify existing code instead of
duplicating it), so I played with it a bit today.

My plan was to modify bcm47xx code to make nvram.c a separated driver
and update bcm47xx/bcma to use it. Well, it didn't work out. The
problem is that we need access to the NVRAM pretty early. Please take
a look at my description of bcm47xx booting process (it's simply a
summary of start_kernel and bcm47xx code):

1) prom_init / plat_mem_setup
These two functions are called in pretty much the same phase from the
setup_arch (arch/mips/kernel/setup.c).
Task: detect & register memory
Requires: CPU type, maybe Broadcom chip ID (highmem support)
Available: CPU type
Not available: kmalloc, device_add (kobject)

2) arch_init_irq
Called from the arch specific init_IRQ (arch/mips/kernel/irq.c)
Task: setup bcma's MIPS core
Requires: bcma bus MIPS core
Available: kmalloc
Not available: device_add (kobject)

3) plat_time_init
Called from the arch specific time_init (arch/mips/kernel/time.c)
Task: set frequency
Requires: bcma bus ChipCommon core, nvram
Available: kmalloc
Not available: device_add (kobject)

4) At some point we need to register bcma devices, device_initcall can
be used for that

As you can see, we need access to the NVRAM quite early (step 3,
plat_time_init, or even earlier), but device_add (platform
devices/drivers) is not available then yet. So I'm afraid we won't be
able to use this common way to write NVRAM driver.


So there I want to present my plan for the NVRAM improvements. If you
don't agree with any part of it, or you can see any better solution,
please speak up!

1) I won't make nvram.c a platform driver. Instead I would like to
make it less bcm47xx specific. I don't want to touch bcm47xx_bus in
this file. Instead I want to add a generic function that will accept
address and size of memory where NVRAM should be found. Then I'd like
to move this file out of "mips" arch (drivers/misc/?
drivers/bcma/nvram/?) and allow using it for bcm53xx.

2) I was also thinking about cleaning bcm47xx init. Right now we do a
lot of hacks in plat_mem_setup & bcma to register the bus and scan its
cores. It's so early (before mm_init) that we can't alloc memory!
Doing all this stuff slightly later (e.g. arch_init_irq) would allow
us to simply use "kmalloc" and drop all current hacks in bcma.

3) Above change (point 2) would require some small change in bcma. We
would need 2-stages init: detecting (with kmalloc!) bus cores,
registering cores. This is required, because we can't register cores
too early, device_add (and the underlying kobject) would oops/WARN in
kobject_get.

-- 
Rafał
