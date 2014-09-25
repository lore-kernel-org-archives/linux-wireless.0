Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:63819 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaIYKog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:36 -0400
Received: by mail-we0-f176.google.com with SMTP id w61so6788159wes.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 03:44:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: rename fw_stats related stuff
Date: Thu, 25 Sep 2014 12:33:48 +0200
Message-Id: <1411641230-18785-3-git-send-email-michal.kazior@tieto.com> (sfid-20140925_124443_666160_02DBCB08)
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The naming was a bit inconsistent.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 11 +++++------
 drivers/net/wireless/ath/ath10k/debug.c | 18 +++++++++---------
 drivers/net/wireless/ath/ath10k/debug.h |  6 +++---
 drivers/net/wireless/ath/ath10k/wmi.c   | 12 ++++++------
 drivers/net/wireless/ath/ath10k/wmi.h   |  4 ++--
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8a997b6..082a8dad 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -116,14 +116,14 @@ struct ath10k_wmi {
 	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
 };
 
-struct ath10k_peer_stat {
+struct ath10k_fw_stats_peer {
 	u8 peer_macaddr[ETH_ALEN];
 	u32 peer_rssi;
 	u32 peer_tx_rate;
 	u32 peer_rx_rate; /* 10x only */
 };
 
-struct ath10k_target_stats {
+struct ath10k_fw_stats {
 	/* PDEV stats */
 	s32 ch_noise_floor;
 	u32 tx_frame_count;
@@ -183,7 +183,7 @@ struct ath10k_target_stats {
 
 	/* PEER STATS */
 	u8 peers;
-	struct ath10k_peer_stat peer_stat[TARGET_NUM_PEERS];
+	struct ath10k_fw_stats_peer peer_stat[TARGET_NUM_PEERS];
 
 	/* TODO: Beacon filter stats */
 
@@ -292,11 +292,10 @@ struct ath10k_fw_crash_data {
 struct ath10k_debug {
 	struct dentry *debugfs_phy;
 
-	struct ath10k_target_stats target_stats;
+	struct ath10k_fw_stats fw_stats;
+	struct completion fw_stats_complete;
 	DECLARE_BITMAP(wmi_service_bitmap, WMI_SERVICE_MAX);
 
-	struct completion event_stats_compl;
-
 	unsigned long htt_stats_mask;
 	struct delayed_work htt_stats_dwork;
 	struct ath10k_dfs_stats dfs_stats;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0afd1aa..97b5c16 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -242,29 +242,29 @@ static const struct file_operations fops_wmi_services = {
 	.llseek = default_llseek,
 };
 
-void ath10k_debug_read_target_stats(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 {
 	int ret;
 
 	spin_lock_bh(&ar->data_lock);
 
-	ret = ath10k_wmi_pull_fw_stats(ar, skb, &ar->debug.target_stats);
+	ret = ath10k_wmi_pull_fw_stats(ar, skb, &ar->debug.fw_stats);
 	if (ret) {
 		ath10k_warn(ar, "failed to pull fw stats: %d\n", ret);
 		goto unlock;
 	}
 
-	complete(&ar->debug.event_stats_compl);
+	complete(&ar->debug.fw_stats_complete);
 
 unlock:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
+static ssize_t ath10k_fw_stats_read(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
-	struct ath10k_target_stats *fw_stats;
+	struct ath10k_fw_stats *fw_stats;
 	char *buf = NULL;
 	unsigned int len = 0, buf_len = 8000;
 	ssize_t ret_cnt = 0;
@@ -272,7 +272,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	int i;
 	int ret;
 
-	fw_stats = &ar->debug.target_stats;
+	fw_stats = &ar->debug.fw_stats;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -289,7 +289,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 		goto exit;
 	}
 
-	left = wait_for_completion_timeout(&ar->debug.event_stats_compl, 1*HZ);
+	left = wait_for_completion_timeout(&ar->debug.fw_stats_complete, 1*HZ);
 	if (left <= 0)
 		goto exit;
 
@@ -448,7 +448,7 @@ exit:
 }
 
 static const struct file_operations fops_fw_stats = {
-	.read = ath10k_read_fw_stats,
+	.read = ath10k_fw_stats_read,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1072,7 +1072,7 @@ int ath10k_debug_register(struct ath10k *ar)
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
 			  ath10k_debug_htt_stats_dwork);
 
-	init_completion(&ar->debug.event_stats_compl);
+	init_completion(&ar->debug.fw_stats_complete);
 
 	debugfs_create_file("fw_stats", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_fw_stats);
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index f7e8131..8d15bce 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -55,7 +55,7 @@ void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_read_service_map(struct ath10k *ar,
 				   const void *service_map,
 				   size_t map_size);
-void ath10k_debug_read_target_stats(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 
@@ -97,8 +97,8 @@ static inline void ath10k_debug_read_service_map(struct ath10k *ar,
 {
 }
 
-static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
-						  struct sk_buff *skb)
+static inline void ath10k_debug_fw_stats_process(struct ath10k *ar,
+						 struct sk_buff *skb)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8e2d021..c4640aa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1330,7 +1330,7 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				       struct ath10k_target_stats *dst)
+				       struct ath10k_fw_stats *dst)
 {
 	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
 	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
@@ -1383,7 +1383,7 @@ static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
 }
 
 static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
-				       struct ath10k_peer_stat *dst)
+				       struct ath10k_fw_stats_peer *dst)
 {
 	ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
 	dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
@@ -1392,7 +1392,7 @@ static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
 
 static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
 					 struct sk_buff *skb,
-					 struct ath10k_target_stats *stats)
+					 struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
@@ -1432,7 +1432,7 @@ static int ath10k_wmi_main_pull_fw_stats(struct ath10k *ar,
 
 static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
 					struct sk_buff *skb,
-					struct ath10k_target_stats *stats)
+					struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
@@ -1481,7 +1481,7 @@ static int ath10k_wmi_10x_pull_fw_stats(struct ath10k *ar,
 }
 
 int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
-			     struct ath10k_target_stats *stats)
+			     struct ath10k_fw_stats *stats)
 {
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
 		return ath10k_wmi_10x_pull_fw_stats(ar, skb, stats);
@@ -1493,7 +1493,7 @@ static void ath10k_wmi_event_update_stats(struct ath10k *ar,
 					  struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
-	ath10k_debug_read_target_stats(ar, skb);
+	ath10k_debug_fw_stats_process(ar, skb);
 }
 
 static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4ce8e3c..6243dbe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4573,7 +4573,7 @@ struct wmi_svc_rdy_ev_arg {
 
 struct ath10k;
 struct ath10k_vif;
-struct ath10k_target_stats;
+struct ath10k_fw_stats;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
@@ -4646,6 +4646,6 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable);
 int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
-			     struct ath10k_target_stats *stats);
+			     struct ath10k_fw_stats *stats);
 
 #endif /* _WMI_H_ */
-- 
1.8.5.3

