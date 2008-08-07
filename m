Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:38765 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYHGFMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:12:14 -0400
Received: by wf-out-1314.google.com with SMTP id 27so468261wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:12:13 -0700 (PDT)
Message-ID: <1197ff4c0808062212u6d30f535q431671f2c77dc21a@mail.gmail.com> (sfid-20080807_071219_086761_C6F4C3E1)
Date: Thu, 7 Aug 2008 13:12:13 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] ath5k hang up in mesh mode
Cc: "Bob Copeland" <me@bobcopeland.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1197ff4c0808061945s1ccc5a97r24263e816cc597ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1197ff4c0808060056q7e10e39cl41a5ea5a26b7cdd6@mail.gmail.com>
	 <b6c5339f0808060656v771a00dar51054236bc4ec50b@mail.gmail.com>
	 <1218031218.23048.4.camel@johannes.berg>
	 <1197ff4c0808061945s1ccc5a97r24263e816cc597ec@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 7, 2008 at 10:45 AM, YanBo <dreamfly281@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 10:00 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>
>>> > [  577.639420] Mesh plink with 00:19:e0:86:0f:2f ESTABLISHED
>>> > [  602.864544] BUG: sleeping function called from invalid context at
>>> > mm/slab.c:3043
>>> > [  602.869975] in_atomic():1, irqs_disabled():0
>>> > [  602.874241] INFO: lockdep is turned off.
>>> > [  602.878162] Pid: 5160, comm: ath5k_pci Not tainted
>>> > 2.6.27-rc1-wl-14922-gb73da91 #4
>>> > [  602.885719]  [<c0172e5f>] kmem_cache_alloc+0xef/0x110
>>> > [  602.890794]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
>>> > [  602.895610]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
>>> > [  602.900468]  [<c04eb8c6>] hwmp_route_info_get+0x406/0x4c0
>>> > [  602.905886]  [<c04eb4e5>] hwmp_route_info_get+0x25/0x4c0
>>> > [  602.911927]  [<c04eb9f4>] mesh_rx_path_sel_frame+0x74/0x870
>>> > [  602.917257]  [<c04d76dd>] ieee80211_rx_bss_info+0x67d/0xe80
>>> > [  602.922846]  [<c04d70dc>] ieee80211_rx_bss_info+0x7c/0xe80
>>> > [  602.928353]  [<c04d9d40>] ieee80211_rx_mgmt_action+0x180/0x8a0
>>>
>>> I guess mesh_path_add should be using GFP_ATOMIC instead of GFP_KERNEL, since
>>> it's called under rcu_read_lock?  CCed Johannes.
>>
>> Looks like it, but I don't really know. OTOH, we really could make all
>> that RX business non-atomic. Oh well, not now.
>>
> Above bug disappeared after change the GFP_KERNEL to GFP_ATOMIC, but
> the PC still will hang up after send some packets, and the dmesg show
> below message, IMHO this should be the root cause of the problem, it
> is still a  "cpu stuck for 61s" Bug after insert ath5k module:
>
> [   84.824343] mesh: no IPv6 routers present
> [  133.610997] Mesh plink (peer, state, llid, plid, event):
> 00:19:e0:86:0f:2f 0 0 0 1
> [  133.618982] Mesh plink (peer, state, llid, plid, event):
> 00:19:e0:86:0f:2f 2 23523 50820 4
> [  133.626851] Mesh plink with 00:19:e0:86:0f:2f ESTABLISHED
> [  253.403937] BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
> [  253.405266] Modules linked in: ath5k
> [  253.405266] irq event stamp: 706218
> [  253.405266] hardirqs last  enabled at (706217): [<c02dc49f>]
> acpi_processor_idle+0x2a6/0x3ff
> [  253.405266] hardirqs last disabled at (706218): [<c050267d>]
> schedule+0x6d/0x340
> [  253.405266] softirqs last  enabled at (706166): [<c01267e5>]
> do_softirq+0x45/0x50
> [  253.405266] softirqs last disabled at (706159): [<c01267e5>]
> do_softirq+0x45/0x50
> [  253.405266]
> [  253.405266] Pid: 0, comm: swapper Not tainted
> (2.6.27-rc1-wl-14922-gb73da91-dirty #6)
> [  253.405266] EIP: 0060:[<c0281502>] EFLAGS: 00000202 CPU: 0
> [  253.405266] EIP is at delay_tsc+0x92/0x9c
> [  253.405266] EAX: c06f6000 EBX: 000000a0 ECX: c06f6000 EDX: 00000309
> [  253.405266] ESI: 00000001 EDI: 03518402 EBP: 00000000 ESP: c06f7c4c
> [  253.405266]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  253.405266] CR0: 8005003b CR2: b7f6fa7c CR3: 35047000 CR4: 000006d0
> [  253.405266] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  253.405266] DR6: ffff0ff0 DR7: 00000400
> [  253.405266]  [<c0281406>] __delay+0x6/0x10
> [  253.405266]  [<c02857dc>] _raw_spin_lock+0xbc/0x140
> [  253.405266]  [<c02854b8>] spin_bug+0x18/0x100
> [  253.405266]  [<c0504a08>] _spin_lock_bh+0x58/0x70
> [  253.405266]  [<f885a3d5>] ath5k_tx+0x335/0x490 [ath5k]
> [  253.405266]  [<f885a3d5>] ath5k_tx+0x335/0x490 [ath5k]
> [  253.405266]  [<f885d150>] ath5k_hw_setup_4word_tx_desc+0x0/0x2a0 [ath5k]
> [  253.405266]  [<c04e577e>] __ieee80211_tx+0x3e/0x160
> [  253.405266]  [<c04e5bf7>] ieee80211_master_start_xmit+0x247/0x3e0
> [  253.405266]  [<c04e5b27>] ieee80211_master_start_xmit+0x177/0x3e0
> [  253.405266]  [<c042a35d>] dev_hard_start_xmit+0x27d/0x310
> [  253.405266]  [<c0438a41>] __qdisc_run+0x141/0x1e0
> [  253.405266]  [<c042cbc2>] dev_queue_xmit+0xb2/0x500
> [  253.405266]  [<c042cdc7>] dev_queue_xmit+0x2b7/0x500
> [  253.405266]  [<c042cb49>] dev_queue_xmit+0x39/0x500
> [  253.405266]  [<c04eb2d6>] mesh_path_error_tx+0xe6/0x100
> [  253.405266]  [<c04e9728>] mesh_plink_broken+0xc8/0x130
> [  253.405266]  [<c04e9660>] mesh_plink_broken+0x0/0x130
> [  253.405266]  [<c04ecf32>] rate_control_pid_tx_status+0x582/0x5a0
> [  253.405266]  [<c04ec9d5>] rate_control_pid_tx_status+0x25/0x5a0
> [  253.405266]  [<c04cfd60>] ieee80211_tx_status+0x240/0x4f0
> [  253.405266]  [<c04cfbd5>] ieee80211_tx_status+0xb5/0x4f0
> [  253.405266]  [<c04cfb20>] ieee80211_tx_status+0x0/0x4f0
> [  253.405266]  [<f8858f36>] ath5k_tasklet_tx+0x126/0x250 [ath5k]
> [  253.405266]  [<c0505035>] _spin_unlock+0x25/0x40
> [  253.405266]  [<c0126a76>] irq_exit+0x16/0x50
> [  253.405266]  [<c0126903>] tasklet_action+0x43/0x90
> [  253.405266]  [<c0126742>] __do_softirq+0x62/0xc0
> [  253.405266]  [<c01267e5>] do_softirq+0x45/0x50
> [  253.405266]  [<c0126aa4>] irq_exit+0x44/0x50
> [  253.405266]  [<c0105de6>] do_IRQ+0x46/0x90
> [  253.405266]  [<c02818c4>] trace_hardirqs_off_thunk+0xc/0x18
> [  253.405266]  [<c0103df8>] common_interrupt+0x28/0x30
> [  253.405266]  [<c02dc47c>] acpi_processor_idle+0x283/0x3ff
> [  253.405266]  [<c0101dff>] cpu_idle+0x2f/0x80
> [  253.405266]  =======================

After disable the kernel debugging option, this bug never be triggered
again, but obviously this problem is not be solved and I guess it is
some kinds of problem relative with "lock", BTW the performance
between two mesh node is very bad, I'll send a performance report in
another mail.


BR
yanbo
