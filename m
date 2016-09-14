Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35597 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbcINFqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 01:46:50 -0400
Received: by mail-lf0-f68.google.com with SMTP id s64so154249lfs.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2016 22:46:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs
Date: Wed, 14 Sep 2016 07:45:28 +0200
Message-Id: <20160914054528.28717-1-zajec5@gmail.com> (sfid-20160914_074656_134397_7E77B9EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Even with the most recent brcmfmac code ppl keep seeing WARNINGs from
brcmf_netdev_wait_pend8021x [0].

Hante suggested using CONSOLE for debugging some firmware crash so I
decided to see I it could also help understanding WARNINGs. I believe it
did.

First of all, I can't reproduce these problems reliably. One evening I
got WARNINGs one by one and I could work on my debugging patch easily.
Yesterday when I got my patch complete, it took me 10+ hours to get a
single WARNING.

Anyway, it seems to me that sometimes AMPDU stalls in the firmware. It
seems firmware has some AMPDU watchdog that notices the problem and
kicks in. It prints some debugging info and starts cleaning up process.

If brcmf_netdev_wait_pend8021x gets called shortly after that (I set
wpa_group_rekey=30 in hostapd to get brcmf_cfg80211_add_key called more
often) it results in a WARNING.

For better debugging I wrote brcmfmac patch that:
1) Keeps track of every 802.1x skb submitted to the device
2) During WARNING it prints skbs and marks them as timedout
3) It informs when timedout skb gets finally reported as sent

Enough talking, please take a look at my debugging log. Does it give you
enough hint? Could you review/debug firmware's code responsible for
AMPDU? FWIW Merlin users (so no brcmfmac invovled) also saw this [1].

