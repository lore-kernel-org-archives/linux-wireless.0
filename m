Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD634C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED2321746
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ED2321746
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbeI1NDG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43108 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbeI1NDG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id z14-v6so5051390wrs.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S62U6/d84tYV7aXTb51ZVVwEk8F7lgbFsv2erDU8URc=;
        b=jZaV16SuvQ6c+WbdElp2Ad9bYYVR0blL1BBh5Ymr6I+D1al1Ktl0rkEccu9td6fh0U
         8fmcrn65Jn7c5g8rPWPx0fiMinIzpaeRr0a3u0EEIpfmJQEbtguDXJPqWDfJREBNqUZ+
         GYi8dBxNG/OQD9IzDP5/ClneXe/eURcr49Ss1DSUpCnSkfTXGxT3481oza4vhClysJ68
         dN0HvcazjlNPQvR1GMc+e7hHvuvNLT2+vHFM4rrzNgyhlgPnwuQicKRd76oFqsqMlUMS
         3i/EPRNqFHB3KaREZ56iv58CEwqd0O9RU+IXHh82hLeTm962ihACwXUHkRKhuOsWwAxF
         09/g==
X-Gm-Message-State: ABuFfogUVbboTJm1EB52Z2e4o0UjmTCWSOXOZMHXWSQYesGP8Ldyem2R
        qs2tEkjnxQPMRM1zqdVfNuIu4w==
X-Google-Smtp-Source: ACcGV636Ly84LvG1hbLb/azZTpdXNsCfwIRgoh0Omqpx43j+8+eH0QfOzIESY7A95hivnQ2OTtGVgw==
X-Received: by 2002:adf:f4ce:: with SMTP id h14-v6mr11515255wrp.259.1538116852150;
        Thu, 27 Sep 2018 23:40:52 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:51 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 23/24] mt76x0: eeprom: load eeprom data from mtd by default
Date:   Fri, 28 Sep 2018 08:40:16 +0200
Message-Id: <20180928064017.26870-24-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.0

