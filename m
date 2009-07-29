Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15389 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbZG2Sof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 14:44:35 -0400
Subject: Re: Pulling rt73 USB stick oopses the kernel
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200907291224.37562.mb@bu3sch.de>
References: <200907291224.37562.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 14:44:34 -0400
Message-Id: <1248893074.2750.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-29 at 12:24 +0200, Michael Buesch wrote:
> Pulling a rt73 USB stick in operation (packets were injected into the monitor)
> does oops the kernel as follows:
...
> [  829.269554] BUG kmalloc-16: Redzone overwritten

There are some memory corruption issues with the removal of rt73usb and
rt61pci, but they are hard to track down.  Using kmemcheck allows to
catch the first invalid memory access.

That's what I got (that's unloading rt73usb with rmmod while the
interface is up in station mode):

usbcore: deregistering interface driver rt73usb
WARNING: kmemcheck: Caught 64-bit read from freed memory (ffff88012f36b4c0)
58f97781ffffffff58f97781ffffffff4c71000001000000e0e00481ffffffff
 f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
 ^

Modules linked in: rt2x00usb rt2x00lib mac80211 cfg80211 [last unloaded: rt73usb]
Pid: 2043, comm: hald Not tainted 2.6.31-rc4-wl #185 G31T-M
RIP: 0010:[<ffffffff8124b476>]  [<ffffffff8124b476>] __list_add+0x26/0xa0
RSP: 0018:ffff88012f8f7da0  EFLAGS: 00010046
RAX: ffffffff8177f480 RBX: ffff8800280305a0 RCX: 00000000000004c0
RDX: ffffffff8177f958 RSI: ffff88012f36b4c0 RDI: ffff8800280305a0
RBP: ffff88012f8f7dc0 R08: ffff88012f36b4c0 R09: ffff880028022000
R10: 00000000ffffffff R11: 0000000000000000 R12: ffffffff8177f958
R13: ffff88012f36b4c0 R14: 000000010000714c R15: ffffffff8177f480
FS:  00007ff62a5316f0(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88012f890ea8 CR3: 000000012f21e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff810461f5>] internal_add_timer+0xb5/0x110
 [<ffffffff810468b1>] mod_timer+0xe1/0x130
 [<ffffffff81046913>] add_timer+0x13/0x20
 [<ffffffff8104e03b>] queue_delayed_work_on+0x8b/0xc0
 [<ffffffff8104e34c>] queue_delayed_work+0x1c/0x30
 [<ffffffff8104e376>] schedule_delayed_work+0x16/0x20
 [<ffffffff81081dc8>] vmstat_update+0x38/0x40
 [<ffffffff8104dbb4>] worker_thread+0xe4/0x190
 [<ffffffff81051816>] kthread+0x96/0xa0
 [<ffffffff8100c2ba>] child_rip+0xa/0x20
 [<ffffffffffffffff>] 0xffffffffffffffff


__list_add+0x26 corresponds to line 27 in lib/list_debug.c:

        WARN(prev->next != next,
                "list_add corruption. prev->next should be "
                "next (%p), but was %p. (prev=%p).\n",
                next, prev->next, prev);

next and prev are accessed in the previous statement, so apparently it's
prev->next that is invalid.

rt73usb is already unloaded at this point.  Perhaps it left some timers
registered.

-- 
Regards,
Pavel Roskin
