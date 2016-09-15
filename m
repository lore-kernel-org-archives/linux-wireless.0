Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34052 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756187AbcIOLtW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 07:49:22 -0400
Received: by mail-lf0-f67.google.com with SMTP id k12so1984717lfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2016 04:49:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs
Date: Thu, 15 Sep 2016 13:48:36 +0200
Message-Id: <20160915114836.12364-1-zajec5@gmail.com> (sfid-20160915_134928_824193_FA2DA213)
In-Reply-To: <3220e8ef-ee12-0b98-832a-819f980634c7@broadcom.com>
References: <3220e8ef-ee12-0b98-832a-819f980634c7@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2016 08:28 PM, Arend Van Spriel wrote:
> On 14-9-2016 7:45, Rafał Miłecki wrote:
>> Even with the most recent brcmfmac code ppl keep seeing WARNINGs from
>> brcmf_netdev_wait_pend8021x [0].
>>
>> Hante suggested using CONSOLE for debugging some firmware crash so I
>> decided to see I it could also help understanding WARNINGs. I believe it
>> did.
>>
>> First of all, I can't reproduce these problems reliably. One evening I
>> got WARNINGs one by one and I could work on my debugging patch easily.
>> Yesterday when I got my patch complete, it took me 10+ hours to get a
>> single WARNING.
>>
>> Anyway, it seems to me that sometimes AMPDU stalls in the firmware. It
>> seems firmware has some AMPDU watchdog that notices the problem and
>> kicks in. It prints some debugging info and starts cleaning up process.
>>
>> If brcmf_netdev_wait_pend8021x gets called shortly after that (I set
>> wpa_group_rekey=30 in hostapd to get brcmf_cfg80211_add_key called more
>> often) it results in a WARNING.
>>
>> For better debugging I wrote brcmfmac patch that:
>> 1) Keeps track of every 802.1x skb submitted to the device
>> 2) During WARNING it prints skbs and marks them as timedout
>> 3) It informs when timedout skb gets finally reported as sent
>>
>> Enough talking, please take a look at my debugging log. Does it give you
>> enough hint? Could you review/debug firmware's code responsible for
>> AMPDU? FWIW Merlin users (so no brcmfmac invovled) also saw this [1].
>>
>> [  913.569121] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7369480 brcmf_ifname(ifp):wlan1
>> [  913.579521] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70cd480 brcmf_ifname(ifp):wlan0
>> [  913.627346] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71a1480 brcmf_ifname(ifp):wlan1-1
>> [  913.839833] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6464c80 brcmf_ifname(ifp):wlan0-1
>> [  914.179775] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64cac80 brcmf_ifname(ifp):wlan0-2
>> [  914.191129] brcmfmac: CONSOLE: 027644.261 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.198474] brcmfmac: CONSOLE: 027644.266 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.206020] brcmfmac: CONSOLE: 027644.273 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.215243] brcmfmac: CONSOLE: 027644.284 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.224521] brcmfmac: CONSOLE: 027644.294 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.231878] brcmfmac: CONSOLE: 027644.298 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.239425] brcmfmac: CONSOLE: 027644.307 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.248444] brcmfmac: CONSOLE: 027644.318 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.257163] brcmfmac: CONSOLE: 027644.326 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.266616] brcmfmac: CONSOLE: 027644.336 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.274072] brcmfmac: CONSOLE: 027644.341 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.284716] brcmfmac: CONSOLE: 027644.354 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.291962] brcmfmac: CONSOLE: 027644.359 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.299172] brcmfmac: CONSOLE: 027644.364 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.306646] brcmfmac: CONSOLE: 027644.371 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.314058] brcmfmac: CONSOLE: 027644.380 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.323193] brcmfmac: CONSOLE: 027644.393 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.330640] brcmfmac: CONSOLE: 027644.400 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.340886] brcmfmac: CONSOLE: 027644.410 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.352975] brcmfmac: CONSOLE: 027644.422 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.365365] brcmfmac: CONSOLE: 027644.434 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.372790] brcmfmac: CONSOLE: 027644.440 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.384982] brcmfmac: CONSOLE: 027644.454 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.395488] brcmfmac: CONSOLE: 027644.465 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.402977] brcmfmac: CONSOLE: 027644.471 wl0.3: wlc_send_bar: seq 0x3 tid 0
>> [  914.701404] brcmfmac: CONSOLE: 027644.771 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.710513] brcmfmac: CONSOLE: 027644.780 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.717731] brcmfmac: CONSOLE: 027644.787 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.728099] brcmfmac: CONSOLE: 027644.798 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.737616] brcmfmac: CONSOLE: 027644.807 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.745320] brcmfmac: CONSOLE: 027644.815 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.757985] brcmfmac: CONSOLE: 027644.827 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.765457] brcmfmac: CONSOLE: 027644.833 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.772729] brcmfmac: CONSOLE: 027644.841 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.781407] brcmfmac: CONSOLE: 027644.851 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.789268] brcmfmac: CONSOLE: 027644.859 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.796754] brcmfmac: CONSOLE: 027644.866 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.808174] brcmfmac: CONSOLE: 027644.878 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  914.818975] brcmfmac: CONSOLE: 027644.888 wl0.3: wlc_send_bar: seq 0x4 tid 0
>> [  917.077991] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: wl0.3 scb:00347c74 tid:0 
>> [  917.085368] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: wl0.3 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
>> [  917.100070] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: ifsstat 0xaf nav_stat 0x0 txop 30788
>> [  917.108303] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: pktpend: 0 2 0 0 0 ap 1
>> [  917.115434] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: txall 5901 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
>> [  917.125265] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 9 0 9 0 0 ifs_boff 0
>> [  917.134907] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: again1 ifsstat 0xaf nav_stat 0x0
>> [  917.142806] brcmfmac: CONSOLE: 027647.149 ampdu_dbg: again2 ifsstat 0xaf nav_stat 0x0
>> [  917.150739] brcmfmac: CONSOLE: 027647.149 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
>> [  917.162912] brcmfmac: CONSOLE: 027647.149 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
>> [  917.718723] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2
>> [  918.678558] ------------[ cut here ]------------
>> [  918.683329] WARNING: CPU: 1 PID: 1145 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
>> [  918.699599] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
>> [  918.771954] CPU: 1 PID: 1145 Comm: hostapd Not tainted 4.4.19 #0
>> [  918.777971] Hardware name: BCM5301X
>> [  918.781461] Backtrace: 
>> [  918.783938] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
>> [  918.791523]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
>> [  918.797240] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
>> [  918.804480] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
>> [  918.812587]  r5:00000009 r4:00000000
>> [  918.816184] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
>> [  918.824981]  r8:c72f10a4 r7:00000001 r6:c64f7b3c r5:00000000 r4:c6518c80
>> [  918.831764] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
>> [  918.842243] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
>> [  918.854870]  r8:c72f10a4 r7:bf1c8613 r6:c6518c80 r5:c04903c8 r4:c72f1394
>> [  918.861641] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
>> [  918.873836]  r7:00000000 r6:c6518c80 r5:c72f10a4 r4:00000004
>> [  918.879578] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
>> [  918.890296]  r10:00000014 r9:c7250800 r8:c64f7ca0 r7:c72de000 r6:c6518800 r5:00000000
>> [  918.898181]  r4:bf1ad460
>> [  918.900751] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
>> [  918.909723]  r8:c5d50300 r7:c658b614 r6:bf170540 r5:bf1787d0 r4:00000000
>> [  918.916482] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
>> [  918.924328]  r10:c5d50300 r9:00000000 r8:c64f7d84 r7:c6b0e400 r6:c0286ce0 r5:c5d50300
>> [  918.932214]  r4:c658b600
>> [  918.934761] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
>> [  918.942258]  r7:c6b0e400 r6:c5d50300 r5:c5d50300 r4:c04a42a0
>> [  918.947965] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
>> [  918.955637]  r5:00000048 r4:c7952000
>> [  918.959236] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
>> [  918.967517]  r9:00000008 r8:00000000 r7:00000048 r6:c64f7f4c r5:c6b0e400 r4:00000000
>> [  918.975324] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
>> [  918.983167]  r10:00000000 r9:00000000 r8:00000000 r7:c7544900 r6:c64f7e64 r5:00000000
>> [  918.991053]  r4:c64f7f4c
>> [  918.993598] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
>> [  919.001529] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
>> [  919.009375]  r10:00000000 r9:c64f6000 r8:c00098c4 r7:00000128 r6:00000000 r5:bee617c0
>> [  919.017260]  r4:c7544900
>> [  919.019807] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
>> [  919.027393]  r6:00003000 r5:00000000 r4:00000000
>> [  919.032046] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
>> [  919.039829] ---[ end trace ab86393507c49518 ]---
>> [  919.044467] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c6518c80 brcmf_ifname(ifp):wlan1-2 brcmf_get_pend_8021x_cnt(ifp):2
>> [  919.055542] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
>> [  919.062956] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7269780 skb->dev:c6518800 skb->dev->name:wlan1-2
>> [  919.072547] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c72693c0 skb->dev:c6518800 skb->dev->name:wlan1-2
> 
> Hi Rafal,
> 
> Surprised to see those ampdu_dbg messages in official firmware release.

