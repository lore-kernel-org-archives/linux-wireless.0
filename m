Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:37105 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZGJRJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 13:09:13 -0400
MIME-Version: 1.0
In-Reply-To: <20090710143253.GA4133@matrix.chaos.earth.li>
References: <20090710143253.GA4133@matrix.chaos.earth.li>
Date: Fri, 10 Jul 2009 10:03:55 -0700
Message-ID: <4a5ff6bc0907101003i30a1589fl18048af4c8ff2853@mail.gmail.com>
Subject: Re: PROBLEM: USB wlan device stops working; ehci "kernel BUG"
From: Steve Calfee <stevecalfee@gmail.com>
To: Ian Lynagh <igloo@earth.li>
Cc: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 10, 2009 at 7:32 AM, Ian Lynagh<igloo@earth.li> wrote:
>
> Hi all,
>
> [1.] PROBLEM: USB wlan device stops working; ehci "kernel BUG"
>
> [2.]
>
> I am having a problem with an rt73usb and/or ehci. I /think/ the bug is
> in ehci, and the rt73usb problems are just a symptom, but I'm not sure.
>
> The actual problem is that after a while (generally a few days, I think)
> my USB wireless device stops working. I've attached the dmesg log at the
> point that I noticed it stopped working today; unfortunately, I don't
> know exactly when it broke. My guess is it was at this line, though:
>
> [582576.209231] ehci_hcd 0000:00:12.2: force halt; handhake ffffc20000636024 00004000 00000000 -> -110
>
Hi I've seen this too. Once the "handhake" error happens, the ehci
controller is off line until a reboot. Connect/disconnect is no longer
detected on any port. I did not try to see if rmmod/insmod for echi
fixed the problem.

I caused it with a very heavy bulk load (flash to flash copy), and
then lots of control traffic to another device (a scanner and once a
webcam) while the third device was starting up. It seemed very timing
sensitive.

<snip>

> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
>        Subsystem: Giga-byte Technology Device 5004
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32, Cache Line Size: 64 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [c0] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>                Bridge: PM- B3+
>        Capabilities: [e4] Debug port: BAR=1 offset=00e0
>        Kernel driver in use: ehci_hcd
>        Kernel modules: ehci-hcd
>

And this is the southbridge where I had the problem, too. On an
earlier kernel someone at AMD presented some patches to ehci for the
sb600 and sb700 which had some startup hang problems. I think they
will need to be consulted for a workaround for this problem.

I no longer have access to the system where I ran into the problem, so
I cannot give more details, sorry.

Regards, Steve
