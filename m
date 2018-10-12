Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EFDC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA91220868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA91220868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbeJLRsj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:39 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:40401 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeJLRsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:39 -0400
Received: by mail-wr1-f46.google.com with SMTP id d2-v6so12835955wro.7
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WRZioZmLQJ8yDPrlF3fUpkqeC1wQfchYa5g9i18pFVM=;
        b=q3kwsm1oKwPYt7T1sHB14Q3FyViEARGREM6YSOqevweFfhSrSe171DugH8Z2Wuu1Tw
         Gq/DVtE9I+epCTAQHDniea2pg0aR3YMkf+iWG8oAfebbStAoHPWIHPs+DRhtTixlpPP6
         CA8RXiuUeLMwk0s4EvyAbPOWya62y6zyLDpIn03C/1EWCrsSL5InHrL7xthREdqetYjP
         mU0/PEujjnjNincH1pyJre3DU4qGfaZmsHSPYbhX8XSp9ge3LPqmtb34RdprTm8FQEQn
         TmZk2UGNqhPdQr6TXV0dPaLbs2OkI4hayl27BfwtsvSTzfsObqM8HKzLelj6Q2TJpJ16
         ylug==
X-Gm-Message-State: ABuFfohopaw1j3oZ2N/oMSypwHxLmH0ErnzvAIhyxdURLAtpi5mdvGHv
        F1DZWaHVjgQ1O3NJaRBrYAVwCQ==
X-Google-Smtp-Source: ACcGV60+Vc9HH+7xmX2rQXlE74zZ5TRPv47tmsD/yMteuSBPWx2U8V+GICxuEm8NxWqOJduCtiZkng==
X-Received: by 2002:a5d:6511:: with SMTP id x17-v6mr4944601wru.150.1539339414975;
        Fri, 12 Oct 2018 03:16:54 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:54 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] mt76x0: phy: use proper name convention
Date:   Fri, 12 Oct 2018 12:16:29 +0200
Message-Id: <77e1a64480cbcf20b335f3ae6c7427d797d71853.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x0_phy as prefix for routines in mt76x0/phy.c
Moreover use mt76x0_phy_rf_set to enable vco calibration in
mt76x0_phy_vco_cal

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 228 +++++++++---------
 3 files changed, 117 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 578f1b34f0f1..ac7a949801fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -113,7 +113,7 @@ static int mt76x0_init_bbp(struct mt76x02_dev *dev)
 {
 	int ret, i;
 
-	ret = mt76x0_wait_bbp_ready(dev);
+	ret = mt76x0_phy_wait_bbp_ready(dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 2187bafaf2e9..f27335ccb582 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -65,7 +65,7 @@ int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
-int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev);
+int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index cf024950e0ed..79408a44980b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -27,7 +27,7 @@
 #include "../mt76x02_phy.h"
 
 static int
-mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
+mt76x0_phy_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 {
 	int ret = 0;
 	u8 bank, reg;
@@ -65,7 +65,8 @@ mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 	return ret;
 }
 
-static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
+static int
+mt76x0_phy_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 {
 	int ret = -ETIMEDOUT;
 	u32 val;
@@ -110,7 +111,7 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 }
 
 static int
-rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
+mt76x0_phy_rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
 	if (mt76_is_usb(dev)) {
 		struct mt76_reg_pair pair = {
@@ -122,12 +123,11 @@ rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 			     &dev->mt76.state));
 		return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
-		return mt76x0_rf_csr_wr(dev, offset, val);
+		return mt76x0_phy_rf_csr_wr(dev, offset, val);
 	}
 }
 
-static int
-rf_rr(struct mt76x02_dev *dev, u32 offset)
+static int mt76x0_phy_rf_rr(struct mt76x02_dev *dev, u32 offset)
 {
 	int ret;
 	u32 val;
@@ -142,22 +142,22 @@ rf_rr(struct mt76x02_dev *dev, u32 offset)
 		ret = mt76_rd_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 		val = pair.value;
 	} else {
-		ret = val = mt76x0_rf_csr_rr(dev, offset);
+		ret = val = mt76x0_phy_rf_csr_rr(dev, offset);
 	}
 
 	return (ret < 0) ? ret : val;
 }
 
 static int
-rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
+mt76x0_phy_rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
 {
 	int ret;
 
-	ret = rf_rr(dev, offset);
+	ret = mt76x0_phy_rf_rr(dev, offset);
 	if (ret < 0)
 		return ret;
 	val |= ret & ~mask;
-	ret = rf_wr(dev, offset, val);
+	ret = mt76x0_phy_rf_wr(dev, offset, val);
 	if (ret)
 		return ret;
 
@@ -165,37 +165,38 @@ rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
 }
 
 static int
-rf_set(struct mt76x02_dev *dev, u32 offset, u8 val)
+mt76x0_phy_rf_set(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
-	return rf_rmw(dev, offset, 0, val);
+	return mt76x0_phy_rf_rmw(dev, offset, 0, val);
 }
 
 #if 0
 static int
 rf_clear(struct mt76x02_dev *dev, u32 offset, u8 mask)
 {
-	return rf_rmw(dev, offset, mask, 0);
+	return mt76x0_phy_rf_rmw(dev, offset, mask, 0);
 }
 #endif
 
 static void
-mt76x0_rf_csr_wr_rp(struct mt76x02_dev *dev, const struct mt76_reg_pair *data,
-		    int n)
+mt76x0_phy_rf_csr_wr_rp(struct mt76x02_dev *dev,
+			const struct mt76_reg_pair *data,
+			int n)
 {
 	while (n-- > 0) {
-		mt76x0_rf_csr_wr(dev, data->reg, data->value);
+		mt76x0_phy_rf_csr_wr(dev, data->reg, data->value);
 		data++;
 	}
 }
 
 #define RF_RANDOM_WRITE(dev, tab) do {					\
 	if (mt76_is_mmio(dev))						\
-		mt76x0_rf_csr_wr_rp(dev, tab, ARRAY_SIZE(tab));		\
+		mt76x0_phy_rf_csr_wr_rp(dev, tab, ARRAY_SIZE(tab));	\
 	else								\
 		mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, tab, ARRAY_SIZE(tab));\
 } while (0)
 
-int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
+int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev)
 {
 	int i = 20;
 	u32 val;
@@ -215,11 +216,11 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
+static void mt76x0_phy_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
 
-	val = rf_rr(dev, MT_RF(0, 4));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 4));
 	if ((val & 0x70) != 0x30)
 		return;
 
@@ -235,20 +236,20 @@ static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 	 *  40MHz channel: 101
 	 *  20MHz channel: 100
 	 */
-	val = rf_rr(dev, MT_RF(0, 6));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 6));
 	val &= ~0xf;
 	val |= 0x09;
-	rf_wr(dev, MT_RF(0, 6), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 6), val);
 
-	val = rf_rr(dev, MT_RF(0, 5));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 5));
 	if (val != 0)
-		rf_wr(dev, MT_RF(0, 5), 0x0);
+		mt76x0_phy_rf_wr(dev, MT_RF(0, 5), 0x0);
 
-	val = rf_rr(dev, MT_RF(0, 4));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 4));
 	val &= ~0x07;
-	rf_wr(dev, MT_RF(0, 4), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 4), val);
 
-	val = rf_rr(dev, MT_RF(0, 3));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 3));
 	val &= ~0x77;
 	if (channel == 1 || channel == 7 || channel == 9 || channel >= 13) {
 		val |= 0x63;
@@ -261,12 +262,9 @@ static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 		WARN(1, "Unknown channel %u\n", channel);
 		return;
 	}
-	rf_wr(dev, MT_RF(0, 3), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 3), val);
 
-	/* TODO replace by mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7)); */
-	val = rf_rr(dev, MT_RF(0, 4));
-	val = ((val & ~(0x80)) | 0x80);
-	rf_wr(dev, MT_RF(0, 4), val);
+	mt76x0_phy_rf_set(dev, MT_RF(0, 4), BIT(7));
 
 	msleep(2);
 }
@@ -278,8 +276,8 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 	case NL80211_BAND_2GHZ:
 		RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
 
