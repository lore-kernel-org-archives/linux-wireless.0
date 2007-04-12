Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:49188 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161444AbXDLBdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 21:33:07 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1Hbo93-0008V7-8g
	for linux-wireless@vger.kernel.org; Wed, 11 Apr 2007 21:30:41 -0400
Received: from proski by gnu.org with local (Exim 4.66)
	(envelope-from <proski@gnu.org>)
	id 1HboBO-0004sz-51
	for linux-wireless@vger.kernel.org; Wed, 11 Apr 2007 21:33:06 -0400
Subject: rt61: Kernel bug in ieee80211.c:4920
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Apr 2007 21:33:05 -0400
Message-Id: <1176341585.21564.30.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've tried the current wireless-dev.git with an rt61 card, but I forgot
to install the firmware.  The driver loaded and informed me of missing
firmware, but crashed on unload:

PM: Removing info for No Bus:0000:06:00.0
rt61pci->rt61pci_load_firmware: Error - Failed to load Firmware.
Unloading module: rt61pci - CVS (N/A) by http://rt2x00.serialmonkey.com.
bus pci: remove driver rt61pci
------------[ cut here ]------------
kernel BUG at /home/proski/src/linux-2.6/net/mac80211/ieee80211.c:4920!
invalid opcode: 0000 [#1]
SMP DEBUG_PAGEALLOC
Modules linked in: rt61pci rt2x00lib mac80211 eeprom_93cx6 crc_itu_t
CPU:    1
EIP:    0060:[<fc285d4f>]    Not tainted VLI
EFLAGS: 00010297   (2.6.21-rc6 #22)
EIP is at ieee80211_unregister_hw+0x22f/0x240 [mac80211]
eax: dac0e2e0   ebx: dac0f0a0   ecx: 00000000   edx: dad31b04
esi: dac0e2e0   edi: db0207f8   ebp: db061eb4   esp: db061e98
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 2825, ti=db060000 task=dad315d0 task.ti=db060000)
Stack: c0398142 db0208b8 dac0e2e0 c03957b9 dac0f0a0 dac0e2e0 db0207f8 db061ec8 
       f88f7a93 db0207f8 f88fd5b4 f88fd5b4 db061ed4 c0235709 db020840 db061ee4 
       c02b10ea db020840 dfd6a840 db061f00 c02b1813 f88fd658 f88fd63c f88fd5b4 
Call Trace:
 [<c0103b2a>] show_trace_log_lvl+0x1a/0x30
 [<c0103bf1>] show_stack_log_lvl+0xb1/0xe0
 [<c0103df1>] show_registers+0x1d1/0x2e0
 [<c0104028>] die+0x128/0x260
 [<c01041e2>] do_trap+0x82/0xb0
 [<c0104b27>] do_invalid_op+0x97/0xb0
 [<c03984c4>] error_code+0x7c/0x84
 [<f88f7a93>] rt61pci_remove+0x23/0x70 [rt61pci]
 [<c0235709>] pci_device_remove+0x19/0x40
 [<c02b10ea>] __device_release_driver+0x6a/0xa0
 [<c02b1813>] driver_detach+0x103/0x110
 [<c02b0549>] bus_remove_driver+0x89/0xb0
 [<c02b184b>] driver_unregister+0xb/0x20
 [<c02358c3>] pci_unregister_driver+0x13/0x70
 [<f88faf74>] rt61pci_exit+0x24/0x26 [rt61pci]
 [<c0142971>] sys_delete_module+0x121/0x190
 [<c0102a5e>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 00 00 c7 82 a0 08 00 00 00 00 00 00 e8 7b 05 ea c3 85 c0 74 0c 8b 45 ec f0 0f ba b0 b0 08 
00 00 00 e8 d6 70 ea c3 e9 78 fe ff ff <0f> 0b eb fe 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 8
9 e5 53 
EIP: [<fc285d4f>] ieee80211_unregister_hw+0x22f/0x240 [mac80211] SS:ESP 0068:db061e98

This is net/mac80211/ieee80211.c, line 4920:

BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);

Apparently rt61 calls ieee80211_unregister_hw() even though it never
called ieee80211_register_hw() due to the failure to load the firmware.

Either mac80211 should be more tolerant, or rt61 should keep track of
what it has registered.  I'm unsure which is better, hence no patch
attached ;)

-- 
Regards,
Pavel Roskin

