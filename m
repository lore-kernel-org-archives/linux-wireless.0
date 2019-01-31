Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14112C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1AE9218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbfAaMWW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:22 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53736 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732461AbfAaMWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:12 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLsEx016785, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLsEx016785
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:54 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:53 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/24] rtw88: add 8822c tx power index table parsing support
Date:   Thu, 31 Jan 2019 20:21:26 +0800
Message-ID: <1548937297-14660-14-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

For power by rate table, 8822b needs to use bcd2bin() to parse the
table, while 8822c does not. Variable is_pwr_by_rate_dec is used to
identify whether we need to treat the value from the table as BCD code
or not.
And since the unit of tx power index diff is changed in 8822c, the index
is multiplied by a factor to get desired index value.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/main.c     |  3 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 drivers/net/wireless/realtek/rtw88/phy.c      | 95 ++++++++++++++++-----------
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |  2 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  2 +
 5 files changed, 63 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 8a2ec8a..dcc3b1b 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1042,8 +1042,7 @@ static int rtw_chip_board_info_setup(struct rtw_dev *rtwdev)
 	rtw_phy_setup_phy_cond(rtwdev, 0);
 
 	rtw_hw_init_tx_power(hal);
-	if (rtwdev->chip->id != RTW_CHIP_TYPE_8822C)
-		rtw_load_table(rtwdev, rfe_def->phy_pg_tbl);
+	rtw_load_table(rtwdev, rfe_def->phy_pg_tbl);
 	rtw_load_table(rtwdev, rfe_def->txpwr_lmt_tbl);
 	rtw_phy_tx_power_by_rate_config(hal);
 	rtw_phy_tx_power_limit_config(hal);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index f28f086e..03b1e4c 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -807,6 +807,8 @@ struct rtw_chip_info {
 	u8 csi_buf_pg_num;
 	u8 dig_max;
 	u8 dig_min;
+	u8 txgi_factor;
+	bool is_pwr_by_rate_dec;
 
 	bool ht_supported;
 	bool vht_supported;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index a3cade2..cbb96a6 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -959,13 +959,16 @@ static u8 rtw_get_channel_group(u8 channel)
 	}
 }
 
