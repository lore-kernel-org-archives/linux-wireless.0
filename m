Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33419 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZKDK7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 05:59:15 -0500
Received: by bwz27 with SMTP id 27so8699743bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 02:59:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257327017.28469.76.camel@johannes.local>
References: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
	 <1257327017.28469.76.camel@johannes.local>
Date: Wed, 4 Nov 2009 04:59:20 -0600
Message-ID: <51058d550911040259k1da3a624wc6325c78b954d56f@mail.gmail.com>
Subject: Re: iwlwifi connection troubles, maybe aggregation related
From: Greg Oliver <oliver.greg@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-wireless@vger.kernel.org,
	ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 3:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-11-03 at 18:38 -0500, Andrew Lutomirski wrote:
>
>> iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:21:d8:49:4a:52 tid = 0
>
>> Turning on or off power management and fiddling with
>> no_sleep_autoadjust makes no difference.  Setting tx_agg_tid_enable to
>> zero in debugfs while the connection was working seemed to make it a
>> little more reliable (it lasted long enough to do "git pull" but not
>> much longer).
>>
>> After running "iw dev wlan0 disconnect" a few times, I start to get
>> errors like this:
>>
>> [18078.209635] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
>> [18078.313461] iwlagn 0000:03:00.0: No space for Tx
>> [18078.313467] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
>> enqueue_hcmd failed: -28
>> [18078.313470] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
>> [18078.522409] iwlagn 0000:03:00.0: No space for Tx
>> [18078.522414] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
>> enqueue_hcmd failed: -28
>
> Sounds like the firmware messes up ...
>
> Maybe as a first workaround you could modprobe iwlagn with
> 11n_disable=1. But I don't know at this point what the problem could be.
>
> johannes
>

I am also still getting oops' with -rc5..

[36759.355012] Pid: 0, comm: swapper Tainted: P
2.6.31-14-generic #48-Ubuntu
[36759.355018] Call Trace:
[36759.355022]  <IRQ>  [<ffffffff810e083c>] __alloc_pages_slowpath+0x4cc/0x4e0
[36759.355047]  [<ffffffff810e099e>] __alloc_pages_nodemask+0x14e/0x150
[36759.355059]  [<ffffffff81111dfa>] kmalloc_large_node+0x5a/0xb0
[36759.355067]  [<ffffffff81115fa5>] __kmalloc_node_track_caller+0x135/0x180
[36759.355109]  [<ffffffffa03c7977>] ? iwl_rx_allocate+0x197/0x2f0 [iwlcore]
[36759.355121]  [<ffffffff8142e41b>] __alloc_skb+0x7b/0x180
[36759.355146]  [<ffffffffa03c7977>] iwl_rx_allocate+0x197/0x2f0 [iwlcore]
[36759.355171]  [<ffffffffa03c8de6>] iwl_rx_replenish_now+0x16/0x30 [iwlcore]
[36759.355191]  [<ffffffffa03e4f18>] iwl_rx_handle+0x288/0x2f0 [iwlagn]
[36759.355208]  [<ffffffffa03e5708>] iwl_irq_tasklet+0x138/0x4e0 [iwlagn]
[36759.355220]  [<ffffffff810741e0>] ? delayed_work_timer_fn+0x0/0x40
[36759.355228]  [<ffffffff81073d82>] ? insert_work+0x72/0xc0
[36759.355239]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
[36759.355248]  [<ffffffff81063ee0>] tasklet_action+0xd0/0xe0
[36759.355257]  [<ffffffff8106549d>] __do_softirq+0xbd/0x200
[36759.355266]  [<ffffffff810131ec>] call_softirq+0x1c/0x30
[36759.355273]  [<ffffffff81014bc5>] do_softirq+0x55/0x90
[36759.355281]  [<ffffffff81065205>] irq_exit+0x85/0x90
[36759.355287]  [<ffffffff81014100>] do_IRQ+0x70/0xe0
[36759.355296]  [<ffffffff81012a13>] ret_from_intr+0x0/0x11
[36759.355301]  <EOI>  [<ffffffff812d7ed9>] ? acpi_idle_enter_bm+0x28b/0x2bf
[36759.355317]  [<ffffffff812d7ed2>] ? acpi_idle_enter_bm+0x284/0x2bf
[36759.355327]  [<ffffffff813fe40b>] ? cpuidle_idle_call+0x9b/0xf0
[36759.355335]  [<ffffffff81010e12>] ? cpu_idle+0xb2/0x100
[36759.355344]  [<ffffffff81514c56>] ? rest_init+0x66/0x70
[36759.355355]  [<ffffffff8183a047>] ? start_kernel+0x352/0x35b
[36759.355364]  [<ffffffff8183959a>] ? x86_64_start_reservations+0x125/0x129
[36759.355372]  [<ffffffff81839698>] ? x86_64_start_kernel+0xfa/0x109

Same oops' as with -rc4 it seems..  It does not hard lock anything -
this is not during any suspend/resume..  This laptop is always on..

[36894.090466] iwlagn 0000:04:00.0: Failed to allocate SKB buffer with
GFP_ATOMIC. Only 0 free buffers remaining.

-Greg
