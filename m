Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7F1ECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0632145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E0632145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbeJRWqo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 18:46:44 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:33912 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbeJRWqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 18:46:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 2FC19241D83;
        Thu, 18 Oct 2018 16:45:23 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id e6L5sNl1bNTR; Thu, 18 Oct 2018 16:45:22 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id DCBEA242A01;
        Thu, 18 Oct 2018 16:45:21 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/4] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Thu, 18 Oct 2018 16:42:44 +0200
Message-Id: <20181018144251.30028-4-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018144251.30028-1-poeschel@lemonage.de>
References: <20181018144251.30028-1-poeschel@lemonage.de>
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

