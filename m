Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37332 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbHFQGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 12:06:08 -0400
Received: by igbpg9 with SMTP id pg9so14629262igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 09:06:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 6 Aug 2015 10:06:07 -0600
Message-ID: <CANR9swOiEVT6PvKv0V1Ytwm0GsN0_2HXqFpdmGAPzFoQG5T2Cg@mail.gmail.com> (sfid-20150806_180612_824463_9E66D0C6)
Subject: lenovo t400 atheros ar242x ath5k bug
From: Brady Lyles <lyles.brady@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I was recommended by the qubes-users list to ask here about an ath5k bug.
It looks like my fedora 20 networking virtual machine (netvm) is
trying to load the ath5k driver for the qualcomm atheros ar242x wifi
module in my lenovo t400, but is choking.
Here's an excerpt from netvm dmesg:

[    5.399092] ath5k 0000:00:01.0: Xen PCI mapped GSI17 to IRQ39
[    5.399311] ath5k 0000:00:01.0: registered as 'phy0'
[    5.401276] BUG: unable to handle kernel paging request at ffffc90000900014
[    5.401287] IP: [<ffffffff81268928>] iowrite32+0x38/0x40
[    5.401297] PGD 12536067 PUD 12537067 PMD 126f5067 PTE 8010000000000464
[    5.401309] Oops: 0003 [#1] SMP
[    5.401315] Modules linked in: ath5k(+) ath mac80211 cfg80211
rfkill e1000e ptp pps_core pcspkr coretemp hwmon dummy_hcd nfsd
udc_core usbcore auth_rpcgss oid_registry usb_common exportfs nfs_acl
lockd sunrpc u2mfn(O) xen_blkback binfmt_misc ext4 crc16 jbd2
dm_snapshot xen_blkfront autofs4
[    5.401356] CPU: 1 PID: 353 Comm: systemd-udevd Tainted: G
 O 3.12.40-1.pvops.qubes.x86_64 #1
[    5.401364] task: ffff88000b8286c0 ti: ffff88000b820000 task.ti:
ffff88000b820000
[    5.401369] RIP: e030:[<ffffffff81268928>]  [<ffffffff81268928>]
iowrite32+0x38/0x40
[    5.401377] RSP: e02b:ffff88000b821ad0  EFLAGS: 00010292
[    5.401381] RAX: 0000000000000000 RBX: ffff8800126d97c0 RCX: 0000000000000000
[    5.401386] RDX: ffffc90000900014 RSI: ffffc90000900014 RDI: 0000000000000000
[    5.401391] RBP: ffff88000b821af8 R08: 0000000000000000 R09: 000000000000177c
[    5.401396] R10: ffff88000c6dc2c0 R11: 0000000000000001 R12: 0000000000000000
[    5.401401] R13: 00000000ffffffff R14: 0000000000000000 R15: ffff8800126d97c0
[    5.401409] FS:  00007f56d958d880(0000) GS:ffff880012900000(0000)
knlGS:0000000000000000
[    5.401415] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.401419] CR2: ffff8000007a1800 CR3: 000000000cea6000 CR4: 0000000000002660
[    5.401425] Stack:
[    5.401427]  ffffffffa0420d26 00000000126d97c0 ffff8800126d97c0
0000000000000000
[    5.401436]  ffff88000c414000 ffff88000b821b38 ffffffffa0420fad
0000000000000010
[    5.401445]  00000000000000e2 0000000000000000 0000000000000000
ffffffffa0430c60
[    5.401453] Call Trace:
[    5.401465]  [<ffffffffa0420d26>] ? ath5k_hw_nic_reset+0x96/0xc0 [ath5k]
[    5.401475]  [<ffffffffa0420fad>] ath5k_hw_nic_wakeup+0x10d/0x420 [ath5k]
[    5.402041]  [<ffffffffa0422432>] ath5k_hw_init+0xe2/0x7e0 [ath5k]
[    5.402050]  [<ffffffffa0426da2>] ath5k_init_ah+0x1a2/0x550 [ath5k]
[    5.402059]  [<ffffffffa0429d61>] ath5k_pci_probe+0x1c1/0x290 [ath5k]
[    5.402067]  [<ffffffff812867cc>] pci_device_probe+0x7c/0xd0
[    5.402075]  [<ffffffff8134a1bb>] driver_probe_device+0x8b/0x3c0
[    5.402081]  [<ffffffff8134a5bb>] __driver_attach+0x8b/0x90
[    5.402086]  [<ffffffff8134a530>] ? __device_attach+0x40/0x40
[    5.402092]  [<ffffffff81348103>] bus_for_each_dev+0x63/0xa0
[    5.402098]  [<ffffffff81349c39>] driver_attach+0x19/0x20
[    5.402103]  [<ffffffff813497c0>] bus_add_driver+0x200/0x2d0
[    5.402110]  [<ffffffffa0437000>] ? 0xffffffffa0436fff
[    5.402115]  [<ffffffff8134abcf>] driver_register+0x5f/0xf0
[    5.402121]  [<ffffffffa0437000>] ? 0xffffffffa0436fff
[    5.402126]  [<ffffffff812853d7>] __pci_register_driver+0x47/0x50
[    5.402135]  [<ffffffffa043701e>] ath5k_pci_driver_init+0x1e/0x20 [ath5k]
[    5.402142]  [<ffffffff810020d2>] do_one_initcall+0xd2/0x180
[    5.402148]  [<ffffffff811592e2>] ? kfree+0xc2/0x130
[    5.402154]  [<ffffffff8114d05a>] ? __vunmap+0xaa/0xf0
[    5.402160]  [<ffffffff810c38f9>] load_module+0x1b39/0x2530
[    5.402166]  [<ffffffff810bfa40>] ? store_uevent+0x40/0x40
[    5.402172]  [<ffffffff810c087a>] ? copy_module_from_fd.isra.50+0x10a/0x160
[    5.402178]  [<ffffffff810c443e>] SyS_finit_module+0x7e/0xa0
[    5.402185]  [<ffffffff814ee367>] tracesys+0xdd/0xe2
[    5.402188] Code: 81 fe 00 00 01 00 76 0b 0f b7 d6 89 f8 ef c3 0f
1f 40 00 55 48 c7 c6 37 5f 7c 81 48 89 d7 48 89 e5 e8 1d fe ff ff 5d
c3 0f 1f 00 <89> 3e c3 0f 1f 44 00 00 48 81 ff ff ff 03 00 77 37 48 81
ff 00
[    5.402247] RIP  [<ffffffff81268928>] iowrite32+0x38/0x40
[    5.402253]  RSP <ffff88000b821ad0>
[    5.402257] CR2: ffffc90000900014
[    5.402261] ---[ end trace 2516d0582185bfb7 ]---

Are there any ideas about how to troubleshoot/fix? Is there more
information I can send?
Thank you in advance!
