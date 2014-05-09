Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37185 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaEIMmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:54 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2593879eei.5
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] ath10k: introduce core restart symbol
Date: Fri,  9 May 2014 14:35:52 +0200
Message-Id: <1399638957-20449-3-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144307_373043_740D6C52)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to have an extra preparation
code before restart work is scheduled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++--
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/pci.c  |  2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7034c72..acc22cc 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -672,7 +672,7 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_core_restart(struct work_struct *work)
+static void ath10k_core_restart_work(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
 
@@ -704,6 +704,12 @@ static void ath10k_core_restart(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+void ath10k_core_restart(struct ath10k *ar)
+{
+	queue_work(ar->workqueue, &ar->restart_work);
+}
+EXPORT_SYMBOL(ath10k_core_restart);
+
 struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops)
 {
@@ -749,7 +755,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	INIT_WORK(&ar->wmi_mgmt_tx_work, ath10k_mgmt_over_wmi_tx_work);
 	skb_queue_head_init(&ar->wmi_mgmt_tx_queue);
 
-	INIT_WORK(&ar->restart_work, ath10k_core_restart);
+	INIT_WORK(&ar->restart_work, ath10k_core_restart_work);
 
 	return ar;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2c1dfd7..170094d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -494,5 +494,6 @@ int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
 void ath10k_core_unregister(struct ath10k *ar);
+void ath10k_core_restart(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 438d3cf..7be5784 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1788,7 +1788,7 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 
 		if (ar_pci->started) {
 			ath10k_pci_hif_dump_area(ar);
-			queue_work(ar->workqueue, &ar->restart_work);
+			ath10k_core_restart(ar);
 		} else {
 			/*
 			 * Probable Target failure before we're prepared
-- 
1.8.5.3

