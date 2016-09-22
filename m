Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36264 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcIVMYb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 08:24:31 -0400
Received: by mail-lf0-f43.google.com with SMTP id g62so65437349lfe.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 05:24:29 -0700 (PDT)
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite
 WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <20160920111604.32716-1-zajec5@gmail.com>
 <20160922115935.11287-1-zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <bdc7e4d1-0d96-c8ed-e07a-fdb19c1265d8@gmail.com> (sfid-20160922_142455_176442_3C5B9D51)
Date: Thu, 22 Sep 2016 14:24:26 +0200
MIME-Version: 1.0
In-Reply-To: <20160922115935.11287-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2016 01:59 PM, Rafał Miłecki wrote:
> And again...
>
> I decided to focus on brcmf_flowring_delete a bit more.
>
> As I can see flowrings are created and removed from time to time, in most cases
> they are empty when being deleted. When they are not, things go wrong. In below
> log you can see brcmfmac removing flowring that got 8 skb packets.
>
> First some summary, of what was already partially noticed in previous e-mail:
> 1) brcmf_flowring_delete calls brcmu_pkt_buf_free_skb directly bypassing
>    brcmf_txfinalize. It means tracing 802.1x packets and counting TX errors is
>    broken.
> 2) After freeing skb (as the result of brcmf_flowring_delete) there will still
>    an IRQ, MSGBUF_TYPE_TX_STATUS and call to the brcmf_txfinalize. That's
>    definitely unexpected as brcmf_txfinalize will be operating on skb that was
>    already freed.
>
> Now, there is something new that looks even worse. Sometimes brcmf_txfinalize
> may be called multiple times for the same skb! Take a close look at my log.
> It was called twice for skb c64a5a80. Twice for c64a5480. Twice for c64a5f00.
> Then Linux/device rebooted itself due to amount of console messages.

I got the same problem again, but this time there was only 1 skb in my flowring.
That resulted in less serial console messages and no reboot.

It doesn't look good. brcmf_txfinalize was called 11 times after deleting
flowring. Everytime it was working with the same skb that was already freed.

After my DIR-885L and brcmfmac managed to survive that, my smartphone remained
connected but I couldn't contact it (no reply to ping). I had to reconnect and
then it was back OK.

[ 2927.500112] brcmfmac: CONSOLE: 029651.820 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??

[ 2927.509473] brcmfmac: [brcmf_msgbuf_process_flow_ring_delete_response -> __brcmf_msgbuf_remove_flowring] flowid:3
[ 2927.519800] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] flowid:3 ring:c7850540
[ 2927.529318] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] count:0

[ 2927.537526] brcmfmac: [brcmf_msgbuf_process_flow_ring_delete_response -> __brcmf_msgbuf_remove_flowring] flowid:34
[ 2927.547929] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] flowid:34 ring:c7850180
[ 2927.557533] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] count:0

[ 2927.559735] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] da:78:d6:f0:9b:ba:bc prio:0 ifidx:1
[ 2927.559739] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] flowid:3
[ 2927.584463] brcmfmac: [brcmf_msgbuf_process_flow_ring_create_response] flowid:3 status:0x0000

[ 2927.593211] brcmfmac: [brcmf_msgbuf_process_flow_ring_delete_response -> __brcmf_msgbuf_remove_flowring] flowid:3
[ 2927.603538] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] flowid:3 ring:c658cb80
[ 2927.613059] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2927.626750] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] count:1

[ 2928.348341] brcmfmac: CONSOLE: 029652.655 wl0: wlc_ampdu_resp_timeout: cleaning up resp tid 0 waiting forseq 0xbb9 for 1000 ms

[ 2930.887857] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] da:78:d6:f0:9b:ba:bc prio:0 ifidx:1
[ 2930.898340] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] flowid:3
[ 2930.906686] brcmfmac: [brcmf_msgbuf_process_flow_ring_create_response] flowid:3 status:0x0000

