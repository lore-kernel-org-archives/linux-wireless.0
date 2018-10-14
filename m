Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2C3C7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4FD62077C
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4FD62077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbeJOAhN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 20:37:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36415 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOAhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 20:37:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id y16so18543357wrw.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 09:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=slvNMwcRLRmmEvM9PA6C4O0MNyMYPPk0wsVIVKoqPqM=;
        b=JrfKwaTHs++LyYkmOcaaIHsYS+tWCt0cL5Dx/FFHog06/Z68d+yH/7NvQ6LqgXe5uC
         CZvebODMv+W0mF2YzveMhfwvRTuZzeA5EFWG2+6NPAAetAIYxNQIzYVeCigUHHni6EAo
         T4jYgWn2Ug0vvlDtYeEXfFhJMMi1y/vr8SWv6Iih37VDH3dLjisKKmsvf7xtSjXtDcUK
         MMIcKzE7TA5V3+9oJvd9+njTNSxE9PH0orf55Lu/6LdiMMq5+Y1I+A7qZQ2td94PRXrb
         KCU4NSW0srHiAp4igR6+dOIFVNbVZRLGrjkP95PfZ3Vfx26rnULRl/184qwwTy4v6gQL
         0e1Q==
X-Gm-Message-State: ABuFfoiPIGs9F00zRbfUdS1VpW5v6yZ+ajWns4XsGSxEyPZIMiuOPLIM
        DxL2GsTuNiTsIx7vrgTQ5XyjxA==
X-Google-Smtp-Source: ACcGV60IYCwUIUJFJ08Wh6M2UFpFVlJPik3Nb3yuO6tVP95wRmyXOWpSZXeiimuF4HtVkqlnna3Wbg==
X-Received: by 2002:adf:bc13:: with SMTP id s19-v6mr12426638wrg.255.1539536132191;
        Sun, 14 Oct 2018 09:55:32 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id k25-v6sm16068279wre.18.2018.10.14.09.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 09:55:31 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76x0: phy: use proper name convention
Date:   Sun, 14 Oct 2018 18:55:18 +0200
Message-Id: <4f75cef26ef0164165dd8848f9b356f7589868ff.1539535586.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539535586.git.lorenzo.bianconi@redhat.com>
References: <cover.1539535586.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x0_phy as prefix for routines in mt76x0/phy.c
Moreover use mt76x0_rf_set to enable vco calibration in
mt76x0_phy_vco_cal

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 222 +++++++++---------
 3 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 4a9408801260..d7d4dfbbd04d 100644
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
index cf024950e0ed..b1bf990148d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -110,7 +110,7 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 }
 
 static int
-rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
+mt76x0_rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
 	if (mt76_is_usb(dev)) {
 		struct mt76_reg_pair pair = {
@@ -126,8 +126,7 @@ rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 	}
 }
 
-static int
-rf_rr(struct mt76x02_dev *dev, u32 offset)
+static int mt76x0_rf_rr(struct mt76x02_dev *dev, u32 offset)
 {
 	int ret;
 	u32 val;
@@ -149,38 +148,38 @@ rf_rr(struct mt76x02_dev *dev, u32 offset)
 }
 
 static int
-rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
+mt76x0_rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
 {
 	int ret;
 
-	ret = rf_rr(dev, offset);
+	ret = mt76x0_rf_rr(dev, offset);
 	if (ret < 0)
 		return ret;
+
 	val |= ret & ~mask;
-	ret = rf_wr(dev, offset, val);
-	if (ret)
-		return ret;
 
-	return val;
+	ret = mt76x0_rf_wr(dev, offset, val);
+	return ret ? ret : val;
 }
 
 static int
-rf_set(struct mt76x02_dev *dev, u32 offset, u8 val)
+mt76x0_rf_set(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
-	return rf_rmw(dev, offset, 0, val);
+	return mt76x0_rf_rmw(dev, offset, 0, val);
 }
 
 #if 0
 static int
 rf_clear(struct mt76x02_dev *dev, u32 offset, u8 mask)
 {
-	return rf_rmw(dev, offset, mask, 0);
+	return mt76x0_rf_rmw(dev, offset, mask, 0);
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
 		mt76x0_rf_csr_wr(dev, data->reg, data->value);
@@ -190,12 +189,12 @@ mt76x0_rf_csr_wr_rp(struct mt76x02_dev *dev, const struct mt76_reg_pair *data,
 
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
@@ -215,11 +214,11 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
+static void mt76x0_phy_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
 
-	val = rf_rr(dev, MT_RF(0, 4));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 4));
 	if ((val & 0x70) != 0x30)
 		return;
 
