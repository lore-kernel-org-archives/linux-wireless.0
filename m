Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vie01a-dmta-ch01-3.mx.upcmail.net ([84.116.36.93]:13286 "EHLO
        vie01a-dmta-ch01-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751388AbdKUKHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 05:07:21 -0500
Received: from [172.31.216.44] (helo=vie01a-pemc-psmtp-pe02)
        by vie01a-dmta-ch01.mx.upcmail.net with esmtp (Exim 4.88)
        (envelope-from <odi@odi.ch>)
        id 1eH5SY-0007hO-PB
        for linux-wireless@vger.kernel.org; Tue, 21 Nov 2017 11:07:18 +0100
From: =?UTF-8?Q?Ortwin_Gl=c3=bcck?= <odi@odi.ch>
Subject: ath9k: insufficient skb len
To: linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <0c4ce5a3-6da1-b2b4-bfe9-d8f5f5319e42@odi.ch> (sfid-20171121_110838_313244_F04FC3D1)
Date: Tue, 21 Nov 2017 11:07:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw this WARN_ON splat on ath9k in hostap mode. The code triggering the warning says it's a driver 
bug.

Thanks for checking.

Ortwin

[Tue Nov 21 06:00:36 2017] ------------[ cut here ]------------
[Tue Nov 21 06:00:36 2017] WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:629 ieee80211_rx_napi+0x814/0x9a0
[Tue Nov 21 06:00:36 2017] Modules linked in: radeon ttm
[Tue Nov 21 06:00:36 2017] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0 #1
[Tue Nov 21 06:00:36 2017] Hardware name: Apple Inc. iMac11,2/Mac-F2238AC8, BIOS 
IM112.88Z.0057.B00.1005031455 05/03/10
[Tue Nov 21 06:00:36 2017] task: ffffffffa8e0f4c0 task.stack: ffffffffa8e00000
[Tue Nov 21 06:00:36 2017] RIP: 0010:ieee80211_rx_napi+0x814/0x9a0
[Tue Nov 21 06:00:36 2017] RSP: 0018:ffff915efbc03d68 EFLAGS: 00010246
[Tue Nov 21 06:00:36 2017] RAX: 0000000000010000 RBX: ffff915eec76e100 RCX: 0000000000000000
[Tue Nov 21 06:00:36 2017] RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffff915ee9d94740
[Tue Nov 21 06:00:36 2017] RBP: ffff915ee9d94740 R08: 0000000000000000 R09: 0000000000000000
[Tue Nov 21 06:00:36 2017] R10: 000000000000000b R11: 0000000000000001 R12: 0000000000000000
[Tue Nov 21 06:00:36 2017] R13: 0000000000000000 R14: ffff915eec76e100 R15: ffff915ee9d95500
[Tue Nov 21 06:00:36 2017] FS:  0000000000000000(0000) GS:ffff915efbc00000(0000) knlGS:0000000000000000
[Tue Nov 21 06:00:36 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Nov 21 06:00:36 2017] CR2: 000000000170b208 CR3: 0000000051e0a003 CR4: 00000000000206f0
[Tue Nov 21 06:00:36 2017] Call Trace:
[Tue Nov 21 06:00:36 2017]  <IRQ>
[Tue Nov 21 06:00:36 2017]  ? __build_skb+0x20/0xe0
[Tue Nov 21 06:00:36 2017]  ? __netdev_alloc_skb+0x9d/0xd0
[Tue Nov 21 06:00:36 2017]  ? ath9k_cmn_rx_skb_postprocess+0x44/0x120
[Tue Nov 21 06:00:36 2017]  ath_rx_tasklet+0x9f9/0xe50
[Tue Nov 21 06:00:36 2017]  ath9k_tasklet+0x1d0/0x230
[Tue Nov 21 06:00:36 2017]  tasklet_action+0x8c/0xa0
[Tue Nov 21 06:00:36 2017]  __do_softirq+0xcf/0x1c3
[Tue Nov 21 06:00:36 2017]  irq_exit+0xa3/0xb0
[Tue Nov 21 06:00:36 2017]  do_IRQ+0x45/0xc0
[Tue Nov 21 06:00:36 2017]  common_interrupt+0x89/0x89
[Tue Nov 21 06:00:36 2017]  </IRQ>
[Tue Nov 21 06:00:36 2017] RIP: 0010:cpuidle_enter_state+0x15d/0x1f0
[Tue Nov 21 06:00:36 2017] RSP: 0018:ffffffffa8e03e90 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff2e
[Tue Nov 21 06:00:36 2017] RAX: ffff915efbc18880 RBX: ffff915efbc1eee8 RCX: 000000000000001f
[Tue Nov 21 06:00:36 2017] RDX: 20c49ba5e353f7cf RSI: 0000000029d8003a RDI: 0000000000000000
[Tue Nov 21 06:00:36 2017] RBP: 0000299aa6ed0d94 R08: ffff915efbc15a84 R09: 0000000000000018
[Tue Nov 21 06:00:36 2017] R10: 00000000000014a6 R11: 0000000000000a11 R12: 0000000000000004
[Tue Nov 21 06:00:36 2017] R13: 0000299aa6c473ad R14: 0000000000000004 R15: ffffffffa8e56518
[Tue Nov 21 06:00:36 2017]  do_idle+0xd6/0x170
[Tue Nov 21 06:00:36 2017]  cpu_startup_entry+0x6a/0x70
[Tue Nov 21 06:00:36 2017]  start_kernel+0x47e/0x49e
[Tue Nov 21 06:00:36 2017]  secondary_startup_64+0xa5/0xa5
[Tue Nov 21 06:00:36 2017] Code: 48 85 c0 0f 84 77 fb ff ff 48 8b 54 24 38 4c 8b bb d0 00 00 00 4c 
8b 82 d0 00 00 00 e9 5d fa ff ff 44 8b 64 24 24 e9 62 fe ff ff <0f> ff 48 89 df e8 52 c4 e0 ff e9 4e 
fb ff ff 0f ff e9 b0 f8 ff
[Tue Nov 21 06:00:36 2017] ---[ end trace 023f67413980a151 ]---



rx.c:
         if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
                 if (unlikely(origskb->len <= FCS_LEN)) {
                         /* driver bug */
                         WARN_ON(1);
                         dev_kfree_skb(origskb);
                         return NULL;
                 }
                 present_fcs_len = FCS_LEN;
         }
