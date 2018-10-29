Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DB8C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58652082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D58652082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJ3GWE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:22:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37749 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJ3GWE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:22:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id p2-v6so9381614wmc.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 14:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5EExLsfSsLL16cZ82uQQ74hDAaqd/FSsvicLoRtrkbQ=;
        b=V2D0abjY15l50L4GylDKH1N8UpyddfuxG5L/fLxt+upTjW/Kkh/jCC6Wf19KGzQI75
         z2rM3lLitP0lqnxfDpCnfFONPEyvk0pXYdCf+tONjBwONQoEm7MnT2x71mDdJXclWNNu
         Vmc4/k/Sf0WEjOHatMyBC3VpgVZTmaOal6ZIOiyDc0SZtt/gIkJUO7CPLOc0whqjEyz0
         KKjz9O2FAJEZbVVqr/kR3McM83W7Qd4Y+GkSuG0MI20EhcK509h5tjLVwsD+H/qk7xD+
         6y17O3tVzcSW5IN8zwVzhFxOUAUfjKo93JMUesTeXiA2YbqkWfFxOcRdyNKxPqa1iYDz
         UN4w==
X-Gm-Message-State: AGRZ1gIy/kkn2mMIVOxpkux3it4QzHJZ4UVTdfcyIr7lBomi3ftuwiiT
        x5kTcHPGikcCmnABTv6PS7PLAT+Hwb8=
X-Google-Smtp-Source: AJdET5dLphd5HmesEY7e5xjpjgvzO7LVYcuaN67kmAiADXDVxHQttheHXG/k2mEuV9S2UnSmsAvw2Q==
X-Received: by 2002:a1c:3d03:: with SMTP id k3-v6mr8658762wma.90.1540848693164;
        Mon, 29 Oct 2018 14:31:33 -0700 (PDT)
Received: from localhost.localdomain ([151.66.3.112])
        by smtp.gmail.com with ESMTPSA id c18-v6sm14814981wrr.74.2018.10.29.14.31.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 14:31:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: move mt76x02_eeprom_copy in mt76x02-lib module
Date:   Mon, 29 Oct 2018 22:31:23 +0100
Message-Id: <193b3abe6007e2e16cb31446299937b205baf661.1540848411.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
References: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_eeprom_copy utility routine in mt76x02-lib module
in order to be reused by mt76x0 driver adding tssi calibration
support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c   | 12 ++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h   |  3 +++
 .../net/wireless/mediatek/mt76/mt76x2/eeprom.c    | 15 ++-------------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index 9390de2a323e..07f0496d828a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -53,6 +53,18 @@ mt76x02_efuse_read(struct mt76x02_dev *dev, u16 addr, u8 *data,
 	return 0;
 }
 
+int mt76x02_eeprom_copy(struct mt76x02_dev *dev,
+			enum mt76x02_eeprom_field field,
+			void *dest, int len)
+{
+	if (field + len > dev->mt76.eeprom.size)
+		return -1;
+
+	memcpy(dest, dev->mt76.eeprom.data + field, len);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_eeprom_copy);
+
 int mt76x02_get_efuse_data(struct mt76x02_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 1de041590050..5db01bda64b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -188,5 +188,8 @@ u8 mt76x02_get_lna_gain(struct mt76x02_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan);
 void mt76x02_eeprom_parse_hw_cap(struct mt76x02_dev *dev);
+int mt76x02_eeprom_copy(struct mt76x02_dev *dev,
+			enum mt76x02_eeprom_field field,
+			void *dest, int len);
 
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index f39b622d03f4..6f6998561d9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -21,17 +21,6 @@
 
 #define EE_FIELD(_name, _value) [MT_EE_##_name] = (_value) | 1
 
-static int
-mt76x2_eeprom_copy(struct mt76x02_dev *dev, enum mt76x02_eeprom_field field,
-		   void *dest, int len)
-{
-	if (field + len > dev->mt76.eeprom.size)
-		return -1;
-
-	memcpy(dest, dev->mt76.eeprom.data + field, len);
-	return 0;
-}
-
 static int
 mt76x2_eeprom_get_macaddr(struct mt76x02_dev *dev)
 {
@@ -378,7 +367,7 @@ mt76x2_get_power_info_2g(struct mt76x02_dev *dev,
 	else
 		delta_idx = 5;
 
-	mt76x2_eeprom_copy(dev, offset, data, sizeof(data));
+	mt76x02_eeprom_copy(dev, offset, data, sizeof(data));
 
 	t->chain[chain].tssi_slope = data[0];
 	t->chain[chain].tssi_offset = data[1];
@@ -429,7 +418,7 @@ mt76x2_get_power_info_5g(struct mt76x02_dev *dev,
 	else
 		delta_idx = 4;
 
-	mt76x2_eeprom_copy(dev, offset, data, sizeof(data));
+	mt76x02_eeprom_copy(dev, offset, data, sizeof(data));
 
 	t->chain[chain].tssi_slope = data[0];
 	t->chain[chain].tssi_offset = data[1];
-- 
2.19.1