Well, I'm somehow glad they make it into the official firmware. It at least
allowed understanding what causes these delays (A-MPDU issue). They indeed don't
seem to be present in 43602a1 firmware so I can only guess it suffers from the
same problem.


> It would be great to have a timestamp for these skb when they arrive in
> brcmfmac or transferred to firmware (or both).

You ask and you have it :) I saved kernel's local time and printed it the same
way print_time function does it. Let me paste the most important lines:
[ 1876.496770] brcmfmac: CONSOLE: 028605.731 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[ 1877.958898] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1878.923359] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1256 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1880.659840] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 1880.670922] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1880.678333] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1880.687935] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1880.697530] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1881.439614] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1874.928858]; commit_time:[ 1874.928994])
[ 1881.457852] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1875.938806]; commit_time:[ 1875.938858])
[ 1881.476074] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1876.948805]; commit_time:[ 1876.948855])

For the first skb brcmf_netdev_start_xmit was called at 1874.928858.
It was commited to firmware with brcmf_msgbuf_txflow at 1874.928994.
Then there was A-MPDU hang in firmware.
Finally brcmf_msgbuf_process_txstatus was called and it called
brcmf_txfinalize and this one logged everything at 1881.439614.

You'll find full log at the end.


> The obvious solution would be to increase the pend8021x timeout in
> brcmfmac. Probably another solution would be to exclude EAPOL frames
> from A-MPDU in firmware. That still does not solve the A-MPDU stall.

