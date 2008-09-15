Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36482 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYIOWzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 18:55:44 -0400
Received: by gxk9 with SMTP id 9so26165169gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 15:55:42 -0700 (PDT)
Message-ID: <43e72e890809151555u3a79bd89h763fa0a6ba07e752@mail.gmail.com> (sfid-20080916_005551_138899_E0D3E737)
Date: Mon, 15 Sep 2008 15:55:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: Re: [RFC] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 11:26 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Re-enable aggregation by addressing skb->cb overwrites
> after insertion into the qdisc. Aggregation was disabled
> after the new TX multiqueue changes were introduced. Instead
> of relying on the skb->cb we use two flags on the skb.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> Users have been reporting low rates on 2.6.27 with 11n drivers, the
> problem isbeen 11n aggregation was disabled due to the new TX multique
> changes. We should have addressed this sooner but we just got to it now.
>
> Without addressing this we won't get 11n aggregation on 2.6.27. I tried
> to minimize the changes required. I'm about to test this, it compiles.
>
> If this doesn't get upstream for 27 perhaps distributions are willing to
> carry it around then and if so oh well (grr...).

OK I get these results with iwlagn (Intel 4965) using iperf on 2GHz
using HT20 TCP on a very very noisy environment (at work):

(Server end using iperf -s -i1)

[  5] local 192.168.1.5 port 5001 connected with 192.168.1.3 port 34066
[  5]  0.0- 1.0 sec  4.21 MBytes  35.3 Mbits/sec
[  5]  1.0- 2.0 sec  2.85 MBytes  23.9 Mbits/sec
[  5]  2.0- 3.0 sec  3.94 MBytes  33.0 Mbits/sec
[  5]  3.0- 4.0 sec  3.66 MBytes  30.7 Mbits/sec
[  5]  4.0- 5.0 sec  3.63 MBytes  30.5 Mbits/sec
[  5]  5.0- 6.0 sec  3.22 MBytes  27.0 Mbits/sec
[  5]  6.0- 7.0 sec  3.82 MBytes  32.0 Mbits/sec
[  5]  7.0- 8.0 sec  3.36 MBytes  28.2 Mbits/sec
[  5]  8.0- 9.0 sec  2.66 MBytes  22.3 Mbits/sec
[  5]  9.0-10.0 sec  4.46 MBytes  37.4 Mbits/sec
[  5]  0.0-10.4 sec  37.1 MBytes  30.0 Mbits/sec


With ath9k aggregation is not being negotiated correctly. Will have to
look into that.

(Server end using iperf -s -i1)

[  4] local 192.168.1.5 port 5001 connected with 192.168.1.6 port 38482
[  4]  0.0- 1.0 sec    528 KBytes  4.33 Mbits/sec
[  4]  1.0- 2.0 sec    732 KBytes  6.00 Mbits/sec
[  4]  2.0- 3.0 sec    672 KBytes  5.51 Mbits/sec
[  4]  3.0- 4.0 sec    376 KBytes  3.08 Mbits/sec
[  4]  4.0- 5.0 sec    269 KBytes  2.20 Mbits/sec
[  4]  5.0- 6.0 sec    252 KBytes  2.06 Mbits/sec
[  4]  6.0- 7.0 sec    363 KBytes  2.98 Mbits/sec
[  4]  7.0- 8.0 sec    277 KBytes  2.27 Mbits/sec
[  4]  8.0- 9.0 sec    382 KBytes  3.13 Mbits/sec
[  4]  9.0-10.0 sec    474 KBytes  3.88 Mbits/sec
[  4]  0.0-10.2 sec  4.27 MBytes  3.50 Mbits/sec

On the client side with ath9k:
mcgrof@mosca ~ $ sudo dmesg -c
[ 6521.420101] wlan1: no IPv6 routers present
[ 6574.460164] Open BA session requested for 00:03:7f:0c:e0:bc tid 6
[ 6574.460175] BA request denied - queue unavailable for tid 6
[ 6580.168173] Open BA session requested for 00:03:7f:0c:e0:bc tid 6
[ 6580.168183] BA request denied - queue unavailable for tid 6
[ 6597.983766] Rx A-MPDU request on tid 0 result 0

