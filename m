Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91699C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F4D12147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y0LrYLA6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I7N3ab1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfBZJ2T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:28:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZJ2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:28:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3DDE660E7A; Tue, 26 Feb 2019 09:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173298;
        bh=VQBFLR4B6N44fYtcmoGaYtecKS2NTMTCfmSqBXoZLVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0LrYLA6ozaal+Y/N74ZR2/6QTbTZXlemvgcNSCeJXNeZYYdOCyHqBuHUKfDCsPUC
         ng5A9mLEKn8X9tXUmoo844vT7hclhimebUyCDlgcQpDbpT2/dpLwJQ+zAraI4txewl
         SoBDf4sKSv+u51wEEUOFw2mrH8KOBnM5t4ijH+dw=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FA8360767;
        Tue, 26 Feb 2019 09:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173295;
        bh=VQBFLR4B6N44fYtcmoGaYtecKS2NTMTCfmSqBXoZLVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7N3ab1cWMp9pmdNq6Sc8mFfLYvezeDXicNaquvPzPYew661SDREvqiAFIg+3WGXA
         osser4DiBeQkkgotuxSEuqSRVzGezQ/DSiRYUn9hTjOHDIOdZw6pnIkv8lgaBA+QVK
         JQeWxMTPiYBmnVP7JlOnQoALFgR2H0ELOCgI4PpU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FA8360767
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2 2/4] ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
Date:   Tue, 26 Feb 2019 14:57:56 +0530
Message-Id: <1551173278-20926-3-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
References: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, the bandwidth is updated wrongly in BW table in tx_stats
debugfs per sta as there is difference in number of bandwidth type
in mac80211 and driver stats table. This leads to bandwidth getting
updated at wrong index in bandwidth table in tx_stats.

Fix this index mismatch between mac80211 and driver stats table (BW table)
by making the number of bandwidth type in driver compatible with mac80211.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 7 ++++---
 drivers/net/wireless/ath/ath10k/wmi.h         | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 8331d8b..c704ae3 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -685,11 +685,12 @@ static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
 						 "  %llu ", stats->ht[j][i]);
 			len += scnprintf(buf + len, size - len, "\n");
 			len += scnprintf(buf + len, size - len,
-					" BW %s (20,40,80,160 MHz)\n", str[j]);
+					" BW %s (20,5,10,40,80,160 MHz)\n", str[j]);
 			len += scnprintf(buf + len, size - len,
-					 "  %llu %llu %llu %llu\n",
+					 "  %llu %llu %llu %llu %llu %llu\n",
 					 stats->bw[j][0], stats->bw[j][1],
-					 stats->bw[j][2], stats->bw[j][3]);
+					 stats->bw[j][2], stats->bw[j][3],
+					 stats->bw[j][4], stats->bw[j][5]);
 			len += scnprintf(buf + len, size - len,
 					 " NSS %s (1x1,2x2,3x3,4x4)\n", str[j]);
 			len += scnprintf(buf + len, size - len,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d9b646f..d915942 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5045,7 +5045,7 @@ enum wmi_rate_preamble {
 #define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
-#define ATH10K_BW_NUM		4
+#define ATH10K_BW_NUM		6
 #define ATH10K_NSS_NUM		4
 #define ATH10K_LEGACY_NUM	12
 #define ATH10K_GI_NUM		2
-- 
1.9.1

