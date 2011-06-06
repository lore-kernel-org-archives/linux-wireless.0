Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1FFLdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:33:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
Date: Mon, 6 Jun 2011 13:32:51 +0200
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Greg KH <greg@kroah.com>,
	linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <1307311658-15853-2-git-send-email-hauke@hauke-m.de> <BANLkTimAPHPcqKKJ+Rphef_+1RB0aHR4ug@mail.gmail.com>
In-Reply-To: <BANLkTimAPHPcqKKJ+Rphef_+1RB0aHR4ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106061332.51661.arnd@arndb.de> (sfid-20110606_133306_701799_5F911EB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 June 2011, Rafał Miłecki wrote:
> Greg, Arnd: could you take a look at this patch, please?
> 
> With proposed patch we are going back to this ugly array and wrappers hacks.
> 
> I was really happy with our final solution, but it seems it's not
> doable for embedded systems...? Is there something better we can do
> about this?
> 
> 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> > When using bcma on a embedded device it is initialized very early at
> > boot. We have to do so as the cpu and interrupt management and all
> > other devices are attached to this bus and it has to be initialized so
> > early. In that stage we can not allocate memory or sleep, just use the
> > memory on the stack and in the text segment as the kernel is not
> > initialized far enough. This patch removed the kzallocs from the scan
> > code. Some earlier version of the bcma implementation and the normal
> > ssb implementation are doing it like this.
> > The __bcma_dev_wrapper struct is used as the container for the device
> > struct as bcma_device will be too big if it includes struct device.
> >
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

If you rely on device scan to find your CPUs and interrupt controllers,
you are screwed already, this won't work.

In that case, it's better to have a few "early" drivers, as few as
possible, that don't go through the bus scan at all but have their
own ways of bootstrapping themselves. I don't know what you mean by
"CPU management", but I can only assume that it's not doing that much,
and you can just put the register values into the device tree.

For an interrupt controller, it should be ok to have it initialized
late, as long as it's only responsible for the devices on the same
bus and not for instance for IPI interrupts. Just make sure that you
do the bus scan and the initialization of the IRQ driver before you
initialize any drivers that rely in on the interrupts to be working.

	Arnd
