Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5C9C67863
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 22:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460D921476
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 22:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 460D921476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbeJSHAx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 03:00:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35514 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbeJSHAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 03:00:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id o17-v6so1174851wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 15:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dwkc0MQebIiHT0JpTzF+pqaPz3lqXtJnqsmwAeeItGg=;
        b=sye/2tL3hbHbPdkPihgo1rMSaylNktslYKn6I5sICH6VM/7E0EyFw8QdSif1wsKHp8
         GPnNVd0lsvuh3aJ344bf9DA5eogvHJenAjyQeRdSdH1v58LaHxelx5owmYOpaARsJgAp
         FDInCUVc86WFFSyIIgQGZjtNUgimqGtgDm+Nn0oUri8bAnO8Rp1oW36ghrUpP5EYWLXN
         NC5cfiVIQlarN0ePfJZAlVHJJMSCyVd5QGpA0/eD5cGdPf2mfSkOeXTuUV2kqautQcD0
         hsQvowQpmSadY4qNak0ZQ5mtazkCKtLiXs1unRK5ZubnM7cMPK/KpWZ02QiKVO9XlgPG
         DGXA==
X-Gm-Message-State: ABuFfogQzdQbF8bdlmPVfWqITIcnlJ9/TS0pHJKxYDP89iCYTYTvs+Kq
        nyLc3liOpxxsoti10DW8CAMUnA==
X-Google-Smtp-Source: AJdET5c33YZvVQKN4so/P+QRN0FK0PIJsC+QVw972tT9XFBHG2ZPwvnn1TYyLEezTfEQcW0FPBzvgw==
X-Received: by 2002:a1c:3b89:: with SMTP id i131-v6mr2201968wma.27.1539903460036;
        Thu, 18 Oct 2018 15:57:40 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id z8-v6sm19268042wrp.63.2018.10.18.15.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 15:57:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: add missing MODULE_FIRMWARE macro
Date:   Fri, 19 Oct 2018 00:57:32 +0200
Message-Id: <dab40954ff61c78f9c39fd47239e48b63e7fea88.1539903329.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1539903329.git.lorenzo.bianconi@redhat.com>
References: <cover.1539903329.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing firmware declaration for mt76x0e driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h  | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c | 3 ---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 989ed00c0b7a..24e817bda500 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -28,6 +28,9 @@
 #include "../mt76x02.h"
 #include "eeprom.h"
 
+#define MT7610E_FIRMWARE		"mediatek/mt7610e.bin"
+#define MT7650E_FIRMWARE		"mediatek/mt7650e.bin"
+
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 3277e6b07a46..6e11b8c8e495 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -211,6 +211,8 @@ static const struct pci_device_id mt76x0e_device_table[] = {
 };
 
 MODULE_DEVICE_TABLE(pci, mt76x0e_device_table);
+MODULE_FIRMWARE(MT7610E_FIRMWARE);
+MODULE_FIRMWARE(MT7650E_FIRMWARE);
 MODULE_LICENSE("Dual BSD/GPL");
 
 static struct pci_driver mt76x0e_driver = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
index 569861289aa5..aca0ea318dce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -19,9 +19,6 @@
 #include "mt76x0.h"
 #include "mcu.h"
 
-#define MT7610E_FIRMWARE	"mediatek/mt7610e.bin"
-#define MT7650E_FIRMWARE	"mediatek/mt7650e.bin"
-
 #define MT_MCU_IVB_ADDR		(MT_MCU_ILM_ADDR + 0x54000 - MT_MCU_IVB_SIZE)
 
 static int mt76x0e_load_firmware(struct mt76x02_dev *dev)
-- 
2.19.1