[ 2933.982285] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2933.995705] ------------[ cut here ]------------
[ 2934.000359] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2934.015949] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2934.088284] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Not tainted 4.4.21 #0
[ 2934.094913] Hardware name: BCM5301X
[ 2934.098403] Backtrace:
[ 2934.100877] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2934.108465]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2934.114183] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2934.121421] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2934.129527]  r5:00000009 r4:00000000
[ 2934.133126] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2934.141931]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2934.148707] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2934.158923] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2934.170158]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c658cf40 r4:c6b3fc80
[ 2934.176931] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2934.187731]  r10:c64d1240 r9:cacd2e80 r8:cacd2e80 r7:c7388180 r6:00000021 r5:00000000
[ 2934.195616]  r4:c7389c00
[ 2934.198175] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2934.209761]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2934.217646]  r4:c7389c00
[ 2934.220207] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2934.232138]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2934.237853] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2934.247266]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2934.255069] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2934.262655]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2934.268363] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2934.275336]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2934.283223]  r4:c738bcc0
[ 2934.285770] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2934.293005]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2934.298708] ---[ end trace 886f614767d73cfe ]---

[ 2936.216611] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2936.230030] ------------[ cut here ]------------
[ 2936.234684] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2936.250276] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2936.322610] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2936.330456] Hardware name: BCM5301X
[ 2936.333946] Backtrace:
[ 2936.336421] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2936.344008]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2936.349726] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2936.356965] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2936.365072]  r5:00000009 r4:00000000
[ 2936.368669] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2936.377475]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2936.384249] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2936.394468] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2936.405702]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c7850040 r4:c6b3fc80
[ 2936.412474] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2936.423275]  r10:c64d1240 r9:cacd2e90 r8:cacd2e90 r7:c7388180 r6:00000021 r5:00000000
[ 2936.431160]  r4:c7389c00
[ 2936.433720] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2936.445305]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2936.453190]  r4:c7389c00
[ 2936.455750] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2936.467683]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2936.473396] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2936.482811]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2936.490613] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2936.498199]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2936.503906] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2936.510880]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2936.518767]  r4:c738bcc0
[ 2936.521315] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2936.528549]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2936.534252] ---[ end trace 886f614767d73cff ]---

[ 2942.054359] brcmfmac: CONSOLE: 029666.332 wl0.2: wlc_send_bar: seq 0x1 tid 0

[ 2942.683661] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] da:78:d6:f0:9b:ba:bc prio:6 ifidx:1
[ 2942.694175] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] flowid:34
[ 2942.702765] brcmfmac: [brcmf_msgbuf_process_flow_ring_create_response] flowid:34 status:0x0000

[ 2942.850073] brcmfmac: CONSOLE: 029667.008 wl0.2: wlc_send_bar: seq 0x1 tid 6

[ 2943.368191] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2943.381618] ------------[ cut here ]------------
[ 2943.386273] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2943.401864] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2943.474198] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2943.482044] Hardware name: BCM5301X
[ 2943.485534] Backtrace:
[ 2943.488009] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2943.495597]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2943.501314] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2943.508553] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2943.516660]  r5:00000009 r4:00000000
[ 2943.520258] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2943.529055]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2943.535829] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2943.546047] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2943.557281]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c658cd00 r4:c6b3fc80
[ 2943.564054] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2943.574855]  r10:c64d1240 r9:cacd30b0 r8:cacd30b0 r7:c7388180 r6:00000021 r5:00000000
[ 2943.582741]  r4:c7389c00
[ 2943.585301] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2943.596885]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2943.604771]  r4:c7389c00
[ 2943.607330] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2943.619262]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2943.624976] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2943.634391]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2943.642193] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2943.649779]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2943.655485] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2943.662460]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2943.670346]  r4:c738bcc0
[ 2943.672893] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2943.680129]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2943.685832] ---[ end trace 886f614767d73d00 ]---

[ 2948.380193] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2948.393616] ------------[ cut here ]------------
[ 2948.398271] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2948.413860] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2948.486196] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2948.494041] Hardware name: BCM5301X
[ 2948.497532] Backtrace:
[ 2948.500007] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2948.507593]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2948.513311] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2948.520551] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2948.528657]  r5:00000009 r4:00000000
[ 2948.532256] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2948.541061]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2948.547836] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2948.558053] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2948.569288]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c7850340 r4:c6b3fc80
[ 2948.576060] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2948.586860]  r10:c64d1240 r9:cacd3340 r8:cacd3340 r7:c7388180 r6:00000003 r5:00000000
[ 2948.594747]  r4:c7389c00
[ 2948.597307] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2948.608891]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2948.616776]  r4:c7389c00
[ 2948.619336] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2948.631268]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2948.636983] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2948.646396]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2948.654198] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2948.661776]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2948.667483] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2948.674458]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2948.682343]  r4:c738bcc0
[ 2948.684892] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2948.692126]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2948.697830] ---[ end trace 886f614767d73d01 ]---

