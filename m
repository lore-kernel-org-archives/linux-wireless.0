Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:54000 "EHLO
	mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbcE2K7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 06:59:17 -0400
Date: Sun, 29 May 2016 13:02:48 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: linux-wlan-client-support-list@broadcom.com, 1332647@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: BCM4331 reset leads to wl lockup
Message-ID: <20160529110248.GA12632@wunner.de> (sfid-20160529_125936_343540_FBCE1B7E)
References: <20160526121210.GA7006@wunner.de>
 <20160526144246.217bfff1@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20160526144246.217bfff1@wiggum>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2016 at 02:42:46PM +0200, Michael Büsch wrote:
> On Thu, 26 May 2016 14:12:10 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > +	mmio = early_ioremap(addr, BCM4331_MMIO_SIZE);
> > +	if (!mmio) {
> > +		pr_err("Cannot iomap Apple AirPort card\n");
> > +		return;
> > +	}
> > +	pr_info("Resetting Apple AirPort card\n");
> > +	iowrite32(BCMA_RESET_CTL_RESET,
> > +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> > +	early_iounmap(mmio, BCM4331_MMIO_SIZE);
> 
> Just writing that bit is not the correct reset procedure.
> So it might cause problems depending on how wl does the core reset
> later.
> 
> Please try this:
> - wait for BCMA_RESET_ST to be 0
> - set reset bit
> - flush
> - wait 1us
> - reset reset bit
> - flush
> - wait 10us
> 
> See bcma_core_disable()

It turned out that the lockups are triggered by bec3cfdca36b
("net: skb_segment() provides list head and tail") in Linux 3.18
and that Eric Duzamet has kindly provided a fix for broadcom-sta:
https://bugs.gentoo.org/show_bug.cgi?id=523326#c24
https://523326.bugs.gentoo.org/attachment.cgi?id=393374

@Broadcom: Please consider releasing a new driver version which
incorporates that patch. The latest version 6.30.223.271 of your
driver is still missing it even though the issue has existed for
almost 18 months now.

Nevertheless I amended my patch to follow the reset procedure you
specified above, just to cover all bases. Thanks Michael.

Best regards,

Lukas