-static u8 phy_get_2g_tx_power_index(struct rtw_2g_txpwr_idx *pwr_idx_2g,
+static u8 phy_get_2g_tx_power_index(struct rtw_dev *rtwdev,
+				    struct rtw_2g_txpwr_idx *pwr_idx_2g,
 				    enum rtw_bandwidth bandwidth,
 				    u8 rate, u8 group)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 tx_power;
 	bool mcs_rate;
 	bool above_2ss;
+	u8 factor = chip->txgi_factor;
 
 	if (rate <= DESC_RATE11M)
 		tx_power = pwr_idx_2g->cck_base[group];
@@ -973,7 +976,7 @@ static u8 phy_get_2g_tx_power_index(struct rtw_2g_txpwr_idx *pwr_idx_2g,
 		tx_power = pwr_idx_2g->bw40_base[group];
 
 	if (rate >= DESC_RATE6M && rate <= DESC_RATE54M)
-		tx_power += pwr_idx_2g->ht_1s_diff.ofdm;
+		tx_power += pwr_idx_2g->ht_1s_diff.ofdm * factor;
 
 	mcs_rate = (rate >= DESC_RATEMCS0 && rate <= DESC_RATEMCS15) ||
 		   (rate >= DESC_RATEVHT1SS_MCS0 &&
@@ -988,28 +991,31 @@ static u8 phy_get_2g_tx_power_index(struct rtw_2g_txpwr_idx *pwr_idx_2g,
 	default:
 		WARN_ON(1);
 	case RTW_CHANNEL_WIDTH_20:
-		tx_power += pwr_idx_2g->ht_1s_diff.bw20;
+		tx_power += pwr_idx_2g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
-			tx_power += pwr_idx_2g->ht_2s_diff.bw20;
+			tx_power += pwr_idx_2g->ht_2s_diff.bw20 * factor;
 		break;
 	case RTW_CHANNEL_WIDTH_40:
 		/* bw40 is the base power */
 		if (above_2ss)
-			tx_power += pwr_idx_2g->ht_2s_diff.bw40;
+			tx_power += pwr_idx_2g->ht_2s_diff.bw40 * factor;
 		break;
 	}
 
 	return tx_power;
 }
 
-static u8 phy_get_5g_tx_power_index(struct rtw_5g_txpwr_idx *pwr_idx_5g,
+static u8 phy_get_5g_tx_power_index(struct rtw_dev *rtwdev,
+				    struct rtw_5g_txpwr_idx *pwr_idx_5g,
 				    enum rtw_bandwidth bandwidth,
 				    u8 rate, u8 group)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 tx_power;
 	u8 upper, lower;
 	bool mcs_rate;
 	bool above_2ss;
+	u8 factor = chip->txgi_factor;
 
 	tx_power = pwr_idx_5g->bw40_base[group];
 
@@ -1020,7 +1026,7 @@ static u8 phy_get_5g_tx_power_index(struct rtw_5g_txpwr_idx *pwr_idx_5g,
 		    (rate >= DESC_RATEVHT2SS_MCS0);
 
 	if (!mcs_rate) {
-		tx_power += pwr_idx_5g->ht_1s_diff.ofdm;
+		tx_power += pwr_idx_5g->ht_1s_diff.ofdm * factor;
 		return tx_power;
 	}
 
@@ -1028,14 +1034,14 @@ static u8 phy_get_5g_tx_power_index(struct rtw_5g_txpwr_idx *pwr_idx_5g,
 	default:
 		WARN_ON(1);
 	case RTW_CHANNEL_WIDTH_20:
-		tx_power += pwr_idx_5g->ht_1s_diff.bw20;
+		tx_power += pwr_idx_5g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
-			tx_power += pwr_idx_5g->ht_2s_diff.bw20;
+			tx_power += pwr_idx_5g->ht_2s_diff.bw20 * factor;
 		break;
 	case RTW_CHANNEL_WIDTH_40:
 		/* bw40 is the base power */
 		if (above_2ss)
-			tx_power += pwr_idx_5g->ht_2s_diff.bw40;
+			tx_power += pwr_idx_5g->ht_2s_diff.bw40 * factor;
 		break;
 	case RTW_CHANNEL_WIDTH_80:
 		/* the base idx of bw80 is the average of bw40+/bw40- */
@@ -1043,9 +1049,9 @@ static u8 phy_get_5g_tx_power_index(struct rtw_5g_txpwr_idx *pwr_idx_5g,
 		upper = pwr_idx_5g->bw40_base[group + 1];
 
 		tx_power = (lower + upper) / 2;
-		tx_power += pwr_idx_5g->vht_1s_diff.bw80;
+		tx_power += pwr_idx_5g->vht_1s_diff.bw80 * factor;
 		if (above_2ss)
-			tx_power += pwr_idx_5g->vht_2s_diff.bw80;
+			tx_power += pwr_idx_5g->vht_2s_diff.bw80 * factor;
 		break;
 	}
 
@@ -1108,12 +1114,14 @@ u8 phy_get_tx_power_index(void *adapter, u8 rf_path, u8 rate,
 	/* base power index for 2.4G/5G */
 	if (channel <= 14) {
 		band = PHY_BAND_2G;
-		tx_power = phy_get_2g_tx_power_index(&pwr_idx->pwr_idx_2g,
+		tx_power = phy_get_2g_tx_power_index(rtwdev,
+						     &pwr_idx->pwr_idx_2g,
 						     bandwidth, rate, group);
 		offset = hal->tx_pwr_by_rate_offset_2g[rf_path][rate];
 	} else {
 		band = PHY_BAND_5G;
-		tx_power = phy_get_5g_tx_power_index(&pwr_idx->pwr_idx_5g,
+		tx_power = phy_get_5g_tx_power_index(rtwdev,
+						     &pwr_idx->pwr_idx_5g,
 						     bandwidth, rate, group);
 		offset = hal->tx_pwr_by_rate_offset_5g[rf_path][rate];
 	}
@@ -1167,6 +1175,14 @@ void phy_set_tx_power_index_by_rs(void *adapter, u8 ch, u8 path, u8 rs)
 	}
 }
 
+static u8 tbl_to_dec_pwr_by_rate(struct rtw_dev *rtwdev, u32 hex, u8 i)
+{
+	if (rtwdev->chip->is_pwr_by_rate_dec)
+		return bcd_to_dec_pwr_by_rate(hex, i);
+	else
+		return (hex >> (i * 8)) & 0xFF;
+}
+
 static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 						 u32 addr, u32 mask,
 						 u32 val, u8 *rate,
@@ -1182,7 +1198,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATE12M;
 		rate[3] = DESC_RATE18M;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xE04:
@@ -1192,7 +1208,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATE48M;
 		rate[3] = DESC_RATE54M;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xE08:
@@ -1207,7 +1223,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 			rate[2] = DESC_RATE11M;
 			for (i = 1; i < 4; ++i)
 				pwr_by_rate[i - 1] =
-					bcd_to_dec_pwr_by_rate(val, i);
+					tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 			*rate_num = 3;
 		} else if (mask == 0x000000ff) {
 			rate[0] = DESC_RATE11M;
@@ -1222,7 +1238,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS2;
 		rate[3] = DESC_RATEMCS3;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xE14:
@@ -1232,7 +1248,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS6;
 		rate[3] = DESC_RATEMCS7;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xE18:
@@ -1242,7 +1258,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS10;
 		rate[3] = DESC_RATEMCS11;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xE1C:
@@ -1252,7 +1268,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS14;
 		rate[3] = DESC_RATEMCS15;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 
 		break;
@@ -1261,7 +1277,8 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[1] = DESC_RATE2M;
 		rate[2] = DESC_RATE5_5M;
 		for (i = 1; i < 4; ++i)
-			pwr_by_rate[i - 1] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i - 1] = tbl_to_dec_pwr_by_rate(rtwdev,
+								    val, i);
 		*rate_num = 3;
 		break;
 	case 0xC20:
@@ -1273,7 +1290,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATE5_5M;
 		rate[3] = DESC_RATE11M;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC24:
@@ -1285,7 +1302,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATE12M;
 		rate[3] = DESC_RATE18M;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC28:
@@ -1297,7 +1314,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATE48M;
 		rate[3] = DESC_RATE54M;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC2C:
@@ -1309,7 +1326,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS2;
 		rate[3] = DESC_RATEMCS3;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC30:
@@ -1321,7 +1338,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS6;
 		rate[3] = DESC_RATEMCS7;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC34:
@@ -1333,7 +1350,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS10;
 		rate[3] = DESC_RATEMCS11;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC38:
@@ -1345,7 +1362,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS14;
 		rate[3] = DESC_RATEMCS15;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC3C:
@@ -1357,7 +1374,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT1SS_MCS2;
 		rate[3] = DESC_RATEVHT1SS_MCS3;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC40:
@@ -1369,7 +1386,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT1SS_MCS6;
 		rate[3] = DESC_RATEVHT1SS_MCS7;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC44:
@@ -1381,7 +1398,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT2SS_MCS0;
 		rate[3] = DESC_RATEVHT2SS_MCS1;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC48:
@@ -1393,7 +1410,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT2SS_MCS4;
 		rate[3] = DESC_RATEVHT2SS_MCS5;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xC4C:
@@ -1405,7 +1422,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT2SS_MCS8;
 		rate[3] = DESC_RATEVHT2SS_MCS9;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xCD8:
@@ -1417,7 +1434,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS18;
 		rate[3] = DESC_RATEMCS19;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xCDC:
@@ -1429,7 +1446,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEMCS22;
 		rate[3] = DESC_RATEMCS23;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xCE0:
@@ -1441,7 +1458,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT3SS_MCS2;
 		rate[3] = DESC_RATEVHT3SS_MCS3;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xCE4:
@@ -1453,7 +1470,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[2] = DESC_RATEVHT3SS_MCS6;
 		rate[3] = DESC_RATEVHT3SS_MCS7;
 		for (i = 0; i < 4; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 4;
 		break;
 	case 0xCE8:
@@ -1463,7 +1480,7 @@ static void phy_get_rate_values_of_txpwr_by_rate(struct rtw_dev *rtwdev,
 		rate[0] = DESC_RATEVHT3SS_MCS8;
 		rate[1] = DESC_RATEVHT3SS_MCS9;
 		for (i = 0; i < 2; ++i)
-			pwr_by_rate[i] = bcd_to_dec_pwr_by_rate(val, i);
+			pwr_by_rate[i] = tbl_to_dec_pwr_by_rate(rtwdev, val, i);
 		*rate_num = 2;
 		break;
 	default:
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 0339041..fefc83d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1563,6 +1563,8 @@ struct rtw_chip_info rtw8822b_hw_spec = {
 	.ptct_efuse_size = 96,
 	.txff_size = 262144,
 	.rxff_size = 24576,
+	.txgi_factor = 1,
+	.is_pwr_by_rate_dec = true,
 	.csi_buf_pg_num = 0,
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = 128,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 40008d7..19e8e7b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -1180,6 +1180,8 @@ struct rtw_chip_info rtw8822c_hw_spec = {
 	.ptct_efuse_size = 124,
 	.txff_size = 262144,
 	.rxff_size = 24576,
+	.txgi_factor = 2,
+	.is_pwr_by_rate_dec = false,
 	.csi_buf_pg_num = 50,
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = 128,
-- 
2.7.4

