Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51691 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYJASyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 14:54:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 11:54:50 -0700
Date: Wed, 1 Oct 2008 04:54:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20081001115435.GD6126@tesla> (sfid-20081001_205455_016987_3972F2D5)
References: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com> <1ba2fa240809301318p16bedbdr31fdaea97c3cf3be@mail.gmail.com> <20080930152524.GA8131@tesla> <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 05:07:49PM -0700, Tomas Winkler wrote:
> On Tue, Sep 30, 2008 at 6:25 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > A quick test indicates it works but the removal is still an issue.
> 
> I didn't implement it yet I just wanted a feedback if I'm in correct
> direction with the starting part.
> 
> We also
> > have to make lockdep happy -- one more complaint (even with your v3
> > patch).
> 
> Strange I haven't seen one, can you post the log.

We just need to add some lockdep annotation magic. Here is the log:

[72633.463960] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[72633.463982] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[72633.464543] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[72633.464591] iwlagn 0000:03:00.0: setting latency timer to 64
[72633.464718] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[72633.513220] iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
[72633.515932] iwlagn 0000:03:00.0: PCI INT A disabled
[72633.523422] phy0: Selected rate control algorithm 'iwl-agn-rs'
[72648.265149] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[72648.265427] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x40100102, writing 0x40100106)
[72648.266169] firmware: requesting iwlwifi-4965-2.ucode
[72648.844843] Registered led device: iwl-phy0:radio
[72648.845033] Registered led device: iwl-phy0:assoc
[72648.845175] Registered led device: iwl-phy0:RX
[72648.845308] Registered led device: iwl-phy0:TX
[72648.880229] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[72650.067296] wlan0: authenticate with AP 00:03:7f:0c:e0:bc
[72650.080688] wlan0: authenticated
[72650.080710] wlan0: associate with AP 00:03:7f:0c:e0:bc
[72650.090999] wlan0: RX AssocResp from 00:03:7f:0c:e0:bc (capab=0x21 status=0 aid=1)
[72650.091014] wlan0: associated
[72650.091557] wlan0 (WE) : Wireless Event too big (366)
[72650.111655] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[72660.740126] wlan0: no IPv6 routers present
[72683.897238] Rx A-MPDU request on tid 0 result 0

At this point an iperf session starts and then:

[72706.524807] INFO: trying to register non-static key.
[72706.524951] the code is fine but needs lockdep annotation.
[72706.525085] turning off the locking correctness validator.
[72706.525217] Pid: 0, comm: swapper Not tainted 2.6.27-rc7 #4
[72706.525346]  [<c037b35b>] ? printk+0x1d/0x22
[72706.525672]  [<c0156847>] register_lock_class+0x387/0x3c0
[72706.525894]  [<c01593d1>] __lock_acquire+0x171/0xf90
[72706.526118]  [<c015a279>] lock_acquire+0x89/0xc0
[72706.526337]  [<f92c732a>] ? ieee80211_start_tx_ba_session+0x8a/0x120 [mac80211]
[72706.526697]  [<c037e82d>] _spin_lock_bh+0x3d/0x50
[72706.526921]  [<f92c732a>] ? ieee80211_start_tx_ba_session+0x8a/0x120 [mac80211]
[72706.527271]  [<f92c732a>] ieee80211_start_tx_ba_session+0x8a/0x120 [mac80211]
[72706.527534]  [<f92c72a0>] ? ieee80211_start_tx_ba_session+0x0/0x120 [mac80211]
[72706.527890]  [<f8f43ae8>] rs_tl_turn_on_agg_for_tid+0x138/0x140 [iwlagn]
[72706.528128]  [<f8f433fa>] ? rs_switch_to_siso+0x9a/0xd0 [iwlagn]
[72706.528448]  [<f8f44a19>] rs_tx_status+0xf29/0x1870 [iwlagn]
[72706.528679]  [<f8f43b82>] ? rs_tx_status+0x92/0x1870 [iwlagn]
[72706.528691]  [<c0336c3e>] ? __udp4_lib_rcv+0x5ae/0x8d0
[72706.528691]  [<c0159504>] ? __lock_acquire+0x2a4/0xf90
[72706.528691]  [<c0159504>] ? __lock_acquire+0x2a4/0xf90
[72706.528691]  [<c0159504>] ? __lock_acquire+0x2a4/0xf90
[72706.528691]  [<c0159504>] ? __lock_acquire+0x2a4/0xf90
[72706.528691]  [<c025a491>] ? _raw_spin_lock+0x41/0x120
[72706.528691]  [<c0158fcb>] ? trace_hardirqs_on+0xb/0x10
[72706.528691]  [<f92c8270>] ? ieee80211_tx_status+0x0/0x4c0 [mac80211]
[72706.528691]  [<f92c832b>] ieee80211_tx_status+0xbb/0x4c0 [mac80211]
[72706.528691]  [<f92c8270>] ? ieee80211_tx_status+0x0/0x4c0 [mac80211]
[72706.528691]  [<f92c8840>] ieee80211_tasklet_handler+0x110/0x120 [mac80211]
[72706.528691]  [<c02e9446>] ? __kfree_skb+0x36/0x90
[72706.528691]  [<c0158fcb>] ? trace_hardirqs_on+0xb/0x10
[72706.528691]  [<c0158ed6>] ? trace_hardirqs_on_caller+0x86/0x170
[72706.528691]  [<c0137f3d>] tasklet_action+0x7d/0x110
[72706.528691]  [<c013834a>] __do_softirq+0x9a/0x130
[72706.528691]  [<c013846d>] do_softirq+0x8d/0xa0
[72706.528691]  [<c0138605>] irq_exit+0x65/0xa0
[72706.528691]  [<c0106d9a>] do_IRQ+0x4a/0x80
[72706.528691]  [<c0105058>] common_interrupt+0x28/0x30
[72706.528691]  [<c015007b>] ? update_wall_time+0x24b/0x890
[72706.528691]  [<f8844384>] ? acpi_idle_enter_bm+0x25d/0x2ac [processor]
[72706.528691]  [<c02da43b>] cpuidle_idle_call+0x7b/0xd0
[72706.528691]  [<c0102892>] cpu_idle+0x82/0x140
[72706.528691]  [<c036d1e3>] rest_init+0x53/0x60
[72706.528691]  =======================
[72706.528691] Open BA session requested for 00:03:7f:0c:e0:bc tid 0
[72706.528691] allocated aggregation queue 4 tid 0 addr 00:03:7f:0c:e0:bc pool=0x10
[72706.528691] iwlagn: iwl_tx_agg_start on ra = 00:03:7f:0c:e0:bc tid = 0
[72706.528691] activated addBA response timer on tid 0
[72706.547217] switched off addBA timer for tid 0 
[72707.397444] Aggregation is on for tid 0 

  Luis
