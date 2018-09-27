Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9FEC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DB12156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0DB12156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbeI0PTm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:42 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:36653 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbeI0PTl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:41 -0400
Received: by mail-wm1-f45.google.com with SMTP id n23-v6so1216376wmc.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DLdbYEjA+D377wnWsUVe4qu1NerUReHy/V/6pNppyA4=;
        b=abzwE3sdkJSIa82Zo1iPuUVWT5xm/njIze5nL5wMMPt0xLUyffGlgi0FW+aayzra0w
         0Y+VlnJczfs/5qKahfsFCP5CGXKMPs4bt0V9gdaSoruBdE3HJQut8TTHn0o3YuGgunW5
         zsMq8bZfEHwu2nw4bxsGaK+0/JtzykfY7zA4SAJ9KaYBj2IhEWXxJwqRTJ4K0KuZGC0A
         g2Qj+PFrKY3mjocy1IWfPiSLKsGA34exuu26P8oK2OAjxoIV9TkxHQ78RDrT8O7HUksV
         6IFayPcbbGr1FV6XCvN04yryhyQy77e0egR7OeCvRCrsO+BMk52hRhJmD1CGnkCgRCTd
         LmPg==
X-Gm-Message-State: ABuFfohPHLN6F7KP4J6DjOOILsGVNIXMdsZB9WBkaqDDr2fsJc3uOtzd
        NM0KHTRndL9Dua4/W58r1voutQ==
X-Google-Smtp-Source: ACcGV63ijfqRNky1eA/ZY8lKIVAKbL71h2Yqyw1yqybv1EjeYTYQlV+JBLwkQoRQaN5siQ1LIAI1Lg==
X-Received: by 2002:a1c:4182:: with SMTP id o124-v6mr7497533wma.101.1538038946116;
        Thu, 27 Sep 2018 02:02:26 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 25/26] mt76: move eeprom_load routines in mt76x02_eeprom.c
Date:   Thu, 27 Sep 2018 11:01:54 +0200
Message-Id: <d2fdb4a39ed2b274c2661ce6f24c0e5851f30885.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_eeprom_load, mt76x02_check_eeprom,
mt76x02_apply_cal_free_data and mt76x02_has_cal_free_data
in mt76x02-lib module since they will be used to load
mt76x0e eeprom data

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 152 +++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   1 +
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 157 +-----------------
 3 files changed, 154 insertions(+), 156 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index d3efeb8a72b7..f2a4dca3e05e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -154,3 +154,155 @@ u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
 	return lna != 0xff ? lna : 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_lna_gain);
