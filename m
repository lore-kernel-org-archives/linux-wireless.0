Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59632 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798AbZCWPId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 11:08:33 -0400
Received: by fxm2 with SMTP id 2so1841567fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 08:08:29 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org, mb@bu3sch.de
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
References: <20090322174515.22f11d92@home.aephome.ru>
	<1237726612.19647.2.camel@johannes.local>
	<b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 23 Mar 2009 17:08:25 +0200
In-Reply-To: <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com> (Bob Copeland's message of "Sun\, 22 Mar 2009 10\:49\:50 -0400")
Message-ID: <87iqm0s2dy.fsf@litku.valot.fi> (sfid-20090323_160849_328781_0D317FFE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Hmm, I've seen the rate_control one before, and there's a guy
> with ath5k who can reproduce it easily.  Looks like minstrel
> somehow gets confused about the rate table and eventually tries
> to use -1 as a valid rate index.  Neither I nor Felix could come
> up with a logical explanation, though (I am completely lost in
> the RC code, so that's not saying much for me).
>
> He is using ad-hoc too - but I use adhoc on a daily basis and
> haven't seen it myself.

Today I saw something similar with stlc45xx and wireless-testing:

[11723.959442] kernel BUG at net/mac80211/rate.c:239!

And the BUG_ON() is this:

	/*
	 * try to enforce the maximum rate the user wanted
	 */
	if (sdata->max_ratectrl_rateidx > -1)
		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
				continue;
			info->control.rates[i].idx =
				min_t(s8, info->control.rates[i].idx,
				      sdata->max_ratectrl_rateidx);
	}

	BUG_ON(info->control.rates[0].idx < 0);
}

My AP was hostapd+b43 with latest wireless-testing running on a
laptop, naturally in infrastructure more. stlc45xx was connected to
the AP and I was pinging the AP. stlc45xx was running on Nokia N800
with 2.6.29-rc8-omap1-wl (recent linux-omap with latest
wireless-testing on top of that).

I was adding short preamble support for transmitted frames to
stlc45xx. so I might have done something stupid. I have seen this only
once, but I will report if I see it again.

Here are the logs:

[11376.462982] cfg80211: Using static regulatory domain info
[11376.468566] cfg80211: Regulatory domain: US
[11376.472778] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[11376.480102] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[11376.486968] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[11376.493865] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[11376.500732] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[11376.507598] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[11376.514465] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[11376.545074] cfg80211: Calling CRDA for country: US
[11376.906433] stlc45xx: v0.1.3 loaded
[11376.909973] stlc45xx: config buffer 0x20200-0x2060b
[11376.915008] stlc45xx: tx 0x2060c-0x23917, rx 0x23918-0x27c5f
[11377.074737] cx3110x spi2.0: firmware: requesting 3826.arm
[11570.356506] ------------[ cut here ]------------
[11570.361175] WARNING: at net/mac80211/tx.c:611 invoke_tx_handlers+0x714/0xdfc [mac80211]()
[11570.369506] Modules linked in: stlc45xx mac80211 cfg80211 [last unloaded: cfg80211]
[11570.377319] [<c002f14c>] (dump_stack+0x0/0x14) from [<c004f164>] (warn_slowpath+0x70/0x8c)
[11570.385742] [<c004f0f4>] (warn_slowpath+0x0/0x8c) from [<bf135d44>] (invoke_tx_handlers+0x714/0xdfc [mac80211])
[11570.396240]  r3:0000000c r2:00000000
[11570.399871]  r7:bf143f40 r6:c38c1ac4 r5:00000000 r4:c38d2404
[11570.405639] [<bf135630>] (invoke_tx_handlers+0x0/0xdfc [mac80211]) from [<bf137748>] (ieee80211_master_start_xmit+0x378/0x4c0 [mac80211])
[11570.418579] [<bf1373d0>] (ieee80211_master_start_xmit+0x0/0x4c0 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11570.430389] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11570.439605] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11570.448425] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<bf1371ac>] (ieee80211_subif_start_xmit+0x470/0x4f4 [mac80211])
[11570.459747]  r7:0000001c r6:c38d23e0 r5:0000000c r4:00000006
[11570.465515] [<bf136d3c>] (ieee80211_subif_start_xmit+0x0/0x4f4 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11570.477233] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11570.486450] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11570.495269] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<c021f164>] (ip_finish_output+0x22c/0x280)
[11570.504577]  r7:00000000 r6:0000000e r5:c7a30560 r4:c38d23e0
[11570.510345] [<c021ef38>] (ip_finish_output+0x0/0x280) from [<c021f508>] (ip_output+0xb0/0xc4)
[11570.518981]  r7:00000040 r6:c79cc040 r5:c38d23e0 r4:c38d23e0
[11570.524749] [<c021f458>] (ip_output+0x0/0xc4) from [<c021ebb0>] (ip_local_out+0x2c/0x30)
[11570.532989]  r4:c38d23e0
[11570.535552] [<c021eb84>] (ip_local_out+0x0/0x30) from [<c021eeb8>] (ip_push_pending_frames+0x304/0x384)
[11570.545104]  r5:c38d23e0 r4:c38e0880
[11570.548736] [<c021ebb4>] (ip_push_pending_frames+0x0/0x384) from [<c02397ac>] (raw_sendmsg+0x694/0x740)
[11570.558288] [<c0239118>] (raw_sendmsg+0x0/0x740) from [<c0241b50>] (inet_sendmsg+0x5c/0x64)
[11570.566772] [<c0241af4>] (inet_sendmsg+0x0/0x64) from [<c01f28c8>] (sock_sendmsg+0xb0/0xd0)
[11570.575256]  r7:c38c1de0 r6:c38c1f54 r5:00000000 r4:00000000
[11570.581024] [<c01f2818>] (sock_sendmsg+0x0/0xd0) from [<c01f2bb0>] (sys_sendto+0xb4/0xd8)
[11570.589324]  r7:00000040 r6:c38c1ed4 r5:00000000 r4:c7564b60
[11570.595092] [<c01f2afc>] (sys_sendto+0x0/0xd8) from [<c002ad80>] (ret_fast_syscall+0x0/0x2c)
[11570.603668] ---[ end trace 322ca1d491750370 ]---
[11570.608551] ------------[ cut here ]------------
[11570.613189] WARNING: at net/mac80211/tx.c:57 ieee80211_duration+0x60/0x1f4 [mac80211]()
[11570.621307] Modules linked in: stlc45xx mac80211 cfg80211 [last unloaded: cfg80211]
[11570.629089] [<c002f14c>] (dump_stack+0x0/0x14) from [<c004f164>] (warn_slowpath+0x70/0x8c)
[11570.637512] [<c004f0f4>] (warn_slowpath+0x0/0x8c) from [<bf13549c>] (ieee80211_duration+0x60/0x1f4 [mac80211])
[11570.647857]  r3:00000000 r2:00000000
[11570.651489]  r7:c38c1ac4 r6:c38c1ac4 r5:bf143f40 r4:00000000
[11570.657257] [<bf13543c>] (ieee80211_duration+0x0/0x1f4 [mac80211]) from [<bf13624c>] (invoke_tx_handlers+0xc1c/0xdfc [mac80211])
[11570.669342] [<bf135630>] (invoke_tx_handlers+0x0/0xdfc [mac80211]) from [<bf137748>] (ieee80211_master_start_xmit+0x378/0x4c0 [mac80211])
[11570.682159] [<bf1373d0>] (ieee80211_master_start_xmit+0x0/0x4c0 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11570.694000] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11570.703186] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11570.712036] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<bf1371ac>] (ieee80211_subif_start_xmit+0x470/0x4f4 [mac80211])
[11570.723358]  r7:0000001c r6:c38d23e0 r5:0000000c r4:00000006
[11570.729095] [<bf136d3c>] (ieee80211_subif_start_xmit+0x0/0x4f4 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11570.740844] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11570.750030] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11570.758850] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<c021f164>] (ip_finish_output+0x22c/0x280)
[11570.768127]  r7:00000000 r6:0000000e r5:c7a30560 r4:c38d23e0
[11570.773895] [<c021ef38>] (ip_finish_output+0x0/0x280) from [<c021f508>] (ip_output+0xb0/0xc4)
[11570.782562]  r7:00000040 r6:c79cc040 r5:c38d23e0 r4:c38d23e0
[11570.788330] [<c021f458>] (ip_output+0x0/0xc4) from [<c021ebb0>] (ip_local_out+0x2c/0x30)
[11570.796569]  r4:c38d23e0
[11570.799133] [<c021eb84>] (ip_local_out+0x0/0x30) from [<c021eeb8>] (ip_push_pending_frames+0x304/0x384)
[11570.808654]  r5:c38d23e0 r4:c38e0880
[11570.812316] [<c021ebb4>] (ip_push_pending_frames+0x0/0x384) from [<c02397ac>] (raw_sendmsg+0x694/0x740)
[11570.821868] [<c0239118>] (raw_sendmsg+0x0/0x740) from [<c0241b50>] (inet_sendmsg+0x5c/0x64)
[11570.830352] [<c0241af4>] (inet_sendmsg+0x0/0x64) from [<c01f28c8>] (sock_sendmsg+0xb0/0xd0)
[11570.838836]  r7:c38c1de0 r6:c38c1f54 r5:00000000 r4:00000000
[11570.844604] [<c01f2818>] (sock_sendmsg+0x0/0xd0) from [<c01f2bb0>] (sys_sendto+0xb4/0xd8)
[11570.852905]  r7:00000040 r6:c38c1ed4 r5:00000000 r4:c7564b60
[11570.858673] [<c01f2afc>] (sys_sendto+0x0/0xd8) from [<c002ad80>] (ret_fast_syscall+0x0/0x2c)
[11570.867248] ---[ end trace 322ca1d491750371 ]---
[11723.959442] kernel BUG at net/mac80211/rate.c:239!
[11723.964294] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[11723.972534] pgd = c38e4000
[11723.975311] [00000000] *pgd=870c7031, *pte=00000000, *ppte=00000000
[11723.981689] Internal error: Oops: 817 [#1]
[11723.985809] Modules linked in: stlc45xx mac80211 cfg80211 [last unloaded: cfg80211]
[11723.993591] CPU: 0    Tainted: G        W   (2.6.29-rc8-omap1-wl #115)
[11724.000183] PC is at __bug+0x20/0x2c
[11724.003814] LR is at release_console_sem+0x190/0x1a8
[11724.008819] pc : [<c002eba0>]    lr : [<c004f920>]    psr: 20000013
[11724.008850] sp : c38c1a08  ip : c38c1940  fp : c38c1a14
[11724.020416] r10: c38ebb60  r9 : 00000000  r8 : c7f3b9a0
[11724.025665] r7 : c38c1a70  r6 : c38ebb60  r5 : c38c3564  r4 : c38c3564
[11724.032257] r3 : 00000000  r2 : 00000001  r1 : 00007830  r0 : 00000039
[11724.038818] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[11724.046020] Control: 00c5387d  Table: 838e4000  DAC: 00000015
[11724.051818] Process ping (pid: 1842, stack limit = 0xc38c0260)
[11724.057708] Stack: (0xc38c1a08 to 0xc38c2000)
[11724.062072] 1a00:                   c38c1a3c c38c1a18 bf12ed7c c002eb8c c38c3564 00000930 
[11724.070495] 1a20: c38c1ac4 c3822060 bf14e684 00000000 c38c1ab4 c38c1a40 bf135bd8 bf12ec90 
[11724.078887] 1a40: c38c3540 00000001 c38c1a6c c38c1a58 bf1257ec c012a41c c3822060 c38c1ac4 
[11724.087310] 1a60: c38c1ab4 c38c1a70 bf135318 bf1383cc c38e11a0 bf14e684 c38ebda0 c38c3540 
[11724.095703] 1a80: 000000ff 0000ff01 c38c1ab4 c38c1ac4 c38e11a0 c38c3540 c38e11a0 00000000 
[11724.104125] 1aa0: c38eb800 c38ebb60 c38c1b1c c38c1ab8 bf137748 bf13563c c38c3564 c38c3564 
[11724.112518] 1ac0: c38d20e0 c38c3540 c38eb800 c38e11a0 c38ebb60 c7f3b800 00000000 bf14e794 
[11724.120941] 1ae0: 00000000 00000000 00000800 00000002 c7ac60a0 c7ac60a0 c38c3540 c38c3540 
[11724.129333] 1b00: c38fa000 bf13a9d4 00164df4 c70c6bc0 c38c1b4c c38c1b20 c01ffdbc bf1373dc 
[11724.137756] 1b20: c70c6bc0 c38d20e0 c7ac60a0 c70c6bc0 c38c3540 c38c3540 c38fa000 c38c0000 
[11724.146179] 1b40: c38c1b7c c38c1b50 c020e99c c01ffbe8 00000001 c7ac60a0 c70c6bc0 c38c3540 
[11724.154571] 1b60: 00000000 00000008 c38eb800 c38c1bba c38c1b9c c38c1b80 c0202bac c020e8cc 
[11724.162994] 1b80: 00000006 0000000c c38c3540 0000001c c38c1c04 c38c1ba0 bf1371ac c0202890 
[11724.171386] 1ba0: c38eb800 c38e0880 c38e0894 c38e11a0 00000018 00000108 01080001 11000000 
[11724.179809] 1bc0: 42c2f450 c0ee0200 1100eeff 42c2f450 c38e0000 00000003 c00582ac c38bcec0 
[11724.188201] 1be0: c38c3540 c38c3540 c38eb800 bf13ab38 00164df4 c7e9cac0 c38c1c34 c38c1c08 
[11724.196624] 1c00: c01ffdbc bf136d48 c38c1c2c c38c1c18 c38bcec0 c7e9cac0 c38c3540 c38c3540 
[11724.205017] 1c20: c38eb800 c38c0000 c38c1c64 c38c1c38 c020e99c c01ffbe8 00000001 c38bcec0 
[11724.213439] 1c40: c7e9cac0 c38c3540 00000000 c7fb3a80 00000000 00000040 c38c1c84 c38c1c68 
[11724.221832] 1c60: c0202bac c020e8cc c38c3540 c7a30560 0000000e 00000000 c38c1ca4 c38c1c88 
[11724.230255] 1c80: c021f164 c0202890 c38c3540 c38c3540 c79cc040 00000040 c38c1ccc c38c1ca8 
[11724.238647] 1ca0: c021f508 c021ef44 c021eb74 c02136d0 c38eb800 c021d7cc 80000000 c38c3540 
[11724.247070] 1cc0: c38c1ce4 c38c1cd0 c021ebb0 c021f464 c38e0880 c38c3540 c38c1d14 c38c1ce8 
[11724.255462] 1ce0: c021eeb8 c021eb90 00000000 00000000 00000000 c38c1f54 c79cc040 010ba8c0 
[11724.263885] 1d00: 00000000 00000000 c38c1dbc c38c1d18 c02397ac c021ebc0 00000000 c38c1d7c 
[11724.272277] 1d20: c38c1d8c 00000000 c38c1f54 c79cc040 00000040 00000001 00000000 00000000 
[11724.280670] 1d40: 00000000 00000000 00000000 010ba8c0 020ba8c0 00000000 00000000 00000000 
[11724.289093] 1d60: 00000000 00000000 00000000 00000000 00000001 00000008 00000000 010ba8c0 
[11724.297485] 1d80: 00000000 00000000 c38c0000 00000000 c38c1dcc c79cc040 c38c1de0 00000040 
[11724.305908] 1da0: c38c1f54 00049fb4 c38c0000 00000010 c38c1ddc c38c1dc0 c0241b50 c0239124 
[11724.314300] 1dc0: 00000000 00000000 c38c1f54 c38c1de0 c38c1ecc c38c1de0 c01f28c8 c0241b00 
[11724.322692] 1de0: c7abda18 c38c1ed0 00000000 00000001 ffffffff 00000000 00000000 00000000 
[11724.331115] 1e00: 00000000 00000000 c72d56a0 c38c1e18 00000000 00000000 c005af4c c72d56a0 
[11724.339508] 1e20: c00630dc c38c1e24 c38c1e24 c38c1e38 c005b174 c005af38 c38c1e70 c38c1e48 
[11724.347930] 1e40: 00000000 c38c1ed0 c72d56a0 0000000a c38c1e74 c38c1e60 c0145cb0 c002af28 
[11724.356323] 1e60: bedfc4cc c38c1fb0 c38c1ed0 c38c0000 c713b740 c38c1f50 c38c1ebc 00000040 
[11724.364746] 1e80: c7564b60 00000124 00000000 c38c1f54 00000008 00000000 c38c1ebc 00000000 
[11724.373138] 1ea0: c38c1ed4 00000040 00049fb4 c38c1ed4 c7564b60 00000000 c38c1ed4 00000040 
[11724.381561] 1ec0: c38c1fa4 c38c1ed0 c01f2bb0 c01f2824 0000000e 00000002 010ba8c0 00000000 
[11724.389953] 1ee0: 00000000 00000000 00000000 00000002 c38c1f44 c38c1f00 c0147658 c014cb68 
[11724.398376] 1f00: c3870520 c01499dc c7fb5814 00000000 c38c1f5c c38c1f20 c00699c4 c0038c40 
[11724.406768] 1f20: ffffffff 00000000 00000037 00000000 c38c0000 c38c1f80 00000000 c38c1f80 
[11724.415161] 1f40: 0000004e c002af28 c38c0000 00000000 c38c1f7c c38c1ed4 00000010 c38c1f70 
[11724.423583] 1f60: 00000001 00000000 00000000 00000000 bedfc060 00000040 00000000 00000000 
[11724.431976] 1f80: 00049fb4 00000010 bedfc060 00000122 c002af28 00000000 00000000 c38c1fa8 
[11724.440399] 1fa0: c002ad80 c01f2b08 00049fb4 00000010 00000003 bedfc060 00000040 00000000 
[11724.448791] 1fc0: 00049fb4 00000010 bedfc060 00000122 00000000 00000000 40172000 00000000 
[11724.457183] 1fe0: bedfc0bc bedfc040 00020edd 4011a728 40000010 00000003 00000004 00130001 
[11724.465606] Backtrace: 
[11724.468078] [<c002eb80>] (__bug+0x0/0x2c) from [<bf12ed7c>] (rate_control_get_rate+0xf8/0xfc [mac80211])
[11724.477935] [<bf12ec84>] (rate_control_get_rate+0x0/0xfc [mac80211]) from [<bf135bd8>] (invoke_tx_handlers+0x5a8/0xdfc [mac80211])
[11724.490112]  r9:00000000 r8:bf14e684 r7:c3822060 r6:c38c1ac4 r5:00000930
[11724.496734] r4:c38c3564
[11724.499389] [<bf135630>] (invoke_tx_handlers+0x0/0xdfc [mac80211]) from [<bf137748>] (ieee80211_master_start_xmit+0x378/0x4c0 [mac80211])
[11724.512176] [<bf1373d0>] (ieee80211_master_start_xmit+0x0/0x4c0 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11724.523956] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11724.533111] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11724.541931] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<bf1371ac>] (ieee80211_subif_start_xmit+0x470/0x4f4 [mac80211])
[11724.553192]  r7:0000001c r6:c38c3540 r5:0000000c r4:00000006
[11724.558929] [<bf136d3c>] (ieee80211_subif_start_xmit+0x0/0x4f4 [mac80211]) from [<c01ffdbc>] (dev_hard_start_xmit+0x1e0/0x270)
[11724.570617] [<c01ffbdc>] (dev_hard_start_xmit+0x0/0x270) from [<c020e99c>] (__qdisc_run+0xdc/0x208)
[11724.579772] [<c020e8c0>] (__qdisc_run+0x0/0x208) from [<c0202bac>] (dev_queue_xmit+0x328/0x440)
[11724.588592] [<c0202884>] (dev_queue_xmit+0x0/0x440) from [<c021f164>] (ip_finish_output+0x22c/0x280)
[11724.597869]  r7:00000000 r6:0000000e r5:c7a30560 r4:c38c3540
[11724.603607] [<c021ef38>] (ip_finish_output+0x0/0x280) from [<c021f508>] (ip_output+0xb0/0xc4)
[11724.612243]  r7:00000040 r6:c79cc040 r5:c38c3540 r4:c38c3540
[11724.617980] [<c021f458>] (ip_output+0x0/0xc4) from [<c021ebb0>] (ip_local_out+0x2c/0x30)
[11724.626190]  r4:c38c3540
[11724.628753] [<c021eb84>] (ip_local_out+0x0/0x30) from [<c021eeb8>] (ip_push_pending_frames+0x304/0x384)
[11724.638275]  r5:c38c3540 r4:c38e0880
[11724.641876] [<c021ebb4>] (ip_push_pending_frames+0x0/0x384) from [<c02397ac>] (raw_sendmsg+0x694/0x740)
[11724.651397] [<c0239118>] (raw_sendmsg+0x0/0x740) from [<c0241b50>] (inet_sendmsg+0x5c/0x64)
[11724.659881] [<c0241af4>] (inet_sendmsg+0x0/0x64) from [<c01f28c8>] (sock_sendmsg+0xb0/0xd0)
[11724.668334]  r7:c38c1de0 r6:c38c1f54 r5:00000000 r4:00000000
[11724.674072] [<c01f2818>] (sock_sendmsg+0x0/0xd0) from [<c01f2bb0>] (sys_sendto+0xb4/0xd8)
[11724.682342]  r7:00000040 r6:c38c1ed4 r5:00000000 r4:c7564b60
[11724.688110] [<c01f2afc>] (sys_sendto+0x0/0xd8) from [<c002ad80>] (ret_fast_syscall+0x0/0x2c)
[11724.696655] Code: e1a01000 e59f000c eb0084c2 e3a03000 (e5833000) 
[11724.703002] Kernel panic - not syncing: Fatal exception in interrupt


-- 
Kalle Valo
