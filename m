Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:2968 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763503AbYHEUFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:05:09 -0400
Message-ID: <4898B018.5050202@wpkg.org> (sfid-20080805_220519_408842_EB7A6EEA)
Date: Tue, 05 Aug 2008 21:55:04 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: kernel panic on p54pci insertion on mipsel
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a mipsel device (ASUS WL-500gP; it runs a 2.6.25.9 OpenWRT kernel) with a prism54 mini-pci card:


00:02.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
        Subsystem: Intersil Corporation Unknown device 0000
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 6
        Region 0: Memory at 40002000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Unfortunately, the kernel panics as soon as I try to insert p54pci module (with version 2.7.0.0.arm firmware):

# modprobe p54pci
PCI: Fixing up device 0000:00:02.0
p54: LM86 firmware
p54: FW rev 2.7.0.0 - Softmac protocol 4.1
Data bus error, epc == c00573f4, ra == 8004dd00
Oops[#1]:
Cpu 0
$ 0   : 00000000 fffffffd c0054000 00000001
$ 4   : 00000006 819f4de0 001c7655 00000000
$ 8   : 003d0900 00000000 3b9ac9ff fffffffd
$12   : 328b7400 000001aa 80300000 00000000
$16   : 81b84b00 000000a0 00000001 00000006
$20   : 000000ff 0000000c 00000010 00004000
$24   : 0008891f 00000000
$28   : 802ae000 802afe58 00000010 8004dd00
Hi    : 00000000
Lo    : 00000000
epc   : c00573f4     Not tainted
ra    : 8004dd00 Status: 10009802    KERNEL EXL
Cause : 0080401c
PrId  : 00029006 (Broadcom BCM3302)
Modules linked in: p54pci(+) p54common mac80211 cfg80211 [last unloaded: p54pci]
Process swapper (pid: 0, threadinfo=802ae000, task=802b0160)
Stack : 32a634bf 000001aa 00004000 802f1c51 8004dd00 8004dd00 802fda58 802f1c51
        802e0000 800465a8 802b3aa0 00000006 802e0000 802e0000 8004f1ac 800473f4
        00004000 80029dec 802f1f30 0000000c 00004000 802f1c51 80001e24 80001e0c
        000000ff 0000000c 00000010 00004000 00000000 80002c64 2fe1623c 000001aa
        00007bd4 1000d801 2faf0800 8002eba8 00000000 1000d800 800026f4 00000000
        ...
Call Trace:[<8004dd00>][<8004dd00>][<800465a8>][<8004f1ac>][<800473f4>][<80029dec>][<80001e24>][<80001e0c>][<80002c64>][<8002eba8>][<800026f4>][<80004e0c>]

Code: 8ca20308  27bdffe8  afbf0010 <8c430010> 24a403bc  ac430014  8ca20308  8c420018  00621824
Kernel panic - not syncing: Fatal exception in interrupt


As it is unclear to me which firmware I should use (lspci outputs both ISL3890 and ISL3886 for this device; http://prism54.org/fullmac.html tells that these two cards should use different firmware), I also tried 1.0.4.3.arm firmware - this time, it oopses, with no kernel panic:

# modprobe p54pci
PCI: Fixing up device 0000:00:02.0
CPU 0 Unable to handle kernel paging request at virtual address 4fe7c87f, epc == c00612f8, ra == c0057150
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000d800 00000000 6d656d70
$ 4   : 4fe7c878 6f6f6c5f 80000000 00000002
$ 8   : 00000034 00000001 00000414 00000001
$12   : 00000001 ffffffe0 802f7588 802f75a8
$16   : 4fe7c880 81f60de0 c007cf2c 00000000
$20   : 4fe7c878 81f60160 81c58400 81f60de0
$24   : 00000001 80158dfc
$28   : 81f5a000 81f5bc98 81f60160 c0057150
Hi    : 00000001
Lo    : 084210a0
epc   : c00612f8     Not tainted
ra    : c0057150 Status: 1000d803    KERNEL EXL IE
Cause : 00800008
BadVA : 4fe7c87f
PrId  : 00029006 (Broadcom BCM3302)
Modules linked in: p54pci(+) p54common mac80211 cfg80211 [last unloaded: p54pci]
Process modprobe (pid: 1083, threadinfo=81f5a000, task=81f59998)
Stack : 81f610f0 00000000 81f5a000 81f5bcc8 81f60de0 00000000 81f60160 81c584e4
        00000000 c0060000 c0057150 c0057110 8000c66c 40008000 00002000 81c584e4
        81b4e200 c0060000 81c58458 801285a0 00002000 c0057ffc 40008000 00000001
        00000400 2d17117b 81c584c0 80120cdc 81d3a4b0 81c59d48 800c938c 800c9380
        81c58400 80150140 0000000b 81f5be00 c0058830 81c58400 00000000 81c584e4
        ...
Call Trace:[<c0060000>][<c0057150>][<c0057110>][<8000c66c>][<c0060000>][<801285a0>][<c0057ffc>][<80120cdc>][<800c938c>][<800c9380>][<80150140>][<80022944>]

Code: 0250102b  14400008  00000000 <88850007> 98850004  00051080  0202a021  0254102b  1040ff89
Segmentation fault


Ideas? With 2.6.23.1 kernel, it didn't oops nor panic (but it didn't work then for a different reason - "Out of memory, cannot handle oid"):

http://marc.info/?l=linux-wireless&m=120250829717134&w=2


-- 
Tomasz Chmielewski
http://wpkg.org
