Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:43206 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933486AbaKNQtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 11:49:09 -0500
Date: Fri, 14 Nov 2014 18:43:28 +0200
From: Jouni Malinen <j@w1.fi>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v6] mac80211: minstrel_ht: add basic support for VHT
 rates <= 3SS@80MHz
Message-ID: <20141114164328.GA30967@w1.fi> (sfid-20141114_174914_245344_1F47FED3)
References: <1413812762-6605-5-git-send-email-karl.beldan@gmail.com>
 <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 10:38:38AM +0200, Karl Beldan wrote:
> When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set (default 'N'),
> there is no behavioral change including in sampling and MCS_GROUP_RATES
> remains 8.
> Otherwise MCS_GROUP_RATES is 10, and a module parameter *vht_only*
> (default 'true'), restricts the rates selection to VHT when vht is
> supported.

Have you tested this with mac80211_hwsim? I'm seeing number of issues in
hwsim test cases with CONFIG_MAC80211_RC_MINSTREL_VHT=y with
wireless-testing.git. These disappear if I disable this build option.

For example, with nfc_p2p_go_neg test case:

[    7.023869] wlan1: authenticate with 02:00:00:00:00:00
[    7.024421] wlan1: Allocated STA 02:00:00:00:00:00
[    7.024426] wlan1: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded

