Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D91C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D0720684
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44D0720684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbeJDTAH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:00:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43485 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbeJDTAH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:00:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1-v6so9635115wrt.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H+7tMFZdVMzUcGjEQ9sJIcKqfWnWO8fxWgYaiTRDrxA=;
        b=bYSLpS/rEjTU9wJa4yXR1QKBeMt+QK8dW+Misf+FfYJUcZqic43D/hGZhUQ8/KoYMv
         mJ8/0nwcoLqIK/K/EP78PlrT0jHyZHUuqKmMbLVcXWQOGxsPROulXBiw/CkCprzebXTW
         BXqr04tPfaxbGPPYDihQb06iOjsGGpixOA7wFyVz2giCiKsIsLklPzHOjEtC59PLODzB
         omG9I+kMnvLIPuKv+4nIikkzzXz7tB+n8uZcHLrbCJ2Pu11EIbbA9kB2YUXYpI1es0l9
         Dtsts/lRmrX6h54kP/dJLAppg09DHNKclafTHyebBEszWpKcLZTORYUOMBYW82o43VtY
         oDcw==
X-Gm-Message-State: ABuFfoi+PBppDqQJeGS4GaZGADDizMSy8PZbundiqUQ7/ojBM1UwCg3g
        +rjfvJkYRKznWJnGWH2YiPGBRA==
X-Google-Smtp-Source: ACcGV617B0WXGP8VWhHqOsE6WJCBGKSiwVMsBBKKq05rbeS7CXq1Q6Av5DoQGonhOWjF8E/cGkwrHA==
X-Received: by 2002:adf:fe0f:: with SMTP id n15-v6mr4366843wrr.71.1538654824953;
        Thu, 04 Oct 2018 05:07:04 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:07:03 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 7/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_eeprom.c
Date:   Thu,  4 Oct 2018 14:06:50 +0200
Message-Id: <77d08229298872236eb6f862b61c2347d36cc772.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
References: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_eeprom.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 50 ++++++------
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 33 ++++----
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 20 ++---
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    | 80 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |  5 +-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  8 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 12 +--
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   |  6 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  6 +-
 15 files changed, 112 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index bea1af7ffa73..1defb072ccbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -31,8 +31,8 @@ mt76x0_efuse_physical_size_check(struct mt76x02_dev *dev)
 	int ret, i;
 	u32 start = 0, end = 0, cnt_free;
 
-	ret = mt76x02_get_efuse_data(&dev->mt76, MT_EE_USAGE_MAP_START,
-				     data, sizeof(data), MT_EE_PHYSICAL_READ);
+	ret = mt76x02_get_efuse_data(dev, MT_EE_USAGE_MAP_START, data,
+				     sizeof(data), MT_EE_PHYSICAL_READ);
 	if (ret)
 		return ret;
 
@@ -55,10 +55,10 @@ mt76x0_efuse_physical_size_check(struct mt76x02_dev *dev)
 
 static void mt76x0_set_chip_cap(struct mt76x02_dev *dev)
 {
-	u16 nic_conf0 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
-	u16 nic_conf1 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
+	u16 nic_conf0 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
+	u16 nic_conf1 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1);
 
-	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
+	mt76x02_eeprom_parse_hw_cap(dev);
 	dev_dbg(dev->mt76.dev, "2GHz %d 5GHz %d\n",
 		dev->mt76.cap.has_2ghz, dev->mt76.cap.has_5ghz);
 
@@ -86,7 +86,7 @@ static void mt76x0_set_temp_offset(struct mt76x02_dev *dev)
 {
 	u8 val;
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_2G_TARGET_POWER) >> 8;
+	val = mt76x02_eeprom_get(dev, MT_EE_2G_TARGET_POWER) >> 8;
 	if (mt76x02_field_valid(val))
 		dev->cal.rx.temp_offset = mt76x02_sign_extend(val, 8);
 	else
