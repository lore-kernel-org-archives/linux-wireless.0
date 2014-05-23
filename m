Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39963 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEWKf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 06:35:58 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so3548833eek.34
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 03:35:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: relocate core create/destroy functions
Date: Fri, 23 May 2014 12:28:45 +0200
Message-Id: <1400840927-14272-2-git-send-email-michal.kazior@tieto.com> (sfid-20140523_123621_603888_37563193)
In-Reply-To: <1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
 <1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will avoid unnecessary forward declaration of
any kind in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 128 ++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 75b3dfb..bd4d1cc 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -701,70 +701,6 @@ static void ath10k_core_restart(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
-struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
-				  const struct ath10k_hif_ops *hif_ops)
-{
-	struct ath10k *ar;
-
-	ar = ath10k_mac_create();
-	if (!ar)
-		return NULL;
-
-	ar->ath_common.priv = ar;
-	ar->ath_common.hw = ar->hw;
-
-	ar->p2p = !!ath10k_p2p;
-	ar->dev = dev;
-
-	ar->hif.priv = hif_priv;
-	ar->hif.ops = hif_ops;
-
-	init_completion(&ar->scan.started);
-	init_completion(&ar->scan.completed);
-	init_completion(&ar->scan.on_channel);
-	init_completion(&ar->target_suspend);
-
-	init_completion(&ar->install_key_done);
-	init_completion(&ar->vdev_setup_done);
-
-	setup_timer(&ar->scan.timeout, ath10k_reset_scan, (unsigned long)ar);
-
-	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
-	if (!ar->workqueue)
-		goto err_wq;
-
-	mutex_init(&ar->conf_mutex);
-	spin_lock_init(&ar->data_lock);
-
-	INIT_LIST_HEAD(&ar->peers);
-	init_waitqueue_head(&ar->peer_mapping_wq);
-
-	init_completion(&ar->offchan_tx_completed);
-	INIT_WORK(&ar->offchan_tx_work, ath10k_offchan_tx_work);
-	skb_queue_head_init(&ar->offchan_tx_queue);
-
-	INIT_WORK(&ar->wmi_mgmt_tx_work, ath10k_mgmt_over_wmi_tx_work);
-	skb_queue_head_init(&ar->wmi_mgmt_tx_queue);
-
-	INIT_WORK(&ar->restart_work, ath10k_core_restart);
-
-	return ar;
-
-err_wq:
-	ath10k_mac_destroy(ar);
-	return NULL;
-}
-EXPORT_SYMBOL(ath10k_core_create);
-
-void ath10k_core_destroy(struct ath10k *ar)
-{
-	flush_workqueue(ar->workqueue);
-	destroy_workqueue(ar->workqueue);
-
-	ath10k_mac_destroy(ar);
-}
-EXPORT_SYMBOL(ath10k_core_destroy);
-
 int ath10k_core_start(struct ath10k *ar)
 {
 	int status;
@@ -1058,6 +994,70 @@ void ath10k_core_unregister(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
+struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
+				  const struct ath10k_hif_ops *hif_ops)
+{
+	struct ath10k *ar;
+
+	ar = ath10k_mac_create();
+	if (!ar)
+		return NULL;
+
+	ar->ath_common.priv = ar;
+	ar->ath_common.hw = ar->hw;
+
+	ar->p2p = !!ath10k_p2p;
+	ar->dev = dev;
+
+	ar->hif.priv = hif_priv;
+	ar->hif.ops = hif_ops;
+
+	init_completion(&ar->scan.started);
+	init_completion(&ar->scan.completed);
+	init_completion(&ar->scan.on_channel);
+	init_completion(&ar->target_suspend);
+
+	init_completion(&ar->install_key_done);
+	init_completion(&ar->vdev_setup_done);
+
+	setup_timer(&ar->scan.timeout, ath10k_reset_scan, (unsigned long)ar);
+
+	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
+	if (!ar->workqueue)
+		goto err_wq;
+
+	mutex_init(&ar->conf_mutex);
+	spin_lock_init(&ar->data_lock);
+
+	INIT_LIST_HEAD(&ar->peers);
+	init_waitqueue_head(&ar->peer_mapping_wq);
+
+	init_completion(&ar->offchan_tx_completed);
+	INIT_WORK(&ar->offchan_tx_work, ath10k_offchan_tx_work);
+	skb_queue_head_init(&ar->offchan_tx_queue);
+
+	INIT_WORK(&ar->wmi_mgmt_tx_work, ath10k_mgmt_over_wmi_tx_work);
+	skb_queue_head_init(&ar->wmi_mgmt_tx_queue);
+
+	INIT_WORK(&ar->restart_work, ath10k_core_restart);
+
+	return ar;
+
+err_wq:
+	ath10k_mac_destroy(ar);
+	return NULL;
+}
+EXPORT_SYMBOL(ath10k_core_create);
+
+void ath10k_core_destroy(struct ath10k *ar)
+{
+	flush_workqueue(ar->workqueue);
+	destroy_workqueue(ar->workqueue);
+
+	ath10k_mac_destroy(ar);
+}
+EXPORT_SYMBOL(ath10k_core_destroy);
+
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Core module for QCA988X PCIe devices.");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
1.8.5.3

