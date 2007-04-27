Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48825 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757343AbXD0VhR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 17:37:17 -0400
Date: Fri, 27 Apr 2007 23:37:38 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mbuesch@freenet.de>
Subject: Oops in ieee80211_register_hw
Message-ID: <20070427233738.5842decf@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

has anyone an idea what's going on here?

How to reproduce:
1. modprobe bcm43xx_mac80211
2. plug in my cardbus bcm4318 card
(note that if I swap these two steps, the oops doesn't occur)

By adding debug printks, I located the place where the null dereference
happens. Please note that I have Michael Wu's latest patches applied.
It's in
	name = wiphy_dev(local->hw.wiphy)->driver->name;
and wiphy_dev(local->hw.wiphy) is NULL.

The relevant part of dmesg follows.

Thanks,

 Jiri

------------
pccard: CardBus card inserted into slot 0
PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:03:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device <NULL>
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09, vendor 0x4243)
ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
ssb: Switching to ChipCommon core, index 0
ssb: Switching to PCI core, index 2
bcm43xx_mac80211: Broadcom 4318 WLAN found
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_mac80211: Radio turned off
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000194
 printing eip:
f8be6c0f
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: bcm43xx_mac80211 ssb mac80211 arc4 ecb blkcipher cfg80211
CPU:    0
EIP:    0060:[<f8be6c0f>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-test #88)
EIP is at ieee80211_register_hw+0x2f/0x240 [mac80211]
eax: 00000000   ebx: f12ca2e0   ecx: 00000000   edx: 00000001
esi: fffffff4   edi: f3b2426c   ebp: f7a65bf0   esp: f7a65bdc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pccardd (pid: 815, ti=f7a64000 task=c1cff490 task.ti=f7a64000)
Stack: f3b2426c 00000000 00000000 00000000 f12cb180 f7a65c48 f8aff8c8 ef53d7f5 
       00004318 c04850b0 c04850b7 f2e8fb6f f3af31fc 00000001 f7a65c44 f12cb268 
       f3b2470c f12cb180 f3af30ec f3217304 00000001 00000000 f12ca2e0 f3b2427c 
Call Trace:
 [<c0103a0a>] show_trace_log_lvl+0x1a/0x30
 [<c0103ad6>] show_stack_log_lvl+0xb6/0x100
 [<c0103e6e>] show_registers+0x1de/0x2f0
 [<c01041a1>] die+0x111/0x220
 [<c03cc505>] do_page_fault+0x2c5/0x630
 [<c03caaa4>] error_code+0x7c/0x84
 [<f8aff8c8>] bcm43xx_probe+0x298/0x700 [bcm43xx_mac80211]
 [<f887124a>] ssb_device_probe+0x3a/0x80 [ssb]
 [<c0270f5c>] really_probe+0x5c/0x170
 [<c0271357>] driver_probe_device+0xb7/0xd0
 [<c0271448>] __device_attach+0x8/0x10
 [<c0270233>] bus_for_each_drv+0x63/0x90
 [<c0271126>] device_attach+0x86/0x90
 [<c02702c9>] bus_attach_device+0x29/0x70
 [<c026f356>] device_add+0x596/0x740
 [<c026f512>] device_register+0x12/0x20
 [<f887049f>] ssb_attach_queued_buses+0x1ff/0x280 [ssb]
 [<f8870fa5>] ssb_bus_register+0x125/0x180 [ssb]
 [<f8871102>] ssb_bus_pcibus_register+0x42/0x50 [ssb]
 [<f8872e50>] ssb_pcihost_probe+0x90/0xc0 [ssb]
 [<c0205fdb>] pci_device_probe+0x5b/0x80
 [<c0270f5c>] really_probe+0x5c/0x170
 [<c0271357>] driver_probe_device+0xb7/0xd0
 [<c0271448>] __device_attach+0x8/0x10
 [<c0270233>] bus_for_each_drv+0x63/0x90
 [<c0271126>] device_attach+0x86/0x90
 [<c02702c9>] bus_attach_device+0x29/0x70
 [<c026f356>] device_add+0x596/0x740
 [<c0200c17>] pci_bus_add_device+0x17/0x60
 [<c0200d2a>] pci_bus_add_devices+0xca/0x140
 [<c02cafe2>] cb_alloc+0xc2/0xe0
 [<c02c74f7>] socket_insert+0xb7/0x110
 [<c02c7d17>] pccardd+0x207/0x250
 [<c012eaca>] kthread+0xda/0xe0
 [<c010371f>] kernel_thread_helper+0x7/0x18
 =======================
Code: 53 89 c3 83 ec 0c 8b 00 e8 5f f9 c4 ff 85 c0 89 c6 0f 88 6c 01 00 00 8b 03 31 c9 ba 01 00 00 00 be f4 ff ff ff 8b 80 e0 00 00 00 <8b> 80 94 01 00 00 8b 00 e8 04 4d 54 c7 85 c0 89 43 58 0f 84 9c 
EIP: [<f8be6c0f>] ieee80211_register_hw+0x2f/0x240 [mac80211] SS:ESP 0068:f7a65bdc



-- 
Jiri Benc
SUSE Labs
