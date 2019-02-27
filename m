Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E465C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D05592147C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:23:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kh+RFoNc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kh+RFoNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfB0LXK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:23:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LXK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 06:23:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8E54E60E59; Wed, 27 Feb 2019 11:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266588;
        bh=c+bhn/ttlntgoPtmKspAuKKp/siRxFgP+kOSsYxuqrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh+RFoNcPISkV2dE1VmtXKpUds4qKv9Q+PjKpygWnB//HjbQt0286fuxU81JaOQbu
         Je9nXam35EyJTT/o/2F782YMcAmYVX/tMXplIfJJhzMK11J1z/oSgqZQ388qw1hgkv
         j/nuwR+c+o0pQ8h/kSOg/qSnrEV1Qr5fyTMgVq78=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mkenna@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4CE1E60909;
        Wed, 27 Feb 2019 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266588;
        bh=c+bhn/ttlntgoPtmKspAuKKp/siRxFgP+kOSsYxuqrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh+RFoNcPISkV2dE1VmtXKpUds4qKv9Q+PjKpygWnB//HjbQt0286fuxU81JaOQbu
         Je9nXam35EyJTT/o/2F782YMcAmYVX/tMXplIfJJhzMK11J1z/oSgqZQ388qw1hgkv
         j/nuwR+c+o0pQ8h/kSOg/qSnrEV1Qr5fyTMgVq78=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4CE1E60909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mkenna@codeaurora.org
From:   Maharaja Kennadyrajan <mkenna@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, vikpatel@codeaurora.org,
        arnagara@codeaurora.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Added support to reset HTT stats in debugfs
Date:   Wed, 27 Feb 2019 16:54:42 +0530
Message-Id: <1551266682-32073-2-git-send-email-mkenna@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1551266682-32073-1-git-send-email-mkenna@codeaurora.org>
References: <1551266682-32073-1-git-send-email-mkenna@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reset HTT stats helps to get the aggregated HTT stats via
tracing and also we can clear the accumulated HTT stats with
this debugfs file.

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/debug.c  | 43 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt.h    |  3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  5 +--
 4 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 27ec5557de88..317a41c2a9b1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -614,6 +614,7 @@ struct ath10k_debug {
 	bool fw_stats_done;
 
 	unsigned long htt_stats_mask;
+	unsigned long reset_htt_stats;
 	struct delayed_work htt_stats_dwork;
 	struct ath10k_dfs_stats dfs_stats;
 	struct ath_dfs_pool_stats dfs_pool_stats;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ca1af0e1623c..daf30eaa53c5 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -873,7 +873,7 @@ static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 	cookie = get_jiffies_64();
 
 	ret = ath10k_htt_h2t_stats_req(&ar->htt, ar->debug.htt_stats_mask,
-				       cookie);
+				       ar->debug.reset_htt_stats, cookie);
 	if (ret) {
 		ath10k_warn(ar, "failed to send htt stats request: %d\n", ret);
 		return ret;
@@ -2466,6 +2466,44 @@ static const struct file_operations fops_ps_state_enable = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_write_reset_htt_stats(struct file *file,
+					    const char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long reset;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &reset);
+	if (ret)
+		return ret;
+
+	if (reset == 0 || reset > 0x1ffff)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.reset_htt_stats = reset;
+
+	ret = ath10k_debug_htt_stats_req(ar);
+	if (ret)
+		goto out;
+
+	ar->debug.reset_htt_stats = 0;
+	ret = count;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_reset_htt_stats = {
+	.write = ath10k_write_reset_htt_stats,
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.cal_data = vzalloc(ATH10K_DEBUG_CAL_DATA_LEN);
@@ -2606,6 +2644,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("ps_state_enable", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_ps_state_enable);
 
+	debugfs_create_file("reset_htt_stats", 0200, ar->debug.debugfs_phy, ar,
+			    &fops_reset_htt_stats);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8ff432bb2e86..b909f2f079c7 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -2110,7 +2110,8 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
-int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u64 cookie);
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u32 reset_mask,
+			     u64 cookie);
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7e5f0eba043b..524bd8b44580 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -580,7 +580,8 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	return 0;
 }
 
-int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u64 cookie)
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u32 reset_mask,
+			     u64 cookie)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_stats_req *req;
@@ -607,7 +608,7 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u64 cookie)
 	 * about endian support
 	 */
 	memcpy(req->upload_types, &mask, 3);
-	memcpy(req->reset_types, &mask, 3);
+	memcpy(req->reset_types, &reset_mask, 3);
 	req->stat_type = HTT_STATS_REQ_CFG_STAT_TYPE_INVALID;
 	req->cookie_lsb = cpu_to_le32(cookie & 0xffffffff);
 	req->cookie_msb = cpu_to_le32((cookie & 0xffffffff00000000ULL) >> 32);
-- 
2.20.1

