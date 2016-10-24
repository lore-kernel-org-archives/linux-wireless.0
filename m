Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from obi-wan.optimeas.de ([82.165.198.204]:51380 "EHLO
        obi-wan.optimeas.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752075AbcJXK2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 06:28:06 -0400
From: "Matthias Klein" <matthias.klein@optimeas.de>
To: linux-wireless@vger.kernel.org
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
Cc: "Klein, Matthias" <Matthias.Klein@optimeas.de>
Date: Mon, 24 Oct 2016 10:18:51 +0000
Message-Id: <emfd19c3e4-1b17-443b-b80a-e6b60a49f9dc@nb-mak> (sfid-20161024_122810_868391_D9B1DC72)
Reply-To: "Matthias Klein" <matthias.klein@optimeas.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I also try to get a pcie wifi card (Compex WLE600VX) running in the 
clearfog pro board with kernel 4.4.

As I read in this thread the "irg.mode=1" shoud help: 
https://www.spinics.net/lists/linux-wireless/msg155685.html

But it is not working for me:

debian@clearfog:~$ lsmod
Module Size Used by
8021q 36864 0
garp 16384 1 8021q
mrp 20480 1 8021q
stp 16384 1 garp
llc 16384 2 stp,garp
bnep 20480 2
ath10k_pci 45056 0
ath10k_core 249856 1 ath10k_pci
ath 32768 1 ath10k_core
mac80211 786432 1 ath10k_core
bluetooth 385024 7 bnep
qcserial 16384 0
cfg80211 561152 3 ath,mac80211,ath10k_core
usb_wwan 16384 1 qcserial
qmi_wwan 24576 0
cdc_wdm 20480 1 qmi_wwan
usbserial 40960 2 qcserial,usb_wwan
usbnet 36864 1 qmi_wwan
mii 16384 1 usbnet
rfkill 32768 4 cfg80211,bluetooth
firmware_class 24576 1 ath10k_core
marvell_cesa 45056 0
ehci_orion 16384 0
des_generic 28672 1 marvell_cesa
mcp3021 16384 0
hwmon 16384 1 mcp3021
evbug 16384 0
uio_pdrv_genirq 16384 0
uio 20480 1 uio_pdrv_genirq
fuse 102400 1
ipv6 532480 0
autofs4 36864 2

debian@clearfog:~$ uname -a
Linux clearfog 4.4.15-clearfog #1 SMP Wed Oct 5 00:03:36 UTC 2016 armv7l 
GNU/Linux

debian@clearfog:~$ sudo rmmod ath10k_pci ath10k_core
debian@clearfog:~$ sudo modprobe ath10k_core
debian@clearfog:~$ sudo modprobe ath10k_pci
[ 69.529351] ath10k_pci 0000:01:00.0: Refused to change power state, 
currently in D3
[ 69.567989] ath10k_pci 0000:01:00.0: failed to wake up device : -110
[ 69.575267] ath10k_pci: probe of 0000:01:00.0 failed with error -110

debian@clearfog:~$ sudo rmmod ath10k_pci ath10k_core
debian@clearfog:~$ sudo modprobe ath10k_core
debian@clearfog:~$ sudo modprobe ath10k_pci irq_mode=1
[ 97.899370] ath10k_pci 0000:01:00.0: Refused to change power state, 
currently in D3
[ 97.938045] ath10k_pci 0000:01:00.0: failed to wake up device : -110
[ 97.944973] ath10k_pci: probe of 0000:01:00.0 failed with error -110

debian@clearfog:~$ lspci -vvv
00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04) 
(prog-if 00 [Normal decode])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: f8000000-f82fffff
         Prefetchable memory behind bridge: 00000000-000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: <access denied>

00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04) 
(prog-if 00 [Normal decode])
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 00000000-000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: <access denied>

01:00.0 Network controller: Qualcomm Atheros QCA988x 802.11ac Wireless 
Network Adapter (rev ff) (prog-if ff)
         !!! Unknown header type 7f


Something else what I can try?

Best regards,
Matthias
