Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdLBM7V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 07:59:21 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Wireless regressions in v4.15-rc1
Date: Sat, 02 Dec 2017 14:59:15 +0200
Message-ID: <87po7xwajg.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_135939_841463_D1ADD367)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

just a heads up to everyone that there are multiple regressions in
v4.15-rc1. For starters hostapd (=AP mode) doesn't work because of:

net: netlink: Update attr validation to require exact length for some types
https://git.kernel.org/linus/28033ae4e0f5

Jouni fixed this already in hostapd but we also need a fix for kernel so
that old hostapd versions continue to work:

https://w1.fi/cgit/hostap/commit/?id=a2426829ce426de82d2fa47071ca41ea81c43307

Jouni also found a similar problem with mesh:

https://w1.fi/cgit/hostap/commit/?id=963d3149abfcbab5b83f9023bc50321f777360d1

And Johannes already submitted a revert related to wpa_supplicant:

[net] Revert "net: core: maybe return -EEXIST in __dev_alloc_name" diffmboxseries
https://patchwork.ozlabs.org/patch/843863/

And with ath10k I'm now seeing this:

[  133.175508] WARNING: CPU: 2 PID: 1743 at net/mac80211/agg-tx.c:315 ___ieee80211_stop_tx_ba_session+0x1ab/0x280 [mac80211]
[  133.175660] Modules linked in: ctr ccm arc4 ath10k_pci(E) ath10k_core(E) ath(E) mac80211(E) cfg80211(E) snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic joydev btusb snd_hda_i
[  133.175924] CPU: 2 PID: 1743 Comm: hostapd Tainted: G            E    4.15.0-rc1-wt-ath+ #553
[  133.175960] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[  133.175996] task: ffff9a1b9b6e1cc0 task.stack: ffffb13800348000
[  133.176072] RIP: 0010:___ieee80211_stop_tx_ba_session+0x1ab/0x280 [mac80211]
[  133.176111] RSP: 0018:ffffb1380034b8f8 EFLAGS: 00210246
[  133.176151] RAX: 0000000000000000 RBX: ffff9a1b93e85698 RCX: 0000000000000000
[  133.176187] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000200246
[  133.176223] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[  133.176259] R10: 0000000000000000 R11: 0000000000000012 R12: 0000000000000000
[  133.176295] R13: 0000000000000003 R14: 0000000000000000 R15: ffff9a1b93060dc0
[  133.176332] FS:  0000000000000000(0000) GS:ffff9a1bb2600000(0063) knlGS:00000000f7b69b00
[  133.176368] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  133.181034] CR2: 00000000f7dd56c0 CR3: 0000000119076000 CR4: 00000000000006e0
[  133.181068] Call Trace:
[  133.181191]  ieee80211_sta_tear_down_BA_sessions+0x6d/0x140 [mac80211]
[  133.181264]  __sta_info_destroy_part1+0x5e/0x9d0 [mac80211]
[  133.181336]  __sta_info_flush+0x129/0x190 [mac80211]
[  133.181421]  ieee80211_stop_ap+0x14c/0x5c0 [mac80211]
[  133.181516]  __cfg80211_stop_ap+0xdd/0x620 [cfg80211]
[  133.181591]  cfg80211_stop_ap+0x3a/0x50 [cfg80211]
[  133.181631]  genl_family_rcv_msg+0x1b9/0x370
[  133.181680]  genl_rcv_msg+0x47/0x90
[  133.181712]  ? genl_rcv+0x15/0x40
[  133.181744]  ? genl_family_rcv_msg+0x370/0x370
[  133.181777]  netlink_rcv_skb+0xd2/0xf0
[  133.181816]  genl_rcv+0x24/0x40
[  133.181850]  netlink_unicast+0x1c0/0x2e0
[  133.181887]  netlink_sendmsg+0x2ac/0x390
[  133.181931]  sock_sendmsg+0x30/0x40
[  133.181965]  ___sys_sendmsg+0x2a6/0x2b0
[  133.182003]  ? trace_hardirqs_on_caller+0x124/0x190
[  133.182042]  ? trace_hardirqs_on_caller+0x124/0x190
[  133.182083]  ? free_debug_processing+0x271/0x380
[  133.182122]  ? __lock_acquire+0x52d/0x1120
[  133.182159]  ? __lock_acquire+0x52d/0x1120
[  133.182200]  ? __sys_sendmsg+0x41/0x70
[  133.182231]  __sys_sendmsg+0x41/0x70
[  133.182278]  compat_SyS_socketcall+0x2db/0x480
[  133.182311]  ? task_work_run+0x6a/0xb0
[  133.182366]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  133.182406]  do_fast_syscall_32+0x9c/0x300
[  133.182443]  entry_SYSENTER_compat+0x51/0x60
[  133.182493] Code: 5d 41 5e 41 5f c3 c7 04 24 03 00 00 00 e9 dc fe ff ff 48 8d bf 58 09 00 00 be ff ff ff ff e8 dd 36 90 e7 85 c0 0f 85 a8 fe ff ff <0f> ff e9 a1 fe ff ff 4c 89 f7 e8 76 
[  133.182798] ---[ end trace fb3fb3b808e4ce1b ]---

-- 
Kalle Valo
