Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33001 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbbHUFEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 01:04:42 -0400
Received: by lbbsx3 with SMTP id sx3so36692978lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 22:04:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
Date: Fri, 21 Aug 2015 07:04:40 +0200
Message-ID: <CA+BoTQnx=V+LuxA3SbxVcZvM+3LqKogoBp-DiCD7erG6p_E41w@mail.gmail.com> (sfid-20150821_070448_539875_99F20B72)
Subject: Re: mac80211: When adding a new station, notify driver before adding
 to hash
From: Michal Kazior <michal.kazior@tieto.com>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 August 2015 at 23:39, Marty Faltesek <mfaltesek@google.com> wrote:
> We are seeing reports of the following panic with ath10k, running
> backports 3.19-rc1 code:
>
> [196113.641] ------------[ cut here ]------------
> [196113.641] kernel BUG at kernel/workqueue.c:1040!
> [196113.641] Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
> [196113.656] Modules linked in: ctr ccm nf_conntrack_netlink
> auto_bridge(O) fci(O) nfnetlink pktgen ath9k_htc(O) mwifiex_usb(O)
> mwifiex(O) ath10k_pci(O) ath10k_core(O) arc4 ath9k(O) mac80211(O)
> ath9k_common(O) ath9k_hw(O) ath(O) cfg80211(O) compat(O) bmoc
> a(O) xt_connmark ip6table_mangle xt_CLASSIFY iptable_mangle xt_helper
> ip6t_REJECT ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables nf_nat_rtsp nf_conntrack_rtsp nf_nat_h323 nf_conntrack_h323
> nf_nat_irc nf_conntrack_irc nf_nat_pptp nf_c
> onntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_sip
> nf_conntrack_sip nf_nat_tftp nf_conntrack_tftp nf_nat_ftp
> nf_conntrack_ftp ipt_MASQUERADE ipt_REJECT ipt_LOG xt_limit xt_pkttype
> xt_conntrack xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 n
> f_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables pfe(O)
> [196113.734] CPU: 0    Tainted: G           O  (3.2.26 #1)
> [196113.734] PC is at __queue_work+0x20e/0x310
> [196113.750] LR is at __queue_work+0x1c7/0x310
> [196113.750] pc : [<840383ea>]    lr : [<840383a3>]    psr: 000101b3
> [196113.750] sp : b8cd5730  ip : 00000000  fp : 00010113
> [196113.766] r10: 89de13cc  r9 : 8446b6e4  r8 : 84472e40
> [196113.766] r7 : 00000000  r6 : bc797a00  r5 : bc79bd20  r4 : 89de1424
> [196113.766] r3 : 89de1428  r2 : 00000000  r1 : bc79bd20  r0 : bc797a00
> [196113.781] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb
> Segment user
> [196113.781] Control: 50c53c7d  Table: 3577404a  DAC: 00000015
> [196113.797] Process hostapd (pid: 3817, stack limit = 0xb8cd42f0)
> [196113.797] Stack: (0xb8cd5730 to 0xb8cd6000)
> ...
> [196114.391] [<840383ea>] (__queue_work+0x20e/0x310) from [<84038509>]
> (queue_work_on+0x1d/0x24)
> [196114.406] [<84038509>] (queue_work_on+0x1d/0x24) from [<8403852d>]
> (queue_work+0x1d/0x34)
> [196114.406] [<8403852d>] (queue_work+0x1d/0x34) from [<83883a05>]
> (ieee80211_queue_work+0x14/0x18 [mac80211])
> [196114.422] [<83883a05>] (ieee80211_queue_work+0x14/0x18 [mac80211])
> from [<838fa15f>] (ath10k_sta_rc_update+0xbe/0x1b4 [ath10k_core])
> [196114.438] [<838fa15f>] (ath10k_sta_rc_update+0xbe/0x1b4
> [ath10k_core]) from [<8387ddd3>]
> (ieee80211_sta_ps_transition+0x1456/0x25a4 [mac80211])
> [196114.438] [<8387ddd3>] (ieee80211_sta_ps_transition+0x1456/0x25a4
> [mac80211]) from [<8387ee81>]
> (ieee80211_sta_ps_transition+0x2504/0x25a4 [mac80211])
> [196114.453] [<8387ee81>] (ieee80211_sta_ps_transition+0x2504/0x25a4
> [mac80211]) from [<8387f407>] (ieee80211_rx+0x4e6/0x580 [mac80211])
> [196114.469] [<8387f407>] (ieee80211_rx+0x4e6/0x580 [mac80211]) from
> [<8390659f>] (ath10k_wmi_htc_tx_complete+0xf72/0x160c [ath10k_core])
> [196114.484] [<8390659f>] (ath10k_wmi_htc_tx_complete+0xf72/0x160c
> [ath10k_core]) from [<83908f29>] (ath10k_wmi_process_rx+0x3e0/0x5c0
> [ath10k_core])
> [196114.500] [<83908f29>] (ath10k_wmi_process_rx+0x3e0/0x5c0
> [ath10k_core]) from [<8390261f>]
> (ath10k_htc_rx_completion_handler+0x2be/0x304 [ath10k_core])
> [196114.516] [<8390261f>]
> (ath10k_htc_rx_completion_handler+0x2be/0x304 [ath10k_core]) from
> [<83920f51>] (ath10k_pci_ce_recv_data+0x120/0x190 [ath10k_pci])
> [196114.516] FW:IN=wan0.2 OUT=br0
> MAC=<removed>
> SRC=<removed>
> DST=<removed> LEN=60 TC=0 HOPLIMIT=52
> FLOWLBL=0 PROTO=TCP SPT=5228 DPT=61497 WINDOW=0 RES=0x00 RST URGP=0
> [196114.547] [<83920f51>] (ath10k_pci_ce_recv_data+0x120/0x190
> [ath10k_pci]) from [<8392257b>]
> (ath10k_ce_per_engine_service+0x4a/0x74 [ath10k_pci])
> [196114.562] [<8392257b>] (ath10k_ce_per_engine_service+0x4a/0x74
> [ath10k_pci]) from [<839225d1>]
> (ath10k_ce_per_engine_service_any+0x2c/0x48 [ath10k_pci])
> [196114.578] [<839225d1>] (ath10k_ce_per_engine_service_any+0x2c/0x48
> [ath10k_pci]) from [<8392209f>] (ath10k_pci_tasklet+0x26/0x40
> [ath10k_pci])
> [196114.578] [<8392209f>] (ath10k_pci_tasklet+0x26/0x40 [ath10k_pci])
> from [<8402b96f>] (tasklet_action+0x6f/0x104)
> [196114.594] [<8402b96f>] (tasklet_action+0x6f/0x104) from
> [<8402bc9d>] (__do_softirq+0xc5/0x190)
> [196114.594] [<8402bc9d>] (__do_softirq+0xc5/0x190) from [<8402c067>]
> (irq_exit+0x37/0x6c)
> [196114.609] [<8402c067>] (irq_exit+0x37/0x6c) from [<8400d3d7>]
> (handle_IRQ+0xdf/0xf4)
> [196114.609] [<8400d3d7>] (handle_IRQ+0xdf/0xf4) from [<8400c553>]
> (__irq_svc+0x33/0xb8)
> [196114.625] [<8400c553>] (__irq_svc+0x33/0xb8) from [<838695a4>]
> (sta_info_recalc_tim+0x573/0x9a4 [mac80211])
> [196114.641] [<838695a4>] (sta_info_recalc_tim+0x573/0x9a4 [mac80211])
> from [<83869a4d>] (sta_info_insert_rcu+0x78/0x84 [mac80211])
> [196114.641] [<83869a4d>] (sta_info_insert_rcu+0x78/0x84 [mac80211])
> from [<8387afe5>] (ieee80211_add_station+0x184/0x1e8 [mac80211])
> [196114.656] [<8387afe5>] (ieee80211_add_station+0x184/0x1e8
> [mac80211]) from [<837a4721>] (nl80211_new_station+0x214/0x2d8
> [cfg80211])
> [196114.672] [<837a4721>] (nl80211_new_station+0x214/0x2d8 [cfg80211])
> from [<842436a1>] (genl_rcv_msg+0x149/0x17c)
> [196114.672] [<842436a1>] (genl_rcv_msg+0x149/0x17c) from [<84242fed>]
> (netlink_rcv_skb+0x31/0x6c)
> [196114.688] [<84242fed>] (netlink_rcv_skb+0x31/0x6c) from
> [<8424354d>] (genl_rcv+0x21/0x2c)
> [196114.703] [<8424354d>] (genl_rcv+0x21/0x2c) from [<84242a77>]
> (netlink_unicast+0x1bb/0x2b8)
> [196114.703] [<84242a77>] (netlink_unicast+0x1bb/0x2b8) from
> [<84242d97>] (netlink_sendmsg+0x183/0x21c)
> [196114.734] [<84242d97>] (netlink_sendmsg+0x183/0x21c) from
> [<84221649>] (sock_sendmsg+0x61/0x74)
> [196114.734] [<84221649>] (sock_sendmsg+0x61/0x74) from [<84222047>]
> (__sys_sendmsg+0x1c3/0x1e0)
> [196114.750] [<84222047>] (__sys_sendmsg+0x1c3/0x1e0) from
> [<84222dd7>] (sys_sendmsg+0x23/0x38)
> [196114.750] [<84222dd7>] (sys_sendmsg+0x23/0x38) from [<8400ca81>]
> (ret_fast_syscall+0x1/0x46)
> [196114.766] Code: 6862 1d23 429a d000 (de02) 68b7
> [196114.766] ---[ end trace 4ff223894257ab1a ]---
> [196114.766] Kernel panic - not syncing: Fatal exception in interrupt
> [196114.781] [<840111e1>] (unwind_backtrace+0x1/0x8c) from
> [<842c28fd>] (panic+0x5d/0x134)
> [196114.781] [<842c28fd>] (panic+0x5d/0x134) from [<8400f5f3>] (die+0x1eb/0x224)
> [196114.797] [<8400f5f3>] (die+0x1eb/0x224) from [<84008249>]
> (do_undefinstr+0xc5/0xdc)
> [196114.797] [<84008249>] (do_undefinstr+0xc5/0xdc) from [<8400c661>]
> (__und_svc_finish+0x1/0x40)
>
>
> I believe the following race occurs:
>
> 1. mac80211 is processing a new station that just joined.
> 2. Before it's completed initializing the station, we take an interrupt,
>    with a packet from the STA.
> 3. That interrupt is a management frame from the station which causes
>    rate_control_rate_update to be called, which calls back into the ath10k
>    with the not-fully initialized station.
> 4. It reaches ath10k_sta_rc_update before the interrupted thread had
> reached ath10k_sta_state()
>    Therefore it has not yet initialized its workqueue. Still NULL.
> 5. When this NULL workqueue gets passed to queue_work, it passes
>    the first check that its not in use because of the NULL struct, but fails the
>    next check in __queue_work because a NULL structure makes the test
>    for an empty list fail.
>
>
> Proposed patch is to not add the new station in the hash until after the
> driver initializes it. But I'm not clear what implications this has. Could this
> cause other problems?

Yes. This can cause problems with drivers using iterate_stations()
from within sta_state() (actually ath10k does that).

Moreover it seems your patch will re-introduce another problem if you
swap the inserting sequence:

commit 5108ca828017120981880eeec8a9ec369334a899
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Feb 17 20:49:03 2014 +0100

    mac80211: insert stations before adding to driver

    There's a race condition in mac80211 because we add stations
    to the internal lists after adding them to the driver, which
    means that (for example) the following can happen:
     1. a station connects and is added
     2. first, it is added to the driver
     3. then, it is added to the mac80211 lists

    If the station goes to sleep between steps 2 and 3, and the
    firmware/hardware records it as being asleep, mac80211 will
    never instruct the driver to wake it up again as it never
    realized it went to sleep since the RX path discarded the
    frame as a "spurious class 3 frame", no station entry was
    present yet.

    Fix this by adding the station in software first, and only
    then adding it to the driver. That way, any state that the
    driver changes will be reflected properly in mac80211's
    station state. The problematic part is the roll-back if the
    driver fails to add the station, in that case a bit more is
    needed. To not make that overly complex prevent starting BA
    sessions in the meantime.

    Signed-off-by: Johannes Berg <johannes.berg@intel.com>


I guess it'd be better to try to prevent mac80211 from calling
sta_rc_update() before sta_state()..


Michał
