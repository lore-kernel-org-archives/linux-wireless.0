Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C25BC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C04D222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbfBNI7n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:43 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39605 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbfBNI7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:41 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xJfm005863, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xJfm005863
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:19 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:19 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 10/24] rtw88: 8822c: update channel setting
Date:   Thu, 14 Feb 2019 16:58:49 +0800
Message-ID: <1550134743-17443-11-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chien-Hsun Liao <ben.liao@realtek.com>

Update BB and RF channel settings. The old settings are not compatible
with most of the chips now. To swtich to a target channel correctly,
many of the PHY parameters needs to be modified.

For BB, the DAC clock setting, CCK tx filter coefficient and OFDM dfir
should be updated in order to meet 802.11 standards of spectral mask.
CCK trx settings should be modified based on different band, because the
CCK signals are not allowed in 5G bands.

For RF, subband setting should be corrected, ch-140 ~ ch-144 is in
band-3 instead of band-4. Also rx amplifier should be set to different
values in different bandwidth, otherwise the rx sensitivity will
degrade.

Note the settings are based on phy parameter v27 table, should be
applied together to make sure it work.

Signed-off-by: Chien-Hsun Liao <ben.liao@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 85 +++++++++++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 15 +++--
 3 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 56137cf5..8d8dbc5 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -412,6 +412,7 @@
 #define RF_XTALX2	0xb8
 #define RF_MALSEL	0xbe
 #define RF_LUTDBG	0xdf
+#define RF_LUTWE2	0xee
 #define RF_LUTWE	0xef
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 7dd1d15..c10894e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -337,6 +337,7 @@ static void rtw8822c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 #define RF18_BW_80M		(BIT(12))
 
 	u32 rf_reg18 = 0;
+	u32 rf_rxbb = 0;
 
 	rf_reg18 = rtw_read_rf(rtwdev, RF_PATH_A, 0x18, RFREG_MASK);
 
@@ -345,7 +346,7 @@ static void rtw8822c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 
 	rf_reg18 |= (channel <= 14 ? RF18_BAND_2G : RF18_BAND_5G);
 	rf_reg18 |= (channel & RF18_CHANNEL_MASK);
-	if (channel > 140)
+	if (channel > 144)
 		rf_reg18 |= RF18_RFSI_GT_CH140;
 	else if (channel >= 80)
 		rf_reg18 |= RF18_RFSI_GE_CH80;
@@ -356,16 +357,29 @@ static void rtw8822c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	case RTW_CHANNEL_WIDTH_20:
 	default:
 		rf_reg18 |= RF18_BW_20M;
+		rf_rxbb = 0x18;
 		break;
 	case RTW_CHANNEL_WIDTH_40:
 		/* RF bandwidth */
 		rf_reg18 |= RF18_BW_40M;
+		rf_rxbb = 0x10;
 		break;
 	case RTW_CHANNEL_WIDTH_80:
 		rf_reg18 |= RF18_BW_80M;
+		rf_rxbb = 0x8;
 		break;
 	}
 
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE2, 0x04, 0x01);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWA, 0x1f, 0x12);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWD0, 0xfffff, rf_rxbb);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE2, 0x04, 0x00);
+
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWE2, 0x04, 0x01);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWA, 0x1f, 0x12);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWD0, 0xfffff, rf_rxbb);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWE2, 0x04, 0x00);
+
 	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK, rf_reg18);
 	rtw_write_rf(rtwdev, RF_PATH_B, RF_CFGCH, RFREG_MASK, rf_reg18);
 }
@@ -385,7 +399,9 @@ static void rtw8822c_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 				    u8 primary_ch_idx)
 {
 	if (channel <= 14) {
-		rtw_write32_set(rtwdev, REG_ENCCK, BIT_CCK_BLK_EN);
+		rtw_write32_clr(rtwdev, REG_BGCTRL, BITS_RX_IQ_WEIGHT);
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
+		rtw_write32_set(rtwdev, REG_TXF4, BIT(20));
 		rtw_write32_clr(rtwdev, REG_CCK_CHECK, BIT_CHECK_CCK_EN);
 		rtw_write32_clr(rtwdev, REG_CCKTXONLY, BIT_BB_CCK_CHECK_EN);
 		rtw_write32_mask(rtwdev, REG_CCAMSK, 0x3F000000, 0xF);
@@ -398,22 +414,43 @@ static void rtw8822c_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x96a);
 		else
 			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x9aa);