But sadly with both we run into an an rtnl assert too (doesn't crash,
just a WARN_ON()):

This is with iwlagn:

Sep 15 14:44:45 mosca klogd: [ 2908.342255] iwlagn: Copyright(c)
2003-2008 Intel Corporation
Sep 15 14:44:45 mosca klogd: [ 2908.342526] iwlagn 0000:03:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Sep 15 14:44:45 mosca klogd: [ 2908.342657] iwlagn: Detected Intel
Wireless WiFi Link 4965AGN REV=0x4
Sep 15 14:44:45 mosca klogd: [ 2908.390128] iwlagn: Tunable channels:
11 802.11bg, 13 802.11a channels
Sep 15 14:45:26 mosca klogd: [ 2949.155420] iwlagn 0000:03:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Sep 15 14:45:26 mosca klogd: [ 2949.161136] firmware: requesting
iwlwifi-4965-2.ucode
Sep 15 14:45:26 mosca klogd: [ 2949.384341] Registered led device:
iwl-phy0:radio
Sep 15 14:45:26 mosca klogd: [ 2949.385560] Registered led device:
iwl-phy0:assoc
Sep 15 14:45:26 mosca klogd: [ 2949.386541] Registered led device: iwl-phy0:RX
Sep 15 14:45:26 mosca klogd: [ 2949.387490] Registered led device: iwl-phy0:TX
Sep 15 14:45:26 mosca klogd: [ 2949.432829] iwlagn: TX Power requested
while scanning!
Sep 15 14:45:26 mosca klogd: [ 2949.443491] ADDRCONF(NETDEV_UP):
wlan0: link is not ready
Sep 15 14:45:27 mosca klogd: [ 2950.759647] ADDRCONF(NETDEV_CHANGE):
wlan0: link becomes ready
Sep 15 14:56:38 mosca -- MARK --
Sep 15 15:02:07 mosca klogd: [ 3950.109244] iwlagn: iwl_tx_agg_start
on ra = 00:03:7f:0c:e0:bc tid = 0
Sep 15 15:02:07 mosca klogd: [ 3950.109359] Pid: 10156, comm: iperf
Not tainted 2.6.27-rc6 #3
Sep 15 15:02:07 mosca klogd: [ 3950.109365]  [<c037b64b>] ? printk+0x1d/0x22
Sep 15 15:02:07 mosca klogd: [ 3950.109380]  [<f8eac200>]
ieee80211_requeue+0x220/0x230 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109408]  [<f8eabfe0>] ?
ieee80211_requeue+0x0/0x230 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109430]  [<f8e943f5>]
ieee80211_start_tx_ba_session+0x165/0x2e0 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109439]  [<f8e942c0>] ?
ieee80211_start_tx_ba_session+0x30/0x2e0 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109449]  [<f8aefae0>] ?
iwl4965_mac_ampdu_action+0x0/0xc0 [iwlagn]
Sep 15 15:02:07 mosca klogd: [ 3950.109457]  [<f8af6ae5>]
rs_tl_turn_on_agg_for_tid+0x135/0x140 [iwlagn]
Sep 15 15:02:07 mosca klogd: [ 3950.109464]  [<f8adb8d0>] ?
iwl_generic_cmd_callback+0x0/0x70 [iwlcore]
Sep 15 15:02:07 mosca klogd: [ 3950.109471]  [<f8af7a11>]
rs_tx_status+0xf21/0x1860 [iwlagn]
Sep 15 15:02:07 mosca klogd: [ 3950.109478]  [<f8af6b82>] ?
rs_tx_status+0x92/0x1860 [iwlagn]
Sep 15 15:02:07 mosca klogd: [ 3950.109495]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:02:07 mosca klogd: [ 3950.109500]  [<c01386c7>] ?
local_bh_enable+0x77/0xe0
Sep 15 15:02:07 mosca klogd: [ 3950.109505]  [<c01594f4>] ?
__lock_acquire+0x2a4/0xf90
Sep 15 15:02:07 mosca klogd: [ 3950.109509]  [<c0317c4d>] ?
ip_finish_output+0x18d/0x290
Sep 15 15:02:07 mosca klogd: [ 3950.109514]  [<c0317da5>] ? ip_output+0x55/0xb0
Sep 15 15:02:07 mosca klogd: [ 3950.109518]  [<c01594f4>] ?
__lock_acquire+0x2a4/0xf90
Sep 15 15:02:07 mosca klogd: [ 3950.109523]  [<c01594f4>] ?
__lock_acquire+0x2a4/0xf90
Sep 15 15:02:07 mosca klogd: [ 3950.109527]  [<c025a791>] ?
_raw_spin_lock+0x41/0x120
Sep 15 15:02:07 mosca klogd: [ 3950.109532]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:02:07 mosca klogd: [ 3950.109536]  [<f8e95150>] ?
ieee80211_tx_status+0x0/0x4c0 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109555]  [<f8e9520b>]
ieee80211_tx_status+0xbb/0x4c0 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109564]  [<f8e95150>] ?
ieee80211_tx_status+0x0/0x4c0 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109574]  [<f8e95720>]
ieee80211_tasklet_handler+0x110/0x120 [mac80211]
Sep 15 15:02:07 mosca klogd: [ 3950.109583]  [<c02e9696>] ?
__kfree_skb+0x36/0x90
Sep 15 15:02:07 mosca klogd: [ 3950.109587]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:02:07 mosca klogd: [ 3950.109591]  [<c0158ec6>] ?
trace_hardirqs_on_caller+0x86/0x170
Sep 15 15:02:07 mosca klogd: [ 3950.109595]  [<c0137f4d>]
tasklet_action+0x7d/0x110
Sep 15 15:02:07 mosca klogd: [ 3950.109599]  [<c013835a>]
__do_softirq+0x9a/0x130
Sep 15 15:02:07 mosca klogd: [ 3950.109602]  [<c013847d>] do_softirq+0x8d/0xa0
Sep 15 15:02:07 mosca klogd: [ 3950.109605]  [<c0138615>] irq_exit+0x65/0xa0
Sep 15 15:02:07 mosca klogd: [ 3950.109608]  [<c0106d9a>] do_IRQ+0x4a/0x80
Sep 15 15:02:07 mosca klogd: [ 3950.109612]  [<c0158f55>] ?
trace_hardirqs_on_caller+0x115/0x170
Sep 15 15:02:07 mosca klogd: [ 3950.109616]  [<c0105058>]
common_interrupt+0x28/0x30
Sep 15 15:02:07 mosca klogd: [ 3950.109620]  [<c03700d8>] ?
pci_scan_bridge+0xe6/0x3ae
Sep 15 15:02:07 mosca klogd: [ 3950.109624]  [<c0119e34>] ? read_hpet+0x14/0x20
Sep 15 15:02:07 mosca klogd: [ 3950.109628]  [<c014f7ab>]
getnstimeofday+0x4b/0x100
Sep 15 15:02:07 mosca klogd: [ 3950.109632]  [<c014f876>]
do_gettimeofday+0x16/0x40
Sep 15 15:02:07 mosca klogd: [ 3950.109636]  [<c0137aa2>]
sys_gettimeofday+0x22/0x70
Sep 15 15:02:07 mosca klogd: [ 3950.109639]  [<c025633c>] ?
trace_hardirqs_on_thunk+0xc/0x10
Sep 15 15:02:07 mosca klogd: [ 3950.109643]  [<c0103f6b>]
sysenter_do_call+0x12/0x3f
Sep 15 15:02:07 mosca klogd: [ 3950.109648]  =======================

