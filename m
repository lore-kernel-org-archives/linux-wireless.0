Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from danu.mythicnet.org ([69.36.14.47]:34205 "EHLO
	danu.mythicnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1APTyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 14:54:44 -0500
Received: from localhost (localhost [127.0.0.1])
	by danu.mythicnet.org (Postfix) with SMTP id 4BC9C7834F
	for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 14:54:43 -0500 (EST)
Received: from [10.1.42.223] (cpe-184-57-88-200.columbus.res.rr.com [184.57.88.200])
	by danu.mythicnet.org (Postfix) with ESMTPSA id ECCFC78327
	for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 14:54:42 -0500 (EST)
Message-ID: <4D334D00.4030604@mythicnet.org>
Date: Sun, 16 Jan 2011 14:54:40 -0500
From: Ilya Kogan <ikogan@mythicnet.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Kernel Panic on Associate with brcm80211.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

     I've solved my issue regarding not being able to get the card to 
scan (apparently there was a conflict with acer_wmi). Now that I can get 
it to come up, I've discovered the following panic on associate:

[   80.856072] wlan0: authenticated
[   80.856175] wlan0: associate with 00:23:69:56:27:b1 (try 1)
[   80.859729] wlan0: RX AssocResp from 00:23:69:56:27:b1 (capab=0x411 
status=0 aid=2)
[   80.859803] wlan0: associated
[   80.859877] ieee80211 phy0: Allocated STA 00:23:69:56:27:b1
[   80.860489] ieee80211 phy0: Inserted STA 00:23:69:56:27:b1
[   80.860586] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 
cWmax=1023 txop=0 uapsd=0
[   80.860750] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 
cWmax=1023 txop=0 uapsd=0
[   80.860915] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 
cWmax=15 txop=94 uapsd=0
[   80.861080] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 
cWmax=7 txop=47 uapsd=0
[   80.861245] Associated:      True
[   80.861693] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   80.866030] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 
159/256 dur 1778/1504
[   80.875589] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 
137/256 dur 1602/1504
[   80.956792] Intel AES-NI instructions are not detected.
[   81.022228] padlock: VIA PadLock not detected.
[   81.103155] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 
382/256 dur 3562/1504
[   81.440181] Kernel panic - not syncing: <3>assertion "!(sdu->cloned)" 
failed: file "wlc_mac80211.c", line 5129
[   81.440185]
[   81.440352] Pid: 0, comm: swapper Tainted: P            
2.6.35-25-debug #43
[   81.440409] Call Trace:
[   81.440460] <IRQ>  [<ffffffff815ad3c7>] panic+0x90/0x118
[   81.440586]  [<ffffffffa06fb876>] osl_assert+0xb6/0x170 [brcm80211]
[   81.440665]  [<ffffffffa074a238>] ? dma64_txfast+0xd8/0x3e0 [brcm80211]
[   81.440740]  [<ffffffffa0707833>] ? wlc_txfifo+0xb3/0x180 [brcm80211]
[   81.440815]  [<ffffffffa0707997>] ? wlc_send_q+0x97/0x230 [brcm80211]
[   81.440889]  [<ffffffffa070364f>] ? wlc_prec_enq_head+0xdf/0x260 
[brcm80211]
[   81.440964]  [<ffffffffa070be00>] wlc_sendpkt_mac80211+0x1720/0x2830 
[brcm80211]
[   81.441043]  [<ffffffffa07037e1>] ? wlc_prec_enq+0x11/0x20 [brcm80211]
[   81.441117]  [<ffffffffa070bb0f>] ? 
wlc_sendpkt_mac80211+0x142f/0x2830 [brcm80211]
[   81.441193]  [<ffffffffa070fbcc>] ? wl_ops_tx+0x2c/0xa0 [brcm80211]
[   81.441252]  [<ffffffff812dd1e4>] ? do_raw_spin_lock+0x54/0x150
[   81.441327]  [<ffffffffa070fbee>] wl_ops_tx+0x4e/0xa0 [brcm80211]
[   81.441404]  [<ffffffffa06a15e7>] __ieee80211_tx+0x147/0x230 [mac80211]
[   81.441479]  [<ffffffffa06a0f56>] ? 
ieee80211_tx_h_calculate_duration+0x56/0x80 [mac80211]
[   81.441559]  [<ffffffffa06a2d9e>] ieee80211_tx+0xfe/0x2e0 [mac80211]
[   81.441632]  [<ffffffffa06a2cde>] ? ieee80211_tx+0x3e/0x2e0 [mac80211]
[   81.441707]  [<ffffffffa06a3062>] ieee80211_xmit+0xe2/0x240 [mac80211]
[   81.441781]  [<ffffffffa06a2f80>] ? ieee80211_xmit+0x0/0x240 [mac80211]
[   81.441855]  [<ffffffffa06a389b>] ? 
ieee80211_subif_start_xmit+0x5bb/0x9d0 [mac80211]
[   81.441935]  [<ffffffffa06a368f>] 
ieee80211_subif_start_xmit+0x3af/0x9d0 [mac80211]
[   81.442013]  [<ffffffffa06a3827>] ? 
ieee80211_subif_start_xmit+0x547/0x9d0 [mac80211]
[   81.442076]  [<ffffffff814a7aae>] ? sock_def_write_space+0x9e/0xd0
[   81.442132]  [<ffffffff814a7a10>] ? sock_def_write_space+0x0/0xd0
[   81.442189]  [<ffffffff814b813a>] dev_hard_start_xmit+0x13a/0x2e0
[   81.442245]  [<ffffffff814d4626>] sch_direct_xmit+0xf6/0x260
[   81.442300]  [<ffffffff814ba7cd>] dev_queue_xmit+0x13d/0x680
[   81.442360]  [<ffffffff814ba6ea>] ? dev_queue_xmit+0x5a/0x680
[   81.442425]  [<ffffffff81098e3d>] ? trace_hardirqs_on+0xd/0x10
[   81.442482]  [<ffffffff8106a547>] ? local_bh_enable_ip+0x97/0xf0
[   81.442538]  [<ffffffff814c3400>] neigh_resolve_output+0x110/0x3e0
[   81.442595]  [<ffffffff8154ce97>] ip6_finish_output2+0x107/0x410
[   81.442651]  [<ffffffff8154e058>] ip6_finish_output+0x98/0x150
[   81.442707]  [<ffffffff8154e1a8>] ip6_output+0x98/0x1b0
[   81.442763]  [<ffffffff81562b03>] ndisc_send_skb+0x303/0x3c0
[   81.442819]  [<ffffffff815628b2>] ? ndisc_send_skb+0xb2/0x3c0
[   81.442875]  [<ffffffff81562c21>] __ndisc_send+0x61/0x80
[   81.442931]  [<ffffffff81553fb0>] ? addrconf_dad_timer+0x0/0x190
[   81.442989]  [<ffffffff81563442>] ndisc_send_ns+0x72/0xc0
[   81.443044]  [<ffffffff81553fb0>] ? addrconf_dad_timer+0x0/0x190
[   81.443099]  [<ffffffff81553fb0>] ? addrconf_dad_timer+0x0/0x190
[   81.443154]  [<ffffffff815540f0>] addrconf_dad_timer+0x140/0x190
[   81.443212]  [<ffffffff810725c4>] call_timer_fn+0x84/0x180
[   81.443267]  [<ffffffff81072540>] ? call_timer_fn+0x0/0x180
[   81.443323]  [<ffffffff81553fb0>] ? addrconf_dad_timer+0x0/0x190
[   81.443378]  [<ffffffff8107320c>] run_timer_softirq+0x14c/0x260
[   81.443435]  [<ffffffff8102b5fd>] ? lapic_next_event+0x1d/0x30
[   81.443491]  [<ffffffff81069c23>] __do_softirq+0xd3/0x220
[   81.443548]  [<ffffffff81087080>] ? hrtimer_interrupt+0x140/0x250
[   81.443605]  [<ffffffff8100c05c>] call_softirq+0x1c/0x30
[   81.443659]  [<ffffffff8100db9d>] do_softirq+0x9d/0xd0
[   81.443716]  [<ffffffff810697e5>] irq_exit+0x95/0xa0
[   81.443771]  [<ffffffff815b8970>] smp_apic_timer_interrupt+0x70/0x9b
[   81.443827]  [<ffffffff8100bb13>] apic_timer_interrupt+0x13/0x20
[   81.443880] <EOI>  [<ffffffff810141dd>] ? default_idle+0x3d/0xa0
[   81.443983]  [<ffffffff810371ab>] ? native_safe_halt+0xb/0x10
[   81.444041]  [<ffffffff81098e3d>] ? trace_hardirqs_on+0xd/0x10
[   81.444097]  [<ffffffff810141e2>] default_idle+0x42/0xa0
[   81.444152]  [<ffffffff810142da>] c1e_idle+0x9a/0x130
[   81.444208]  [<ffffffff81009da8>] cpu_idle+0xb8/0x110
[   81.444264]  [<ffffffff815964bf>] rest_init+0xcf/0xe0
[   81.444319]  [<ffffffff815963f0>] ? rest_init+0x0/0xe0
[   81.444375]  [<ffffffff81afdcbe>] start_kernel+0x3aa/0x3b3
[   81.444440]  [<ffffffff81afd341>] x86_64_start_reservations+0x12c/0x130
[   81.444504]  [<ffffffff81afd43f>] x86_64_start_kernel+0xfa/0x109

Kernel is: Linux Lulzer 2.6.35-25-debug #43 SMP Sat Jan 15 22:29:10 EST 
2011 x86_64 GNU/Linux
Card is: 06:00.0 Network controller [0280]: Broadcom Corporation 
BCM43225 802.11b/g/n [14e4:4357] (rev 01)
Module is: [   78.955414] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver 
(1.82.8.0) (Compiled at 01:50:33 on Jan 16 2011)

This is based on the latest compat-wireless git revision as of the 
module compile date.

Thanks,
-- Ilya Kogan

