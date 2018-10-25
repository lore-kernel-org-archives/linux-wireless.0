Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6348C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 866D72075D
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:32:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 866D72075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbeJYWFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 18:05:02 -0400
Received: from smtp1-3.goneo.de ([85.220.129.32]:33707 "EHLO smtp1-3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbeJYWFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 18:05:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id CEA95241024;
        Thu, 25 Oct 2018 15:32:13 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xNkZVFm5j6qq; Thu, 25 Oct 2018 15:32:13 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id C97CF23F435;
        Thu, 25 Oct 2018 15:32:12 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 5/5] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Thu, 25 Oct 2018 15:29:36 +0200
Message-Id: <20181025132937.24405-5-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181025132937.24405-1-poeschel@lemonage.de>
References: <20181025132937.24405-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This switches the pn532 UART phy driver from manually polling to the new
autopoll mechanism.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 8fd71c8953ca..a95ca01745ca 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -207,7 +207,7 @@ static int pn532_uart_probe(struct serdev_device *serdev)
 		goto err_free;
 
 	pn532->serdev = serdev;
-	priv = pn533_register_device(PN533_DEVICE_PN532,
+	priv = pn533_register_device(PN533_DEVICE_PN532_AUTOPOLL,
 				     PN533_NO_TYPE_B_PROTOCOLS,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     pn532, &uart_phy_ops, NULL,
-- 
2.19.1

