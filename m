Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n15b.bullet.mail.mud.yahoo.com ([68.142.207.236]:38750 "HELO
	n15b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753476AbYIOO53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:57:29 -0400
Date: Mon, 15 Sep 2008 07:52:15 -0700 (PDT)
From: Julius Rafft <juliusrafft@yahoo.com>
Subject: p54 not working with SMC2802W EU
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <251662.40630.qm@web59813.mail.ac4.yahoo.com> (sfid-20080915_165733_609921_CEBC8CE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have an SMC2802W card which seems it should work with the p54 driver.
Yet I cannot associate to an ap even if the AP is right next to the card:

lspci -n:
04:02.0 0280: 1260:3890 (rev 01)

lspci -vvv:
04:02.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
        Subsystem: Accton Technology Corporation Device ee03
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f9ffe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: prism54pci
        Kernel modules: prism54, p54pci



relevant dmesg bits:

[ 2482.340701] prism54pci 0000:04:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[ 2482.390380] firmware: requesting isl3886
[ 2482.393546] p54: LM86 firmware
[ 2482.393552] p54: FW rev 2.5.3.0 - Softmac protocol 3.0
[ 2483.236740] p54: unknown eeprom code : 0x1
[ 2483.236745] p54: unknown eeprom code : 0x3
[ 2483.236747] p54: unknown eeprom code : 0x1007
[ 2483.236748] p54: unknown eeprom code : 0x1008
[ 2483.236750] p54: unknown eeprom code : 0x1100
[ 2483.236751] p54: unknown eeprom code : 0x1905
[ 2483.238706] phy0: Selected rate control algorithm 'pid'
[ 2483.241611] phy0: hwaddr 00:04:e2:ec:b1:4b, isl3886
[ 2487.309923] firmware: requesting isl3886
[ 2487.345457] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2487.480817] phy0: unknown frame RXed (0x65)
[ 2487.487612] phy0: unknown frame RXed (0x20)
[ 2487.507937] phy0: unknown frame RXed (0x20)
[ 2487.536800] phy0: unknown frame RXed (0x20)
[ 2487.543233] phy0: unknown frame RXed (0x20)
[ 2487.610339] phy0: unknown frame RXed (0x20)
[ 2487.917553] phy0: unknown frame RXed (0x65)
[ 2488.019956] phy0: unknown frame RXed (0x20)
[ 2488.429569] phy0: unknown frame RXed (0x20)
[ 2488.531975] phy0: unknown frame RXed (0x20)
[ 2488.941588] phy0: unknown frame RXed (0x20)
[ 2489.556011] phy0: unknown frame RXed (0x20)
[ 2490.784854] phy0: unknown frame RXed (0x65)
[ 2490.887254] phy0: unknown frame RXed (0x20)
[ 2491.296871] phy0: unknown frame RXed (0x20)
[ 2491.399273] phy0: unknown frame RXed (0x20)
[ 2491.808888] phy0: unknown frame RXed (0x20)


Note I use the 2.5.3.0 firmware since it is the one included
in the windows driver that came with my card. I also tried
the others (2.7.0.0 and 2.13.1.0) but also no joy.

with 2.5.3.0 it actually managed to associate, but only
once, only for a couple of seconds and even then it
didn't manage to "authenticate" (despite having no
encryption/security whatsoever in this access point)

Any ideas? If there is any additional info I can provide
or a way to better debug/understand what is happening
that would be great.

Thanks,
Julius




      

