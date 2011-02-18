Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55251 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1BRCTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 21:19:45 -0500
Received: by ywo7 with SMTP id 7so1403069ywo.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 18:19:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19805.55087.117572.853090@gargle.gargle.HOWL>
Date: Fri, 18 Feb 2011 07:49:27 +0530
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix conn_mon_timer running after disassociate
In-Reply-To: <20110216095443.GC2812@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
	<1297698696.4723.16.camel@wwguy-ubuntu>
	<20110215113444.GC2162@redhat.com>
	<1297770602.3935.3.camel@jlt3.sipsolutions.net>
	<20110215130428.GA2515@redhat.com>
	<1297775393.3935.15.camel@jlt3.sipsolutions.net>
	<20110215132202.GC2515@redhat.com>
	<1297776631.3935.16.camel@jlt3.sipsolutions.net>
	<20110216095443.GC2812@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka wrote:
> Low level driver could pass rx frames to us after disassociate, what
> can lead to run conn_mon_timer by ieee80211_sta_rx_notify(). Thats
> is obviously wrong, but nothing happens until we unload modules and
> resources are used after free. If kernel debugging is enabled following
> warning could be observed:

I just hit this issue right after unloading ath9k_htc.
I haven't tested your patch yet.

 general protection fault: 0000 [#1] PREEMPT SMP
 last sysfs file: /sys/devices/platform/regulatory.0/uevent
 CPU 1
 Modules linked in: arc4 ecb mac80211 cfg80211 ipv6 ext2 i915 drm_kms_helper drm i2c_algo_bit mct_u232 usbserial joydev pcmcia uhci_hcd ehci_hcd usbcore psmouse yenta_socket pcmcia_rsrc]

 Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc5-wl #43 LENOVO 7661GN4/7661GN4
 RIP: 0010:[<ffffffff81073e3b>]  [<ffffffff81073e3b>] __queue_work+0xab/0x480
 RSP: 0018:ffff88007d503d40  EFLAGS: 00010046
 RAX: ffff88003765f0d0 RBX: ffff88007d50f600 RCX: 0000000000000001
 RDX: 0000000000002601 RSI: ffffffff818443c0 RDI: ffff88007d50f600
 RBP: ffff88007d503d80 R08: 000000000005e3c0 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000104 R12: ffff88003765f0c8
 R13: 0000000000000282 R14: 0000000000000001 R15: ffff1000ea433a00
 FS:  0000000000000000(0000) GS:ffff88007d500000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f81dde2c098 CR3: 0000000001573000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kworker/0:0 (pid: 0, threadinfo ffff88007a8c2000, task ffff88007a8b9f60)
 Stack:
  ffff88007d503dc0 0000000000000002 0000000000000000 ffff88007a8c2000
  ffff88007a8c3fd8 ffff88007d503e80 0000000000000102 ffff88007a8c3fd8
  ffff88007d503d90 ffffffff8107425d ffff88007d503dc0 ffffffff810742c6
 Call Trace:
  <IRQ>
  [<ffffffff8107425d>] queue_work_on+0x1d/0x30
  [<ffffffff810742c6>] queue_work+0x36/0x60
  [<ffffffff810927ad>] ? trace_hardirqs_on_caller+0x5d/0x180
  [<ffffffffa036757d>] ieee80211_queue_work+0x3d/0x50 [mac80211]
  [<ffffffffa0351b6f>] ieee80211_sta_conn_mon_timer+0x2f/0x40 [mac80211]
  [<ffffffff81067f11>] run_timer_softirq+0x1a1/0x430
  [<ffffffff81067e7c>] ? run_timer_softirq+0x10c/0x430
  [<ffffffffa0351b40>] ? ieee80211_sta_conn_mon_timer+0x0/0x40 [mac80211]
  [<ffffffff8105fa89>] __do_softirq+0xd9/0x260
  [<ffffffff8108a748>] ? tick_dev_program_event+0x48/0x100
  [<ffffffff8108a81a>] ? tick_program_event+0x1a/0x20
  [<ffffffff8100cd9c>] call_softirq+0x1c/0x30
  [<ffffffff8100f0e5>] do_softirq+0xa5/0xe0
  [<ffffffff8105fd2d>] irq_exit+0x9d/0xa0
  [<ffffffff81029d6b>] smp_apic_timer_interrupt+0x6b/0xa0
  [<ffffffff8100c853>] apic_timer_interrupt+0x13/0x20
  <EOI>
  [<ffffffff81014605>] ? native_sched_clock+0x15/0x70
  [<ffffffffa00ed027>] ? acpi_idle_enter_bm+0x261/0x299 [processor]
  [<ffffffffa00ed020>] ? acpi_idle_enter_bm+0x25a/0x299 [processor]
  [<ffffffff812c9734>] cpuidle_idle_call+0xc4/0x2f0
  [<ffffffff8100a23b>] cpu_idle+0xab/0x110
  [<ffffffff81395c2d>] start_secondary+0x1f6/0x1fd

Sujith
