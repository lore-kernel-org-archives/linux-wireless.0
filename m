Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35051 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755320AbcIVMAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 08:00:16 -0400
Received: by mail-lf0-f68.google.com with SMTP id s64so3918883lfs.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 05:00:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite WARNINGs
Date: Thu, 22 Sep 2016 13:59:35 +0200
Message-Id: <20160922115935.11287-1-zajec5@gmail.com> (sfid-20160922_140024_185112_B077931F)
In-Reply-To: <20160920111604.32716-1-zajec5@gmail.com>
References: <20160920111604.32716-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And again...

I decided to focus on brcmf_flowring_delete a bit more.

As I can see flowrings are created and removed from time to time, in most cases
they are empty when being deleted. When they are not, things go wrong. In below
log you can see brcmfmac removing flowring that got 8 skb packets.

First some summary, of what was already partially noticed in previous e-mail:
1) brcmf_flowring_delete calls brcmu_pkt_buf_free_skb directly bypassing
   brcmf_txfinalize. It means tracing 802.1x packets and counting TX errors is
   broken.
2) After freeing skb (as the result of brcmf_flowring_delete) there will still
   an IRQ, MSGBUF_TYPE_TX_STATUS and call to the brcmf_txfinalize. That's
   definitely unexpected as brcmf_txfinalize will be operating on skb that was
   already freed.

Now, there is something new that looks even worse. Sometimes brcmf_txfinalize
may be called multiple times for the same skb! Take a close look at my log.
It was called twice for skb c64a5a80. Twice for c64a5480. Twice for c64a5f00.
Then Linux/device rebooted itself due to amount of console messages.

[  242.242012] brcmfmac: [brcmf_msgbuf_process_flow_ring_delete_response -> __brcmf_msgbuf_remove_flowring] flowid:36
[  242.252440] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] flowid:36 ring:c667fd40
[  242.262043] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5780 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.275733] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5540 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.289420] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5180 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.303112] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5f00 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.316802] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a50c0 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.330488] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5480 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.344177] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5a80 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.357867] brcmfmac: [__brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c64a5900 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.371548] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] count:8

[  242.379758] brcmfmac: [brcmf_msgbuf_process_flow_ring_delete_response -> __brcmf_msgbuf_remove_flowring] flowid:37
[  242.390159] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] flowid:37 ring:c667fc80
[  242.399752] brcmfmac: [__brcmf_msgbuf_remove_flowring -> __brcmf_flowring_delete] count:0

[  242.433468] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] da:78:d6:f0:9b:ba:bc prio:0 ifidx:1
[  242.443974] brcmfmac: [brcmf_msgbuf_flowring_create -> __brcmf_flowring_create] flowid:36
[  242.452580] brcmfmac: [brcmf_msgbuf_process_flow_ring_create_response] flowid:36 status:0x0000

[  242.765056] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5900 skb->dev:c647a000 skb->dev->name:wlan1-1
[  242.778479] ------------[ cut here ]------------
[  242.783133] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  242.798724] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  242.871057] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Not tainted 4.4.21 #0
[  242.877686] Hardware name: BCM5301X
[  242.881176] Backtrace: 
[  242.883651] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  242.891230]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[  242.896946] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  242.904186] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  242.912293]  r5:00000009 r4:00000000
[  242.915891] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  242.924696]  r8:a0000013 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5900
[  242.931468] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  242.941680] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  242.952914]  r8:c04903c8 r7:c647a5d0 r6:c64a5900 r5:c648ca00 r4:c647a480
[  242.959687] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  242.970488]  r10:c64a5900 r9:cacd1000 r8:cacd1000 r7:c7395600 r6:0000001e r5:00000000
[  242.978373]  r4:c72bb840
[  242.980934] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  242.992517]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  243.000403]  r4:c72bb840
[  243.002963] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  243.014895]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  243.020608] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  243.030023]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  243.037826] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  243.045412]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  243.051118] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  243.058093]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  243.065979]  r4:c6965080
[  243.068526] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  243.075762]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  243.081465] ---[ end trace 9caeb81bf124e5fc ]---

