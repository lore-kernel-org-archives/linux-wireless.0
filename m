Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:50301 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964815AbeEXHHg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 03:07:36 -0400
Received: by mail-wm0-f49.google.com with SMTP id t11-v6so2068377wmt.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 00:07:35 -0700 (PDT)
Date: Thu, 24 May 2018 09:07:32 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org
Subject: TXQ stats API lockdep warning
Message-ID: <20180524070732.GA14576@localhost.localdomain> (sfid-20180524_090835_999753_B631D983)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello


Commit 2fe4a29a452a ("mac80211: Support the new cfg80211 TXQ stats API")

Introduces some new lockdep (build with CONFIG_PROVE_LOCKING=y) warning:

[    7.368515] the code is fine but needs lockdep annotation.
[    7.372501] turning off the locking correctness validator.
[    7.377805] CPU: 3 PID: 6 Comm: kworker/u8:0 Tainted: G        W         4.17.0-rc5-wt-ath-01074-gb630e9375eb6 #229
[    7.383301] Hardware name: Generic DT based system
[    7.393615] Workqueue: ath10k_wq ath10k_core_register_work
[    7.398482] [<c0314e00>] (unwind_backtrace) from [<c030fc70>] (show_stack+0x20/0x24)
[    7.403962] [<c030fc70>] (show_stack) from [<c0c16ad8>] (dump_stack+0xa0/0xcc)
[    7.411860] [<c0c16ad8>] (dump_stack) from [<c037e0a0>] (register_lock_class+0x658/0x65c)
[    7.418896] [<c037e0a0>] (register_lock_class) from [<c03817c0>] (__lock_acquire+0xa0/0x1ae4)
[    7.427140] [<c03817c0>] (__lock_acquire) from [<c0383c80>] (lock_acquire+0xdc/0x2d4)
[    7.435646] [<c0383c80>] (lock_acquire) from [<c0c35c70>] (_raw_spin_lock_bh+0x50/0x60)
[    7.443457] [<c0c35c70>] (_raw_spin_lock_bh) from [<c0bbde04>] (ieee80211_get_txq_stats+0x4c/0x1bc)
[    7.451278] [<c0bbde04>] (ieee80211_get_txq_stats) from [<c0b3ff9c>] (nl80211_send_iface+0x4ec/0x1220)
[    7.460310] [<c0b3ff9c>] (nl80211_send_iface) from [<c0b5809c>] (nl80211_notify_iface+0x7c/0x118)
[    7.469681] [<c0b5809c>] (nl80211_notify_iface) from [<c0b19900>] (cfg80211_netdev_notifier_call+0x3d8/0x900)
[    7.478638] [<c0b19900>] (cfg80211_netdev_notifier_call) from [<c0352bbc>] (notifier_call_chain+0x58/0x94)
[    7.488525] [<c0352bbc>] (notifier_call_chain) from [<c0352da0>] (raw_notifier_call_chain+0x28/0x30)
[    7.498070] [<c0352da0>] (raw_notifier_call_chain) from [<c0a146d0>] (call_netdevice_notifiers_info+0x3c/0x88)
[    7.507368] [<c0a146d0>] (call_netdevice_notifiers_info) from [<c0a24868>] (register_netdevice+0x2f4/0x73c)
[    7.517177] [<c0a24868>] (register_netdevice) from [<c0badee4>] (ieee80211_if_add+0x32c/0x6b8)
[    7.526802] [<c0badee4>] (ieee80211_if_add) from [<c0b84568>] (ieee80211_register_hw+0xa40/0xacc)
[    7.535486] [<c0b84568>] (ieee80211_register_hw) from [<c08c02d8>] (ath10k_mac_register+0x5d8/0x7c8)
[    7.544421] [<c08c02d8>] (ath10k_mac_register) from [<c08c87f8>] (ath10k_core_register_work+0x5f4/0x910)
[    7.553632] [<c08c87f8>] (ath10k_core_register_work) from [<c0348eb4>] (process_one_work+0x2c4/0x8fc)
[    7.563087] [<c0348eb4>] (process_one_work) from [<c0349550>] (worker_thread+0x64/0x5cc)
[    7.572192] [<c0349550>] (worker_thread) from [<c0350d10>] (kthread+0x180/0x188)
[    7.580345] [<c0350d10>] (kthread) from [<c03010b4>] (ret_from_fork+0x14/0x20)


Lockdep gives us a hint that perhaps the new code is only missing
proper lockdep annotations.

Since this is queued up for v4.18, it would be nice if this
could be fixed..


Kind regards,
Niklas
