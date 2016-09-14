Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33505 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755204AbcINHZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:25:10 -0400
Received: by mail-lf0-f51.google.com with SMTP id h127so3647675lfh.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2016 00:25:08 -0700 (PDT)
Subject: Re: AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <20160914054528.28717-1-zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <e48ed332-fbce-1898-d50f-a23eb28e00d0@gmail.com> (sfid-20160914_092514_270659_DD3F8851)
Date: Wed, 14 Sep 2016 09:25:05 +0200
MIME-Version: 1.0
In-Reply-To: <20160914054528.28717-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2016 07:45 AM, Rafał Miłecki wrote:
> Even with the most recent brcmfmac code ppl keep seeing WARNINGs from
> brcmf_netdev_wait_pend8021x [0].
>
> Hante suggested using CONSOLE for debugging some firmware crash so I
> decided to see I it could also help understanding WARNINGs. I believe it
> did.
>
> First of all, I can't reproduce these problems reliably. One evening I
> got WARNINGs one by one and I could work on my debugging patch easily.
> Yesterday when I got my patch complete, it took me 10+ hours to get a
> single WARNING.
>
> Anyway, it seems to me that sometimes AMPDU stalls in the firmware. It
> seems firmware has some AMPDU watchdog that notices the problem and
> kicks in. It prints some debugging info and starts cleaning up process.
>
> If brcmf_netdev_wait_pend8021x gets called shortly after that (I set
> wpa_group_rekey=30 in hostapd to get brcmf_cfg80211_add_key called more
> often) it results in a WARNING.

Above log was from D-Link DIR-885L.

I can also see WARNINGs on SmartRG SR-400ac with 2 x 43602a1. Unfortunately
brcmfmac43602-pcie.ap.bin doesn't seem to have so many debugging messages so
despite having CONSOLE enabled, I didn't get anything interesting :(

Below you can find 4 logs that look pretty identical to me. At the end of
e-mail there is a confirmation of CONSOLE working.


