Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1G3LJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 07:09:32 -0400
Received: by fxh19 with SMTP id 19so3021784fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 04:09:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Martin Partridge" <martin_partridge@btconnect.com>
Subject: Re: help with wg511v2
Date: Sat, 30 Jul 2011 13:12:17 +0200
Cc: linux-wireless@vger.kernel.org
References: <op.vzcrpnuuhgplxr@melanie> <201107290147.26919.chunkeey@googlemail.com> <op.vzexmjbnhgplxr@melanie>
In-Reply-To: <op.vzexmjbnhgplxr@melanie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107301312.17758.chunkeey@googlemail.com> (sfid-20110730_130943_193522_B8EDE270)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 July 2011 05:36:09 Martin Partridge wrote:
> I've checked everything and the WG511v2 is still not lighting up and it
> isn't showing as a network card, it is detected when plugged in:
> 
> [13523.594828] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
> [13524.917077] pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
> [13524.917132] pci 0000:02:00.0: [11ab:1faa] type 0 class 0x000200
> [13524.917176] pci 0000:02:00.0: reg 10: [mem 0xd0000000-0xd000ffff]
> [13524.917200] pci 0000:02:00.0: reg 14: [mem 0xc0000000-0xc000ffff]
>...
> and when the output from lspci is:
> 
> 00:09.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro
> 100 (rev 09)
> 00:09.1 Serial controller: Agere Systems LT WinModem
> 02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
    ^^^^^^^

Ah, this explains it everything. You are unfortunately a victim of Netgear's stupid
naming scam. The situation is explained at http://daemonizer.de/prism54/wg511/ 
The upshot is: there are two WG511 v2 versions, but only the first v2 works with
p54. The second one needs a driver from marvell.

Regards,
	Chr
