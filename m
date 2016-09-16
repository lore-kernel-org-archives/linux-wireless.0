Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36510 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759155AbcIPK4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 06:56:33 -0400
Received: by mail-yb0-f174.google.com with SMTP id u125so51129065ybg.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2016 03:56:33 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Grandi <grn.matteo@gmail.com>
Date: Fri, 16 Sep 2016 12:56:31 +0200
Message-ID: <CAF3cwD2jkXTbZAw7YPE2mDyZKgEUCdWOXDAqkt6zLbXLV6uT9g@mail.gmail.com> (sfid-20160916_125644_191733_98065CA1)
Subject: ath10k mesh mode issue
To: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I'm using Gateworks Ventana 5410 boards
(http://www.gateworks.com/product/item/ventana-gw5410-network-processor)
running Ubuntu Trusty-Ventana kernel v3.14 with a Compex WLE600V5-27
miniPCIe Qualcomm Atheros QCA9882 wifi dongle installed
https://www.landashop.com/compex-wle-600v5.html?___store=english&___from_store=default

The aim is to use some of these boards to build a mesh network and
perform some HT test (it's a part of my MSc thesis).
I'm trying to configure the devices in mesh mode, but I've encountered
some problems, this is the dmesg output:

root@Yazi:~# iw dev wlan1 interface add mp1 type mp
root@Yazi:~# iw dev mp1 set freq 5240
root@Yazi:~# dmesg | grep ath
[    7.134520] ath10k_pci 0000:07:00.0: pci irq legacy interrupts 0
irq_mode 0 reset_mode 0
[    7.349228] ath10k_pci 0000:07:00.0: Direct firmware load failed
with error -2
[    7.349245] ath10k_pci 0000:07:00.0: Falling back to user helper
[    7.417170] ath10k_pci 0000:07:00.0: Direct firmware load failed
with error -2
[    7.417189] ath10k_pci 0000:07:00.0: Falling back to user helper
[    8.589474] ath10k_pci 0000:07:00.0: qca988x hw2.0 (0x4100016c,
0x043222ff sub 0000:0000) fw 10.2.4.70.54 fwapi 5 bdapi 1 htt-ver 2.1
wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features
no-p2p,raw-mode
[    8.589491] ath10k_pci 0000:07:00.0: debug 1 debugfs 1 tracing 0
dfs 0 testmode 1
[    8.691670] ath: EEPROM regdomain: 0x0
[    8.691680] ath: EEPROM indicates default country code should be used
[    8.691686] ath: doing EEPROM country->regdmn map search
[    8.691695] ath: country maps to regdmn code: 0x3a
[    8.691702] ath: Country alpha2 being used: US
[    8.691706] ath: Regpair used: 0x3a
root@Yazi:~# ifconfig mp1 up
SIOCSIFFLAGS: Invalid argument
root@Yazi:~# dmesg | grep ath
[    7.134520] ath10k_pci 0000:07:00.0: pci irq legacy interrupts 0
irq_mode 0 reset_mode 0
[    7.349228] ath10k_pci 0000:07:00.0: Direct firmware load failed
with error -2
[    7.349245] ath10k_pci 0000:07:00.0: Falling back to user helper
[    7.417170] ath10k_pci 0000:07:00.0: Direct firmware load failed
with error -2
[    7.417189] ath10k_pci 0000:07:00.0: Falling back to user helper
[    8.589474] ath10k_pci 0000:07:00.0: qca988x hw2.0 (0x4100016c,
0x043222ff sub 0000:0000) fw 10.2.4.70.54 fwapi 5 bdapi 1 htt-ver 2.1
wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features
no-p2p,raw-mode
[    8.589491] ath10k_pci 0000:07:00.0: debug 1 debugfs 1 tracing 0
dfs 0 testmode 1
[    8.691670] ath: EEPROM regdomain: 0x0
[    8.691680] ath: EEPROM indicates default country code should be used
[    8.691686] ath: doing EEPROM country->regdmn map search
[    8.691695] ath: country maps to regdmn code: 0x3a
[    8.691702] ath: Country alpha2 being used: US
[    8.691706] ath: Regpair used: 0x3a
[  176.983250] ath10k_pci 0000:07:00.0: must load driver with
rawmode=1 to add mesh interfaces

It seems that the rowmode is NOT enable, but 8 lines above it's seems
to be ok...

Let me give you some useful details:
- the lspci output:
root@Yazi:~# lspci
00:00.0 PCI bridge: Synopsys, Inc. Device abcd (rev 01)
01:00.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
01:00.1 System peripheral: PLX Technology, Inc. PEX 8609 8-lane,
8-Port PCI Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:01.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:04.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:05.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:06.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:07.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:08.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
02:09.0 PCI bridge: PLX Technology, Inc. PEX 8609 8-lane, 8-Port PCI
Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba)
07:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac
Wireless Network Adapter
08:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8057
PCI-E Gigabit Ethernet Controller

-the lsmod output:
root@Yazi:~# lsmod
Module                  Size  Used by
arc4                    1687  2
ath10k_pci             34340  0
ath10k_core           289147  1 ath10k_pci
sky2                   53987  0
mac80211              458056  1 ath10k_core
ath                    21573  1 ath10k_core
cfg80211              218260  3 ath,mac80211,ath10k_core
compat                 24039  4 cfg80211,mac80211,ath10k_pci,ath10k_core

- the firmware currently in use is the firmware-5.bin_10.2.4.70.54
(renamed firmware-5.bin and with executable permission) located in
/lib/firmware/ath10k/QCA988X/hw2.0. I retrived it on
https://github.com/kvalo/ath10k-firmware
- The backports-4.2.6-1 was crosscompiled with the kernel following
the official wiki guide provided by Gateworks
- I've also tried to load the ath10k modules adding the parameter
rowmode=1 but I had an error "rawmode unknown parameter"
- in another try I used the firmware "firmware-5.bin_10.2.4.70.6-2"
after retriving this
https://github.com/o11s/open80211s/wiki/ath10k-(802.11ac)-for-Mesh-Support
but nothing is changed...

I'm not an expert so I'm sorry if I miss some basics...
Hope in your help!

All the bes
