Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1428C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72BB1214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfAJN10 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:27:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45648 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbfAJN10 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 08:27:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id t6so11316906wrr.12
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 05:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jwGTH4o3k0RMk3UtrudlTQuAXKZjqe9O0Us8XDUF2aQ=;
        b=sKw+ijont5mrzuYmXdcLp3yCM596wJLpkAIk9nnqKdka3EjQuxcpu7sDA8j8HvsbBt
         R6VwNiOJqGye8xt3RzyLUWptxq19YDg+W2hvdJnbNpPWyS0PY8EuuUztZ2fm4EswBEUS
         gv+PD93KlOttKq48wENqoaIe0yGucizohwawxByRXIiXdMILONtZEPQGhz6utokCoghq
         qvymbgxdpPqB7y7Y5lyyuBkrF85763Uox+vLutz3ktwA7BVkp0gCfkd1ah7g86nOXWni
         kDLAnH3TRK+aI47EuJmtDFBYmWyzzPzCevEWWbwdYEoNqNhS//8QXTg/tXgk95EodHB8
         e9Fw==
X-Gm-Message-State: AJcUukeyNJxgbKn9tSaMTJSf7Aupw9sJQPd7jVIPntRaN30j9R+YHtVO
        ZYhGbIrJnkm3ddTWiRB49cgH1w==
X-Google-Smtp-Source: ALg8bN7OqixElT4vrMBU/TjuUVH0zD8KFY26/5QGOtutO4f24IpuKHx3GLMn+r7cF0jgkGKaW27G/w==
X-Received: by 2002:adf:e8c1:: with SMTP id k1mr8749401wrn.104.1547126843852;
        Thu, 10 Jan 2019 05:27:23 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j3sm15942427wmb.39.2019.01.10.05.27.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jan 2019 05:27:22 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: add led support to mt76x0e driver
Date:   Thu, 10 Jan 2019 14:27:06 +0100
Message-Id: <927f29d64a774b79f3d548c9cc36c48077d596cd.1547126738.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547126738.git.lorenzo.bianconi@redhat.com>
References: <cover.1547126738.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02 led support in mt76x02-lib module in order to
add tpt led trigger to mt76x0e driver

Tested-by: LGA1150 <dqfext@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_regs.h | 23 ++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 59 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/mcu.h   | 23 --------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 54 -----------------
 4 files changed, 82 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index b8d1ffbac6b5..7401cb94fb72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -230,6 +230,29 @@
 #define MT_COM_REG2			0x0738
 #define MT_COM_REG3			0x073C
 
+#define MT_LED_CTRL			0x0770
+#define MT_LED_CTRL_REPLAY(_n)		BIT(0 + (8 * (_n)))
+#define MT_LED_CTRL_POLARITY(_n)	BIT(1 + (8 * (_n)))
+#define MT_LED_CTRL_TX_BLINK_MODE(_n)	BIT(2 + (8 * (_n)))
+#define MT_LED_CTRL_KICK(_n)		BIT(7 + (8 * (_n)))
+
+#define MT_LED_TX_BLINK_0		0x0774
+#define MT_LED_TX_BLINK_1		0x0778
+
+#define MT_LED_S0_BASE			0x077C
+#define MT_LED_S0(_n)			(MT_LED_S0_BASE + 8 * (_n))
+#define MT_LED_S1_BASE			0x0780
+#define MT_LED_S1(_n)			(MT_LED_S1_BASE + 8 * (_n))
+#define MT_LED_STATUS_OFF_MASK		GENMASK(31, 24)
+#define MT_LED_STATUS_OFF(_v)		(((_v) << __ffs(MT_LED_STATUS_OFF_MASK)) & \
+					 MT_LED_STATUS_OFF_MASK)
+#define MT_LED_STATUS_ON_MASK		GENMASK(23, 16)
+#define MT_LED_STATUS_ON(_v)		(((_v) << __ffs(MT_LED_STATUS_ON_MASK)) & \
+					 MT_LED_STATUS_ON_MASK)
+#define MT_LED_STATUS_DURATION_MASK	GENMASK(15, 8)
+#define MT_LED_STATUS_DURATION(_v)	(((_v) << __ffs(MT_LED_STATUS_DURATION_MASK)) & \
+					 MT_LED_STATUS_DURATION_MASK)
+
 #define MT_FCE_PSE_CTRL			0x0800
 #define MT_FCE_PARAMETERS		0x0804
 #define MT_FCE_CSO			0x0808
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3c878f18e05d..d80c8eb5a0ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -75,6 +75,58 @@ static const struct ieee80211_iface_combination mt76x02_if_comb[] = {
 	}
 };
 
+static void
+mt76x02_led_set_config(struct mt76_dev *mdev, u8 delay_on,
+		       u8 delay_off)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev,
+					       mt76);
+	u32 val;
+
+	val = MT_LED_STATUS_DURATION(0xff) |
+	      MT_LED_STATUS_OFF(delay_off) |
+	      MT_LED_STATUS_ON(delay_on);
+
+	mt76_wr(dev, MT_LED_S0(mdev->led_pin), val);
+	mt76_wr(dev, MT_LED_S1(mdev->led_pin), val);
+
+	val = MT_LED_CTRL_REPLAY(mdev->led_pin) |
+	      MT_LED_CTRL_KICK(mdev->led_pin);
+	if (mdev->led_al)
+		val |= MT_LED_CTRL_POLARITY(mdev->led_pin);
+	mt76_wr(dev, MT_LED_CTRL, val);
+}
+
+static int
+mt76x02_led_set_blink(struct led_classdev *led_cdev,
+		      unsigned long *delay_on,
+		      unsigned long *delay_off)
+{
+	struct mt76_dev *mdev = container_of(led_cdev, struct mt76_dev,
+					     led_cdev);
+	u8 delta_on, delta_off;
+
+	delta_off = max_t(u8, *delay_off / 10, 1);
+	delta_on = max_t(u8, *delay_on / 10, 1);
+
+	mt76x02_led_set_config(mdev, delta_on, delta_off);
+
+	return 0;
+}
+
+static void
+mt76x02_led_set_brightness(struct led_classdev *led_cdev,
+			   enum led_brightness brightness)
+{
+	struct mt76_dev *mdev = container_of(led_cdev, struct mt76_dev,
+					     led_cdev);
+
+	if (!brightness)
+		mt76x02_led_set_config(mdev, 0, 0xff);
+	else
+		mt76x02_led_set_config(mdev, 0xff, 0);
+}
+
 void mt76x02_init_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
