Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35348 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcINInU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:43:20 -0400
Received: by mail-lf0-f53.google.com with SMTP id l131so4881014lfl.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2016 01:43:18 -0700 (PDT)
Subject: Re: AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <20160914054528.28717-1-zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <06f9b0f6-1c29-2acb-7ca4-604a9018f753@gmail.com> (sfid-20160914_104327_107277_F5DB0D68)
Date: Wed, 14 Sep 2016 10:43:14 +0200
MIME-Version: 1.0
In-Reply-To: <20160914054528.28717-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2016 07:45 AM, Rafał Miłecki wrote:
> First of all, I can't reproduce these problems reliably. One evening I
> got WARNINGs one by one and I could work on my debugging patch easily.
> Yesterday when I got my patch complete, it took me 10+ hours to get a
> single WARNING.

I think I found a way to reproduce this more reliably! It seems doing a static
transfer from few devices (I use iperf) doesn't matter much. So this is what I
do to get WARNINGs on my DIR-885L:
1) Notebook sending data with iperf to DIR-885L
2) iPad playing YouTube using SR400ac on the same channel
3) I take my 2 smartphones to the next room and keep switching between 2 out of
    3 SSIDs of DIR-885L. Once connected I run iperf for a bit randomly.

It seems I can get a WARNINGs every few minutes this way.


> Enough talking, please take a look at my debugging log. Does it give you
> enough hint? Could you review/debug firmware's code responsible for
> AMPDU? FWIW Merlin users (so no brcmfmac invovled) also saw this [1].

I grabbed more logs I can share now. I believe they show the same: stall and
warning soon after ampdu_dbg/wlc_ampdu_watchdog. I'm attaching them anyway.

Please note that calls to __send_key_to_dongle happen all the time, I'm
including them in logs for a context. You can treat them as an indicator that
things are going well.
It's ampdu_dbg + wlc_ampdu_watchdog that lead up to the WARNINGs.


