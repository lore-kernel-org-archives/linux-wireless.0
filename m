Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADB9C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0A020700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfBVOVk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:40 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:22290 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbfBVOVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:39 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017388"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:34 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285594"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:34 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 21/21] wil6210: print error in FW and board files load failures
Date:   Fri, 22 Feb 2019 16:21:19 +0200
Message-Id: <1550845279-16103-22-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add an error print-out in case FW and board files load fails,
as such an error is not printed on all failures and user may
not understand why the interface up operations didn't succeed.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/fw_inc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 388b3d4..3ec0f2f 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2014-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -647,6 +647,8 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 
 out:
 	release_firmware(fw);
+	if (rc)
+		wil_err_fw(wil, "Loading <%s> failed, rc %d\n", name, rc);
 	return rc;
 }
 
@@ -741,6 +743,8 @@ int wil_request_board(struct wil6210_priv *wil, const char *name)
 
 out:
 	release_firmware(brd);
+	if (rc)
+		wil_err_fw(wil, "Loading <%s> failed, rc %d\n", name, rc);
 	return rc;
 }
 
-- 
1.9.1

