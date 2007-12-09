Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:27364 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751078AbXLITl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 14:41:59 -0500
Date: Sun, 9 Dec 2007 19:41:58 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1193657365.19938.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <587622.50680.qm@web52902.mail.re2.yahoo.com> (sfid-20071209_194211_874642_749EE34D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've recently been having trouble loading the hostap_plx 802.11b wireless networking driver, and
this evening I managed to narrow the problem down to these lines of code by copying code from
hostap_plx into a "test driver" until the test driver also locked the PC up:

        /* read CIS; it is in even offsets in the beginning of attr_mem */
        for (i = 0; i < CIS_MAX_LEN; i++)
                cis[i] = readb(attr_mem + 2 * i);

If I comment these lines out then my test driver just complains about the garbage CIS information
and fails gracefully. Leave these lines in and my PC freezes instantly.

These lines are part of the prism2_plx_check_cis() function, which is called when the module first
loads. CIX_MAX_LEN is a #define for 256, and cis is a u8* pointer previously allocated as:

cis = kmalloc(CIS_MAX_LEN, GFP_KERNEL);

attr_mem is one of the function's paramters, and is defined as void __iomem *attr_mem.

As far as I can tell, the PCI I/O memory information is correct, and matches what lspci tells me:

00:0e.0 Network controller: Netgear MA301 802.11b Wireless PCI Adapter (rev 02)
        Subsystem: Netgear MA301 802.11b Wireless PCI Adapter
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+
FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR-
        Interrupt: pin A routed to IRQ 5
        Region 1: I/O ports at 1000 [size=128]
        Region 2: Memory at e8002000 (32-bit, non-prefetchable) [size=4K]
        Region 3: I/O ports at 1080 [size=64]

so there is apparently 4K of I/O memory at 0xe8002000.

Can anyone help me understand why my PC is locking up when it executes this code, please?

Thanks,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

