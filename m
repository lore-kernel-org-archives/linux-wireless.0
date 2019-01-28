Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8169AC282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE5920880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfA1Pmu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:50 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:19718 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbfA1Pmt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:49 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2019 10:42:40 EST
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881357"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:33 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037507"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:33 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 09/12] wil6210: ignore HALP ICR if already handled
Date:   Mon, 28 Jan 2019 17:36:23 +0200
Message-Id: <1548689786-23288-10-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

HALP ICR is set as long as the FW should stay awake.
To prevent its multiple handling the driver masks this IRQ bit.
However, if there is a different MISC ICR before the driver clears
this bit, there is a risk of race condition between HALP mask and
unmask. This race leads to HALP timeout, in case it is mistakenly
masked.
Add a flag to indicate if HALP ICR should be handled.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 12 ++++++++----
 drivers/net/wireless/ath/wil6210/main.c      |  3 +++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5d287a8..3f5bd17 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -575,10 +575,14 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	}
 
 	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
-		wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-		wil6210_mask_halp(wil);
 		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
-		complete(&wil->halp.comp);
+		if (wil->halp.handle_icr) {
+			/* no need to handle HALP ICRs until next vote */
+			wil->halp.handle_icr = false;
+			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
+			wil6210_mask_halp(wil);
+			complete(&wil->halp.comp);
+		}
 	}
 
 	wil->isr_misc = isr;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1c2823b..bd933a0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1899,11 +1899,14 @@ void wil_halp_vote(struct wil6210_priv *wil)
 
 	if (++wil->halp.ref_cnt == 1) {
 		reinit_completion(&wil->halp.comp);
+		/* mark to IRQ context to handle HALP ICR */
+		wil->halp.handle_icr = true;
 		wil6210_set_halp(wil);
 		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
 		if (!rc) {
 			wil_err(wil, "HALP vote timed out\n");
 			/* Mask HALP as done in case the interrupt is raised */
+			wil->halp.handle_icr = false;
 			wil6210_mask_halp(wil);
 		} else {
 			wil_dbg_irq(wil,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index cc46873..de97c4e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -781,6 +781,7 @@ struct wil_halp {
 	struct mutex		lock; /* protect halp ref_cnt */
 	unsigned int		ref_cnt;
 	struct completion	comp;
+	u8			handle_icr;
 };
 
 struct wil_blob_wrapper {
-- 
1.9.1