[30256.622554] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b2ec80 brcmf_ifname(ifp):wlan0
[30258.179143] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c652ec80 brcmf_ifname(ifp):wlan0-1
[30258.402521] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64e1c80 brcmf_ifname(ifp):wlan1-1
[30258.525317] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64e2c80 brcmf_ifname(ifp):wlan1-2
[30258.539100] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c647c480 brcmf_ifname(ifp):wlan0-2
[30260.112015] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b2d480 brcmf_ifname(ifp):wlan1
[30261.071798] ------------[ cut here ]------------
[30261.076459] WARNING: CPU: 1 PID: 1505 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[30261.092493] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[30261.164362] CPU: 1 PID: 1505 Comm: hostapd Not tainted 4.4.19 #0
[30261.170342] Hardware name: BCM5301X
[30261.173816] Backtrace:
[30261.176284] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[30261.183813]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[30261.189496] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[30261.196687] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[30261.204738]  r5:00000009 r4:00000000
[30261.208312] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[30261.217050]  r8:c71b3148 r7:00000001 r6:c6505b3c r5:00000000 r4:c7b2d480
[30261.223791] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[30261.234206] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[30261.246746]  r8:c71b3148 r7:bf1c8613 r6:c7b2d480 r5:c04903c8 r4:c71b3438
[30261.253477] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[30261.265589]  r7:00000000 r6:c7b2d480 r5:c71b3148 r4:00000004
[30261.271315] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[30261.281955]  r10:00000014 r9:c7a61c00 r8:c6505ca0 r7:c6a58000 r6:c7b2d000 r5:00000000
[30261.289781]  r4:bf1ad460
[30261.292349] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[30261.301264]  r8:c68ef900 r7:c656fc14 r6:bf170540 r5:bf1787d0 r4:00000000
[30261.307978] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[30261.315770]  r10:c68ef900 r9:00000000 r8:c6505d84 r7:c646dc00 r6:c0286ce0 r5:c68ef900
[30261.323599]  r4:c656fc00
[30261.326131] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[30261.333577]  r7:c646dc00 r6:c68ef900 r5:c68ef900 r4:c04a42a0
[30261.339247] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[30261.346865]  r5:00000048 r4:c7931c00
[30261.350443] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[30261.358667]  r9:00000008 r8:00000000 r7:00000048 r6:c6505f4c r5:c646dc00 r4:00000000
[30261.366421] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[30261.374211]  r10:00000000 r9:00000000 r8:00000000 r7:c756e900 r6:c6505e64 r5:00000000
[30261.382039]  r4:c6505f4c
[30261.384568] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[30261.392450] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[30261.400235]  r10:00000000 r9:c6504000 r8:c00098c4 r7:00000128 r6:00000000 r5:be8ca7a0
[30261.408062]  r4:c756e900
[30261.410593] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[30261.418119]  r6:b6f371c8 r5:00000000 r4:00000000
[30261.422743] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[30261.430519] ---[ end trace 7622542e763ab584 ]---
[30261.435138] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c7b2d480 brcmf_ifname(ifp):wlan1 brcmf_get_pend_8021x_cnt(ifp):3
[30261.445963] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[30261.453335] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c68ef540 skb->dev:c7b2d000 skb->dev->name:wlan1
[30261.462690] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c68ef240 skb->dev:c7b2d000 skb->dev->name:wlan1
[30261.472048] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c68ef600 skb->dev:c7b2d000 skb->dev->name:wlan1
[30261.481438] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c68ef540 skb->dev:c7b2d000 skb->dev->name:wlan1
[30261.495608] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c7b2d480 brcmf_ifname(ifp):wlan1
[30262.451804] ------------[ cut here ]------------
[30262.456462] WARNING: CPU: 1 PID: 1505 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[30262.472486] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[30262.544371] CPU: 1 PID: 1505 Comm: hostapd Tainted: G        W       4.4.19 #0
[30262.551559] Hardware name: BCM5301X
[30262.555032] Backtrace:
[30262.557500] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[30262.565030]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[30262.570722] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[30262.577920] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[30262.585971]  r5:00000009 r4:00000000
[30262.589546] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[30262.598284]  r8:c68ef540 r7:00000001 r6:c6505b74 r5:00000000 r4:c7b2d480
[30262.605024] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[30262.615440] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[30262.627979]  r8:c68ef540 r7:bf1c85fc r6:c7b2d480 r5:c04903c8 r4:c71b32f0
[30262.634711] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[30262.646649]  r7:c7b2d480 r6:00000002 r5:c71b3254 r4:c71b3000
[30262.652374] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[30262.663014]  r7:c6a58000 r6:c7b2d000 r5:c644b720 r4:bf1ad370
[30262.668718] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[30262.677634]  r7:c644b714 r6:bf170554 r5:bf1787d0 r4:00000000
[30262.683301] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[30262.691095]  r10:c68ef540 r9:00000000 r8:c6505d84 r7:c646dc00 r6:c0286ce0 r5:c68ef540
[30262.698922]  r4:c644b700
[30262.701453] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[30262.708892]  r7:c646dc00 r6:c68ef540 r5:c68ef540 r4:c04a42a0
[30262.714561] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[30262.722180]  r5:00000030 r4:c7931c00
[30262.725758] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[30262.733974]  r9:00000008 r8:00000000 r7:00000030 r6:c6505f4c r5:c646dc00 r4:00000000
[30262.741728] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[30262.749518]  r10:00000000 r9:00000000 r8:00000000 r7:c756e900 r6:c6505e64 r5:00000000
[30262.757345]  r4:c6505f4c
[30262.759875] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[30262.767756] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[30262.775542]  r10:00000000 r9:c6504000 r8:c00098c4 r7:00000128 r6:00000000 r5:be8ca770
[30262.783369]  r4:c756e900
[30262.785901] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[30262.793427]  r6:b6f371c8 r5:00000000 r4:00000000
[30262.798050] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[30262.805792] ---[ end trace 7622542e763ab585 ]---
[30262.810397] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c7b2d480 brcmf_ifname(ifp):wlan1 brcmf_get_pend_8021x_cnt(ifp):2
[30262.821229] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[30262.828606] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c68ef240 skb->dev:c7b2d000 skb->dev->name:wlan1
[30262.837962] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c68ef600 skb->dev:c7b2d000 skb->dev->name:wlan1
[30264.339034] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c68ef240 skb->dev:c7b2d000 skb->dev->name:wlan1
[30264.352306] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c68ef600 skb->dev:c7b2d000 skb->dev->name:wlan1



