Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41782 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GUJDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2012 05:03:42 -0400
Received: by wibhr14 with SMTP id hr14so1301818wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jul 2012 02:03:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFD7B06.4010401@broadcom.com>
References: <4FFD7B06.4010401@broadcom.com>
Date: Sat, 21 Jul 2012 11:03:40 +0200
Message-ID: <CACna6rzGUUNzL-qcDk8gG0n=J9YdDH30VJumvi=YHU83kXVQmQ@mail.gmail.com> (sfid-20120721_110347_328563_FD71DBFA)
Subject: Re: bcma-pci-bridge issue with bcm43224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/11 Arend van Spriel <arend@broadcom.com>:
> Hi Rafal
>
> I am testing with BCM43224 in PCIe slot:
> $ lspci -vns 03:00.0
> 03:00.0 0280: 14e4:4353 (rev 01)
>         Subsystem: 1028:000e
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at e6e00000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: bcma-pci-bridge
>
> In the log the irq field in the bcma_device structure is printed in
> brcmsmac probe function and the value seems invalid hence the
> request_irq() failure. Any clues?

Sorry for late reply, I couldn't setup my testing machine to work with
openSUSE firewall and I couldn't debug that problem remotely :|

I've plugged my BCM43225 and noticed it doesn't provide any RX
(scanning results) for both: b43 and brcmsmac. I suspected it's indeed
the regression you noticed and tried going back to other releases.
After reaching 3.2.0 I noticed sth is wrong. Kernel 3.2.0 was working
for me for sure.

After playing with my machine a little more, I've figured out the
problem. When I had my dedicated GPU card connected to the
motherboard, Broadcom cards diddn't get any RX! I've confirmed that
problem with "wl" driver as well.

After removing my AMD GPU (and switching to the one on the
motherboard) card started working correctly. Even with the latest
wireless-testing, including both: b43 and brcmsmac.

So I can't really debug that problem you're seeing :( Could you try
bisecting this, please?

-- 
Rafał
