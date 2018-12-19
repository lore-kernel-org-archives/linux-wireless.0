Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604FEC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C091218A6
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 16:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbeLSQaL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 11:30:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60654 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727155AbeLSQaL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 11:30:11 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gZejX-0008KJ-VQ; Wed, 19 Dec 2018 16:30:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix missing read_write setting when reading data
Date:   Wed, 19 Dec 2018 16:30:07 +0000
Message-Id: <20181219163007.5329-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the cmd.read_write setting is not initialized so it contains
garbage from the stack.  Fix this by setting it to 0 to indicate a
read is required.

Detected by CoverityScan, CID#1357925 ("Uninitialized scalar variable")

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 27fdfbdda5c0..e2f739fef21c 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -861,6 +861,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 	if (!sdio_priv->irq_gpio) {
 		int i;
 
+		cmd.read_write = 0;
 		cmd.function = 1;
 		cmd.address = 0x04;
 		cmd.data = 0;
-- 
2.19.1

