Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64981C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EFA920700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfBVOVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:38 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbfBVOVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:38 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017385"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:33 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285591"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:32 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 18/21] wil6210: prevent access to RGF_CAF_ICR in Talyn
Date:   Fri, 22 Feb 2019 16:21:16 +0200
Message-Id: <1550845279-16103-19-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Due to access control RGF_CAF_ICR cannot be accessed by host.
Such an access will cause device AHB logger to halt and it will not
capture future AHB fault if there is any.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b69d9a2..9b9c9ec 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1532,11 +1532,6 @@ static void wil_pre_fw_config(struct wil6210_priv *wil)
 	if (wil->hw_version < HW_VER_TALYN_MB) {
 		wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
 		wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
-	} else {
-		wil_s(wil,
-		      RGF_CAF_ICR_TALYN_MB + offsetof(struct RGF_ICR, ICR), 0);
-		wil_w(wil, RGF_CAF_ICR_TALYN_MB +
-		      offsetof(struct RGF_ICR, IMV), ~0);
 	}
 	/* clear PAL_UNIT_ICR (potential D0->D3 leftover)
 	 * In Talyn-MB host cannot access this register due to
-- 
1.9.1

