Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6FEC282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD2D21855
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfDFJuy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:50:54 -0400
Received: from www.osadl.org ([62.245.132.105]:59644 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfDFJuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 05:50:54 -0400
Received: from debian01.hofrr.at (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x369oZOp024651;
        Sat, 6 Apr 2019 11:50:35 +0200
From:   Nicholas Mc Guire <hofrat@osadl.org>
To:     Adham Abozaeid <adham.abozaeid@microchip.com>
Cc:     Julian Calaby <julian.calaby@gmail.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH V3] staging: wilc1000: drop explicit conversion to bool
Date:   Sat,  6 Apr 2019 11:45:27 +0200
Message-Id: <1554543927-13038-1-git-send-email-hofrat@osadl.org>
X-Mailer: git-send-email 2.1.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As the expression evaluates to a boolean anyway (relational and logical
operators) conversion with the ternary operator is not needed here as
coccinelle notes (boolconv.cocci)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com> 
---

V2: sent out the wrong version - the commit message was longer than 75
    chars - only change here is the commit message wrapping.

V3: dropping the superfluous outer () as suggested by
    Julian Calaby <julian.calaby@gmail.com>

scripts/coccinelle/misc/boolconv.cocci warned about:
drivers/staging/wilc1000/wilc_wlan.c:14:48-53: WARNING: conversion to bool not needed here

Patch was compile tested with: x86_64_defconfig + Staging=y,
WILC1000_SDIO=m, WILC1000_SPI=m, WILC1000=m
(checkpatch, sparse and cocci clean otherwise)

Patch is against 5.1-rc3 (localversion-next is -next-20190405)

 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c238969..6c9fd3a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -11,7 +11,7 @@
 
 static inline bool is_wilc1000(u32 id)
 {
-	return ((id & 0xfffff000) == 0x100000 ? true : false);
+	return (id & 0xfffff000) == 0x100000;
 }
 
 static inline void acquire_bus(struct wilc *wilc, enum bus_acquire acquire)
-- 
2.1.4