[ 1213.809245] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1213.819946] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1214.029819] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1214.359083] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1214.389756] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1215.581850] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: wl0.2 scb:00343a08 tid:0
[ 1215.589269] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x1a fifordy 0x2 cpbusy 0x0
[ 1215.603896] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: ifsstat 0x18a0 nav_stat 0x0 txop 24973
[ 1215.612317] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: pktpend: 0 32 0 0 0 ap 1
[ 1215.619540] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: txall 4821 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
[ 1215.629381] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 4 0 4 0 0 ifs_boff 5
[ 1215.639015] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: again1 ifsstat 0xa0 nav_stat 0x0
[ 1215.646906] brcmfmac: CONSOLE: 027945.032 ampdu_dbg: again2 ifsstat 0x18a0 nav_stat 0x0
[ 1215.655024] brcmfmac: CONSOLE: 027945.032 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[ 1215.667206] brcmfmac: CONSOLE: 027945.032 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1217.368721] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1218.328557] ------------[ cut here ]------------
[ 1218.333232] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1218.349366] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1218.421716] CPU: 1 PID: 1130 Comm: hostapd Not tainted 4.4.19 #0
[ 1218.427735] Hardware name: BCM5301X
[ 1218.431225] Backtrace:
[ 1218.433699] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1218.441287]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1218.447003] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1218.454243] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1218.462349]  r5:00000009 r4:00000000
[ 1218.465948] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1218.474754]  r8:c72ce0a4 r7:00000001 r6:c6b8fb3c r5:00000000 r4:c64d3480
[ 1218.481533] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1218.492006] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1218.504633]  r8:c72ce0a4 r7:bf1c8613 r6:c64d3480 r5:c04903c8 r4:c72ce394
[ 1218.511404] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1218.523599]  r7:00000000 r6:c64d3480 r5:c72ce0a4 r4:00000004
[ 1218.529341] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1218.540059]  r10:00000014 r9:c735ec00 r8:c6b8fca0 r7:c696c000 r6:c64d3000 r5:00000000
[ 1218.547944]  r4:bf1ad460
[ 1218.550514] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1218.559487]  r8:c66663c0 r7:c6b42e14 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1218.566246] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1218.574091]  r10:c66663c0 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c66663c0
[ 1218.581977]  r4:c6b42e00
[ 1218.584524] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1218.592022]  r7:c6516400 r6:c66663c0 r5:c66663c0 r4:c04a42a0
[ 1218.597728] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1218.605400]  r5:00000048 r4:c799a000
[ 1218.609000] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1218.617281]  r9:00000008 r8:00000000 r7:00000048 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1218.625087] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1218.632930]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1218.640816]  r4:c6b8ff4c
[ 1218.643361] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1218.651292] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1218.659139]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee037c0
[ 1218.667024]  r4:c7536a80
[ 1218.669571] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1218.677156]  r6:b6f0a1c8 r5:00000000 r4:00000000
[ 1218.681810] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1218.689603] ---[ end trace e3199c520974d43f ]---
[ 1218.694230] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 1218.705307] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1218.712730] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c647ee40 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1218.722321] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c72369c0 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1218.731912] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b99180 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1218.744839] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1219.708556] ------------[ cut here ]------------
[ 1219.713235] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1219.729367] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1219.801736] CPU: 1 PID: 1130 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1219.808973] Hardware name: BCM5301X
[ 1219.812462] Backtrace:
[ 1219.814937] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1219.822524]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1219.828241] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1219.835480] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1219.843587]  r5:00000009 r4:00000000
[ 1219.847185] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1219.855982]  r8:c739dd80 r7:00000001 r6:c6b8fb74 r5:00000000 r4:c64d3480
[ 1219.862760] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1219.873234] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1219.885862]  r8:c739dd80 r7:bf1c85fc r6:c64d3480 r5:c04903c8 r4:c72ce2f0
[ 1219.892633] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 1219.904654]  r7:c64d3480 r6:00000002 r5:c72ce254 r4:c72ce000
[ 1219.910396] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 1219.921114]  r7:c696c000 r6:c64d3000 r5:c650f220 r4:bf1ad370
[ 1219.926844] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1219.935824]  r7:c650f214 r6:bf170554 r5:bf1787d0 r4:00000000
[ 1219.941530] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1219.949376]  r10:c739dd80 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c739dd80
[ 1219.957261]  r4:c650f200
[ 1219.959809] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1219.967306]  r7:c6516400 r6:c739dd80 r5:c739dd80 r4:c04a42a0
[ 1219.973012] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1219.980685]  r5:00000030 r4:c799a000
[ 1219.984284] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1219.992565]  r9:00000008 r8:00000000 r7:00000030 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1220.000371] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1220.008214]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1220.016100]  r4:c6b8ff4c
[ 1220.018646] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1220.026576] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1220.034422]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee03790
[ 1220.042309]  r4:c7536a80
[ 1220.044854] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1220.052440]  r6:b6f0a1c8 r5:00000000 r4:00000000
[ 1220.057094] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1220.064881] ---[ end trace e3199c520974d440 ]---
[ 1220.069529] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 1220.080605] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1220.088016] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c647ee40 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1220.097606] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c72369c0 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1220.107197] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b99180 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1222.597085] brcmfmac: CONSOLE: 027952.044 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1222.606543] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c647ee40 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1222.619911] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c72369c0 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1222.633274] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b99180 skb->dev:c64d3000 skb->dev->name:wlan1-1
[ 1243.839113] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1243.850070] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1244.049797] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1244.379059] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1244.409084] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1244.532211] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1244.672407] brcmfmac: CONSOLE: 027974.121 wl0.2: wlc_send_bar: seq 0xd96 tid 0