[  243.086158] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5a80 skb->dev:c647a000 skb->dev->name:wlan1-1
[  243.099579] ------------[ cut here ]------------
[  243.104228] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  243.119822] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  243.192157] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  243.200004] Hardware name: BCM5301X
[  243.203494] Backtrace: 
[  243.205966] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  243.213548]  r7:00000046 r6:bf1d1146 r5:60000093 r4:00000000
[  243.219263] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  243.226504] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  243.234610]  r5:00000009 r4:00000000
[  243.238209] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  243.247005]  r8:a0000013 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5a80
[  243.253779] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  243.263997] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  243.275232]  r8:c04903c8 r7:c647a5d0 r6:c64a5a80 r5:c648c740 r4:c647a480
[  243.282005] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  243.292805]  r10:c64a5a80 r9:cacd1010 r8:cacd1010 r7:c7395600 r6:0000001e r5:00000001
[  243.300691]  r4:c72bb840
[  243.303251] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  243.314835]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  243.322721]  r4:c72bb840
[  243.325281] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  243.337213]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  243.342926] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  243.352341]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  243.360143] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  243.367729]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  243.373435] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  243.380411]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  243.388296]  r4:c6965080
[  243.390844] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  243.398080]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  243.403782] ---[ end trace 9caeb81bf124e5fd ]---

[  243.416467] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5480 skb->dev:c647a000 skb->dev->name:wlan1-1
[  243.429895] ------------[ cut here ]------------
[  243.434549] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  243.450139] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  243.522474] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  243.530321] Hardware name: BCM5301X
[  243.533811] Backtrace: 
[  243.536285] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  243.543864]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  243.549581] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  243.556821] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  243.564928]  r5:00000009 r4:00000000
[  243.568525] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  243.577331]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5480
[  243.584107] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  243.594324] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  243.605566]  r8:c04903c8 r7:c647a5d0 r6:c64a5480 r5:c648c5c0 r4:c647a480
[  243.612339] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  243.623140]  r10:c64a5480 r9:cacd1020 r8:cacd1020 r7:c7395600 r6:0000001e r5:00000000
[  243.631025]  r4:c72bb840
[  243.633584] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  243.645169]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  243.653054]  r4:c72bb840
[  243.655615] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  243.667547]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  243.673261] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  243.682675]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  243.690477] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  243.698063]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  243.703770] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  243.710746]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  243.718632]  r4:c6965080
[  243.721179] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  243.728415]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  243.734117] ---[ end trace 9caeb81bf124e5fe ]---

[  243.738821] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5f00 skb->dev:c647a000 skb->dev->name:wlan1-1
[  243.752240] ------------[ cut here ]------------
[  243.756892] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  243.772482] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  243.844818] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  243.852664] Hardware name: BCM5301X
[  243.856154] Backtrace: 
[  243.858627] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  243.866207]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  243.871923] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  243.879164] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  243.887271]  r5:00000009 r4:00000000
[  243.890869] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  243.899666]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5f00
[  243.906439] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  243.916648] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  243.927884]  r8:c04903c8 r7:c647a5d0 r6:c64a5f00 r5:c648cb00 r4:c647a480
[  243.934655] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  243.945457]  r10:c64a5f00 r9:cacd1030 r8:cacd1030 r7:c7395600 r6:0000001e r5:00000001
[  243.953343]  r4:c72bb840
[  243.955902] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  243.967487]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  243.975372]  r4:c72bb840
[  243.977932] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  243.989864]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  243.995578] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  244.004984]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  244.012787] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  244.020373]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  244.026078] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  244.033055]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  244.040939]  r4:c6965080
[  244.043487] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  244.050723]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  244.056426] ---[ end trace 9caeb81bf124e5ff ]---

