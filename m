Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4498DC0044C
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C4F920840
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C4F920840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbeJaRz5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:57 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23737 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbeJaRz4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:56 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418122"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:28 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147922"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:28 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 02/16] wil6210: fix reset flow for Talyn-mb
Date:   Wed, 31 Oct 2018 10:52:10 +0200
Message-Id: <1540975944-30576-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

With current reset flow, Talyn sometimes get stuck causing PCIe
enumeration to fail. Fix this by removing some reset flow operations
that are not relevant for Talyn.
Setting bit 15 in RGF_HP_CTRL is WBE specific and is not in use for
all wil6210 devices.
For Sparrow, BIT_HPAL_PERST_FROM_PAD and BIT_CAR_PERST_RST were set
as a WA an HW issue.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 398900a..c54b008 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -998,10 +998,13 @@ static int wil_target_reset(struct wil6210_priv *wil, int no_flash)
 
 	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->hw_name);
 
-	/* Clear MAC link up */
-	wil_s(wil, RGF_HP_CTRL, BIT(15));
-	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_HPAL_PERST_FROM_PAD);
-	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+	if (wil->hw_version < HW_VER_TALYN) {
+		/* Clear MAC link up */
+		wil_s(wil, RGF_HP_CTRL, BIT(15));
+		wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0,
+		      BIT_HPAL_PERST_FROM_PAD);
+		wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+	}
 
 	wil_halt_cpu(wil);
 
-- 
1.9.1

