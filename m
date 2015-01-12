Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34832 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbbALTsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:48:46 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [RFC 5/8] ath10k:  add firmware wmi keep-alive message.
Date: Mon, 12 Jan 2015 10:32:41 -0800
Message-Id: <1421087564-10384-5-git-send-email-greearb@candelatech.com> (sfid-20150112_204901_947397_4EE486B0)
In-Reply-To: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Only useful for CT firmware.

This sends a wmi message to the firmware every 2 seconds or so.
Once CT firmware receives one of these messages, it will assert
if it does not receive more within a 10 second window.

This helps debug and work-around wmi transport hangs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is for comment only, as it requires at least minimal CT firmware support
patches in order to compile or work.

 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 32 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   |  7 +++++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a16cadd..f3729bc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -367,6 +367,7 @@ struct ath10k_debug {
 
 	unsigned long htt_stats_mask;
 	struct delayed_work htt_stats_dwork;
+	struct delayed_work nop_dwork;
 	struct ath10k_dfs_stats dfs_stats;
 	struct ath_dfs_pool_stats dfs_pool_stats;
 
@@ -374,6 +375,7 @@ struct ath10k_debug {
 	u32 fw_dbglog_mask;
 	u32 pktlog_filter;
 	u32 reg_addr;
+	u32 nop_id;
 
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 92c8488..f419e88 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -27,6 +27,8 @@
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
 
+#define ATH10K_DEBUG_NOP_INTERVAL 2000 /* ms */
+
 #define ATH10K_FW_CRASH_DUMP_VERSION 1
 
 /**
@@ -1550,6 +1552,27 @@ static void ath10k_debug_htt_stats_dwork(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_debug_nop_dwork(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k,
+					 debug.nop_dwork.work);
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state == ATH10K_STATE_ON) {
+		int ret = ath10k_wmi_request_nop(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to send wmi nop: %d\n", ret);
+		}
+	}
+
+	/* Re-arm periodic work. */
+	queue_delayed_work(ar->workqueue, &ar->debug.nop_dwork,
+			   msecs_to_jiffies(ATH10K_DEBUG_NOP_INTERVAL));
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
 static ssize_t ath10k_read_htt_stats_mask(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
@@ -2192,6 +2215,11 @@ int ath10k_debug_register(struct ath10k *ar)
 		return -ENOMEM;
 	}
 
+	INIT_DELAYED_WORK(&ar->debug.nop_dwork, ath10k_debug_nop_dwork);
+
+	queue_delayed_work(ar->workqueue, &ar->debug.nop_dwork,
+			   msecs_to_jiffies(ATH10K_DEBUG_NOP_INTERVAL));
+
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
 			  ath10k_debug_htt_stats_dwork);
 
@@ -2262,6 +2290,7 @@ int ath10k_debug_register(struct ath10k *ar)
 
 void ath10k_debug_unregister(struct ath10k *ar)
 {
+	cancel_delayed_work_sync(&ar->debug.nop_dwork);
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 203bcb9..5d3fe88 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4480,6 +4480,38 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->request_stats_cmdid);
 }
 
+#ifdef CONFIG_ATH10K_DEBUG
+/* CT firmware only:
+ * (re) start wmi keep-alive timer in firmware.  Once we start
+ * sending these, firmware will assert if it does not receive one
+ * after about 10 seconds.
+ */
+
+struct wmi_request_nop_cmd {
+	u32 nop_id; /* for debugging purposes */
+};
+
+int ath10k_wmi_request_nop(struct ath10k *ar)
+{
+	struct wmi_request_nop_cmd *cmd;
+	struct sk_buff *skb;
+
+	if (! test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
+		return 0;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_request_nop_cmd *)skb->data;
+	cmd->nop_id = __cpu_to_le32(ar->debug.nop_id++);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi request nop (id %d)\n",
+		   ar->debug.nop_id - 1);
+	return ath10k_wmi_cmd_send(ar, skb, WMI_NOP);
+}
+#endif
+
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 026a697..fc9f068 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -901,6 +901,8 @@ enum wmi_10x_cmd_id {
 	WMI_10X_GPIO_CONFIG_CMDID,
 	WMI_10X_GPIO_OUTPUT_CMDID,
 
+	WMI_NOP = WMI_10X_END_CMDID - 100, /* CT only:  wmi transport keep-alive, basically */
+
 	WMI_10X_PDEV_UTF_CMDID = WMI_10X_END_CMDID - 1,
 };
 
@@ -4736,4 +4738,9 @@ int ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
 int ath10k_wmi_pdev_pktlog_enable(struct ath10k *ar, u32 ev_list);
 int ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar);
 
+#ifdef CONFIG_ATH10K_DEBUG
+/* CT Firmware only */
+int ath10k_wmi_request_nop(struct ath10k *ar);
+#endif
+
 #endif /* _WMI_H_ */
-- 
1.7.11.7

