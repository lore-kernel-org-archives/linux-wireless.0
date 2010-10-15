Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48535 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0JOXdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:33:52 -0400
Message-ID: <4CB8E4DE.9070706@candelatech.com>
Date: Fri, 15 Oct 2010 16:33:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com> <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com> <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com> <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com> <4CB8AD3F.50201@candelatech.com> <20101015210720.GA2007@tux> <20101015232140.GA1796@tux>
In-Reply-To: <20101015232140.GA1796@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 04:21 PM, Luis R. Rodriguez wrote:
> Ben, please give this patch a shot. I addresses three races on the PCU:
>
>    * When we were stopping the CPU for non-EDMA cards we never locked against
>      anything starting the PCU again
>
>    * ath9k_hw_startpcureceive() was being called without locking
>
>    * Although we lock on the rxbuf lock for contention against starting/stopping
>      the PCU, we also need to lock on the driver in locations where we start/stop
>      the PCU within the same location otherwise we end up in inconsistant states
>      and the hardware may end up proessing an incorrect buffer for DMA. To
>      protect against this we use a new PCU lock on the main part of the driver to
>      ensure each start/stop/reset operation is done atomically.
>
> And fixes one issue as a side effect:
>
>    * No more packet loss on ping flood when you have one STA associated :)
>
> The only issue I see with this is I eventually run out of memory and my box
> becomes useless, unless I am mistaking that for some other issue.
>
> Please give this a shot and if it cures your woes I'll split it up into
> 3 separate patches, or maybe just two, one for the first two and one for
> the last issue.

Sounds good, but this lockdep splat happens almost immediately upon starting
my app:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.36-rc8-wl+ #32
-------------------------------------------------------
swapper/0 is trying to acquire lock:
  (&(&sc->rx.pcu_lock)->rlock){+.-...}, at: [<fa16e5c7>] ath9k_tasklet+0x7e/0x140 [ath9k]

but task is already holding lock:
  (&(&sc->rx.rxflushlock)->rlock){+.-...}, at: [<fa16e5b9>] ath9k_tasklet+0x70/0x140 [ath9k]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&sc->rx.rxflushlock)->rlock){+.-...}:
        [<c0457639>] lock_acquire+0x5a/0x78
        [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
        [<fa170513>] ath_flushrecv+0x14/0x61 [ath9k]
        [<fa16dda2>] ath_radio_disable+0x83/0x143 [ath9k]
        [<fa16e370>] ath9k_config+0x3c3/0x3d8 [ath9k]
        [<fa09ca2e>] ieee80211_hw_config+0x11b/0x125 [mac80211]
        [<fa0a8edf>] ieee80211_do_open+0x3c5/0x466 [mac80211]
        [<fa0a8fdb>] ieee80211_open+0x5b/0x5e [mac80211]
        [<c06ce76b>] __dev_open+0x80/0xae
        [<c06cc99b>] __dev_change_flags+0xa0/0x115
        [<c06ce6bf>] dev_change_flags+0x13/0x3f
        [<c06d7e78>] do_setlink+0x23a/0x51b
        [<c06d847c>] rtnl_newlink+0x269/0x431
        [<c06d79e2>] rtnetlink_rcv_msg+0x182/0x198
        [<c06e503c>] netlink_rcv_skb+0x30/0x77
        [<c06d7859>] rtnetlink_rcv+0x1b/0x22
        [<c06e4e77>] netlink_unicast+0xbe/0x119
        [<c06e5a15>] netlink_sendmsg+0x234/0x24c
        [<c06bf93a>] __sock_sendmsg+0x51/0x5a
        [<c06bfba4>] sock_sendmsg+0x93/0xa7
        [<c06bfd8c>] sys_sendmsg+0x149/0x193
        [<c06c148b>] sys_socketcall+0x15e/0x1a5
        [<c0402f1c>] sysenter_do_call+0x12/0x38

-> #0 (&(&sc->rx.pcu_lock)->rlock){+.-...}:
        [<c0457374>] __lock_acquire+0x921/0xb8c
        [<c0457639>] lock_acquire+0x5a/0x78
        [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
        [<fa16e5c7>] ath9k_tasklet+0x7e/0x140 [ath9k]
        [<c0438fd1>] tasklet_action+0x73/0xc6
        [<c043945f>] __do_softirq+0x86/0x111
        [<c0439520>] do_softirq+0x36/0x5a
        [<c0439659>] irq_exit+0x35/0x69
        [<c0403fb9>] do_IRQ+0x86/0x9a
        [<c04034ee>] common_interrupt+0x2e/0x40
        [<c040227f>] cpu_idle+0x4e/0x6b
        [<c074b6e9>] rest_init+0x8d/0x92
        [<c09758ea>] start_kernel+0x320/0x325
        [<c09750d0>] i386_start_kernel+0xd0/0xd7

other info that might help us debug this:

1 lock held by swapper/0:
  #0:  (&(&sc->rx.rxflushlock)->rlock){+.-...}, at: [<fa16e5b9>] ath9k_tasklet+0x70/0x140 [ath9k]

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.36-rc8-wl+ #32
Call Trace:
  [<c075d940>] ? printk+0xf/0x17
  [<c04565af>] print_circular_bug+0x91/0x9d
  [<c0457374>] __lock_acquire+0x921/0xb8c
  [<c0457639>] lock_acquire+0x5a/0x78
  [<fa16e5c7>] ? ath9k_tasklet+0x7e/0x140 [ath9k]
  [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
  [<fa16e5c7>] ? ath9k_tasklet+0x7e/0x140 [ath9k]
  [<fa16e5c7>] ath9k_tasklet+0x7e/0x140 [ath9k]
  [<c0438fd1>] tasklet_action+0x73/0xc6
  [<c043945f>] __do_softirq+0x86/0x111
  [<c0439520>] do_softirq+0x36/0x5a
  [<c0439659>] irq_exit+0x35/0x69
  [<c0403fb9>] do_IRQ+0x86/0x9a
  [<c04034ee>] common_interrupt+0x2e/0x40
  [<c045007b>] ? do_adjtimex+0x223/0x55e
  [<c0408245>] ? mwait_idle+0x5c/0x6c
  [<c040227f>] cpu_idle+0x4e/0x6b
  [<c074b6e9>] rest_init+0x8d/0x92
  [<c09758ea>] start_kernel+0x320/0x325
  [<c09750d0>] i386_start_kernel+0xd0/0xd7


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

