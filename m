Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZCYDpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 23:45:04 -0400
Date: Wed, 25 Mar 2009 11:41:21 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: TJ <ubuntu@tjworld.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
Message-ID: <20090325034121.GA4792@owl> (sfid-20090325_044516_501529_A6FFC213)
References: <1237909459.5365.16.camel@hephaestion> <200903241851.11949.helmut.schaa@gmail.com> <1237929739.5365.21.camel@hephaestion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1237929739.5365.21.camel@hephaestion>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This issue is confirmed here too. But during compile, there is warning =
about
cancel_work_sync(), cancel_delayed_work_sync() should be used instead.

And, without the modification in iwl3945_rfkill_poll() and=20
iwl3945_mac_stop(), just with one line cancel_delayed_work_sync(), this=
 issue
is also fixed in my testing.

Best regards
Huaxu

PS: The following is the log when iwl3945 was unloaded before patched.

root@Januty-devel:~# modprobe -r iwl3945
[  164.840610] iwl3945: U iwl3945_pci_remove *** UNLOAD DRIVER ***
[  164.846515] iwl3945: U __iwl3945_down iwl3945 is going down
[  164.852315] iwl3945: U iwl3945_hw_nic_stop_master stop master
[  164.858634] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-all=
ocated heap on clear.
[  164.917177] iwl3945: U __iwl3945_down iwl3945 is going down
[  164.922735] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-all=
ocated heap on clear.
[  166.804090] BUG: unable to handle kernel paging request at 000077ff8=
b64b8c7
[  166.808082] IP: [<ffffffff80262b62>] delayed_work_timer_fn+0x32/0x40
[  166.808082] PGD 0=20
[  166.808082] Oops: 0000 [#1] SMP=20
[  166.808082] last sysfs file: /sys/module/cfg80211/refcnt
[  166.808082] Dumping ftrace buffer:
[  166.808082]    (ftrace buffer empty)
[  166.808082] CPU 1=20
[  166.808082] Modules linked in: lp parport arc4 ecb psmouse iTCO_wdt =
video serio_raw pcspkr usbhid intel_agp iTCO_vendor_support output ehci=
_hcd uhci_hcd ]
[  166.808082] Pid: 0, comm: swapper Not tainted 2.6.28.8 #1
[  166.808082] RIP: 0010:[<ffffffff80262b62>]  [<ffffffff80262b62>] del=
ayed_work_timer_fn+0x32/0x40
[  166.808082] RSP: 0018:ffff88007b62be80  EFLAGS: 00010246
[  166.808082] RAX: 000077ff8b64b8bf RBX: ffff8800738df7c8 RCX: ffff880=
0738df7c8
[  166.808082] RDX: 0000000000000001 RSI: ffff8800738df7c8 RDI: ffff880=
0738df7c8
[  166.808082] RBP: ffff88007b62be80 R08: ffff8800738df820 R09: 0000000=
000000000
[  166.808082] R10: ffff88007b625e18 R11: 0000000000000000 R12: 0000000=
000000100
[  166.808082] R13: ffff88007b614000 R14: ffff88007b62beb0 R15: fffffff=
f80262b30
[  166.808082] FS:  0000000000000000(0000) GS:ffff88007bc02c00(0000) kn=
lGS:0000000000000000
[  166.808082] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  166.808082] CR2: 000077ff8b64b8c7 CR3: 0000000000201000 CR4: 0000000=
0000006a0
[  166.808082] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  166.808082] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  166.808082] Process swapper (pid: 0, threadinfo ffff88007b624000, ta=
sk ffff88007b61c320)
[  166.808082] Stack:
[  166.808082]  ffff88007b62bef0 ffffffff80259e39 ffff88007b615c18 ffff=
88007b615818
[  166.808082]  ffff88007b615418 ffff88007b615018 ffff88007b62beb0 ffff=
88007b62beb0
[  166.808082]  ffffffff80271efd 0000000000000008 0000000000000001 0000=
000000000100
[  166.808082] Call Trace:
[  166.808082]  <IRQ> <0> [<ffffffff80259e39>] run_timer_softirq+0x179/=
0x260
[  166.808082]  [<ffffffff80271efd>] ? tick_handle_oneshot_broadcast+0x=
ed/0x100
[  166.808082]  [<ffffffff80254cfc>] __do_softirq+0x9c/0x170
[  166.808082]  [<ffffffff80213cac>] call_softirq+0x1c/0x30
[  166.808082]  [<ffffffff80214f0d>] do_softirq+0x5d/0xa0
[  166.808082]  [<ffffffff80254a7d>] irq_exit+0x8d/0xa0
[  166.808082]  [<ffffffff802151d5>] do_IRQ+0xc5/0x110
[  166.808082]  [<ffffffff80212b13>] ret_from_intr+0x0/0x29
[  166.808082]  <EOI> <0> [<ffffffff8046d906>] ? acpi_idle_enter_simple=
+0x166/0x1a4
[  166.808082]  [<ffffffff8046d8fe>] ? acpi_idle_enter_simple+0x15e/0x1=
a4
[  166.808082]  [<ffffffff805745a5>] ? cpuidle_idle_call+0xa5/0x100
[  166.808082]  [<ffffffff80210e85>] ? cpu_idle+0x65/0xc0
[  166.808082]  [<ffffffff8067e6fd>] ? start_secondary+0x168/0x1bb
[  166.808082] Code: 65 8b 14 25 24 00 00 00 48 89 e5 48 83 e0 fc 48 8b=
 40 38 8b 70 20 48 8b 00 85 f6 0f 45 15 ff c9 72 00 48 f7 d0 48 89 ce 4=
8 63 d2 <48> 8=20
[  166.808082] RIP  [<ffffffff80262b62>] delayed_work_timer_fn+0x32/0x4=
0
[  166.808082]  RSP <ffff88007b62be80>
[  166.808082] CR2: 000077ff8b64b8c7
[  167.086916] Kernel panic - not syncing: Fatal exception in interrupt


On 21:22 Tue 24 Mar, TJ wrote:
> On Tue, 2009-03-24 at 18:51 +0100, Helmut Schaa wrote:
> > Am Dienstag, 24. M=E4rz 2009 schrieb TJ:
> > > Tim Gardner suggested I forward this as a possible stable-release
> > > update. I found the problem in our current Ubuntu Jaunty tree - i=
wlwifi
> > > version 1.2.26k. What follows is a copy of the patch for Jaunty
> > > (2.6.28).
> >=20
> > The patch that introduced the rfkill polling did not hit mainline y=
et. It
> > should pop up in 2.6.30, hence this patch is not needed for any sta=
ble
> > series.
> >=20
> > I wasn't able to reproduce the issue by unloading iwl3945 here. Any=
 hints
> > on how to reproduce this issue?
>=20
> lspci -nn -s 06:00.0
> 06:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 394=
5ABG [Golan] Network Connection [8086:4222] (rev 02)
>=20
> With the interface active and in use do:
>=20
> sudo modprobe -r iwl3945
>=20
> Approximately 2 seconds later the PC locks solid and requires a
> power-off button restart.
>=20
> Confirmed by another of our kernel team:
>=20
> https://launchpad.net/bugs/345710
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
