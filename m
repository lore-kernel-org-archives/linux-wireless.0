Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37258 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeCEG7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 01:59:11 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 2/2] ath10k: add debugfs support to configure fwtest parameters
Date: Mon,  5 Mar 2018 12:29:08 +0530
Message-Id: <1520233148-26050-3-git-send-email-akolli@codeaurora.org> (sfid-20180305_075914_482002_DF483674)
In-Reply-To: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sathishkumar Muruganandam <murugana@codeaurora.org>

Added a debugfs file "fw_test" to configure the tx parameters
through WMI_FWTEST_CMD

Usage:
cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_test
echo <param id> <val> > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_test

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h  |    3 ++
 drivers/net/wireless/ath/ath10k/debug.c |   81 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe6b30356d3b..2db734138877 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -496,6 +497,8 @@ struct ath10k_debug {
 	u32 reg_addr;
 	u32 nf_cal_period;
 	void *cal_data;
+	u32 fw_test_param_id;
+	u32 fw_test_param_value;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 554cd7856cb6..245237a6660b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2088,6 +2088,83 @@ static ssize_t ath10k_read_peer_stats(struct file *file, char __user *ubuf,
 	.open = simple_open
 };
 
+static ssize_t ath10k_read_fops_fw_test(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	const char buf[] =
+		"Commands used for FW test'\n"
+		"Syntax example:\n"
+		"echo 5 0 > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_test'\n";
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+/* fw_test support
+ */
+static ssize_t ath10k_write_fw_test(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32] = {0};
+	ssize_t rc;
+	u32 param_id;
+	u32 param_value;
+	int ret;
+
+	rc = simple_write_to_buffer(buf, sizeof(buf) - 1,
+				    ppos, user_buf, count);
+	if (rc < 0)
+		return rc;
+
+	buf[*ppos - 1] = '\0';
+
+	ret = sscanf(buf, "%u %x", &param_id, &param_value);
+
+	if (ret != 2)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
+
+	if (param_id) {
+		ar->debug.fw_test_param_id = param_id;
+		ar->debug.fw_test_param_value = param_value;
+	} else {
+		ath10k_warn(ar, "Enter a valid param ID!");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = ath10k_wmi_fw_test(ar, ar->debug.fw_test_param_id,
+				 ar->debug.fw_test_param_value);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to do fw_test: %d\n", ret);
+		goto exit;
+	}
+
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_fw_test = {
+	.read = ath10k_read_fops_fw_test,
+	.write = ath10k_write_fw_test,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
 					      char __user *user_buf,
 					      size_t count, loff_t *ppos)
@@ -2258,6 +2335,10 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_checksums", 0400, ar->debug.debugfs_phy, ar,
 			    &fops_fw_checksums);
 
+	if (test_bit(WMI_SERVICE_FWTEST, ar->wmi.svc_map))
+		debugfs_create_file("fw_test", 0600, ar->debug.debugfs_phy, ar,
+				    &fops_fw_test);
+
 	return 0;
 }
 
-- 
1.7.9.5
