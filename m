Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45466 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756229AbdACDE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 22:04:29 -0500
Message-ID: <586B14C9.8050407@candelatech.com> (sfid-20170103_040440_590937_A0FCDE25)
Date: Mon, 02 Jan 2017 19:04:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix invalid 'info' access in xmit-fast.
References: <1483123790-14412-1-git-send-email-greearb@candelatech.com> <1483352652.4596.0.camel@sipsolutions.net>
In-Reply-To: <1483352652.4596.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2017 02:24 AM, Johannes Berg wrote:
> On Fri, 2016-12-30 at 10:49 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> ieee80211_xmit_fast assigns info from the passed-in
>> skb, but then later it also checks for skb_shared(skb),
>> and may create a new skb based on that check.
>>
>> But, the code did not re-assign 'info', so it pointed into
>> the old shared skb.  This leads to all sorts of problems,
>> most obviously crashes since the new skb's info->hw_queue is not
>> properly initialized.
>>
>> Bug was seen by sending pktgen packets on a bridge that
>> had an AP network interface in it.  hw-queue was out of
>> range, which made it crash like this:
>>
>> BUG: unable to handle kernel NULL pointer dereference
>> at           (null)
>> IP: [<ffffffffa0ad4672>] ieee80211_tx_frags+0x232/0x4c0 [mac80211]
>> PGD 0
>> Oops: 0002 [#1] PREEMPT SMP
>> CPU: 0 PID: 1512 Comm: kpktgend_0 Tainted: G           O    4.7.10+
>> #24
>> Hardware name: To be filled by O.E.M. To be filled by
>> O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
>> task: ffff8802132f3a00 ti: ffff8800362ac000 task.ti: ffff8800362ac000
>> RIP: 0010:[<ffffffffa0ad4672>]  [<ffffffffa0ad4672>]
>> ieee80211_tx_frags+0x232/0x4c0 [mac80211]
>> RSP: 0018:ffff8800362afa28  EFLAGS: 00010086
>> RAX: ffff8802130a22c0 RBX: ffff8802130a13a0 RCX: ffff880035ef2200
>> RDX: ffff880035ef2200 RSI: 0000000000000292 RDI: 0000000000000000
>> RBP: ffff8800362afa90 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000088 R11: 0000000000000001 R12: ffff880035ef2200
>> R13: ffff880035dabb90 R14: ffff8800362afb18 R15: 0000000000000cc0
>> FS:  0000000000000000(0000) GS:ffff88021e200000(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000000 CR3: 0000000001e06000 CR4: 00000000001406f0
>> Stack:
>>   0000000000000292 ffff880035daa880 ffff8802130a0b20 ffff8800d4f01808
>>   00ff8800362afaa0 ffff8800362afb18 ffff8802130a13c0 ffff88021e20db68
>>   ffff880035daa880 ffff8800362afb18 ffff880035ef2200 ffff88020f6ca300
>> Call Trace:
>>   [<ffffffffa0ad9f63>] __ieee80211_subif_start_xmit+0xc13/0xc30
>> [mac80211]
>>   [<ffffffff8113d2c5>] ? find_busiest_group+0x35/0x4a0
>>   [<ffffffffa0ad9f8b>] ieee80211_subif_start_xmit+0xb/0x10 [mac80211]
>>   [<ffffffff8177d40b>] dev_hard_start_xmit+0x9b/0x220
>>   [<ffffffff817a3716>] sch_direct_xmit+0xd6/0x1a0
>>   [<ffffffff8177da8e>] __dev_queue_xmit+0x3be/0x6c0
>>   [<ffffffff81127f43>] ? finish_task_switch+0x73/0x1f0
>>   [<ffffffff8177dd9d>] dev_queue_xmit+0xd/0x10
>>   [<ffffffffa0b5fe85>] br_dev_queue_push_xmit+0x75/0x140 [bridge]
>>   [<ffffffffa0b5ffc9>] br_forward_finish+0x29/0xa0 [bridge]
>>   [<ffffffff8116db83>] ? del_timer_sync+0x43/0x50
>>   [<ffffffffa0b600a2>] __br_deliver+0x62/0x130 [bridge]
>>   [<ffffffff81175937>] ? __getnstimeofday64+0x37/0xd0
>>   [<ffffffff811759d9>] ? getnstimeofday64+0x9/0x30
>>   [<ffffffffa0b605b6>] br_deliver+0x56/0x60 [bridge]
>>   [<ffffffffa0b5d472>] br_dev_xmit+0x1c2/0x250 [bridge]
>>   [<ffffffffa137aa1c>] pktgen_thread_worker+0x174c/0x2471 [pktgen]
>>   [<ffffffff8185087a>] ? __schedule+0x30a/0x7c0
>>   [<ffffffff811446e0>] ? wake_atomic_t_function+0x60/0x60
>>   [<ffffffffa13792d0>] ? pktgen_rem_all_ifs+0x80/0x80 [pktgen]
>>   [<ffffffff81121c14>] kthread+0xc4/0xe0
>>   [<ffffffff818551df>] ret_from_fork+0x1f/0x40
>>   [<ffffffff81121b50>] ? kthread_worker_fn+0x180/0x180
>>
>> Fix this by re-assigning info after creating new one.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> This patch is against 4.7.10+
>
> And thus didn't apply - I've replaced it with my own patch which I'll
> send out in a moment

Thanks for your patch...  It is cleaner than what I originally wrote,
and I was out the door before I thought to re-write it as you did.

FYI, the same patch applies as far back as 4.4...I didn't look at anything older.

Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
