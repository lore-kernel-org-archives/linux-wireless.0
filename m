Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1FFND3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 09:03:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: George Kashperko <george@znau.edu.ua>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
Date: Mon, 6 Jun 2011 15:03:14 +0200
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, Greg KH <greg@kroah.com>,
	linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <201106061332.51661.arnd@arndb.de> <1307363399.28734.25.camel@dev.znau.edu.ua>
In-Reply-To: <1307363399.28734.25.camel@dev.znau.edu.ua>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106061503.14852.arnd@arndb.de> (sfid-20110606_150332_490849_2D9C8B21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 June 2011, George Kashperko wrote:
> > For an interrupt controller, it should be ok to have it initialized
> > late, as long as it's only responsible for the devices on the same
> > bus and not for instance for IPI interrupts. Just make sure that you
> > do the bus scan and the initialization of the IRQ driver before you
> > initialize any drivers that rely in on the interrupts to be working.
>
> Without proper timer init (which requires both the chipcommon and mips
> cores knowledge) kernel will get hung somewhere inside calibrate_delay.
> It could get addressed if get bus scan called in arch_init_irq or
> plat_time_init - both are executed before calibrate_delay and with slab
> available.

Ok, so you need the interrupt controller to be working for the timer tick,
right? I think another option (if that's not what you mean already) would
be to have a simpler way to find a device on the bus that can be called
before doing a full scan.

Early drivers would then have to know what is there and call a function
like "bcma_find_device(BCMA_DEV_ID_IRQ)", while drivers that are not
required to be up just register a regular device driver with a probe
function that gets called after the bus scan creates device structures.

	Arnd