@@ -235,20 +234,20 @@ static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 	 *  40MHz channel: 101
 	 *  20MHz channel: 100
 	 */
-	val = rf_rr(dev, MT_RF(0, 6));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 6));
 	val &= ~0xf;
 	val |= 0x09;
-	rf_wr(dev, MT_RF(0, 6), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 6), val);
 
-	val = rf_rr(dev, MT_RF(0, 5));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 5));
 	if (val != 0)
-		rf_wr(dev, MT_RF(0, 5), 0x0);
+		mt76x0_rf_wr(dev, MT_RF(0, 5), 0x0);
 
-	val = rf_rr(dev, MT_RF(0, 4));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 4));
 	val &= ~0x07;
-	rf_wr(dev, MT_RF(0, 4), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 4), val);
 
-	val = rf_rr(dev, MT_RF(0, 3));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 3));
 	val &= ~0x77;
 	if (channel == 1 || channel == 7 || channel == 9 || channel >= 13) {
 		val |= 0x63;
@@ -261,12 +260,9 @@ static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 		WARN(1, "Unknown channel %u\n", channel);
 		return;
 	}
-	rf_wr(dev, MT_RF(0, 3), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 3), val);
 
-	/* TODO replace by mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7)); */
-	val = rf_rr(dev, MT_RF(0, 4));
-	val = ((val & ~(0x80)) | 0x80);
-	rf_wr(dev, MT_RF(0, 4), val);
+	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
 
 	msleep(2);
 }
@@ -278,8 +274,8 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 	case NL80211_BAND_2GHZ:
 		RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
 
-		rf_wr(dev, MT_RF(5, 0), 0x45);
-		rf_wr(dev, MT_RF(6, 0), 0x44);
+		mt76x0_rf_wr(dev, MT_RF(5, 0), 0x45);
+		mt76x0_rf_wr(dev, MT_RF(6, 0), 0x44);
 
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00050007);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x003E0002);
@@ -287,8 +283,8 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 	case NL80211_BAND_5GHZ:
 		RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
 
-		rf_wr(dev, MT_RF(5, 0), 0x44);
-		rf_wr(dev, MT_RF(6, 0), 0x45);
+		mt76x0_rf_wr(dev, MT_RF(5, 0), 0x44);
+		mt76x0_rf_wr(dev, MT_RF(6, 0), 0x45);
 
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00000005);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x01010102);
@@ -326,103 +322,103 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 			else
 				freq_item = &(mt76x0_frequency_plan[i]);
 
-			rf_wr(dev, MT_RF(0, 37), freq_item->pllR37);
-			rf_wr(dev, MT_RF(0, 36), freq_item->pllR36);
-			rf_wr(dev, MT_RF(0, 35), freq_item->pllR35);
-			rf_wr(dev, MT_RF(0, 34), freq_item->pllR34);
-			rf_wr(dev, MT_RF(0, 33), freq_item->pllR33);
+			mt76x0_rf_wr(dev, MT_RF(0, 37), freq_item->pllR37);
+			mt76x0_rf_wr(dev, MT_RF(0, 36), freq_item->pllR36);
+			mt76x0_rf_wr(dev, MT_RF(0, 35), freq_item->pllR35);
+			mt76x0_rf_wr(dev, MT_RF(0, 34), freq_item->pllR34);
+			mt76x0_rf_wr(dev, MT_RF(0, 33), freq_item->pllR33);
 
-			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 32));
 			rf_val &= ~0xE0;
 			rf_val |= freq_item->pllR32_b7b5;
-			rf_wr(dev, MT_RF(0, 32), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 32), rf_val);
 
 			/* R32<4:0> pll_den: (Denomina - 8) */
-			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 32));
 			rf_val &= ~0x1F;
 			rf_val |= freq_item->pllR32_b4b0;
-			rf_wr(dev, MT_RF(0, 32), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 32), rf_val);
 
 			/* R31<7:5> */
-			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 31));
 			rf_val &= ~0xE0;
 			rf_val |= freq_item->pllR31_b7b5;
-			rf_wr(dev, MT_RF(0, 31), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 31), rf_val);
 
 			/* R31<4:0> pll_k(Nominator) */
-			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 31));
 			rf_val &= ~0x1F;
 			rf_val |= freq_item->pllR31_b4b0;
-			rf_wr(dev, MT_RF(0, 31), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 31), rf_val);
 
 			/* R30<7> sdm_reset_n */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x80;
 			if (bSDM) {
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 				rf_val |= 0x80;
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 			} else {
 				rf_val |= freq_item->pllR30_b7;
-				rf_wr(dev, MT_RF(0, 30), rf_val);
+				mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 			}
 
 			/* R30<6:2> sdmmash_prbs,sin */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x7C;
 			rf_val |= freq_item->pllR30_b6b2;
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R30<1> sdm_bp */
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x02;
 			rf_val |= (freq_item->pllR30_b1 << 1);
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R30<0> R29<7:0> (hex) pll_n */
 			rf_val = freq_item->pll_n & 0x00FF;