@@ -98,12 +98,12 @@ static void mt76x0_set_freq_offset(struct mt76x02_dev *dev)
 	struct mt76x02_rx_freq_cal *caldata = &dev->cal.rx;
 	u8 val;
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_FREQ_OFFSET);
+	val = mt76x02_eeprom_get(dev, MT_EE_FREQ_OFFSET);
 	if (!mt76x02_field_valid(val))
 		val = 0;
 	caldata->freq_offset = val;
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TSSI_BOUND4) >> 8;
+	val = mt76x02_eeprom_get(dev, MT_EE_TSSI_BOUND4) >> 8;
 	if (!mt76x02_field_valid(val))
 		val = 0;
 
@@ -118,10 +118,8 @@ void mt76x0_read_rx_gain(struct mt76x02_dev *dev)
 	u16 rssi_offset;
 	int i;
 
-	mt76x02_get_rx_gain(&dev->mt76, chan->band, &rssi_offset,
-			    &lna_2g, lna_5g);
-	caldata->lna_gain = mt76x02_get_lna_gain(&dev->mt76, &lna_2g,
-						 lna_5g, chan);
+	mt76x02_get_rx_gain(dev, chan->band, &rssi_offset, &lna_2g, lna_5g);
+	caldata->lna_gain = mt76x02_get_lna_gain(dev, &lna_2g, lna_5g, chan);
 
 	for (i = 0; i < ARRAY_SIZE(caldata->rssi_offset); i++) {
 		val = rssi_offset >> (8 * i);
@@ -132,9 +130,9 @@ void mt76x0_read_rx_gain(struct mt76x02_dev *dev)
 	}
 }
 
-static s8 mt76x0_get_delta(struct mt76_dev *dev)
+static s8 mt76x0_get_delta(struct mt76x02_dev *dev)
 {
-	struct cfg80211_chan_def *chandef = &dev->chandef;
+	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	u8 val;
 
 	if (mt76x02_tssi_enabled(dev))
@@ -162,54 +160,54 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_2ghz = chan->band == NL80211_BAND_2GHZ;
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
-	s8 delta = mt76x0_get_delta(&dev->mt76);
+	s8 delta = mt76x0_get_delta(dev);
 	u16 val, addr;
 
 	memset(t, 0, sizeof(*t));
 
 	/* cck 1M, 2M, 5.5M, 11M */
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_BYRATE_BASE);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_BYRATE_BASE);
 	t->cck[0] = t->cck[1] = s6_to_s8(val);
 	t->cck[2] = t->cck[3] = s6_to_s8(val >> 8);
 
 	/* ofdm 6M, 9M, 12M, 18M */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 2 : 0x120;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->ofdm[0] = t->ofdm[1] = s6_to_s8(val);
 	t->ofdm[2] = t->ofdm[3] = s6_to_s8(val >> 8);
 
 	/* ofdm 24M, 36M, 48M, 54M */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 4 : 0x122;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->ofdm[4] = t->ofdm[5] = s6_to_s8(val);
 	t->ofdm[6] = t->ofdm[7] = s6_to_s8(val >> 8);
 
 	/* ht-vht mcs 1ss 0, 1, 2, 3 */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 6 : 0x124;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->ht[0] = t->ht[1] = t->vht[0] = t->vht[1] = s6_to_s8(val);
 	t->ht[2] = t->ht[3] = t->vht[2] = t->vht[3] = s6_to_s8(val >> 8);
 
 	/* ht-vht mcs 1ss 4, 5, 6 */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 8 : 0x126;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->ht[4] = t->ht[5] = t->vht[4] = t->vht[5] = s6_to_s8(val);
 	t->ht[6] = t->vht[6] = s6_to_s8(val >> 8);
 
 	/* ht-vht mcs 1ss 0, 1, 2, 3 stbc */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 14 : 0xec;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->stbc[0] = t->stbc[1] = s6_to_s8(val);
 	t->stbc[2] = t->stbc[3] = s6_to_s8(val >> 8);
 
 	/* ht-vht mcs 1ss 4, 5, 6 stbc */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 16 : 0xee;
-	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	val = mt76x02_eeprom_get(dev, addr);
 	t->stbc[4] = t->stbc[5] = s6_to_s8(val);
 	t->stbc[6] = t->stbc[7] = s6_to_s8(val >> 8);
 
 	/* vht mcs 8, 9 5GHz */