+
+static bool mt76x02_has_cal_free_data(u8 *efuse)
+{
+	u16 *efuse_w = (u16 *) efuse;
+
+	if (efuse_w[MT_EE_NIC_CONF_0] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_XTAL_TRIM_1] == 0xffff)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_DELTA_BW40] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_START_2G] == 0xffff)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE] == 0xffff)
+		return false;
+
+	return true;
+}
+
+static void mt76x02_apply_cal_free_data(struct mt76_dev *dev, u8 *efuse)
+{
+#define GROUP_5G(_id)							   \
+	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
+	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1, \
+	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
+	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1
+
+	static const u8 cal_free_bytes[] = {
+		MT_EE_XTAL_TRIM_1,
+		MT_EE_TX_POWER_EXT_PA_5G + 1,
+		MT_EE_TX_POWER_0_START_2G,
+		MT_EE_TX_POWER_0_START_2G + 1,
+		MT_EE_TX_POWER_1_START_2G,
+		MT_EE_TX_POWER_1_START_2G + 1,
+		GROUP_5G(0),
+		GROUP_5G(1),
+		GROUP_5G(2),
+		GROUP_5G(3),
+		GROUP_5G(4),
+		GROUP_5G(5),
+		MT_EE_RF_2G_TSSI_OFF_TXPOWER,
+		MT_EE_RF_2G_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN + 1,
+	};
+	u8 *eeprom = dev->eeprom.data;
+	u8 prev_grp0[4] = {
+		eeprom[MT_EE_TX_POWER_0_START_5G],
+		eeprom[MT_EE_TX_POWER_0_START_5G + 1],
+		eeprom[MT_EE_TX_POWER_1_START_5G],
+		eeprom[MT_EE_TX_POWER_1_START_5G + 1]
+	};
+	u16 val;
+	int i;
+
+	if (!mt76x02_has_cal_free_data(efuse))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(cal_free_bytes); i++) {
+		int offset = cal_free_bytes[i];
+
+		eeprom[offset] = efuse[offset];
+	}
+
+	if (!(efuse[MT_EE_TX_POWER_0_START_5G] |
+	      efuse[MT_EE_TX_POWER_0_START_5G + 1]))
+		memcpy(eeprom + MT_EE_TX_POWER_0_START_5G, prev_grp0, 2);
+	if (!(efuse[MT_EE_TX_POWER_1_START_5G] |
+	      efuse[MT_EE_TX_POWER_1_START_5G + 1]))
+		memcpy(eeprom + MT_EE_TX_POWER_1_START_5G, prev_grp0 + 2, 2);
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_RCAL_RESULT);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_RCAL_RESULT] = val & 0xff;
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_VCDL_CALIBRATION);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_VCDL_CALIBRATION + 1] = val >> 8;
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_PMUCFG);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_PMUCFG] = val & 0xff;
+}
+
+static int mt76x02_check_eeprom(struct mt76_dev *dev)
+{
+	u16 val = get_unaligned_le16(dev->eeprom.data);
+
+	if (!val)
+		val = get_unaligned_le16(dev->eeprom.data + MT_EE_PCI_ID);
+
+	switch (val) {
+	case 0x7662:
+	case 0x7612:
+		return 0;
+	default:
+		dev_err(dev->dev, "EEPROM data check failed: %04x\n", val);
+		return -EINVAL;
+	}
+}
+
+int mt76x02_eeprom_load(struct mt76_dev *dev, int eeprom_size)
+{
+	void *efuse;
+	bool found;
+	int ret;
+
+	ret = mt76_eeprom_init(dev, eeprom_size);
+	if (ret < 0)
+		return ret;
+
+	found = ret;
+	if (found)
+		found = !mt76x02_check_eeprom(dev);
+
+	dev->otp.data = devm_kzalloc(dev->dev, eeprom_size, GFP_KERNEL);
+	dev->otp.size = eeprom_size;
+	if (!dev->otp.data)
+		return -ENOMEM;
+
+	efuse = dev->otp.data;
+
+	if (mt76x02_get_efuse_data(dev, 0, efuse, eeprom_size,
+				   MT_EE_READ))
+		goto out;
+
+	if (found) {
+		mt76x02_apply_cal_free_data(dev, efuse);
+	} else {
+		/* FIXME: check if efuse data is complete */
+		found = true;
+		memcpy(dev->eeprom.data, efuse, eeprom_size);
+	}
+
+out:
+	if (!found)
+		return -ENOENT;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_eeprom_load);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index bcd05f7c5f45..330b3a42aaa8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -207,5 +207,6 @@ u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan);
 void mt76x02_eeprom_parse_hw_cap(struct mt76_dev *dev);
+int mt76x02_eeprom_load(struct mt76_dev *dev, int eeprom_size);
 
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 136faa4066a5..d37f5aa84c83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -41,161 +41,6 @@ mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
 	return 0;
 }
 
