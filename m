Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679Ab1D1Jh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:37:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH wireless-2.6] iwl4965: fix "TX Power requested while scanning"
Date: Thu, 28 Apr 2011 11:36:54 +0200
Message-Id: <1303983414-6256-1-git-send-email-sgruszka@redhat.com> (sfid-20110428_113810_267017_4B94CDC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following:

WARNING: at drivers/net/wireless/iwlegacy/iwl-4965.c:1128 \
iwl4965_send_tx_power+0x61/0x102 [iwl4965]() Hardware name: [...]
TX Power requested while scanning!

Pid: 5723, comm: kworker/u:28 Not tainted 2.6.39-0.rc4.4.fc14.x86_64 #1
Call Trace:
 [<ffffffff8104e27b>] warn_slowpath_common+0x85/0x9d
 [<ffffffffa02782e0>] ? iwl4965_show_temperature+0x49/0x49 [iwl4965]
 [<ffffffff8104e336>] warn_slowpath_fmt+0x46/0x48
 [<ffffffffa027712f>] iwl4965_send_tx_power+0x61/0x102 [iwl4965]
 [<ffffffff81477e05>] ? mutex_lock+0x36/0x50
 [<ffffffffa0278337>] iwl4965_bg_txpower_work+0x57/0x73 [iwl4965]
 [<ffffffff810647f3>] process_one_work+0x18d/0x286
 [<ffffffff81065a5e>] worker_thread+0xfd/0x181
 [<ffffffff81065961>] ? manage_workers.clone.16+0x172/0x172
 [<ffffffff81069036>] kthread+0x82/0x8a
 [<ffffffff81480524>] kernel_thread_helper+0x4/0x10
 [<ffffffff81068fb4>] ? kthread_worker_fn+0x14b/0x14b
 [<ffffffff81480520>] ? gs_change+0x13/0x13

Reported-and-tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index f887054..ad05f2e 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2984,15 +2984,15 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			txpower_work);
 
+	mutex_lock(&priv->mutex);
+
 	/* If a scan happened to start before we got here
 	 * then just return; the statistics notification will
 	 * kick off another scheduled work to compensate for
 	 * any temperature delta we missed here. */
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    test_bit(STATUS_SCANNING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
+		goto out;
 
 	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
@@ -3002,7 +3002,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
 	priv->last_temperature = priv->temperature;
-
+out:
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.1