[ 2688.254245] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 2688.597156] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 2689.411719] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 2689.961683] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 2689.974174] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2
[ 2692.133701] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2693.093493] ------------[ cut here ]------------
[ 2693.098153] WARNING: CPU: 1 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 2693.114191] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2693.186072] CPU: 1 PID: 1202 Comm: hostapd Not tainted 4.4.19 #0
[ 2693.192051] Hardware name: BCM5301X
[ 2693.195524] Backtrace:
[ 2693.197993] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2693.205520]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 2693.211206] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 2693.218401] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2693.226446]  r5:00000009 r4:00000000
[ 2693.230020] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2693.238758]  r8:c72f4148 r7:00000001 r6:c6475b3c r5:00000000 r4:c649bc80
[ 2693.245498] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 2693.255915] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 2693.268453]  r8:c72f4148 r7:bf1c8613 r6:c649bc80 r5:c04903c8 r4:c72f4438
[ 2693.275185] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 2693.287298]  r7:00000000 r6:c649bc80 r5:c72f4148 r4:00000004
[ 2693.293021] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 2693.303661]  r10:00000014 r9:c7966800 r8:c6475ca0 r7:c715e000 r6:c649b800 r5:00000000
[ 2693.311489]  r4:bf1ad460
[ 2693.314057] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 2693.322972]  r8:c6bd2b40 r7:c785f014 r6:bf170540 r5:bf1787d0 r4:00000000
[ 2693.329686] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 2693.337478]  r10:c6bd2b40 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c6bd2b40
[ 2693.345306]  r4:c785f000
[ 2693.347838] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 2693.355277]  r7:c68bb000 r6:c6bd2b40 r5:c6bd2b40 r4:c04a42a0
[ 2693.360945] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 2693.368565]  r5:00000048 r4:c7931c00
[ 2693.372143] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 2693.380367]  r9:00000008 r8:00000000 r7:00000048 r6:c6475f4c r5:c68bb000 r4:00000000
[ 2693.388120] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 2693.395910]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 2693.403738]  r4:c6475f4c
[ 2693.406267] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 2693.414148] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 2693.421935]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf37a0
[ 2693.429762]  r4:c7503500
[ 2693.432292] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 2693.439820]  r6:b6f201c8 r5:00000000 r4:00000000
[ 2693.444442] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 2693.452191] ---[ end trace b29225cb54365624 ]---
[ 2693.456815] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 2693.467821] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 2693.475197] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6bd2e40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2693.486107] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2694.443471] ------------[ cut here ]------------
[ 2694.448127] WARNING: CPU: 1 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 2694.464159] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2694.536044] CPU: 1 PID: 1202 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 2694.543235] Hardware name: BCM5301X
[ 2694.546708] Backtrace:
[ 2694.549175] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2694.556704]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 2694.562388] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 2694.569577] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2694.577621]  r5:00000009 r4:00000000
[ 2694.581195] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2694.589932]  r8:c6bd2b40 r7:00000001 r6:c6475b74 r5:00000000 r4:c649bc80
[ 2694.596677] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 2694.607089] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 2694.619629]  r8:c6bd2b40 r7:bf1c85fc r6:c649bc80 r5:c04903c8 r4:c72f42f0
[ 2694.626359] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 2694.638291]  r7:c649bc80 r6:00000002 r5:c72f4254 r4:c72f4000
[ 2694.644015] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 2694.654655]  r7:c715e000 r6:c649b800 r5:c68eb520 r4:bf1ad370
[ 2694.660360] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 2694.669273]  r7:c68eb514 r6:bf170554 r5:bf1787d0 r4:00000000
[ 2694.674942] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 2694.682735]  r10:c6bd2b40 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c6bd2b40
[ 2694.690563]  r4:c68eb500
[ 2694.693094] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 2694.700533]  r7:c68bb000 r6:c6bd2b40 r5:c6bd2b40 r4:c04a42a0
[ 2694.706202] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 2694.713821]  r5:00000030 r4:c7931c00
[ 2694.717399] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 2694.725615]  r9:00000008 r8:00000000 r7:00000030 r6:c6475f4c r5:c68bb000 r4:00000000
[ 2694.733369] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 2694.741158]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 2694.748986]  r4:c6475f4c
[ 2694.751516] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 2694.759397] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 2694.767182]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf3770
[ 2694.775010]  r4:c7503500
[ 2694.777541] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 2694.785068]  r6:b6f201c8 r5:00000000 r4:00000000
[ 2694.789691] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 2694.797445] ---[ end trace b29225cb54365625 ]---
[ 2694.802054] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 2694.813060] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 2694.820436] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6bd2e40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2696.497370] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6bd2e40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2715.160649] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2718.274307] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 2718.607701] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 2718.881713] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2719.431788] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 2719.981819] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 2719.994262] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2



