Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64366 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HYNur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 09:50:47 -0400
Message-ID: <4E565333.3080007@gmail.com> (sfid-20110825_155052_323461_46408EBE)
Date: Thu, 25 Aug 2011 15:50:43 +0200
From: =?UTF-8?B?Tmljb2xhcyBkZSBQZXNsb8O8YW4=?=
	<nicolas.2p.debian@gmail.com>
MIME-Version: 1.0
To: wwguy <wey-yi.w.guy@intel.com>
CC: "dhalperi@cs.washington.edu" <dhalperi@cs.washington.edu>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: Random "Time out reading EEPROM".
References: <4DEA2FC1.2030104@gmail.com>	 <1307284276.6918.17.camel@wwguy-ubuntu>  <4E1FF8B8.9020005@gmail.com> <1310740111.13897.13.camel@wwguy-ubuntu>
In-Reply-To: <1310740111.13897.13.camel@wwguy-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 15/07/2011 16:28, wwguy a écrit :

> the error indicate fail to read data from EEPROM, your 2nd report is
> even more strange, the number at the end the error message indicate the
> index of DWORD driver trying to read from EEPROM.
>
> "Time out reading EEPROM[2]" telling me the first 2 DWORD is reading ok
> but not the 3rd read.
>
> How many PCI-E slots you have in your system, could it possible for you
> to switch to another PCI-E slot, or pull out and re-insert the NIC.

Unfortunately, not. On this laptop, the NIC is not reachable without disassembling the laptop, and I 
don't want to... I will double check again, but...

> Also, it is possible to put the NIC into different system and see if you
> are seeing the similar problem?

No, for the exact same reason.

Not that it still happens with 3.0.0-1 from Debian.

[   15.086244] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.086247] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[   15.086404] iwlagn 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   15.086412] iwlagn 0000:05:00.0: setting latency timer to 64
[   15.086438] iwlagn 0000:05:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.095859] iwlagn 0000:05:00.0: Time out reading EEPROM[6]
[   15.095945] iwlagn 0000:05:00.0: Unable to init EEPROM
[   15.096030] iwlagn 0000:05:00.0: PCI INT A disabled
[   15.096039] iwlagn: probe of 0000:05:00.0 failed with error -110

modprobe -r iwlagn ; modprobe iwlagn

[  231.822492] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[  231.822495] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[  231.822581] iwlagn 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  231.822591] iwlagn 0000:05:00.0: setting latency timer to 64
[  231.822621] iwlagn 0000:05:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[  231.843544] iwlagn 0000:05:00.0: device EEPROM VER=0x11f, CALIB=0x4
[  231.843546] iwlagn 0000:05:00.0: Device SKU: 0Xb
[  231.844889] iwlagn 0000:05:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  231.844961] iwlagn 0000:05:00.0: irq 50 for MSI/MSI-X
[  231.989424] iwlagn 0000:05:00.0: loaded firmware version 8.83.5.1 build 33692
[  232.037456] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'

The error is not easy to reproduce, but the fix is perfectly stable. A single unload/reload of 
iwlagn is always enough to solve the problem, when it happens. For this reason, it sounds difficult 
to consider this a hardware slot problem. Can't this be related to some other PCI components?

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
01:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 9300M GS] (rev a1)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller 
(rev 14)
05:00.0 Network controller: Intel Corporation WiFi Link 5100
09:03.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
09:03.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
09:03.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)

I'm quite sure I can fix this problem by loading, unloading and reloading iwlagn on every startup... 
but I don't really consider this a fix :-/

	Nicolas.
