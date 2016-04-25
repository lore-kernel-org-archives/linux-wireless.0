Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34547 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbcDYO7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 10:59:39 -0400
Date: Mon, 25 Apr 2016 16:59:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: 4.6-rc5 on arm (nokia n900): spinlock bad magic on CPU#0,
Message-ID: <20160425145933.GA10740@amd> (sfid-20160425_165957_664193_83366A87)
References: <20160425112028.GA22359@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160425112028.GA22359@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> First time such thing happened, normally N900 is very stable.

Second time, within a day. It seems rather repeatable. I tested 4.4
rather heavily, and seen any backtraces... 

Oh, and some saboteur seemed to turn on ipv6 on my wifi. Probably
unrelated....

Best regards,
								Pavel


[  157.867431] DSS: dss_save_context
[  157.867462] DSS: context saved
[  322.248291] BUG: spinlock bad magic on CPU#0, kworker/u2:3/2693
[  322.248687]  lock: 0xce670f40, .magic: 00000000, .owner: <none>/-1,
.owner_cpu: 0
[  322.249114] CPU: 0 PID: 2693 Comm: kworker/u2:3 Not tainted
4.6.0-rc5-176733-g8b658a3-dirty #244
[  322.249603] Hardware name: Nokia RX-51 board
[  322.249877] Workqueue: phy1 wl1251_irq_work
[  322.250183] [<c010eebc>] (unwind_backtrace) from [<c010b150>]
(show_stack+0x10/0x14)
[  322.250640] [<c010b150>] (show_stack) from [<c04232b0>]
(dump_stack+0x8c/0xac)
[  322.251068] [<c04232b0>] (dump_stack) from [<c017cf78>]
(do_raw_spin_lock+0x198/0x1b8)
[  322.251495] [<c017cf78>] (do_raw_spin_lock) from [<c084ed98>]
(_raw_spin_lock_irqsave+0x10/0x18)
[  322.251922] [<c084ed98>] (_raw_spin_lock_irqsave) from [<c05aaf20>]
(wl1251_op_tx+0x38/0x5c)
[  322.252380] [<c05aaf20>] (wl1251_op_tx) from [<c0818788>]
(ieee80211_tx_frags+0xd0/0x3d4)
[  322.252807] [<c0818788>] (ieee80211_tx_frags) from [<c0818af8>]
(__ieee80211_tx+0x6c/0x134)
[  322.253234] [<c0818af8>] (__ieee80211_tx) from [<c081a034>]
(ieee80211_tx+0xb4/0xdc)
[  322.253631] [<c081a034>] (ieee80211_tx) from [<c081ad38>]
(__ieee80211_subif_start_xmit+0x540/0x6d0)
[  322.254089] [<c081ad38>] (__ieee80211_subif_start_xmit) from
[<c081aed4>] (ieee80211_subif_start_xmit+0xc/0x14)
[  322.254608] [<c081aed4>] (ieee80211_subif_start_xmit) from
[<c06a5f40>] (dev_hard_start_xmit+0x228/0x440)
[  322.255096] [<c06a5f40>] (dev_hard_start_xmit) from [<c06c60f0>]
(sch_direct_xmit+0xf4/0x220)
[  322.255523] [<c06c60f0>] (sch_direct_xmit) from [<c06a6500>]
(__dev_queue_xmit+0x25c/0x62c)
[  322.255981] [<c06a6500>] (__dev_queue_xmit) from [<c06d80bc>]
(ip_finish_output2+0x1a0/0x3d0)
[  322.256408] [<c06d80bc>] (ip_finish_output2) from [<c06d91a8>]
(ip_output+0x130/0x144)
[  322.256805] [<c06d91a8>] (ip_output) from [<c06d8854>]
(ip_local_out+0x38/0x3c)
[  322.257202] [<c06d8854>] (ip_local_out) from [<c06f1010>]
(tcp_transmit_skb+0x510/0x984)
[  322.257598] [<c06f1010>] (tcp_transmit_skb) from [<c06edc9c>]
(tcp_rcv_established+0x360/0x728)
[  322.258056] [<c06edc9c>] (tcp_rcv_established) from [<c06f6a24>]
(tcp_v4_do_rcv+0x14c/0x1b0)
[  322.258483] [<c06f6a24>] (tcp_v4_do_rcv) from [<c06f9034>]
(tcp_v4_rcv+0xc3c/0xc58)
[  322.258880] [<c06f9034>] (tcp_v4_rcv) from [<c06d3358>]
(ip_local_deliver_finish+0x5c/0x29c)
[  322.268096] [<c06d3358>] (ip_local_deliver_finish) from
[<c06d3790>] (ip_local_deliver+0xd0/0xd8)
[  322.277374] [<c06d3790>] (ip_local_deliver) from [<c06d3094>]
(ip_rcv_finish+0x1f0/0x458)
[  322.286590] [<c06d3094>] (ip_rcv_finish) from [<c06d3b34>]
(ip_rcv+0x39c/0x56c)
[  322.295715] [<c06d3b34>] (ip_rcv) from [<c069e2d0>]
(__netif_receive_skb_core+0x2e8/0x958)
[  322.304809] [<c069e2d0>] (__netif_receive_skb_core) from
[<c06a2b4c>] (netif_receive_skb_internal+0x30/0xa0)
[  322.323059] [<c06a2b4c>] (netif_receive_skb_internal) from
[<c0812490>] (ieee80211_deliver_skb+0x184/0x1bc)
[  322.341827] [<c0812490>] (ieee80211_deliver_skb) from [<c08136e0>]
(ieee80211_rx_handlers+0xe9c/0x201c)
[  322.360961] [<c08136e0>] (ieee80211_rx_handlers) from [<c0814a18>]
(ieee80211_prepare_and_rx_handle+0x1b8/0x9b4)
[  322.380493] [<c0814a18>] (ieee80211_prepare_and_rx_handle) from
[<c0815894>] (ieee80211_rx_napi+0x680/0x7f0)
[  322.400390] [<c0815894>] (ieee80211_rx_napi) from [<c05ad0c0>]
(wl1251_rx+0x324/0x49c)
[  322.410522] [<c05ad0c0>] (wl1251_rx) from [<c05ab660>]
(wl1251_irq_work+0x154/0x1b0)
[  322.420532] [<c05ab660>] (wl1251_irq_work) from [<c014ce64>]
(process_one_work+0x130/0x428)
[  322.430450] [<c014ce64>] (process_one_work) from [<c014d2f0>]
(worker_thread+0x15c/0x490)
[  322.440277] [<c014d2f0>] (worker_thread) from [<c01522f4>]
(kthread+0xd4/0xf0)
[  322.449951] [<c01522f4>] (kthread) from [<c0107918>]
(ret_from_fork+0x14/0x3c)
pavel@n900:/my$


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
