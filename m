Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB23C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 04:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFA52083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 04:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfDIEVE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 00:21:04 -0400
Received: from www.osadl.org ([62.245.132.105]:36568 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfDIEVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 00:21:03 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2019 00:21:01 EDT
Received: from localhost.localdomain (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x393mTx9012040;
        Tue, 9 Apr 2019 05:48:34 +0200
From:   Nicholas Mc Guire <hofrat@opentech.at>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@opentech.at>
Subject: [PATCH 2/2] NFC: st95hf: fix timing factor error
Date:   Tue,  9 Apr 2019 05:48:19 +0200
Message-Id: <1554781699-42604-2-git-send-email-hofrat@opentech.at>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1554781699-42604-1-git-send-email-hofrat@opentech.at>
References: <1554781699-42604-1-git-send-email-hofrat@opentech.at>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The comment suggests that per ISO standard 5-6ms are required
but the code is 50-60ms delay - look like a simple typo - so
set the delay to 5000 to 6000.

Signed-off-by: Nicholas Mc Guire <hofrat@opentech.at>
Fixes: cab47333f0f7 ("NFC: Add STMicroelectronics ST95HF driver")
---

Problem located with an experimental coccinelle script

Note that as I do not have the standard - it could of course
also be a typo in the comment - in which case it should
then probably be using msleep(60) not usleep_ranges(). 

Patch was compile tested with: x86_64_defconfig + SPI=y,
NFC=y, NFC_DIGITAL=y, NFC_ST95HF=m

Patch is against 5.1-rc3 (localversion-next is -next-20190408)

 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 34bf1d7..89e6160 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -430,7 +430,7 @@ static int st95hf_select_protocol(struct st95hf_context *stcontext, int type)
 		 * delay of 5-6 ms is required after select protocol
 		 * command in case of ISO14443 Type B
 		 */
-		usleep_range(50000, 60000);
+		usleep_range(5000, 6000);
 
 		/* secondary config. for 14443Type 4B after protocol select */
 		result = secondary_configuration_type4b(stcontext);
-- 
2.1.4

