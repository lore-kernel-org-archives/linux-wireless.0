Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78656C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F2A20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfBVOVj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:39 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:54040 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727113AbfBVOVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:39 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017386"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:33 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285592"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:33 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 19/21] wil6210: add support for ucode tracing
Date:   Fri, 22 Feb 2019 16:21:17 +0200
Message-Id: <1550845279-16103-20-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

The driver needs to expose RGF_USER_USAGE_2 register that contains
the offset of the ucode logging table.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 817762f..78320ec 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2392,6 +2392,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	{"RGF_MAC_MTRL_COUNTER_0", 0444, HOSTADDR(RGF_MAC_MTRL_COUNTER_0),
 		doff_io32},
 	{"RGF_USER_USAGE_1", 0444, HOSTADDR(RGF_USER_USAGE_1), doff_io32},
+	{"RGF_USER_USAGE_2", 0444, HOSTADDR(RGF_USER_USAGE_2), doff_io32},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9d7e02e..f508d52 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -185,6 +185,7 @@ struct RGF_ICR {
 
 /* registers - FW addresses */
 #define RGF_USER_USAGE_1		(0x880004)
+#define RGF_USER_USAGE_2		(0x880008)
 #define RGF_USER_USAGE_6		(0x880018)
 	#define BIT_USER_OOB_MODE		BIT(31)
 	#define BIT_USER_OOB_R2_MODE		BIT(30)
-- 
1.9.1

