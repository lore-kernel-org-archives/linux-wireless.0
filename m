Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40213 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3COROb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 13:14:31 -0400
Message-ID: <514356F3.4030408@candelatech.com> (sfid-20130315_181435_255433_46F54581)
Date: Fri, 15 Mar 2013 10:14:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Optimizing performance for lots of virtual stations.
References: <5142074C.1060708@candelatech.com> <51425963.2000904@openwrt.org> <51425AB1.9090603@candelatech.com> <51427CFF.1020105@openwrt.org> <514294ED.7040909@candelatech.com>
In-Reply-To: <514294ED.7040909@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I probably should have done this first of course..but here is a 'perf top' on
the station machine (50 TCP streams transmitting on each of 50 stations,
and 78 associated-but-mostly-idle stations:

Looks like sta_info_get would be a good place to start :)


---------------------------------------------------------------------------------------------------------------------------
    PerfTop:    1890 irqs/sec  kernel:87.9%  exact:  0.0% [1000Hz cycles],  (all, 2 CPUs)
---------------------------------------------------------------------------------------------------------------------------

              samples  pcnt function                        DSO
              _______ _____ _______________________________ ______________

              2261.00 20.8% sta_info_get                    [mac80211]
              1707.00 15.7% ieee80211_tx_status             [mac80211]
              1192.00 11.0% intel_idle                      [kernel]
               462.00  4.3% __ieee80211_recalc_idle         [mac80211]
               414.00  3.8% ieee80211_prepare_and_rx_handle [mac80211]
               240.00  2.2% dev_queue_xmit_nit              [kernel]
               199.00  1.8% ieee80211_rx                    [mac80211]
               154.00  1.4% ieee80211_find_sta_by_ifaddr    [mac80211]
               124.00  1.1% read_hpet                       [kernel]
               101.00  0.9% _raw_spin_lock_irqsave          [kernel]
                92.00  0.8% __netif_receive_skb             [kernel]
                80.00  0.7% tg_load_down                    [kernel]
                76.00  0.7% fget_light                      [kernel]
                75.00  0.7% ieee80211_propagate_queue_wake  [mac80211]
                75.00  0.7% memcpy                          [kernel]
                71.00  0.7% __ieee80211_stop_queue          [mac80211]
                70.00  0.6% ipt_do_table                    [kernel]
                66.00  0.6% csum_partial_copy_generic       [kernel]
                65.00  0.6% datagram_poll                   [kernel]
                63.00  0.6% _raw_spin_lock_bh               [kernel]
                61.00  0.6% ath_get_rate                    [ath9k]
                49.00  0.5% ieee80211_subif_start_xmit      [mac80211]
                48.00  0.4% tcp_poll                        [kernel]

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

