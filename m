Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:62943 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbZAOUHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 15:07:09 -0500
Received: by ewy12 with SMTP id 12so448067ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 12:07:06 -0800 (PST)
Message-ID: <496F9767.6030500@gmail.com> (sfid-20090115_210715_976892_552BCC55)
Date: Thu, 15 Jan 2009 21:07:03 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org, "" <linville@tuxdriver.com>
Subject: [PATCH] p54: set_tim must be atomic.
References: <494698AF.4020204@gmail.com> <200901151953.49053.chunkeey@web.de> <496F8A83.8000605@gmail.com> <200901152042.42372.chunkeey@web.de>
In-Reply-To: <200901152042.42372.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix for:

BUG: scheduling while atomic: named/2004/0x10000200
Pid: 2004, comm: named Not tainted 2.6.29-rc1-00271-ge9fa6b0 #45
Call Trace:
 [<c04d4ef7>] schedule+0x2a7/0x320
 [<c03aed74>] __alloc_skb+0x34/0x110
 [<c011f5b3>] __cond_resched+0x13/0x30
 [<c04d501d>] _cond_resched+0x2d/0x40
 [<c016d8c5>] kmem_cache_alloc+0x95/0xc0
 [<c016b8d4>] check_object+0xc4/0x230
 [<c03aed74>] __alloc_skb+0x34/0x110
 [<c02ede91>] p54_alloc_skb+0x71/0xf0
 [<c02ee36f>] p54_set_tim+0x3f/0xa0
 [<c04ae064>] sta_info_set_tim_bit+0x64/0x80
 [<c04c1017>] invoke_tx_handlers+0xd57/0xd80
 [<c016c397>] free_debug_processing+0x197/0x210
 [<c03ae215>] pskb_expand_head+0xf5/0x170
 [<c04bfd94>] __ieee80211_tx_prepare+0x164/0x2f0
 [<c04c1a8d>] ieee80211_skb_resize+0x6d/0xe0
 [<c04c250f>] ieee80211_master_start_xmit+0x23f/0x550
 [<c016d188>] __slab_alloc+0x2b8/0x4f0
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c03b5e7b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c6a4b>] __qdisc_run+0x1ab/0x200
 [<c0136aa1>] __run_hrtimer+0x31/0xf0
 [<c03b6247>] dev_queue_xmit+0x247/0x500
 [<c04c1e56>] ieee80211_subif_start_xmit+0x356/0x7d0
 [<c0466ff7>] packet_rcv_spkt+0x37/0x150
 [<c0466ff7>] packet_rcv_spkt+0x37/0x150
 [<c03b5e7b>] dev_hard_start_xmit+0x1db/0x240
 [<c03c6a4b>] __qdisc_run+0x1ab/0x200
 [<c03b6247>] dev_queue_xmit+0x247/0x500
 [<c03bc1e2>] neigh_resolve_output+0xe2/0x200
 [<c0410080>] ip_finish_output+0x0/0x290
 [<c0410267>] ip_finish_output+0x1e7/0x290
 [<c040f355>] ip_local_out+0x15/0x20
 [<c040f5d2>] ip_push_pending_frames+0x272/0x380
 [<c042bbc6>] udp_push_pending_frames+0x146/0x3a0
 [<c042d52a>] udp_sendmsg+0x2fa/0x6b0
 [<c0433bc7>] inet_sendmsg+0x37/0x70
 [<c03a7b7e>] sock_sendmsg+0xbe/0x100
 [<c0133cd0>] autoremove_wake_function+0x0/0x50
 [<c011c043>] __wake_up_common+0x43/0x70
 [<c024a892>] copy_from_user+0x32/0x130
 [<c024a892>] copy_from_user+0x32/0x130
 [<c03b001e>] verify_iovec+0x2e/0xb0
 [<c03a7d3f>] sys_sendmsg+0x17f/0x290
 [<c017730a>] pipe_write+0x29a/0x570
 [<c013a172>] update_wall_time+0x492/0x8e0
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c011b05d>] sched_slice+0x3d/0x80
 [<c013a711>] getnstimeofday+0x51/0x120
 [<c0136657>] hrtimer_forward+0x147/0x1a0
 [<c01101b0>] lapic_next_event+0x10/0x20
 [<c013ccb3>] clockevents_program_event+0xa3/0x170
 [<c03a9054>] sys_socketcall+0xa4/0x290
 [<c0110920>] smp_apic_timer_interrupt+0x40/0x70
 [<c0103165>] sysenter_do_call+0x12/0x25


Signed-off-by: Artur Skawina <art.08.09@gmail.com>
Acked-by: Christian Lamparter <chunkeey@web.de>

---
 drivers/net/wireless/p54/p54common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 635b423..579bc6c 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1295,7 +1295,7 @@ static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
 	struct p54_tim *tim;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*tim),
-			    P54_CONTROL_TYPE_TIM, GFP_KERNEL);
+			    P54_CONTROL_TYPE_TIM, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