@@ -109,6 +161,13 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 			BIT(NL80211_IFTYPE_ADHOC);
 
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+
+		/* init led callbacks */
+		if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+			dev->mt76.led_cdev.brightness_set =
+					mt76x02_led_set_brightness;
+			dev->mt76.led_cdev.blink_set = mt76x02_led_set_blink;
+		}
 	}
 
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
index acfa2b570c7c..40ef43926c06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
@@ -26,29 +26,6 @@
 #define MT_MCU_PCIE_REMAP_BASE2		0x0744
 #define MT_MCU_PCIE_REMAP_BASE3		0x0748
 
-#define MT_LED_CTRL			0x0770
-#define MT_LED_CTRL_REPLAY(_n)		BIT(0 + (8 * (_n)))
-#define MT_LED_CTRL_POLARITY(_n)	BIT(1 + (8 * (_n)))
-#define MT_LED_CTRL_TX_BLINK_MODE(_n)	BIT(2 + (8 * (_n)))
-#define MT_LED_CTRL_KICK(_n)		BIT(7 + (8 * (_n)))
-
-#define MT_LED_TX_BLINK_0		0x0774
-#define MT_LED_TX_BLINK_1		0x0778
-
-#define MT_LED_S0_BASE			0x077C
-#define MT_LED_S0(_n)			(MT_LED_S0_BASE + 8 * (_n))
-#define MT_LED_S1_BASE			0x0780
-#define MT_LED_S1(_n)			(MT_LED_S1_BASE + 8 * (_n))
-#define MT_LED_STATUS_OFF_MASK		GENMASK(31, 24)
-#define MT_LED_STATUS_OFF(_v)		(((_v) << __ffs(MT_LED_STATUS_OFF_MASK)) & \
-					 MT_LED_STATUS_OFF_MASK)
-#define MT_LED_STATUS_ON_MASK		GENMASK(23, 16)
-#define MT_LED_STATUS_ON(_v)		(((_v) << __ffs(MT_LED_STATUS_ON_MASK)) & \
-					 MT_LED_STATUS_ON_MASK)
-#define MT_LED_STATUS_DURATION_MASK	GENMASK(15, 8)
-#define MT_LED_STATUS_DURATION(_v)	(((_v) << __ffs(MT_LED_STATUS_DURATION_MASK)) & \
-					 MT_LED_STATUS_DURATION_MASK)
-
 #define MT_MCU_ROM_PATCH_OFFSET		0x80000
 #define MT_MCU_ROM_PATCH_ADDR		0x90000
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 34418e575542..4347d5e7a915 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -342,54 +342,6 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 	return dev;
 }
 
-static void mt76x2_led_set_config(struct mt76_dev *mt76, u8 delay_on,
-				  u8 delay_off)
-{
-	struct mt76x02_dev *dev = container_of(mt76, struct mt76x02_dev,
-					       mt76);
-	u32 val;
-
-	val = MT_LED_STATUS_DURATION(0xff) |
-	      MT_LED_STATUS_OFF(delay_off) |
-	      MT_LED_STATUS_ON(delay_on);
-
-	mt76_wr(dev, MT_LED_S0(mt76->led_pin), val);
-	mt76_wr(dev, MT_LED_S1(mt76->led_pin), val);
-
-	val = MT_LED_CTRL_REPLAY(mt76->led_pin) |
-	      MT_LED_CTRL_KICK(mt76->led_pin);
-	if (mt76->led_al)
-		val |= MT_LED_CTRL_POLARITY(mt76->led_pin);
-	mt76_wr(dev, MT_LED_CTRL, val);
-}
-
-static int mt76x2_led_set_blink(struct led_classdev *led_cdev,
-				unsigned long *delay_on,
-				unsigned long *delay_off)
-{
-	struct mt76_dev *mt76 = container_of(led_cdev, struct mt76_dev,
-					     led_cdev);
-	u8 delta_on, delta_off;
-
-	delta_off = max_t(u8, *delay_off / 10, 1);
-	delta_on = max_t(u8, *delay_on / 10, 1);
-
-	mt76x2_led_set_config(mt76, delta_on, delta_off);
-	return 0;
-}
-
-static void mt76x2_led_set_brightness(struct led_classdev *led_cdev,
-				      enum led_brightness brightness)
-{
-	struct mt76_dev *mt76 = container_of(led_cdev, struct mt76_dev,
-					     led_cdev);
-
-	if (!brightness)
-		mt76x2_led_set_config(mt76, 0, 0xff);
-	else
-		mt76x2_led_set_config(mt76, 0xff, 0);
-}
-
 int mt76x2_register_device(struct mt76x02_dev *dev)
 {
 	int ret;
@@ -404,12 +356,6 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 
 	mt76x02_config_mac_addr_list(dev);
 
-	/* init led callbacks */
-	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
-		dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
-		dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
-	}
-
 	ret = mt76_register_device(&dev->mt76, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (ret)
-- 
2.20.1