[ 2948.705730] brcmfmac: CONSOLE: 029672.990 wl0.2: wlc_send_bar: seq 0x19 tid 0

[ 2956.055394] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2956.068820] ------------[ cut here ]------------
[ 2956.073474] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2956.089064] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2956.161400] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2956.169245] Hardware name: BCM5301X
[ 2956.172735] Backtrace:
[ 2956.175211] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2956.182798]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2956.188515] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2956.195754] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2956.203861]  r5:00000009 r4:00000000
[ 2956.207459] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2956.216264]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2956.223039] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2956.233256] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2956.244491]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c658ca80 r4:c6b3fc80
[ 2956.251264] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2956.262064]  r10:c64d1240 r9:cacd3530 r8:cacd3530 r7:c7388180 r6:00000021 r5:00000000
[ 2956.269950]  r4:c7389c00
[ 2956.272509] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2956.284094]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2956.291980]  r4:c7389c00
[ 2956.294539] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2956.306473]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2956.312185] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2956.321591]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2956.329393] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2956.336971]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2956.342677] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2956.349653]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2956.357538]  r4:c738bcc0
[ 2956.360086] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2956.367321]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2956.373024] ---[ end trace 886f614767d73d02 ]---

[ 2966.060530] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2966.073953] ------------[ cut here ]------------
[ 2966.078607] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2966.094198] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2966.166533] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2966.174378] Hardware name: BCM5301X
[ 2966.177869] Backtrace:
[ 2966.180345] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2966.187931]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2966.193648] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2966.200887] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2966.208994]  r5:00000009 r4:00000000
[ 2966.212593] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2966.221398]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2966.228171] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2966.238382] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2966.249616]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c7850680 r4:c6b3fc80
[ 2966.256388] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2966.267190]  r10:c64d1240 r9:cacd3670 r8:cacd3670 r7:c7388180 r6:00000021 r5:00000001
[ 2966.275075]  r4:c7389c00
[ 2966.277634] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2966.289219]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2966.297104]  r4:c7389c00
[ 2966.299664] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2966.311596]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2966.317311] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2966.326724]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2966.334527] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2966.342112]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2966.347820] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2966.354795]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2966.362680]  r4:c738bcc0
[ 2966.365229] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2966.372464]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2966.378166] ---[ end trace 886f614767d73d03 ]---

[ 2966.527066] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2966.540487] ------------[ cut here ]------------
[ 2966.545141] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2966.560731] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2966.633066] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2966.640913] Hardware name: BCM5301X
[ 2966.644403] Backtrace:
[ 2966.646878] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2966.654465]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2966.660181] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2966.667422] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2966.675529]  r5:00000009 r4:00000000
[ 2966.679127] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2966.687932]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2966.694703] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2966.704915] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2966.716149]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c78508c0 r4:c6b3fc80
[ 2966.722922] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2966.733723]  r10:c64d1240 r9:cacd3700 r8:cacd3700 r7:c7388180 r6:00000021 r5:00000000
[ 2966.741609]  r4:c7389c00
[ 2966.744168] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2966.755753]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2966.763639]  r4:c7389c00
[ 2966.766198] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2966.778131]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2966.783843] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2966.793250]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2966.801052] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2966.808630]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2966.814336] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2966.821311]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2966.829197]  r4:c738bcc0
[ 2966.831745] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2966.838981]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2966.844683] ---[ end trace 886f614767d73d04 ]---

[ 2971.310626] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2971.324049] ------------[ cut here ]------------
[ 2971.328703] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2971.344293] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2971.416627] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2971.424474] Hardware name: BCM5301X
[ 2971.427964] Backtrace:
[ 2971.430440] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2971.438026]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2971.443744] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2971.450983] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2971.459090]  r5:00000009 r4:00000000
[ 2971.462688] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2971.471492]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2971.478268] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2971.488486] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2971.499728]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c658c080 r4:c6b3fc80
[ 2971.506501] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2971.517302]  r10:c64d1240 r9:cacd37f0 r8:cacd37f0 r7:c7388180 r6:00000021 r5:00000000
[ 2971.525187]  r4:c7389c00
[ 2971.527746] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2971.539332]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2971.547217]  r4:c7389c00
[ 2971.549777] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2971.561709]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2971.567423] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2971.576837]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2971.584639] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2971.592225]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2971.597933] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2971.604908]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2971.612793]  r4:c738bcc0
[ 2971.615342] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2971.622576]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2971.628280] ---[ end trace 886f614767d73d05 ]---

