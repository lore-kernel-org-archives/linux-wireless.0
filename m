Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AA9C71122
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8202064E
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF8202064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbeJOCJ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 22:09:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39271 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbeJOCJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 22:09:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id y144-v6so17334885wmd.4
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 11:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gd6dGZ7Q0uspSBNc+W1kS58F/T9Jfd86k7qe5wXW22o=;
        b=QwBXFxMB1pMZuRME3nWCUQyfLjOPON9HA1Q7nHd09c71cR3eLthyaJWDX9KYG0mhhn
         +2bRFSXXYIISQgikV1guxNkXc3eHONfBvTYcEF20vaX1XA1u6iCTw2h8STVFxj2YA+X/
         8S7m7DlN4aGdcHLIJc/KF/X4YVqtXo2/NKYKIXGmL5yygL2RVzCpmaIiBP4E0mQcLquH
         ysaC+5vO1OPzoqialo+A0uLYqIeeYpTHzrJiO8xxGwOwjrCg2vqzma0xVfN+p++fSmwA
         +wLoCRRgUxChisiAoggV9ZRNO78bX+oPb/BOYk1aHAn//g8aAvWl1aPUoB0XfdHhvrvh
         FSwA==
X-Gm-Message-State: ABuFfoin6FzibJvb37RoYLFc5AzC8yB/bb991CUMPwGqkDLMjPfzRyXo
        8cuEJyGQwYknzjkqdyPJIjRkJw==
X-Google-Smtp-Source: ACcGV60KuwJAHMV0AmWcj4yRL687GHAkxoVC+wAdhaXQnQZoHiyiX+spRHAE9xkHNew3skXCJPjDzw==
X-Received: by 2002:a1c:9ca:: with SMTP id 193-v6mr11450021wmj.86.1539541682858;
        Sun, 14 Oct 2018 11:28:02 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id s7-v6sm15439321wmd.0.2018.10.14.11.28.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 11:28:02 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] mt76x2: align mt76x2 and mt76x2u firmware
Date:   Sun, 14 Oct 2018 20:27:27 +0200
Message-Id: <86b689536dd6625cad8df22f6fb6ef4442049098.1539541196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539541196.git.lorenzo.bianconi@redhat.com>
References: <cover.1539541196.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify firmware version used on mt76x2e and mt76x2u drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h  | 3 ---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c     | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index ab93125f46de..b546fe83a40d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -31,9 +31,6 @@
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
 #define MT7662_EEPROM_SIZE	512
 
-#define MT7662U_FIRMWARE	"mediatek/mt7662u.bin"
-#define MT7662U_ROM_PATCH	"mediatek/mt7662u_rom_patch.bin"
-
 #define MT_CALIBRATE_INTERVAL	HZ
 
 #include "../mt76x02.h"
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 57baf8d1c830..4d1788eb3812 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -131,8 +131,8 @@ static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 }
 
 MODULE_DEVICE_TABLE(usb, mt76x2u_device_table);
-MODULE_FIRMWARE(MT7662U_FIRMWARE);
-MODULE_FIRMWARE(MT7662U_ROM_PATCH);
+MODULE_FIRMWARE(MT7662_FIRMWARE);
+MODULE_FIRMWARE(MT7662_ROM_PATCH);
 
 static struct usb_driver mt76x2u_driver = {
 	.name		= KBUILD_MODNAME,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 3f1e558e5e6d..a40aa838b6b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -117,7 +117,7 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x02_dev *dev)
 		return 0;
 	}
 
-	err = request_firmware(&fw, MT7662U_ROM_PATCH, dev->mt76.dev);
+	err = request_firmware(&fw, MT7662_ROM_PATCH, dev->mt76.dev);
 	if (err < 0)
 		return err;
 
@@ -183,7 +183,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 	int err, len, ilm_len, dlm_len;
 	const struct firmware *fw;
 
-	err = request_firmware(&fw, MT7662U_FIRMWARE, dev->mt76.dev);
+	err = request_firmware(&fw, MT7662_FIRMWARE, dev->mt76.dev);
 	if (err < 0)
 		return err;
 
-- 
2.19.0

