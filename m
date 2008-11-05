Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:37680 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYKEPlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:41:50 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Wed, 5 Nov 2008 13:42:04 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <970642.22610.qm@web23103.mail.ird.yahoo.com>
In-Reply-To: <970642.22610.qm@web23103.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811051342.05303.herton@mandriva.com.br> (sfid-20081105_164153_702260_139D09C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 November 2008 00:02:07 Hin-Tak Leung wrote:
> --- On Tue, 4/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > > Signed-off-by: Herton Ronaldo Krzesinski
> >
> > <herton@mandriva.com.br>
> >
> > Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> I tried with this combo:
>
> compat-wireless: master-2008-10-31
> wireless-testing: v2.6.28-rc2-4239-gd80fe00
>
> and applying the two patches on top, they applies cleanly and compile okay
> except for some warnings in a different module about missing symbols
> (<something>_sta) but the result dies very painfully with a kernel oops:

Looks like something bad in combination of compat-wireless plus kernel 
2.6.27.4-73.fc10.x86_64, please try a plain wireless-testing tree with the 
two patches.

> -------------
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000307
> IP: [<ffffffffa0105988>] rtl8187_probe+0x7f/0x836 [rtl8187]
> PGD 754c4067 PUD 751d5067 PMD 0
> Oops: 0002 [1] SMP
> CPU 0
> Modules linked in: rtl8187(+) snd_page_alloc video firewire_ohci
> firewire_core shpchp pcspkr eeprom_93cx6 output ac battery joydev r8169
> crc_itu_t soundcore i2c_piix4 k8temp hwmon pata_atiixp radeon drm
> i2c_algo_bit i2c_core Pid: 829, comm: modprobe Not tainted
> 2.6.27.4-73.fc10.x86_64 #1
> RIP: 0010:[<ffffffffa0105988>]  [<ffffffffa0105988>]
> rtl8187_probe+0x7f/0x836 [rtl8187] RSP: 0018:ffff880074de1c48  EFLAGS:
> 00010246
> RAX: ffffffffa0108520 RBX: ffff880074de1cd0 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffff8800754763c8 RDI: 0000000000000040
> RBP: ffff880074de1d08 R08: 00000000000003e8 R09: ffff8800776ed868
> R10: ffff8800754761c4 R11: 000000000000000a R12: 0000000000000000
> R13: ffff8800754762e0 R14: 0000000000000038 R15: ffff880074958000
> FS:  00007f5c8bef66f0(0000) GS:ffffffff8158a100(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000307 CR3: 0000000074dc6000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 829, threadinfo ffff880074de0000, task
> ffff880075420000) Stack:  ffff880074de1cb8 ffffffff8110d22f
> ffff880074de1c78 ffff880074de1c78 ffff88007402af50 ffff88007402af50
> ffffffffa0108520 ffff88007487a000 ffff880074958000 ffffffff81031023
> ffff880074de1ca8 ffffffff81353562 Call Trace:
>  [<ffffffff8110d22f>] ? sysfs_addrm_finish+0x69/0x20e
>  [<ffffffff81031023>] ? need_resched+0x1e/0x28
>  [<ffffffff81353562>] ? _cond_resched+0x9/0x38
>  [<ffffffff81353aee>] ? mutex_lock+0x22/0x33
>  [<ffffffff81240d08>] ? usb_match_one_id+0x2b/0x88
>  [<ffffffff812412df>] ? usb_autopm_do_device+0xc8/0xd4
>  [<ffffffff812418b5>] usb_probe_interface+0x10e/0x14b
>  [<ffffffff811f64c4>] driver_probe_device+0xc0/0x16e
>  [<ffffffff811f65c1>] __driver_attach+0x4f/0x79
>  [<ffffffff811f6572>] ? __driver_attach+0x0/0x79
>  [<ffffffff811f5d57>] bus_for_each_dev+0x4f/0x89
>  [<ffffffff811f630f>] driver_attach+0x1c/0x1e
>  [<ffffffff811f5677>] bus_add_driver+0xb7/0x201
>  [<ffffffff811f67b0>] driver_register+0xa8/0x128
>  [<ffffffff81241aff>] usb_register_driver+0x80/0xe4
>  [<ffffffffa00bb000>] ? rtl8187_init+0x0/0x20 [rtl8187]
>  [<ffffffffa00bb01e>] rtl8187_init+0x1e/0x20 [rtl8187]
>  [<ffffffff8100a047>] do_one_initcall+0x47/0x12e
>  [<ffffffff81065be1>] sys_init_module+0xa9/0x1b6
>  [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
>
>
> Code: 24 e1 e9 98 07 00 00 48 81 eb 88 00 00 00 48 89 5d 80 4c 8b 60 40 48
> 8d 5d c8 48 8b 85 70 ff ff ff 4d 8d 74 24 38 48 83 78 10 01 <41> 0f 94 84
> 24 07 03 00 00 48 8b 85 78 ff ff ff 49 8b 55 28 48
> RIP  [<ffffffffa0105988>] rtl8187_probe+0x7f/0x836 [rtl8187]
>  RSP <ffff880074de1c48>
> CR2: 0000000000000307
> ---[ end trace aed852fa39b00f8c ]---
> ---------
>
>
> Hin-Tak

--
[]'s
Herton