[ 1419.521703] brcmfmac: CONSOLE: 028148.962 wl0: wlc_ampdu_rx_recv_delba: AMPDU OFF: tid 0 initiator 1 reason 39
[ 1420.346975] brcmfmac: CONSOLE: 028149.786 wl0.3: wlc_send_bar: seq 0x1 tid 6
[ 1423.166160] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: wl0.3 scb:00344c30 tid:0
[ 1423.173521] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: wl0.3 dead_cnt 2 tx_in_transit 1 psm_mux 0x200 aqmqmap 0x0x101 aqmfifo_status 0x0x1 fifordy 0x2 cpbusy 0x0
[ 1423.187872] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: ifsstat 0x1da0 nav_stat 0x0 txop 27528
[ 1423.196289] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: pktpend: 0 1 0 0 0 ap 1
[ 1423.203434] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: txall 5454 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
[ 1423.213266] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 8 0 8 0 0 ifs_boff 0
[ 1423.222905] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: again1 ifsstat 0x1d80 nav_stat 0x0
[ 1423.230972] brcmfmac: CONSOLE: 028152.603 ampdu_dbg: again2 ifsstat 0x1d80 nav_stat 0x0
[ 1423.239081] brcmfmac: CONSOLE: 028152.603 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[ 1423.251255] brcmfmac: CONSOLE: 028152.603 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1423.989156] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1424.000369] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1424.018123] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1424.170006] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1424.529823] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1427.958783] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1428.918558] ------------[ cut here ]------------
[ 1428.923235] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1428.939369] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1429.011756] CPU: 1 PID: 1130 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1429.018992] Hardware name: BCM5301X
[ 1429.022481] Backtrace:
[ 1429.024957] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1429.032544]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1429.038261] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1429.045499] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1429.053606]  r5:00000009 r4:00000000
[ 1429.057205] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1429.066010]  r8:c71c8148 r7:00000001 r6:c6b8fb3c r5:00000000 r4:c65a0480
[ 1429.072791] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1429.083263] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1429.095891]  r8:c71c8148 r7:bf1c8613 r6:c65a0480 r5:c04903c8 r4:c71c8438
[ 1429.102661] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1429.114857]  r7:00000000 r6:c65a0480 r5:c71c8148 r4:00000004
[ 1429.120598] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1429.131317]  r10:00000014 r9:c735ec00 r8:c6b8fca0 r7:c696c000 r6:c65a0000 r5:00000000
[ 1429.139201]  r4:bf1ad460
[ 1429.141771] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1429.150743]  r8:c731ee40 r7:c6a5e614 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1429.157503] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1429.165348]  r10:c731ee40 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c731ee40
[ 1429.173235]  r4:c6a5e600
[ 1429.175781] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1429.183279]  r7:c6516400 r6:c731ee40 r5:c731ee40 r4:c04a42a0
[ 1429.188985] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1429.196657]  r5:00000048 r4:c799a000
[ 1429.200256] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1429.208537]  r9:00000008 r8:00000000 r7:00000048 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1429.216344] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1429.224187]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1429.232073]  r4:c6b8ff4c
[ 1429.234618] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1429.242558] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1429.250404]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee037c0
[ 1429.258290]  r4:c7536a80
[ 1429.260836] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1429.268422]  r6:00000006 r5:00000000 r4:00000000
[ 1429.273075] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1429.280917] ---[ end trace e3199c520974d441 ]---
[ 1429.285548] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):1
[ 1429.296627] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1429.304048] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c64e5d80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1429.316441] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1430.278565] ------------[ cut here ]------------
[ 1430.283245] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1430.299380] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1430.371763] CPU: 1 PID: 1130 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1430.379000] Hardware name: BCM5301X
[ 1430.382491] Backtrace:
[ 1430.384965] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1430.392552]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1430.398269] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1430.405508] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1430.413615]  r5:00000009 r4:00000000
[ 1430.417213] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1430.426010]  r8:c64b90c0 r7:00000001 r6:c6b8fb74 r5:00000000 r4:c65a0480
[ 1430.432789] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1430.443262] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1430.455891]  r8:c64b90c0 r7:bf1c85fc r6:c65a0480 r5:c04903c8 r4:c71c82f0
[ 1430.462661] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 1430.474682]  r7:c65a0480 r6:00000002 r5:c71c8254 r4:c71c8000
[ 1430.480423] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 1430.491142]  r7:c696c000 r6:c65a0000 r5:c7389d20 r4:bf1ad370
[ 1430.496870] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1430.505842]  r7:c7389d14 r6:bf170554 r5:bf1787d0 r4:00000000
[ 1430.511550] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1430.519394]  r10:c64b90c0 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c64b90c0
[ 1430.527281]  r4:c7389d00
[ 1430.529827] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1430.537324]  r7:c6516400 r6:c64b90c0 r5:c64b90c0 r4:c04a42a0
[ 1430.543031] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1430.550702]  r5:00000030 r4:c799a000
[ 1430.554304] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1430.562583]  r9:00000008 r8:00000000 r7:00000030 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1430.570391] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1430.578234]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1430.586120]  r4:c6b8ff4c
[ 1430.588665] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1430.596604] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1430.604450]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee03790
[ 1430.612336]  r4:c7536a80
[ 1430.614882] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1430.622467]  r6:00000006 r5:00000000 r4:00000000
[ 1430.627121] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1430.634935] ---[ end trace e3199c520974d442 ]---
[ 1430.639574] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):1
[ 1430.650650] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1430.658061] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c64e5d80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1433.091596] brcmfmac: CONSOLE: 028162.527 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1433.151731] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c64e5d80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1445.329593] brcmfmac: CONSOLE: 028174.764 wl0.3: wlc_send_bar: seq 0xc6e tid 0
[ 1446.332452] brcmfmac: CONSOLE: 028175.767 wl0.3: wlc_send_bar: seq 0xc6f tid 0
[ 1454.009194] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1454.020432] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1454.121584] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1454.189851] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1454.549783] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1454.561299] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2


