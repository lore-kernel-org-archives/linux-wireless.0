Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:43504 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaKPUxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 15:53:14 -0500
Date: Sun, 16 Nov 2014 22:53:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, nbd@nbd.name, ikstream86@gmail.com
Subject: Re: [PATCH v2 2/2] mac80211: improve minstrel_ht rate sorting by
 throughput & probability
Message-ID: <20141116205309.GA22596@w1.fi> (sfid-20141116_215318_371406_9F70D557)
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 09, 2014 at 11:22:14PM +0200, Thomas Huehn wrote:
> This patch improves the way minstrel_ht sorts rates according to throughput
> and success probability. 3 FOR-loops across the entire rate and mcs group set
> in function minstrel_ht_update_stats() which where used to determine the
> fastest, second fastest and most robust rate are reduced to 2 FOR-loop.
> 
> The sorted list of rates according throughput is extended to the best four
> rates as we need them in upcoming joint rate and power control. The sorting
> is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
> of those 4 best throughput rates in the debugfs file rc-stats is changes to:
> "A,B,C,D", where A is the fastest rate and C the 4th fastest.

I'm not sure whether this was triggered by this specific commit or a
more recent rc80211_minstrel_ht.c change, but I'm seeing relatively
frequent kernel panic in mac80211_hwsim test cases in that
minstrel_ht_sort_best_tp_rates() function that was added here. Any idea
what could be causing this? Details of the crash below:

> +static void
> +minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
> +			       u8 *tp_list)
> +{
> +	int cur_group, cur_idx, cur_thr, cur_prob;
> +	int tmp_group, tmp_idx, tmp_thr, tmp_prob;
> +	int j = MAX_THR_RATES;
> +
> +	cur_group = index / MCS_GROUP_RATES;
> +	cur_idx = index  % MCS_GROUP_RATES;
> +	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
> +	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
> +
> +	tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
> +	tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
> +	tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
> +	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
> +
> +	while (j > 0 && (cur_thr > tmp_thr ||
> +	      (cur_thr == tmp_thr && cur_prob > tmp_prob))) {
> +		j--;
> +		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
> +		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
> +		tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;

This tmp_thr assignment line is the one that the RIP
(minstrel_ht_sort_best_tp_rates+0xfe/0x160) resolves to.

That's net/mac80211/rc80211_minstrel_ht.c:407 in the current
wireless-testing.git snapshot.

> +		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
> +	}
> +
> +	if (j < MAX_THR_RATES - 1) {
> +		memmove(&tp_list[j + 1], &tp_list[j], (sizeof(*tp_list) *
> +		       (MAX_THR_RATES - (j + 1))));
> +	}
> +	if (j < MAX_THR_RATES)
> +		tp_list[j] = index;
> +}


Kernel log looks like this:

[  231.605848] wlan1: authenticate with 02:00:00:00:03:00
[  231.606511] wlan1: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[  231.607293] wlan1: send auth to 02:00:00:00:03:00 (try 1/3)
[  231.609349] wlan1: authenticated
[  231.620137] wlan1: associate with 02:00:00:00:03:00 (try 1/3)
[  231.624999] wlan1: RX AssocResp from 02:00:00:00:03:00 (capab=0x411 status=0 aid=2)
[  231.626416] wlan1: associated
[  231.683007] BUG: unable to handle kernel paging request at ffff8800201019d0
[  231.684283] IP: [<ffffffff814c0dbe>] minstrel_ht_sort_best_tp_rates+0xfe/0x160
[  231.685261] PGD 282f067 PUD 2830067 PMD 0 
[  231.685854] Oops: 0000 [#1] PREEMPT SMP 
[  231.686434] CPU: 0 PID: 585 Comm: wpa_supplicant Not tainted 3.18.0-rc4-wl+ #358
[  231.687338] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  231.688413] task: ffff88001df02040 ti: ffff88001dd14000 task.ti: ffff88001dd14000
[  231.689213] RIP: 0010:[<ffffffff814c0dbe>]  [<ffffffff814c0dbe>] minstrel_ht_sort_best_tp_rates+0xfe/0x160
[  231.690432] RSP: 0018:ffff88001fc03d38  EFLAGS: 00010246
[  231.691102] RAX: ffff8800201019c8 RBX: 0000000000000006 RCX: 0000000000000118
[  231.692032] RDX: ffff88001fc03d90 RSI: 0000000000010000 RDI: ffff88001fd68000
[  231.692859] RBP: ffff88001fc03d48 R08: 0000000000001999 R09: 0000000000000000
[  231.692905] R10: ffff88001fc03d8c R11: 0000000000000cb2 R12: ffff88001fd681c8
[  231.692905] R13: 0000000000000006 R14: 0000000000000006 R15: ffff88001fd68198
[  231.692905] FS:  00007f336cdee740(0000) GS:ffff88001fc00000(0000) knlGS:0000000000000000
[  231.692905] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  231.692905] CR2: ffff8800201019d0 CR3: 000000001dcf9000 CR4: 00000000000006b0
[  231.692905] Stack:
[  231.692905]  ffff88001fd6804a ffff88001fd681c8 ffff88001fc03dd8 ffffffff814c16a8
[  231.692905]  ffff88001fc03d78 ffff88001e157e2c ffff88001fd68000 0006ff8800000001
[  231.692905]  0000000000000000 0000000000000006 ffff88001fc03e08 0000000000000000
[  231.692905] Call Trace:
[  231.692905]  <IRQ> 
[  231.692905]  [<ffffffff814c16a8>] minstrel_ht_update_stats.isra.7+0x208/0x5d0
[  231.692905]  [<ffffffff814c1f9c>] minstrel_ht_tx_status+0x52c/0x5e0
[  231.692905]  [<ffffffff81434b8b>] ieee80211_tx_status+0x99b/0x1450
[  231.692905]  [<ffffffff81434770>] ? ieee80211_tx_status+0x580/0x1450
[  231.692905]  [<ffffffff814e29a5>] ? _raw_spin_unlock_irqrestore+0x55/0x80
[  231.692905]  [<ffffffff81430d32>] ieee80211_tasklet_handler+0x62/0xe0
[  231.692905]  [<ffffffff8103f3d7>] tasklet_action+0xe7/0xf0
[  231.692905]  [<ffffffff8103e780>] __do_softirq+0x150/0x610
[  231.692905]  [<ffffffff812ea74a>] ? __dev_queue_xmit+0x2aa/0x8e0
[  231.692905]  [<ffffffff814e518c>] do_softirq_own_stack+0x1c/0x30
[  231.692905]  <EOI> 
[  231.692905]  [<ffffffff8103ed2d>] do_softirq+0x7d/0x90
[  231.692905]  [<ffffffff8103ee27>] __local_bh_enable_ip+0xe7/0xf0
[  231.692905]  [<ffffffff812ea773>] __dev_queue_xmit+0x2d3/0x8e0
[  231.692905]  [<ffffffff812ea4f0>] ? __dev_queue_xmit+0x50/0x8e0
[  231.692905]  [<ffffffff812eae00>] dev_queue_xmit+0x10/0x20
[  231.692905]  [<ffffffff813cdcba>] packet_sendmsg+0xdfa/0x10a0
[  231.692905]  [<ffffffff812cec59>] sock_sendmsg+0x69/0x90
[  231.692905]  [<ffffffff812ce8f5>] ? move_addr_to_kernel+0x45/0x70
[  231.692905]  [<ffffffff812d02e2>] SyS_sendto+0x112/0x150
[  231.692905]  [<ffffffff814e3755>] ? sysret_check+0x22/0x5d
[  231.692905]  [<ffffffff81080de5>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  231.692905]  [<ffffffff811e7eab>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  231.692905]  [<ffffffff814e3729>] system_call_fastpath+0x12/0x17
[  231.692905] Code: 00 01 c0 29 c1 0f b7 c9 48 8d 04 cd 00 00 00 00 48 c1 e1 06 48 29 c1 4b 8d 04 c0 48 c1 e0 06 48 01 c8 41 83 e9 01 48 8d 44 07 70 <8b> 48 08 8b 40 10 75 9d bf 02 00 00 00 31 f6 b8 06 00 00 00 4c 
[  231.692905] RIP  [<ffffffff814c0dbe>] minstrel_ht_sort_best_tp_rates+0xfe/0x160
[  231.692905]  RSP <ffff88001fc03d38>
[  231.692905] CR2: ffff8800201019d0
[  231.692905] ---[ end trace ab3554bcb77c14a7 ]---
[  231.692905] Kernel panic - not syncing: Fatal exception in interrupt

-- 
Jouni Malinen                                            PGP id EFC895FA
