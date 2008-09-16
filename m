Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56106 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYIPUaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:30:25 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Julius Rafft <juliusrafft@yahoo.com>
Subject: Re: p54 not working with SMC2802W EU
Date: Tue, 16 Sep 2008 22:33:50 +0200
Cc: linux-wireless@vger.kernel.org
References: <251662.40630.qm@web59813.mail.ac4.yahoo.com>
In-Reply-To: <251662.40630.qm@web59813.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809162233.51924.chunkeey@web.de> (sfid-20080916_223027_772596_BBAAA0EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008 16:52:15 Julius Rafft wrote:
> Hi,
>
> relevant dmesg bits:
>
> [ 2482.340701] prism54pci 0000:04:02.0: PCI INT A -> GSI 23 (level, low) ->
> IRQ 23 [ 2482.390380] firmware: requesting isl3886
> [ 2482.393546] p54: LM86 firmware
> [ 2482.393552] p54: FW rev 2.5.3.0 - Softmac protocol 3.0
> [ 2483.236740] p54: unknown eeprom code : 0x1
> [ 2483.238706] phy0: Selected rate control algorithm 'pid'
> [ 2483.241611] phy0: hwaddr 00:04:e2:ec:b1:4b, isl3886
> [ 2487.309923] firmware: requesting isl3886
> [ 2487.345457] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 2487.480817] phy0: unknown frame RXed (0x65)
> [ 2487.487612] phy0: unknown frame RXed (0x20)
>[...]

> Note I use the 2.5.3.0 firmware since it is the one included
> in the windows driver that came with my card. I also tried
> the others (2.7.0.0 and 2.13.1.0) but also no joy.
Do you have some sort of a big-endian architecture?

Anyway, 2.13.1.0 is only useful if you are working with wireless-testing/
wireless-next git tree, it won't work with any older driver.

So please, checkout the current wireless-next and see what it does.
>
> with 2.5.3.0 it actually managed to associate, but only
> once, only for a couple of seconds and even then it
> didn't manage to "authenticate" (despite having no
> encryption/security whatsoever in this access point)
>
???
No?... If a card can't authenticate, it won't even try to associate.

Maybe the firmware crashes shortly after the first few successful 
transmission. At least there are some hints (unknown frame RXed) that 
something fishy is going on. Maybe another wlan device in monitor
mode can help here.... but let's try the simple solutions first ;-)

Regards,
	Chr
