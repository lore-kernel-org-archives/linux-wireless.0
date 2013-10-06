Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward3h.mail.yandex.net ([84.201.187.148]:36859 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3JFCK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 22:10:29 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"gwingerde@gmail.com" <gwingerde@gmail.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>
In-Reply-To: <39871380943748@web17j.yandex.ru>
References: <39871380943748@web17j.yandex.ru>
Subject: Re: [regression] [bisected] rt2800pci doesn't work after 9483f40d8d01918b399b4e24d0c1111db0afffeb
MIME-Version: 1.0
Message-Id: <123871381025423@web17h.yandex.ru> (sfid-20131006_041048_720752_A3F6A0E6)
Date: Sun, 06 Oct 2013 06:10:23 +0400
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

05.10.2013, 07:29, "Kirill Tkhai" <tkhai@yandex.ru>:
> Hi, everyone!
>
> I've just moved from v3.10 to v3.11 and found that my rt2800pci doesn't work:
>
> [ š705.761252] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
> [ š705.871194] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
> [ š710.757696] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
> [ š710.867637] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
> [ š710.977581] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
> [ š711.087516] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
> [ š711.119530] ieee80211 phy3: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 0
> [ š712.219961] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
> [ š712.329900] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
> [ š714.233932] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
> [ š714.343872] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
> [ š721.135366] rt2800pci 0000:01:00.0: irq 45 for MSI/MSI-X
> [ š721.135467] ieee80211 phy4: rt2x00_set_rt: Info - RT chipset 3290, rev 0015 detected
> [ š721.137440] ieee80211 phy4: rt2x00_set_rf: Info - RF chipset 3290 detected
>
> GIt bisect says the first bad commit is 9483f40d8d01918b399b4e24d0c1111db0afffeb:
>
> ššššššššAuthor: Jakub Kicinski <kubakici@wp.pl>
> ššššššššDate: ššTue May 7 00:28:50 2013 +0200
>
> ššššššššššššrt2x00pci: Use PCI MSIs whenever possible
>
> ššššššššššššAll PCIe devices must support MSIs, make use of them.
>
> With reverted commit everything is ok.
>
> $ cat /sys/bus/pci/devices/*/msi_bus
> 1
> 1
> 1
>
> $ cat /proc/interrupts
> 45: šššššššš97 ššššššššš0 ššššššššš0 ššššššššš0 ššPCI-MSI-edge ššššš0000:01:00.0
>
> PCI IDS: 1814:3298

Mistake: right PCI IDS are 1814:3290:103c:18ec

$ lspci -vv
01:00.0 Network controller: Ralink corp. RT3290 Wireless 802.11n 1T/1R PCIe
	Subsystem: Hewlett-Packard Company Device 18ec
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at c2510000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number <my top secret MAC address>
	Kernel driver in use: rt2800pci

$ lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM75 Express Chipset LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
01:00.0 Network controller: Ralink corp. RT3290 Wireless 802.11n 1T/1R PCIe
01:00.1 Bluetooth: Ralink corp. RT3290 Bluetooth
02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader (rev 01)
08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
