Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B5CC43612
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C3420861
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfAOMeC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:34:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51838 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbfAOMd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:33:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so3118649wmj.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQeLfaozPhgc59Xi4Vf5R9yOu4XoYgDRdqqXgKx448A=;
        b=Biv6yEcKYRi/ji6aFdVdRMLm0gim8AhbjeAzN+tnECL6tSHuxuglpI77J9H8F5KTzG
         9rYbTYzHaTKrdMw0v6t4ywhVYwgnoudTJBnfNBKGT2QvXiBfiyAkWsQNFArjLU731s/k
         oyT9MHcvb57GJVuhpb6cqvFBnrlh7YHcVzVZ+LlXPE3KuTvo0lHDV0KyOEy2Paber3c0
         2g6jJ08IfXQDS9t5nbkcwG7fF6uur/50vil64KlvmQXqZqaDEORmeKNGdO52vDinx6b6
         0jq+ECMWAhAkgql2uilhubYBsVaRJ76qTkRdyIsUDBQITdg6CTFQuDGupgtbLHQmWsa5
         uqlw==
X-Gm-Message-State: AJcUuke0qwTt3LKpZJudjbY8lsVwdckNIgwEqa2KZ1qMgrtDsJo8isYs
        N+2mfLXGECRBpWpT+FVq088o/g==
X-Google-Smtp-Source: ALg8bN6P5QIHMe14mRGrJ9nxbQRt9f0J/2lNB4QRF9MCwdsB1A5v+HOjYlJZKjQufsyHh7sxYngTug==
X-Received: by 2002:a1c:2686:: with SMTP id m128mr3112662wmm.52.1547555637232;
        Tue, 15 Jan 2019 04:33:57 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a6sm28218186wmh.10.2019.01.15.04.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 04:33:55 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, rosenp@gmail.com,
        sgruszka@redhat.com
Subject: [RFC 4/4] mt76: usb: introduce disable_usb_sg parameter
Date:   Tue, 15 Jan 2019 13:33:45 +0100
Message-Id: <99a03acbc5ba45920b3ec08083d2533c1e114baf.1547549771.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add disable_usb_sg module parameter to disable scatter-gather on demand

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 491b17756ccd..0b056f04630f 100644
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