[ 2972.173454] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2972.186877] ------------[ cut here ]------------
[ 2972.191530] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2972.207120] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2972.279454] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2972.287301] Hardware name: BCM5301X
[ 2972.290792] Backtrace:
[ 2972.293266] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2972.300854]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2972.306572] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2972.313812] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2972.321917]  r5:00000009 r4:00000000
[ 2972.325516] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2972.334320]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2972.341097] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2972.351314] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2972.362556]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c7850800 r4:c6b3fc80
[ 2972.369328] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2972.380130]  r10:c64d1240 r9:cacd3900 r8:cacd3900 r7:c7388180 r6:00000021 r5:00000000
[ 2972.388015]  r4:c7389c00
[ 2972.390574] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2972.402158]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2972.410044]  r4:c7389c00
[ 2972.412605] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2972.424536]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2972.430251] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2972.439665]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2972.447467] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2972.455054]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2972.460760] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2972.467734]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2972.475621]  r4:c738bcc0
[ 2972.478169] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2972.485403]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2972.491107] ---[ end trace 886f614767d73d06 ]---

[ 2974.318618] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2974.332046] ------------[ cut here ]------------
[ 2974.336700] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2974.352291] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2974.424626] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2974.432471] Hardware name: BCM5301X
[ 2974.435962] Backtrace:
[ 2974.438437] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2974.446024]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2974.451741] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2974.458981] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2974.467086]  r5:00000009 r4:00000000
[ 2974.470685] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2974.479482]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2974.486259] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2974.496474] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2974.507708]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c658c3c0 r4:c6b3fc80
[ 2974.514481] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2974.525282]  r10:c64d1240 r9:cacd3a20 r8:cacd3a20 r7:c7388180 r6:00000021 r5:00000000
[ 2974.533168]  r4:c7389c00
[ 2974.535727] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2974.547312]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2974.555198]  r4:c7389c00
[ 2974.557757] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2974.569690]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2974.575403] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2974.584817]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2974.592619] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2974.600197]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2974.605905] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2974.612879]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2974.620765]  r4:c738bcc0
[ 2974.623312] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2974.630549]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2974.636250] ---[ end trace 886f614767d73d07 ]---

[ 2975.049818] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c6b3fc80] ***BUG*** skb:c64d1240 skb->dev:c6b3f800 skb->dev->name:wlan1-1
[ 2975.063243] ------------[ cut here ]------------
[ 2975.067897] WARNING: CPU: 1 PID: 615 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[ 2975.083488] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 2975.155822] CPU: 1 PID: 615 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[ 2975.163668] Hardware name: BCM5301X
[ 2975.167159] Backtrace:
[ 2975.169634] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 2975.177221]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[ 2975.182938] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[ 2975.190177] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 2975.198283]  r5:00000009 r4:00000000
[ 2975.201882] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 2975.210688]  r8:a0000013 r7:c6b3fdd0 r6:bf1c9f2d r5:c6b3fc80 r4:c64d1240
[ 2975.217465] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[ 2975.227681] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[ 2975.238923]  r8:c04903c8 r7:c6b3fdd0 r6:c64d1240 r5:c7850b00 r4:c6b3fc80
[ 2975.245695] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[ 2975.256496]  r10:c64d1240 r9:cacd3c50 r8:cacd3c50 r7:c7388180 r6:00000021 r5:00000000
[ 2975.264381]  r4:c7389c00
[ 2975.266941] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[ 2975.278526]  r10:00000000 r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:00010000
[ 2975.286411]  r4:c7389c00
[ 2975.288971] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[ 2975.300904]  r7:c0057d98 r6:c7a0c240 r5:00010000 r4:c68fa800
[ 2975.306617] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[ 2975.316032]  r9:c0493882 r8:c738ba64 r7:c0057d98 r6:c7a0c240 r5:c738ba40 r4:c738ba40
[ 2975.323834] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[ 2975.331420]  r7:c0057d98 r6:c7254000 r5:c738ba40 r4:c7a0c240
[ 2975.337127] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[ 2975.344102]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c738ba40 r5:00000000
[ 2975.351987]  r4:c738bcc0
[ 2975.354535] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[ 2975.361770]  r7:00000000 r6:00000000 r5:c00393e4 r4:c738bcc0
[ 2975.367473] ---[ end trace 886f614767d73d08 ]---
