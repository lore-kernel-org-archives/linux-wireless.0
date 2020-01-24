Return-Path: <SRS0=oqKg=3N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF87C32771
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3BB206F0
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579876542;
	bh=QFIDya6ivalEWjHBowgAtT7ZFFosbE3XxUDc3fLxS0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h6UVCC0HzeHpeqfMSr0e1XkvLMqp2TIP2B1MMKUvZRzuWJTt/5c9Jd5B2yqxQSCOI
	 uRWxbQGmJveudL8nXk/AvDJ1E22a3cVhz5JCcsKpGx9y3CZ8i3Jk32EIQKiRhmg681
	 FQSYi4gXCYclEarQotfG0zgcFW0iwhHGk1/rt/OM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392071AbgAXOfl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391715AbgAXOTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9EB22522;
        Fri, 24 Jan 2020 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875569;
        bh=QFIDya6ivalEWjHBowgAtT7ZFFosbE3XxUDc3fLxS0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFlju4nnIDoFDyU9DrxA7yzDclo1/Tll8jCvY/8S++KHzfFHKBNPFfWtLubE7L4R4
         n1+CvCn2IJAEWUkQiqdWpu2nucAchZdxWNdcD+kS6jc5GhkjcIPXfZaevlfYbKLvYT
         D714tjoT2HH7uA7uvg0mNj912WIr3lDgontLyTVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 062/107] NFC: pn533: fix bulk-message timeout
Date:   Fri, 24 Jan 2020 09:17:32 -0500
Message-Id: <20200124141817.28793-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit a112adafcb47760feff959ee1ecd10b74d2c5467 ]

The driver was doing a synchronous uninterruptible bulk-transfer without
using a timeout. This could lead to the driver hanging on probe due to a
malfunctioning (or malicious) device until the device is physically
disconnected. While sleeping in probe the driver prevents other devices
connected to the same hub from being added to (or removed from) the bus.

An arbitrary limit of five seconds should be more than enough.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index e897e4d768ef7..d7a355d053687 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -391,7 +391,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 		       cmd, sizeof(cmd), false);
 
 	rc = usb_bulk_msg(phy->udev, phy->out_urb->pipe, buffer, sizeof(cmd),
-			  &transferred, 0);
+			  &transferred, 5000);
 	kfree(buffer);
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
-- 
2.20.1

