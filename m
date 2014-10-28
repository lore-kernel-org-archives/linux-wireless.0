Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37983 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJ1Jeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:34:50 -0400
Received: by mail-lb0-f173.google.com with SMTP id l4so225548lbv.32
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:34:48 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: avoid possible deadlock with scan timeout
Date: Tue, 28 Oct 2014 10:23:09 +0100
Message-Id: <1414488189-28625-1-git-send-email-michal.kazior@tieto.com> (sfid-20141028_103455_000668_A881E8F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should prevent deadlock predicted by the
following splat:

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.17.0-wl-ath+ #67 Not tainted
 -------------------------------------------------------
 kworker/u32:1/7230 is trying to acquire lock:
  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa040a57d>] ath10k_scan_timeout_work+0x2d/0x50 [ath10k_core]

 but task is already holding lock:
  ((&(&ar->scan.timeout)->work)){+.+...}, at: [<ffffffff8106dae1>] process_one_work+0x151/0x470

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 ((&(&ar->scan.timeout)->work)){+.+...}:
        [<ffffffff810a12e5>] lock_acquire+0x85/0x100
        [<ffffffff8106cb4d>] flush_work+0x3d/0x270
        [<ffffffff8106e49d>] __cancel_work_timer+0x7d/0x110
        [<ffffffff8106e543>] cancel_delayed_work_sync+0x13/0x20
        [<ffffffffa0409f16>] ath10k_cancel_remain_on_channel+0x36/0x60 [ath10k_core]
        [<ffffffffa028c75c>] ieee80211_cancel_roc+0x1cc/0x2f0 [mac80211]
        [<ffffffffa028c8a2>] ieee80211_mgmt_tx_cancel_wait+0x22/0x30 [mac80211]
        [<ffffffffa0132288>] nl80211_tx_mgmt_cancel_wait+0xa8/0x130 [cfg80211]
        [<ffffffff816654a5>] genl_family_rcv_msg+0x1a5/0x3c0
        [<ffffffff81665749>] genl_rcv_msg+0x89/0xc0
        [<ffffffff81664e91>] netlink_rcv_skb+0xb1/0xc0
        [<ffffffff816650bc>] genl_rcv+0x2c/0x40
        [<ffffffff8166474d>] netlink_unicast+0x18d/0x200
        [<ffffffff81664add>] netlink_sendmsg+0x31d/0x430
        [<ffffffff8161a9ac>] sock_sendmsg+0x9c/0xd0
        [<ffffffff8161b469>] ___sys_sendmsg+0x389/0x3a0
        [<ffffffff8161bed9>] __sys_sendmsg+0x49/0x90
        [<ffffffff8161bf32>] SyS_sendmsg+0x12/0x20
        [<ffffffff8174c456>] system_call_fastpath+0x1a/0x1f

 -> #0 (&ar->conf_mutex){+.+.+.}:
        [<ffffffff810a0bde>] __lock_acquire+0x1b6e/0x1ce0
        [<ffffffff810a12e5>] lock_acquire+0x85/0x100
        [<ffffffff817491eb>] mutex_lock_nested+0x4b/0x370
        [<ffffffffa040a57d>] ath10k_scan_timeout_work+0x2d/0x50 [ath10k_core]
        [<ffffffff8106db41>] process_one_work+0x1b1/0x470
        [<ffffffff8106df63>] worker_thread+0x123/0x460
        [<ffffffff81073f34>] kthread+0xe4/0x100
        [<ffffffff8174c3ac>] ret_from_fork+0x7c/0xb0

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock((&(&ar->scan.timeout)->work));
                                lock(&ar->conf_mutex);
                                lock((&(&ar->scan.timeout)->work));
   lock(&ar->conf_mutex);

  *** DEADLOCK ***

Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a726107..a7236ea 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3307,9 +3307,10 @@ static void ath10k_cancel_hw_scan(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	cancel_delayed_work_sync(&ar->scan.timeout);
 	ath10k_scan_abort(ar);
 	mutex_unlock(&ar->conf_mutex);
+
+	cancel_delayed_work_sync(&ar->scan.timeout);
 }
 
 static void ath10k_set_key_h_def_keyidx(struct ath10k *ar,
@@ -3826,10 +3827,11 @@ static int ath10k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	cancel_delayed_work_sync(&ar->scan.timeout);
 	ath10k_scan_abort(ar);
 	mutex_unlock(&ar->conf_mutex);
 
+	cancel_delayed_work_sync(&ar->scan.timeout);
+
 	return 0;
 }
 
-- 
1.8.5.3