-
 		if (channel == 14) {
-			rtw_write32_mask(rtwdev, REG_PSFGC2, MASKDWORD, 0x0000b81c);
-			rtw_write32_mask(rtwdev, REG_PSFGC6, MASKLWORD, 0x0000);
-			rtw_write32_mask(rtwdev, REG_PSFGC, MASKDWORD, 0x00003667);
+			rtw_write32_mask(rtwdev, REG_TXF0, MASKHWORD, 0x3da0);
+			rtw_write32_mask(rtwdev, REG_TXF1, MASKDWORD,
+					 0x4962c931);
+			rtw_write32_mask(rtwdev, REG_TXF2, MASKLWORD, 0x6aa3);
+			rtw_write32_mask(rtwdev, REG_TXF3, MASKHWORD, 0xaa7b);
+			rtw_write32_mask(rtwdev, REG_TXF4, MASKLWORD, 0xf3d7);
+			rtw_write32_mask(rtwdev, REG_TXF5, MASKDWORD, 0x0);
+			rtw_write32_mask(rtwdev, REG_TXF6, MASKDWORD,
+					 0xff012455);
+			rtw_write32_mask(rtwdev, REG_TXF7, MASKDWORD, 0xffff);
 		} else {
-			rtw_write32_mask(rtwdev, REG_PSFGC2, MASKDWORD, 0x64b80c1c);
-			rtw_write32_mask(rtwdev, REG_PSFGC6, MASKLWORD, 0x8810);
-			rtw_write32_mask(rtwdev, REG_PSFGC, MASKDWORD, 0x01235667);
+			rtw_write32_mask(rtwdev, REG_TXF0, MASKHWORD, 0x5284);
+			rtw_write32_mask(rtwdev, REG_TXF1, MASKDWORD,
+					 0x3e18fec8);
+			rtw_write32_mask(rtwdev, REG_TXF2, MASKLWORD, 0x0a88);
+			rtw_write32_mask(rtwdev, REG_TXF3, MASKHWORD, 0xacc4);
+			rtw_write32_mask(rtwdev, REG_TXF4, MASKLWORD, 0xc8b2);
+			rtw_write32_mask(rtwdev, REG_TXF5, MASKDWORD,
+					 0x00faf0de);
+			rtw_write32_mask(rtwdev, REG_TXF6, MASKDWORD,
+					 0x00122344);
+			rtw_write32_mask(rtwdev, REG_TXF7, MASKDWORD,
+					 0x0fffffff);
 		}
+		if (channel == 13)
+			rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x3);
+		else
+			rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x1);
 	} else if (channel > 35) {
 		rtw_write32_set(rtwdev, REG_CCKTXONLY, BIT_BB_CCK_CHECK_EN);
 		rtw_write32_set(rtwdev, REG_CCK_CHECK, BIT_CHECK_CCK_EN);
-		rtw_write32_clr(rtwdev, REG_ENCCK, BIT_CCK_BLK_EN);
+		rtw_write32_set(rtwdev, REG_BGCTRL, BITS_RX_IQ_WEIGHT);
+		rtw_write32_clr(rtwdev, REG_TXF4, BIT(20));
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x0);
 		rtw_write32_mask(rtwdev, REG_CCAMSK, 0x3F000000, 0x22);
-
+		rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x3);
 		if (channel >= 36 && channel <= 64) {
 			rtw_write32_mask(rtwdev, REG_RXAGCCTL0, 0x1f0, 0x1);
 			rtw_write32_mask(rtwdev, REG_RXAGCCTL, 0x1f0, 0x1);
@@ -443,13 +480,9 @@ static void rtw8822c_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 	case RTW_CHANNEL_WIDTH_20:
 		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x19B);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xc0, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xff00,
