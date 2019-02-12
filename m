Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127CCC282CE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2F921773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549978995;
	bh=92NKZmdPsWhiPRbZ16Dba0dUynmIQACPlO8HtGfp6MA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=U1yXw4e+su1Qtzgq//E4YzDngsP0M8y1uW6t7V9pZsgVp+2AUGyGGd0RjU/aZdM9j
	 3rcmneVZGz91n+HrSpruGCnjSdeSmIxQilsGMpO4bDpo9t5qMESs46r9vLpZxrRx83
	 hvY79Mtb1qLjCVS29eml8kN/vaqinTMGKZuLMAQA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfBLNnP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLNnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:43:14 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9770621773
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549978994;
        bh=92NKZmdPsWhiPRbZ16Dba0dUynmIQACPlO8HtGfp6MA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ik/aeG4PSw8g0qnZYZUdrEIa2Kj3OU4iixQpe7jycJOYaq7zD5SKe38M7HxNKtfLw
         3LjqIKqiVbGgWB9HPWEnyUHdsTL/8vCe3sIRO6g10mqL/iZkA911hzJHtHmIZCjU47
         Tm/dTW2dSh3Ask4pgUBN5vXfZhr0WiozuS5VZ6AI=
From:   lorenzo@kernel.org
To:     linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 4/4] mt76: usb: introduce disable_usb_sg parameter
Date:   Tue, 12 Feb 2019 14:42:42 +0100
Message-Id: <de432354252ddaec04ac99f7cb23defb7909511d.1549977282.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549977282.git.lorenzo@kernel.org>
References: <cover.1549977282.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add disable_usb_sg module parameter to disable scatter-gather on demand

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7e7da6b49a88..78191968b4fa 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -22,6 +22,10 @@
 #define MT_VEND_REQ_MAX_RETRY	10
 #define MT_VEND_REQ_TOUT_MS	300
 
+static bool disable_usb_sg;
+module_param_named(disable_usb_sg, disable_usb_sg, bool, 0644);
+MODULE_PARM_DESC(disable_usb_sg, "Disable usb scatter-gather support");
+
 /* should be called with usb_ctrl_mtx locked */
 static int __mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 				  u8 req_type, u16 val, u16 offset,
@@ -246,7 +250,7 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	return (udev->bus->sg_tablesize > 0 &&
+	return (!disable_usb_sg && udev->bus->sg_tablesize > 0 &&
 		(udev->bus->no_sg_constraint ||
 		 udev->speed == USB_SPEED_WIRELESS));
 }
-- 
2.20.1

