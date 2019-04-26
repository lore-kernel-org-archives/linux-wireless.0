Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B92C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923F9205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfDZPuD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:50:03 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21643 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbfDZPuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:50:01 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367518"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:42 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889766"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:41 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 3/9] wil6210: add printout of platform capabilities
Date:   Fri, 26 Apr 2019 18:43:31 +0300
Message-Id: <1556293417-27097-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

Add logging of the platform capabilities after retrieving it from the
platform driver.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 3b82d6c..4e2d922 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -142,6 +142,8 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 		       min(sizeof(wil->platform_capa), sizeof(platform_capa)));
 	}
 
+	wil_info(wil, "platform_capa 0x%lx\n", *wil->platform_capa);
+
 	/* extract FW capabilities from file without loading the FW */
 	wil_request_firmware(wil, wil->wil_fw_name, false);
 	wil_refresh_fw_capabilities(wil);
-- 
1.9.1