-	val = mt76x02_eeprom_get(&dev->mt76, 0x132);
+	val = mt76x02_eeprom_get(dev, 0x132);
 	t->vht[7] = s6_to_s8(val);
 	t->vht[8] = s6_to_s8(val >> 8);
 
@@ -266,7 +264,7 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 		addr = MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + offset;
 	}
 
-	data = mt76x02_eeprom_get(&dev->mt76, addr);
+	data = mt76x02_eeprom_get(dev, addr);
 
 	info[0] = data;
 	if (!info[0] || info[0] > 0x3f)
@@ -312,7 +310,7 @@ static int mt76x0_load_eeprom(struct mt76x02_dev *dev)
 	if (found < 0)
 		return found;
 
-	return mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
+	return mt76x02_get_efuse_data(dev, 0, dev->mt76.eeprom.data,
 				      MT76X0_EEPROM_SIZE, MT_EE_READ);
 }
 
@@ -326,7 +324,7 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	data = mt76x02_eeprom_get(&dev->mt76, MT_EE_VERSION);
+	data = mt76x02_eeprom_get(dev, MT_EE_VERSION);
 	version = data >> 8;
 	fae = data;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 3a5c7cd06265..b0e11d2203b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -102,7 +102,7 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 		u16 val;
 
 		mt76_clear(dev, MT_COEXCFG0, BIT(0));
