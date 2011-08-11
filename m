Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab1HKNUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 09:20:31 -0400
Date: Thu, 11 Aug 2011 15:19:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: commit 50d3dfb72 corrupt memory
Message-ID: <20110811131937.GA4903@redhat.com> (sfid-20110811_152034_711425_D0A6C25B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My system crash when try to connet to wireless network since

commit 50d3dfb728e987790cf3d973aaf5fba2433771d8
Author: Jouni Malinen <jouni@qca.qualcomm.com>
Date:   Mon Aug 8 12:11:52 2011 +0300

    cfg80211/nl80211: Send AssocReq IEs to user space in AP mode

assoc_req_ies is not initialized hence NLA_PUT may write
on random address. I think station_info->filled should be
used for check.

Stanislaw

Slab corruption: size-512 start=e569e080, len=512
Redzone: 0xa5eb08b0f6318175/0xec458b00768dc35d.
Last user: [<0002c880>](0x2c880)
000: 90 8d 74 26 00 83 f8 02 74 d0 8d 76 00 e9 69 ff
010: ff ff 8d 76 00 83 f8 01 90 8d 74 26 00 0f 85 58
020: ff ff ff 31 f6 b0 02 e9 79 ff ff ff 90 85 ff 0f
030: 85 46 ff ff ff 83 f8 08 0f 84 60 ff ff ff e9 38
040: ff ff ff 66 90 85 c0 8d b6 00 00 00 00 0f 84 2d
050: ff ff ff e9 23 ff ff ff 90 8d 74 26 00 55 89 e5
Prev obj: start=e569dce8, len=512
Redzone: 0xfffff6c1850fc085/0xe9fffffff4bf905d.
Last user: [<5d8bfe89>](0x5d8bfe89)
000: 8b 87 cc 01 00 00 8b 55 9c 89 90 dc 00 00 00 8b
010: 87 cc 01 00 00 8b 4d 98 89 88 d8 00 00 00 8b 87
slab error in cache_alloc_debugcheck_after(): cache `size-512':
double free, or memory outside object was overwritten
Pid: 197, comm: kworker/u:2 Not tainted 3.1.0-rc1-wl+ #15
Call Trace:
 [<c051f516>] __slab_error+0x26/0x30
 [<c051fc97>] cache_alloc_debugcheck_after+0x67/0x220
 [<c0521d50>] ? __kmalloc_track_caller+0x190/0x230
 [<c048e141>] ? trace_hardirqs_on_caller+0xa1/0x180
 [<c0521d06>] __kmalloc_track_caller+0x146/0x230
 [<c0767bec>] ? dev_alloc_skb+0x1c/0x30
 [<c0767af9>] ? __alloc_skb+0x29/0x100
 [<c0767bec>] ? dev_alloc_skb+0x1c/0x30
 [<c0767b23>] __alloc_skb+0x53/0x100
 [<c0767bec>] dev_alloc_skb+0x1c/0x30
 [<f8a3fded>] iwl3945_rx_reply_rx+0x2dd/0x5c0 [iwl3945]
 [<c048a6cb>] ? trace_hardirqs_off+0xb/0x10
 [<f8a3a94f>] iwl3945_irq_tasklet+0x54f/0x13d0 [iwl3945]
 [<c048de74>] ? mark_held_locks+0x64/0xf0
 [<c04be35e>] ? check_for_new_grace_period+0x9e/0x130
 [<c045d223>] tasklet_action+0xc3/0x100
 [<c045cd8e>] __do_softirq+0xae/0x1e0
 [<c045cce0>] ? irq_enter+0x70/0x70
 <IRQ>  [<c045cb6d>] ? irq_exit+0xad/0xd0
 [<c0411f66>] ? do_IRQ+0x46/0xb0
 [<c048e194>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c082ddb5>] ? common_interrupt+0x35/0x3c
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<c052007b>] ? cache_free_debugcheck+0x22b/0x290
 [<c05f092a>] ? memcpy+0x1a/0x40
 [<c0600a48>] ? __nla_put+0x18/0x20
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<c0600a86>] ? nla_put+0x36/0x50
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<f88ffa1a>] ? nl80211_send_station+0x20a/0x600 [cfg80211]
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<f8900013>] ? nl80211_send_sta_event+0x53/0xb0 [cfg80211]
 [<f8a47770>] ? iwl3945_remove_debugfs+0x10/0x10 [iwl3945]
 [<f8903023>] ? cfg80211_new_sta+0x33/0x50 [cfg80211]
 [<f8ba0570>] ? sta_info_finish_insert+0xf0/0x1d0 [mac80211]
 [<c048de74>] ? mark_held_locks+0x64/0xf0
 [<c0826855>] ? _raw_spin_unlock_irqrestore+0x35/0x60
 [<c048e194>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<f8ba0f93>] ? sta_info_insert_rcu+0x183/0x240 [mac80211]
 [<c0826855>] ? _raw_spin_unlock_irqrestore+0x35/0x60
 [<f8ba1059>] ? sta_info_insert+0x9/0x30 [mac80211]
 [<f8ba967b>] ? ieee80211_assoc_success+0x3cb/0xab0 [mac80211]
 [<f8baaf37>] ? ieee80211_assoc_done+0x67/0x200 [mac80211]
 [<c048a6cb>] ? trace_hardirqs_off+0xb/0x10
 [<c048de74>] ? mark_held_locks+0x64/0xf0
 [<c08248b4>] ? __mutex_unlock_slowpath+0xb4/0x150
 [<c048e194>] ? trace_hardirqs_on_caller+0xf4/0x180
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<f8bacc60>] ? ieee80211_work_work+0x240/0x1360 [mac80211]
 [<c044766a>] ? finish_task_switch+0x7a/0xd0
 [<c048a6cb>] ? trace_hardirqs_off+0xb/0x10
 [<c047ce7d>] ? local_clock+0x6d/0x70
 [<c0470416>] ? process_one_work+0x186/0x440
 [<c047039a>] ? process_one_work+0x10a/0x440
 [<f8baca20>] ? ieee80211_rx_mgmt_assoc_resp+0x1f0/0x1f0 [mac80211]
 [<c0471f43>] ? worker_thread+0x133/0x310
 [<c048e22b>] ? trace_hardirqs_on+0xb/0x10
 [<c0471e10>] ? manage_workers+0x1e0/0x1e0
 [<c04760cc>] ? kthread+0x7c/0x90
 [<c0476050>] ? __init_kthread_worker+0x60/0x60
 [<c082ddc2>] ? kernel_thread_helper+0x6/0x10
e569e078: redzone 1:0xa5eb08b0f6318175, redzone 2:0xec458b00768dc35d
