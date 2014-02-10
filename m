Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:60003 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaBJQO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 11:14:57 -0500
Received: by mail-ea0-f177.google.com with SMTP id m10so490879eaj.36
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 08:14:55 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH 3/3] ath10k: suspend hardware before reset
Date: Mon, 10 Feb 2014 17:14:24 +0100
Message-Id: <1392048864-13352-4-git-send-email-marek.puzyniak@tieto.com> (sfid-20140210_171518_595186_EAE6B2B7)
In-Reply-To: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
References: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of warm reset target need to be suspended.
Suspend function is extented to handle both cases
with disabling interrupts and without disabling interrupts.
Warm target reset requires suspend with all interrupts
disabled.

This patch depends on
ath10k: fix device initialization routine

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 14 +++-----------
 drivers/net/wireless/ath/ath10k/wmi.c  |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.h  |  2 +-
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0d161cf..ebc5fc2 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -858,10 +858,34 @@ err:
 }
 EXPORT_SYMBOL(ath10k_core_start);
 
+int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt)
+{
+	int ret;
+
+	reinit_completion(&ar->target_suspend);
+
+	ret = ath10k_wmi_pdev_suspend_target(ar, suspend_opt);
+	if (ret) {
+		ath10k_warn("could not suspend target (%d)\n", ret);
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&ar->target_suspend, 1 * HZ);
+
+	if (ret == 0) {
+		ath10k_warn("suspend timed out - target pause event never came\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 void ath10k_core_stop(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
+	/* try to suspend target */
+	ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
 	ath10k_debug_stop(ar);
 	ath10k_htc_stop(&ar->htc);
 	ath10k_htt_detach(&ar->htt);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4f7ff9b..fae53f9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -492,6 +492,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 void ath10k_core_destroy(struct ath10k *ar);
 
 int ath10k_core_start(struct ath10k *ar);
+int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
 void ath10k_core_unregister(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 751284b..90a9ef6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3442,22 +3442,14 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
-	reinit_completion(&ar->target_suspend);
-
-	ret = ath10k_wmi_pdev_suspend_target(ar);
+	ret = ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND);
 	if (ret) {
-		ath10k_warn("could not suspend target (%d)\n", ret);
+		if (ret == -ETIMEDOUT)
+			goto resume;
 		ret = 1;
 		goto exit;
 	}
 
-	ret = wait_for_completion_timeout(&ar->target_suspend, 1 * HZ);
-
-	if (ret == 0) {
-		ath10k_warn("suspend timed out - target pause event never came\n");
-		goto resume;
-	}
-
 	ret = ath10k_hif_suspend(ar);
 	if (ret) {
 		ath10k_warn("could not suspend hif (%d)\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7298c06..cf8dc13 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2443,7 +2443,7 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				   ar->wmi.cmd->pdev_set_channel_cmdid);
 }
 
-int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
+int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt)
 {
 	struct wmi_pdev_suspend_cmd *cmd;
 	struct sk_buff *skb;
@@ -2453,7 +2453,7 @@ int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
 		return -ENOMEM;
 
 	cmd = (struct wmi_pdev_suspend_cmd *)skb->data;
-	cmd->suspend_opt = WMI_PDEV_SUSPEND;
+	cmd->suspend_opt = __cpu_to_le32(suspend_opt);
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_suspend_cmdid);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 083079f..fc1093a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4193,7 +4193,7 @@ int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 int ath10k_wmi_connect_htc_service(struct ath10k *ar);
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *);
-int ath10k_wmi_pdev_suspend_target(struct ath10k *ar);
+int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);
 int ath10k_wmi_pdev_resume_target(struct ath10k *ar);
 int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
 				  u16 rd5g, u16 ctl2g, u16 ctl5g);
-- 
1.8.1.2

