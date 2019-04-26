Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF453C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91830205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfDZPt4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:49:56 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21641 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbfDZPtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:55 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2019 11:49:53 EDT
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367522"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:44 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889771"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:44 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 7/9] wil6210: fix missed MISC mbox interrupt
Date:   Fri, 26 Apr 2019 18:43:35 +0300
Message-Id: <1556293417-27097-8-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When MISC interrupt is triggered due to HALP bit, in parallel
to mbox events handling by the MISC threaded IRQ, new mbox
interrupt can be missed in the following scenario:
1. MISC ICR is read in the IRQ handler
2. Threaded IRQ is completed and all MISC interrupts are unmasked
3. mbox interrupt is set by FW
4. HALP is masked
The mbox interrupt in step 3 can be missed due to constant high level
of ICM.
Masking all MISC IRQs instead of masking only HALP bit in step 4
will guarantee that ICM will drop to 0 and interrupt will be triggered
once MISC interrupts will be unmasked.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index d161dc9..b00a13d 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -595,7 +595,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 			/* no need to handle HALP ICRs until next vote */
 			wil->halp.handle_icr = false;
 			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-			wil6210_mask_halp(wil);
+			wil6210_mask_irq_misc(wil, true);
 			complete(&wil->halp.comp);
 		}
 	}
-- 
1.9.1

