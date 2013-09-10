Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:45718 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3IJNuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 09:50:12 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] ath10k: remove wmi pending count limit
Date: Tue, 10 Sep 2013 15:50:02 +0200
Message-ID: <1378821003-22925-7-git-send-email-michal.kazior@tieto.com> (sfid-20130910_155026_598440_D7610C6E)
In-Reply-To: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is no longer used nor necessary since WMI
commands can block.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    2 --
 drivers/net/wireless/ath/ath10k/mac.c  |    9 ---------
 drivers/net/wireless/ath/ath10k/wmi.c  |   32 --------------------------------
 drivers/net/wireless/ath/ath10k/wmi.h  |    2 --
 4 files changed, 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 14b7d3d..c2b6a76 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -112,8 +112,6 @@ struct ath10k_wmi {
 	enum ath10k_htc_ep_id eid;
 	struct completion service_ready;
 	struct completion unified_ready;
-	atomic_t pending_tx_count;
-	wait_queue_head_t wq;
 	wait_queue_head_t tx_credits_wq;
 
 	struct sk_buff_head wmi_event_list;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 439d0c3..698088f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1205,8 +1205,6 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 		ath10k_dbg(ATH10K_DBG_MAC, "VDEV: %d ath10k_wmi_vdev_down failed (%d)\n",
 			   arvif->vdev_id, ret);
 
-	ath10k_wmi_flush_tx(ar);
-
 	arvif->def_wep_key_index = 0;
 }
 
@@ -1643,8 +1641,6 @@ static int ath10k_abort_scan(struct ath10k *ar)
 		return -EIO;
 	}
 
-	ath10k_wmi_flush_tx(ar);
-
 	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
 	if (ret == 0)
 		ath10k_warn("timed out while waiting for scan to stop\n");
@@ -1678,10 +1674,6 @@ static int ath10k_start_scan(struct ath10k *ar,
 	if (ret)
 		return ret;
 
-	/* make sure we submit the command so the completion
-	* timeout makes sense */
-	ath10k_wmi_flush_tx(ar);
-
 	ret = wait_for_completion_timeout(&ar->scan.started, 1*HZ);
 	if (ret == 0) {
 		ath10k_abort_scan(ar);
@@ -1903,7 +1895,6 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 			ret = ath10k_monitor_destroy(ar);
 	}
 
-	ath10k_wmi_flush_tx(ar);
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c13e434..aa7093a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -23,30 +23,6 @@
 #include "wmi.h"
 #include "mac.h"
 
-void ath10k_wmi_flush_tx(struct ath10k *ar)
-{
-	int ret;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	if (ar->state == ATH10K_STATE_WEDGED) {
-		ath10k_warn("wmi flush skipped - device is wedged anyway\n");
-		return;
-	}
-
-	ret = wait_event_timeout(ar->wmi.wq,
-				 atomic_read(&ar->wmi.pending_tx_count) == 0,
-				 5*HZ);
-	if (atomic_read(&ar->wmi.pending_tx_count) == 0)
-		return;
-
-	if (ret == 0)
-		ret = -ETIMEDOUT;
-
-	if (ret < 0)
-		ath10k_warn("wmi flush failed (%d)\n", ret);
-}
-
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -85,9 +61,6 @@ static struct sk_buff *ath10k_wmi_alloc_skb(u32 len)
 static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
 	dev_kfree_skb(skb);
-
-	if (atomic_sub_return(1, &ar->wmi.pending_tx_count) == 0)
-		wake_up(&ar->wmi.wq);
 }
 
 static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
@@ -1239,7 +1212,6 @@ int ath10k_wmi_attach(struct ath10k *ar)
 {
 	init_completion(&ar->wmi.service_ready);
 	init_completion(&ar->wmi.unified_ready);
-	init_waitqueue_head(&ar->wmi.wq);
 	init_waitqueue_head(&ar->wmi.tx_credits_wq);
 
 	skb_queue_head_init(&ar->wmi.wmi_event_list);
@@ -1250,10 +1222,6 @@ int ath10k_wmi_attach(struct ath10k *ar)
 
 void ath10k_wmi_detach(struct ath10k *ar)
 {
-	/* HTC should've drained the packets already */
-	if (WARN_ON(atomic_read(&ar->wmi.pending_tx_count) > 0))
-		ath10k_warn("there are still pending packets\n");
-
 	cancel_work_sync(&ar->wmi.wmi_event_work);
 	skb_queue_purge(&ar->wmi.wmi_event_list);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 482461a..82d6103 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3002,7 +3002,6 @@ struct wmi_force_fw_hang_cmd {
 
 #define WMI_MAX_EVENT 0x1000
 /* Maximum number of pending TXed WMI packets */
-#define WMI_MAX_PENDING_TX_COUNT 128
 #define WMI_SKB_HEADROOM sizeof(struct wmi_cmd_hdr)
 
 /* By default disable power save for IBSS */
@@ -3015,7 +3014,6 @@ int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
-void ath10k_wmi_flush_tx(struct ath10k *ar);
 
 int ath10k_wmi_connect_htc_service(struct ath10k *ar);
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
-- 
1.7.9.5

