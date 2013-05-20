Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:64533 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab3ETV0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 17:26:50 -0400
Received: by mail-ia0-f176.google.com with SMTP id j3so5590696iae.7
        for <linux-wireless@vger.kernel.org>; Mon, 20 May 2013 14:26:50 -0700 (PDT)
MIME-Version: 1.0
From: Flavio <fbcyborg@gmail.com>
Date: Mon, 20 May 2013 23:26:30 +0200
Message-ID: <CAP8Jb=oTE_tL+57_wtMo_QTNG01_oP2jgjicrDneFwTuOocs8g@mail.gmail.com> (sfid-20130520_232654_460705_D72ADFDC)
Subject: Problem with iwlwifi kernel 3.9.0 and 3.9.2
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've recently changed my wifi router and I'm experiencing something
really strange with my wifi connection.
If I try to connect to my access point using windows, I don't have any
problem, but if I try with Linux (Gentoo Linux
x86_64) I cannot connect to my Access Point unless I do the following steps:

ifconfig wlan0 down
rmmod iwldvm
rmmod iwlwifi
modprobe iwlwifi
ifconfig wlan0 up

otherwise if I try to connect to my access point / wifi router, Wicd
tells me that I inserted a wrong password.
I've even tried with another live linux distribution, and I don't have
this issue.

I use gentoo-sources-3.9.2 kernel.

Anway, I see a lot of these lines into the ringbuffer:
[   10.597894] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   10.604842] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   10.974579] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   10.981532] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   11.170175] udevd (1281) used greatest stack depth: 3904 bytes left
[   11.177626] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   12.943205] ehci-pci 0000:00:1d.0: reused qh ffff88025442db80 schedule
[   12.943220] usb 2-1.2.4: link qh8-0601/ffff88025442db80 start 3 [1/2 us]
[   14.966790] ehci-pci 0000:00:1a.0: reused qh ffff880256313780 schedule
[   14.966809] usb 1-1.2: link qh1-0601/ffff880256313780 start 0 [1/2 us]
[   16.040474] r8169 0000:05:00.0 eth0: unable to load firmware patch
rtl_nic/rtl8168e-3.fw (-2)
[   16.053919] r8169 0000:05:00.0 eth0: link down
[   16.053984] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.290113] EXT4-fs (sdb2): re-mounted. Opts: discard,data=ordered,commit=600
[   16.361332] EXT4-fs (sdb3): re-mounted. Opts: discard,user_xattr,commit=600
[   21.357366] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   21.364249] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   21.575272] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   21.657055] r8169 0000:05:00.0 eth0: link down
[   21.657128] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.700948] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   21.707855] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   21.917497] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.326409] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   31.333315] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   31.549301] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.632951] r8169 0000:05:00.0 eth0: link down
[   31.633017] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.674518] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   31.681424] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   31.901246] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   32.708189] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   32.715113] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   32.930218] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   33.019577] r8169 0000:05:00.0 eth0: link down
[   33.019645] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   41.426395] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   41.433323] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   41.648486] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   41.732823] r8169 0000:05:00.0 eth0: link down
[   41.732902] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   41.782637] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   41.789542] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   42.003966] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   42.801094] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   42.808009] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   43.022852] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   43.109315] r8169 0000:05:00.0 eth0: link down
[   43.109382] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   50.550516] ata1.00: configured for UDMA/133
[   50.550520] ata1: EH complete
[   50.556920] ata2.00: configured for UDMA/133
[   50.556924] ata2: EH complete
[   50.640043] EXT4-fs (sdb2): re-mounted. Opts: discard,commit=600
[   50.679807] EXT4-fs (sdb3): re-mounted. Opts: discard,user_xattr,commit=600
[   51.314954] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   51.321836] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   51.517346] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   51.584493] r8169 0000:05:00.0 eth0: link down
[   51.584529] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   51.622496] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   51.629524] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   51.825554] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.651756] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   52.658680] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   52.874838] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.964131] r8169 0000:05:00.0 eth0: link down
[   52.964196] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   55.297179] cc1 (3560) used greatest stack depth: 3560 bytes left
[   57.035425] ehci-pci 0000:00:1a.0: reused qh ffff880255754a80 schedule
[   57.035431] usb 1-1.3: link qh16-0001/ffff880255754a80 start 3 [1/0 us]
[   57.035539] usb 1-1.3: unlink qh16-0001/ffff880255754a80 start 3 [1/0 us]
[   58.078190] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   58.085086] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   58.278011] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   58.341392] r8169 0000:05:00.0 eth0: link down
[   58.341432] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   75.980776] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   75.987691] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   76.198996] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   76.282766] r8169 0000:05:00.0 eth0: link down
[   76.282848] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   76.336181] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   76.343115] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   76.552906] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   78.929615] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   78.936515] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   79.147113] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   79.231901] r8169 0000:05:00.0 eth0: link down
[   79.231989] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  125.566966] Intel(R) Wireless WiFi driver for Linux, in-tree:
[  125.566975] Copyright(c) 2003-2013 Intel Corporation
[  125.567862] iwlwifi 0000:02:00.0: irq 50 for MSI/MSI-X
[  125.569289] iwlwifi 0000:02:00.0: loaded firmware version 18.168.6.1
[  125.573184] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[  125.573198] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[  125.573206] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[  125.573214] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[  125.573222] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[  125.573232] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6230 AGN, REV=0xB0
[  125.573311] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  125.589763] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
[  131.463071] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  131.469967] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  131.849054] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  131.855971] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  132.059034] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  155.659291] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  155.666217] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  155.878162] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  155.960425] r8169 0000:05:00.0 eth0: link down
[  155.960500] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  156.013922] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  156.020848] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  156.232123] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  158.686204] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  158.693095] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  158.909408] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  158.996422] r8169 0000:05:00.0 eth0: link down
[  158.996489] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  165.945974] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  165.952897] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  166.165433] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  166.241019] r8169 0000:05:00.0 eth0: link down
[  166.241097] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  166.298743] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  166.305659] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[  166.520184] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  168.607165] wlan0: authenticate with 9c:d3:6d:f7:95:02
[  168.612821] wlan0: send auth to 9c:d3:6d:f7:95:02 (try 1/3)
[  168.615680] wlan0: authenticated
[  168.615720] wlan0: waiting for beacon from 9c:d3:6d:f7:95:02
[  168.711236] wlan0: associate with 9c:d3:6d:f7:95:02 (try 1/3)
[  168.714864] wlan0: RX AssocResp from 9c:d3:6d:f7:95:02 (capab=0x411
status=0 aid=2)
[  168.718389] wlan0: associated
[  168.718442] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

I don't know if this is normal or not, but since when I changed the
wifi router I'm experiencing the problem described above.
Could you help me to debug the problem?
I don't understand if this has something to do with my configuration
or if there's a bug somewhere.
the /etc/modprobe.d/iwlwifi.conf file is empty.

Feel free to ask for further information you would need.

Thanks a lot,

-- 
Flavio
