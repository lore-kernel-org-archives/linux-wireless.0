Return-Path: <SRS0=Gxg0=4G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AABC34047
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Feb 2020 18:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37912208C4
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Feb 2020 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582049863;
	bh=yYDMjp5/cDBIY1sRGi3LckFsgTfaXqAJLGyXpqe7DkY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=WeT4BUaLe12L0dkkmcFr3GtNQy3HtNRcQUg7fgFtwqsB3AEeou5J/bJqTvLxTsMCy
	 b1FrSalwZoGCdJRYqG0r3C/e89nAaqfudQd/lIUSMmvpr5JEuuOKZ/7s0XbgC9g5aN
	 ohR/bHNxNtToPozXJPIcTXKaEwNfMLvHgNXgYsD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgBRSRm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Feb 2020 13:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgBRSRm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Feb 2020 13:17:42 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008CD21D56;
        Tue, 18 Feb 2020 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582049861;
        bh=yYDMjp5/cDBIY1sRGi3LckFsgTfaXqAJLGyXpqe7DkY=;
        h=From:To:Cc:Subject:Date:From;
        b=EIxa0kWpnZOLNnWA9UZan6r/vH48Jr10BNLZWLEL2RZKSkF1d7vSLCeV/YdMtznfA
         vMbjHS2t8pNCgVdch0YDWsch2rfJKyB2mZz6adbOY2ovqqGMOs/sKGLiZf7nlc3aBW
         9M1JA+IalfKS6lRdZc9+uNbBMvOUk334oAGVFW6M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt76u: fix a possible memory leak in mt76u_init
Date:   Tue, 18 Feb 2020 19:17:12 +0100
Message-Id: <44f06c31962adb2e451aa220711ad4e957beeab9.1582049726.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove usb workqueue if mt76u_set_endpoints fails.

Fixes: 284efb473ef5 ("mt76: mt76u: rely on a dedicated stats workqueue")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 36ba81d63f12..2c0dbc36f9aa 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -1150,6 +1150,7 @@ int mt76u_init(struct mt76_dev *dev,
 	};
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76_usb *usb = &dev->usb;
+	int err = -ENOMEM;
 
 	mt76u_ops.rr = ext ? mt76u_rr_ext : mt76u_rr;
 	mt76u_ops.wr = ext ? mt76u_wr_ext : mt76u_wr;
@@ -1169,10 +1170,8 @@ int mt76u_init(struct mt76_dev *dev,
 		usb->data_len = 32;
 
 	usb->data = devm_kmalloc(dev->dev, usb->data_len, GFP_KERNEL);
-	if (!usb->data) {
-		mt76u_deinit(dev);
-		return -ENOMEM;
-	}
+	if (!usb->data)
+		goto error;
 
 	mutex_init(&usb->usb_ctrl_mtx);
 	dev->bus = &mt76u_ops;
@@ -1182,7 +1181,15 @@ int mt76u_init(struct mt76_dev *dev,
 
 	usb->sg_en = mt76u_check_sg(dev);
 
-	return mt76u_set_endpoints(intf, usb);
+	err = mt76u_set_endpoints(intf, usb);
+	if (err < 0)
+		goto error;
+
+	return 0;
+
+error:
+	mt76u_deinit(dev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(mt76u_init);
 
-- 
2.24.1