[  244.061843] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a50c0 skb->dev:c647a000 skb->dev->name:wlan1-1
[  244.075263] ------------[ cut here ]------------
[  244.079922] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  244.095514] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  244.167850] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  244.175696] Hardware name: BCM5301X
[  244.179186] Backtrace: 
[  244.181660] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  244.189239]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  244.194956] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  244.202196] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  244.210302]  r5:00000009 r4:00000000
[  244.213901] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  244.222706]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a50c0
[  244.229476] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  244.239690] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  244.250924]  r8:c04903c8 r7:c647a5d0 r6:c64a50c0 r5:c648c640 r4:c647a480
[  244.257697] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  244.268497]  r10:c64a50c0 r9:cacd1040 r8:cacd1040 r7:c7395600 r6:0000001e r5:00000000
[  244.276383]  r4:c72bb840
[  244.278942] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  244.290527]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  244.298413]  r4:c72bb840
[  244.300972] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  244.312905]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  244.318618] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  244.328025]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  244.335826] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  244.343404]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  244.349112] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  244.356085]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  244.363972]  r4:c6965080
[  244.366519] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  244.373755]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  244.379457] ---[ end trace 9caeb81bf124e600 ]---

[  244.385925] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5180 skb->dev:c647a000 skb->dev->name:wlan1-1
[  244.399348] ------------[ cut here ]------------
[  244.404009] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  244.419599] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  244.491935] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  244.499780] Hardware name: BCM5301X
[  244.503271] Backtrace: 
[  244.505745] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  244.513333]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  244.519050] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  244.526290] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  244.534397]  r5:00000009 r4:00000000
[  244.537994] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  244.546791]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5180
[  244.553568] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  244.563782] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  244.575018]  r8:c04903c8 r7:c647a5d0 r6:c64a5180 r5:c648cc40 r4:c647a480
[  244.581790] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  244.592590]  r10:c64a5180 r9:cacd1070 r8:cacd1070 r7:c7395600 r6:0000001e r5:00000001
[  244.600477]  r4:c72bb840
[  244.603036] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  244.614621]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  244.622506]  r4:c72bb840
[  244.625066] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  244.636998]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  244.642712] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  244.652126]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  244.659928] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  244.667506]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  244.673213] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  244.680188]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  244.688074]  r4:c6965080
[  244.690622] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  244.697857]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  244.703559] ---[ end trace 9caeb81bf124e601 ]---

[  244.708277] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5f00 skb->dev:c647a000 skb->dev->name:wlan1-1
[  244.721699] ------------[ cut here ]------------
[  244.726339] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  244.741934] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  244.814268] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  244.822116] Hardware name: BCM5301X
[  244.825605] Backtrace: 
[  244.828073] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  244.835659]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  244.841371] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  244.848607] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  244.856713]  r5:00000009 r4:00000000
[  244.860311] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  244.869108]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5f00
[  244.875878] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  244.886092] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  244.897326]  r8:c04903c8 r7:c647a5d0 r6:c64a5f00 r5:c648cb40 r4:c647a480
[  244.904100] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  244.914900]  r10:c64a5f00 r9:cacd1080 r8:cacd1080 r7:c7395600 r6:0000001e r5:00000002
[  244.922786]  r4:c72bb840
[  244.925344] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  244.936930]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  244.944815]  r4:c72bb840
[  244.947375] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  244.959307]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  244.965020] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  244.974426]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  244.982229] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  244.989807]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  244.995512] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  245.002488]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  245.010374]  r4:c6965080
[  245.012920] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  245.020157]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  245.025859] ---[ end trace 9caeb81bf124e602 ]---

