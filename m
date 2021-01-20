Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B07C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Jan 2021 03:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DDA2311C
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Jan 2021 03:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbhATDXM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:23:12 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:30603 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbhATCcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jan 2021 21:32:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611109902; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=zZhbbgN1aNaYMatzWLZZmW6596lnCtgrp5FcvjFMtQA=; b=Q82LyI8G7DdeLZH5AcxXxcJsIb7YlzuseID57GEYVcGrC90OyeDcz62+5WZPJva8frE0PX72
 0HGWSZWGXmXdKuaSDG76NRiDEmi6/W3k+jVD7t1QV6vWxmZmJ4SEoqOnXy2zRj48CT1P7mUy
 dg422MyfdP24rOU57CpZlLAuOn8=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 600795e17086580d32fcdfd1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Jan 2021 02:30:57
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B07DEC43462; Wed, 20 Jan 2021 02:30:57 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93C6FC433C6;
        Wed, 20 Jan 2021 02:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93C6FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>,
        Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH V4 2/2] ath11k: add debugfs for TWT debug calls
Date:   Tue, 19 Jan 2021 18:30:48 -0800
Message-Id: <20210120023048.5016-3-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20210120023048.5016-1-alokad@codeaurora.org>
References: <20210120023048.5016-1-alokad@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: John Crispin <john@phrozen.org>

These new debugfs files allow us to manually add/del/pause/resume TWT
dialogs for test/debug purposes.

The debugfs files expect the following parameters
add_dialog	- mac dialog_id wake_intvl_us wake_intvl_mantis
		  wake_dura_us sp_offset_us twt_cmd flag_bcast
		  flag_trigger flag_flow_type flag_protection
