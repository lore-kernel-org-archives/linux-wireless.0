Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AA9ECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94C8F21476
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="BewRwVl6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94C8F21476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbeJRWSC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 18:18:02 -0400
Received: from nbd.name ([46.4.11.11]:34790 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbeJRWSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 18:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zawS86Yja7LElzbbfl0WfXvHXkr9e4SAojIbaoz2oc4=; b=BewRwVl60jLZ1Kn9/bY1HS4lK9
        6UyerSK1OKYvSszAbud4UpLZJDCRIDrJcYhWpnXdiXEGHejueOtLPZHlwdqAadxf/BVJFVIKtdARS
        aEHQkIR6R3wLcxBHdp7x0t/UmH5R40gLuBDAz9NonnR6HYwPkFfWrSNry7GHEXQfIcsc=;
Received: by maeck.lan (Postfix, from userid 501)
        id CD476401BB75; Thu, 18 Oct 2018 16:16:45 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     sgruszka@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH 1/2] mt76: mt76x0: reduce duplication in setting rf bandwidth parameters
Date:   Thu, 18 Oct 2018 16:16:44 +0200
Message-Id: <20181018141645.31484-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove initval table with duplicated registers and driver specific flags
in favor of a function that sets the registers directly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../mediatek/mt76/mt76x0/initvals_phy.h       | 45 ------------
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 73 +++++++++++++------
 2 files changed, 49 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
index 56c6fa73daf5..755dd6749b65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
@@ -233,51 +233,6 @@ static const struct mt76_reg_pair mt76x0_rf_vga_channel_0_tab[] = {
 	{ MT_RF(7, 74), 0x00 },
 };
 
-static const struct mt76x0_rf_switch_item mt76x0_rf_bw_switch_tab[] = {
-	/* bank, reg	bw/band			value */
-	{ MT_RF(0, 17),	RF_G_BAND | RF_BW_20,	0x00 },
-	{ MT_RF(0, 17),	RF_G_BAND | RF_BW_40,	0x00 },
-	{ MT_RF(0, 17),	RF_A_BAND | RF_BW_20,	0x00 },
-	{ MT_RF(0, 17),	RF_A_BAND | RF_BW_40,	0x00 },
-	{ MT_RF(0, 17),	RF_A_BAND | RF_BW_80,	0x00 },
-	{ MT_RF(7,  6),	RF_G_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7,  6),	RF_G_BAND | RF_BW_40,	0x1C },
-	{ MT_RF(7,  6),	RF_A_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7,  6),	RF_A_BAND | RF_BW_40,	0x20 },
-	{ MT_RF(7,  6),	RF_A_BAND | RF_BW_80,	0x10 },
-	{ MT_RF(7,  7),	RF_G_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7,  7),	RF_G_BAND | RF_BW_40,	0x20 },
-	{ MT_RF(7,  7),	RF_A_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7,  7),	RF_A_BAND | RF_BW_40,	0x20 },
-	{ MT_RF(7,  7),	RF_A_BAND | RF_BW_80,	0x10 },
-	{ MT_RF(7,  8),	RF_G_BAND | RF_BW_20,	0x03 },
-	{ MT_RF(7,  8),	RF_G_BAND | RF_BW_40,	0x01 },
-	{ MT_RF(7,  8),	RF_A_BAND | RF_BW_20,	0x03 },
-	{ MT_RF(7,  8),	RF_A_BAND | RF_BW_40,	0x01 },
-	{ MT_RF(7,  8),	RF_A_BAND | RF_BW_80,	0x00 },
-	{ MT_RF(7, 58),	RF_G_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7, 58),	RF_G_BAND | RF_BW_40,	0x40 },
-	{ MT_RF(7, 58),	RF_A_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7, 58),	RF_A_BAND | RF_BW_40,	0x40 },
-	{ MT_RF(7, 58),	RF_A_BAND | RF_BW_80,	0x10 },
-	{ MT_RF(7, 59),	RF_G_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7, 59),	RF_G_BAND | RF_BW_40,	0x40 },
-	{ MT_RF(7, 59),	RF_A_BAND | RF_BW_20,	0x40 },
-	{ MT_RF(7, 59),	RF_A_BAND | RF_BW_40,	0x40 },
-	{ MT_RF(7, 59),	RF_A_BAND | RF_BW_80,	0x10 },
-	{ MT_RF(7, 60),	RF_G_BAND | RF_BW_20,	0xAA },
-	{ MT_RF(7, 60),	RF_G_BAND | RF_BW_40,	0xAA },
-	{ MT_RF(7, 60),	RF_A_BAND | RF_BW_20,	0xAA },
-	{ MT_RF(7, 60),	RF_A_BAND | RF_BW_40,	0xAA },
-	{ MT_RF(7, 60),	RF_A_BAND | RF_BW_80,	0xAA },
-	{ MT_RF(7, 76),	RF_BW_20,		0x40 },
-	{ MT_RF(7, 76),	RF_BW_40,		0x40 },
-	{ MT_RF(7, 76),	RF_BW_80,		0x10 },
-	{ MT_RF(7, 77),	RF_BW_20,		0x40 },
-	{ MT_RF(7, 77),	RF_BW_40,		0x40 },
-	{ MT_RF(7, 77),	RF_BW_80,		0x10 },
-};
-
 static const struct mt76x0_rf_switch_item mt76x0_rf_band_switch_tab[] = {
 	/* bank, reg		bw/band		value */
 	{ MT_RF(0,  16),	RF_G_BAND,	0x20 },
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 37e1ead1dc85..10041e673c31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -239,17 +239,61 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 	}
 }
 