[  245.030694] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5480 skb->dev:c647a000 skb->dev->name:wlan1-1
[  245.044121] ------------[ cut here ]------------
[  245.048770] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  245.064365] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  245.136699] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  245.144546] Hardware name: BCM5301X
[  245.148036] Backtrace: 
[  245.150507] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  245.158089]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  245.163805] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  245.171046] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  245.179153]  r5:00000009 r4:00000000
[  245.182752] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  245.191556]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5480
[  245.198328] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  245.208541] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  245.219774]  r8:c04903c8 r7:c647a5d0 r6:c64a5480 r5:c648c340 r4:c647a480
[  245.226548] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (brcmf_msgbuf_txdata+0x53c/0x6e8 [brcmfmac])
[  245.237348]  r10:c64a5480 r9:cacd1090 r8:cacd1090 r7:c7395600 r6:0000001e r5:00000003
[  245.245234]  r4:c72bb840
[  245.247793] [<bf1c3390>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3964>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  245.259378]  r10:00000000 r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:00010000
[  245.267263]  r4:c72bb840
[  245.269823] [<bf1c3928>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c8004>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  245.281757]  r7:c0057d98 r6:c7a0c300 r5:00010000 r4:c68ea800
[  245.287469] [<bf1c7e40>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  245.296884]  r9:c0493882 r8:c6965064 r7:c0057d98 r6:c7a0c300 r5:c6965040 r4:c6965040
[  245.304686] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  245.312272]  r7:c0057d98 r6:c6920000 r5:c6965040 r4:c7a0c300
[  245.317979] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  245.324954]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c6965040 r5:00000000
[  245.332840]  r4:c6965080
[  245.335387] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  245.342623]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6965080
[  245.348326] ---[ end trace 9caeb81bf124e603 ]---

