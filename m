Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35490 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751294AbeCWNna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <20180323094740.GA5942@localhost.localdomain>
References: <20180323094740.GA5942@localhost.localdomain>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 23 Mar 2018 14:43:28 +0100
Message-ID: <CACna6rx-QNQhVNkwFSabwAY9vM1qV_gTcWywsHFuP5B4NH4NXA@mail.gmail.com> (sfid-20180323_144351_022332_27EF09D1)
Subject: Re: [QUESTION] Mainline support for B43_PHY_AC wifi cards
To: Juri Lelli <juri.lelli@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 23 March 2018 at 10:47, Juri Lelli <juri.lelli@gmail.com> wrote:
> I've got a Dell XPS 13 9343/0TM99H (BIOS A15 01/23/2018) mounting a
> BCM4352 802.11ac (rev 03) wireless card and so far I've been using it on
> Fedora with broadcom-wl package (which I believe installs Broadcom's STA
> driver?). It works good apart from occasional hiccups after suspend.
>
> I'd like to get rid of that dependency (you can understand that it's
> particularly annoying when testing mainline kernels), but I found out
> that support for my card is BROKEN in mainline [1]. Just to see what
> happens, I forcibly enabled it witnessing that it indeed crashes like
> below as Kconfig warns. :)
>
>  bcma: bus0: Found chip with id 0x4352, rev 0x03 and package 0x00
>  bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2B, class 0x0)
>  bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2A, class 0x0)
>  bcma: bus0: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x02, class 0x0)
>  bcma: bus0: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x01, class 0x0)
>  bcma: bus0: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x11, class 0x0)
>  bcma: Unsupported SPROM revision: 11
>  bcma: bus0: Invalid SPROM read from the PCIe card, trying to use fallback SPROM
>  bcma: bus0: Using fallback SPROM failed (err -2)
>  bcma: bus0: No SPROM available
>  bcma: bus0: Bus registered
>  b43-phy0: Broadcom 4352 WLAN found (core revision 42)
>  b43-phy0: Found PHY: Analog 12, Type 11 (AC), Revision 1
>  b43-phy0: Found Radio: Manuf 0x17F, ID 0x2069, Revision 4, Version 0
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000

This isn't really useful without a full backtrace.


> So, question: is replacing my card the only way I can get rid of this
> downstream dependency? :(

It's definitely the cheapest way. Getting AC PHY into anything usable
(proper setup that will allow Tx & Rx anything) would probably take
weeks or months of development. I'm not even going to estimate cost of
adding support for 802.11n and 802.11ac features. I was the last
person actively working on b43, right now I spend my free time on
other hobby projects. Few people were planning to help but it seems it
never worked out for them.