For me the most obvious solution would be to fix A-MPDU problem in the firmware.
Of course that would require releasing updated firmware and ppl switching to it.
It still sounds like a desired long term solution.

I don't think we want few second stalls in communication with AP. Moreover Hante
seemed to be worried clients can get totally disconnected which would make
things even worse:
> This waiting uses a timeout (950ms) and in this case the timeout expired. It
> will most likely result in a situation where client and AP wont have the same
> keys anymore and eventually the client will disconnect en reconnect.

If xmit of skb was started at 1874.928858 and we got TX status at 1881.439614
that's 6-7 seconds of delay. Quite a lot so I really would prefer a *fix*
instead of workaround hiding the problem.


[ 1874.409157] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6970c80 brcmf_ifname(ifp):wlan1
[ 1874.499840] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c79d5480 brcmf_ifname(ifp):wlan0
[ 1874.579199] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64b0480 brcmf_ifname(ifp):wlan1-2
[ 1874.599201] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c79d0c80 brcmf_ifname(ifp):wlan0-1
[ 1874.719154] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6aac480 brcmf_ifname(ifp):wlan0-2
[ 1876.423494] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: wl0.2 scb:00345ba8 tid:0 
[ 1876.430873] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: wl0.2 dead_cnt 2 tx_in_transit 1 psm_mux 0xfff0 aqmqmap 0x0x101 aqmfifo_status 0x0x4000 fifordy 0x0 cpbusy 0x0
[ 1876.445571] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: ifsstat 0x1d80 nav_stat 0x0 txop 31893
[ 1876.453990] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: pktpend: 0 0 0 0 0 ap 1
[ 1876.461122] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: txall 5836 txbcn 0 txrts 0 rxcts 0 rsptmout 0 rxstrt 0
[ 1876.470948] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: cwcur0-3 f f 7 3 bslots cur/0-3 6 0 0 0 0 ifs_boff 0
[ 1876.480586] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: again1 ifsstat 0x1ea0 nav_stat 0x0
[ 1876.488657] brcmfmac: CONSOLE: 028605.731 ampdu_dbg: again2 ifsstat 0x1ea0 nav_stat 0x0
[ 1876.496770] brcmfmac: CONSOLE: 028605.731 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
[ 1876.508943] brcmfmac: CONSOLE: 028605.731 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1877.958898] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1878.918681] ------------[ cut here ]------------
[ 1878.923359] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1256 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1878.939505] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1879.011922] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1879.019157] Hardware name: BCM5301X
[ 1879.022647] Backtrace: 
[ 1879.025124] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1879.032710]  r7:000004e8 r6:bf1d12cf r5:60000013 r4:00000000
[ 1879.038428] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1879.045667] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1879.053773]  r5:00000009 r4:00000000
[ 1879.057371] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1879.066176]  r8:c79050a4 r7:00000001 r6:c6471b3c r5:00000000 r4:c71c5480
[ 1879.072960] [<c002153c>] (warn_slowpath_null) from [<bf1be784>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1879.083444] [<bf1be6c8>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1879.096075]  r8:c79050a4 r7:bf1c8927 r6:c71c5480 r5:c04903c8 r4:c7905394
[ 1879.102848] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1879.115050]  r7:00000000 r6:c71c5480 r5:c79050a4 r4:00000004
[ 1879.120793] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1879.131509]  r10:00000014 r9:c79da800 r8:c6471ca0 r7:c7306000 r6:c71c5000 r5:00000000
[ 1879.139394]  r4:bf1ad460
[ 1879.141976] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1879.150953]  r8:c721f780 r7:c695e414 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1879.157716] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1879.165558]  r10:c721f780 r9:00000000 r8:c6471d84 r7:c72e0800 r6:c0286ce0 r5:c721f780
[ 1879.173444]  r4:c695e400
[ 1879.175991] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1879.183489]  r7:c72e0800 r6:c721f780 r5:c721f780 r4:c04a42a0
[ 1879.189194] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1879.196866]  r5:00000048 r4:c7952000
[ 1879.200467] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1879.208747]  r9:00000008 r8:00000000 r7:00000048 r6:c6471f4c r5:c72e0800 r4:00000000
[ 1879.216554] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1879.224396]  r10:00000000 r9:00000000 r8:00000000 r7:c7507c80 r6:c6471e64 r5:00000000
[ 1879.232283]  r4:c6471f4c
[ 1879.234829] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1879.242767] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1879.250613]  r10:00000000 r9:c6470000 r8:c00098c4 r7:00000128 r6:00000000 r5:beb207c0
[ 1879.258499]  r4:c7507c80
[ 1879.261046] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1879.268630]  r6:b6f6b1c8 r5:00000000 r4:00000000
[ 1879.273285] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1879.281100] ---[ end trace 86e59c15931392ff ]---
[ 1879.285743] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 1879.296836] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1879.304264] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1879.313856] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1879.323447] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1879.336774] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1880.298704] ------------[ cut here ]------------
[ 1880.303383] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1256 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1880.319629] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1880.391985] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1880.399220] Hardware name: BCM5301X
[ 1880.402711] Backtrace: 
[ 1880.405186] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1880.412774]  r7:000004e8 r6:bf1d12cf r5:60000013 r4:00000000
[ 1880.418490] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1880.425729] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1880.433835]  r5:00000009 r4:00000000
[ 1880.437434] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1880.446238]  r8:c646be40 r7:00000001 r6:c6471b74 r5:00000000 r4:c71c5480
[ 1880.453029] [<c002153c>] (warn_slowpath_null) from [<bf1be784>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1880.463514] [<bf1be6c8>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1880.476145]  r8:c646be40 r7:bf1c8910 r6:c71c5480 r5:c04903c8 r4:c79052f0
[ 1880.482918] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 1880.494938]  r7:c71c5480 r6:00000002 r5:c7905254 r4:c7905000
[ 1880.500682] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 1880.511396]  r7:c7306000 r6:c71c5000 r5:c659b420 r4:bf1ad370
[ 1880.517138] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1880.526115]  r7:c659b414 r6:bf170554 r5:bf1787d0 r4:00000000
[ 1880.531824] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1880.539667]  r10:c646be40 r9:00000000 r8:c6471d84 r7:c72e0800 r6:c0286ce0 r5:c646be40
[ 1880.547553]  r4:c659b400
[ 1880.550100] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1880.557597]  r7:c72e0800 r6:c646be40 r5:c646be40 r4:c04a42a0
[ 1880.563304] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1880.570975]  r5:00000030 r4:c7952000
[ 1880.574575] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1880.582856]  r9:00000008 r8:00000000 r7:00000030 r6:c6471f4c r5:c72e0800 r4:00000000
[ 1880.590663] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1880.598506]  r10:00000000 r9:00000000 r8:00000000 r7:c7507c80 r6:c6471e64 r5:00000000
[ 1880.606392]  r4:c6471f4c
[ 1880.608938] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1880.616876] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1880.624722]  r10:00000000 r9:c6470000 r8:c00098c4 r7:00000128 r6:00000000 r5:beb20790
[ 1880.632608]  r4:c7507c80
[ 1880.635155] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1880.642741]  r6:b6f6b1c8 r5:00000000 r4:00000000
[ 1880.647394] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1880.655195] ---[ end trace 86e59c1593139300 ]---
[ 1880.659840] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 1880.670922] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1880.678333] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1880.687935] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1880.697530] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1
[ 1881.439614] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1874.928858]; commit_time:[ 1874.928994])
[ 1881.457852] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1875.938806]; commit_time:[ 1875.938858])
[ 1881.476074] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1876.948805]; commit_time:[ 1876.948855])
[ 1881.494440] brcmfmac: CONSOLE: 028610.749 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1888.235520] brcmfmac: CONSOLE: 028617.545 wl0.2: wlc_send_bar: seq 0x1 tid 0
[ 1888.331718] brcmfmac: CONSOLE: 028617.642 wl0.2: wlc_send_bar: seq 0x2 tid 0
[ 1888.339244] brcmfmac: CONSOLE: 028617.649 wl0.2: wlc_send_bar: seq 0x2 tid 0
[ 1888.346526] brcmfmac: CONSOLE: 028617.653 wl0.2: wlc_send_bar: seq 0x2 tid 0
[ 1889.340149] brcmfmac: CONSOLE: 028618.650 wl0.2: wlc_send_bar: seq 0x3 tid 0
[ 1889.347986] brcmfmac: CONSOLE: 028618.658 wl0.2: wlc_send_bar: seq 0x3 tid 0
[ 1889.356389] brcmfmac: CONSOLE: 028618.666 wl0.2: wlc_send_bar: seq 0x3 tid 0
[ 1889.365376] brcmfmac: CONSOLE: 028618.675 wl0.2: wlc_send_bar: seq 0x3 tid 0
[ 1889.820256] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1891.234796] brcmfmac: CONSOLE: 028620.545 wl0.2: wlc_send_bar: seq 0x5 tid 0
[ 1891.450654] brcmfmac: CONSOLE: 028620.761 wl0.2: wlc_send_bar: seq 0x1 tid 6
[ 1896.459074] brcmfmac: CONSOLE: 028625.769 wl0.2: wlc_send_bar: seq 0xb tid 0
[ 1896.466714] brcmfmac: CONSOLE: 028625.777 wl0.2: wlc_send_bar: seq 0xb tid 0
[ 1899.466112] brcmfmac: CONSOLE: 028628.776 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.477359] brcmfmac: CONSOLE: 028628.787 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.485109] brcmfmac: CONSOLE: 028628.795 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.493678] brcmfmac: CONSOLE: 028628.804 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.502530] brcmfmac: CONSOLE: 028628.812 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.512932] brcmfmac: CONSOLE: 028628.823 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.521532] brcmfmac: CONSOLE: 028628.832 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.533614] brcmfmac: CONSOLE: 028628.843 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.542998] brcmfmac: CONSOLE: 028628.853 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.550675] brcmfmac: CONSOLE: 028628.857 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.558172] brcmfmac: CONSOLE: 028628.865 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1899.567218] brcmfmac: CONSOLE: 028628.877 wl0.2: wlc_send_bar: seq 0x11 tid 0
[ 1900.541469] brcmfmac: CONSOLE: 028629.852 wl0.2: wlc_send_bar: seq 0x12 tid 0
[ 1900.562295] brcmfmac: CONSOLE: 028629.872 wl0.2: wlc_send_bar: seq 0x13 tid 0
[ 1901.357401] brcmfmac: CONSOLE: 028630.667 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1901.367534] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1902.823503] brcmfmac: CONSOLE: 028632.131 wl0.3: wlc_send_bar: seq 0x3 tid 0
[ 1904.429210] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6970c80 brcmf_ifname(ifp):wlan1
[ 1904.519856] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c79d5480 brcmf_ifname(ifp):wlan0
[ 1904.599225] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64b0480 brcmf_ifname(ifp):wlan1-2
[ 1904.619978] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c79d0c80 brcmf_ifname(ifp):wlan0-1
[ 1904.654979] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
[ 1904.739199] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6aac480 brcmf_ifname(ifp):wlan0-2
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 94 +++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    | 17 +++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  2 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 30 ++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 21 +++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 +
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |  2 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |  2 +-
 9 files changed, 167 insertions(+), 8 deletions(-)

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
index 8d16f02..67f2623 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,6 +38,46 @@
 #include "pcie.h"
 #include "common.h"
 