[  245.352983] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c647a480] ***BUG*** skb:c64a5a80 skb->dev:c647a000 skb->dev->name:wlan1-1
[  245.366404] ------------[ cut here ]------------
[  245.371043] WARNING: CPU: 1 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:70 __brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac]()
[  245.386630] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  245.458964] CPU: 1 PID: 616 Comm: irq/33-brcmf_pc Tainted: G        W       4.4.21 #0
[  245.466811] Hardware name: BCM5301X
[  245.470303] Backtrace: 
[  245.472770] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  245.480356]  r7:00000046 r6:bf1d1146 r5:60000193 r4:00000000
[  245.486068] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  245.493303] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  245.501410]  r5:00000009 r4:00000000
[  245.505008] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  245.513813]  r8:a0000113 r7:c647a5d0 r6:bf1c9f2d r5:c647a480 r4:c64a5a80
[  245.520584] [<c002153c>] (warn_slowpath_null) from [<bf1bd550>] (__brcmu_pkt_buf_free_skb+0x98/0x1ec [brcmfmac])
[  245.530797] [<bf1bd4b8>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bde90>] (__brcmf_txfinalize+0x19c/0x1d0 [brcmfmac])
[  245.542032]  r8:c04903c8 r7:c647a5d0 r6:c64a5a80 r5:c648cc00 r4:c647a480
[  245.548805] [<bf1bdcf4>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c377c>] (b�
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 111 ++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  20 +++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  12 ++-
 .../broadcom/brcm80211/brcmfmac/flowring.h         |   6 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  31 +++++-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  27 ++++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |   2 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |   2 +-
 9 files changed, 202 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f02..42d1fdd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,6 +38,48 @@
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
+		unsigned long flags;
+
+		spin_lock_irqsave(&ifp->pend_lock, flags);
+		list_for_each_entry(e, &ifp->pend_skbs, list) {
+			if (e->skb == skb) {
+				pr_info("[%s -> %s] [ifp:%p] ***BUG*** skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+				WARN_ON(1);
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&ifp->pend_lock, flags);
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
@@ -250,6 +292,21 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	if (eh->h_proto == htons(ETH_P_PAE))
 		atomic_inc(&ifp->pend_8021x_cnt);
 
+	{
+		struct pend_skb *e;
+		unsigned long flags;
+
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		e->skb = skb;
+		e->start_time = local_clock();
+		e->start_jiffies = jiffies;
+		e->pae = eh->h_proto == htons(ETH_P_PAE);
+
+		spin_lock_irqsave(&ifp->pend_lock, flags);
+		list_add_tail(&e->list, &ifp->pend_skbs);
+		spin_unlock_irqrestore(&ifp->pend_lock, flags);
+	}
+
 	ret = brcmf_fws_process_skb(ifp, skb);
 
 done:
@@ -333,7 +390,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+		__brcmu_pkt_buf_free_skb(__func__, *ifp, skb);
 		return -ENODATA;
 	}
 
@@ -378,7 +435,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
 	struct ethhdr *eh;
 	u16 type;
@@ -386,8 +443,38 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
+	{
+		struct pend_skb *e, *tmp;
+		//u64 now_time = local_clock();
+		unsigned long now_jiffies = jiffies;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ifp->pend_lock, flags);
+		list_for_each_entry_safe(e, tmp, &ifp->pend_skbs, list) {
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
+		spin_unlock_irqrestore(&ifp->pend_lock, flags);
+	}
+
 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -477,6 +564,9 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	atomic_set(&ifp->pend_8021x_cnt, 0);
 
+	INIT_LIST_HEAD(&ifp->pend_skbs);
+	spin_lock_init(&ifp->pend_lock);
+
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
@@ -1169,7 +1259,22 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 !brcmf_get_pend_8021x_cnt(ifp),
 				 MAX_WAIT_FOR_8021X_TX);
 
-	WARN_ON(!err);
+	//WARN_ON(!err);
+	if (!err)
+		pr_info("[%s] ***TIMEOUT WARNING*** ifp:%p brcmf_ifname(ifp):%s brcmf_get_pend_8021x_cnt(ifp):%d\n", __func__, ifp, brcmf_ifname(ifp), brcmf_get_pend_8021x_cnt(ifp));
+	if (!list_empty(&ifp->pend_skbs)) {
+		struct pend_skb *e;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ifp->pend_lock, flags);
+		list_for_each_entry(e, &ifp->pend_skbs, list) {
+			if (e->pae) {
+				e->timedout = true;
+				pr_info("[%s] Pending 802.1x skb:%p skb->dev:%p skb->dev->name:%s\n", __func__, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+			}
+		}
+		spin_unlock_irqrestore(&ifp->pend_lock, flags);
+	}
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8fa34ca..208f0d2 100644
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
@@ -169,6 +172,16 @@ enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
+struct pend_skb {
+	struct sk_buff *skb;
+	u64 start_time;
+	unsigned long start_jiffies;
+	u64 commit_time;
+	bool timedout;
+	bool pae;
+	struct list_head list;
+};
+
 /**
  * struct brcmf_if - interface control information.
  *
@@ -203,9 +216,13 @@ struct brcmf_if {
 	u8 netif_stop;
 	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
+	bool pend_8021x_ready;
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
+
+	struct list_head pend_skbs;
+	spinlock_t pend_lock;
 };
 
 int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
@@ -219,7 +236,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
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
index 7e269f9..56be839 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -108,7 +108,7 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 }
 
 
-u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
+u32 __brcmf_flowring_create(const char *c0, struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx)
 {
 	struct brcmf_flowring_ring *ring;
@@ -120,6 +120,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	bool sta;
 	u8 *mac;
 
+	pr_info("[%s -> %s] da:%pM prio:%d ifidx:%d\n", c0, __func__, da, prio, ifidx);
 	fifo = brcmf_flowring_prio2fifo[prio];
 	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
 	mac = da;
@@ -167,6 +168,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 		skb_queue_head_init(&ring->skblist);
 		flow->rings[i] = ring;
 
+		pr_info("[%s -> %s] flowid:%d\n", c0, __func__, i);
 		return i;
 	}
 	return BRCMF_FLOWRING_INVALID_ID;
@@ -232,12 +234,14 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
 }
 
 
-void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
+void __brcmf_flowring_delete(const char *c0, struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
 	u16 hash_idx;
 	struct sk_buff *skb;
+	int count = 0;
 
+	pr_info("[%s -> %s] flowid:%d ring:%p\n", c0, __func__, flowid, flow->rings[flowid]);
 	ring = flow->rings[flowid];
 	if (!ring)
 		return;
@@ -249,9 +253,13 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 
 	skb = skb_dequeue(&ring->skblist);
 	while (skb) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmu_pkt_buf_free_skb(skb);
 		skb = skb_dequeue(&ring->skblist);
+		count++;
 	}
+	pr_info("[%s -> %s] count:%d\n", c0, __func__, count);
 
 	kfree(ring);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
index 068e68d..8d82a57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
@@ -59,9 +59,11 @@ struct brcmf_flowring {
 
 u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx);
-u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
+u32 __brcmf_flowring_create(const char *c0, struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx);
-void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid);
+#define brcmf_flowring_create(flow, da, prio, ifidx)	__brcmf_flowring_create(__func__, flow, da, prio, ifidx)
+void __brcmf_flowring_delete(const char *c0, struct brcmf_flowring *flow, u16 flowid);
+#define brcmf_flowring_delete(flow, flowid)	__brcmf_flowring_delete(__func__, flow, flowid)
 void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid);
 u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u16 flowid);
 u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u16 flowid,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 9f9024a..5ab0615 100644
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
@@ -2056,6 +2067,23 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
+	{
+		struct brcmf_if *ifp = brcmf_get_ifp(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX));
+
+		if (ifp) {
+			struct pend_skb *e;
+			unsigned long flags;
+
+			spin_lock_irqsave(&ifp->pend_lock, flags);
+			list_for_each_entry(e, &ifp->pend_skbs, list) {
+				if (e->skb == skb) {
+					e->commit_time = local_clock();
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&ifp->pend_lock, flags);
+		}
+	}
 
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
@@ -2454,6 +2482,7 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
+	struct brcmf_if *ifp = NULL;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 2b9a2bc..07ae721 100644
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
 
@@ -532,11 +537,12 @@ static void brcmf_msgbuf_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb)
 }
 
 static void
-brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
+__brcmf_msgbuf_remove_flowring(const char *c0, struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	u32 dma_sz;
 	void *dma_buf;
 
+	pr_info("[%s -> %s] flowid:%d\n", c0, __func__, flowid);
 	brcmf_dbg(MSGBUF, "Removing flowring %d\n", flowid);
 
 	dma_sz = BRCMF_H2D_TXFLOWRING_MAX_ITEM * BRCMF_H2D_TXFLOWRING_ITEMSIZE;
@@ -546,6 +552,7 @@ brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
 
 	brcmf_flowring_delete(msgbuf->flow, flowid);
 }
+#define brcmf_msgbuf_remove_flowring(msgbuf, flowid)	__brcmf_msgbuf_remove_flowring(__func__, msgbuf, flowid)
 
 
 static struct brcmf_msgbuf_work_item *
@@ -747,6 +754,23 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 			brcmf_commonring_write_complete(commonring);
 			count = 0;
 		}
+		{
+			struct brcmf_if *ifp = brcmf_get_ifp(msgbuf->drvr, tx_msghdr->msg.ifidx);
+
+			if (ifp) {
+				struct pend_skb *e;
+				unsigned long flags;
+
+				spin_lock_irqsave(&ifp->pend_lock, flags);
+				list_for_each_entry(e, &ifp->pend_skbs, list) {
+					if (e->skb == skb) {
+						e->commit_time = local_clock();
+						break;
+					}
+				}
+				spin_unlock_irqrestore(&ifp->pend_lock, flags);
+			}
+		}
 	}
 	if (count)
 		brcmf_commonring_write_complete(commonring);
@@ -1177,6 +1201,7 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	flowid -= BRCMF_NROF_H2D_COMMON_MSGRINGS;
 	status =  le16_to_cpu(flowring_create_resp->compl_hdr.status);
 
+	pr_info("[%s] flowid:%d status:0x%04x\n", __func__, flowid, status);
 	if (status) {
 		brcmf_err("Flowring creation failed, code %d\n", status);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
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
