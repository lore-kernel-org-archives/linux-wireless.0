Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E46CC2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D79D246A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698014;
	bh=SsNKGqw30yQ9peA9T9IZh1o/PgCY2XYE1wCwxi9YVW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tqC1LAr3Hv2H2JPHJu0oKggcE5L1aKU5MfOgbjtavUm5sf50vQB9Fn6ZEnvTbrB9R
	 UZYjQjfWnYQhd25hmN73hG0+h6NvFk0XzKOriUol/D7Lqzd5BlrFgTB1i8wX+yXePe
	 9yk7x+p32EGFgf16WagArnr7m2CON+n07LkIxn/g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393546AbgBNQd2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406096AbgBNQZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3109A247CB;
        Fri, 14 Feb 2020 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697525;
        bh=SsNKGqw30yQ9peA9T9IZh1o/PgCY2XYE1wCwxi9YVW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSovNoPqAfj7uVd69SRH6de/+kcBtw76jAyqnNoBAhQalbB7WszfjW3bRr8C5Mvj2
         PABdxKJS8fFb4P+4+gzB9kKbwtrkDOCo/kZTpNKFpTYd2eU/W81y1AeaXDOW/hKwwk
         IIGqOWDagbrCxMBuS0YoPMVTVdwZIEJFkia6sDuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 048/100] orinoco: avoid assertion in case of NULL pointer
Date:   Fri, 14 Feb 2020 11:23:32 -0500
Message-Id: <20200214162425.21071-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit c705f9fc6a1736dcf6ec01f8206707c108dca824 ]

In ezusb_init, if upriv is NULL, the code crashes. However, the caller
in ezusb_probe can handle the error and print the failure message.
The patch replaces the BUG_ON call to error return.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index e434f7ca8ff36..3c5baccd67922 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1351,7 +1351,8 @@ static int ezusb_init(struct hermes *hw)
 	int retval;
 
 	BUG_ON(in_interrupt());
-	BUG_ON(!upriv);
+	if (!upriv)
+		return -EINVAL;
 
 	upriv->reply_count = 0;
 	/* Write the MAGIC number on the simulated registers to keep
-- 
2.20.1

