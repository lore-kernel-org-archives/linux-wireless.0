Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6264C7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CAF2064E
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89CAF2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbeJOCKE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 22:10:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37988 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbeJOCKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 22:10:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id a13-v6so18712939wrt.5
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 11:28:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QaAzJn+XF15fSV9+3wre1sFv2odJXAM6TgFyr9p8hts=;
        b=AR+AHxk64baOXfUmGSguKmoN3HJznRJcxxZt3P7HwmqsWOl+azkb6MDxTzuDau/qsZ
         CdfdzGjjtNGwkLNIjil7uvlDLpe3sH182VZXrs0Q43d/4bpeJRn8DvWNAQ92k62Lbzt2
         7b3oFwo4K1QlMeojEdrBj/bS9vJHcFLxiGtASxM1gOFVKTMh2ATV2a8kSL/WN6pdlvAk
         wxhYO2fLgA2Fm4C90S7mjx5iOeaNUZ3uDxbx6HuSxYyw6WNC85tQxrldfJvvGUsOsLkM
         FH4RcYcloEB0j+hDIkROIcy9fIXsMrvZUtgHD2/KF52X0/j3dKODqqhzSZZexUr4QyzJ
         bUgw==
X-Gm-Message-State: ABuFfogBeW3QJGVfjbj6r2VepObuuddezF+iHIHZrzGR3sUhztAl8IFc
        KuRUISp+7G5T8e9nJa4GiVFN2Q==
X-Google-Smtp-Source: ACcGV62/++EmyrqyMNtToBCp8LRYMlR4RAYLwc69mOAjlWIHAdYsM7LXAWpCsSoy34egTgHzO7e/PQ==
X-Received: by 2002:a5d:4cc3:: with SMTP id c3-v6mr12417240wrt.75.1539541689075;
        Sun, 14 Oct 2018 11:28:09 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id s7-v6sm15439321wmd.0.2018.10.14.11.28.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 11:28:08 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] mt76x2u: align channel gain logic to mt76x2 one
Date:   Sun, 14 Oct 2018 20:27:28 +0200
Message-Id: <a3a9b224bd4f86cb781989977a7cb331eae09366.1539541196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539541196.git.lorenzo.bianconi@redhat.com>
References: <cover.1539541196.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update vga tuning algorithm to the one used in mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |   1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |  21 ----
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  90 --------------
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 111 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  24 ----
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  41 +------
 8 files changed, 114 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
index 3cb9d1864286..a11babbf292d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
@@ -19,7 +19,6 @@
 
 void mt76x2_dfs_init_params(struct mt76x02_dev *dev);
 void mt76x2_dfs_init_detector(struct mt76x02_dev *dev);
-void mt76x2_dfs_adjust_agc(struct mt76x02_dev *dev);
 void mt76x2_dfs_set_domain(struct mt76x02_dev *dev,
 			   enum nl80211_dfs_regions region);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index b546fe83a40d..be0ae24d310a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -98,5 +98,6 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw);
 void mt76x2_apply_gain_adj(struct mt76x02_dev *dev);
+void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 6e932b5010ef..833974de5c80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -46,8 +46,6 @@ void mt76x2u_phy_calibrate(struct work_struct *work);
 void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev);
 
 void mt76x2u_mcu_complete_urb(struct urb *urb);
-int mt76x2u_mcu_set_dynamic_vga(struct mt76x02_dev *dev, u8 channel, bool ap,
-				bool ext, int rssi, u32 false_cca);
 int mt76x2u_mcu_init(struct mt76x02_dev *dev);
 int mt76x2u_mcu_fw_init(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index b56febae8945..8d66952400a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -803,27 +803,6 @@ static void mt76x2_dfs_set_bbp_params(struct mt76x02_dev *dev)
 	mt76_wr(dev, 0x212c, 0x0c350001);
 }
 
-void mt76x2_dfs_adjust_agc(struct mt76x02_dev *dev)
-{
-	u32 agc_r8, agc_r4, val_r8, val_r4, dfs_r31;
-
-	agc_r8 = mt76_rr(dev, MT_BBP(AGC, 8));
-	agc_r4 = mt76_rr(dev, MT_BBP(AGC, 4));
-
-	val_r8 = (agc_r8 & 0x00007e00) >> 9;
-	val_r4 = agc_r4 & ~0x1f000000;
-	val_r4 += (((val_r8 + 1) >> 1) << 24);
-	mt76_wr(dev, MT_BBP(AGC, 4), val_r4);
-
-	dfs_r31 = FIELD_GET(MT_BBP_AGC_LNA_HIGH_GAIN, val_r4);
-	dfs_r31 += val_r8;
-	dfs_r31 -= (agc_r8 & 0x00000038) >> 3;
-	dfs_r31 = (dfs_r31 << 16) | 0x00000307;
-	mt76_wr(dev, MT_BBP(DFS, 31), dfs_r31);
-
-	mt76_wr(dev, MT_BBP(DFS, 32), 0x00040071);
-}
-
 void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 5bda44540225..16ff6c376373 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -124,96 +124,6 @@ void mt76x2_phy_set_antenna(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_BBP(AGC, 0), val);
 }
 
