Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34898 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdFDNMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Jun 2017 09:12:35 -0400
Received: by mail-lf0-f68.google.com with SMTP id v20so4810891lfa.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jun 2017 06:12:34 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: johannes@sipsolutions.net, johannes.berg@intel.com,
        kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/1] mac80211: ieee80211_rx_napi: remove warning
Date: Sun,  4 Jun 2017 15:11:55 +0200
Message-Id: <1496581915-4412-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170604_151240_187448_37FE99CC)
In-Reply-To: <1496581915-4412-1-git-send-email-erik.stromdahl@gmail.com>
References: <1496581915-4412-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The softirq count is not always incremented during driver
operation. This is the case for usb and sdio network
drivers.

The below warning occurs on the first RX frame pushed to
mac80211 (for usb and sdio):

[   27.414995] ------------[ cut here ]------------
[   27.416444] WARNING: CPU: 0 PID: 16 at net/mac80211/rx.c:4254 ieee80211_rx_napi+0x598/0xa30
[   27.419161] Modules linked in: i8042 serio ehci_pci ehci_hcd ath10k_usb ath10k_core ath
[   27.421660] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 4.12.0-rc2-wt-ath-ARCH-QEMU+ #5
[   27.424323] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[   27.425205] Workqueue: events ath10k_usb_io_comp_work [ath10k_usb]
[   27.425760] task: ffff88003a730d00 task.stack: ffffc90000210000
[   27.426275] RIP: 0010:ieee80211_rx_napi+0x598/0xa30
[   27.426700] RSP: 0018:ffffc90000213c68 EFLAGS: 00010346
[   27.427155] RAX: 0000000080000000 RBX: ffff880039d08500 RCX: 0000000000000000
[   27.427764] RDX: ffff880039d08500 RSI: 0000000000000000 RDI: ffff880039ff0780
[   27.428371] RBP: ffffc90000213d38 R08: 0000000000000000 R09: 00000000fffffff0
[   27.429015] R10: ffffea0000e7e200 R11: 0000000000000080 R12: 0000000000000000
[   27.429633] R13: ffff880039ff1560 R14: 0000000000000080 R15: ffff880039ff0780
[   27.430240] FS:  0000000000000000(0000) GS:ffff88003be00000(0000) knlGS:0000000000000000
[   27.430914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.431392] CR2: 00000000007fe518 CR3: 000000003f8c0000 CR4: 00000000000006f0
[   27.431982] Call Trace:
[   27.432195]  ? ieee80211_rx_napi+0x18/0xa30
[   27.432553]  ath10k_wmi_event_mgmt_rx+0x233/0x430 [ath10k_core]
[   27.433046]  ath10k_wmi_tlv_op_rx+0x2fb/0x7b0 [ath10k_core]
[   27.433567]  ath10k_wmi_process_rx+0x1a/0x40 [ath10k_core]
[   27.434039]  ath10k_usb_io_comp_work+0x13e/0x1a0 [ath10k_usb]
[   27.434527]  ? __schedule+0x2e3/0x840
[   27.434858]  process_one_work+0x1e0/0x420
[   27.435203]  worker_thread+0x48/0x3f0
[   27.435514]  kthread+0x109/0x140
[   27.435846]  ? process_one_work+0x420/0x420
[   27.436231]  ? kthread_create_on_node+0x70/0x70
[   27.436644]  ret_from_fork+0x2c/0x40
[   27.437046] Code: 70 4c 8b ab d8 00 00 00 44 8b 83 80 00 00 00 41 0f b7 55 00 4d 89 ee 41 89 d4 41 83 e4 0c e9 88 fc ff ff 4d 89 ec e9 c1 fd ff ff <0f> ff 0f b6 43 4b 3c 02 0f 86 b2 fa ff ff 0f ff e9 30 fb ff ff
[   27.439114] ---[ end trace 89f286e9814e824a ]---

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 net/mac80211/rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f75280ba26c..2ec54232817d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4251,8 +4251,6 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	WARN_ON_ONCE(softirq_count() == 0);
-
 	if (WARN_ON(status->band >= NUM_NL80211_BANDS))
 		goto drop;
 
-- 
2.13.0