-			rf_wr(dev, MT_RF(0, 29), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 29), rf_val);
 
-			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 30));
 			rf_val &= ~0x1;
 			rf_val |= ((freq_item->pll_n >> 8) & 0x0001);
-			rf_wr(dev, MT_RF(0, 30), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 30), rf_val);
 
 			/* R28<7:6> isi_iso */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0xC0;
 			rf_val |= freq_item->pllR28_b7b6;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<5:4> pfd_dly */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x30;
 			rf_val |= freq_item->pllR28_b5b4;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<3:2> clksel option */
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x0C;
 			rf_val |= freq_item->pllR28_b3b2;
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R28<1:0> R27<7:0> R26<7:0> (hex) sdm_k */
 			rf_val = freq_item->pll_sdm_k & 0x000000FF;
-			rf_wr(dev, MT_RF(0, 26), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 26), rf_val);
 
 			rf_val = ((freq_item->pll_sdm_k >> 8) & 0x000000FF);
-			rf_wr(dev, MT_RF(0, 27), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 27), rf_val);
 
-			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 28));
 			rf_val &= ~0x3;
 			rf_val |= ((freq_item->pll_sdm_k >> 16) & 0x0003);
-			rf_wr(dev, MT_RF(0, 28), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 28), rf_val);
 
 			/* R24<1:0> xo_div */
-			rf_val = rf_rr(dev, MT_RF(0, 24));
+			rf_val = mt76x0_rf_rr(dev, MT_RF(0, 24));
 			rf_val &= ~0x3;
 			rf_val |= freq_item->pllR24_b1b0;
-			rf_wr(dev, MT_RF(0, 24), rf_val);
+			mt76x0_rf_wr(dev, MT_RF(0, 24), rf_val);
 
 			break;
 		}
@@ -430,19 +426,22 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
 		if (rf_bw == mt76x0_rf_bw_switch_tab[i].bw_band) {
-			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_bw_switch_tab[i].value);
+			mt76x0_rf_wr(dev,
+				     mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				     mt76x0_rf_bw_switch_tab[i].value);
 		} else if ((rf_bw == (mt76x0_rf_bw_switch_tab[i].bw_band & 0xFF)) &&
 			   (rf_band & mt76x0_rf_bw_switch_tab[i].bw_band)) {
-			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_bw_switch_tab[i].value);
+			mt76x0_rf_wr(dev,
+				     mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				     mt76x0_rf_bw_switch_tab[i].value);
 		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & rf_band) {
-			rf_wr(dev, mt76x0_rf_band_switch_tab[i].rf_bank_reg,
-				   mt76x0_rf_band_switch_tab[i].value);
+			mt76x0_rf_wr(dev,
+				     mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+				     mt76x0_rf_band_switch_tab[i].value);
 		}
 	}
 
@@ -470,8 +469,9 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 		/* External PA */
 		for (i = 0; i < ARRAY_SIZE(mt76x0_rf_ext_pa_tab); i++)
 			if (mt76x0_rf_ext_pa_tab[i].bw_band & rf_band)
-				rf_wr(dev, mt76x0_rf_ext_pa_tab[i].rf_bank_reg,
-					   mt76x0_rf_ext_pa_tab[i].value);
+				mt76x0_rf_wr(dev,
+					mt76x0_rf_ext_pa_tab[i].rf_bank_reg,
+					mt76x0_rf_ext_pa_tab[i].value);
 	}
 
 	if (rf_band & RF_G_BAND) {
@@ -516,7 +516,7 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x02_dev *dev, u16 rf_bw_band)
 	}
 }
 
-static void mt76x0_ant_select(struct mt76x02_dev *dev)
+static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 
@@ -536,7 +536,7 @@ static void mt76x0_ant_select(struct mt76x02_dev *dev)
 }
 
 static void