[ 1604.139419] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1604.150635] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1604.238314] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1604.289129] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1604.659083] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1605.551886] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: wl0.3 scb:00344060 tid:0
[ 1605.559253] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: wl0.3 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x1 fifordy 0x2 cpbusy 0x0
[ 1605.573688] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: ifsstat 0x1d80 nav_stat 0x0 txop 31752
[ 1605.582096] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: pktpend: 0 1 0 0 0 ap 1
[ 1605.589224] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: txall 5893 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
[ 1605.599049] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 13 0 13 0 0 ifs_boff 0
[ 1605.608861] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: again1 ifsstat 0x1ea0 nav_stat 0x0
[ 1605.616923] brcmfmac: CONSOLE: 028334.964 ampdu_dbg: again2 ifsstat 0xa0 nav_stat 0x0
[ 1605.624853] brcmfmac: CONSOLE: 028334.964 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[ 1605.637027] brcmfmac: CONSOLE: 028334.964 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1607.988759] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1608.948558] ------------[ cut here ]------------
[ 1608.953229] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1608.969361] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1609.041801] CPU: 1 PID: 1130 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1609.049036] Hardware name: BCM5301X
[ 1609.052528] Backtrace:
[ 1609.055001] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1609.062581]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1609.068297] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1609.075537] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1609.083643]  r5:00000009 r4:00000000
[ 1609.087241] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1609.096038]  r8:c71c8148 r7:00000001 r6:c6b8fb3c r5:00000000 r4:c65a0480
[ 1609.102820] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1609.113292] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1609.125920]  r8:c71c8148 r7:bf1c8613 r6:c65a0480 r5:c04903c8 r4:c71c8438
[ 1609.132689] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1609.144885]  r7:00000000 r6:c65a0480 r5:c71c8148 r4:00000004
[ 1609.150626] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1609.161345]  r10:00000014 r9:c735ec00 r8:c6b8fca0 r7:c696c000 r6:c65a0000 r5:00000000
[ 1609.169230]  r4:bf1ad460
[ 1609.171800] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1609.180771]  r8:c731e9c0 r7:c69b7414 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1609.187533] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1609.195378]  r10:c731e9c0 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c731e9c0
[ 1609.203263]  r4:c69b7400
[ 1609.205810] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1609.213307]  r7:c6516400 r6:c731e9c0 r5:c731e9c0 r4:c04a42a0
[ 1609.219014] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1609.226685]  r5:00000048 r4:c799a000
[ 1609.230286] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1609.238567]  r9:00000008 r8:00000000 r7:00000048 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1609.246372] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1609.254216]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1609.262102]  r4:c6b8ff4c
[ 1609.264647] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1609.272577] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1609.280423]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee037c0
[ 1609.288310]  r4:c7536a80
[ 1609.290855] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1609.298441]  r6:00000006 r5:00000000 r4:00000000
[ 1609.303095] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1609.310876] ---[ end trace e3199c520974d443 ]---
[ 1609.315507] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):3
[ 1609.326581] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1609.333997] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c681f3c0 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1609.343589] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7116900 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1609.353185] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7361a80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1609.365870] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
[ 1610.328562] ------------[ cut here ]------------
[ 1610.333240] WARNING: CPU: 1 PID: 1130 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1610.349374] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1610.421742] CPU: 1 PID: 1130 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1610.428977] Hardware name: BCM5301X
[ 1610.432469] Backtrace:
[ 1610.434943] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1610.442529]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 1610.448246] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1610.455486] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1610.463593]  r5:00000009 r4:00000000
[ 1610.467191] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1610.475987]  r8:c65b0840 r7:00000001 r6:c6b8fb74 r5:00000000 r4:c65a0480
[ 1610.482769] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1610.493241] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1610.505869]  r8:c65b0840 r7:bf1c85fc r6:c65a0480 r5:c04903c8 r4:c71c82f0
[ 1610.512639] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 1610.524660]  r7:c65a0480 r6:00000002 r5:c71c8254 r4:c71c8000
[ 1610.530402] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 1610.541120]  r7:c696c000 r6:c65a0000 r5:c650fd20 r4:bf1ad370
[ 1610.546848] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1610.555821]  r7:c650fd14 r6:bf170554 r5:bf1787d0 r4:00000000
[ 1610.561527] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1610.569373]  r10:c65b0840 r9:00000000 r8:c6b8fd84 r7:c6516400 r6:c0286ce0 r5:c65b0840
[ 1610.577258]  r4:c650fd00
[ 1610.579806] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1610.587303]  r7:c6516400 r6:c65b0840 r5:c65b0840 r4:c04a42a0
[ 1610.593010] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1610.600682]  r5:00000030 r4:c799a000
[ 1610.604282] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1610.612561]  r9:00000008 r8:00000000 r7:00000030 r6:c6b8ff4c r5:c6516400 r4:00000000
[ 1610.620368] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1610.628212]  r10:00000000 r9:00000000 r8:00000000 r7:c7536a80 r6:c6b8fe64 r5:00000000
[ 1610.636098]  r4:c6b8ff4c
[ 1610.638643] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1610.646582] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1610.654428]  r10:00000000 r9:c6b8e000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee03790
[ 1610.662315]  r4:c7536a80
[ 1610.664861] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1610.672446]  r6:00000006 r5:00000000 r4:00000000
[ 1610.677100] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1610.684897] ---[ end trace e3199c520974d444 ]---
[ 1610.689536] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):3
[ 1610.700612] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1610.708021] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c681f3c0 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1610.717611] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7116900 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1610.727202] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7361a80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1612.571349] brcmfmac: CONSOLE: 028341.979 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1612.580961] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c681f3c0 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1612.594343] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c7116900 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1612.607715] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c7361a80 skb->dev:c65a0000 skb->dev->name:wlan1-2
[ 1634.169780] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c780ec80 brcmf_ifname(ifp):wlan0
[ 1634.180374] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c695bc80 brcmf_ifname(ifp):wlan1
[ 1634.309650] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c1c80 brcmf_ifname(ifp):wlan0-1
[ 1634.346305] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64d3480 brcmf_ifname(ifp):wlan1-1
[ 1634.679761] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64c5c80 brcmf_ifname(ifp):wlan0-2
[ 1635.294903] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c65a0480 brcmf_ifname(ifp):wlan1-2