-		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
+		val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
 		if (val & MT_EE_NIC_CONF_0_PA_IO_CURRENT) {
 			u32 data;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 376f2dbf013d..ba3b5847af48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -475,7 +475,7 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 	mt76_wr(dev, MT_RF_MISC, mac_reg);
 
 	band = (rf_band & RF_G_BAND) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
-	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
+	if (mt76x02_ext_pa_enabled(dev, band)) {
 		/*
 			MT_RF_MISC (offset: 0x0518)
 			[2]1'b1: enable external A band PA, 1'b0: disable external A band PA
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index d3efeb8a72b7..9390de2a323e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -17,46 +17,43 @@
 
 #include <asm/unaligned.h>
 
-#include "mt76.h"
 #include "mt76x02_eeprom.h"
-#include "mt76x02_regs.h"
 
 static int
-mt76x02_efuse_read(struct mt76_dev *dev, u16 addr, u8 *data,
+mt76x02_efuse_read(struct mt76x02_dev *dev, u16 addr, u8 *data,
 		   enum mt76x02_eeprom_modes mode)
 {
 	u32 val;
 	int i;
 
-	val = __mt76_rr(dev, MT_EFUSE_CTRL);
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
 	val &= ~(MT_EFUSE_CTRL_AIN |
 		 MT_EFUSE_CTRL_MODE);
 	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf);
 	val |= FIELD_PREP(MT_EFUSE_CTRL_MODE, mode);
 	val |= MT_EFUSE_CTRL_KICK;
-	__mt76_wr(dev, MT_EFUSE_CTRL, val);
+	mt76_wr(dev, MT_EFUSE_CTRL, val);
 
-	if (!__mt76_poll_msec(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK,
-			      0, 1000))
+	if (!mt76_poll_msec(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
 		return -ETIMEDOUT;
 
 	udelay(2);
 
-	val = __mt76_rr(dev, MT_EFUSE_CTRL);
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
 	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
 		memset(data, 0xff, 16);
 		return 0;
 	}
 
 	for (i = 0; i < 4; i++) {
-		val = __mt76_rr(dev, MT_EFUSE_DATA(i));
+		val = mt76_rr(dev, MT_EFUSE_DATA(i));
 		put_unaligned_le32(val, data + 4 * i);
 	}
 
 	return 0;
 }
 
-int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
+int mt76x02_get_efuse_data(struct mt76x02_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode)
 {
 	int ret, i;
@@ -71,26 +68,26 @@ int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_efuse_data);
 
-void mt76x02_eeprom_parse_hw_cap(struct mt76_dev *dev)
+void mt76x02_eeprom_parse_hw_cap(struct mt76x02_dev *dev)
 {
 	u16 val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
 
 	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, val)) {
 	case BOARD_TYPE_5GHZ:
-		dev->cap.has_5ghz = true;
+		dev->mt76.cap.has_5ghz = true;
 		break;
 	case BOARD_TYPE_2GHZ:
-		dev->cap.has_2ghz = true;
+		dev->mt76.cap.has_2ghz = true;
 		break;
 	default:
-		dev->cap.has_2ghz = true;
-		dev->cap.has_5ghz = true;
+		dev->mt76.cap.has_2ghz = true;
+		dev->mt76.cap.has_5ghz = true;
 		break;
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_eeprom_parse_hw_cap);
 
-bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band)
+bool mt76x02_ext_pa_enabled(struct mt76x02_dev *dev, enum nl80211_band band)
 {
 	u16 conf0 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
 
@@ -101,7 +98,7 @@ bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band)
 }
 EXPORT_SYMBOL_GPL(mt76x02_ext_pa_enabled);
 
-void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
+void mt76x02_get_rx_gain(struct mt76x02_dev *dev, enum nl80211_band band,
 			 u16 *rssi_offset, s8 *lna_2g, s8 *lna_5g)
 {
 	u16 val;
@@ -129,7 +126,7 @@ void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_rx_gain);
 
-u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
+u8 mt76x02_get_lna_gain(struct mt76x02_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index bcd05f7c5f45..0fba43d569b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -18,6 +18,8 @@
 #ifndef __MT76x02_EEPROM_H
 #define __MT76x02_EEPROM_H
 
+#include "mt76x02.h"
+
 enum mt76x02_eeprom_field {
 	MT_EE_CHIP_ID =				0x000,
 	MT_EE_VERSION =				0x002,
@@ -168,17 +170,17 @@ static inline s8 mt76x02_rate_power_val(u8 val)
 }
 
 static inline int
-mt76x02_eeprom_get(struct mt76_dev *dev,
+mt76x02_eeprom_get(struct mt76x02_dev *dev,
 		   enum mt76x02_eeprom_field field)
 {
 	if ((field & 1) || field >= __MT_EE_MAX)
 		return -1;
 
-	return get_unaligned_le16(dev->eeprom.data + field);
+	return get_unaligned_le16(dev->mt76.eeprom.data + field);
 }
 
 static inline bool
-mt76x02_temp_tx_alc_enabled(struct mt76_dev *dev)
+mt76x02_temp_tx_alc_enabled(struct mt76x02_dev *dev)
 {
 	u16 val;
 
@@ -191,21 +193,21 @@ mt76x02_temp_tx_alc_enabled(struct mt76_dev *dev)
 }
 
 static inline bool
-mt76x02_tssi_enabled(struct mt76_dev *dev)
+mt76x02_tssi_enabled(struct mt76x02_dev *dev)
 {
 	return !mt76x02_temp_tx_alc_enabled(dev) &&
 	       (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
 		MT_EE_NIC_CONF_1_TX_ALC_EN);
 }
 
-bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band);
-int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
+bool mt76x02_ext_pa_enabled(struct mt76x02_dev *dev, enum nl80211_band band);
+int mt76x02_get_efuse_data(struct mt76x02_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode);
-void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
+void mt76x02_get_rx_gain(struct mt76x02_dev *dev, enum nl80211_band band,
 			 u16 *rssi_offset, s8 *lna_2g, s8 *lna_5g);
-u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
+u8 mt76x02_get_lna_gain(struct mt76x02_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan);
-void mt76x02_eeprom_parse_hw_cap(struct mt76_dev *dev);
+void mt76x02_eeprom_parse_hw_cap(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index bbab021b5f1a..5fb9532f3eed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -177,8 +177,8 @@ mt76x2_eeprom_load(struct mt76x02_dev *dev)
 
 	efuse = dev->mt76.otp.data;
 
-	if (mt76x02_get_efuse_data(&dev->mt76, 0, efuse,
-				   MT7662_EEPROM_SIZE, MT_EE_READ))
+	if (mt76x02_get_efuse_data(dev, 0, efuse, MT7662_EEPROM_SIZE,
+				   MT_EE_READ))
 		goto out;
 
 	if (found) {
@@ -248,22 +248,22 @@ mt76x2_get_5g_rx_gain(struct mt76x02_dev *dev, u8 channel)
 	group = mt76x2_get_cal_channel_group(channel);
 	switch (group) {
 	case MT_CH_5G_JAPAN:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN);
 	case MT_CH_5G_UNII_1:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN) >> 8;
 	case MT_CH_5G_UNII_2:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN);
 	case MT_CH_5G_UNII_2E_1:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN) >> 8;
 	case MT_CH_5G_UNII_2E_2:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN);
 	default:
-		return mt76x02_eeprom_get(&dev->mt76,
+		return mt76x02_eeprom_get(dev,
 					  MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN) >> 8;
 	}
 }
@@ -277,14 +277,13 @@ void mt76x2_read_rx_gain(struct mt76x02_dev *dev)
 	u16 val;
 
 	if (chan->band == NL80211_BAND_2GHZ)
-		val = mt76x02_eeprom_get(&dev->mt76,
-					 MT_EE_RF_2G_RX_HIGH_GAIN) >> 8;
+		val = mt76x02_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN) >> 8;
 	else
 		val = mt76x2_get_5g_rx_gain(dev, channel);
 
 	mt76x2_set_rx_gain_group(dev, val);
 
-	mt76x02_get_rx_gain(&dev->mt76, chan->band, &val, &lna_2g, lna_5g);
+	mt76x02_get_rx_gain(dev, chan->band, &val, &lna_2g, lna_5g);
 	mt76x2_set_rssi_offset(dev, 0, val);
 	mt76x2_set_rssi_offset(dev, 1, val >> 8);
 
@@ -293,7 +292,7 @@ void mt76x2_read_rx_gain(struct mt76x02_dev *dev)
 	dev->cal.rx.mcu_gain |= (lna_5g[1] & 0xff) << 16;
 	dev->cal.rx.mcu_gain |= (lna_5g[2] & 0xff) << 24;
 
-	lna = mt76x02_get_lna_gain(&dev->mt76, &lna_2g, lna_5g, chan);
+	lna = mt76x02_get_lna_gain(dev, &lna_2g, lna_5g, chan);
 	dev->cal.rx.lna_gain = mt76x02_sign_extend(lna, 8);
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
@@ -308,53 +307,49 @@ void mt76x2_get_rate_power(struct mt76x02_dev *dev, struct mt76_rate_power *t,
 
 	memset(t, 0, sizeof(*t));
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_CCK);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_CCK);
 	t->cck[0] = t->cck[1] = mt76x02_rate_power_val(val);
 	t->cck[2] = t->cck[3] = mt76x02_rate_power_val(val >> 8);
 
 	if (is_5ghz)
-		val = mt76x02_eeprom_get(&dev->mt76,
-					 MT_EE_TX_POWER_OFDM_5G_6M);
+		val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_6M);
 	else
-		val = mt76x02_eeprom_get(&dev->mt76,
-					 MT_EE_TX_POWER_OFDM_2G_6M);
+		val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_6M);
 	t->ofdm[0] = t->ofdm[1] = mt76x02_rate_power_val(val);
 	t->ofdm[2] = t->ofdm[3] = mt76x02_rate_power_val(val >> 8);
 
 	if (is_5ghz)
-		val = mt76x02_eeprom_get(&dev->mt76,
-					 MT_EE_TX_POWER_OFDM_5G_24M);
+		val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_24M);
 	else
-		val = mt76x02_eeprom_get(&dev->mt76,
-					 MT_EE_TX_POWER_OFDM_2G_24M);
+		val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_24M);
 	t->ofdm[4] = t->ofdm[5] = mt76x02_rate_power_val(val);
 	t->ofdm[6] = t->ofdm[7] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS0);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS0);
 	t->ht[0] = t->ht[1] = mt76x02_rate_power_val(val);
 	t->ht[2] = t->ht[3] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS4);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS4);
 	t->ht[4] = t->ht[5] = mt76x02_rate_power_val(val);
 	t->ht[6] = t->ht[7] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS8);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS8);
 	t->ht[8] = t->ht[9] = mt76x02_rate_power_val(val);
 	t->ht[10] = t->ht[11] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS12);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS12);
 	t->ht[12] = t->ht[13] = mt76x02_rate_power_val(val);
 	t->ht[14] = t->ht[15] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS0);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS0);
 	t->vht[0] = t->vht[1] = mt76x02_rate_power_val(val);
 	t->vht[2] = t->vht[3] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS4);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS4);
 	t->vht[4] = t->vht[5] = mt76x02_rate_power_val(val);
 	t->vht[6] = t->vht[7] = mt76x02_rate_power_val(val >> 8);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS8);
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS8);
 	if (!is_5ghz)
 		val >>= 8;
 	t->vht[8] = t->vht[9] = mt76x02_rate_power_val(val >> 8);
@@ -390,7 +385,7 @@ mt76x2_get_power_info_2g(struct mt76x02_dev *dev,
 	t->chain[chain].target_power = data[2];
 	t->chain[chain].delta = mt76x02_sign_extend_optional(data[delta_idx], 7);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
+	val = mt76x02_eeprom_get(dev, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
 	t->target_power = val >> 8;
 }
 
@@ -441,7 +436,7 @@ mt76x2_get_power_info_5g(struct mt76x02_dev *dev,
 	t->chain[chain].target_power = data[2];
 	t->chain[chain].delta = mt76x02_sign_extend_optional(data[delta_idx], 7);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_RX_HIGH_GAIN);
+	val = mt76x02_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN);
 	t->target_power = val & 0xff;
 }
 
@@ -453,8 +448,8 @@ void mt76x2_get_power_info(struct mt76x02_dev *dev,
 
 	memset(t, 0, sizeof(*t));
 
-	bw40 = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_DELTA_BW40);
-	bw80 = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_DELTA_BW80);
+	bw40 = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
+	bw80 = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80);
 
 	if (chan->band == NL80211_BAND_5GHZ) {
 		bw40 >>= 8;
@@ -469,7 +464,7 @@ void mt76x2_get_power_info(struct mt76x02_dev *dev,
 					 MT_EE_TX_POWER_1_START_2G);
 	}
 
-	if (mt76x02_tssi_enabled(&dev->mt76) ||
+	if (mt76x02_tssi_enabled(dev) ||
 	    !mt76x02_field_valid(t->target_power))
 		t->target_power = t->chain[0].target_power;
 
@@ -486,23 +481,20 @@ int mt76x2_get_temp_comp(struct mt76x02_dev *dev, struct mt76x2_temp_comp *t)
 
 	memset(t, 0, sizeof(*t));
 
-	if (!mt76x02_temp_tx_alc_enabled(&dev->mt76))
+	if (!mt76x02_temp_tx_alc_enabled(dev))
 		return -EINVAL;
 
-	if (!mt76x02_ext_pa_enabled(&dev->mt76, band))
+	if (!mt76x02_ext_pa_enabled(dev, band))
 		return -EINVAL;
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
 	t->temp_25_ref = val & 0x7f;
 	if (band == NL80211_BAND_5GHZ) {
-		slope = mt76x02_eeprom_get(&dev->mt76,
-					   MT_EE_RF_TEMP_COMP_SLOPE_5G);
-		bounds = mt76x02_eeprom_get(&dev->mt76,
-					    MT_EE_TX_POWER_EXT_PA_5G);
+		slope = mt76x02_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_5G);
+		bounds = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
 	} else {
-		slope = mt76x02_eeprom_get(&dev->mt76,
-					   MT_EE_RF_TEMP_COMP_SLOPE_2G);
-		bounds = mt76x02_eeprom_get(&dev->mt76,
+		slope = mt76x02_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_2G);
+		bounds = mt76x02_eeprom_get(dev,
 					    MT_EE_TX_POWER_DELTA_BW80) >> 8;
 	}
 
@@ -523,7 +515,7 @@ int mt76x2_eeprom_init(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
+	mt76x02_eeprom_parse_hw_cap(dev);
 	mt76x2_eeprom_get_macaddr(dev);
 	mt76_eeprom_override(&dev->mt76);
 	dev->mt76.macaddr[0] &= ~BIT(1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
index c97b31c77d83..13bceb6aa5e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
@@ -62,7 +62,7 @@ void mt76x2_read_rx_gain(struct mt76x02_dev *dev);
 static inline bool
 mt76x2_has_ext_lna(struct mt76x02_dev *dev)
 {
-	u32 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
+	u32 val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1);
 
 	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ)
 		return val & MT_EE_NIC_CONF_1_LNA_EXT_2G;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
index 134037a227d7..88bd62cfbdf9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
@@ -59,7 +59,6 @@ EXPORT_SYMBOL_GPL(mt76x2_mcu_set_channel);
 int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 		       u8 channel)
 {
-	struct mt76_dev *mdev = &dev->mt76;
 	struct sk_buff *skb;
 	struct {
 		u8 cr_mode;
@@ -76,8 +75,8 @@ int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 	u32 val;
 
 	val = BIT(31);
-	val |= (mt76x02_eeprom_get(mdev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
-	val |= (mt76x02_eeprom_get(mdev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
+	val |= (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
+	val |= (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
 	msg.cfg = cpu_to_le32(val);
 
 	/* first set the channel without the extension channel info */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 4e920c71cee9..3824290b219d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -43,7 +43,7 @@ mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 	u16 eep_val;
 	s8 offset = 0;
 
-	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_2);
+	eep_val = mt76x02_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
 
 	offset = eep_val & 0x7f;
 	if ((eep_val & 0xff) == 0xff)
@@ -53,7 +53,7 @@ mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 
 	eep_val >>= 8;
 	if (eep_val == 0x00 || eep_val == 0xff) {
-		eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_1);
+		eep_val = mt76x02_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
 		eep_val &= 0xff;
 
 		if (eep_val == 0x00 || eep_val == 0xff)
@@ -64,7 +64,7 @@ mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 	mt76_rmw_field(dev, MT_XO_CTRL5, MT_XO_CTRL5_C2_VAL, eep_val + offset);
 	mt76_set(dev, MT_XO_CTRL6, MT_XO_CTRL6_C2_CTRL);
 
-	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
+	eep_val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
 	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
 	case 0:
 		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 563e2c459409..d8fa9ba56437 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -140,7 +140,7 @@ mt76pci_load_firmware(struct mt76x02_dev *dev)
 
 	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
+	val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
 	if (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, val) == 1)
 		mt76_set(dev, MT_MCU_COM_REG0, BIT(30));
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index aff0363e0958..dbb63d4c3bad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -26,7 +26,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u32 flag = 0;
 