-mt76x0_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
+mt76x0_phy_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
 {
 	enum { BW_20 = 0, BW_40 = 1, BW_80 = 2, BW_10 = 4};
 	int bw;
@@ -684,7 +684,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	}
 
 	if (mt76_is_usb(dev)) {
-		mt76x0_bbp_set_bw(dev, chandef->width);
+		mt76x0_phy_bbp_set_bw(dev, chandef->width);
 	} else {
 		if (chandef->width == NL80211_CHAN_WIDTH_80 ||
 		    chandef->width == NL80211_CHAN_WIDTH_40)
@@ -696,7 +696,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x02_phy_set_band(dev, chandef->chan->band,
 			     ch_group_index & 1);
-	mt76x0_ant_select(dev);
+	mt76x0_phy_ant_select(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
@@ -722,10 +722,10 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x02_init_agc_gain(dev);
 
 	if (mt76_is_usb(dev)) {
-		mt76x0_vco_cal(dev, channel);
+		mt76x0_phy_vco_cal(dev, channel);
 	} else {
 		/* enable vco */
-		rf_set(dev, MT_RF(0, 4), BIT(7));
+		mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
 	}
 
 	if (scan)
@@ -749,7 +749,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 
-	mt76x0_vco_cal(dev, channel);
+	mt76x0_phy_vco_cal(dev, channel);
 
 	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
@@ -774,18 +774,18 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
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
+	rf_b7_73 = mt76x0_rf_rr(dev, MT_RF(7, 73));
+	rf_b0_66 = mt76x0_rf_rr(dev, MT_RF(0, 66));
+	rf_b0_67 = mt76x0_rf_rr(dev, MT_RF(0, 67));
 
-	rf_wr(dev, MT_RF(7, 73), 0x02);
-	rf_wr(dev, MT_RF(0, 66), 0x23);
-	rf_wr(dev, MT_RF(0, 67), 0x01);
+	mt76x0_rf_wr(dev, MT_RF(7, 73), 0x02);
+	mt76x0_rf_wr(dev, MT_RF(0, 66), 0x23);
+	mt76x0_rf_wr(dev, MT_RF(0, 67), 0x01);
 
 	mt76_wr(dev, MT_BBP(CORE, 34), 0x00080055);
 
@@ -809,9 +809,9 @@ static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 	}
 
 done:
-	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
-	rf_wr(dev, MT_RF(0, 66), rf_b0_66);
-	rf_wr(dev, MT_RF(0, 67), rf_b0_67);
+	mt76x0_rf_wr(dev, MT_RF(7, 73), rf_b7_73);
+	mt76x0_rf_wr(dev, MT_RF(0, 66), rf_b0_66);
+	mt76x0_rf_wr(dev, MT_RF(0, 67), rf_b0_67);
 }
 
 static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
@@ -861,13 +861,13 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
 
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
@@ -881,16 +881,16 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 		const struct mt76x0_rf_switch_item *item = &mt76x0_rf_bw_switch_tab[i];
 
 		if (item->bw_band == RF_BW_20)
-			rf_wr(dev, item->rf_bank_reg, item->value);
+			mt76x0_rf_wr(dev, item->rf_bank_reg, item->value);
 		else if (((RF_G_BAND | RF_BW_20) & item->bw_band) == (RF_G_BAND | RF_BW_20))
-			rf_wr(dev, item->rf_bank_reg, item->value);
+			mt76x0_rf_wr(dev, item->rf_bank_reg, item->value);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & RF_G_BAND) {
-			rf_wr(dev,
-			      mt76x0_rf_band_switch_tab[i].rf_bank_reg,
-			      mt76x0_rf_band_switch_tab[i].value);
+			mt76x0_rf_wr(dev,
+				     mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+				     mt76x0_rf_band_switch_tab[i].value);
 		}
 	}
 
@@ -899,32 +899,32 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 	   E1: B0.R22<6:0>: xo_cxo<6:0>
 	   E2: B0.R21<0>: xo_cxo<0>, B0.R22<7:0>: xo_cxo<8:1>
 	 */
-	rf_wr(dev, MT_RF(0, 22),
-	      min_t(u8, dev->cal.rx.freq_offset, 0xbf));
-	val = rf_rr(dev, MT_RF(0, 22));
+	mt76x0_rf_wr(dev, MT_RF(0, 22),
+		     min_t(u8, dev->cal.rx.freq_offset, 0xbf));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 22));
 
 	/*
 	   Reset the DAC (Set B0.R73<7>=1, then set B0.R73<7>=0, and then set B0.R73<7>) during power up.
 	 */
-	val = rf_rr(dev, MT_RF(0, 73));
+	val = mt76x0_rf_rr(dev, MT_RF(0, 73));
 	val |= 0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 73), val);
 	val &= ~0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 73), val);
 	val |= 0x80;
-	rf_wr(dev, MT_RF(0, 73), val);
+	mt76x0_rf_wr(dev, MT_RF(0, 73), val);
 
 	/*
 	   vcocal_en (initiate VCO calibration (reset after completion)) - It should be at the end of RF configuration.
 	 */
-	rf_set(dev, MT_RF(0, 4), 0x80);
+	mt76x0_rf_set(dev, MT_RF(0, 4), 0x80);
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
2.19.0

