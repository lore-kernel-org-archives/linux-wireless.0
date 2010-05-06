Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39691 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0EFLv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 07:51:59 -0400
Message-ID: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>
Date: Thu, 06 May 2010 07:51:57 -0400
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Subject: rt61pci: WEP broken in current wireless-testing
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Recent changes in wireless-testing have broken WEP support in rt61pci.  
  An older kernel from wireless-testing identified as 2.6.34-rc5-wl is  
working fine.

I'm using an x86_64 system.  The device is

Network controller [0280]: RaLink RT2561/RT61 rev B 802.11g [1814:0302]

The device is in managed mode.  I'm using WEP with a 40-bit key (I  
know it's ridiculously insecure, but it's not my choice).  With the  
current kernel, the association works, but no traffic is received by  
the station.

That's the relevant part of .config:

CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
CONFIG_RT61PCI=m
CONFIG_RT2800PCI_PCI=y
# CONFIG_RT2800PCI is not set
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y

arc4 support is compiled as a module and it's loaded.  I haven't seen  
anything unusual in the kernel log.

Curiously, I'm seeing some interesting warnings with the working  
kernel (2.6.34-rc5-wl).  They don't appear immediately, as you can see  
from the timestamps:

[   74.534338] phy1 -> rt2x00lib_request_firmware: Info - Loading  
firmware file 'rt2561.bin'.
[   74.534343] rt61pci 0000:04:03.0: firmware: requesting rt2561.bin
[   74.638978] phy1 -> rt2x00lib_request_firmware: Info - Firmware  
detected - version: 0.8.
[   74.801343] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 0  
- CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
[   74.801350] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 1  
- CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
[   74.801357] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 2  
- CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
[   74.801363] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 3  
- CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
[   81.212513] wlan2: authenticate with 00:23:97:5c:82:7e (try 1)
[   81.214001] wlan2: authenticated
[   81.250009] wlan2: associate with 00:23:97:5c:82:7e (try 1)
[   81.251750] wlan2: RX AssocResp from 00:23:97:5c:82:7e (capab=0x411  
status=0 aid=1)
[   81.251753] wlan2: associated
[   81.252014] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 0  
- CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
[   81.252020] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 1  
- CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
[   81.252027] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 2  
- CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
[   81.252034] phy1 -> rt2x00mac_conf_tx: Info - Configured TX queue 3  
- CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
[  652.484017] phy1 -> rt61pci_txdone: Warning - TX status report  
missed for entry 15
[  652.970531] phy1 -> rt61pci_txdone: Warning - TX status report  
missed for entry 2

It's should be rather straightforward to bisect, but I'll be away from  
that system until next Monday.

-- 
Regards,
Pavel Roskin
