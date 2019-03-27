Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0671C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04C32075C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714963;
	bh=DZlINmG1lM12VF8DFoS3JMnFbQRIx5SlE38ekQv96nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0SLZPH1Wz9M3FwCMWkjaJl5H8FNJ8P6Y8JsD2dSCchyG+GzSmt4s3b8+ZbVXmM+fZ
	 /XGpUUuKRWw/onpTEc754Y227QQ++/VDyF2ceAGEXzMVfyLJacbsMgyDTnP5Pw+Z8W
	 tS9He6GMjZne/8uJUGUTfPsXiyot5Pc0JQA/sIoU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732966AbfC0SDz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbfC0SDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E862082F;
        Wed, 27 Mar 2019 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709833;
        bh=DZlINmG1lM12VF8DFoS3JMnFbQRIx5SlE38ekQv96nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APmf+JDt47gEzqz/cA6NHn10RCuTwAI5sZq4k/nfTgxtwjfCqYfB0Tscvnhn2r15g
         H51srthQCGc1GbucWnsVyFS+nQFQ5S/jbaIraWinfWsCTPI1FLzlkua298y7VlPKyt
         TMw077wJk+CNHv/N77DMsQpjAmtem3GICBFW02oU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 065/262] ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
Date:   Wed, 27 Mar 2019 13:58:40 -0400
Message-Id: <20190327180158.10245-65-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

[ Upstream commit ef9051c72ab7bc664e8047c55ac74bdb1c7fa3ee ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 7 ++++---
 drivers/net/wireless/ath/ath10k/wmi.h         | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 4778a455d81a..068f1a7e07d3 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -696,11 +696,12 @@ static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
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
index 2034ccc7cc72..1d5d0209ebeb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5003,7 +5003,7 @@ enum wmi_rate_preamble {
 #define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
-#define ATH10K_BW_NUM		4
+#define ATH10K_BW_NUM		6
 #define ATH10K_NSS_NUM		4
 #define ATH10K_LEGACY_NUM	12
 #define ATH10K_GI_NUM		2
-- 
2.19.1