(note: this part happens also with minstrel_ht VHT supported disabled,
but the issues below don't)

...

[    7.255983] wlan0: Allocated STA 02:00:00:00:01:00
[    7.255988] wlan0: moving STA 02:00:00:00:01:00 to state 2
[    7.255991] wlan0: moving STA 02:00:00:00:01:00 to state 3
[    7.256232] wlan0: Inserted STA 02:00:00:00:01:00
[    7.270176] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[    7.494771] ------------[ cut here ]------------
[    7.495194] WARNING: CPU: 1 PID: 584 at net/mac80211/rate.c:501 ieee80211_get_tx_rates+0x2c2/0x810()
[    7.495972] CPU: 1 PID: 584 Comm: wpa_supplicant Not tainted 3.18.0-rc4-wl #347
[    7.496607] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    7.497322]  0000000000000009 ffff88001e327798 ffffffff814d7f34 ffffffff81089c41
[    7.498010]  0000000000000000 ffff88001e3277d8 ffffffff8103ab6c 0000000000000246
[    7.498703]  ffff88001dcb7600 ffff88001dcb7630 0000000000000000 ffff88001dcb763c
[    7.499399] Call Trace:
[    7.499628]  [<ffffffff814d7f34>] dump_stack+0x4e/0x71
[    7.500108]  [<ffffffff81089c41>] ? console_unlock+0x1f1/0x4d0
[    7.500628]  [<ffffffff8103ab6c>] warn_slowpath_common+0x7c/0xa0
[    7.501184]  [<ffffffff8103ac7a>] warn_slowpath_null+0x1a/0x20
[    7.501702]  [<ffffffff814598e2>] ieee80211_get_tx_rates+0x2c2/0x810
[    7.502256]  [<ffffffff81459f0a>] rate_control_get_rate+0xda/0xf0
[    7.502790]  [<ffffffff8146f8f2>] ieee80211_tx_h_rate_ctrl+0x1a2/0x430
[    7.503368]  [<ffffffff8146fda8>] invoke_tx_handlers+0x108/0x180
[    7.503898]  [<ffffffff81470d15>] ieee80211_tx+0x75/0xf0
[    7.504370]  [<ffffffff81470ef1>] ieee80211_xmit+0xa1/0x100
[    7.504862]  [<ffffffff8147239a>] ieee80211_subif_start_xmit+0xf9a/0x1150
[    7.505494]  [<ffffffff81471442>] ?  ieee80211_subif_start_xmit+0x42/0x1150
[    7.506039]  [<ffffffff812e9ee1>] dev_hard_start_xmit+0x271/0x830
[    7.506394]  [<ffffffff812e9cc8>] ? dev_hard_start_xmit+0x58/0x830
[    7.506754]  [<ffffffff8130d822>] sch_direct_xmit+0xf2/0x1f0
[    7.507086]  [<ffffffff812ea704>] __dev_queue_xmit+0x264/0x8e0
[    7.507426]  [<ffffffff812ea4f0>] ? __dev_queue_xmit+0x50/0x8e0
[    7.507774]  [<ffffffff812eae00>] dev_queue_xmit+0x10/0x20
[    7.508110]  [<ffffffff813cdcba>] packet_sendmsg+0xdfa/0x10a0
[    7.508450]  [<ffffffff812cec59>] sock_sendmsg+0x69/0x90
[    7.508762]  [<ffffffff812ce8f5>] ? move_addr_to_kernel+0x45/0x70
[    7.509130]  [<ffffffff812d02e2>] SyS_sendto+0x112/0x150
[    7.509469]  [<ffffffff814e2995>] ? sysret_check+0x22/0x5d
[    7.509793]  [<ffffffff81080de5>] ?  trace_hardirqs_on_caller+0x105/0x1d0
[    7.510208]  [<ffffffff811e7eab>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    7.510587]  [<ffffffff814e2969>] system_call_fastpath+0x12/0x17
[    7.510941] ---[ end trace a7659d7a05f5ad35 ]---
[    7.511249] ------------[ cut here ]------------
[    7.511525] WARNING: CPU: 1 PID: 584 at net/mac80211/rx.c:3452 ieee80211_rx+0xb54/0xb60()
[    7.512001] Rate marked as a VHT rate but data is invalid: MCS: 11, NSS: 1
[    7.512542] CPU: 1 PID: 584 Comm: wpa_supplicant Tainted: G        W 3.18.0-rc4-wl #347
[    7.513210] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    7.513839]  0000000000000009 ffff88001fc83d98 ffffffff814d7f34 ffffffff81089c41
[    7.514463]  ffff88001fc83de8 ffff88001fc83dd8 ffffffff8103ab6c 0000000000000001
[    7.514926]  ffff88001dcb7d00 ffff88001e1f07c0 ffff88001e1f07c0 ffff88001e1f0ce0
[    7.515388] Call Trace:
[    7.515536]  <IRQ>  [<ffffffff814d7f34>] dump_stack+0x4e/0x71
[    7.515895]  [<ffffffff81089c41>] ? console_unlock+0x1f1/0x4d0
[    7.516242]  [<ffffffff8103ab6c>] warn_slowpath_common+0x7c/0xa0
[    7.516597]  [<ffffffff8103ac06>] warn_slowpath_fmt+0x46/0x50
[    7.516949]  [<ffffffff8146e404>] ieee80211_rx+0xb54/0xb60
[    7.517316]  [<ffffffff81080d92>] ?  trace_hardirqs_on_caller+0xb2/0x1d0
[    7.517710]  [<ffffffff81080ebd>] ? trace_hardirqs_on+0xd/0x10
[    7.518056]  [<ffffffff81430d94>] ieee80211_tasklet_handler+0xd4/0xe0
[    7.518435]  [<ffffffff8103f3d7>] tasklet_action+0xe7/0xf0
[    7.518761]  [<ffffffff8103e780>] __do_softirq+0x150/0x610
[    7.519083]  [<ffffffff812ea74a>] ? __dev_queue_xmit+0x2aa/0x8e0
[    7.519453]  [<ffffffff814e43cc>] do_softirq_own_stack+0x1c/0x30
[    7.519804]  <EOI>  [<ffffffff8103ed2d>] do_softirq+0x7d/0x90
[    7.520193]  [<ffffffff8103ee27>] __local_bh_enable_ip+0xe7/0xf0
[    7.520707]  [<ffffffff812ea773>] __dev_queue_xmit+0x2d3/0x8e0
[    7.521047]  [<ffffffff812ea4f0>] ? __dev_queue_xmit+0x50/0x8e0
[    7.521420]  [<ffffffff812eae00>] dev_queue_xmit+0x10/0x20
[    7.521743]  [<ffffffff813cdcba>] packet_sendmsg+0xdfa/0x10a0
[    7.522082]  [<ffffffff812cec59>] sock_sendmsg+0x69/0x90
[    7.522396]  [<ffffffff812ce8f5>] ? move_addr_to_kernel+0x45/0x70
[    7.522759]  [<ffffffff812d02e2>] SyS_sendto+0x112/0x150
[    7.523078]  [<ffffffff814e2995>] ? sysret_check+0x22/0x5d
[    7.523403]  [<ffffffff81080de5>] ?  trace_hardirqs_on_caller+0x105/0x1d0
[    7.523797]  [<ffffffff811e7eab>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    7.524176]  [<ffffffff814e2969>] system_call_fastpath+0x12/0x17
[    7.524531] ---[ end trace a7659d7a05f5ad36 ]---
[    7.910139] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[    8.050101] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[    8.910107] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[    8.910754] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[    9.210099] wlan1: dropped frame to 02:00:00:00:00:00 (unauthorized port)
[   12.512254] ------------[ cut here ]------------
[   12.512542] WARNING: CPU: 1 PID: 585 at net/mac80211/rate.c:501 ieee80211_get_tx_rates+0x2c2/0x810()
...

-- 
Jouni Malinen                                            PGP id EFC895FA
