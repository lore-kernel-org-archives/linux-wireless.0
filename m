Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h1355771.stratoserver.net ([85.214.105.140]:53202 "EHLO
	h1355771.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2FLWQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 18:16:41 -0400
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
From: Andreas Kemnade <andreas@kemnade.info>
To: Dan Williams <dcbw@redhat.com>
Cc: dsd@laptop.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1339528734.14638.14.camel@dcbw.foobar.com>
References: <1339247007.5895.373.camel@localhost>
	 <1339528734.14638.14.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 13 Jun 2012 00:16:00 +0200
Message-ID: <1339539360.3284.235.camel@localhost> (sfid-20120613_001644_283049_92E3460C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2012-06-12 at 14:18 -0500, Dan Williams wrote:
> On Sat, 2012-06-09 at 15:03 +0200, Andreas Kemnade wrote:
> > Hi,
> > 
> > on the GTA04 (www.gta04.org) 
> > which has a W2CBW003 chip for wifi connected to a DM3730CBP CPU. data
> > rates are quite low using the libertas driver from kernel 3.2-3.4 
> > (https://github.com/neilbrown/gta04/branches)
> > even near an accesspoint. That seems not depend on the encryption
> > settings. Rates are around 100KByte/s. iwconfig shows 5.5Mb/s if it is
> > not connected to an accesspoint with specially configured rates (but
> > still the throughput is low).
> > 
> > In contrary data rates are high (>1MByte/s) with a kernel based on
> > the 2.6.32  BeagleBoard XM hw-validation kernel
> > https://github.com/goldelico/gta04-kernel
> > That behaviour was reported by several people.
> > 
> > I tried also the libertas-tf driver with kernel 3.2 using the
> > instructions here:
> > http://corysohrakoff.wordpress.com/2011/09/13/enabling-wifi-ap-mode-on-a-gumstix-overo/
> > That was also slow.
> > 
> > Any hints?
> 
> GSPI or SDIO?  What SD host controller?  Does the controller support
It is the host controller integrated into the SoC (the DM3730 from TI).
There is
a level shifter (the 74avca406) in between.

> 4-bit mode correctly?  What block sizes does it support?  Most often the
> issue is with crappy  host controllers that need workarounds or quirks
> to correctly support the higher speeds that the driver can do.  The
> benchmark I always used was that on a laptop with a Ricoh SD controller,
> I could easily pull megabits per second even 15 feet away.
>
4 bit is supported.
The hardware does not impose unresolvable limitations, the 2.6.32 kernel
gives high performance. But since that kernel is not mainstream, it is
very hard to find out which patch gives the slowdown. git bisect
is not very useful in that situation.
SD memory card reading speed is always ok (on another of the integrated
sd host controllers).

I'm citing from the 
AM/DM37x Multimedia Device
Silicon Revision 1.x
Version O
Technical Reference Manual from TI page 3396
from http://www.ti.com/product/dm3730
here:

>The known limitations are as follows:
>· No built-in hardware support for error correction codes (ECC). See
>the Multimedia Card System
>   Specification, v4.2, and the SD Memory Card Specifications, v2.0,
>for details about ECC.
>· The maximum block size defined in the SD Memory Card Specifications,
>v2.0, that the host driver can
>   read and write to the buffer in the host controller is 2048 bytes. 
> MMC supports a maximum block size
>   of 1024 bytes. Up to 512 byte transfers, the buffer in MMC is
>considered as a double buffering with
>   ping-pong management; half of the buffer can be written while the
>other part is read. For 512 to 1024
>   byte transfers, the entire buffer is dedicated to the transfer (read
>only or write only).


>The differences between the MMC/SD/SDIO host controllers and a
>standard SD host controller are
>defined by the SD Card Specification, Part A2, SD Host Controller
>Standard Specification, v1.00, as
>follows:
>· The MMC/SD/SDIO host controllers support MMC cards.
>· The MMC/SD/SDIO host controller is defined as a DMA slave device. A
>standard SD host controller is
>    defined as a DMA master controller that can start and stop a DMA
>transfer. MMC/SD/SDIO host
>    controllers support DMA transfers through slave DMA requests.
>· The clock divider in MMC/SD/SDIO host controller supports a wider
>range of frequency than specified
>    in the SD Memory Card Specifications, v2.0. The MMC/SD/SDIO host
>controller supports odd and
>    even clock ratio.
>· The MMC/SD/SDIO host controller supports configurable busy time-out.

Maybe you can name the limitation which might be problematic here.

Greetings
Andreas Kemnade