[  913.569121] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7369480 brcmf_ifname(ifp):wlan1
[  913.579521] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70cd480 brcmf_ifname(ifp):wlan0
[  913.627346] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71a1480 brcmf_ifname(ifp):wlan1-1
[  913.839833] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6464c80 brcmf_ifname(ifp):wlan0-1
[  914.179775] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64cac80 brcmf_ifname(ifp):wlan0-2
[  914.191129] brcmfmac: CONSOLE: 027644.261 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.198474] brcmfmac: CONSOLE: 027644.266 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.206020] brcmfmac: CONSOLE: 027644.273 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.215243] brcmfmac: CONSOLE: 027644.284 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.224521] brcmfmac: CONSOLE: 027644.294 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.231878] brcmfmac: CONSOLE: 027644.298 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.239425] brcmfmac: CONSOLE: 027644.307 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.248444] brcmfmac: CONSOLE: 027644.318 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.257163] brcmfmac: CONSOLE: 027644.326 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.266616] brcmfmac: CONSOLE: 027644.336 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.274072] brcmfmac: CONSOLE: 027644.341 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.284716] brcmfmac: CONSOLE: 027644.354 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.291962] brcmfmac: CONSOLE: 027644.359 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.299172] brcmfmac: CONSOLE: 027644.364 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.306646] brcmfmac: CONSOLE: 027644.371 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.314058] brcmfmac: CONSOLE: 027644.380 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.323193] brcmfmac: CONSOLE: 027644.393 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.330640] brcmfmac: CONSOLE: 027644.400 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.340886] brcmfmac: CONSOLE: 027644.410 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.352975] brcmfmac: CONSOLE: 027644.422 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.365365] brcmfmac: CONSOLE: 027644.434 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.372790] brcmfmac: CONSOLE: 027644.440 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.384982] brcmfmac: CONSOLE: 027644.454 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.395488] brcmfmac: CONSOLE: 027644.465 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.402977] brcmfmac: CONSOLE: 027644.471 wl0.3: wlc_send_bar: seq 0x3 tid 0
[  914.701404] brcmfmac: CONSOLE: 027644.771 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.710513] brcmfmac: CONSOLE: 027644.780 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.717731] brcmfmac: CONSOLE: 027644.787 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.728099] brcmfmac: CONSOLE: 027644.798 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.737616] brcmfmac: CONSOLE: 027644.807 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.745320] brcmfmac: CONSOLE: 027644.815 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.757985] brcmfmac: CONSOLE: 027644.827 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.765457] brcmfmac: CONSOLE: 027644.833 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.772729] brcmfmac: CONSOLE: 027644.841 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.781407] brcmfmac: CONSOLE: 027644.851 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.789268] brcmfmac: CONSOLE: 027644.859 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.796754] brcmfmac: CONSOLE: 027644.866 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.808174] brcmfmac: CONSOLE: 027644.878 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  914.818975] brcmfmac: CONSOLE: 027644.888 wl0.3: wlc_send_bar: seq 0x4 tid 0
[  917.077991] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: wl0.3 scb:00347c74 tid:0 
[  917.085368] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: wl0.3 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
[  917.100070] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 30788
[  917.108303] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: pktpend: 0 2 0 0 0 ap 1
[  917.115434] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: txall 5901 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
[  917.125265] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 9 0 9 0 0 ifs_boff 0
[  917.134907] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
[  917.142806] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
[  917.150739] brcmfmac: CONSOLE: 027647.149 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[  917.162912] brcmfmac: CONSOLE: 027647.149 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[  917.718723] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2
[  918.678558] ------------[ cut here ]------------
[  918.683329] WARNING: CPU: 1 PID: 1145 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[  918.699599] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  918.771954] CPU: 1 PID: 1145 Comm: hostapd Not tainted 4.4.19 #0
[  918.777971] Hardware name: BCM5301X
[  918.781461] Backtrace: 
[  918.783938] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  918.791523]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[  918.797240] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[  918.804480] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  918.812587]  r5:00000009 r4:00000000
[  918.816184] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  918.824981]  r8:c72f10a4 r7:00000001 r6:c64f7b3c r5:00000000 r4:c6518c80
[  918.831764] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[  918.842243] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[  918.854870]  r8:c72f10a4 r7:bf1c8613 r6:c6518c80 r5:c04903c8 r4:c72f1394
[  918.861641] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[  918.873836]  r7:00000000 r6:c6518c80 r5:c72f10a4 r4:00000004
[  918.879578] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[  918.890296]  r10:00000014 r9:c7250800 r8:c64f7ca0 r7:c72de000 r6:c6518800 r5:00000000
[  918.898181]  r4:bf1ad460
[  918.900751] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[  918.909723]  r8:c5d50300 r7:c658b614 r6:bf170540 r5:bf1787d0 r4:00000000
[  918.916482] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[  918.924328]  r10:c5d50300 r9:00000000 r8:c64f7d84 r7:c6b0e400 r6:c0286ce0 r5:c5d50300
[  918.932214]  r4:c658b600
[  918.934761] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[  918.942258]  r7:c6b0e400 r6:c5d50300 r5:c5d50300 r4:c04a42a0
[  918.947965] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[  918.955637]  r5:00000048 r4:c7952000
[  918.959236] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[  918.967517]  r9:00000008 r8:00000000 r7:00000048 r6:c64f7f4c r5:c6b0e400 r4:00000000
[  918.975324] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[  918.983167]  r10:00000000 r9:00000000 r8:00000000 r7:c7544900 r6:c64f7e64 r5:00000000
[  918.991053]  r4:c64f7f4c
[  918.993598] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[  919.001529] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[  919.009375]  r10:00000000 r9:c64f6000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee617c0
[  919.017260]  r4:c7544900
[  919.019807] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[  919.027393]  r6:00003000 r5:00000000 r4:00000000
[  919.032046] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[  919.039829] ---[ end trace ab86393507c49518 ]---
[  919.044467] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):2
[  919.055542] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  919.062956] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7269780 skb->dev:c6518800 skb->dev->name:wlan1-2
[  919.072547] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c72693c0 skb->dev:c6518800 skb->dev->name:wlan1-2
[  919.082148] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c7269780 skb->dev:c6518800 skb->dev->name:wlan1-2
[  919.098449] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2
[  920.058595] ------------[ cut here ]------------
[  920.063473] WARNING: CPU: 1 PID: 1145 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[  920.079937] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  920.152313] CPU: 1 PID: 1145 Comm: hostapd Tainted: G        W       4.4.19 #0
[  920.159547] Hardware name: BCM5301X
[  920.163038] Backtrace: 
[  920.165515] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  920.173101]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[  920.178818] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[  920.186056] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  920.194164]  r5:00000009 r4:00000000
[  920.197761] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  920.206558]  r8:c5d50300 r7:00000001 r6:c64f7b74 r5:00000000 r4:c6518c80
[  920.213343] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[  920.223820] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[  920.236447]  r8:c5d50300 r7:bf1c85fc r6:c6518c80 r5:c04903c8 r4:c72f12f0
[  920.243218] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[  920.255240]  r7:c6518c80 r6:00000002 r5:c72f1254 r4:c72f1000
[  920.260981] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[  920.271699]  r7:c72de000 r6:c6518800 r5:c70c5620 r4:bf1ad370
[  920.277429] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[  920.286400]  r7:c70c5614 r6:bf170554 r5:bf1787d0 r4:00000000
[  920.292106] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[  920.299952]  r10:c5d50300 r9:00000000 r8:c64f7d84 r7:c6b0e400 r6:c0286ce0 r5:c5d50300
[  920.307837]  r4:c70c5600
[  920.310384] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[  920.317882]  r7:c6b0e400 r6:c5d50300 r5:c5d50300 r4:c04a42a0
[  920.323588] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[  920.331261]  r5:00000030 r4:c7952000
[  920.334859] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[  920.343141]  r9:00000008 r8:00000000 r7:00000030 r6:c64f7f4c r5:c6b0e400 r4:00000000
[  920.350947] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[  920.358790]  r10:00000000 r9:00000000 r8:00000000 r7:c7544900 r6:c64f7e64 r5:00000000
[  920.366677]  r4:c64f7f4c
[  920.369222] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[  920.377162] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[  920.385007]  r10:00000000 r9:c64f6000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee61790
[  920.392893]  r4:c7544900
[  920.395439] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[  920.403024]  r6:00003000 r5:00000000 r4:00000000
[  920.407678] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[  920.415462] ---[ end trace ab86393507c49519 ]---
[  920.420108] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):1
[  920.431188] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  920.438608] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c72693c0 skb->dev:c6518800 skb->dev->name:wlan1-2
[  921.488695] brcmfmac: CONSOLE: 027651.562 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[  921.498112] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c72693c0 skb->dev:c6518800 skb->dev->name:wlan1-2
[  943.599077] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7369480 brcmf_ifname(ifp):wlan1
[  943.609854] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70cd480 brcmf_ifname(ifp):wlan0
[  943.642073] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71a1480 brcmf_ifname(ifp):wlan1-1
[  943.859842] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6464c80 brcmf_ifname(ifp):wlan0-1
[  944.189138] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2
[  944.209834] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64cac80 brcmf_ifname(ifp):wlan0-2

