Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([206.191.95.214]:52343 "EHLO
	mail.lenbrook.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbBLVOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 16:14:34 -0500
Message-ID: <54DD14E7.80101@lenbrook.com> (sfid-20150212_221439_781742_48F49DD0)
Date: Thu, 12 Feb 2015 16:02:31 -0500
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Solomon Peachy <pizza@shaftnet.org>
Subject: cw1200 - deadlock warning on imx6 quad core
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[  108.191975] ======================================================
[  108.198157] [ INFO: possible circular locking dependency detected ]
[  108.204430] 3.17.2 #9 Not tainted
[  108.207748] -------------------------------------------------------
[  108.214018] kworker/u8:1/30 is trying to acquire lock:
[  108.219160]  (&priv->conf_mutex){+.+.+.}, at: [<80442380>] 
cw1200_bss_params_work+0x24/0x4c
[  108.227593]
[  108.227593] but task is already holding lock:
[  108.233430]  ((&priv->bss_params_work)){+.+...}, at: [<8003dd44>] 
process_one_work+0x13c/0x3fc
[  108.242111]
[  108.242111] which lock already depends on the new lock.
[  108.242111]
[  108.250294]
[  108.250294] the existing dependency chain (in reverse order) is:
[  108.257780]
-> #2 ((&priv->bss_params_work)){+.+...}:
[  108.263065]        [<8003cf10>] flush_work+0x44/0x268
[  108.268138]        [<8003eac0>] __cancel_work_timer+0x88/0x12c
[  108.273992]        [<8003eb90>] cancel_work_sync+0x14/0x18
[  108.279497]        [<804410ac>] __cw1200_cqm_bssloss_sm+0x30/0x148
[  108.285699]        [<804438b8>] cw1200_bss_info_changed+0x23c/0xc78
[  108.291988]        [<8066c23c>] 
ieee80211_bss_info_change_notify+0xa8/0x11c
[  108.298980]        [<806b12cc>] ieee80211_assoc_success+0x7cc/0xa18
[  108.305273]        [<8069cefc>] ieee80211_rx_mgmt_assoc_resp+0x13c/0x26c
[  108.311994]        [<8069d32c>] ieee80211_sta_rx_queued_mgmt+0x28c/0x5e8
[  108.318714]        [<8067ba94>] ieee80211_iface_work+0x280/0x354
[  108.324747]        [<8003ddb0>] process_one_work+0x1a8/0x3fc
[  108.330426]        [<8003e158>] worker_thread+0x118/0x4d0
[  108.335844]        [<80042fec>] kthread+0xd0/0xec
[  108.340567]        [<8000eac8>] ret_from_fork+0x14/0x2c
[  108.345817]
-> #1 (&(&priv->bss_loss_lock)->rlock){+.+...}:
[  108.351623]        [<806b631c>] _raw_spin_lock+0x34/0x44
[  108.356958]        [<804438a4>] cw1200_bss_info_changed+0x228/0xc78
[  108.363246]        [<8066c23c>] 
ieee80211_bss_info_change_notify+0xa8/0x11c
[  108.370230]         [<806b12cc>] ieee80211_assoc_success+0x7cc/0xa18
[  108.376597]        [<8069cefc>] ieee80211_rx_mgmt_assoc_resp+0x13c/0x26c
[  108.383318]        [<8069d32c>] ieee80211_sta_rx_queued_mgmt+0x28c/0x5e8
[  108.390038]        [<8067ba94>] ieee80211_iface_work+0x280/0x354
[  108.396066]        [<8003ddb0>] process_one_work+0x1a8/0x3fc
[  108.401745]        [<8003e158>] worker_thread+0x118/0x4d0
[  108.407163]        [<80042fec>] kthread+0xd0/0xec
[  108.411885]        [<8000eac8>] ret_from_fork+0x14/0x2c
[  108.417131]
-> #0 (&priv->conf_mutex){+.+.+.}:
[  108.421808]        [<800600d8>] lock_acquire+0x68/0x7c
[  108.426971]        [<806b446c>] mutex_lock_nested+0x5c/0x3c0
[  108.432651]        [<80442380>] cw1200_bss_params_work+0x24/0x4c
[  108.438682]        [<8003ddb0>] process_one_work+0x1a8/0x3fc
[  108.444361]        [<8003e158>] worker_thread+0x118/0x4d0
[  108.449780]        [<80042fec>] kthread+0xd0/0xec
[  108.454502]        [<8000eac8>] ret_from_fork+0x14/0x2c
[  108.459749]
[  108.459749] other info that might help us debug this:
[  108.459749]
[  108.467758] Chain exists of:
   &priv->conf_mutex --> &(&priv->bss_loss_lock)->rlock --> 
(&priv->bss_params_work)

[  108.478281]  Possible unsafe locking scenario:
[  108.478281]
[  108.484204]        CPU0                    CPU1
[  108.488736]        ----                    ----
[  108.493268]   lock((&priv->bss_params_work));
[  108.497655] lock(&(&priv->bss_loss_lock)->rlock);
[  108.505081] lock((&priv->bss_params_work));
[  108.511987]   lock(&priv->conf_mutex);
[  108.515766]
[  108.515766]  *** DEADLOCK ***
[  108.515766]
[  108.521692] 2 locks held by kworker/u8:1/30:
[  108.525964]  #0:  ("%s""cw1200_wq"){.+.+.+}, at: [<8003dd44>] 
process_one_work+0x13c/0x3fc
[  108.534308]  #1:  ((&priv->bss_params_work)){+.+...}, at: 
[<8003dd44>] process_one_work+0x13c/0x3fc
[  108.543433]
[  108.543433] stack backtrace:
[  108.547799] CPU: 2 PID: 30 Comm: kworker/u8:1 Not tainted 3.17.2 #9
[  108.554074] Workqueue: cw1200_wq cw1200_bss_params_work
[  108.559315] Backtrace:
[  108.561791] [<80011dc0>] (dump_backtrace) from [<80011f60>] 
(show_stack+0x18/0x1c)
[  108.569363]  r6:80b28700 r5:00000000 r4:00000000 r3:be1d3a80
[  108.575094] [<80011f48>] (show_stack) from [<806af960>] 
(dump_stack+0x80/0x9c)
[  108.582325] [<806af8e0>] (dump_stack) from [<806ad704>] 
(print_circular_bug+0x284/0x2dc)
[  108.590417]  r5:80b28a30 r4:80b26610
[  108.594032] [<806ad480>] (print_circular_bug) from [<8005f864>] 
(__lock_acquire+0x19c8/0x1d0c)
[  108.602645]  r10:00000110 r9:be1d3f08 r8:80b28a30 r7:00000000 
r6:811ba594 r5:be1d3ef0
[  108.610555]  r4:be1d3a80 r3:be1d3ef0
[  108.614168] [<8005de9c>] (__lock_acquire) from [<800600d8>] 
(lock_acquire+0x68/0x7c)
[  108.621914]  r10:be210000 r9:be1d3a80 r8:be210000 r7:00000000 
r6:60000013 r5:be210000
[  108.629826]  r4:00000000
[  108.632384] [<80060070>] (lock_acquire) from [<806b446c>] 
(mutex_lock_nested+0x5c/0x3c0)
[  108.640477]  r7:00000000- r6:8116af54 r5:80442380 r4:bd6895ac
[  108.646294] [<806b4410>] (mutex_lock_nested) from [<80442380>] 
(cw1200_bss_params_work+0x24/0x4c)
[  108.655168]  r10:00000000 r9:00000001 r8:be210000 r7:bd42bd00 
r6:bd689560 r5:bd6895ac
[  108.663078]  r4:bd68a490
[  108.665637] [<8044235c>] (cw1200_bss_params_work) from [<8003ddb0>] 
(process_one_work+0x1a8/0x3fc)
[  108.674597]  r6:be011c00 r5:bd68a490 r4:be1f3880 r3:8044235c
[  108.680328] [<8003dc08>] (process_one_work) from [<8003e158>] 
(worker_thread+0x118/0x4d0)
[  108.688508]  r10:00000088 r9:be011c00 r8:be1f3898 r7:be011c30 
r6:be210000 r5:be011c00
[  108.696417]  r4:be1f3880
[  108.698973] [<8003e040>] (worker_thread) from [<80042fec>] 
(kthread+0xd0/0xec)
[  108.706198]  r10:00000000 r9:00000000 r8:00000000 r7:8003e040 
r6:be1f3880 r5:be1f5100
[  108.714107]  r4:00000000
[  108.716665] [<80042f1c>] (kthread) from [<8000eac8>] 
(ret_from_fork+0x14/0x2c)
[  108.723889]  r7:00000000 r6:00000000 r5:80042f1c r4:be1f5100

-- 
Jonathan Bagg
Embedded Systems Developer
NAD Electronics | Lenbrook Industries Limited
633 Granite Court, Pickering, Ontario, Canada L1W 3K1 | 905-831-0799 ext 4478 | http://www.nadelectronics.com