-		rf_wr(dev, MT_RF(5, 0), 0x45);
-		rf_wr(dev, MT_RF(6, 0), 0x44);
+		mt76x0_phy_rf_wr(dev, MT_RF(5, 0), 0x45);
+		mt76x0_phy_rf_wr(dev, MT_RF(6, 0), 0x44);
 
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00050007);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x003E0002);
@@ -287,8 +285,8 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 	case NL80211_BAND_5GHZ:
 		RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
 
-		rf_wr(dev, MT_RF(5, 0), 0x44);
-		rf_wr(dev, MT_RF(6, 0), 0x45);
+		mt76x0_phy_rf_wr(dev, MT_RF(5, 0), 0x44);
+		mt76x0_phy_rf_wr(dev, MT_RF(6, 0), 0x45);
 
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00000005);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x01010102);
@@ -326,103 +324,103 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 			else
 				freq_item = &(mt76x0_frequency_plan[i]);
 
-			rf_wr(dev, MT_RF(0, 37), freq_item->pllR37);
-			rf_wr(dev, MT_RF(0, 36), freq_item->pllR36);
-			rf_wr(dev, MT_RF(0, 35), freq_item->pllR35);
-			rf_wr(dev, MT_RF(0, 34), freq_item->pllR34);
-			rf_wr(dev, MT_RF(0, 33), freq_item->pllR33);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 37), freq_item->pllR37);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 36), freq_item->pllR36);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 35), freq_item->pllR35);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 34), freq_item->pllR34);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 33), freq_item->pllR33);
 
-			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 32));
 			rf_val &= ~0xE0;
 			rf_val |= freq_item->pllR32_b7b5;
-			rf_wr(dev, MT_RF(0, 32), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 32), rf_val);
 
 			/* R32<4:0> pll_den: (Denomina - 8) */
-			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 32));
 			rf_val &= ~0x1F;
 			rf_val |= freq_item->pllR32_b4b0;
-			rf_wr(dev, MT_RF(0, 32), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 32), rf_val);
 
 			/* R31<7:5> */
-			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 31));
 			rf_val &= ~0xE0;
 			rf_val |= freq_item->pllR31_b7b5;
-			rf_wr(dev, MT_RF(0, 31), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 31), rf_val);
 
 			/* R31<4:0> pll_k(Nominator) */
-			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 31));
 			rf_val &= ~0x1F;
 			rf_val |= freq_item->pllR31_b4b0;
-			rf_wr(dev, MT_RF(0, 31), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 31), rf_val);
 
 			/* R30<7> sdm_reset_n */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x80;
 			if (bSDM) {
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 				rf_val |= 0x80;
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 			} else {
 				rf_val |= freq_item->pllR30_b7;
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 			}
 
 			/* R30<6:2> sdmmash_prbs,sin */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x7C;
 			rf_val |= freq_item->pllR30_b6b2;
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R30<1> sdm_bp */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x02;
 			rf_val |= (freq_item->pllR30_b1 << 1);
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R30<0> R29<7:0> (hex) pll_n */
 			rf_val = freq_item->pll_n & 0x00FF;
-			rf_wr(dev, MT_RF(0, 29), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 29), rf_val);
 
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x1;
 			rf_val |= ((freq_item->pll_n >> 8) & 0x0001);
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R28<7:6> isi_iso */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0xC0;
 			rf_val |= freq_item->pllR28_b7b6;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<5:4> pfd_dly */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x30;
 			rf_val |= freq_item->pllR28_b5b4;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<3:2> clksel option */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x0C;
 			rf_val |= freq_item->pllR28_b3b2;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<1:0> R27<7:0> R26<7:0> (hex) sdm_k */
 			rf_val = freq_item->pll_sdm_k & 0x000000FF;
-			rf_wr(dev, MT_RF(0, 26), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 26), rf_val);
 
 			rf_val = ((freq_item->pll_sdm_k >> 8) & 0x000000FF);
-			rf_wr(dev, MT_RF(0, 27), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 27), rf_val);
 
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x3;
 			rf_val |= ((freq_item->pll_sdm_k >> 16) & 0x0003);
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R24<1:0> xo_div */
-			rf_val = rf_rr(dev, MT_RF(0, 24));
+			rf_val = mt76x0_phy_rf_rr(dev, MT_RF(0, 24));
 			rf_val &= ~0x3;
 			rf_val |= freq_item->pllR24_b1b0;