+
+static void mt76x0_phy_rf_switch_band(struct mt76x02_dev *dev,
+				      struct cfg80211_chan_def *chandef)
+{
+	enum nl80211_chan_width width = NL80211_CHAN_WIDTH_20;
+	enum nl80211_band band = NL80211_BAND_2GHZ;
+	u8 r6, r7, r8;
+	u8 r58_59_76 = 0x40;
+
+	if (chandef) {
+		band = chandef->chan->band;
+		width = chandef->width;
+	}
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_80:
+		r6 = r7 = 0x10;
+		r8 = 0x00;
+		r58_59_76 = 0x10;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		r6 = r7 = 0x20;
+		if (band == NL80211_BAND_2GHZ)
+			r6 = 0x1c;
+		r8 = 0x01;
+		break;
+	default:
+		r6 = r7 = 0x40;
+		r8 = 0x03;
+		break;
+	}
+
+	mt76x0_rf_wr(dev, MT_RF(0, 17), 0x00);
+	mt76x0_rf_wr(dev, MT_RF(7, 6), r6);
+	mt76x0_rf_wr(dev, MT_RF(7, 7), r7);
+	mt76x0_rf_wr(dev, MT_RF(7, 8), r8);
+	mt76x0_rf_wr(dev, MT_RF(7, 58), r58_59_76);
+	mt76x0_rf_wr(dev, MT_RF(7, 59), r58_59_76);
+	mt76x0_rf_wr(dev, MT_RF(7, 60), 0xaa);
+	mt76x0_rf_wr(dev, MT_RF(7, 76), r58_59_76);
+}
+
 static void
-mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_band)
+mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev,
+			      struct cfg80211_chan_def *chandef, u16 rf_bw_band)
 {
 	const struct mt76x0_freq_item *freq_item;
 	u16 rf_band = rf_bw_band & 0xff00;
-	u16 rf_bw = rf_bw_band & 0x00ff;
 	enum nl80211_band band;
 	bool b_sdm = false;
 	u32 mac_reg;
+	u8 channel;
 	int i;
 
+	channel = chandef->chan->hw_value;
 	for (i = 0; i < ARRAY_SIZE(mt76x0_sdm_channel); i++) {
 		if (channel == mt76x0_sdm_channel[i]) {
 			b_sdm = true;
@@ -344,18 +388,7 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
-		if (rf_bw == mt76x0_rf_bw_switch_tab[i].bw_band) {
-			mt76x0_rf_wr(dev,
-				     mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				     mt76x0_rf_bw_switch_tab[i].value);
-		} else if ((rf_bw == (mt76x0_rf_bw_switch_tab[i].bw_band & 0xFF)) &&
-			   (rf_band & mt76x0_rf_bw_switch_tab[i].bw_band)) {
-			mt76x0_rf_wr(dev,
-				     mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
-				     mt76x0_rf_bw_switch_tab[i].value);
-		}
-	}
+	mt76x0_phy_rf_switch_band(dev, chandef);
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & rf_band) {
@@ -623,7 +656,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 		 ext_cca_chan[ch_group_index]);
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
-	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
+	mt76x0_phy_set_chan_rf_params(dev, chandef, rf_bw_band);
 
 	/* set Japan Tx filter at channel 14 */
 	if (channel == 14)
@@ -751,15 +784,7 @@ static void mt76x0_phy_rf_init(struct mt76x02_dev *dev)
 	RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
 	RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
 	RF_RANDOM_WRITE(dev, mt76x0_rf_vga_channel_0_tab);
-
-	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
-		const struct mt76x0_rf_switch_item *item = &mt76x0_rf_bw_switch_tab[i];
-
-		if (item->bw_band == RF_BW_20)
-			mt76x0_rf_wr(dev, item->rf_bank_reg, item->value);
-		else if (((RF_G_BAND | RF_BW_20) & item->bw_band) == (RF_G_BAND | RF_BW_20))
-			mt76x0_rf_wr(dev, item->rf_bank_reg, item->value);
-	}
+	mt76x0_phy_rf_switch_band(dev, NULL);
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
 		if (mt76x0_rf_band_switch_tab[i].bw_band & RF_G_BAND) {
-- 
2.17.0

