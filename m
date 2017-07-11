Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vie01a-dmta-ch02-1.mx.upcmail.net ([84.116.36.94]:39200 "EHLO
        vie01a-dmta-ch02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754126AbdGKH4I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 03:56:08 -0400
Received: from [172.31.216.44] (helo=vie01a-pemc-psmtp-pe02)
        by vie01a-dmta-ch02.mx.upcmail.net with esmtp (Exim 4.88)
        (envelope-from <odi@odi.ch>)
        id 1dUq1e-0004zR-Ou
        for linux-wireless@vger.kernel.org; Tue, 11 Jul 2017 09:56:06 +0200
Received: from [10.11.1.254] (unknown [81.7.230.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gandalf.odi.ch (Postfix) with ESMTPSA id 8CE4D46001A
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 09:55:55 +0200 (CEST)
From: =?UTF-8?Q?Ortwin_Gl=c3=bcck?= <odi@odi.ch>
To: linux-wireless@vger.kernel.org
Subject: ath9k: insufficient skb len
Message-ID: <60275295-6296-d84b-2ddb-9b84145cbad6@odi.ch> (sfid-20170711_095612_543348_14F98F39)
Date: Tue, 11 Jul 2017 09:55:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw this WARN_ON splat on ath9k in hostap mode. The code triggering the warning says it's a driver 
bug.

Thanks for checking.

Ortwin

[629805.015640] ------------[ cut here ]------------
[629805.015695] WARNING: CPU: 2 PID: 0 at net/mac80211/rx.c:630 ieee80211_rx_napi+0x8a5/0xa70
[629805.015735] Modules linked in: radeon ttm
[629805.015740] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.12.0 #1
[629805.015750] Hardware name: Apple Inc. iMac11,2/Mac-F2238AC8, BIOS 
IM112.88Z.0057.B00.1005031455 05/03/10
[629805.015752] task: ffffa35a370e6300 task.stack: ffffa58840074000
[629805.015754] RIP: 0010:ieee80211_rx_napi+0x8a5/0xa70
[629805.015755] RSP: 0018:ffffa35a3bc83d38 EFLAGS: 00010246
[629805.015756] RAX: 0000000000010000 RBX: ffffa3593987f700 RCX: 0000000000000000
[629805.015771] RDX: 0000000000000004 RSI: 0000000000000001 RDI: ffffa35a29d0c740
[629805.015772] RBP: ffffa35a3bc83e08 R08: 0000000000000000 R09: 0000000000000001
[629805.015773] R10: 0000000000000000 R11: 0000000000000000 R12: ffffa35a29d0c740
[629805.015773] R13: 0000000000000000 R14: 0000000000000000 R15: ffffa35a29d0d500
[629805.015775] FS:  0000000000000000(0000) GS:ffffa35a3bc80000(0000) knlGS:0000000000000000
[629805.015776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[629805.015777] CR2: 0000000001f3b038 CR3: 0000000006e0a000 CR4: 00000000000006e0
[629805.015790] Call Trace:
[629805.015792]  <IRQ>
[629805.015797]  ? swiotlb_tbl_map_single+0x21d/0x2f0
[629805.015812]  ? ath9k_cmn_rx_skb_postprocess+0x47/0x130
[629805.015814]  ? swiotlb_tbl_unmap_single+0xf0/0x120
[629805.015816]  ath_rx_tasklet+0xa28/0xed0
[629805.015819]  ath9k_tasklet+0x1db/0x240
[629805.015822]  tasklet_action+0x91/0xb0
[629805.015824]  __do_softirq+0xd7/0x1d0
[629805.015825]  irq_exit+0xab/0xb0
[629805.015828]  do_IRQ+0x4a/0xc0
[629805.015831]  common_interrupt+0x86/0x86
[629805.015835] RIP: 0010:cpuidle_enter_state+0x15f/0x1f0
[629805.015836] RSP: 0018:ffffa58840077e70 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff2e
[629805.015837] RAX: ffffa35a3bc98740 RBX: ffffa35a3bc9efb0 RCX: 000000000000001f
[629805.015838] RDX: 20c49ba5e353f7cf RSI: ffffa35a3bc95f58 RDI: 0000000000000000
[629805.015839] RBP: ffffa58840077ea0 R08: ffffa35a3bc959a4 R09: 0000000000000018
[629805.015840] R10: 0000000000000eca R11: 00000000000011e5 R12: 00023ccde83b6cf0
[629805.015841] R13: 0000000000000004 R14: ffffffff84e56e18 R15: 0000000000000004
[629805.015842]  </IRQ>
[629805.015845]  cpuidle_enter+0x12/0x20
[629805.015848]  call_cpuidle+0x1e/0x30
[629805.015849]  do_idle+0xdb/0x170
[629805.015850]  cpu_startup_entry+0x6c/0x70
[629805.015853]  start_secondary+0x143/0x160
[629805.015857]  secondary_startup_64+0x9f/0x9f
[629805.015858] Code: ff ff 48 8b 8b d0 00 00 00 4c 8b 82 d0 00 00 00 e9 02 fa ff ff 4c 89 ff 44 8b 
ad 48 ff ff ff 4c 8b a5 38 ff ff ff e9 5a ff ff ff <0f> ff 48 89 df e8 11 e5 de ff e9 fb fa ff ff 0f 
ff e9 2e f8 ff
[629805.015876] ---[ end trace e4857df16afbdba0 ]---


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
