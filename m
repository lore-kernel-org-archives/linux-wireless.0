Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59416 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaJTNKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:10:17 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so3812554lbg.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:10:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] ath10k: make wmi service bitmap non-debug
Date: Mon, 20 Oct 2014 14:58:41 +0200
Message-Id: <1413809925-4352-4-git-send-email-michal.kazior@tieto.com> (sfid-20141020_151024_667207_87FBFA20)
In-Reply-To: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
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
index 1ac2f14..0b08ad2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -108,6 +108,7 @@ struct ath10k_wmi {
 	struct completion service_ready;
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
+	DECLARE_BITMAP(svc_map, WMI_SERVICE_MAX);
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
@@ -295,7 +296,6 @@ struct ath10k_debug {
 	struct ath10k_fw_stats fw_stats;
 	struct completion fw_stats_complete;
 	bool fw_stats_done;
-	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_MAX);
 
 	unsigned long htt_stats_mask;
 	struct delayed_work htt_stats_dwork;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0d94feb..77ddbdd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -178,13 +178,6 @@ EXPORT_SYMBOL(ath10k_warn);
 
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
@@ -206,8 +199,9 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 	if (len > buf_len)
 		len = buf_len;
 
+	spin_lock_bh(&ar->data_lock);
 	for (i = 0; i < WMI_SERVICE_MAX; i++) {
-		enabled = test_bit(i, ar->debug.wmi_service_bitmap);
+		enabled = test_bit(i, ar->wmi.svc_map);
 		name = wmi_service_name(i);
 
 		if (!name) {
@@ -223,6 +217,7 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 				 "%-40s %s\n",
 				 name, enabled ? "enabled" : "-");
 	}
+	spin_unlock_bh(&ar->data_lock);
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 0c934a8..b7a69df 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -61,9 +61,6 @@ int ath10k_debug_create(struct ath10k *ar);
 void ath10k_debug_destroy(struct ath10k *ar);
 int ath10k_debug_register(struct ath10k *ar);
 void ath10k_debug_unregister(struct ath10k *ar);
-void ath10k_debug_read_service_map(struct ath10k *ar,
-				   const void *service_map,
-				   size_t map_size);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
@@ -108,12 +105,6 @@ static inline void ath10k_debug_unregister(struct ath10k *ar)
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
index 2c2e727..49887fd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2465,16 +2465,17 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
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
 
@@ -2497,7 +2498,6 @@ static void ath10k_wmi_event_service_ready(struct ath10k *ar,
 	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
 	ar->ath_common.regulatory.current_rd = __le32_to_cpu(arg.eeprom_rd);
 
-	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
 	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			arg.service_map, arg.service_map_len);
 
-- 
1.8.5.3

