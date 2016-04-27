Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbcD0T7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 15:59:38 -0400
Date: Wed, 27 Apr 2016 21:59:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: 4.6-rc5 on arm (nokia n900): spinlock bad magic on CPU#0,
Message-ID: <20160427195934.GA18806@amd> (sfid-20160427_215957_655541_ED5A354E)
References: <20160425112028.GA22359@amd>
 <20160425145933.GA10740@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160425145933.GA10740@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 2016-04-25 16:59:33, Pavel Machek wrote:
> Hi!
> 
> > First time such thing happened, normally N900 is very stable.
> 
> Second time, within a day. It seems rather repeatable. I tested 4.4
> rather heavily, and seen any backtraces... 
> 
> Oh, and some saboteur seemed to turn on ipv6 on my wifi. Probably
> unrelated....

Happened again today. Definitely a regression from 4.4...

									Pavel

[  266.151550] BUG: spinlock bad magic on CPU#0, kworker/u2:0/6
[  266.151611]  lock: 0xcd644f40, .magic: 00000000, .owner: <none>/-1,
.owner_cpu: 0
[  266.151641] CPU: 0 PID: 6 Comm: kworker/u2:0 Tainted: G        W
4.6.0-rc5-176860-gd6fbb13-dirty #251
[  266.151672] Hardware name: Nokia RX-51 board
[  266.151702] Workqueue: phy1 wl1251_irq_work
[  266.151794] [<c010eebc>] (unwind_backtrace) from [<c010b150>]
(show_stack+0x10/0x14)
[  266.151824] [<c010b150>] (show_stack) from [<c0423a90>]
(dump_stack+0x8c/0xac)
[  266.151855] [<c0423a90>] (dump_stack) from [<c017d770>]
(do_raw_spin_lock+0x198/0x1b8)
[  266.151916] [<c017d770>] (do_raw_spin_lock) from [<c0834078>]
(_raw_spin_lock_irqsave+0x10/0x18)
[  266.151947] [<c0834078>] (_raw_spin_lock_irqsave) from [<c05a9bec>]
(wl1251_op_tx+0x38/0x5c)
[  266.151977] [<c05a9bec>] (wl1251_op_tx) from [<c07fda44>]
(ieee80211_tx_frags+0xd0/0x3d4)
[  266.152008] [<c07fda44>] (ieee80211_tx_frags) from [<c07fddb4>]
(__ieee80211_tx+0x6c/0x134)
[  266.152069] [<c07fddb4>] (__ieee80211_tx) from [<c07ff2f0>]
(ieee80211_tx+0xb4/0xdc)
[  266.152099] [<c07ff2f0>] (ieee80211_tx) from [<c0800018>]
(__ieee80211_subif_start_xmit+0x540/0x6d0)
[  266.152130] [<c0800018>] (__ieee80211_subif_start_xmit) from
[<c08001b4>] (ieee80211_subif_start_xmit+0xc/0x14)
[  266.152160] [<c08001b4>] (ieee80211_subif_start_xmit) from
[<c068c394>] (dev_hard_start_xmit+0x228/0x440)
[  266.152191] [<c068c394>] (dev_hard_start_xmit) from [<c06ac500>]
(sch_direct_xmit+0xf4/0x220)
[  266.152221] [<c06ac500>] (sch_direct_xmit) from [<c068c954>]
(__dev_queue_xmit+0x25c/0x62c)
[  266.152252] [<c068c954>] (__dev_queue_xmit) from [<c06be4cc>]
(ip_finish_output2+0x1a0/0x3d0)
[  266.152282] [<c06be4cc>] (ip_finish_output2) from [<c06bf5b8>]
(ip_output+0x130/0x144)
[  266.152313] [<c06bf5b8>] (ip_output) from [<c06bec64>]
(ip_local_out+0x38/0x3c)
[  266.152343] [<c06bec64>] (ip_local_out) from [<c06d7420>]
(tcp_transmit_skb+0x510/0x984)
[  266.152404] [<c06d7420>] (tcp_transmit_skb) from [<c06d40ac>]
(tcp_rcv_established+0x360/0x728)
[  266.152435] [<c06d40ac>] (tcp_rcv_established) from [<c06dce34>]
(tcp_v4_do_rcv+0x14c/0x1b0)
[  266.152465] [<c06dce34>] (tcp_v4_do_rcv) from [<c06df444>]
(tcp_v4_rcv+0xc3c/0xc58)
[  266.152496] [<c06df444>] (tcp_v4_rcv) from [<c06b9768>]
(ip_local_deliver_finish+0x5c/0x29c)
[  266.152526] [<c06b9768>] (ip_local_deliver_finish) from
[<c06b9ba0>] (ip_local_deliver+0xd0/0xd8)
[  266.152557] [<c06b9ba0>] (ip_local_deliver) from [<c06b94a4>]
(ip_rcv_finish+0x1f0/0x458)
[  266.152587] [<c06b94a4>] (ip_rcv_finish) from [<c06b9f44>]
(ip_rcv+0x39c/0x56c)
[  266.152618] [<c06b9f44>] (ip_rcv) from [<c0684724>]
(__netif_receive_skb_core+0x2e8/0x958)
[  266.152648] [<c0684724>] (__netif_receive_skb_core) from
[<c0688fa0>] (netif_receive_skb_internal+0x30/0xa0)
[  266.152679] [<c0688fa0>] (netif_receive_skb_internal) from
[<c07f7750>] (ieee80211_deliver_skb+0x184/0x1bc)
[  266.152709] [<c07f7750>] (ieee80211_deliver_skb) from [<c07f89a0>]
(ieee80211_rx_handlers+0xe9c/0x201c)
[  266.152740] [<c07f89a0>] (ieee80211_rx_handlers) from [<c07f9cd8>]
(ieee80211_prepare_and_rx_handle+0x1b8/0x9b4)
[  266.152770] [<c07f9cd8>] (ieee80211_prepare_and_rx_handle) from
[<c07fab54>] (ieee80211_rx_napi+0x680/0x7f0)
[  266.152832] [<c07fab54>] (ieee80211_rx_napi) from [<c05abf08>]
(wl1251_rx+0x324/0x49c)
[  266.152862] [<c05abf08>] (wl1251_rx) from [<c05aa320>]
(wl1251_irq_work+0x144/0x1b0)
[  266.152893] [<c05aa320>] (wl1251_irq_work) from [<c014d65c>]
(process_one_work+0x130/0x428)
[  266.152923] [<c014d65c>] (process_one_work) from [<c014dae8>]
(worker_thread+0x15c/0x490)
[  266.152954] [<c014dae8>] (worker_thread) from [<c0152aec>]
(kthread+0xd4/0xf0)
[  266.152984] [<c0152aec>] (kthread) from [<c0107918>]
(ret_from_fork+0x14/0x3c)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
