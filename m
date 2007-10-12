Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.15]:40290 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbXJLPbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 11:31:00 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: linux-wireless@vger.kernel.org
Subject: [BUG] zd1211rw on 2.6.23 oops ejecting the device
Date: Fri, 12 Oct 2007 17:04:52 +0200
Cc: kunde@deine-taler.de, dsd@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710121704.53143.marc.pignat@hevs.ch> (sfid-20071012_163109_524313_5EE51688)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've got one of the (in)famous usb wifi stick with the virtual cdrom...

The dmesg output (extract) is at the end of the message.
It seems that the oops is while ejecting. Please note that this is a perfectly
portable oops and oops on my x86 desktop pc with usb2.0 and on my arm920t based system with usb1.1.

Please let-me know if you want more informations!

Regards

Marc



Linux version 2.6.23 (pim@pim-linux) (gcc version 4.2.1 (Debian 4.2.1-3)) #1 SMP Fri Oct 12 16:33:03 CEST 2007
...
usb 1-8: new high speed USB device using ehci_hcd and address 5
usb 1-8: configuration #1 chosen from 1 choice
usb 1-8: Ejecting virtual installer media...
usb 1-8: USB disconnect, address 5
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000288
 printing eip:
c02d58bd
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c02d58bd>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23 #1)
EIP is at disconnect+0xd/0x4c
eax: f4c45c00   ebx: f4c45c00   ecx: 00000002   edx: 00000000
esi: 00000000   edi: f4c45c00   ebp: c19c4858   esp: c19b5ec0
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 188, ti=c19b4000 task=c1a0ea80 task.ti=c19b4000)
Stack: f4c45c00 f4c45c1c c05b5834 c036d3bf f4c45c1c c05b5868 00000000 c0281e9d 
       f4c45c1c f4c45c1c c0282217 f4c45c94 c02818b3 f4c45c00 f4c45c1c c02800e1 
       f4c45c00 c19c4800 00000000 c19c4858 c036b183 0000001f c19c492c c19c4800 
Call Trace:
 [<c036d3bf>] usb_unbind_interface+0x2d/0x6e
 [<c0281e9d>] __device_release_driver+0x6e/0x8b
 [<c0282217>] device_release_driver+0x23/0x39
 [<c02818b3>] bus_remove_device+0x6a/0x7a
 [<c02800e1>] device_del+0x1d7/0x248
 [<c036b183>] usb_disable_device+0x5c/0xbb
 [<c0367df4>] usb_disconnect+0x8e/0xe9
 [<c036843a>] hub_thread+0x319/0x9df
 [<c0133cb1>] autoremove_wake_function+0x0/0x33
 [<c0368121>] hub_thread+0x0/0x9df
 [<c0133be9>] kthread+0x38/0x5f
 [<c0133bb1>] kthread+0x0/0x5f
 [<c0105a77>] kernel_thread_helper+0x7/0x10
 =======================
Code: f8 c7 43 5c 00 00 00 00 e8 04 1a 17 00 89 f0 e8 9a 50 09 00 89 f0 5b 5e 5f e9 4a 53 09 00 57 89 c7 56 53 8b b0 0c 01 00 00 85 f6 <8b> 86 88 02 00 00 74 33 8d 98 40 0b 00 00 89 f0 e8 ee e7 ff ff 
EIP: [<c02d58bd>] disconnect+0xd/0x4c SS:ESP 0068:c19b5ec0
