Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35566 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754207AbcJEOP4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 10:15:56 -0400
Received: by mail-it0-f41.google.com with SMTP id r192so188751948ita.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 07:15:56 -0700 (PDT)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 5 Oct 2016 16:15:35 +0200
Message-ID: <CAKdnbx5hxPXX-5xNEPp5yphgiAWykGZ9dX4fT-Y-+Ki0HSegzA@mail.gmail.com> (sfid-20161005_161600_653643_898EB407)
Subject: Issue with rt61-pci
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a router with onboard a rt2661 pci card and it use rt61pci driver.

With latest openwrt (it use compat wireless, so even the kernel isn't
the latest, the driver is near to linux-next) I get:

Lede-Trunk/Openwrt 15 and trunk:
by using the wifi card(AP mode) dmesg show:
[  257.472000] ieee80211 phy1: rt61pci_txdone: Warning - TX status
report missed for entry 28
[  257.480000] ieee80211 phy1: rt61pci_txdone: Warning - TX status
report missed for entry 29
[  257.488000] ieee80211 phy1: rt61pci_txdone: Warning - TX status
report missed for entry 30
[  257.496000] ieee80211 phy1: rt61pci_txdone: Warning - TX status
report missed for entry 31
[  257.504000] ieee80211 phy1: rt61pci_txdone: Warning - TX status
report missed for entry 1
(don't remember which distribution i used to get this log... but all
suffer of the same issue)

and after few seconds of usage the wifi card stop working and it need
a reboot or rmmod rt61-pci/modprobe to make it work again for few
seconds

root@OpenWrt:/lib/firmware# lspci -v
00:01.0 Network controller: Ralink corp. RT2600 802.11 MIMO
        Subsystem: Ralink corp. Device 2661
        Flags: bus master, slow devsel, latency 64, IRQ 39
        Memory at 30000000 (32-bit, non-prefetchable) [size=32K]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=2]
        Expansion ROM at <unassigned> [disabled] [size=2]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: rt61pci
lspci: Unable to load libkmod resources: error -12

root@OpenWrt:/proc/irq/39# cat /proc/interrupts
           CPU0
  0:          0      MIPS   0  smp_ipi0
  1:          0      MIPS   1  smp_ipi1
  7:    7906287      MIPS   7  timer
  8:          0  bcm6345-periph-intc   0  bcm63xx_timer
 10:         27  bcm6345-periph-intc   2  bcm63xx_uart
 13:          1  bcm6345-periph-intc   5  ohci_hcd:usb2
 14:          6  bcm6345-periph-intc   6  eth1
 17:          0  bcm6345-periph-intc   9  phy_interrupt
 18:          0  bcm6345-periph-intc  10  ehci_hcd:usb1
 25:     168436  bcm6345-periph-intc  17  eth1
 26:      96231  bcm6345-periph-intc  18  eth1
 39:     492016  bcm6345-periph-intc  31  rt61pci
ERR:          0
root@OpenWrt:/proc/irq/39#


it seems that other people even on desktop systems get same error and
is not clear if it is solved on latest ubuntu as well there is already
a ticket opened on openwrt: https://dev.openwrt.org/ticket/18228

On Openwrt 12.09 work correctly.

Have you any idea about what could have introduced this regression?


 ATTITUDE ADJUSTMENT (12.09, r36088)

root@OpenWrt:/# cat /proc/version
Linux version 3.3.8 (blogic@Debian-60-squeeze-64-minimal) (gcc version
4.6.3 20120201 (prerelease) (Linaro GCC 4.6-2012.02) ) #1 Sat Mar 23
18:09:20 UTC 2013

root@OpenWrt:/# cat /proc/interrupts
           CPU0
  2:          0      MIPS  cascade_ip2
  7:     479612      MIPS  timer
  8:          0  bcm63xx_ipic  bcm63xx_timer
 10:      18149  bcm63xx_ipic  bcm63xx_uart
 14:         19  bcm63xx_ipic  eth1
 17:          0  bcm63xx_ipic  phy_interrupt
 25:     247853  bcm63xx_ipic  eth1
 26:     117400  bcm63xx_ipic  eth1
 39:     552385  bcm63xx_ipic  0000:00:01.0
ERR:          0

root@OpenWrt:/# lspci -v
00:01.0 Network controller: Ralink corp. RT2600 802.11 MIMO
        Subsystem: Ralink corp. Device 2661
        Flags: bus master, slow devsel, latency 64, IRQ 39
        Memory at 30000000 (32-bit, non-prefetchable) [size=32K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: rt61pci

01:1e.0 CardBus bridge: Broadcom Corporation Device 6358
        Subsystem: Broadcom Corporation Device 6358
        Flags: bus master, slow devsel, latency 0, IRQ 39
        Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 00000000-00000fff
        Memory window 1: 00000001-00000fff
        I/O window 0: 00000000-00000003
        I/O window 1: 00000000-00000003

Please, can you give me some hint to troubleshoot this issue?

Regards
Eddi De Pieri
