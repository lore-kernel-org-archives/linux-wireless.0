Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33057 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaK0JXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 04:23:48 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so5910401wgh.34
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 01:23:47 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/7] ath10k: make wmi service bitmap non-debug
Date: Thu, 27 Nov 2014 10:11:17 +0100
Message-Id: <1417079481-22255-4-git-send-email-michal.kazior@tieto.com> (sfid-20141127_102401_689070_73990257)
In-Reply-To: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The service bitmap can be used to determine
firmware capabilities.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c | 11 +++--------
 drivers/net/wireless/ath/ath10k/debug.h |  9 ---------
 drivers/net/wireless/ath/ath10k/wmi.c   |  8 ++++----
 4 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a29498..5af9a24 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -123,6 +123,7 @@ struct ath10k_wmi {
 	struct completion service_ready;
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
+	DECLARE_BITMAP(svc_map, WMI_SERVICE_MAX);
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
@@ -313,7 +314,6 @@ struct ath10k_debug {
 	struct ath10k_fw_stats fw_stats;
 	struct completion fw_stats_complete;
 	bool fw_stats_done;
-	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_MAX);
 
 	unsigned long htt_stats_mask;
 	struct delayed_work htt_stats_dwork;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c096d00a..a716758 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -179,13 +179,6 @@ EXPORT_SYMBOL(ath10k_warn);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 
-void ath10k_debug_read_service_map(struct ath10k *ar,
-				   const void *service_map,
-				   size_t map_size)
-{
-	memcpy(ar->debug.wmi_service_bitmap, service_map, map_size);
-}
-
 static ssize_t ath10k_read_wmi_services(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos)
@@ -207,8 +200,9 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 	if (len > buf_len)
 		len = buf_len;
 
+	spin_lock_bh(&ar->data_lock);
 	for (i = 0; i < WMI_SERVICE_MAX; i++) {
-		enabled = test_bit(i, ar->debug.wmi_service_bitmap);
+		enabled = test_bit(i, ar->wmi.svc_map);
 		name = wmi_service_name(i);
 
 		if (!name) {
@@ -224,6 +218,7 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 				 "%-40s %s\n",
 				 name, enabled ? "enabled" : "-");
 	}
+	spin_unlock_bh(&ar->data_lock);
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 815d325..1b87a5d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -62,9 +62,6 @@ int ath10k_debug_create(struct ath10k *ar);
 void ath10k_debug_destroy(struct ath10k *ar);
 int ath10k_debug_register(struct ath10k *ar);
 void ath10k_debug_unregister(struct ath10k *ar);
-void ath10k_debug_read_service_map(struct ath10k *ar,
-				   const void *service_map,
-				   size_t map_size);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
@@ -109,12 +106,6 @@ static inline void ath10k_debug_unregister(struct ath10k *ar)
 {
 }
 
-static inline void ath10k_debug_read_service_map(struct ath10k *ar,
-						 const void *service_map,
-						 size_t map_size)
-{
-}
-
 static inline void ath10k_debug_fw_stats_process(struct ath10k *ar,
 						 struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 81ccc2e..c0f3e4d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2511,16 +2511,17 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 {
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
-	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
 	int ret;
 
+	memset(&ar->wmi.svc_map, 0, sizeof(ar->wmi.svc_map));
+
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
 		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
-		wmi_10x_svc_map(arg.service_map, svc_bmap,
+		wmi_10x_svc_map(arg.service_map, ar->wmi.svc_map,
 				arg.service_map_len);
 	} else {
 		ret = ath10k_wmi_main_pull_svc_rdy_ev(skb, &arg);
-		wmi_main_svc_map(arg.service_map, svc_bmap,
+		wmi_main_svc_map(arg.service_map, ar->wmi.svc_map,
 				 arg.service_map_len);
 	}
 
@@ -2543,7 +2544,6 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
 	ar->ath_common.regulatory.current_rd = __le32_to_cpu(arg.eeprom_rd);
 
-	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
 	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			arg.service_map, arg.service_map_len);
 
-- 
1.8.5.3