[ 2928.414290] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 2928.679474] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 2929.564278] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 2930.151747] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2
[ 2930.162258] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 2932.211271] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2933.171045] ------------[ cut here ]------------
[ 2933.175701] WARNING: CPU: 0 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 2933.191731] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2933.263627] CPU: 0 PID: 1202 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 2933.270814] Hardware name: BCM5301X
[ 2933.274288] Backtrace:
[ 2933.276756] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2933.284285]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 2933.289969] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 2933.297158] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2933.305210]  r5:00000009 r4:00000000
[ 2933.308784] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2933.317521]  r8:c72f4148 r7:00000001 r6:c6475b3c r5:00000000 r4:c649bc80
[ 2933.324263] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 2933.334677] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 2933.347218]  r8:c72f4148 r7:bf1c8613 r6:c649bc80 r5:c04903c8 r4:c72f4438
[ 2933.353949] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 2933.366061]  r7:00000000 r6:c649bc80 r5:c72f4148 r4:00000004
[ 2933.371785] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 2933.382426]  r10:00000014 r9:c7966800 r8:c6475ca0 r7:c715e000 r6:c649b800 r5:00000000
[ 2933.390253]  r4:bf1ad460
[ 2933.392821] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 2933.401737]  r8:c6abd540 r7:c653f214 r6:bf170540 r5:bf1787d0 r4:00000000
[ 2933.408451] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 2933.416243]  r10:c6abd540 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c6abd540
[ 2933.424070]  r4:c653f200
[ 2933.426602] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 2933.434041]  r7:c68bb000 r6:c6abd540 r5:c6abd540 r4:c04a42a0
[ 2933.439708] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 2933.447321]  r5:00000048 r4:c7931c00
[ 2933.450898] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 2933.459123]  r9:00000008 r8:00000000 r7:00000048 r6:c6475f4c r5:c68bb000 r4:00000000
[ 2933.466877] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 2933.474666]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 2933.482494]  r4:c6475f4c
[ 2933.485022] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 2933.492905] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 2933.500690]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf37a0
[ 2933.508518]  r4:c7503500
[ 2933.511048] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 2933.518574]  r6:b6f201c8 r5:00000000 r4:00000000
[ 2933.523199] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 2933.530975] ---[ end trace b29225cb54365626 ]---
[ 2933.535595] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):2
[ 2933.546602] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 2933.553984] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7bcb300 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2933.563523] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7bcb240 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2933.574411] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2934.531066] ------------[ cut here ]------------
[ 2934.535734] WARNING: CPU: 0 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 2934.551769] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2934.623666] CPU: 0 PID: 1202 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 2934.630855] Hardware name: BCM5301X
[ 2934.634328] Backtrace:
[ 2934.636794] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2934.644324]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 2934.650008] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 2934.657197] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2934.665241]  r5:00000009 r4:00000000
[ 2934.668814] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2934.677552]  r8:c709be40 r7:00000001 r6:c6475b74 r5:00000000 r4:c649bc80
[ 2934.684294] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 2934.694708] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 2934.707248]  r8:c709be40 r7:bf1c85fc r6:c649bc80 r5:c04903c8 r4:c72f42f0
[ 2934.713981] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 2934.725919]  r7:c649bc80 r6:00000002 r5:c72f4254 r4:c72f4000
[ 2934.731644] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 2934.742284]  r7:c715e000 r6:c649b800 r5:c6906720 r4:bf1ad370
[ 2934.747987] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 2934.756903]  r7:c6906714 r6:bf170554 r5:bf1787d0 r4:00000000
[ 2934.762572] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 2934.770364]  r10:c709be40 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c709be40
[ 2934.778192]  r4:c6906700
[ 2934.780723] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 2934.788171]  r7:c68bb000 r6:c709be40 r5:c709be40 r4:c04a42a0
[ 2934.793838] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 2934.801450]  r5:00000030 r4:c7931c00
[ 2934.805028] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 2934.813253]  r9:00000008 r8:00000000 r7:00000030 r6:c6475f4c r5:c68bb000 r4:00000000
[ 2934.821006] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 2934.828795]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 2934.836624]  r4:c6475f4c
[ 2934.839153] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 2934.847034] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 2934.854820]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf3770
[ 2934.862648]  r4:c7503500
[ 2934.865179] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 2934.872704]  r6:b6f201c8 r5:00000000 r4:00000000
[ 2934.877328] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 2934.885107] ---[ end trace b29225cb54365627 ]---
[ 2934.889718] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):2
[ 2934.900737] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 2934.908123] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7bcb300 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2934.917659] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7bcb240 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2934.927268] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c7bcb300 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2934.940547] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c7bcb240 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 2958.431826] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 2958.689224] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 2958.983312] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 2959.584290] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 2960.174354] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 2960.185643] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2



