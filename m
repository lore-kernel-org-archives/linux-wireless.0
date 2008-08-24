Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:38097 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYHXM0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 08:26:50 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1400660mue.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Aug 2008 05:26:49 -0700 (PDT)
Date: Sun, 24 Aug 2008 12:24:38 +0000
From: =?utf-8?Q?Beno=C3=AEt?= Knecht <benoit.knecht@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY
Message-ID: <20080824122438.GA6399@wilfried.groenland> (sfid-20080824_142705_160662_F78163D4)
References: <200808160029.56876.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200808160029.56876.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> PLEASE TEST TEST TEST TEST TEST

I tested your patch on my 4318, and it seems performance and stability
are pretty much the same as unpatched wireless-testing. Here's what
dmesg has to say:
# dmesg | grep b43
b43-pci-bridge 0001:10:12.0: enabling device (0004 -> 0006)
b43-phy0: Broadcom 4318 WLAN found
b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
firmware: requesting b43/ucode5.fw
firmware: requesting b43/pcm5.fw
firmware: requesting b43/b0g0initvals5.fw
firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0: Radio turned on by software
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac:
00:16:b6:a3:26:91
b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac:
ff:ff:ff:ff:ff:ff

and the exact description of my card:
# lspci -vn
0001:10:12.0 0280: 14e4:4318 (rev 02)
        Subsystem: 106b:4318
        Flags: bus master, fast devsel, latency 16, IRQ 52
        Memory at 80084000 (32-bit, non-prefetchable) [size=3D8K]
        Kernel driver in use: b43-pci-bridge
        Kernel modules: ssb

I transfered some files around using both patched and unpatched
wireless-testing, and I get very similar results in both cases:
around 2.6 MB/s upload and 3.5 MB/s download. This is a couple rooms
away from the AP, with a signal quality of 58/100.

I will continue using this kernel for some time, and will report back
here if I notice anything peculiar.

I hope I didn't forget anything useful, but the bottom line is that I
didn't see any difference between patched and unpatched
wireless-testing, and if you need me to run some more tests, I'd be
happy to; please let me know.

--
Beno=C3=AEt
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