+#include <linux/sched.h>
+
+static size_t print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	rem_nsec = do_div(ts, 1000000000);
+
+	if (!buf)
+		return snprintf(NULL, 0, "[%5lu.000000]", (unsigned long)ts);
+
+	return sprintf(buf, "[%5lu.%06lu]",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+/* Free the driver packet. Free the tag if present */
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	if (ifp) {
+		struct pend_skb *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == skb) {
+				pr_info("[%s -> %s] [ifp:%p] ***BUG*** skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+				break;
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
@@ -247,8 +287,18 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
+		struct pend_skb *e;
+
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		e->skb = skb;
+		e->start_time = local_clock();
+
 		atomic_inc(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_add_tail(&e->list, &ifp->pend_8021x_skbs);
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
@@ -333,7 +383,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+		__brcmu_pkt_buf_free_skb(__func__, *ifp, skb);
 		return -ENODATA;
 	}
 
@@ -378,7 +428,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
 	struct ethhdr *eh;
 	u16 type;
@@ -387,7 +437,30 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
+		struct pend_skb *e, *tmp;
+
 		atomic_dec(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry_safe(e, tmp, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == txp) {
+				if (e->timedout) {
+					char start[32], commit[32];
+
+					print_time(e->start_time, start);
+					print_time(e->commit_time, commit);
+
+					pr_info("[%s -> %s] Finally finalizing skb:%p skb->dev:%p skb->dev->name:%s (start_time:%s; commit_time:%s)\n",
+						c0, __func__,
+						e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---",
+						start, commit);
+				}
+
+				list_del(&e->list);
+				kfree(e);
+				break;
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -476,6 +549,8 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 
 	atomic_set(&ifp->pend_8021x_cnt, 0);
+	INIT_LIST_HEAD(&ifp->pend_8021x_skbs);
+	mutex_init(&ifp->pend_8021x_mutex);
 
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
@@ -1170,6 +1245,19 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	WARN_ON(!err);
+	if (!err)
+		pr_info("[%s] ifp:%p brcmf_ifname(ifp):%s brcmf_get_pend_8021x_cnt(ifp):%d\n", __func__, ifp, brcmf_ifname(ifp), brcmf_get_pend_8021x_cnt(ifp));
+	if (!list_empty(&ifp->pend_8021x_skbs)) {
+		struct pend_skb *e;
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
index 8fa34ca..0f66e8f 100644
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
@@ -169,6 +172,14 @@ enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
+struct pend_skb {
+	struct sk_buff *skb;
+	u64 start_time;
+	u64 commit_time;
+	bool timedout;
+	struct list_head list;
+};
+
 /**
  * struct brcmf_if - interface control information.
  *
@@ -203,6 +214,9 @@ struct brcmf_if {
 	u8 netif_stop;
 	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
+	struct list_head pend_8021x_skbs;
+	struct mutex pend_8021x_mutex;
+	bool pend_8021x_ready;
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
@@ -219,7 +233,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
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
index 9f9024a..7a17afd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -38,6 +38,8 @@
 #include "proto.h"
 #include "common.h"
 
+#include <linux/sched.h>
+
 /**
  * DOC: Firmware Signalling
  *
@@ -590,6 +592,8 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 	for (prec = 0; prec < q->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
 			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		}
@@ -697,6 +701,8 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 		    s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
 			skb = h->items[i].pkt;
 			if (fn == NULL || fn(skb, &ifidx)) {
+				struct brcmf_if *ifp = NULL;
+
 				/* suppress packets freed from psq */
 				if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE)
 					brcmu_pkt_buf_free_skb(skb);
@@ -845,6 +851,8 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	for (prec = 0; prec < txq->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 			hi = &fws->hanger.items[hslot];
 			WARN_ON(skb != hi->pkt);
@@ -971,8 +979,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
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
@@ -2056,6 +2067,22 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
+	{
+		struct brcmf_if *ifp = brcmf_get_ifp(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX));
+
+		if (ifp) {
+			struct pend_skb *e;
+
+			mutex_lock(&ifp->pend_8021x_mutex);
+			list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+				if (e->skb == skb) {
+					e->commit_time = local_clock();
+					break;
+				}
+			}
+			mutex_unlock(&ifp->pend_8021x_mutex);
+		}
+	}
 
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
@@ -2454,6 +2481,7 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
+	struct brcmf_if *ifp = NULL;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 2b9a2bc..6ff91c2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -34,6 +34,8 @@
 #include "bus.h"
 #include "tracepoint.h"
 
+#include <linux/sched.h>
+
 
 #define MSGBUF_IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
@@ -392,6 +394,8 @@ brcmf_msgbuf_release_array(struct device *dev,
 	count = 0;
 	do {
 		if (array[count].allocated.counter) {
+			struct brcmf_if *ifp = NULL;
+
 			pktid = &array[count];
 			dma_unmap_single(dev, pktid->physaddr,
 					 pktid->skb->len - pktid->data_offset,
@@ -483,6 +487,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
+	struct brcmf_if *ifp = NULL;
 	int timeout;
 	int err;
 
@@ -747,6 +752,22 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 			brcmf_commonring_write_complete(commonring);
 			count = 0;
 		}
+		{
+			struct brcmf_if *ifp = brcmf_get_ifp(msgbuf->drvr, tx_msghdr->msg.ifidx);
+
+			if (ifp) {
+				struct pend_skb *e;
+
+				mutex_lock(&ifp->pend_8021x_mutex);
+				list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+					if (e->skb == skb) {
+						e->commit_time = local_clock();
+						break;
+					}
+				}
+				mutex_unlock(&ifp->pend_8021x_mutex);
+			}
+		}
 	}
 	if (count)
 		brcmf_commonring_write_complete(commonring);
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
