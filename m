Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:59274 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1FFMjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 08:39:51 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v12.0.0)
	with ESMTP id md50000010001.msg
	for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 15:39:46 +0300
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
From: George Kashperko <george@znau.edu.ua>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, Greg KH <greg@kroah.com>,
	linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com
In-Reply-To: <201106061332.51661.arnd@arndb.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	 <1307311658-15853-2-git-send-email-hauke@hauke-m.de>
	 <BANLkTimAPHPcqKKJ+Rphef_+1RB0aHR4ug@mail.gmail.com>
	 <201106061332.51661.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Jun 2011 15:29:59 +0300
Message-Id: <1307363399.28734.25.camel@dev.znau.edu.ua> (sfid-20110606_143956_151606_6DE359A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On Monday 06 June 2011, Rafał Miłecki wrote:
> > Greg, Arnd: could you take a look at this patch, please?
> > 
> > With proposed patch we are going back to this ugly array and wrappers hacks.
> > 
> > I was really happy with our final solution, but it seems it's not
> > doable for embedded systems...? Is there something better we can do
> > about this?
> > 
> > 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> > > When using bcma on a embedded device it is initialized very early at
> > > boot. We have to do so as the cpu and interrupt management and all
> > > other devices are attached to this bus and it has to be initialized so
> > > early. In that stage we can not allocate memory or sleep, just use the
> > > memory on the stack and in the text segment as the kernel is not
> > > initialized far enough. This patch removed the kzallocs from the scan
> > > code. Some earlier version of the bcma implementation and the normal
> > > ssb implementation are doing it like this.
> > > The __bcma_dev_wrapper struct is used as the container for the device
> > > struct as bcma_device will be too big if it includes struct device.
> > >
> > > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> If you rely on device scan to find your CPUs and interrupt controllers,
> you are screwed already, this won't work.
> 
> In that case, it's better to have a few "early" drivers, as few as
> possible, that don't go through the bus scan at all but have their
> own ways of bootstrapping themselves. I don't know what you mean by
> "CPU management", but I can only assume that it's not doing that much,
> and you can just put the register values into the device tree.
GPIOs, flash and UART could get initialized early without erom scanning
as Chipcommon seems always to be the #0 core on the amba interconnect.

> 
> For an interrupt controller, it should be ok to have it initialized
> late, as long as it's only responsible for the devices on the same
> bus and not for instance for IPI interrupts. Just make sure that you
> do the bus scan and the initialization of the IRQ driver before you
> initialize any drivers that rely in on the interrupts to be working.
Without proper timer init (which requires both the chipcommon and mips
cores knowledge) kernel will get hung somewhere inside calibrate_delay.
It could get addressed if get bus scan called in arch_init_irq or
plat_time_init - both are executed before calibrate_delay and with slab
available.

Have nice day,
George


