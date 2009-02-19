Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49986 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbZBSUwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 15:52:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211 does transmit frames with stopped queue
Date: Thu, 19 Feb 2009 21:50:38 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902192150.38424.mb@bu3sch.de> (sfid-20090219_215246_765191_79856B6C)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the B43_WARN_ON(ring->stopped) in b43_dma_tx() triggering.

[292334.105762] WARNING: at /home/mb/kernel/compat-wireless-2009-02-17/drivers/net/wireless/b43/dma.c:1314 b43_dma_tx+0x9fc/0xa30 [b43]()
[292334.105808] Modules linked in: b43 ssb mac80211 cfg80211 [last unloaded: cfg80211]
[292334.105861] Pid: 3143, comm: nfsd Tainted: G        W  2.6.28.5 #7
[292334.105886] Call Trace:
[292334.105904]  <IRQ>  [<ffffffff80240b64>] warn_on_slowpath+0x64/0xa0
[292334.105955]  [<ffffffffa008cf9a>] ccmp_encrypt_skb+0x1ba/0x220 [mac80211]
[292334.105995]  [<ffffffffa009d2bf>] ieee80211_duration+0x1af/0x230 [mac80211]
[292334.106032]  [<ffffffffa0017a3c>] b43_dma_tx+0x9fc/0xa30 [b43]
[292334.106070]  [<ffffffffa009e19e>] invoke_tx_handlers+0xe5e/0xfb0 [mac80211]
[292334.106104]  [<ffffffffa0001d84>] b43_op_tx+0x74/0xe0 [b43]
[292334.106141]  [<ffffffffa009e9f6>] __ieee80211_tx+0x56/0x160 [mac80211]
[292334.106180]  [<ffffffffa009f992>] ieee80211_master_start_xmit+0x272/0x530 [mac80211]
[292334.106224]  [<ffffffff8062a70e>] __qdisc_run+0x20e/0x260
[292334.106928]  [<ffffffff8060c770>] net_tx_action+0xe0/0x130
[292334.106953]  [<ffffffff80246803>] __do_softirq+0x93/0x160
[292334.106980]  [<ffffffff8020d49c>] call_softirq+0x1c/0x30
[292334.107003]  <EOI>  [<ffffffff8020ee45>] do_softirq+0x35/0x70
[292334.107034]  [<ffffffff802466d5>] local_bh_enable+0xa5/0xb0
[292334.107060]  [<ffffffff8060e9fc>] dev_queue_xmit+0xfc/0x570
[292334.107088]  [<ffffffff8067e486>] ip_queue_xmit+0x1f6/0x3e0
[292334.107114]  [<ffffffff80686cbf>] sk_stream_alloc_skb+0x3f/0x110
[292334.107140]  [<ffffffff8069151b>] tcp_transmit_skb+0x4eb/0x760
[292334.107167]  [<ffffffff80693ec0>] __tcp_push_pending_frames+0x260/0x960
[292334.107195]  [<ffffffff80690a1c>] tcp_current_mss+0x5c/0x100
[292334.107221]  [<ffffffff80687f12>] tcp_sendpage+0x652/0x6e0
[292334.107247]  [<ffffffff805feea6>] kernel_sendpage+0x16/0x40
[292334.107274]  [<ffffffff80740f56>] svc_sendto+0x216/0x360
[292334.107300]  [<ffffffff803786c1>] encode_fattr3+0x141/0x1f0
[292334.107326]  [<ffffffff80378831>] encode_post_op_attr+0xc1/0xd0
[292334.107353]  [<ffffffff80741d8c>] svc_tcp_sendto+0x4c/0xb0
[292334.107380]  [<ffffffff8074be0b>] svc_send+0x9b/0xd0
[292334.107404]  [<ffffffff8073f6f2>] svc_process+0x232/0x800
[292334.107429]  [<ffffffff80239f50>] default_wake_function+0x0/0x10
[292334.107458]  [<ffffffff8076e4c7>] __down_read+0x17/0xa6
[292334.107484]  [<ffffffff80369639>] nfsd+0x1a9/0x2c0
[292334.107509]  [<ffffffff80369490>] nfsd+0x0/0x2c0
[292334.107534]  [<ffffffff80256da7>] kthread+0x47/0x90
[292334.107558]  [<ffffffff8023dfb7>] schedule_tail+0x27/0x70
[292334.107583]  [<ffffffff8020d139>] child_rip+0xa/0x11
[292334.107608]  [<ffffffff80256d60>] kthread+0x0/0x90
[292334.107633]  [<ffffffff8020d12f>] child_rip+0x0/0x11
[292334.107657] ---[ end trace 43778c870e1cf6c0 ]---

It indicates that mac80211 queued a frame on the queue although
ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb)); was called on that queue.

This seems to only happen with fragmentation turned on (fts = 1024).
(I only noticed it after I turned fragmentation on, so...)
I'm not sure if it's related to AP mode, but this machine is in AP mode.

-- 
Greetings, Michael.
