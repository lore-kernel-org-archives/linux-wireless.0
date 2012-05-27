Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41928 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2E0X3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 19:29:42 -0400
Message-ID: <4FC2B8E0.8060805@openwrt.org> (sfid-20120528_013005_935387_C2F90528)
Date: Mon, 28 May 2012 01:29:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Ben Greear <greearb@candelatech.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL> <4FC2437C.9090106@candelatech.com> <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com> <4FC26EED.5090906@openwrt.org> <CAJ-VmokeucgfCOhFQms9hMkvGdN1VikU0cdybURXWfnO+RzOcA@mail.gmail.com>
In-Reply-To: <CAJ-VmokeucgfCOhFQms9hMkvGdN1VikU0cdybURXWfnO+RzOcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-28 1:15 AM, Adrian Chadd wrote:
> Sweet. Thanks a lot for chasing that up.
> 
> What's the oprofile output look like for the AR7242 when doing that?
Haven't run oprofile on the AR7242 yet, but here's what 350Mbits/s UDP
ethernet-rx <-> wifi-tx traffic (bridged) looks like on AR9344:

CPU: MIPS 74K, speed 417 MHz (estimated)
Counted CYCLES events (0-0 Cycles) with a unit mask of 0x00 (No unit mask) count 10000
samples  %        app name                 symbol name
203986    6.8165  vmlinux                  ag71xx_poll
139395    4.6581  vmlinux                  __do_softirq
119259    3.9852  mac80211.ko              invoke_tx_handlers
112990    3.7757  vmlinux                  ring_buffer_consume
89195     2.9806  mac80211.ko              ieee80211_tx_status
69185     2.3119  vmlinux                  __copy_user
67684     2.2618  vmlinux                  __bzero
67014     2.2394  ath9k.ko                 ath_txq_schedule
65597     2.1920  vmlinux                  __slab_alloc.isra.60.constprop.63
65375     2.1846  vmlinux                  eth_type_trans
63594     2.1251  vmlinux                  r4k_dma_cache_inv
61121     2.0425  mac80211.ko              ieee80211_subif_start_xmit
50797     1.6975  ath9k_hw.ko              ar9003_set_txdesc
49942     1.6689  vmlinux                  __rmemcpy
48397     1.6173  ath9k.ko                 ath_tx_complete
46697     1.5605  vmlinux                  skb_release_data
45083     1.5065  vmlinux                  __netif_receive_skb
43928     1.4679  ath9k.ko                 ath_tx_complete_aggr.isra.21
43289     1.4466  vmlinux                  vlan_untag
41766     1.3957  mac80211.ko              minstrel_ht_set_rate
41154     1.3752  ath9k.ko                 ath_tx_setup_buffer.isra.18
41136     1.3746  vmlinux                  pfifo_fast_dequeue
40500     1.3534  vmlinux                  __slab_free.isra.58
39498     1.3199  vmlinux                  __qdisc_run
39278     1.3125  ath9k.ko                 ath_tx_start
38789     1.2962  vmlinux                  r4k_dma_cache_wback_inv
38497     1.2864  ath9k.ko                 ath_tx_fill_desc
37308     1.2467  vmlinux                  kfree
36235     1.2109  vmlinux                  br_handle_frame
35178     1.1755  vmlinux                  skb_put
34532     1.1539  vmlinux                  __kmalloc_track_caller
31535     1.0538  vmlinux                  kmem_cache_alloc
31045     1.0374  vmlinux                  dev_queue_xmit
30953     1.0343  vmlinux                  vlan_do_receive
30151     1.0075  mac80211.ko              __ieee80211_tx
30132     1.0069  vmlinux                  put_cpu_partial
29625     0.9900  vmlinux                  mips_dma_map_page
28214     0.9428  mac80211.ko              ieee80211_tx_prepare
27059     0.9042  vmlinux                  br_fdb_update
25845     0.8637  oprofile.ko              add_event_entry
25230     0.8431  vmlinux                  br_handle_frame_finish
24652     0.8238  vmlinux                  net_rx_action
22232     0.7429  mac80211.ko              rate_control_get_rate
21840     0.7298  mac80211.ko              minstrel_ht_get_rate
21591     0.7215  mac80211.ko              ccmp_encrypt_skb
20313     0.6788  ath9k.ko                 ath9k_ps_restore
20055     0.6702  vmlinux                  r4k_wait_irqoff
19867     0.6639  vmlinux                  dev_hard_start_xmit
19220     0.6423  vmlinux                  __br_fdb_get
18673     0.6240  vmlinux                  ksize
17769     0.5938  vmlinux                  __alloc_skb
17687     0.5910  vmlinux                  kmem_cache_free
17605     0.5883  mac80211.ko              minstrel_ht_tx_status
17112     0.5718  mac80211.ko              ieee80211_select_queue
16926     0.5656  ath9k.ko                 ath_tx_complete_buf
16310     0.5450  vmlinux                  pfifo_fast_enqueue
16065     0.5368  vmlinux                  local_bh_enable
15586     0.5208  ath9k.ko                 ath_tx_update_baw.isra.14
14449     0.4828  vmlinux                  skb_push
14097     0.4711  oprofile.ko              sync_buffer
13755     0.4596  vmlinux                  napi_complete
12793     0.4275  vmlinux                  mips_dma_unmap_page
12228     0.4086  vmlinux                  br_dev_queue_push_xmit
12212     0.4081  vmlinux                  br_forward
12149     0.4060  vmlinux                  __netdev_alloc_skb
11250     0.3759  vmlinux                  rcu_bh_qs
11153     0.3727  vmlinux                  atomic64_add_return
11123     0.3717  ath9k.ko                 ath9k_tx
11026     0.3685  ath9k.ko                 ath_debug_stat_tx
10763     0.3597  oprofile.ko              op_cpu_buffer_read_entry