-static void
-mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
-{
-	u32 val;
-	u8 gain_val[2];
-
-	gain_val[0] = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
-	gain_val[1] = dev->cal.agc_gain_cur[1] - dev->cal.agc_gain_adjust;
-
-	if (dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
-		val = 0x1e42 << 16;
-	else
-		val = 0x1836 << 16;
-
-	val |= 0xf8;
-
-	mt76_wr(dev, MT_BBP(AGC, 8),
-		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain_val[0]));
-	mt76_wr(dev, MT_BBP(AGC, 9),
-		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain_val[1]));
-
-	if (dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR)
-		mt76x2_dfs_adjust_agc(dev);
-}
-
-static void
-mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
-{
-	u8 *gain = dev->cal.agc_gain_init;
-	u8 low_gain_delta, gain_delta;
-	bool gain_change;
-	int low_gain;
-	u32 val;
-
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
-
-	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
-		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
-
-	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
-	dev->cal.low_gain = low_gain;
-
-	if (!gain_change) {
-		if (mt76x02_phy_adjust_vga_gain(dev))
-			mt76x2_phy_set_gain_val(dev);
-		return;
-	}
-
-	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80) {
-		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560211);
-		val = mt76_rr(dev, MT_BBP(AGC, 26)) & ~0xf;
-		if (low_gain == 2)
-			val |= 0x3;
-		else
-			val |= 0x5;
-		mt76_wr(dev, MT_BBP(AGC, 26), val);
-	} else {
-		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
-	}
-
-	if (mt76x2_has_ext_lna(dev))
-		low_gain_delta = 10;
-	else
-		low_gain_delta = 14;
-
-	if (low_gain == 2) {
-		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
-		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
-		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
-		gain_delta = low_gain_delta;
-		dev->cal.agc_gain_adjust = 0;
-	} else {
-		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
-		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x10101014);
-		else
-			mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
-		mt76_wr(dev, MT_BBP(AGC, 37), 0x2121262C);
-		gain_delta = 0;
-		dev->cal.agc_gain_adjust = low_gain_delta;
-	}
-
-	dev->cal.agc_gain_cur[0] = gain[0] - gain_delta;
-	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
-	mt76x2_phy_set_gain_val(dev);
-
-	/* clear false CCA counters */
-	mt76_rr(dev, MT_RX_STAT_1);
-}
-
 int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			   struct cfg80211_chan_def *chandef)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index e9fff5b7f125..0f9f54569147 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -250,3 +250,114 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_tssi_compensate);
