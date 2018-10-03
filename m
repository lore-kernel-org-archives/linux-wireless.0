Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB185C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 12:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7755020835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 12:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7755020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeJCTME (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 15:12:04 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.154]:23917 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726670AbeJCTME (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 15:12:04 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2018 15:12:03 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 2FDE34012422D
        for <linux-wireless@vger.kernel.org>; Wed,  3 Oct 2018 07:01:05 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7fpxgO0OWRPoj7fpxghQxj; Wed, 03 Oct 2018 07:01:05 -0500
X-Authority-Reason: nr=8
Received: from 174.206.93.92.rev.sfr.net ([92.93.206.174]:36048 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1g7fpw-001nFy-GP; Wed, 03 Oct 2018 07:01:04 -0500
Date:   Wed, 3 Oct 2018 14:01:02 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Buesch <m@bues.ch>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ssb: chipcommon: fix fall-through annotation
Message-ID: <20181003120102.GA22824@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 92.93.206.174
X-Source-L: No
X-Exim-ID: 1g7fpw-001nFy-GP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 174.206.93.92.rev.sfr.net (embeddedor) [92.93.206.174]:36048
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace "Fallthough" with a proper "fall through" annotation.

This fix is part of the ongoing efforts to enabling
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/ssb/driver_chipcommon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 99a4656..3861cb6 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -425,7 +425,7 @@ void ssb_chipco_get_clockcontrol(struct ssb_chipcommon *cc,
 			*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_M2);
 			break;
 		}
-		/* Fallthough */
+		/* Fall through */
 	default:
 		*m = chipco_read32(cc, SSB_CHIPCO_CLOCK_SB);
 	}
-- 
2.7.4

