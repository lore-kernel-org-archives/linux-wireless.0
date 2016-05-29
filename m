Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:53843 "EHLO
	mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbcE2Xs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 19:48:58 -0400
Date: Mon, 30 May 2016 01:52:29 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wlan-client-support-list@broadcom.com, 1332647@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Eric Dumazet <edumazet@google.com>
Subject: Re: BCM4331 reset leads to wl lockup
Message-ID: <20160529235229.GA13107@wunner.de> (sfid-20160530_014917_566149_38786974)
References: <20160526121210.GA7006@wunner.de>
 <20160526144246.217bfff1@wiggum>
 <20160529110248.GA12632@wunner.de>
 <574B3B05.3020106@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <574B3B05.3020106@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[cc += Eric Dumazet]

On Sun, May 29, 2016 at 08:55:01PM +0200, Arend van Spriel wrote:
> On 29-05-16 13:02, Lukas Wunner wrote:
> > On Thu, May 26, 2016 at 02:42:46PM +0200, Michael Büsch wrote:
> >> On Thu, 26 May 2016 14:12:10 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> >>> +	mmio = early_ioremap(addr, BCM4331_MMIO_SIZE);
> >>> +	if (!mmio) {
> >>> +		pr_err("Cannot iomap Apple AirPort card\n");
> >>> +		return;
> >>> +	}
> >>> +	pr_info("Resetting Apple AirPort card\n");
> >>> +	iowrite32(BCMA_RESET_CTL_RESET,
> >>> +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> >>> +	early_iounmap(mmio, BCM4331_MMIO_SIZE);
> >>
> >> Just writing that bit is not the correct reset procedure.
> >> So it might cause problems depending on how wl does the core reset
> >> later.
> >>
> >> Please try this:
> >> - wait for BCMA_RESET_ST to be 0
> >> - set reset bit
> >> - flush
> >> - wait 1us
> >> - reset reset bit
> >> - flush
> >> - wait 10us
> >>
> >> See bcma_core_disable()
> > 
> > It turned out that the lockups are triggered by bec3cfdca36b
> > ("net: skb_segment() provides list head and tail") in Linux 3.18
> > and that Eric Dumazet has kindly provided a fix for broadcom-sta:
> > https://bugs.gentoo.org/show_bug.cgi?id=523326#c24
> > https://523326.bugs.gentoo.org/attachment.cgi?id=393374
> 
> Looked at the patch and it provides little context. So before diving in
> the code would you know if the patched broadcom-sta driver works for
> kernels before 3.18?

I'm not familiar with the broadcom-sta code but I'm inclined to say yes.

The function modified by the patch, wl_start(), contains an if/else
statement, the if-branch puts a packet to be transmitted on a work
queue and the else-branch transmits it straight away. Apparently
skb->prev isn't initialized to NULL for the else-branch which wasn't
an issue until bec3cfdca36b. That's my superficial understanding of
that code, I'm sure you have access to the full source and revision
history and can make more sense of it than I do.

Best regards,

Lukas