[ 3198.584369] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 3198.759755] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 3199.734358] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 3200.374309] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 3200.384905] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2
[ 3202.291309] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 3203.251121] ------------[ cut here ]------------
[ 3203.255787] WARNING: CPU: 0 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 3203.271827] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 3203.343719] CPU: 0 PID: 1202 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 3203.350908] Hardware name: BCM5301X
[ 3203.354381] Backtrace:
[ 3203.356849] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 3203.364378]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 3203.370062] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 3203.377259] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 3203.385304]  r5:00000009 r4:00000000
[ 3203.388877] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 3203.397614]  r8:c72f40a4 r7:00000001 r6:c6475b3c r5:00000000 r4:c649bc80
[ 3203.404355] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 3203.414771] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 3203.427311]  r8:c72f40a4 r7:bf1c8613 r6:c649bc80 r5:c04903c8 r4:c72f4394
[ 3203.434043] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 3203.446154]  r7:00000000 r6:c649bc80 r5:c72f40a4 r4:00000004
[ 3203.451877] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 3203.462519]  r10:00000014 r9:c7966800 r8:c6475ca0 r7:c715e000 r6:c649b800 r5:00000000
[ 3203.470346]  r4:bf1ad460
[ 3203.472915] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 3203.481829]  r8:c6901300 r7:c653f614 r6:bf170540 r5:bf1787d0 r4:00000000
[ 3203.488544] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 3203.496336]  r10:c6901300 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c6901300
[ 3203.504163]  r4:c653f600
[ 3203.506695] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 3203.514142]  r7:c68bb000 r6:c6901300 r5:c6901300 r4:c04a42a0
[ 3203.519810] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 3203.527423]  r5:00000048 r4:c7931c00
[ 3203.531000] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 3203.539224]  r9:00000008 r8:00000000 r7:00000048 r6:c6475f4c r5:c68bb000 r4:00000000
[ 3203.546978] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 3203.554768]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 3203.562596]  r4:c6475f4c
[ 3203.565125] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 3203.573006] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 3203.580791]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf37a0
[ 3203.588619]  r4:c7503500
[ 3203.591150] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 3203.598676]  r6:b6f201c8 r5:00000000 r4:00000000
[ 3203.603300] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 3203.611046] ---[ end trace b29225cb54365628 ]---
[ 3203.615668] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 3203.626670] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 3203.634050] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901180 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3203.643591] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901f00 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3203.653126] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901b40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3203.666634] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 3204.621117] ------------[ cut here ]------------
[ 3204.625777] WARNING: CPU: 0 PID: 1202 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1219 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 3204.641806] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 3204.713721] CPU: 0 PID: 1202 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 3204.720908] Hardware name: BCM5301X
[ 3204.724374] Backtrace:
[ 3204.726840] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 3204.734370]  r7:000004c3 r6:bf1d0e9c r5:60000013 r4:00000000
[ 3204.740054] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 3204.747243] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 3204.755287]  r5:00000009 r4:00000000
[ 3204.758861] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 3204.767600]  r8:c6709b40 r7:00000001 r6:c6475b74 r5:00000000 r4:c649bc80
[ 3204.774337] [<c002153c>] (warn_slowpath_null) from [<bf1be578>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 3204.784755] [<bf1be4bc>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 3204.797295]  r8:c6709b40 r7:bf1c85fc r6:c649bc80 r5:c04903c8 r4:c72f42f0
[ 3204.804026] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad420>] (brcmf_cfg80211_del_key+0xb0/0xf0 [brcmfmac])
[ 3204.815966]  r7:c649bc80 r6:00000002 r5:c72f4254 r4:c72f4000
[ 3204.821689] [<bf1ad370>] (brcmf_cfg80211_del_key [brcmfmac]) from [<bf1608b8>] (nl80211_del_key+0xf4/0x148 [cfg80211])
[ 3204.832330]  r7:c715e000 r6:c649b800 r5:c6906e20 r4:bf1ad370
[ 3204.838033] [<bf1607c4>] (nl80211_del_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 3204.846949]  r7:c6906e14 r6:bf170554 r5:bf1787d0 r4:00000000
[ 3204.852618] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 3204.860410]  r10:c6709b40 r9:00000000 r8:c6475d84 r7:c68bb000 r6:c0286ce0 r5:c6709b40
[ 3204.868238]  r4:c6906e00
[ 3204.870770] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 3204.878217]  r7:c68bb000 r6:c6709b40 r5:c6709b40 r4:c04a42a0
[ 3204.883886] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 3204.891505]  r5:00000030 r4:c7931c00
[ 3204.895083] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 3204.903307]  r9:00000008 r8:00000000 r7:00000030 r6:c6475f4c r5:c68bb000 r4:00000000
[ 3204.911061] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 3204.918851]  r10:00000000 r9:00000000 r8:00000000 r7:c7503500 r6:c6475e64 r5:00000000
[ 3204.926678]  r4:c6475f4c
[ 3204.929208] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 3204.937088] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 3204.944874]  r10:00000000 r9:c6474000 r8:c00098c4 r7:00000128 r6:00000000 r5:beaf3770
[ 3204.952702]  r4:c7503500
[ 3204.955233] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 3204.962760]  r6:b6f201c8 r5:00000000 r4:00000000
[ 3204.967382] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 3204.975127] ---[ end trace b29225cb54365629 ]---
[ 3204.979728] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
[ 3204.990733] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 3204.998108] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901180 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3205.007650] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901f00 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3205.017190] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6901b40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3205.026823] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6901180 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3205.040104] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6901f00 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3205.053367] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6901b40 skb->dev:c649b800 skb->dev->name:wlan1-1
[ 3228.604387] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719d480 brcmf_ifname(ifp):wlan1
[ 3228.769758] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c719a480 brcmf_ifname(ifp):wlan0
[ 3229.737659] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c649bc80 brcmf_ifname(ifp):wlan1-1
[ 3229.751855] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7ab4480 brcmf_ifname(ifp):wlan0-1
[ 3230.401808] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c7b1ec80 brcmf_ifname(ifp):wlan0-2
[ 3230.412403] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6532c80 brcmf_ifname(ifp):wlan1-2



I'm pretty sure I have CONSOLE working as restarting wifi gives me some
messages:

[ 3604.964790] brcmfmac: CONSOLE: 003590.895 wl0: wlc_enable_probe_req: state down, deferring setting of host flags
[ 3607.429608] brcmfmac: CONSOLE: 003595.110 wl0: wlc_enable_probe_req: state down, deferring setting of host flags
[ 3609.430295] brcmfmac: CONSOLE: 003595.359 wl0: bc/mc deauth_reason on STA BSS?
[ 3609.623067] brcmfmac: CONSOLE: 003595.551 wl0: wlc_enable_probe_req: state down, deferring setting of host flags
[ 3609.739680] brcmfmac: CONSOLE: 003595.587 wl0: wlc_enable_probe_req: state down, deferring setting of host flags
