Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44D7C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855042177B
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392069AbfAKPNH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:13:07 -0500
Received: from smtp3.goneo.de ([85.220.129.37]:49352 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfAKPNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 10:13:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 9669C23FB7C;
        Fri, 11 Jan 2019 16:13:03 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YDxrSeopG9zk; Fri, 11 Jan 2019 16:13:02 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 8D25B23F344;
        Fri, 11 Jan 2019 16:13:02 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v5 7/7] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Fri, 11 Jan 2019 17:18:10 +0100
Message-Id: <20190111161812.26325-7-poeschel@lemonage.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190111161812.26325-1-poeschel@lemonage.de>
References: <20190111161812.26325-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This switches the pn532 UART phy driver from manually polling to the new
autopoll mechanism.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 78ef464bfa7b..2f0fcc6d964a 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -254,7 +254,7 @@ static int pn532_uart_probe(struct serdev_device *serdev)
 	serdev_device_set_flow_control(serdev, false);
 	pn532->send_wakeup = PN532_SEND_WAKEUP;
 	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
-	priv = pn53x_common_init(PN533_DEVICE_PN532,
+	priv = pn53x_common_init(PN533_DEVICE_PN532_AUTOPOLL,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     pn532, &uart_phy_ops, NULL,
 				     &pn532->serdev->dev);
-- 
2.20.1

