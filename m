Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37284 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbeCWJro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 05:47:44 -0400
Date: Fri, 23 Mar 2018 10:47:40 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: b43-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [QUESTION] Mainline support for B43_PHY_AC wifi cards
Message-ID: <20180323094740.GA5942@localhost.localdomain> (sfid-20180323_104803_638724_A6E67129)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've got a Dell XPS 13 9343/0TM99H (BIOS A15 01/23/2018) mounting a
BCM4352 802.11ac (rev 03) wireless card and so far I've been using it on
Fedora with broadcom-wl package (which I believe installs Broadcom's STA
driver?). It works good apart from occasional hiccups after suspend.

I'd like to get rid of that dependency (you can understand that it's
particularly annoying when testing mainline kernels), but I found out
that support for my card is BROKEN in mainline [1]. Just to see what
happens, I forcibly enabled it witnessing that it indeed crashes like
below as Kconfig warns. :)

 bcma: bus0: Found chip with id 0x4352, rev 0x03 and package 0x00
 bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2B, class 0x0)
 bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2A, class 0x0)
 bcma: bus0: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x02, class 0x0)
 bcma: bus0: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x01, class 0x0)
 bcma: bus0: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x11, class 0x0)
 bcma: Unsupported SPROM revision: 11
 bcma: bus0: Invalid SPROM read from the PCIe card, trying to use fallback SPROM
 bcma: bus0: Using fallback SPROM failed (err -2)
 bcma: bus0: No SPROM available
 bcma: bus0: Bus registered
 b43-phy0: Broadcom 4352 WLAN found (core revision 42)
 b43-phy0: Found PHY: Analog 12, Type 11 (AC), Revision 1
 b43-phy0: Found Radio: Manuf 0x17F, ID 0x2069, Revision 4, Version 0
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000000

So, question: is replacing my card the only way I can get rid of this
downstream dependency? :(

Thanks a lot.

Best,

- Juri

[1] https://elixir.bootlin.com/linux/v4.16-rc6/source/drivers/net/wireless/broadcom/b43/Kconfig#L151
