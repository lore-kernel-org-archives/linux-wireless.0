Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21B4ECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 837D720834
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 837D720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbeJYWC7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 18:02:59 -0400
Received: from smtp1-3.goneo.de ([85.220.129.32]:38125 "EHLO smtp1-3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbeJYWC7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 18:02:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id EE1AA242151;
        Thu, 25 Oct 2018 15:30:11 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g08a5PjeUCWh; Thu, 25 Oct 2018 15:30:09 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id B63AB241024;
        Thu, 25 Oct 2018 15:30:09 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Lars Poeschel <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/5] nfc: pn533: i2c: "pn532" as dt compatible string
Date:   Thu, 25 Oct 2018 15:29:32 +0200
Message-Id: <20181025132937.24405-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is favourable to have one unified compatible string for devices that
have multiple interfaces. So this adds simply "pn532" as the devicetree
binding compatible string and makes a note that the old ones are
deprecated.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 4389eb4c8d0b..f4eae9dd5305 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -258,6 +258,11 @@ static int pn533_i2c_remove(struct i2c_client *client)
 }
 
 static const struct of_device_id of_pn533_i2c_match[] = {
+	{ .compatible = "nxp,pn532", },
+	/*
+	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
+	 * deprecated and will be removed.
+	 */
 	{ .compatible = "nxp,pn533-i2c", },
 	{ .compatible = "nxp,pn532-i2c", },
 	{},
-- 
2.19.1

