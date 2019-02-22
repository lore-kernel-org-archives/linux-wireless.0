Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAD1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0807620818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="muPnrCfZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qb0dtp8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfBVHU6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:20:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58362 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfBVHU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:20:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 02A71607EF; Fri, 22 Feb 2019 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820057;
        bh=pt1WkFPlBl2dAXeIc31nXbM9kqPjTzEPqko1Zunb3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muPnrCfZlagni/k2gA3hQ29f7AQoVHDmu/acEp7HUxX2RiLTJbNHz6x0QqWgQlu0t
         h47qYQiV4KThokHOnXGYiefZspsFPl72jypeJLtDA6h+z0RGbZvM7wrrn2uQPYLQYy
         NKsetdSCiSxak3TizK6HoxdkLfEtmsMZfcYEbKHM=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1DE80609C1;
        Fri, 22 Feb 2019 07:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820055;
        bh=pt1WkFPlBl2dAXeIc31nXbM9kqPjTzEPqko1Zunb3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qb0dtp8+wVartUjO/kdcN0+6cmZXcpqwuFWLOxltAfKhqVWmxJ4/3yTMAN4wKufM7
         zhTsGq80kH01SYMzaKQQhJSCebM0rk3pP13oJWh8KJqAIcSomGniDH3OGiN21CH46Y
         mE3zSF2KcqRKJXyNhw0IssWDh8nqFZWK24zbVmdM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1DE80609C1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 2/4] ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
Date:   Fri, 22 Feb 2019 12:50:32 +0530
Message-Id: <1550820034-18603-3-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
References: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/wmi.h         | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 4778a45..645ba9c 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -696,11 +696,13 @@ static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
 						 "  %llu ", stats->ht[j][i]);
 			len += scnprintf(buf + len, size - len, "\n");
 			len += scnprintf(buf + len, size - len,
-					" BW %s (20,40,80,160 MHz)\n", str[j]);
+					" BW %s (20,5,10,40,80,160 MHz)\n",
+					str[j]);
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
index 0e27878..7053db4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5056,7 +5056,7 @@ enum wmi_rate_preamble {
 #define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
-#define ATH10K_BW_NUM		4
+#define ATH10K_BW_NUM		6
 #define ATH10K_NSS_NUM		4
 #define ATH10K_LEGACY_NUM	12
 #define ATH10K_GI_NUM		2
-- 
1.9.1

