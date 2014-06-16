Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52605 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaFPONT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:13:19 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so4553157pab.30
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:13:19 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id og3sm19037308pbc.48.2014.06.16.07.13.17
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:13:18 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 07/16] rsi: Changed rate handling.
Date: Mon, 16 Jun 2014 19:43:09 +0530
Message-Id: <1402927989-3957-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161330_465051_E396869E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed rate handling.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |   35 ++++++++++++++----------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 5c122e8..f5182cd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -942,7 +942,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	struct ieee80211_hw *hw = common->priv->hw;
 	u8 band = hw->conf.chandef.chan->band;
 	u8 num_supported_rates = 0;
-	u8 rate_offset = 0;
+	u8 rate_table_offset, rate_offset = 0;
 	u32 rate_bitmap = common->bitrate_mask[band];
 
 	u16 *selected_rates, min_rate;
@@ -978,14 +978,18 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	if (common->channel_width == BW_40MHZ)
 		auto_rate->desc_word[7] |= cpu_to_le16(1);
 
-	if (band == IEEE80211_BAND_2GHZ)
-		min_rate = STD_RATE_01;
-	else
-		min_rate = STD_RATE_06;
+	if (band == IEEE80211_BAND_2GHZ) {
+		min_rate = RSI_RATE_1;
+		rate_table_offset = 0;
+	} else {
+		min_rate = RSI_RATE_6;
+		rate_table_offset = 4;
+	}
 
 	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
 		if (rate_bitmap & BIT(ii)) {
-			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
+			selected_rates[jj++] =
+			(rsi_rates[ii + rate_table_offset].bitrate / 5);
 			rate_offset++;
 		}
 	}
@@ -998,13 +1002,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 		rate_offset += ARRAY_SIZE(mcs);
 	}
 
-	if (rate_offset < (RSI_TBL_SZ / 2) - 1) {
-		for (ii = jj; ii < (RSI_TBL_SZ / 2); ii++) {
-			selected_rates[jj++] = min_rate;
-			rate_offset++;
-		}
-	}
-
 	sort(selected_rates, jj, sizeof(u16), &rsi_compare, NULL);
 
 	/* mapping the rates to RSI rates */
@@ -1020,25 +1017,25 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 
 	/* loading HT rates in the bottom half of the auto rate table */
 	if (common->vif_info[0].is_ht) {
-		if (common->vif_info[0].sgi)
-			auto_rate->supported_rates[rate_offset++] =
-				cpu_to_le16(RSI_RATE_MCS7_SG);
-
 		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
 		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
-			if (common->vif_info[0].sgi)
+			if (common->vif_info[0].sgi ||
+			    conf_is_ht40(&common->priv->hw->conf))
 				auto_rate->supported_rates[ii++] =
 					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
 			auto_rate->supported_rates[ii] =
 				cpu_to_le16(rsi_mcsrates[kk--]);
 		}
 
-		for (; ii < RSI_TBL_SZ; ii++) {
+		for (; ii < (RSI_TBL_SZ - 1); ii++) {
 			auto_rate->supported_rates[ii] =
 				cpu_to_le16(rsi_mcsrates[0]);
 		}
 	}
 
+	for (; ii < RSI_TBL_SZ; ii++)
+		auto_rate->supported_rates[ii] = min_rate;
+
 	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
 	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
 	auto_rate->desc_word[7] |= cpu_to_le16(0 << 8);
-- 
1.7.1

