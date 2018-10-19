Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DCFECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF4E2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAF4E2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbeJSRqV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:46:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40646 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeJSRqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:46:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id z204-v6so3034247wmc.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 02:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AgeWgZPTzT1iV4Pfdhx8moCoCr6Q1TzucyBT/HsWLxY=;
        b=PRbABE2uvhYtc1AnOBdzVKNpKIrn/HHoKmC7QgmQCSRbt01vHGazkWIm/tq1eazMhc
         wFysA8/slQz1vrFkDTQZAtF4VqvYoue3WB8OErfMi6/Nme1HEU+9ioJetFvgReAy9oQd
         IYBzeKjvzJCnON+xHBMGL2+S0i1bPLw2RhOiHb86RfLaKJJkWsKqvq3LoXF80PmN4dUX
         heNFzMRgeQQwSEm+yv6y9TAOD0phaA9e7qz2oi5ZdIkOSzBe0OGCcf5+B2hLt4xDYkli
         HPoXtLzbAC1JqT5DRaMYZEOEQPZxMej9sK3SyD/7C74mGBBWeUXpxQybS6VeiranKi+8
         dbxQ==
X-Gm-Message-State: ABuFfoggmj87jar1xr5IEeqNNO8rix0INDov9WCUptUp7BpCUn/0pyWV
        TSEdg5pMx5dQ4GY4DLHEwrQXwg==
X-Google-Smtp-Source: ACcGV602RLL+csAiDiOixfgJmRDL/6ef4HiF9XzudYEzHOh/eQ7WVjkWQMh0DkwOF4+bC3fUXzDN3Q==
X-Received: by 2002:a1c:9d43:: with SMTP id g64-v6mr3960408wme.26.1539942060878;
        Fri, 19 Oct 2018 02:41:00 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t2-v6sm21189938wrr.7.2018.10.19.02.40.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Oct 2018 02:41:00 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: align mt76x0u and mt76x0e fw version
Date:   Fri, 19 Oct 2018 11:40:48 +0200
Message-Id: <055ec314974a5cb9ea88cfb228a57a2d84f6fa15.1539941831.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539941831.git.lorenzo.bianconi@redhat.com>
References: <cover.1539941831.git.lorenzo.bianconi@redhat.com>
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

Changes since v1:
- use firmware_request_nowarn instead of request_firmware
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
index a9f14d5149d1..9d7585029df9 100644
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
+	err = firmware_request_nowarn(fw, MT7610E_FIRMWARE, dev->mt76.dev);
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

