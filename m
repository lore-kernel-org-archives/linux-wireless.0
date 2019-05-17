Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D62C04AB4
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 21:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB6E2133D
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 21:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558128791;
	bh=HIgHkD6Qu/m6kAvuo9TQMy15ncawMvGhNHmWpuSUjGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p+O+I1P6OYAi0Em33rcZMm4EoAh+GM3+mEgVeKlz9CQU5c4KTPfsxHitpErZV26LG
	 B0UQLbmocpLLxaHgI1XzBwN3v0pA0JoUrMj8oHYACdx62bO4ySw1QNWy05RqSBdGxM
	 RA8rY04lXgbHVcuQ1lD/EuChsEyThXneo5H2dSeo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfEQVdL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 17:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfEQVdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 17:33:11 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D162087E;
        Fri, 17 May 2019 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558128790;
        bh=HIgHkD6Qu/m6kAvuo9TQMy15ncawMvGhNHmWpuSUjGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP1aVt0xqm/BzPa8xp912bJl7q7ylYAVzVis7alAdZyAg+WZX238jASn/G26btt/M
         yxzFBbkKDAwFP7krzamrEuyaVUfHYKnPHKE6Z2X35L3V15DPRo8b5CJglMaZRnRHfQ
         NT8uSU0FAfIm5dLEq+rqQ5DJgWmnbjjYRLG97voo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH] mt76: mt7615: select wifi band according to eeprom
Date:   Fri, 17 May 2019 23:32:56 +0200
Message-Id: <38aa977df45a92f60d78d9cb7e575289ccbaeef6.1558127930.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1558127930.git.lorenzo@kernel.org>
References: <cover.1558127930.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Select supported band according to the value read from
eeprom mtd/otp partition

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../wireless/mediatek/mt76/mt7615/eeprom.c    | 24 ++++++++++++++++---
 .../wireless/mediatek/mt76/mt7615/eeprom.h    |  9 +++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 1712f66520a8..714590878d65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -90,6 +90,26 @@ static int mt7615_check_eeprom(struct mt76_dev *dev)
 	}
 }
 
+static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
+{
+	u8 val, *eeprom = dev->mt76.eeprom.data;
+
+	val = FIELD_GET(MT_EE_NIC_WIFI_CONF_BAND_SEL,
+			eeprom[MT_EE_WIFI_CONF]);
+	switch (val) {
+	case MT_EE_5GHZ:
+		dev->mt76.cap.has_5ghz = true;
+		break;
+	case MT_EE_2GHZ:
+		dev->mt76.cap.has_2ghz = true;
+		break;
+	default:
+		dev->mt76.cap.has_2ghz = true;
+		dev->mt76.cap.has_5ghz = true;
+		break;
+	}
+}
+
 int mt7615_eeprom_init(struct mt7615_dev *dev)
 {
 	int ret;
@@ -103,9 +123,7 @@ int mt7615_eeprom_init(struct mt7615_dev *dev)
 		memcpy(dev->mt76.eeprom.data, dev->mt76.otp.data,
 		       MT7615_EEPROM_SIZE);
 
-	dev->mt76.cap.has_2ghz = true;
-	dev->mt76.cap.has_5ghz = true;
-
+	mt7615_eeprom_parse_hw_cap(dev);
 	memcpy(dev->mt76.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
 	       ETH_ALEN);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
index a4cf16688171..b422e395d6ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
@@ -11,8 +11,17 @@ enum mt7615_eeprom_field {
 	MT_EE_VERSION =				0x002,
 	MT_EE_MAC_ADDR =			0x004,
 	MT_EE_NIC_CONF_0 =			0x034,
+	MT_EE_WIFI_CONF =			0x03e,
 
 	__MT_EE_MAX =				0x3bf
 };
 
+#define MT_EE_NIC_WIFI_CONF_BAND_SEL		GENMASK(5, 4)
+enum mt7615_eeprom_band {
+	MT_EE_DUAL_BAND,
+	MT_EE_5GHZ,
+	MT_EE_2GHZ,
+	MT_EE_DBDC,
+};
+
 #endif
-- 
2.20.1

