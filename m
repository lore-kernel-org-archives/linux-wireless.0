Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26161 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CFJJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 04:09:33 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix kernel panic while receiving fwlog during boot
Date: Tue, 6 Mar 2012 14:39:40 +0530
Message-ID: <1331024980-1632-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120306_100940_411660_B7166591)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ath6kl: Defer wiphy and netdev registration till the end of ath6kl_core_init()"
causes kernel panic by accessing the unallocated debug resources during
boot time. To fix this, split the debug initialization funtion into two,
one initializes the debug resource and the other takes care of debugfs
initialization. When this issue shows up the kernel crash dump would
look like

 ath6kl_debug_fwlog_event+0x9c/0x10a
 [<c10666c9>] register_lock_class+0x57/0x288
 [<c1065cd3>] ? trace_hardirqs_on+0xb/0xd
 [<f801f4c9>] ? ath6kl_debug_fwlog_event+0x9c/0x10a
 [<c1066a8a>] __lock_acquire+0x96/0xbe5
 [<c106007b>] ? alarmtimer_suspend+0x80/0x127
 [<c10258da>] ? vprintk+0x394/0x3b1
 [<f801f4c9>] ? ath6kl_debug_fwlog_event+0x9c/0x10a
 [<c10676b3>] lock_acquire+0xda/0xf9
 [<f801f4c9>] ? ath6kl_debug_fwlog_event+0x9c/0x10a
 [<c1532ce3>] _raw_spin_lock+0x28/0x58
 [<f801f4c9>] ? ath6kl_debug_fwlog_event+0x9c/0x10a
 [<f801f4c9>] ath6kl_debug_fwlog_event+0x9c/0x10a
 [<f80310a4>] ath6kl_wmi_control_rx+0x69d/0xb50 [ath6kl_core]
 [<f802d2e1>] ? ath6kl_rx+0x3c/0x839 [ath6kl_core]
 [<f802d35d>] ath6kl_rx+0xb8/0x839 [ath6kl_core]
 [<c104b81e>] ? local_clock+0x2d/0x4e
 [<c102a0af>] ? _local_bh_enable_ip+0x94/0x98
 [<f802bfc0>] ? ath6kl_alloc_amsdu_rxbuf+0xb7/0xb7
 [<f8023b28>] ath6kl_htc_rxmsg_pending_handler+0x891/0x988 [ath6kl_core]
 [<f802bf00>] ? ath6kl_refill_amsdu_rxbufs+0x89/0x92
 [<f802d2a5>] ? aggr_timeout+0xed/0xed [ath6kl_core]
 [<f802bfc0>] ? ath6kl_alloc_amsdu_rxbuf+0xb7/0xb7
 [<f802c420>] ? ath6kl_tx_complete+0x376/0x376 [ath6kl_core]
 [<f8020e92>] ath6kl_hif_intr_bh_handler+0xf7/0x33e
 [<c138ab00>] ? mmc_host_disable+0x15/0x3a
 [<f8123b5c>] ath6kl_sdio_irq_handler+0x3c/0x90 [ath6kl_sdio]
 [<c1392f56>] sdio_irq_thread+0xb6/0x29c
 [<c1392ea0>] ? sdio_claim_irq+0x1cb/0x1cb
 [<c103d4c0>] kthread+0x67/0x6c
 [<c103d459>] ? __init_kthread_worker+0x42/0x42
 [<c153903a>] kernel_thread_helper+0x6/0xd
 BUG: unable to handle kernel NULL pointer dereference at
EIP: [<f801f4d4>] ath6kl_debug_fwlog_event+0xa7/0x10a

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c  |    9 +++++----
 drivers/net/wireless/ath/ath6kl/debug.c |    5 ++++-
 drivers/net/wireless/ath/ath6kl/debug.h |    9 +++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index e66cf43..24c5109 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -124,6 +124,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
+	ath6kl_debug_init(ar);
+
 	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
 		ath6kl_err("Failed to start hardware: %d\n", ret);
@@ -138,7 +140,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_rxbuf_cleanup;
 
-	ret = ath6kl_debug_init(ar);
+	ret = ath6kl_debugfs_init(ar);
 	if (ret) {
 		wiphy_unregister(ar->wiphy);
 		goto err_rxbuf_cleanup;
@@ -159,7 +161,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 		ath6kl_err("Failed to instantiate a network device\n");
 		ret = -ENOMEM;
 		wiphy_unregister(ar->wiphy);
-		goto err_debug_init;
+		goto err_rxbuf_cleanup;
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
@@ -167,9 +169,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	return ret;
 
-err_debug_init:
-	ath6kl_debug_cleanup(ar);
 err_rxbuf_cleanup:
+	ath6kl_debug_cleanup(ar);
 	ath6kl_htc_flush_rx_buf(ar->htc_target);
 	ath6kl_cleanup_amsdu_rxbufs(ar);
 	ath6kl_wmi_shutdown(ar->wmi);
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 28b516f..49e3c6e 100755
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1722,7 +1722,7 @@ static const struct file_operations fops_power_params = {
 	.llseek = default_llseek,
 };
 
-int ath6kl_debug_init(struct ath6kl *ar)
+void ath6kl_debug_init(struct ath6kl *ar)
 {
 	skb_queue_head_init(&ar->debug.fwlog_queue);
 	init_completion(&ar->debug.fwlog_completion);
@@ -1732,7 +1732,10 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	 * value from the firmware.
 	 */
 	ar->debug.fwlog_mask = 0;
+}
 
+int ath6kl_debugfs_init(struct ath6kl *ar)
+{
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
 					     ar->wiphy->debugfsdir);
 	if (!ar->debugfs_phy)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index c5d5e6c..a196f12 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -78,7 +78,8 @@ int ath6kl_debug_roam_tbl_event(struct ath6kl *ar, const void *buf,
 				size_t len);
 void ath6kl_debug_set_keepalive(struct ath6kl *ar, u8 keepalive);
 void ath6kl_debug_set_disconnect_timeout(struct ath6kl *ar, u8 timeout);
-int ath6kl_debug_init(struct ath6kl *ar);
+void ath6kl_debug_init(struct ath6kl *ar);
+int ath6kl_debugfs_init(struct ath6kl *ar);
 void ath6kl_debug_cleanup(struct ath6kl *ar);
 
 #else
@@ -128,7 +129,11 @@ static inline void ath6kl_debug_set_disconnect_timeout(struct ath6kl *ar,
 {
 }
 
-static inline int ath6kl_debug_init(struct ath6kl *ar)
+static inline void ath6kl_debug_init(struct ath6kl *ar)
+{
+}
+
+static inline int ath6kl_debugfs_init(struct ath6kl *ar)
 {
 	return 0;
 }
-- 
1.7.0.4