-			rf_wr(dev, MT_RF(0, 24), rf_val);
+			mt76x0_phy_rf_wr(dev, MT_RF(0, 24), rf_val);
 
 			break;
 		}
@@ -430,19 +428,22 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
 		if (rf_bw == mt76x0_rf_bw_switch_tab[i].bw_band) {
-			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_bw_switch_tab[i].value);
+			mt76x0_phy_rf_wr(dev,
+				mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				mt76x0_rf_bw_switch_tab[i].value);
 		} else if ((rf_bw == (mt76x0_rf_bw_switch_tab[i].bw_band & 0xFF)) &&
 			   (rf_band & mt76x0_rf_bw_switch_tab[i].bw_band)) {
-			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_bw_switch_tab[i].value);
+			mt76x0_phy_rf_wr(dev,
+				mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				mt76x0_rf_bw_switch_tab[i].value);
 		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & rf_band) {
-			rf_wr(dev, mt76x0_rf_band_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_band_switch_tab[i].value);
+			mt76x0_phy_rf_wr(dev,
+				mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+				mt76x0_rf_band_switch_tab[i].value);
 		}
 	}
 
@@ -470,8 +471,9 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 		/* External PA */
 		for (i = 0; i < ARRAY_SIZE(mt76x0_rf_ext_pa_tab); i++)
 			if (mt76x0_rf_ext_pa_tab[i].bw_band & rf_band)
-				rf_wr(dev, mt76x0_rf_ext_pa_tab[i].rf_bank_reg,
-					   mt76x0_rf_ext_pa_tab[i].value);
+				mt76x0_phy_rf_wr(dev,
+					mt76x0_rf_ext_pa_tab[i].rf_bank_reg,
+					mt76x0_rf_ext_pa_tab[i].value);
 	}
 
 	if (rf_band & RF_G_BAND) {
@@ -516,7 +518,7 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x02_dev *dev, u16 rf_bw_band)
 	}
 }
 
-static void mt76x0_ant_select(struct mt76x02_dev *dev)
+static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 
@@ -536,7 +538,7 @@ static void mt76x0_ant_select(struct mt76x02_dev *dev)
 }
 
 static void
-mt76x0_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
+mt76x0_phy_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
 {
 	enum { BW_20 = 0, BW_40 = 1, BW_80 = 2, BW_10 = 4};
 	int bw;
@@ -684,7 +686,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	}
 
 	if (mt76_is_usb(dev)) {
-		mt76x0_bbp_set_bw(dev, chandef->width);
+		mt76x0_phy_bbp_set_bw(dev, chandef->width);
 	} else {
 		if (chandef->width == NL80211_CHAN_WIDTH_80 ||
 		    chandef->width == NL80211_CHAN_WIDTH_40)
@@ -696,7 +698,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x02_phy_set_band(dev, chandef->chan->band,
 			     ch_group_index & 1);
-	mt76x0_ant_select(dev);
+	mt76x0_phy_ant_select(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
@@ -722,10 +724,10 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x02_init_agc_gain(dev);
 
 	if (mt76_is_usb(dev)) {
-		mt76x0_vco_cal(dev, channel);
+		mt76x0_phy_vco_cal(dev, channel);
 	} else {
 		/* enable vco */
-		rf_set(dev, MT_RF(0, 4), BIT(7));
+		mt76x0_phy_rf_set(dev, MT_RF(0, 4), BIT(7));
 	}
 
 	if (scan)
@@ -749,7 +751,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 
-	mt76x0_vco_cal(dev, channel);
+	mt76x0_phy_vco_cal(dev, channel);
 
 	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
@@ -774,18 +776,18 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
 }
 
-static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
+static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
 	s8 val;
 
-	rf_b7_73 = rf_rr(dev, MT_RF(7, 73));
-	rf_b0_66 = rf_rr(dev, MT_RF(0, 66));
-	rf_b0_67 = rf_rr(dev, MT_RF(0, 67));
+	rf_b7_73 = mt76x0_phy_rf_rr(dev, MT_RF(7, 73));
+	rf_b0_66 = mt76x0_phy_rf_rr(dev, MT_RF(0, 66));
+	rf_b0_67 = mt76x0_phy_rf_rr(dev, MT_RF(0, 67));
 
-	rf_wr(dev, MT_RF(7, 73), 0x02);
-	rf_wr(dev, MT_RF(0, 66), 0x23);
-	rf_wr(dev, MT_RF(0, 67), 0x01);
+	mt76x0_phy_rf_wr(dev, MT_RF(7, 73), 0x02);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 66), 0x23);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 67), 0x01);
 
 	mt76_wr(dev, MT_BBP(CORE, 34), 0x00080055);
 
