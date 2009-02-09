Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4431 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZBICcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 21:32:21 -0500
Date: Sun, 8 Feb 2009 21:30:53 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hugh Dickins <hugh@veritas.com>, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Message-ID: <20090209023053.GA21639@hash.localnet> (sfid-20090209_033227_462109_0BAB019E)
References: <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0902061305530.15787@blonde.anvils> <20090206183443.M95991@bobcopeland.com> <20090206184445.GB7526@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090206184445.GB7526@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2009 at 01:44:46PM -0500, John W. Linville wrote:
> Hmmm...well it is a little big, but I guess it is OK.  Do you have
> an example of the stack trace?  Or a link to a bugzilla or somesuch
> would be even better...

Here's an oops I captured by forcing an skb alloc to fail (transcribed, 
my usb-to-serial adapter tends to drop lots of stuff):

------------[ cut here ]------------
kernel BUG at drivers/net/wireless/ath5k/base.c:1689!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/class/misc/fuse/dev

Pid: 0, comm: swapper Not tainted (2.6.29-rc3 #46) MacBook1,1
EIP: 0060:[f82222ba>] EFLAGS: 00010246 CPU: 1
EIP is at ath5k_tasklet_rx+0xb4/0x5a6 [ath5k]
EAX: f40923b8 EBX: 00000000 ECX: f409239c EDX: 00000000
ESI: 00000080 EDI: 00000082 RBP: 00000000 ESP: f73d5e70
 DS: 007b ES: 007b FS: 00d8 FS: 0000 SS: 0068
Process swapper (pid: 0, ti=f73d4000 task=f73ce750 task.ti=f73d4000)
Stack:
  00000082 f4068f60 f406f0f8 f406f0f0 00000000 f40923b8 f4092380 f406c090
  c0460404 f73ae000 2b74f34f 0000001f 00000000 0000099e ffffffe6 ffffffa0
  00000064 00000001 00000000 00000082 7e4f014e ff460000 0000011b f406c0ec
Call Trace:
  [<c0126bec>] tasklet_action+0x8a/0xeb
  [<c0127000>] __do_softirq+0x8c/0x13c
  [<c01270e6>] do_softirq+0x36/0x51
  [<c012727b>] irq_exit+0x43/0x79
  [<c01044f3>] do_IRQ+0x8e/0xa4
  [<c010346c>] common_interrupt+0x2c/0x34
  [<c013007b>] __create_workqueue_key+0xe1/0x184
  [<f85f009f>] acpi_idle_enter_bm+0x271/0x2f0 [processor]
  [<c02a0483>] menu_select+0x39/0x96
  [<c029fad0>] cpuidle_idle_call+0x62/0x92
  [<c0101f91>] cpu_idle+0x74/0xa7
Code: 64 31 00 00 81 c1 30 31 00 00 89 4c 24 1c 89 54 24 18 8b 44 24 04 8b 80 60 31 00 00 89 44 24 14 8b 50 14 85 d2 89 54 24 10 75 04 <0f> 0b eb fe 8b 4c 24 14 39 4c 24 18 8b 51 0c 75 08 8b 44 24 18
EIP: [<f82222ba>] ath5k_tasklet_rx+0xb4/0x5a6 [ath5k] SS:ESP 0068:f73d5e70
---[ end trace 67aef94060f00cf7 ]---
Kernel panic - not syncing: Fatal exception in interrupt

-- 
Bob Copeland %% www.bobcopeland.com