-				 (primary_ch_idx | (primary_ch_idx << 4)));
-		rtw_write32_mask(rtwdev, REG_TXCLK, MASKH3BYTES, 0xdb6db6);
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0xffffc000, 0x1F8A3);
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0x1, 0x0);
-		rtw_write32_mask(rtwdev, REG_DYMTHMIN, 0x3f, 0x1a);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x7);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x6);
 		break;
 	case RTW_CHANNEL_WIDTH_40:
 		rtw_write32_mask(rtwdev, REG_CCKSB, BIT(4),
@@ -458,33 +491,26 @@ static void rtw8822c_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xc0, 0x0);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xff00,
 				 (primary_ch_idx | (primary_ch_idx << 4)));
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0xffffc000, 0x1D821);
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0x1, 0x0);
-		rtw_write32_mask(rtwdev, REG_DYMTHMIN, MASK12BITS, 0x618);
-		rtw_write32_mask(rtwdev, REG_DYMENTH0, 0x3ffff, 0x1D821);
 		break;
 	case RTW_CHANNEL_WIDTH_80:
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0xa);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xc0, 0x0);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xff00,
 				 (primary_ch_idx | (primary_ch_idx << 4)));
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0xffffc000, 0x1B79F);
-		rtw_write32_mask(rtwdev, REG_DYMPRITH, 0x1, 0x0);
-		rtw_write32_mask(rtwdev, REG_DYMTHMIN, 0x3ffff, 0x18596);
-		rtw_write32_mask(rtwdev, REG_DYMENTH0, 0x3FFFFFFF, 0x2085D75E);
-		rtw_write32_mask(rtwdev, REG_DYMENTH, 0x3f, 0x1d);
 		break;
 	case RTW_CHANNEL_WIDTH_5:
 		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x2AB);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x1);
-		rtw_write32_mask(rtwdev, REG_TXCLK, MASKH3BYTES, 0xDB4DB2);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x4);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x4);
 		break;
 	case RTW_CHANNEL_WIDTH_10:
 		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x2AB);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
 		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x2);
-		rtw_write32_mask(rtwdev, REG_TXCLK, MASKH3BYTES, 0xDB5DB4);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x6);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x5);
 		break;
 	}
 }
@@ -551,7 +577,6 @@ static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
 
 	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x0);
-		rtw_write32_mask(rtwdev, REG_PCCAWT, 0x80000000, 0x0);
 	} else if (rx_path == BB_PATH_AB) {
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x1);
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00060000, 0x1);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index d4806fd..fa71104 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -119,6 +119,7 @@ struct rtw8822c_efuse {
 #define REG_ANAPARLDO_POW_MAC	0x0029
 #define BIT_LDOE25_PON		BIT(0)
 
+#define REG_TXDFIR0	0x808
 #define REG_DFIRBW	0x810
 #define REG_ANTMAP0	0x820
 #define REG_ANTMAP	0x824
@@ -140,16 +141,22 @@ struct rtw8822c_efuse {
 #define REG_RXAGCCTL0	0x18ac
 #define REG_CCKSB	0x1a00
 #define REG_RXCCKSEL	0x1a04
-#define REG_PSFGC2	0x1a24
-#define REG_PSFGC6	0x1a28
+#define REG_BGCTRL	0x1a14
+#define BITS_RX_IQ_WEIGHT	(BIT(8) | BIT(9))
+#define REG_TXF0	0x1a20
+#define REG_TXF1	0x1a24
+#define REG_TXF2	0x1a28
 #define REG_CCANRX	0x1a2c
 #define BIT_CCK_FA_RST		(BIT(14) | BIT(15))
 #define BIT_OFDM_FA_RST		(BIT(12) | BIT(13))
 #define REG_CCK_FACNT	0x1a5c
 #define REG_CCKTXONLY	0x1a80
 #define BIT_BB_CCK_CHECK_EN	BIT(18)
-#define REG_PSFGC	0x1aac
-#define REG_PCCAWT	0x1ac0
+#define REG_TXF3	0x1a98
+#define REG_TXF4	0x1a9c
+#define REG_TXF5	0x1aa0
+#define REG_TXF6	0x1aac
+#define REG_TXF7	0x1ab0
 #define REG_TXANT	0x1c28
 #define REG_ENCCK	0x1c3c
 #define BIT_CCK_BLK_EN		BIT(1)
-- 
2.7.4

