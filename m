Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5B5C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D3E20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfBVOVg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:36 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:22290 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbfBVOVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:33 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017378"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:29 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285584"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:28 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 11/21] wil6210: do not set BIT_USER_SUPPORT_T_POWER_ON_0 in Talyn-MB
Date:   Fri, 22 Feb 2019 16:21:09 +0200
Message-Id: <1550845279-16103-12-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In Sparrow, FW might sleep long time due to T_Power_On calculation
in slow clock, so T_Power_On was set to zero to shorten the L1SS
wake-up time.
In Talyn-MB the L1SS wake-up procedure is handled by the PMU (HW),
hence T_Power_On calculation is accurate and should not be forced
to zero.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6df19a2..f2432ad 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1603,7 +1603,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	if (wil->hw_version == HW_VER_UNKNOWN)
 		return -ENODEV;
 
-	if (test_bit(WIL_PLATFORM_CAPA_T_PWR_ON_0, wil->platform_capa)) {
+	if (test_bit(WIL_PLATFORM_CAPA_T_PWR_ON_0, wil->platform_capa) &&
+	    wil->hw_version < HW_VER_TALYN_MB) {
 		wil_dbg_misc(wil, "Notify FW to set T_POWER_ON=0\n");
 		wil_s(wil, RGF_USER_USAGE_8, BIT_USER_SUPPORT_T_POWER_ON_0);
 	}
-- 
1.9.1

