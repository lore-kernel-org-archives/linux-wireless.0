Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7B3C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDCB218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbfAaMWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:20 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53738 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732824AbfAaMWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:12 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLsjC016789, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLsjC016789
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:54 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:54 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/24] rtw88: add 8822c tx agc support
Date:   Thu, 31 Jan 2019 20:21:27 +0800
Message-ID: <1548937297-14660-15-git-send-email-yhchuang@realtek.com>
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

Compared with 8822b, 8822c writes TX AGC table by reference and
difference. These values can be calculated after we have a complete tx
power table. Hence, driver needs to maintain a tx power table and
collects the indexes before writing them into the tx agc table to let
8822b and 8822c chips share the same configuration flow.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/main.h     |  6 +-
 drivers/net/wireless/realtek/rtw88/phy.c      | 83 ++++++++++++++-------------
 drivers/net/wireless/realtek/rtw88/phy.h      |  9 +++
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 43 ++++++++------
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 77 ++++++++++++++++++++++++-
 5 files changed, 156 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 03b1e4c..fb7ea58 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -613,8 +613,7 @@ struct rtw_chip_ops {
 		       u32 addr, u32 mask);
 	bool (*write_rf)(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 			 u32 addr, u32 mask, u32 data);
-	void (*set_tx_power_index)(struct rtw_dev *rtwdev, u8 power_index,
-				   u8 rf_path, u8 rate);
+	void (*set_tx_power_index)(struct rtw_dev *rtwdev);
 	int (*rsvd_page_dump)(struct rtw_dev *rtwdev, u8 *buf, u32 offset,
 			      u32 size);
 	void (*set_antenna)(struct rtw_dev *rtwdev, u8 antenna_tx,
@@ -809,6 +808,7 @@ struct rtw_chip_info {
 	u8 dig_min;
 	u8 txgi_factor;
 	bool is_pwr_by_rate_dec;
+	u8 max_power_index;
 
 	bool ht_supported;
 	bool vht_supported;
@@ -996,6 +996,8 @@ struct rtw_hal {
 			  [RTW_CHANNEL_WIDTH_MAX]
 			  [RTW_RATE_SECTION_MAX]
 			  [RTW_MAX_CHANNEL_NUM_5G];
+	s8 tx_pwr_tbl[RTW_RF_PATH_MAX]
+		     [DESC_RATE_MAX];
 };
 
 struct rtw_dev {
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index cbb96a6..8b88354 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -812,33 +812,41 @@ void rtw_phy_load_tables(struct rtw_dev *rtwdev)
 
 #define RTW_MAX_POWER_INDEX		0x3F
 
-static u8 cck_rates[] = {DESC_RATE1M, DESC_RATE2M, DESC_RATE5_5M, DESC_RATE11M};
-static u8 ofdm_rates[] = {DESC_RATE6M,  DESC_RATE9M,  DESC_RATE12M,
-			  DESC_RATE18M, DESC_RATE24M, DESC_RATE36M,
-			  DESC_RATE48M, DESC_RATE54M};
-static u8 ht_1s_rates[] = {DESC_RATEMCS0, DESC_RATEMCS1, DESC_RATEMCS2,
-			   DESC_RATEMCS3, DESC_RATEMCS4, DESC_RATEMCS5,
-			   DESC_RATEMCS6, DESC_RATEMCS7};
-static u8 ht_2s_rates[] = {DESC_RATEMCS8,  DESC_RATEMCS9,  DESC_RATEMCS10,
-			   DESC_RATEMCS11, DESC_RATEMCS12, DESC_RATEMCS13,
-			   DESC_RATEMCS14, DESC_RATEMCS15};
-static u8 vht_1s_rates[] = {DESC_RATEVHT1SS_MCS0, DESC_RATEVHT1SS_MCS1,
-			    DESC_RATEVHT1SS_MCS2, DESC_RATEVHT1SS_MCS3,
-			    DESC_RATEVHT1SS_MCS4, DESC_RATEVHT1SS_MCS5,
-			    DESC_RATEVHT1SS_MCS6, DESC_RATEVHT1SS_MCS7,
-			    DESC_RATEVHT1SS_MCS8, DESC_RATEVHT1SS_MCS9};
-static u8 vht_2s_rates[] = {DESC_RATEVHT2SS_MCS0, DESC_RATEVHT2SS_MCS1,
-			    DESC_RATEVHT2SS_MCS2, DESC_RATEVHT2SS_MCS3,
-			    DESC_RATEVHT2SS_MCS4, DESC_RATEVHT2SS_MCS5,
-			    DESC_RATEVHT2SS_MCS6, DESC_RATEVHT2SS_MCS7,
-			    DESC_RATEVHT2SS_MCS8, DESC_RATEVHT2SS_MCS9};
-static u8 cck_size = ARRAY_SIZE(cck_rates);
-static u8 ofdm_size = ARRAY_SIZE(ofdm_rates);
-static u8 ht_1s_size = ARRAY_SIZE(ht_1s_rates);
-static u8 ht_2s_size = ARRAY_SIZE(ht_2s_rates);
-static u8 vht_1s_size = ARRAY_SIZE(vht_1s_rates);
-static u8 vht_2s_size = ARRAY_SIZE(vht_2s_rates);
-
+u8 cck_rates[] = {DESC_RATE1M, DESC_RATE2M, DESC_RATE5_5M, DESC_RATE11M};
+u8 ofdm_rates[] = {DESC_RATE6M,  DESC_RATE9M,  DESC_RATE12M,
+		   DESC_RATE18M, DESC_RATE24M, DESC_RATE36M,
+		   DESC_RATE48M, DESC_RATE54M};
+u8 ht_1s_rates[] = {DESC_RATEMCS0, DESC_RATEMCS1, DESC_RATEMCS2,
+		    DESC_RATEMCS3, DESC_RATEMCS4, DESC_RATEMCS5,
+		    DESC_RATEMCS6, DESC_RATEMCS7};
+u8 ht_2s_rates[] = {DESC_RATEMCS8,  DESC_RATEMCS9,  DESC_RATEMCS10,
+		    DESC_RATEMCS11, DESC_RATEMCS12, DESC_RATEMCS13,
+		    DESC_RATEMCS14, DESC_RATEMCS15};
+u8 vht_1s_rates[] = {DESC_RATEVHT1SS_MCS0, DESC_RATEVHT1SS_MCS1,
+		     DESC_RATEVHT1SS_MCS2, DESC_RATEVHT1SS_MCS3,
+		     DESC_RATEVHT1SS_MCS4, DESC_RATEVHT1SS_MCS5,
+		     DESC_RATEVHT1SS_MCS6, DESC_RATEVHT1SS_MCS7,
+		     DESC_RATEVHT1SS_MCS8, DESC_RATEVHT1SS_MCS9};
+u8 vht_2s_rates[] = {DESC_RATEVHT2SS_MCS0, DESC_RATEVHT2SS_MCS1,
+		     DESC_RATEVHT2SS_MCS2, DESC_RATEVHT2SS_MCS3,
+		     DESC_RATEVHT2SS_MCS4, DESC_RATEVHT2SS_MCS5,
+		     DESC_RATEVHT2SS_MCS6, DESC_RATEVHT2SS_MCS7,
+		     DESC_RATEVHT2SS_MCS8, DESC_RATEVHT2SS_MCS9};
+u8 cck_size = ARRAY_SIZE(cck_rates);
+u8 ofdm_size = ARRAY_SIZE(ofdm_rates);
+u8 ht_1s_size = ARRAY_SIZE(ht_1s_rates);
+u8 ht_2s_size = ARRAY_SIZE(ht_2s_rates);
+u8 vht_1s_size = ARRAY_SIZE(vht_1s_rates);
+u8 vht_2s_size = ARRAY_SIZE(vht_2s_rates);
+u8 *rate_section[RTW_RATE_SECTION_MAX] = {cck_rates, ofdm_rates,
+					  ht_1s_rates, ht_2s_rates,
+					  vht_1s_rates, vht_2s_rates};
+u8 rate_size[RTW_RATE_SECTION_MAX] = {ARRAY_SIZE(cck_rates),
+				      ARRAY_SIZE(ofdm_rates),
+				      ARRAY_SIZE(ht_1s_rates),
+				      ARRAY_SIZE(ht_2s_rates),
+				      ARRAY_SIZE(vht_1s_rates),
+				      ARRAY_SIZE(vht_2s_rates)};
 static const u8 rtw_channel_idx_5g[RTW_MAX_CHANNEL_NUM_5G] = {
 	36,  38,  40,  42,  44,  46,  48, /* Band 1 */
 	52,  54,  56,  58,  60,  62,  64, /* Band 2 */
@@ -1081,6 +1089,7 @@ void phy_set_tx_power_level_by_path(struct rtw_dev *rtwdev, u8 ch, u8 path)
 
 void rtw_phy_set_tx_power_level(struct rtw_dev *rtwdev, u8 channel)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_hal *hal = &rtwdev->hal;
 	u8 path;
 
@@ -1089,6 +1098,7 @@ void rtw_phy_set_tx_power_level(struct rtw_dev *rtwdev, u8 channel)
 	for (path = 0; path < hal->rf_path_num; path++)
 		phy_set_tx_power_level_by_path(rtwdev, channel, path);
 
+	chip->ops->set_tx_power_index(rtwdev);
 	mutex_unlock(&hal->tx_power_mutex);
 }
 
@@ -1134,8 +1144,8 @@ u8 phy_get_tx_power_index(void *adapter, u8 rf_path, u8 rate,
 
 	tx_power += offset;
 
-	if (tx_power > RTW_MAX_POWER_INDEX)
-		tx_power = RTW_MAX_POWER_INDEX;
+	if (tx_power > rtwdev->chip->max_power_index)
+		tx_power = rtwdev->chip->max_power_index;
 
 	return tx_power;
 }
@@ -1144,7 +1154,6 @@ void phy_set_tx_power_index_by_rs(void *adapter, u8 ch, u8 path, u8 rs)
 {
 	struct rtw_dev *rtwdev = adapter;
 	struct rtw_hal *hal = &rtwdev->hal;
-	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 regd = rtwdev->regd.txpwr_regd;
 	u8 *rates;
 	u8 size;
@@ -1152,26 +1161,18 @@ void phy_set_tx_power_index_by_rs(void *adapter, u8 ch, u8 path, u8 rs)
 	u8 pwr_idx;
 	u8 bw;
 	int i;
-	u8 *rate_sections[RTW_RATE_SECTION_MAX] = {
-		cck_rates, ofdm_rates, ht_1s_rates, ht_2s_rates,
-		vht_1s_rates, vht_2s_rates,
-	};
-	u8 sizes[RTW_RATE_SECTION_MAX] = {
-		cck_size, ofdm_size, ht_1s_size, ht_2s_size,
-		vht_1s_size, vht_2s_size,
-	};
 
 	if (rs >= RTW_RATE_SECTION_MAX)
 		return;
 
-	rates = rate_sections[rs];
-	size = sizes[rs];
+	rates = rate_section[rs];
+	size = rate_size[rs];
 	bw = hal->current_band_width;
 	for (i = 0; i < size; i++) {
 		rate = rates[i];
 		pwr_idx = phy_get_tx_power_index(adapter, path, rate, bw, ch,
 						 regd);
-		chip->ops->set_tx_power_index(rtwdev, pwr_idx, path, rate);
+		hal->tx_pwr_tbl[path][rate] = pwr_idx;
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index 2e26372..3bbfe00 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -7,6 +7,15 @@
 
 #include "debug.h"
 
+extern u8 cck_rates[];
+extern u8 ofdm_rates[];
+extern u8 ht_1s_rates[];
+extern u8 ht_2s_rates[];
+extern u8 vht_1s_rates[];
+extern u8 vht_2s_rates[];
+extern u8 *rate_section[];
+extern u8 rate_size[];
+
 void rtw_phy_init(struct rtw_dev *rtwdev);
 void rtw_phy_dynamic_mechanism(struct rtw_dev *rtwdev);
 u8 rtw_phy_rf_power_2_rssi(s8 *rf_power, u8 path_num);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index fefc83d..5e63096 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -888,27 +888,37 @@ static void rtw8822b_query_rx_desc(struct rtw_dev *rtwdev, u8 *rx_desc,
 	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status, phy_status);
 }
 
-static void rtw8822b_set_tx_power_index(struct rtw_dev *rtwdev, u8 power_index,
-					u8 path, u8 rate)
+static void
+rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
 {
+	struct rtw_hal *hal = &rtwdev->hal;
 	static const u32 offset_txagc[2] = {0x1d00, 0x1d80};
 	static u32 phy_pwr_idx;
-	u8 rate_idx;
-	u8 shift;
+	u8 rate, rate_idx, pwr_index, shift;
+	int j;
+
+	for (j = 0; j < rate_size[rs]; j++) {
+		rate = rate_section[rs][j];
+		pwr_index = hal->tx_pwr_tbl[path][rate];
+		shift = rate & 0x3;
+		phy_pwr_idx |= ((u32)pwr_index << (shift * 8));
+		if (shift == 0x3) {
+			rate_idx = rate & 0xfc;
+			rtw_write32(rtwdev, offset_txagc[path] + rate_idx,
+				    phy_pwr_idx);
+			phy_pwr_idx = 0;
+		}
+	}
+}
 
-	if (path > RF_PATH_B || rate > 0x53)
-		return;
+static void rtw8822b_set_tx_power_index(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	int rs, path;
 
-	/*
-	 * 8822B uses four bytes tx power index, driver needs to combine every
-	 * one-byte value for the phydm
-	 */
-	shift = rate & 0x3;
-	phy_pwr_idx |= ((u32)power_index << (shift * 8));
-	if (shift == 0x3) {
-		rate_idx = rate & 0xfc;
-		rtw_write32(rtwdev, offset_txagc[path] + rate_idx, phy_pwr_idx);
-		phy_pwr_idx = 0;
+	for (path = 0; path < hal->rf_path_num; path++) {
+		for (rs = 0; rs < RTW_RATE_SECTION_MAX; rs++)
+			rtw8822b_set_tx_power_index_by_rate(rtwdev, path, rs);
 	}
 }
 
@@ -1565,6 +1575,7 @@ struct rtw_chip_info rtw8822b_hw_spec = {
 	.rxff_size = 24576,
 	.txgi_factor = 1,
 	.is_pwr_by_rate_dec = true,
+	.max_power_index = 0x3f,
 	.csi_buf_pg_num = 0,
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = 128,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 19e8e7b..9c3f0f1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -751,10 +751,80 @@ static void rtw8822c_query_rx_desc(struct rtw_dev *rtwdev, u8 *rx_desc,
 	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status, phy_status);
 }
 
-static void rtw8822c_set_tx_power_index(struct rtw_dev *rtwdev, u8 power_index,
-					u8 path, u8 rate)
+static void
+rtw8822c_set_write_tx_power_ref(struct rtw_dev *rtwdev, u8 *tx_pwr_ref_cck,
+				u8 *tx_pwr_ref_ofdm)
 {
-	/* 8822C will use TSSI to track tx power */
+	struct rtw_hal *hal = &rtwdev->hal;
+	u32 txref_cck[2] = {0x18a0, 0x41a0};
+	u32 txref_ofdm[2] = {0x18e8, 0x41e8};
+	u8 path;
+
+	for (path = 0; path < hal->rf_path_num; path++) {
+		rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0);
+		rtw_write32_mask(rtwdev, txref_cck[path], 0x7f0000,
+				 tx_pwr_ref_cck[path]);
+	}
+	for (path = 0; path < hal->rf_path_num; path++) {
+		rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0);
+		rtw_write32_mask(rtwdev, txref_ofdm[path], 0x1fc00,
+				 tx_pwr_ref_ofdm[path]);
+	}
+}
+
+static void rtw8822c_set_tx_power_diff(struct rtw_dev *rtwdev, u8 rate,
+				       s8 *diff_idx)
+{
+	u32 offset_txagc = 0x3a00;
+	u8 rate_idx = rate & 0xfc;
+	u8 pwr_idx[4];
+	u32 phy_pwr_idx;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		pwr_idx[i] = diff_idx[i] & 0x7f;
+
+	phy_pwr_idx = pwr_idx[0] |
+		      (pwr_idx[1] << 8) |
+		      (pwr_idx[2] << 16) |
+		      (pwr_idx[3] << 24);
+
+	rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0x0);
+	rtw_write32_mask(rtwdev, offset_txagc + rate_idx, MASKDWORD,
+			 phy_pwr_idx);
+}
+
+static void rtw8822c_set_tx_power_index(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 rs, rate, j;
+	u8 pwr_ref_cck[2] = {hal->tx_pwr_tbl[RF_PATH_A][DESC_RATE11M],
+			     hal->tx_pwr_tbl[RF_PATH_B][DESC_RATE11M]};
+	u8 pwr_ref_ofdm[2] = {hal->tx_pwr_tbl[RF_PATH_A][DESC_RATEMCS7],
+			      hal->tx_pwr_tbl[RF_PATH_B][DESC_RATEMCS7]};
+	s8 diff_a, diff_b;
+	u8 pwr_a, pwr_b;
+	s8 diff_idx[4];
+
+	rtw8822c_set_write_tx_power_ref(rtwdev, pwr_ref_cck, pwr_ref_ofdm);
+	for (rs = 0; rs < RTW_RATE_SECTION_MAX; rs++) {
+		for (j = 0; j < rate_size[rs]; j++) {
+			rate = rate_section[rs][j];
+			pwr_a = hal->tx_pwr_tbl[RF_PATH_A][rate];
+			pwr_b = hal->tx_pwr_tbl[RF_PATH_B][rate];
+			if (rs == 0) {
+				diff_a = (s8)pwr_a - (s8)pwr_ref_cck[0];
+				diff_b = (s8)pwr_b - (s8)pwr_ref_cck[1];
+			} else {
+				diff_a = (s8)pwr_a - (s8)pwr_ref_ofdm[0];
+				diff_b = (s8)pwr_b - (s8)pwr_ref_ofdm[1];
+			}
+			diff_idx[rate % 4] = min(diff_a, diff_b);
+			if (rate % 4 == 3)
+				rtw8822c_set_tx_power_diff(rtwdev, rate - 3,
+							   diff_idx);
+		}
+	}
 }
 
 static void rtw8822c_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
@@ -1182,6 +1252,7 @@ struct rtw_chip_info rtw8822c_hw_spec = {
 	.rxff_size = 24576,
 	.txgi_factor = 2,
 	.is_pwr_by_rate_dec = false,
+	.max_power_index = 0x7f,
 	.csi_buf_pg_num = 50,
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = 128,
-- 
2.7.4