With ath9k its the same story, this happens at the beginning when you
start TXing:

Sep 15 15:44:31 mosca klogd: [ 6494.308158] pccard: CardBus card
inserted into slot 0
Sep 15 15:44:31 mosca klogd: [ 6494.753121] ath9k: 0.1
Sep 15 15:44:31 mosca klogd: [ 6494.753392] ath9k 0000:16:00.0:
enabling device (0000 -> 0002)
Sep 15 15:44:31 mosca klogd: [ 6494.753418] ath9k 0000:16:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Sep 15 15:44:32 mosca klogd: [ 6495.191035] phy1: Atheros 5416:
mem=0xf8ca0000, irq=16
Sep 15 15:44:39 mosca klogd: [ 6502.254215] ADDRCONF(NETDEV_UP):
wlan1: link is not ready
Sep 15 15:44:47 mosca klogd: [ 6510.432301] ADDRCONF(NETDEV_CHANGE):
wlan1: link becomes ready
Sep 15 15:44:47 mosca klogd: [ 6510.440592] Pid: 0, comm: swapper Not
tainted 2.6.27-rc6 #3
Sep 15 15:44:47 mosca klogd: [ 6510.440598]  [<c037b64b>] ? printk+0x1d/0x22
Sep 15 15:44:47 mosca klogd: [ 6510.440614]  [<f8eac200>]
ieee80211_requeue+0x220/0x230 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440661]  [<f8eabfe0>] ?
ieee80211_requeue+0x0/0x230 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440703]  [<f8e943f5>]
ieee80211_start_tx_ba_session+0x165/0x2e0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440728]  [<f8e942c0>] ?
ieee80211_start_tx_ba_session+0x30/0x2e0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440753]  [<f90f9370>] ?
ath9k_ampdu_action+0x0/0x1a0 [ath9k]
Sep 15 15:44:47 mosca klogd: [ 6510.440778]  [<f91026a9>]
ath_get_rate+0x329/0x3e0 [ath9k]
Sep 15 15:44:47 mosca klogd: [ 6510.440801]  [<f8ea27bf>] ?
rate_control_get_rate+0x2f/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440842]  [<f8ea2836>]
rate_control_get_rate+0xa6/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440869]  [<f8ea27bf>] ?
rate_control_get_rate+0x2f/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440896]  [<f8ea9979>]
invoke_tx_handlers+0x649/0xcc0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440923]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.440935]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.440945]  [<f8ea7eec>] ?
__ieee80211_tx_prepare+0x16c/0x370 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.440974]  [<f8eaa4b0>] ?
ieee80211_master_start_xmit+0x180/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.441002]  [<f8eaa50c>]
ieee80211_master_start_xmit+0x1dc/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.441040]  [<f8eaa4b0>] ?
ieee80211_master_start_xmit+0x180/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.441068]  [<c02f16cb>]
dev_hard_start_xmit+0x28b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.441081]  [<c02f148b>] ?
dev_hard_start_xmit+0x4b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.441092]  [<c03011eb>]
__qdisc_run+0x1cb/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.441101]  [<c02f396f>]
dev_queue_xmit+0x39f/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.441111]  [<c02f360e>] ?
dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.441122]  [<f8ea8f1b>]
ieee80211_subif_start_xmit+0x35b/0x6d0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.441149]  [<f8ea8f3f>] ?
ieee80211_subif_start_xmit+0x37f/0x6d0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.441191]  [<c02f1568>] ?
dev_hard_start_xmit+0x128/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.441203]  [<c02f16cb>]
dev_hard_start_xmit+0x28b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.441213]  [<c02f148b>] ?
dev_hard_start_xmit+0x4b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.441224]  [<c03011eb>]
__qdisc_run+0x1cb/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.441232]  [<c02f396f>]
dev_queue_xmit+0x39f/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.441242]  [<c02f360e>] ?
dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.441253]  [<c02f74e1>]
neigh_resolve_output+0xf1/0x2a0
Sep 15 15:44:47 mosca klogd: [ 6510.441263]  [<f93fede0>] ?
ipv6_chk_mcast_addr+0x0/0x1e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441305]  [<f93e3166>]
ip6_output_finish+0xa6/0x100 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441337]  [<f93e52b8>]
ip6_output2+0x138/0x220 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441381]  [<f93e58a5>]
ip6_output+0x505/0xba0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441412]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.441423]  [<c0158ec6>] ?
trace_hardirqs_on_caller+0x86/0x170
Sep 15 15:44:47 mosca klogd: [ 6510.441433]  [<f93f0f0f>] ?
icmp6_dst_alloc+0x10f/0x1c0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441468]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.441478]  [<c0138b06>] ?
local_bh_enable_ip+0x76/0xe0
Sep 15 15:44:47 mosca klogd: [ 6510.441502]  [<c037e87a>] ?
_spin_unlock_bh+0x2a/0x30
Sep 15 15:44:47 mosca klogd: [ 6510.441514]  [<f93ff2e8>]
mld_sendpack+0x328/0x390 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441551]  [<f93fefc0>] ?
mld_sendpack+0x0/0x390 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441590]  [<f93ff9a9>]
mld_ifc_timer_expire+0x259/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441627]  [<c013cb9d>]
run_timer_softirq+0x12d/0x1f0
Sep 15 15:44:47 mosca klogd: [ 6510.441637]  [<f93ff750>] ?
mld_ifc_timer_expire+0x0/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441676]  [<f93ff750>] ?
mld_ifc_timer_expire+0x0/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.441714]  [<c013835a>]
__do_softirq+0x9a/0x130
Sep 15 15:44:47 mosca klogd: [ 6510.441722]  [<c013847d>] do_softirq+0x8d/0xa0
Sep 15 15:44:47 mosca klogd: [ 6510.441730]  [<c0138615>] irq_exit+0x65/0xa0
Sep 15 15:44:47 mosca klogd: [ 6510.441738]  [<c011434d>]
smp_apic_timer_interrupt+0x5d/0x90
Sep 15 15:44:47 mosca klogd: [ 6510.441749]  [<c025634c>] ?
trace_hardirqs_off_thunk+0xc/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.441761]  [<c010518d>]
apic_timer_interrupt+0x2d/0x40
Sep 15 15:44:47 mosca klogd: [ 6510.441771]  [<c02d007b>] ?
mousedev_open_device+0x2b/0xf0
Sep 15 15:44:47 mosca klogd: [ 6510.441782]  [<c01028a6>] ? cpu_idle+0x96/0x140
Sep 15 15:44:47 mosca klogd: [ 6510.441792]  [<c036d4e3>] rest_init+0x53/0x60
Sep 15 15:44:47 mosca klogd: [ 6510.441803]  =======================


