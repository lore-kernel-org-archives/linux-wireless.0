Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D0DECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD6202083A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD6202083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbeJQSVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:21:42 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:59086 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbeJQSVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 14:21:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 267A1242620;
        Wed, 17 Oct 2018 12:21:12 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D3dHdPAr8dOB; Wed, 17 Oct 2018 12:21:11 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id 1AB4223F65C;
        Wed, 17 Oct 2018 12:21:11 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH 3/3] nfc: pn532_uart: Make use of pn532 autopoll
Date:   Wed, 17 Oct 2018 12:20:37 +0200
Message-Id: <20181017102037.28537-3-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181017102037.28537-1-poeschel@lemonage.de>
References: <20181017102037.28537-1-poeschel@lemonage.de>
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
index b5f995988cae..3316298e31a7 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -162,7 +162,7 @@ static int pn532_open(struct tty_struct *tty)
 	if (pn532->wq_open_tty == NULL)
 		goto err_skb;
 
-	priv = pn533_register_device(PN533_DEVICE_PN532,
+	priv = pn533_register_device(PN533_DEVICE_PN532_AUTOPOLL,
 				     PN533_NO_TYPE_B_PROTOCOLS,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     pn532, &uart_phy_ops, NULL,
-- 
2.19.1

