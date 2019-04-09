Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8488BC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 04:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FCCE2083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 04:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfDIEVC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 00:21:02 -0400
Received: from www.osadl.org ([62.245.132.105]:36568 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfDIEVC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 00:21:02 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2019 00:21:01 EDT
Received: from localhost.localdomain (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x393mTx8012040;
        Tue, 9 Apr 2019 05:48:29 +0200
From:   Nicholas Mc Guire <hofrat@opentech.at>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@opentech.at>
Subject: [PATCH 1/2] NFC: st95hf: use msleep for long delay
Date:   Tue,  9 Apr 2019 05:48:18 +0200
Message-Id: <1554781699-42604-1-git-send-email-hofrat@opentech.at>
X-Mailer: git-send-email 2.1.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

usleep_ranges is backed by hrtimers - for a delay of 50ms
notably in a loop using a hrtimer is of no benefit and
msleep() should be fine  here (see
Documentation/timers/timers-howto.txt).

Signed-off-by: Nicholas Mc Guire <hofrat@opentech.at>
---

Problem located with an experimental coccinelle script

Patch was compile tested with: x86_64_defconfig + SPI=y,
NFC=y, NFC_DIGITAL=y, NFC_ST95HF=m

Patch is against 5.1-rc3 (localversion-next is -next-20190408)

 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index a50a95c..34bf1d7 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -535,7 +535,7 @@ static int st95hf_por_sequence(struct st95hf_context *st95context)
 			st95hf_send_spi_reset_sequence(st95context);
 
 		/* delay of 50 milisecond */
-		usleep_range(50000, 51000);
+		msleep(50);
 	} while (nth_attempt++ < 3);
 
 	return -ETIMEDOUT;
-- 
2.1.4