And then lockdep picks up a possible recursive lock:


Sep 15 15:44:47 mosca klogd: [ 6510.441919]
=============================================
Sep 15 15:44:47 mosca klogd: [ 6510.441925] [ INFO: possible recursive
locking detected ]
Sep 15 15:44:47 mosca klogd: [ 6510.441931] 2.6.27-rc6 #3
Sep 15 15:44:47 mosca klogd: [ 6510.441935]
---------------------------------------------
Sep 15 15:44:47 mosca klogd: [ 6510.441941] swapper/0 is trying to acquire lock:
Sep 15 15:44:47 mosca klogd: [ 6510.441946]
(_xmit_IEEE80211#2){-+..}, at: [<c0301207>] __qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.441964]
Sep 15 15:44:47 mosca klogd: [ 6510.441965] but task is already holding lock:
Sep 15 15:44:47 mosca klogd: [ 6510.441970]
(_xmit_IEEE80211#2){-+..}, at: [<c0301207>] __qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.441986]
Sep 15 15:44:47 mosca klogd: [ 6510.441988] other info that might help
us debug this:
Sep 15 15:44:47 mosca klogd: [ 6510.441994] 8 locks held by swapper/0:
Sep 15 15:44:47 mosca klogd: [ 6510.441998]  #0:
(rcu_read_lock){..--}, at: [<c02f360e>] dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442017]  #1:
(_xmit_ETHER#2){-+..}, at: [<c0301207>] __qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442034]  #2:
(rcu_read_lock){..--}, at: [<c02f360e>] dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442051]  #3:
(_xmit_IEEE80211#2){-+..}, at: [<c0301207>] __qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442069]  #4:
(rcu_read_lock){..--}, at: [<f8eaa4b0>]
ieee80211_master_start_xmit+0x180/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442104]  #5:
(rcu_read_lock){..--}, at: [<f8ea27bf>]
rate_control_get_rate+0x2f/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442138]  #6:
(rcu_read_lock){..--}, at: [<f8e942c0>]
ieee80211_start_tx_ba_session+0x30/0x2e0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442169]  #7:
(rcu_read_lock){..--}, at: [<c02f360e>] dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442186]
Sep 15 15:44:47 mosca klogd: [ 6510.442187] stack backtrace:
Sep 15 15:44:47 mosca klogd: [ 6510.442194] Pid: 0, comm: swapper Not
tainted 2.6.27-rc6 #3
Sep 15 15:44:47 mosca klogd: [ 6510.442199]  [<c037b64b>] ? printk+0x1d/0x22
Sep 15 15:44:47 mosca klogd: [ 6510.442210]  [<c0159db9>]
__lock_acquire+0xb69/0xf90
Sep 15 15:44:47 mosca klogd: [ 6510.442220]  [<c02f3699>] ?
dev_queue_xmit+0xc9/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442232]  [<c015a269>] lock_acquire+0x89/0xc0
Sep 15 15:44:47 mosca klogd: [ 6510.442241]  [<c0301207>] ?
__qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442252]  [<c037eac8>] _spin_lock+0x38/0x50
Sep 15 15:44:47 mosca klogd: [ 6510.442260]  [<c0301207>] ?
__qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442270]  [<c0301207>]
__qdisc_run+0x1e7/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442279]  [<c02f396f>]
dev_queue_xmit+0x39f/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442289]  [<c02f360e>] ?
dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442301]  [<f8e9acb4>]
ieee80211_sta_tx+0x74/0x90 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442327]  [<f8e9ed6e>]
ieee80211_send_addba_request+0x14e/0x1a0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442353]  [<c0158ec6>] ?
trace_hardirqs_on_caller+0x86/0x170
Sep 15 15:44:47 mosca klogd: [ 6510.442365]  [<f8e943fd>] ?
ieee80211_start_tx_ba_session+0x16d/0x2e0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442392]  [<f8e94459>]
ieee80211_start_tx_ba_session+0x1c9/0x2e0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442416]  [<f90f9370>] ?
ath9k_ampdu_action+0x0/0x1a0 [ath9k]
Sep 15 15:44:47 mosca klogd: [ 6510.442440]  [<f91026a9>]
ath_get_rate+0x329/0x3e0 [ath9k]
Sep 15 15:44:47 mosca klogd: [ 6510.442463]  [<f8ea27bf>] ?
rate_control_get_rate+0x2f/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442505]  [<f8ea2836>]
rate_control_get_rate+0xa6/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442532]  [<f8ea27bf>] ?
rate_control_get_rate+0x2f/0x190 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442560]  [<f8ea9979>]
invoke_tx_handlers+0x649/0xcc0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442587]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.442598]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.442610]  [<f8ea7eec>] ?
__ieee80211_tx_prepare+0x16c/0x370 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442639]  [<f8eaa4b0>] ?
ieee80211_master_start_xmit+0x180/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442668]  [<f8eaa50c>]
ieee80211_master_start_xmit+0x1dc/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442694]  [<f8eaa4b0>] ?
ieee80211_master_start_xmit+0x180/0x420 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442724]  [<c02f16cb>]
dev_hard_start_xmit+0x28b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.442734]  [<c02f148b>] ?
dev_hard_start_xmit+0x4b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.442747]  [<c03011eb>]
__qdisc_run+0x1cb/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442756]  [<c02f396f>]
dev_queue_xmit+0x39f/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442766]  [<c02f360e>] ?
dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442777]  [<f8ea8f1b>]
ieee80211_subif_start_xmit+0x35b/0x6d0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442805]  [<f8ea8f3f>] ?
ieee80211_subif_start_xmit+0x37f/0x6d0 [mac80211]
Sep 15 15:44:47 mosca klogd: [ 6510.442847]  [<c02f1568>] ?
dev_hard_start_xmit+0x128/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.442860]  [<c02f16cb>]
dev_hard_start_xmit+0x28b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.442870]  [<c02f148b>] ?
dev_hard_start_xmit+0x4b/0x320
Sep 15 15:44:47 mosca klogd: [ 6510.442882]  [<c03011eb>]
__qdisc_run+0x1cb/0x220
Sep 15 15:44:47 mosca klogd: [ 6510.442891]  [<c02f396f>]
dev_queue_xmit+0x39f/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442901]  [<c02f360e>] ?
dev_queue_xmit+0x3e/0x5f0
Sep 15 15:44:47 mosca klogd: [ 6510.442913]  [<c02f74e1>]
neigh_resolve_output+0xf1/0x2a0
Sep 15 15:44:47 mosca klogd: [ 6510.442923]  [<f93fede0>] ?
ipv6_chk_mcast_addr+0x0/0x1e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.442964]  [<f93e3166>]
ip6_output_finish+0xa6/0x100 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.442996]  [<f93e52b8>]
ip6_output2+0x138/0x220 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443040]  [<f93e58a5>]
ip6_output+0x505/0xba0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443071]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.443083]  [<c0158ec6>] ?
trace_hardirqs_on_caller+0x86/0x170
Sep 15 15:44:47 mosca klogd: [ 6510.443095]  [<f93f0f0f>] ?
icmp6_dst_alloc+0x10f/0x1c0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443130]  [<c0158fbb>] ?
trace_hardirqs_on+0xb/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.443141]  [<c0138b06>] ?
local_bh_enable_ip+0x76/0xe0
Sep 15 15:44:47 mosca klogd: [ 6510.443165]  [<c037e87a>] ?
_spin_unlock_bh+0x2a/0x30
Sep 15 15:44:47 mosca klogd: [ 6510.443178]  [<f93ff2e8>]
mld_sendpack+0x328/0x390 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443215]  [<f93fefc0>] ?
mld_sendpack+0x0/0x390 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443255]  [<f93ff9a9>]
mld_ifc_timer_expire+0x259/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443292]  [<c013cb9d>]
run_timer_softirq+0x12d/0x1f0
Sep 15 15:44:47 mosca klogd: [ 6510.443303]  [<f93ff750>] ?
mld_ifc_timer_expire+0x0/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443342]  [<f93ff750>] ?
mld_ifc_timer_expire+0x0/0x2e0 [ipv6]
Sep 15 15:44:47 mosca klogd: [ 6510.443381]  [<c013835a>]
__do_softirq+0x9a/0x130
Sep 15 15:44:47 mosca klogd: [ 6510.443390]  [<c013847d>] do_softirq+0x8d/0xa0
Sep 15 15:44:47 mosca klogd: [ 6510.443399]  [<c0138615>] irq_exit+0x65/0xa0
Sep 15 15:44:47 mosca klogd: [ 6510.443407]  [<c011434d>]
smp_apic_timer_interrupt+0x5d/0x90
Sep 15 15:44:47 mosca klogd: [ 6510.443418]  [<c025634c>] ?
trace_hardirqs_off_thunk+0xc/0x10
Sep 15 15:44:47 mosca klogd: [ 6510.443430]  [<c010518d>]
apic_timer_interrupt+0x2d/0x40
Sep 15 15:44:47 mosca klogd: [ 6510.443440]  [<c02d007b>] ?
mousedev_open_device+0x2b/0xf0
Sep 15 15:44:47 mosca klogd: [ 6510.443452]  [<c01028a6>] ? cpu_idle+0x96/0x140
Sep 15 15:44:47 mosca klogd: [ 6510.443462]  [<c036d4e3>] rest_init+0x53/0x60
Sep 15 15:44:47 mosca klogd: [ 6510.443473]  =======================



  Luis
