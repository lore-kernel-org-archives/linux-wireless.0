Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6762FECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 124AD2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 124AD2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbeJSRDz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:03:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37015 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbeJSRDz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:03:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so2927330wmt.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 01:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wp98v3SS96I1WPOekdzw7230MGMEPVcICtPNiyi2J0k=;
        b=X1btmrs15AbQu8rrTOHcq7DknvxfC6EbIDovNq1sKDdbgu7J7k72lZMTndGr/MDc9r
         wzWH+54fy9kns3hUiGEGkfwlay2t2MnSTejw+ptjvfPaUE8ymsx5iDQbSpi+ATAyRagM
         zUlWscYjmuMwziC/EwpDqJ7hLfBF8EDjXQ1ZR6AeLu/nIqITC2GWVHmhsSo4n70/sbkt
         RDxW63zcT6IO/mpbAlcWOstyDGAlsY8VfKQIl8LVaIOVfsfG4/VcSTF8iUsfrWFkdS/J
         RdESdEGURh5jMinKDZ7JisJ8Acd1EMDc4ZXlx8ctwI5vq2l1B7BxeMpZPgIaZyk4+gKj
         3dUQ==
X-Gm-Message-State: ABuFfojsjbMMoBe9xPrVQ6QhQQubM+D+IQLAExm79pr9ff/p49ReGO+r
        BknLgGTz+MKLEs5z5/omJ7zAXet7kvM=
X-Google-Smtp-Source: ACcGV62KhUijBlla/hUEKwhMtzVdL5V8j+n5DxaRv6RcCiKG78UCLeM9zwXzXMqgM6nrmWbjgwn6HA==
X-Received: by 2002:a1c:5e07:: with SMTP id s7-v6mr3773434wmb.91.1539939523431;
        Fri, 19 Oct 2018 01:58:43 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id w2-v6sm15777116wre.57.2018.10.19.01.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Oct 2018 01:58:42 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: align mt76x0u and mt76x0e fw version
Date:   Fri, 19 Oct 2018 10:58:33 +0200
Message-Id: <bd30d8b3853395565d5e81acb98ae3d43ddc1f6e.1539938482.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539938482.git.lorenzo.bianconi@redhat.com>
References: <cover.1539938482.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify firmware version used on mt76x0e and mt76x0u drivers.
Fallback to mt7610u fw if mt7610e one is not available

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
this patch is based on top of:
https://patchwork.kernel.org/patch/10648399/
---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 ++
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 ++
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 23 +++++++++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 24e817bda500..1871ec98aefb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -31,6 +31,8 @@
 #define MT7610E_FIRMWARE		"mediatek/mt7610e.bin"
 #define MT7650E_FIRMWARE		"mediatek/mt7650e.bin"
 
+#define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
+
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index cdbb8a6db608..245eb4aa9764 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -337,6 +337,8 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 }
 
 MODULE_DEVICE_TABLE(usb, mt76x0_device_table);
+MODULE_FIRMWARE(MT7610E_FIRMWARE);
+MODULE_FIRMWARE(MT7610U_FIRMWARE);
 MODULE_LICENSE("GPL");
 
 static struct usb_driver mt76x0_driver = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
index a9f14d5149d1..b57c2a11146f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -22,7 +22,6 @@
 
 #define MCU_FW_URB_MAX_PAYLOAD		0x38f8
 #define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
-#define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
 
 static int
 mt76x0u_upload_firmware(struct mt76x02_dev *dev,
@@ -75,6 +74,24 @@ mt76x0u_upload_firmware(struct mt76x02_dev *dev,
 	return err;
 }
 
+static int mt76x0_get_firmware(struct mt76x02_dev *dev,
+			       const struct firmware **fw)
+{
+	int err;
+
+	/* try to load mt7610e fw if available
+	 * otherwise fall back to mt7610u one
+	 */
+	err = request_firmware(fw, MT7610E_FIRMWARE, dev->mt76.dev);
+	if (err) {
+		dev_info(dev->mt76.dev, "%s not found, switching to %s",
+			 MT7610E_FIRMWARE, MT7610U_FIRMWARE);
+		return request_firmware(fw, MT7610U_FIRMWARE,
+					dev->mt76.dev);
+	}
+	return 0;
+}
+
 static int mt76x0u_load_firmware(struct mt76x02_dev *dev)
 {
 	const struct firmware *fw;
@@ -88,7 +105,7 @@ static int mt76x0u_load_firmware(struct mt76x02_dev *dev)
 	if (mt76x0_firmware_running(dev))
 		return 0;
 
-	ret = request_firmware(&fw, MT7610U_FIRMWARE, dev->mt76.dev);
+	ret = mt76x0_get_firmware(dev, &fw);
 	if (ret)
 		return ret;
 
@@ -171,5 +188,3 @@ int mt76x0u_mcu_init(struct mt76x02_dev *dev)
 
 	return 0;
 }
-
-MODULE_FIRMWARE(MT7610U_FIRMWARE);
-- 
2.17.2

