Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FA4C64E93
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7500206B8
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7500206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbeI3AOa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 20:14:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40058 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbeI3AO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 20:14:29 -0400
Received: by mail-wm1-f66.google.com with SMTP id o2-v6so4939742wmh.5
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 10:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+o+CHpRgbBOtiHpMqibxu9mMr9h4kJhf/O7/eJk/k0Y=;
        b=UCqttQlTAos2zPyeCjSy+FFWP6r6omh7BaWqR+MG/1rDP3yyzh/hf5NDqBivWvijCw
         dhuT3oHE44TjieLhhYY2BUu9hnxE2R2EYsBBEFar4hn0e9hi//SLCoBHSTmwSysucbFq
         Bp9j75ULMwEEAhcjY0vGIIVWg4Uw93Xk0xR3mWLMh+WRUij19i+RlwEZvCn8/S6Gl1k2
         HUlYaozweCV9Nq8uG8tWVAbci4hc0k/K3cjGcDqzr7rPCOoK6yi4hwkEuletjy+m71ln
         /K9fI+7HPYjxKVeF/3yWiFMSdbWOI5M5UL1tBwznfPp0QrJ8j7vlH1fR8dRDWwyd+R4z
         WtDw==
X-Gm-Message-State: ABuFfogLxhmo82nwTAFAYb8a/ZkX52mvIhFt3ZhEMqsTjwcTPnlLKNQM
        WVEQdRk1ycq4x+Fp5kcaTaC0Xw==
X-Google-Smtp-Source: ACcGV62OlDIBhMSIG/zKWO8kFt5YvZt1nItk8a9q3i/0ha+HAXUWkFSoLmy8we2tfcX+yEUUVujJSw==
X-Received: by 2002:a1c:1dc8:: with SMTP id d191-v6mr86081wmd.27.1538243110551;
        Sat, 29 Sep 2018 10:45:10 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e14-v6sm10845021wrs.69.2018.09.29.10.45.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 10:45:10 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/5] mt76: introduce is_mt76x2 routine
Date:   Sat, 29 Sep 2018 19:44:52 +0200
Message-Id: <20180929174456.995-2-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add is_mt76x2 utility routine to check if device chip id is mt76x2.
Moreover move is_mt7612 in mt76.h. This is a preliminary patch to
share write_txwi routine between mt76x2 and mt76x0 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h           | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h  |  5 -----
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c |  2 +-
 6 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f2dd4d87e355..e9595ea9b0fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -516,6 +516,19 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 	return dev->rev & 0xffff;
 }
 
+static inline bool is_mt7612(struct mt76_dev *dev)
+{
+	return mt76_chip(dev) == 0x7612;
+}
+
+static inline bool is_mt76x2(struct mt76_dev *dev)
+{
+	return mt76_chip(dev) == 0x7612 ||
+	       mt76_chip(dev) == 0x7602 ||
+	       mt76_chip(dev) == 0x7662 ||
+	       mt76_chip(dev) == 0x7632;
+}
+
 #define mt76xx_chip(dev) mt76_chip(&((dev)->mt76))
 #define mt76xx_rev(dev) mt76_rev(&((dev)->mt76))
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index ecbb9e4ab888..c58aa251f0b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -109,11 +109,6 @@ struct mt76x2_dev {
 	struct mt76x2_dfs_pattern_detector dfs_pd;
 };
 
-static inline bool is_mt7612(struct mt76x2_dev *dev)
-{
-	return mt76_chip(&dev->mt76) == 0x7612;
-}
-
 static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 7036f4cbc836..56c6259cbf79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -108,7 +108,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 		   MT_MAC_SYS_CTRL_RESET_CSR |
 		   MT_MAC_SYS_CTRL_RESET_BBP);
 
-	if (is_mt7612(dev))
+	if (is_mt7612(&dev->mt76))
 		mt76_clear(dev, MT_COEXCFG0, MT_COEXCFG0_COEX_EN);
 
 	mt76_set(dev, MT_EXT_CCA_CFG, 0x0000f000);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 38fa84bddf7b..ffb1301bd77d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -28,7 +28,7 @@ mt76pci_load_rom_patch(struct mt76x2_dev *dev)
 {
 	const struct firmware *fw = NULL;
 	struct mt76x02_patch_header *hdr;
-	bool rom_protect = !is_mt7612(dev);
+	bool rom_protect = !is_mt7612(&dev->mt76);
 	int len, ret = 0;
 	__le32 *cur;
 	u32 patch_mask, patch_reg;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index ae89461f803c..0045ff50eb35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -103,7 +103,7 @@ int mt76x2u_mac_reset(struct mt76x2_dev *dev)
 		   MT_MAC_SYS_CTRL_RESET_CSR |
 		   MT_MAC_SYS_CTRL_RESET_BBP);
 
-	if (is_mt7612(dev))
+	if (is_mt7612(&dev->mt76))
 		mt76_clear(dev, MT_COEXCFG0, MT_COEXCFG0_COEX_EN);
 
 	mt76_set(dev, MT_EXT_CCA_CFG, 0xf000);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 35e157be456c..06c03e9f627d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -91,7 +91,7 @@ static void mt76x2u_mcu_reset_wmt(struct mt76x2_dev *dev)
 
 static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
 {
-	bool rom_protect = !is_mt7612(dev);
+	bool rom_protect = !is_mt7612(&dev->mt76);
 	struct mt76x02_patch_header *hdr;
 	u32 val, patch_mask, patch_reg;
 	const struct firmware *fw;
-- 
2.19.0

