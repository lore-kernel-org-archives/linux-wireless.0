Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33858 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbcA0PqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 10:46:22 -0500
Date: Wed, 27 Jan 2016 15:46:18 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	aryabinin@virtuozzo.com
Subject: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
Message-ID: <20160127154618.GA5717@localhost> (sfid-20160127_164628_730126_88BF58E3)
References: <20160126111730.GA6765@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160126111730.GA6765@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kzalloc instead of kmalloc for struct tid_ampdu_rx. Fixes:

[    7.976605] UBSAN: Undefined behaviour in net/mac80211/rx.c:932:29
[    7.976608] load of value 2 is not a valid value for type '_Bool'
[    7.976611] CPU: 3 PID: 1134 Comm: kworker/u16:7 Not tainted 4.5.0-rc1+ #265
[    7.976613] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B0A.1509130955 09/13/2015
[    7.976616] Workqueue: phy0 rt2x00usb_work_rxdone
[    7.976619]  0000000000000004 ffff880254a7ba50 ffffffff8181d866 0000000000000007
[    7.976622]  ffff880254a7ba78 ffff880254a7ba68 ffffffff8188422d ffffffff8379b500
[    7.976626]  ffff880254a7bab8 ffffffff81884747 0000000000000202 0000000348620032
[    7.976629] Call Trace:
[    7.976633]  [<ffffffff8181d866>] dump_stack+0x45/0x5f
[    7.976637]  [<ffffffff8188422d>] ubsan_epilogue+0xd/0x40
[    7.976642]  [<ffffffff81884747>] __ubsan_handle_load_invalid_value+0x67/0x70
[    7.976646]  [<ffffffff82227b4d>] ieee80211_sta_reorder_release.isra.16+0x5ed/0x730
[    7.976650]  [<ffffffff8222ca14>] ieee80211_prepare_and_rx_handle+0xd04/0x1c00
[    7.976654]  [<ffffffff81cb27ce>] ? usb_hcd_map_urb_for_dma+0x65e/0x960
[    7.976659]  [<ffffffff8222db03>] __ieee80211_rx_handle_packet+0x1f3/0x750
[    7.976663]  [<ffffffff8222e4a7>] ieee80211_rx_napi+0x447/0x990
[    7.976667]  [<ffffffff81c5fb85>] rt2x00lib_rxdone+0x305/0xbd0
[    7.976670]  [<ffffffff811ac23f>] ? dequeue_task_fair+0x64f/0x1de0
[    7.976674]  [<ffffffff811a1516>] ? sched_clock_cpu+0xe6/0x150
[    7.976678]  [<ffffffff81c6c45c>] rt2x00usb_work_rxdone+0x7c/0x140
[    7.976682]  [<ffffffff8117aef6>] process_one_work+0x226/0x860
[    7.976686]  [<ffffffff8117b58c>] worker_thread+0x5c/0x680
[    7.976690]  [<ffffffff8117b530>] ? process_one_work+0x860/0x860
[    7.976693]  [<ffffffff81184f86>] kthread+0xf6/0x150
[    7.976697]  [<ffffffff81184e90>] ? kthread_worker_fn+0x310/0x310
[    7.976700]  [<ffffffff822a94df>] ret_from_fork+0x3f/0x70
[    7.976703]  [<ffffffff81184e90>] ? kthread_worker_fn+0x310/0x310

Link: https://lkml.org/lkml/2016/1/26/230
Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
---
 net/mac80211/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 10ad4ac1fa0b..bde3344cbdd0 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -291,7 +291,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	}
 
 	/* prepare A-MPDU MLME for Rx aggregation */
-	tid_agg_rx = kmalloc(sizeof(struct tid_ampdu_rx), GFP_KERNEL);
+	tid_agg_rx = kzalloc(sizeof(struct tid_ampdu_rx), GFP_KERNEL);
 	if (!tid_agg_rx)
 		goto end;
 
-- 
2.1.4