@@ -809,9 +811,9 @@ static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 	}
 
 done:
-	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
-	rf_wr(dev, MT_RF(0, 66), rf_b0_66);
-	rf_wr(dev, MT_RF(0, 67), rf_b0_67);
+	mt76x0_phy_rf_wr(dev, MT_RF(7, 73), rf_b7_73);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 66), rf_b0_66);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 67), rf_b0_67);
 }
 
 static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
@@ -861,13 +863,13 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
 
 	mt76x0_phy_update_channel_gain(dev);
 	if (!mt76x0_tssi_enabled(dev))
-		mt76x0_temp_sensor(dev);
+		mt76x0_phy_temp_sensor(dev);
 
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 }
 
-static void mt76x0_rf_init(struct mt76x02_dev *dev)
+static void mt76x0_phy_rf_init(struct mt76x02_dev *dev)
 {
 	int i;
 	u8 val;
@@ -881,16 +883,16 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 		const struct mt76x0_rf_switch_item *item = &mt76x0_rf_bw_switch_tab[i];
 
 		if (item->bw_band == RF_BW_20)
-			rf_wr(dev, item->rf_bank_reg, item->value);
+			mt76x0_phy_rf_wr(dev, item->rf_bank_reg, item->value);
 		else if (((RF_G_BAND | RF_BW_20) & item->bw_band) == (RF_G_BAND | RF_BW_20))
-			rf_wr(dev, item->rf_bank_reg, item->value);
+			mt76x0_phy_rf_wr(dev, item->rf_bank_reg, item->value);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & RF_G_BAND) {
-			rf_wr(dev,
-			      mt76x0_rf_band_switch_tab[i].rf_bank_reg,
-			      mt76x0_rf_band_switch_tab[i].value);
+			mt76x0_phy_rf_wr(dev,
+				mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+				mt76x0_rf_band_switch_tab[i].value);
 		}
 	}
 
@@ -899,32 +901,32 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 	   E1: B0.R22<6:0>: xo_cxo<6:0>
 	   E2: B0.R21<0>: xo_cxo<0>, B0.R22<7:0>: xo_cxo<8:1>
 	 */
-	rf_wr(dev, MT_RF(0, 22),
-	      min_t(u8, dev->cal.rx.freq_offset, 0xbf));
-	val = rf_rr(dev, MT_RF(0, 22));
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 22),
+			 min_t(u8, dev->cal.rx.freq_offset, 0xbf));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 22));
 
 	/*
 	   Reset the DAC (Set B0.R73<7>=1, then set B0.R73<7>=0, and then set B0.R73<7>) during power up.
 	 */
-	val = rf_rr(dev, MT_RF(0, 73));
+	val = mt76x0_phy_rf_rr(dev, MT_RF(0, 73));
 	val |= 0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 73), val);
 	val &= ~0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 73), val);
 	val |= 0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_phy_rf_wr(dev, MT_RF(0, 73), val);
 
 	/*
 	   vcocal_en (initiate VCO calibration (reset after completion)) - It should be at the end of RF configuration.
 	 */
-	rf_set(dev, MT_RF(0, 4), 0x80);
+	mt76x0_phy_rf_set(dev, MT_RF(0, 4), 0x80);
 }
 
 void mt76x0_phy_init(struct mt76x02_dev *dev)
 {
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibration_work);
 
-	mt76x0_rf_init(dev);
+	mt76x0_phy_rf_init(dev);
 	mt76x02_phy_set_rxpath(dev);
 	mt76x02_phy_set_txdac(dev);
 }
-- 
2.17.2

