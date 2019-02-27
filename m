Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FCAC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C3A2147C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I8vL4Z84";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I8vL4Z84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfB0LW5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:22:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LW5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 06:22:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 95F2C60DAD; Wed, 27 Feb 2019 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266575;
        bh=pDTl6BWuI2MvOL7E/5d/5JVXhf+vE7YSrsFeVJD0QKg=;
        h=From:To:Cc:Subject:Date:From;
        b=I8vL4Z84Hc2kBai9i9l9HMWp2gZWhYc4glJDhqlSEwDq+1t2Bd42e8NG3iWw3JsWo
         tv33ybXsYEUOZ8MWO50tsoooLRUhG+8u9iAbucqQquWw/kM8/BHS5GPhxrudLdt+a8
         q9tUzqUUfGHjiq8yaM1JMPlzB8mv1FDaJa6KAZm8=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mkenna@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 579CA60909;
        Wed, 27 Feb 2019 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266575;
        bh=pDTl6BWuI2MvOL7E/5d/5JVXhf+vE7YSrsFeVJD0QKg=;
        h=From:To:Cc:Subject:Date:From;
        b=I8vL4Z84Hc2kBai9i9l9HMWp2gZWhYc4glJDhqlSEwDq+1t2Bd42e8NG3iWw3JsWo
         tv33ybXsYEUOZ8MWO50tsoooLRUhG+8u9iAbucqQquWw/kM8/BHS5GPhxrudLdt+a8
         q9tUzqUUfGHjiq8yaM1JMPlzB8mv1FDaJa6KAZm8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 579CA60909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mkenna@codeaurora.org
From:   Maharaja Kennadyrajan <mkenna@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, vikpatel@codeaurora.org,
        arnagara@codeaurora.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Extended the HTT stats support to retrieve Mu-MIMO related stats
Date:   Wed, 27 Feb 2019 16:54:41 +0530
Message-Id: <1551266682-32073-1-git-send-email-mkenna@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extended the bit mask value of the HTT stats to get the Mu-MIMO
related stats via tracing.

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c  | 4 ++--
 drivers/net/wireless/ath/ath10k/htt.h    | 3 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1b8903280d42..ca1af0e1623c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -922,8 +922,8 @@ static ssize_t ath10k_write_htt_stats_mask(struct file *file,
 	if (ret)
 		return ret;
 
-	/* max 8 bit masks (for now) */
-	if (mask > 0xff)
+	/* max 17 bit masks (for now) */
+	if (mask > HTT_STATS_BIT_MASK)
 		return -E2BIG;
 
 	mutex_lock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index fef716aa8f3a..8ff432bb2e86 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -315,6 +315,7 @@ struct htt_stats_req {
 } __packed;
 
 #define HTT_STATS_REQ_CFG_STAT_TYPE_INVALID 0xff
+#define HTT_STATS_BIT_MASK GENMASK(16, 0)
 
 /*
  * htt_oob_sync_req - request out-of-band sync
@@ -2109,7 +2110,7 @@ void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
-int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u64 cookie);
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d8e9cc0bb772..7e5f0eba043b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -580,7 +580,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	return 0;
 }
 
-int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u32 mask, u64 cookie)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_stats_req *req;
@@ -603,11 +603,11 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 
 	memset(req, 0, sizeof(*req));
 
-	/* currently we support only max 8 bit masks so no need to worry
+	/* currently we support only max 24 bit masks so no need to worry
 	 * about endian support
 	 */
-	req->upload_types[0] = mask;
-	req->reset_types[0] = mask;
+	memcpy(req->upload_types, &mask, 3);
+	memcpy(req->reset_types, &mask, 3);
 	req->stat_type = HTT_STATS_REQ_CFG_STAT_TYPE_INVALID;
 	req->cookie_lsb = cpu_to_le32(cookie & 0xffffffff);
 	req->cookie_msb = cpu_to_le32((cookie & 0xffffffff00000000ULL) >> 32);
-- 
2.20.1