-static bool
-mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
-{
-	u16 *efuse_w = (u16 *) efuse;
-
-	if (efuse_w[MT_EE_NIC_CONF_0] != 0)
-		return false;
-
-	if (efuse_w[MT_EE_XTAL_TRIM_1] == 0xffff)
-		return false;
-
-	if (efuse_w[MT_EE_TX_POWER_DELTA_BW40] != 0)
-		return false;
-
-	if (efuse_w[MT_EE_TX_POWER_0_START_2G] == 0xffff)
-		return false;
-
-	if (efuse_w[MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA] != 0)
-		return false;
-
-	if (efuse_w[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE] == 0xffff)
-		return false;
-
-	return true;
-}
-
-static void
-mt76x2_apply_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
-{
-#define GROUP_5G(_id)							   \
-	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
-	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1, \
-	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
-	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1
-
-	static const u8 cal_free_bytes[] = {
-		MT_EE_XTAL_TRIM_1,
-		MT_EE_TX_POWER_EXT_PA_5G + 1,
-		MT_EE_TX_POWER_0_START_2G,
-		MT_EE_TX_POWER_0_START_2G + 1,
-		MT_EE_TX_POWER_1_START_2G,
-		MT_EE_TX_POWER_1_START_2G + 1,
-		GROUP_5G(0),
-		GROUP_5G(1),
-		GROUP_5G(2),
-		GROUP_5G(3),
-		GROUP_5G(4),
-		GROUP_5G(5),
-		MT_EE_RF_2G_TSSI_OFF_TXPOWER,
-		MT_EE_RF_2G_RX_HIGH_GAIN + 1,
-		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN,
-		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN + 1,
-		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN,
-		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN + 1,
-		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN,
-		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN + 1,
-	};
-	u8 *eeprom = dev->mt76.eeprom.data;
-	u8 prev_grp0[4] = {
-		eeprom[MT_EE_TX_POWER_0_START_5G],
-		eeprom[MT_EE_TX_POWER_0_START_5G + 1],
-		eeprom[MT_EE_TX_POWER_1_START_5G],
-		eeprom[MT_EE_TX_POWER_1_START_5G + 1]
-	};
-	u16 val;
-	int i;
-
-	if (!mt76x2_has_cal_free_data(dev, efuse))
-		return;
-
-	for (i = 0; i < ARRAY_SIZE(cal_free_bytes); i++) {
-		int offset = cal_free_bytes[i];
-
-		eeprom[offset] = efuse[offset];
-	}
-
-	if (!(efuse[MT_EE_TX_POWER_0_START_5G] |
-	      efuse[MT_EE_TX_POWER_0_START_5G + 1]))
-		memcpy(eeprom + MT_EE_TX_POWER_0_START_5G, prev_grp0, 2);
-	if (!(efuse[MT_EE_TX_POWER_1_START_5G] |
-	      efuse[MT_EE_TX_POWER_1_START_5G + 1]))
-		memcpy(eeprom + MT_EE_TX_POWER_1_START_5G, prev_grp0 + 2, 2);
-
-	val = get_unaligned_le16(efuse + MT_EE_BT_RCAL_RESULT);
-	if (val != 0xffff)
-		eeprom[MT_EE_BT_RCAL_RESULT] = val & 0xff;
-
-	val = get_unaligned_le16(efuse + MT_EE_BT_VCDL_CALIBRATION);
-	if (val != 0xffff)
-		eeprom[MT_EE_BT_VCDL_CALIBRATION + 1] = val >> 8;
-
-	val = get_unaligned_le16(efuse + MT_EE_BT_PMUCFG);
-	if (val != 0xffff)
-		eeprom[MT_EE_BT_PMUCFG] = val & 0xff;
-}
-
-static int mt76x2_check_eeprom(struct mt76x2_dev *dev)
-{
-	u16 val = get_unaligned_le16(dev->mt76.eeprom.data);
-
-	if (!val)
-		val = get_unaligned_le16(dev->mt76.eeprom.data + MT_EE_PCI_ID);
-
-	switch (val) {
-	case 0x7662:
-	case 0x7612:
-		return 0;
-	default:
-		dev_err(dev->mt76.dev, "EEPROM data check failed: %04x\n", val);
-		return -EINVAL;
-	}
-}
-
-static int
-mt76x2_eeprom_load(struct mt76x2_dev *dev)
-{
-	void *efuse;
-	bool found;
-	int ret;
-
-	ret = mt76_eeprom_init(&dev->mt76, MT7662_EEPROM_SIZE);
-	if (ret < 0)
-		return ret;
-
-	found = ret;
-	if (found)
-		found = !mt76x2_check_eeprom(dev);
-
-	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, MT7662_EEPROM_SIZE,
-					  GFP_KERNEL);
-	dev->mt76.otp.size = MT7662_EEPROM_SIZE;
-	if (!dev->mt76.otp.data)
-		return -ENOMEM;
-
-	efuse = dev->mt76.otp.data;
-
-	if (mt76x02_get_efuse_data(&dev->mt76, 0, efuse,
-				   MT7662_EEPROM_SIZE, MT_EE_READ))
-		goto out;
-
-	if (found) {
-		mt76x2_apply_cal_free_data(dev, efuse);
-	} else {
-		/* FIXME: check if efuse data is complete */
-		found = true;
-		memcpy(dev->mt76.eeprom.data, efuse, MT7662_EEPROM_SIZE);
-	}
-
-out:
-	if (!found)
-		return -ENOENT;
-
-	return 0;
-}
-
 static void
 mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
 {
@@ -515,7 +360,7 @@ int mt76x2_eeprom_init(struct mt76x2_dev *dev)
 {
 	int ret;
 
-	ret = mt76x2_eeprom_load(dev);
+	ret = mt76x02_eeprom_load(&dev->mt76, MT7662_EEPROM_SIZE);
 	if (ret)
 		return ret;
 
-- 
2.17.1

