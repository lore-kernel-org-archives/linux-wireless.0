Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B47BECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F2D320685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F2D320685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbeJaR4B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:01 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727381AbeJaR4A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:56:00 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418133"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:35 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147933"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:34 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 13/16] wil6210: ignore HALP ICR if already handled
Date:   Wed, 31 Oct 2018 10:52:21 +0200
Message-Id: <1540975944-30576-14-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
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
Add an atomic flag to indicate if HALP ICR should be handled.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 10 +++++++---
 drivers/net/wireless/ath/wil6210/main.c      |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5d287a8..a58fccb 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -575,10 +575,14 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	}
 
 	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
-		wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-		wil6210_mask_halp(wil);
 		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
-		complete(&wil->halp.comp);
+		if (atomic_read(&wil->halp.handle_icr)) {
+			/* no need to handle HALP ICRs until next vote */
+			atomic_set(&wil->halp.handle_icr, 0);
+			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
+			wil6210_mask_halp(wil);
+			complete(&wil->halp.comp);
+		}
 	}
 
 	wil->isr_misc = isr;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 5303867..5c89c01 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1922,6 +1922,8 @@ void wil_halp_vote(struct wil6210_priv *wil)
 
 	if (++wil->halp.ref_cnt == 1) {
 		reinit_completion(&wil->halp.comp);
+		/* mark to IRQ context to handle HALP ICR */
+		atomic_set(&wil->halp.handle_icr, 1);
 		wil6210_set_halp(wil);
 		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
 		if (!rc) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0f3be3ff..1897d8c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -791,6 +791,7 @@ struct wil_halp {
 	struct mutex		lock; /* protect halp ref_cnt */
 	unsigned int		ref_cnt;
 	struct completion	comp;
+	atomic_t		handle_icr;
 };
 
 struct wil_blob_wrapper {
-- 
1.9.1