-	if (!mt76x02_tssi_enabled(&dev->mt76))
+	if (!mt76x02_tssi_enabled(dev))
 		return false;
 
 	if (mt76x2_channel_silent(dev))
@@ -35,7 +35,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 	if (chan->band == NL80211_BAND_5GHZ)
 		flag |= BIT(0);
 
-	if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
+	if (mt76x02_ext_pa_enabled(dev, chan->band))
 		flag |= BIT(8);
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, true);
@@ -361,7 +361,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
 
 	if (!dev->cal.init_cal_done) {
-		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
+		u8 val = mt76x02_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
 			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, true);
@@ -391,7 +391,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	       sizeof(dev->cal.agc_gain_cur));
 
 	/* init default values for temp compensation */
-	if (mt76x02_tssi_enabled(&dev->mt76)) {
+	if (mt76x02_tssi_enabled(dev)) {
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 93bcab7cccfd..fd077e8d8dcb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -65,7 +65,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 		mt76_wr(dev, MT_TX_ALC_CFG_2, 0x35160a00);
 		mt76_wr(dev, MT_TX_ALC_CFG_3, 0x35160a06);
 
-		if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
+		if (mt76x02_ext_pa_enabled(dev, band)) {
 			mt76_wr(dev, MT_RF_PA_MODE_ADJ0, 0x0000ec00);
 			mt76_wr(dev, MT_RF_PA_MODE_ADJ1, 0x0000ec00);
 		} else {
@@ -76,7 +76,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 		pa_mode[0] = 0x0000ffff;
 		pa_mode[1] = 0x00ff00ff;
 
-		if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
+		if (mt76x02_ext_pa_enabled(dev, band)) {
 			mt76_wr(dev, MT_TX_ALC_CFG_2, 0x2f0f0400);
 			mt76_wr(dev, MT_TX_ALC_CFG_3, 0x2f0f0476);
 		} else {
@@ -84,7 +84,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 			mt76_wr(dev, MT_TX_ALC_CFG_3, 0x1b0f0476);
 		}
 
-		if (mt76x02_ext_pa_enabled(&dev->mt76, band))
+		if (mt76x02_ext_pa_enabled(dev, band))
 			pa_mode_adj = 0x04000000;
 		else
 			pa_mode_adj = 0;
@@ -98,7 +98,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 	mt76_wr(dev, MT_RF_PA_MODE_CFG0, pa_mode[0]);
 	mt76_wr(dev, MT_RF_PA_MODE_CFG1, pa_mode[1]);
 
-	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
+	if (mt76x02_ext_pa_enabled(dev, band)) {
 		u32 val;
 
 		if (band == NL80211_BAND_2GHZ)
@@ -196,7 +196,7 @@ void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 {
 	u32 cfg0, cfg1;
 
-	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
+	if (mt76x02_ext_pa_enabled(dev, band)) {
 		cfg0 = bw ? 0x000b0c01 : 0x00101101;
 		cfg1 = 0x00011414;
 	} else {
@@ -275,7 +275,7 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 		dev->cal.tssi_comp_pending = false;
 		mt76x2_get_power_info(dev, &txp, chan);
 
-		if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
+		if (mt76x02_ext_pa_enabled(dev, chan->band))
 			t.pa_mode = 1;
 
 		t.cal_mode = BIT(1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 51d3eabfa01b..13cce2937573 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -130,7 +130,7 @@ static int mt76x2u_init_eeprom(struct mt76x02_dev *dev)
 		put_unaligned_le32(val, dev->mt76.eeprom.data + i);
 	}
 
-	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
+	mt76x02_eeprom_parse_hw_cap(dev);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index dbd635aa763b..db2194a92e67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -32,7 +32,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x02_dev *dev)
 	s8 offset = 0;
 	u16 eep_val;
 
-	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_2);
+	eep_val = mt76x02_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
 
 	offset = eep_val & 0x7f;
 	if ((eep_val & 0xff) == 0xff)
@@ -42,7 +42,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x02_dev *dev)
 
 	eep_val >>= 8;
 	if (eep_val == 0x00 || eep_val == 0xff) {
-		eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_1);
+		eep_val = mt76x02_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
 		eep_val &= 0xff;
 
 		if (eep_val == 0x00 || eep_val == 0xff)
@@ -67,7 +67,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x02_dev *dev)
 	/* init fce */
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
-	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
+	eep_val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
 	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
 	case 0:
 		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index c4c437770fc9..422114de695a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -177,7 +177,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
 
 	if (!dev->cal.init_cal_done) {
-		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
+		u8 val = mt76x02_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
 			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
@@ -202,7 +202,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
-	if (mt76x02_tssi_enabled(&dev->mt76)) {
+	if (mt76x02_tssi_enabled(dev)) {
 		/* init default values for temp compensation */
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
@@ -217,7 +217,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 			chan = dev->mt76.chandef.chan;
 			if (chan->band == NL80211_BAND_5GHZ)
 				flag |= BIT(0);
-			if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
+			if (mt76x02_ext_pa_enabled(dev, chan->band))
 				flag |= BIT(8);
 			mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, false);
 			dev->cal.tssi_cal_done = true;
-- 
2.17.1