del_dialog	- mac dialog_id
pause_dialog	- mac dialog_id
resume_dialog	- mac dialog_id sp_offset_us next_twt_size

Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Aloka Dixit <alokad@codeaurora.org>
---
Changes in V3
* Resolved compilation warnings
* Rebased to latest git tree.
Changes in V2
* add a better patch description

 drivers/net/wireless/ath/ath11k/core.h  |   1 +
 drivers/net/wireless/ath/ath11k/debug.c | 199 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/debug.h |   8 +
 drivers/net/wireless/ath/ath11k/mac.c   |   5 +
 4 files changed, 213 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 9db375b193de..dfb589978b97 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -239,6 +239,7 @@ struct ath11k_vif {
 	bool rsnie_present;
 	bool wpaie_present;
 	struct ieee80211_chanctx_conf chanctx;
+	struct dentry *debugfs_twt;
 };
 
 struct ath11k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index c86de95fbdc5..a3db2bcef137 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -104,3 +104,202 @@ void ath11k_dbg_dump(struct ath11k_base *ab,
 EXPORT_SYMBOL(ath11k_dbg_dump);
 
 #endif /* CONFIG_ATH11K_DEBUG */
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+static ssize_t ath11k_write_twt_add_dialog(struct file *file,
+					   const char __user *ubuf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath11k_vif *arvif = file->private_data;
+	struct wmi_twt_add_dialog_params params = { 0 };
+	u8 buf[128] = {0};
+	int ret;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, ubuf, count);
+	if (ret < 0)
+		return ret;
+
+	buf[ret] = '\0';
+	ret = sscanf(buf,
+		     "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx %u %u %u %u %u %hhu %hhu %hhu %hhu %hhu",
+		     &params.peer_macaddr[0],
+		     &params.peer_macaddr[1],
+		     &params.peer_macaddr[2],
+		     &params.peer_macaddr[3],
+		     &params.peer_macaddr[4],
+		     &params.peer_macaddr[5],
+		     &params.dialog_id,
+		     &params.wake_intvl_us,
+		     &params.wake_intvl_mantis,
+		     &params.wake_dura_us,
+		     &params.sp_offset_us,
+		     &params.twt_cmd,
+		     &params.flag_bcast,
+		     &params.flag_trigger,
+		     &params.flag_flow_type,
+		     &params.flag_protection);
+	if (ret != 16)
+		return -EINVAL;
+
+	params.vdev_id = arvif->vdev_id;
+
+	ret = ath11k_wmi_send_twt_add_dialog_cmd(arvif->ar, &params);
+
+	return ret ? ret : count;
+}
+
+static ssize_t ath11k_write_twt_del_dialog(struct file *file,
+					   const char __user *ubuf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath11k_vif *arvif = file->private_data;
+	struct wmi_twt_del_dialog_params params = { 0 };
+	u8 buf[64] = {0};
+	int ret;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, ubuf, count);
+	if (ret < 0)
+		return ret;
+
+	buf[ret] = '\0';
+	ret = sscanf(buf, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx %u",
+		     &params.peer_macaddr[0],
+		     &params.peer_macaddr[1],
+		     &params.peer_macaddr[2],
+		     &params.peer_macaddr[3],
+		     &params.peer_macaddr[4],
+		     &params.peer_macaddr[5],
+		     &params.dialog_id);
+	if (ret != 7)
+		return -EINVAL;
+
+	params.vdev_id = arvif->vdev_id;
+
+	ret = ath11k_wmi_send_twt_del_dialog_cmd(arvif->ar, &params);
+
+	return ret ? ret : count;
+}
+
+static ssize_t ath11k_write_twt_pause_dialog(struct file *file,
+					     const char __user *ubuf,
+					     size_t count, loff_t *ppos)
+{
+	struct ath11k_vif *arvif = file->private_data;
+	struct wmi_twt_pause_dialog_params params = { 0 };
+	u8 buf[64] = {0};
+	int ret;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, ubuf, count);
+	if (ret < 0)
+		return ret;
+
+	buf[ret] = '\0';
+	ret = sscanf(buf, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx %u",
+		     &params.peer_macaddr[0],
+		     &params.peer_macaddr[1],
+		     &params.peer_macaddr[2],
+		     &params.peer_macaddr[3],
+		     &params.peer_macaddr[4],
+		     &params.peer_macaddr[5],
+		     &params.dialog_id);
+	if (ret != 7)
+		return -EINVAL;
+
+	params.vdev_id = arvif->vdev_id;
+
+	ret = ath11k_wmi_send_twt_pause_dialog_cmd(arvif->ar, &params);
+
+	return ret ? ret : count;
+}
+
+static ssize_t ath11k_write_twt_resume_dialog(struct file *file,
+					      const char __user *ubuf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath11k_vif *arvif = file->private_data;
+	struct wmi_twt_resume_dialog_params params = { 0 };
+	u8 buf[64] = {0};
+	int ret;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, ubuf, count);
+	if (ret < 0)
+		return ret;
+
+	buf[ret] = '\0';
+	ret = sscanf(buf, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx %u %u %u",
+		     &params.peer_macaddr[0],
+		     &params.peer_macaddr[1],
+		     &params.peer_macaddr[2],
+		     &params.peer_macaddr[3],
+		     &params.peer_macaddr[4],
+		     &params.peer_macaddr[5],
+		     &params.dialog_id,
+		     &params.sp_offset_us,
+		     &params.next_twt_size);
+	if (ret != 9)
+		return -EINVAL;
+
+	params.vdev_id = arvif->vdev_id;
+
+	ret = ath11k_wmi_send_twt_resume_dialog_cmd(arvif->ar, &params);
+
+	return ret ? ret : count;
+}
+
+static const struct file_operations ath11k_fops_twt_add_dialog = {
+	.write = ath11k_write_twt_add_dialog,
+	.open = simple_open
+};
+
+static const struct file_operations ath11k_fops_twt_del_dialog = {
+	.write = ath11k_write_twt_del_dialog,
+	.open = simple_open
+};
+
+static const struct file_operations ath11k_fops_twt_pause_dialog = {
+	.write = ath11k_write_twt_pause_dialog,
+	.open = simple_open
+};
+
+static const struct file_operations ath11k_fops_twt_resume_dialog = {
+	.write = ath11k_write_twt_resume_dialog,
+	.open = simple_open
+};
+
+void ath11k_debugfs_twt(struct ath11k_vif *arvif, bool enable)
+{
+	if (!enable && arvif->debugfs_twt) {
+		debugfs_remove_recursive(arvif->debugfs_twt);
+		arvif->debugfs_twt = NULL;
+		return;
+	}
+
+	if (arvif->debugfs_twt)
+		return;
+
+	arvif->debugfs_twt = debugfs_create_dir("twt", arvif->vif->debugfs_dir);
+	if (IS_ERR_OR_NULL(arvif->debugfs_twt)) {
+		ath11k_warn(arvif->ar->ab,
+			    "failed to create twt debugfs: %p\n",
+			    arvif->debugfs_twt);
+		arvif->debugfs_twt = NULL;
+		return;
+	}
+
+	debugfs_create_file("add_dialog", 0200,
+			    arvif->debugfs_twt, arvif,
+			    &ath11k_fops_twt_add_dialog);
+
+	debugfs_create_file("del_dialog", 0200,
+			    arvif->debugfs_twt, arvif,
+			    &ath11k_fops_twt_del_dialog);
+
+	debugfs_create_file("pause_dialog", 0200,
+			    arvif->debugfs_twt, arvif,
+			    &ath11k_fops_twt_pause_dialog);
+
+	debugfs_create_file("resume_dialog", 0200,
+			    arvif->debugfs_twt, arvif,
+			    &ath11k_fops_twt_resume_dialog);
+}
+#endif
diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index 659a275e2eb3..91e40bfdb5e7 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -64,4 +64,12 @@ do {								\
 		__ath11k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__);	\
 } while (0)
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+void ath11k_debugfs_twt(struct ath11k_vif *arvif, bool enable);
+#else
+static inline void ath11k_debugfs_twt(struct ath11k_vif *arvif, bool enable)
+{
+}
+#endif
+
 #endif /* _ATH11K_DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1608f64ea95..564cdf7a5331 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2111,6 +2111,8 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 			ath11k_wmi_send_twt_enable_cmd(ar, ar->pdev->pdev_id);
 		else
 			ath11k_wmi_send_twt_disable_cmd(ar, ar->pdev->pdev_id);
+		if (vif->type == NL80211_IFTYPE_AP)
+			ath11k_debugfs_twt(arvif, info->twt_requester);
 	}
 
 	if (changed & BSS_CHANGED_HE_OBSS_PD)
@@ -4735,6 +4737,9 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	/* TODO: recal traffic pause state based on the available vdevs */
 
+	debugfs_remove_recursive(arvif->debugfs_twt);
+	arvif->debugfs_twt = NULL;
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
2.25.0

