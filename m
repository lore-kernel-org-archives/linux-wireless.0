Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52743 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbbBKUlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 15:41:52 -0500
Received: by mail-wg0-f51.google.com with SMTP id y19so5917144wgg.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 12:41:51 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2015 12:41:50 -0800
Message-ID: <CADfzvvYn74U73GNwkezrpqGf3w96GYbcioSZg9A9RQxwF5edug@mail.gmail.com> (sfid-20150211_214201_249400_F176026E)
Subject: NULL pointer dereference in ath_isr+0x27/0x250 [ath9k]
From: Davide Pesavento <davidepesa@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I'm experiencing random kernel panics during boot on a PC Engines
APU1c board. The system is equipped with two ath9k-driven miniPCIe
cards identified as:

[    7.575650] ieee80211 phy0: Atheros AR9280 Rev:2
mem=0xffffc90000760000, irq=19
[    7.713708] ieee80211 phy1: Atheros AR9300 Rev:4
mem=0xffffc90000900000, irq=16

This is with a stock Ubuntu kernel. Panic trace below:

[    6.838544] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000060
[    6.846521] IP: [<ffffffffc0390b07>] ath_isr+0x27/0x250 [ath9k]
[    6.852491] PGD daa59067 PUD daa5a067 PMD 0
[    6.856843] Oops: 0000 [#1] SMP
[    6.860128] Modules linked in: kvm_amd ath9k(+) ath9k_common kvm
ath9k_hw ath mac80211 sp5100_tco k10temp i2c_piix4 cfg80211 mac_hid lp
parport uas usb_storage ahci libahci r8169 mii
[    6.876912] CPU: 1 PID: 402 Comm: dbus-daemon Not tainted
3.16.0-30-generic #40~14.04.1-Ubuntu
[    6.885520] Hardware name: PC Engines APU/APU, BIOS 4.0 09/08/2014
[    6.891700] task: ffff8800daa18000 ti: ffff8800daa78000 task.ti:
ffff8800daa78000
[    6.899179] RIP: 0010:[<ffffffffc0390b07>]  [<ffffffffc0390b07>]
ath_isr+0x27/0x250 [ath9k]
[    6.907571] RSP: 0000:ffff88011ed03e90  EFLAGS: 00010086
[    6.912890] RAX: 0000000000000080 RBX: 0000000000000000 RCX: 0000000000000005
[    6.920024] RDX: 0000000000000020 RSI: ffff8800da2fd840 RDI: 0000000000000013
[    6.927155] RBP: ffff88011ed03ec0 R08: 0000000000000000 R09: 0000000000000001
[    6.934289] R10: 0000000000000000 R11: 00007ff037fc4b90 R12: ffff8800da2fd840
[    6.941422] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[    6.948557] FS:  00007ff03909f840(0000) GS:ffff88011ed00000(0000)
knlGS:0000000000000000
[    6.956650] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.962395] CR2: 0000000000000060 CR3: 00000000daa58000 CR4: 00000000000007e0
[    6.969526] Stack:
[    6.971546]  0000000000748000 ffff8801186dfb00 0000000000000013
0000000000000001
[    6.979041]  0000000000000001 0000000000000000 ffff88011ed03f08
ffffffff810cb22e
[    6.986537]  ffff8800d74a4c00 000000808135e063 ffff8800d74a4c00
ffff8800d74a4ca4
[    6.994034] Call Trace:
[    6.996490]  <IRQ>
[    6.998424]  [<ffffffff810cb22e>] handle_irq_event_percpu+0x3e/0x1a0
[    7.005011]  [<ffffffff810cb3cd>] handle_irq_event+0x3d/0x60
[    7.010672]  [<ffffffff810ce771>] handle_fasteoi_irq+0x81/0x150
[    7.016604]  [<ffffffff810155ee>] handle_irq+0x1e/0x30
[    7.021747]  [<ffffffff8176dabf>] do_IRQ+0x4f/0xf0
[    7.026550]  [<ffffffff8176b96d>] common_interrupt+0x6d/0x6d
[    7.032213]  <EOI>
[    7.034145]  [<ffffffff8176aced>] ? system_call_fastpath+0x1a/0x1f
[    7.040560] Code: 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 41 57 41
56 41 55 41 54 49 89 f4 53 48 83 ec 08 48 8b 9e b8 08 00 00 c7 45 d4
00 00 00 00 <48> 8b 43 60 a8 01 74 11 31 c0 48 83 c4
[    7.061081] RIP  [<ffffffffc0390b07>] ath_isr+0x27/0x250 [ath9k]
[    7.067120]  RSP <ffff88011ed03e90>
[    7.070613] CR2: 0000000000000060
[    7.073939] ---[ end trace dfb976820ab61b50 ]---
[    7.078566] Kernel panic - not syncing: Fatal exception in interrupt
[    7.084941] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[    7.095107] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

I have no experience in debugging kernel panics, but running gdb on
vmlinux seems to point to the test_bit() call in ath_isr, which
dereferences the "struct ath_common *common" pointer.

I looked around a bit and noticed that in ath9k/pci.c:ath_pci_probe(),
the interrupt handler is registered with request_irq() before invoking
ath9k_init_device(), which takes care of allocating the ath_hw
structure. Therefore it might happen that an interrupt fires and
ath_isr() tries to use the structure before it's allocated.

As I said, I have very little experience in kernel programming so my
analysis could be completely wrong. In any case, I wouldn't know how
to fix it. Any help please?

Thanks,
Davide