[0] https://forum.openwrt.org/viewtopic.php?pid=335019#p335019
[1] http://www.snbforums.com/threads/alpha-builds-for-rt-ac88u-and-rt-ac3100.28024/#post-215754
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 66 +++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    | 15 ++++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  2 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 12 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  3 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 +
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |  2 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |  2 +-
 9 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 201a980..c7ccea5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -464,11 +464,12 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
+__send_key_to_dongle(const char *c0, struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
+	pr_info("[%s -> %s] ifp:%p brcmf_ifname(ifp):%s\n", c0, __func__, ifp, brcmf_ifname(ifp));
 	convert_key_from_CPU(key, &key_le);
 
 	brcmf_netdev_wait_pend8021x(ifp);
@@ -480,6 +481,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 		brcmf_err("wsec_key error (%d)\n", err);
 	return err;
 }
+#define send_key_to_dongle(ifp, key)	__send_key_to_dongle(__func__, ifp, key)
 
 static s32
 brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f02..cc02e3d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,6 +38,30 @@
 #include "pcie.h"
 #include "common.h"
 
+/* Free the driver packet. Free the tag if present */
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	if (ifp) {
+		struct skb_list *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == skb) {
+				pr_info("[%s -> %s] [ifp:%p] ***BUG*** skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	} else if (strcmp(c0, "brcmf_msgbuf_query_dcmd")) {
+		pr_info("[%s -> %s] [ifp:%p] Freeing skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, skb, skb->dev, skb->dev ? skb->dev->name : "---");
+	}
+
+	WARN_ON(skb->next);
+	dev_kfree_skb_any(skb);
+}
+
 #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
 
 #define BRCMF_BSSIDX_INVALID			-1
@@ -247,8 +271,17 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
+		struct skb_list *e;
+
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		e->skb = skb;
+
 		atomic_inc(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_add_tail(&e->list, &ifp->pend_8021x_skbs);
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
@@ -333,7 +366,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+		__brcmu_pkt_buf_free_skb(__func__, *ifp, skb);
 		return -ENODATA;
 	}
 
@@ -378,7 +411,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
 	struct ethhdr *eh;
 	u16 type;
@@ -387,7 +420,19 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
+		struct skb_list *e, *tmp;
+
 		atomic_dec(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry_safe(e, tmp, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == txp) {
+				if (e->timedout)
+					pr_info("[%s -> %s] Finally finalizing skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+				list_del(&e->list);
+				kfree(e);
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -476,6 +521,8 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 
 	atomic_set(&ifp->pend_8021x_cnt, 0);
+	INIT_LIST_HEAD(&ifp->pend_8021x_skbs);
+	mutex_init(&ifp->pend_8021x_mutex);
 
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
@@ -1170,6 +1217,19 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	WARN_ON(!err);
+	if (!err)
+		pr_info("[%s] ifp:%p brcmf_ifname(ifp):%s brcmf_get_pend_8021x_cnt(ifp):%d\n", __func__, ifp, brcmf_ifname(ifp), brcmf_get_pend_8021x_cnt(ifp));
+	if (!list_empty(&ifp->pend_8021x_skbs)) {
+		struct skb_list *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		pr_info("[%s] List of pending 802.1x skbs:\n", __func__);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			e->timedout = true;
+			pr_info("[%s] skb:%p skb->dev:%p skb->dev->name:%s\n", __func__, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8fa34ca..1509d4f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -50,6 +50,9 @@
 
 #define NDOL_MAX_ENTRIES	8
 
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb);
+#define brcmu_pkt_buf_free_skb(skb)	__brcmu_pkt_buf_free_skb(__func__, ifp, skb)
+
 /**
  * struct brcmf_ampdu_rx_reorder - AMPDU receive reorder info
  *
@@ -169,6 +172,12 @@ enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
+struct skb_list {
+	struct sk_buff *skb;
+	bool timedout;
+	struct list_head list;
+};
+
 /**
  * struct brcmf_if - interface control information.
  *
@@ -203,6 +212,9 @@ struct brcmf_if {
 	u8 netif_stop;
 	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
+	struct list_head pend_8021x_skbs;
+	struct mutex pend_8021x_mutex;
+	bool pend_8021x_ready;
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
@@ -219,7 +231,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+#define brcmf_txfinalize(ifp, txp, success)	__brcmf_txfinalize(__func__, ifp, txp, success)
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 7e269f9..87c8de0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -249,6 +249,8 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 
 	skb = skb_dequeue(&ring->skblist);
 	while (skb) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmu_pkt_buf_free_skb(skb);
 		skb = skb_dequeue(&ring->skblist);
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 9f9024a..41dd3fb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -590,6 +590,8 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 	for (prec = 0; prec < q->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
 			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		}
@@ -697,6 +699,8 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 		    s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
 			skb = h->items[i].pkt;
 			if (fn == NULL || fn(skb, &ifidx)) {
+				struct brcmf_if *ifp = NULL;
+
 				/* suppress packets freed from psq */
 				if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE)
 					brcmu_pkt_buf_free_skb(skb);
@@ -845,6 +849,8 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	for (prec = 0; prec < txq->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 			hi = &fws->hanger.items[hslot];
 			WARN_ON(skb != hi->pkt);
@@ -971,8 +977,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		brcmf_fws_unlock(fws);
 		err = brcmf_proto_txdata(fws->drvr, ifidx, data_offset, skb);
 		brcmf_fws_lock(fws);
-		if (err)
+		if (err) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
+		}
 		return true;
 	}
 	return false;
@@ -2454,6 +2463,7 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
+	struct brcmf_if *ifp = NULL;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 2b9a2bc..e47f5a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -392,6 +392,8 @@ brcmf_msgbuf_release_array(struct device *dev,
 	count = 0;
 	do {
 		if (array[count].allocated.counter) {
+			struct brcmf_if *ifp = NULL;
+
 			pktid = &array[count];
 			dma_unmap_single(dev, pktid->physaddr,
 					 pktid->skb->len - pktid->data_offset,
@@ -483,6 +485,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
+	struct brcmf_if *ifp = NULL;
 	int timeout;
 	int err;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 2f978a3..edbe353 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -498,6 +498,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 {
 	struct brcmf_usbreq  *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
+	struct brcmf_if *ifp = NULL;
 	struct sk_buff *skb;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
@@ -548,6 +549,8 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
index 0543607..bf525b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
@@ -49,7 +49,7 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 	WARN_ON(skb->next);
 	dev_kfree_skb_any(skb);
 }
-EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
+//EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
 /*
  * osl multiple-precedence packet queue
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
index 4196952..7bd705d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
@@ -126,7 +126,7 @@ struct sk_buff *brcmu_pktq_pdeq_match(struct pktq *pq, int prec,
 
 /* packet primitives */
 struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
-void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
+//void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
 /* callback function fn(pkt, arg) returns true if pkt belongs to if */
-- 
2.9.3