+
+static void mt76x2_phy_dfs_adjust_agc(struct mt76x02_dev *dev)
+{
+	u32 agc_r8, agc_r4, val_r8, val_r4, dfs_r31;
+
+	agc_r8 = mt76_rr(dev, MT_BBP(AGC, 8));
+	agc_r4 = mt76_rr(dev, MT_BBP(AGC, 4));
+
+	val_r8 = (agc_r8 & 0x00007e00) >> 9;
+	val_r4 = agc_r4 & ~0x1f000000;
+	val_r4 += (((val_r8 + 1) >> 1) << 24);
+	mt76_wr(dev, MT_BBP(AGC, 4), val_r4);
+
+	dfs_r31 = FIELD_GET(MT_BBP_AGC_LNA_HIGH_GAIN, val_r4);
+	dfs_r31 += val_r8;
+	dfs_r31 -= (agc_r8 & 0x00000038) >> 3;
+	dfs_r31 = (dfs_r31 << 16) | 0x00000307;
+	mt76_wr(dev, MT_BBP(DFS, 31), dfs_r31);
+
+	mt76_wr(dev, MT_BBP(DFS, 32), 0x00040071);
+}
+
+static void
+mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
+{
+	u32 val;
+	u8 gain_val[2];
+
+	gain_val[0] = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
+	gain_val[1] = dev->cal.agc_gain_cur[1] - dev->cal.agc_gain_adjust;
+
+	if (dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
+		val = 0x1e42 << 16;
+	else
+		val = 0x1836 << 16;
+
+	val |= 0xf8;
+
+	mt76_wr(dev, MT_BBP(AGC, 8),
+		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain_val[0]));
+	mt76_wr(dev, MT_BBP(AGC, 9),
+		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain_val[1]));
+
+	if (dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR)
+		mt76x2_phy_dfs_adjust_agc(dev);
+}
+
+void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
+{
+	u8 *gain = dev->cal.agc_gain_init;
+	u8 low_gain_delta, gain_delta;
+	bool gain_change;
+	int low_gain;
+	u32 val;
+
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
+
+	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
+		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
+
+	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	dev->cal.low_gain = low_gain;
+
+	if (!gain_change) {
+		if (mt76x02_phy_adjust_vga_gain(dev))
+			mt76x2_phy_set_gain_val(dev);
+		return;
+	}
+
+	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80) {
+		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560211);
+		val = mt76_rr(dev, MT_BBP(AGC, 26)) & ~0xf;
+		if (low_gain == 2)
+			val |= 0x3;
+		else
+			val |= 0x5;
+		mt76_wr(dev, MT_BBP(AGC, 26), val);
+	} else {
+		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
+	}
+
+	if (mt76x2_has_ext_lna(dev))
+		low_gain_delta = 10;
+	else
+		low_gain_delta = 14;
+
+	if (low_gain == 2) {
+		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
+		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
+		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
+		gain_delta = low_gain_delta;
+		dev->cal.agc_gain_adjust = 0;
+	} else {
+		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
+		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
+			mt76_wr(dev, MT_BBP(AGC, 35), 0x10101014);
+		else
+			mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
+		mt76_wr(dev, MT_BBP(AGC, 37), 0x2121262C);
+		gain_delta = 0;
+		dev->cal.agc_gain_adjust = low_gain_delta;
+	}
+
+	dev->cal.agc_gain_cur[0] = gain[0] - gain_delta;
+	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
+	mt76x2_phy_set_gain_val(dev);
+
+	/* clear false CCA counters */
+	mt76_rr(dev, MT_RX_STAT_1);
+}
+EXPORT_SYMBOL_GPL(mt76x2_phy_update_channel_gain);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index a40aa838b6b2..d6e3e663dd8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -29,30 +29,6 @@
 #define MT76U_MCU_DLM_OFFSET		0x110000
 #define MT76U_MCU_ROM_PATCH_OFFSET	0x90000
 
-int mt76x2u_mcu_set_dynamic_vga(struct mt76x02_dev *dev, u8 channel, bool ap,
-				bool ext, int rssi, u32 false_cca)
-{
-	struct {
-		__le32 channel;
-		__le32 rssi_val;
-		__le32 false_cca_val;
-	} __packed __aligned(4) msg = {
-		.rssi_val = cpu_to_le32(rssi),
-		.false_cca_val = cpu_to_le32(false_cca),
-	};
-	struct sk_buff *skb;
-	u32 val = channel;
-
-	if (ap)
-		val |= BIT(31);
-	if (ext)
-		val |= BIT(30);
-	msg.channel = cpu_to_le32(val);
-
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_DYNC_VGA_OP, true);
-}
-
 static void mt76x2u_mcu_load_ivb(struct mt76x02_dev *dev)
 {
 	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index ca96ba60510e..8011c261c658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -39,51 +39,13 @@ void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 	mt76x2u_mac_resume(dev);
 }
 
-static void
-mt76x2u_phy_update_channel_gain(struct mt76x02_dev *dev)
-{
-	u8 channel = dev->mt76.chandef.chan->hw_value;
-	int freq, freq1;
-	u32 false_cca;
-
-	freq = dev->mt76.chandef.chan->center_freq;
-	freq1 = dev->mt76.chandef.center_freq1;
-
-	switch (dev->mt76.chandef.width) {
-	case NL80211_CHAN_WIDTH_80: {
-		int ch_group_index;
-
-		ch_group_index = (freq - freq1 + 30) / 20;
-		if (WARN_ON(ch_group_index < 0 || ch_group_index > 3))
-			ch_group_index = 0;
-		channel += 6 - ch_group_index * 4;
-		break;
-	}
-	case NL80211_CHAN_WIDTH_40:
-		if (freq1 > freq)
-			channel += 2;
-		else
-			channel -= 2;
-		break;
-	default:
-		break;
-	}
-
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
-	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS,
-			      mt76_rr(dev, MT_RX_STAT_1));
-
-	mt76x2u_mcu_set_dynamic_vga(dev, channel, false, false,
-				    dev->cal.avg_rssi_all, false_cca);
-}
-
 void mt76x2u_phy_calibrate(struct work_struct *work)
 {
 	struct mt76x02_dev *dev;
 
 	dev = container_of(work, struct mt76x02_dev, cal_work.work);
 	mt76x2_phy_tssi_compensate(dev, false);
-	mt76x2u_phy_update_channel_gain(dev);
+	mt76x2_phy_update_channel_gain(dev);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
@@ -202,6 +164,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
+	mt76x02_init_agc_gain(dev);
 	if (mt76x2_tssi_enabled(dev)) {
 		/* init default values for temp compensation */
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
-- 
2.19.0

