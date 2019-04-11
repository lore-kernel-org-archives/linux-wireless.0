Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE238C10F11
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 03:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FD9217D9
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 03:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfDKDbt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 23:31:49 -0400
Received: from www.osadl.org ([62.245.132.105]:35486 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKDbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 23:31:48 -0400
Received: from localhost.localdomain (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x3B3VOEJ016044;
        Thu, 11 Apr 2019 05:31:24 +0200
From:   Nicholas Mc Guire <hofrat@opentech.at>
To:     Adham Abozaeid <adham.abozaeid@microchip.com>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH V2] staging: wilc1000: give usleep_range a range
Date:   Thu, 11 Apr 2019 05:31:21 +0200
Message-Id: <1554953481-51340-1-git-send-email-hofrat@opentech.at>
X-Mailer: git-send-email 2.1.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

usleep_range() is called in non-atomic context so there is little point
in setting min==max as the jitter of hrtimer is determined by interruptions
anyway. usleep_range can only perform the intended coalescence if some
room for placing the hrtimer is provided. Given the range of milliseconds
the delay will be 2+ anyway - so make it 2-2.5 ms which gives hrtimers
space to optimize without negatively impacting performance.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem located with an experimental coccinelle script
./drivers/staging/wilc1000/wilc_wlan.c:411:4-16: WARNING: inefficient usleep_range with range 0 (min==max)
./drivers/staging/wilc1000/wilc_wlan.c:426:4-16: WARNING: inefficient usleep_range with range 0 (min==max)

V2: Based on feedback from Adham Abozaeid <Adham.Abozaeid@microchip.com> that
    since this is in the transmit path 5ms could impact throughput but adding
    500 microseconds should be tolerable.

Patch was compile tested with: x86_64_defconfig + Staging=y,
WILC1000_SDIO=m, WILC1000_SPI=m, WILC1000=m

Patch is against 5.1-rc4 (localversion-next is -next-20190410)

 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c238969..42da533 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -408,7 +408,7 @@ void chip_wakeup(struct wilc *wilc)
 			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
 
 			do {
-				usleep_range(2 * 1000, 2 * 1000);
+				usleep_range(2000, 2500);
 				wilc_get_chipid(wilc, true);
 			} while (wilc_get_chipid(wilc, true) == 0);
 		} while (wilc_get_chipid(wilc, true) == 0);
@@ -423,7 +423,7 @@ void chip_wakeup(struct wilc *wilc)
 						     &clk_status_reg);
 
 			while ((clk_status_reg & 0x1) == 0) {
-				usleep_range(2 * 1000, 2 * 1000);
+				usleep_range(2000, 2500);
 
 				wilc->hif_func->hif_read_reg(wilc, 0xf1,
 							     &clk_status_reg);
-- 
2.1.4

