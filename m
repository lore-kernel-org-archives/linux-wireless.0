Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48968 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1COHrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 03:47:41 -0400
Received: by wya21 with SMTP id 21so268591wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 00:47:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110314164812.4c0cfc29@toddler>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
Date: Tue, 15 Mar 2011 13:17:40 +0530
Message-ID: <AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
Subject: Re: Could ath9k and rt2800pci bugs be related?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 14, 2011 at 10:18 PM, Tony Houghton <h@realh.co.uk> wrote:
> [I am no longer subscribed to the list so please Cc me]
>
> I'm the person who reported that my system kept freezing when shutting
> down my AR9285 wireless with kernel 2.6.35 or newer.
>
> I've just bought an Acer Aspire Revo 3700 and this had very similar
> symptoms with a different adapter. Luckily another customer had posted
> about it on the vendor's website and his fix works for me. The fix is to
> blacklist the rt2800pci module and the rt2860sta driver seems to work
> quite happily without it.
>
> It looks as if rt2800pci was introduced somewhere between 2.6.32 and
> 2.6.34 and I experienced the crashes with 2.6.35 (Mint 10/Ubuntu 10.10)
> and 2.6.37 (Debian unstable), but not with 2.6.32 (Debian squeeze) which
> doesn't have that module.

can you please check by disabling the supicious rt modules and see
whether this problems happens.
for quick check please try with the latest compat wireless.

>
> It's probably just coincidence, but I was struck by how similar the
> symptoms are and wondered whether these different drivers have anything
> in common?
>
> lspci output:
>
> 02:00.0 Network controller [0280]: RaLink RT3090 Wireless 802.11n 1T/1R PCIe [1814:3090]
>        Subsystem: Lite-On Communications Inc Device [11ad:6622]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at febf0000 (32-bit, non-prefetchable) [size=64K]
>        Capabilities: <access denied>
>        Kernel driver in use: rt2860
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
