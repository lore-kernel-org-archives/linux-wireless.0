Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55768 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3G1UlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 16:41:18 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: FUSB200 xhci issue
Date: Sun, 28 Jul 2013 22:41:12 +0200
Message-ID: <6066029.JHY9cn8Gkh@blech> (sfid-20130728_224140_990585_8FE6D823)
In-Reply-To: <51F52A89.4050506@rempel-privat.de>
References: <51ED4E12.8030006@rempel-privat.de> <51F50AB7.3030204@rempel-privat.de> <51F52A89.4050506@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 28, 2013 04:28:25 PM Oleksij Rempel wrote:
> Am 28.07.2013 14:12, schrieb Oleksij Rempel:
> > Am 28.07.2013 13:38, schrieb Christian Lamparter:
> >
> >>>>
> >>>> Anyway, I tried the -next branch.
> >>>>
> >>>> commit dbbb809d592dde0b3c9ecb97b3b387ff8e40e799
> >>>> Author: Oleksij Rempel <linux@rempel-privat.de>
> >>>> Date:   Wed Jul 24 10:26:18 2013 +0200
> >>>>
> >>>>       k2_fw_usb_api: workaround for EP4 bug.
> >>>>
> >>>> but still, the device won't show up after autosuspend.
> >>>
> >>> Hm... firmware probably didn't rebooted before suspend. Did interface
> >>> was up, before autosuspend? If no, you need latest wireles-testing -
> >>> there are patches to handle this issue. Or just make "ifconfig wlan1 up"
> >>>    before  rmmod.
> >> Oh, I it was on the latest wireless-testing. (And the "ath9k_htc" module
> >> had the patch "ath9k_htc: reboot firmwware if it was loaded").
> >>
> >> Furthermore, I did the same test with one of the ehci-only ports
> >> and it worked. Both, devices (one had a AR7015, the other a AR9271)
> >> came back after autosuspend there.
> >
> > Grrr... so it brings us back to xhci issue. Even EP4 workaround wont
> > work here :( Suddenly i have no more ideas.
> >
> > Sarah, it's your turn now.
> 
> Christian,
> can you please provide some more info about your xhci controller. I'll 
> try to get me same.

Well, it's a laptop (HP DV6-6003EG). I recon that getting 100% the
same setup will be difficult. However, since the uPD720200 was/is
very popular, it should be very easy to find one. [It's probably
on all of these "10 euro usb-3.0 pcie-adapters". So as long as you
got a free 1x-pcie port you should be good.]

Here's the lspci summary:

19:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194] (rev 04) (prog-if 30 [XHCI])
        Subsystem: Hewlett-Packard Company Device [103c:1657]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at d3400000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: xhci_hcd

Regards,
	Chr
