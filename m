Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6C2C71122
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CAD02077C
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CAD02077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbeJOAUL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 20:20:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52678 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOAUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 20:20:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so16566059wmw.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 09:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gd6dGZ7Q0uspSBNc+W1kS58F/T9Jfd86k7qe5wXW22o=;
        b=NUzjP7utFU8i/JCrDQhgk+Hs0PGwetTbuF4LgCx8sPbyqloMVqIzUbSvTXcKSjuKhW
         fQXBK0T8WVZl/GKYuKwyz6s6029O+Gm9T/Ah297cyijYw76fsx900ezTnHVKYaspc9Fy
         oVa/rQmz//njGzoQpVhOQLj70xGhMrVdtZkd+WCA/aGnY6r8RNjfiuCE10Zo2ZHJUhtj
         gekdTP2ZJFYUCQMCMWAbLLbPYBa6vUUhAlOFloGcMeO0mCOdLtEg3jc3amuGlAEzpCuC
         YZbSjKazg6X2RLALNqEgmgmihw3MmXAc5LfQdN3xW0gs58q8x5vwtGHhum5JzzAGwpOD
         XBGg==
X-Gm-Message-State: ABuFfoh7wiuabTsoEGQVLfUBJwa1eeAPJhDtSFchRmhB0uvWa6gnFLA2
        nxrUkOVbPCE0aXqbNQ5zoc47gw==
X-Google-Smtp-Source: ACcGV60HkwUAjiIjeDGBexPGUW8JJ0BLjDc/K6enUbkMHYHqaZGJhQFd7KX7x+t6SpaFpffyQKdijg==
X-Received: by 2002:a1c:2ecc:: with SMTP id u195-v6mr11185649wmu.137.1539535113562;
        Sun, 14 Oct 2018 09:38:33 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id m143-v6sm7506910wmd.29.2018.10.14.09.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 09:38:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76x2: align mt76x2 and mt76x2u firmware
Date:   Sun, 14 Oct 2018 18:38:05 +0200
Message-Id: <86b689536dd6625cad8df22f6fb6ef4442049098.1539534731.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539534731.git.lorenzo.bianconi@redhat.com>
References: <cover.1539534731.git.lorenzo.bianconi@redhat.com>
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

