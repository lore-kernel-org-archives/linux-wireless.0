Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43482 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZDYOxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:53:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Warning in tx.c:775 invoke_tx_handlers
Date: Sat, 25 Apr 2009 16:50:16 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904251650.17142.mb@bu3sch.de> (sfid-20090425_165322_006828_8BFA2031)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just noticed the following warning on my test-AP:

[973533.018255] ------------[ cut here ]------------
[973533.018287] WARNING: at /home/mb/kernel/compat-wireless-2009-04-20/net/mac80211/tx.c:775 invoke_tx_handlers+0xde4/0xe10 [mac80211]()
[973533.018333] Hardware name:         
[973533.018354] Modules linked in: b43 ssb mac80211 cfg80211 [last unloaded: cfg80211]
[973533.018408] Pid: 2825, comm: lighttpd Not tainted 2.6.29.1 #1
[973533.018432] Call Trace:
[973533.018452]  <IRQ>  [<ffffffff80244470>] warn_slowpath+0xd0/0x130
[973533.018504]  [<ffffffffa00153a6>] ? op32_fill_descriptor+0x46/0xd0 [b43]
[973533.018542]  [<ffffffffa0042913>] ? ssb_pci_write32+0x33/0x60 [ssb]
[973533.018573]  [<ffffffff802130a0>] ? nommu_map_single+0x0/0xa0
[973533.018608]  [<ffffffffa00150ed>] ? b43_dma_tx+0x54d/0x7c0 [b43]
[973533.018652]  [<ffffffffa0042974>] ? ssb_pci_write16+0x34/0x60 [ssb]
[973533.018689]  [<ffffffffa0017a05>] ? b43_led_turn_off+0x75/0xa0 [b43]
[973533.018725]  [<ffffffffa0017b9d>] ? b43_led_brightness_set+0x3d/0x70 [b43]
[973533.018767]  [<ffffffffa00e0a94>] invoke_tx_handlers+0xde4/0xe10 [mac80211]
[973533.018808]  [<ffffffffa00e11f3>] ? __ieee80211_tx+0x73/0xf0 [mac80211]
[973533.018850]  [<ffffffffa00e1372>] ? ieee80211_tx+0x102/0x250 [mac80211]
[973533.018891]  [<ffffffffa00e133d>] ieee80211_tx+0xcd/0x250 [mac80211]
[973533.018932]  [<ffffffffa00e2429>] ieee80211_master_start_xmit+0x1e9/0x3a0 [mac80211]
[973533.018975]  [<ffffffff8063912d>] dev_hard_start_xmit+0x25d/0x2e0
[973533.019004]  [<ffffffff80557508>] ? ehci_qtd_alloc+0x18/0x60
[973533.019032]  [<ffffffff80655efe>] __qdisc_run+0x21e/0x270
[973533.019058]  [<ffffffff80639590>] dev_queue_xmit+0x2b0/0x5a0
[973533.019098]  [<ffffffffa00e1dd5>] ieee80211_subif_start_xmit+0x405/0x870 [mac80211]
[973533.019143]  [<ffffffff807a4140>] ? _read_unlock_bh+0x10/0x20
[973533.019172]  [<ffffffff802626a9>] ? getnstimeofday+0x59/0xe0
[973533.019197]  [<ffffffff8063912d>] dev_hard_start_xmit+0x25d/0x2e0
[973533.019226]  [<ffffffff80655efe>] __qdisc_run+0x21e/0x270
[973533.019252]  [<ffffffff80639590>] dev_queue_xmit+0x2b0/0x5a0
[973533.019280]  [<ffffffff80762fd7>] br_dev_queue_push_xmit+0x67/0x90
[973533.019308]  [<ffffffff80763058>] br_forward_finish+0x58/0x60
[973533.019378]  [<ffffffff807631bd>] __br_deliver+0x5d/0x70
[973533.019405]  [<ffffffff807631fd>] br_deliver+0x2d/0x40
[973533.019430]  [<ffffffff807621f6>] br_dev_xmit+0x76/0xa0
[973533.019455]  [<ffffffff8063912d>] dev_hard_start_xmit+0x25d/0x2e0
[973533.019482]  [<ffffffff8063965e>] dev_queue_xmit+0x37e/0x5a0
[973533.019510]  [<ffffffff806ac783>] ip_finish_output+0x223/0x2f0
[973533.019537]  [<ffffffff806ac8bc>] ip_output+0x6c/0xc0
[973533.019563]  [<ffffffff806ab6b0>] ip_local_out+0x20/0x30
[973533.019589]  [<ffffffff806abf4c>] ip_queue_xmit+0x1ec/0x3d0
[973533.019615]  [<ffffffff8027fb36>] ? handle_fasteoi_irq+0x96/0xe0
[973533.019642]  [<ffffffff8024a207>] ? irq_exit+0x47/0xa0
[973533.019668]  [<ffffffff8020f126>] ? do_IRQ+0x86/0x110
[973533.019695]  [<ffffffff806c082b>] tcp_transmit_skb+0x4fb/0x770
[973533.020433]  [<ffffffff806c2cfb>] tcp_write_xmit+0x20b/0xaa0
[973533.020460]  [<ffffffff806c35fb>] __tcp_push_pending_frames+0x2b/0x90
[973533.020488]  [<ffffffff806be073>] tcp_rcv_established+0x173/0x9c0
[973533.020517]  [<ffffffff806c6ee0>] tcp_v4_do_rcv+0x280/0x3c0
[973533.020544]  [<ffffffff80688bc4>] ? nf_ct_deliver_cached_events+0x44/0xd0
[973533.020574]  [<ffffffff806ed863>] ? ipv4_confirm+0xd3/0x140
[973533.020600]  [<ffffffff806c77cb>] tcp_v4_rcv+0x7ab/0x860
[973533.020627]  [<ffffffff8067ddab>] ? nf_hook_slow+0xab/0x100
[973533.020654]  [<ffffffff806a6db0>] ? ip_local_deliver_finish+0x0/0x2b0
[973533.020683]  [<ffffffff806a6ece>] ip_local_deliver_finish+0x11e/0x2b0
[973533.020711]  [<ffffffff806a70ed>] ip_local_deliver+0x8d/0xa0
[973533.020738]  [<ffffffff806a6883>] ip_rcv_finish+0x1b3/0x3d0
[973533.020764]  [<ffffffff806a6d1a>] ip_rcv+0x27a/0x310
[973533.020790]  [<ffffffff8063821c>] netif_receive_skb+0x2bc/0x590
[973533.020817]  [<ffffffff80763e68>] br_handle_frame_finish+0x188/0x190
[973533.020846]  [<ffffffff80769038>] br_nf_pre_routing_finish+0x308/0x340
[973533.020876]  [<ffffffff8067ddab>] ? nf_hook_slow+0xab/0x100
[973533.020904]  [<ffffffff80768d30>] ? br_nf_pre_routing_finish+0x0/0x340
[973533.020933]  [<ffffffff807695e1>] br_nf_pre_routing+0x571/0x870
[973533.020961]  [<ffffffff8067dcc7>] nf_iterate+0x67/0xa0
[973533.020986]  [<ffffffff80763ce0>] ? br_handle_frame_finish+0x0/0x190
[973533.021014]  [<ffffffff8067ddab>] nf_hook_slow+0xab/0x100
[973533.021039]  [<ffffffff80763ce0>] ? br_handle_frame_finish+0x0/0x190
[973533.021068]  [<ffffffff80763fce>] br_handle_frame+0x15e/0x220
[973533.021096]  [<ffffffff8063814b>] netif_receive_skb+0x1eb/0x590
[973533.021124]  [<ffffffff80638565>] process_backlog+0x75/0xc0
[973533.021152]  [<ffffffff80636312>] net_rx_action+0xf2/0x1b0
[973533.021179]  [<ffffffff8024a584>] __do_softirq+0x94/0x160
[973533.021205]  [<ffffffff8020d4fc>] call_softirq+0x1c/0x30
[973533.021228]  <EOI>  [<ffffffff8020eec5>] do_softirq+0x45/0x90
[973533.021259]  [<ffffffff8024a395>] local_bh_enable_ip+0xa5/0xb0
[973533.021287]  [<ffffffff807a415f>] _spin_unlock_bh+0xf/0x20
[973533.021314]  [<ffffffff8062af77>] release_sock+0xb7/0xd0
[973533.021341]  [<ffffffff806b5b83>] tcp_sendpage+0xf3/0x6c0
[973533.021368]  [<ffffffff806270cb>] sock_sendpage+0x3b/0x40
[973533.021395]  [<ffffffff802e0fcf>] pipe_to_sendpage+0x5f/0x80
[973533.021421]  [<ffffffff802e1ee8>] __splice_from_pipe+0x118/0x270
[973533.021448]  [<ffffffff802e0f70>] ? pipe_to_sendpage+0x0/0x80
[973533.021475]  [<ffffffff802e0f70>] ? pipe_to_sendpage+0x0/0x80
[973533.021502]  [<ffffffff802e22d1>] splice_from_pipe+0x61/0x90
[973533.021528]  [<ffffffff802e2310>] generic_splice_sendpage+0x10/0x20
[973533.021555]  [<ffffffff802e151e>] do_splice_from+0x7e/0xb0
[973533.021580]  [<ffffffff802e156b>] direct_splice_actor+0x1b/0x20
[973533.021607]  [<ffffffff802e1b03>] splice_direct_to_actor+0xe3/0x1d0
[973533.021635]  [<ffffffff802e1550>] ? direct_splice_actor+0x0/0x20
[973533.021663]  [<ffffffff802e1c29>] do_splice_direct+0x39/0x60
[973533.021690]  [<ffffffff802c0fb6>] do_sendfile+0x176/0x280
[973533.021717]  [<ffffffff802d0490>] ? poll_select_set_timeout+0x80/0x90
[973533.021744]  [<ffffffff802c1145>] sys_sendfile64+0x85/0xb0
[973533.021769]  [<ffffffff802d0c67>] ? sys_poll+0x77/0x110
[973533.021795]  [<ffffffff8020c49b>] system_call_fastpath+0x16/0x1b
[973533.021822] ---[ end trace 762692ad4a69c61e ]---

-- 
Greetings, Michael.
