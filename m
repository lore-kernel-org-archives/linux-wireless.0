Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5A1C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6D821547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA6D821547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbeI1SDC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:03:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51154 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeI1SDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:03:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id s12-v6so1901899wmc.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+ToiF4WkQHED/FMECTwZbdU8SdDLDBG/7LYVnue0eLM=;
        b=rSXxC0dZSoEfuo3EoeHFMK1u/05PbzGSJM8QpV/ubRLlaQGt/JAOwDcwjkLXFPLoi0
         vGPafJzlRugDBKotnkcEO6KS5qEDyw4dfuiZpRG34ebMIJoYhMIr8aQhFEVa1ajWdep9
         R1G7dXzipIuP3I5gc+oCeW1BFykKCfMgKRkMxeoQInzy/m5bhHyl1YvPU1lqb8fG2rgF
         Ih9b+NfEOXZk6oil0u/fu/Lxdg3EyVJOuo6p6doVjnd5iQHntCTE75eNpdPMY3Ok1AA5
         FWz9+fq3FngD/bxYoK7xhW5pWVPbajiogiG8TQ1q1FxDRWx2pQS7CVmu8O8m8ChPDfTX
         Bx7w==
X-Gm-Message-State: ABuFfohSc/oJz8gy/bhMoJi9vOAuY7M9v+vbx6Mn6bK5pR9bn/HcC45G
        ynB0cIm0l+A1mbaZka0j4lO9zg==
X-Google-Smtp-Source: ACcGV63njAt0i6UyjxaymM8AJkvuoq5Vr8DdKucBS+vYNTD3pWQwxYoWPFcFuFVnvMASNJzm0jYGLw==
X-Received: by 2002:a1c:90e:: with SMTP id 14-v6mr1457570wmj.130.1538134779274;
        Fri, 28 Sep 2018 04:39:39 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:38 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 23/24] mt76x0: eeprom: load eeprom data from mtd by default
Date:   Fri, 28 Sep 2018 13:39:06 +0200
Message-Id: <f76ca95b115400b68501b31fb64e27ada5191f1b.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Read eeprom data from mtd memory by default and fall-back
to efuse if it fails

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 56 ++++++++++++++-----
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index ef9c3df6a169..166a1fd8644e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -277,24 +277,54 @@ void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info)
 		info[1] = 5;
 }
 
+static int mt76x0_check_eeprom(struct mt76x0_dev *dev)
+{
+	u16 val;
+
+	val = get_unaligned_le16(dev->mt76.eeprom.data);
+	if (!val)
+		val = get_unaligned_le16(dev->mt76.eeprom.data +
+					 MT_EE_PCI_ID);
+
+	switch (val) {
+	case 0x7650:
+	case 0x7610:
+		return 0;
+	default:
+		dev_err(dev->mt76.dev, "EEPROM data check failed: %04x\n",
+			val);
+		return -EINVAL;
+	}
+}
+
+static int mt76x0_load_eeprom(struct mt76x0_dev *dev)
+{
+	int found;
+
+	found = mt76_eeprom_init(&dev->mt76, MT76X0_EEPROM_SIZE);
+	if (found < 0)
+		return found;
+
+	if (found && !mt76x0_check_eeprom(dev))
+		return 0;
+
+	found = mt76x0_efuse_physical_size_check(dev);
+	if (found < 0)
+		return found;
+
+	return mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
+				      MT76X0_EEPROM_SIZE, MT_EE_READ);
+}
+
 int mt76x0_eeprom_init(struct mt76x0_dev *dev)
 {
 	u8 version, fae;
 	u16 data;
-	int ret;
+	int err;
 
-	ret = mt76x0_efuse_physical_size_check(dev);
-	if (ret)
-		return ret;
-
-	ret = mt76_eeprom_init(&dev->mt76, MT76X0_EEPROM_SIZE);
-	if (ret < 0)
-		return ret;
-
-	ret = mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
-				     MT76X0_EEPROM_SIZE, MT_EE_READ);
-	if (ret)
-		return ret;
+	err = mt76x0_load_eeprom(dev);
+	if (err < 0)
+		return err;
 
 	data = mt76x02_eeprom_get(&dev->mt76, MT_EE_VERSION);
 	version = data >> 8;
-- 
2.17.1

