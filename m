Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52446 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeB1DHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/15] rtlwifi: btcoex: Add enum DM_INFO for btcoex to query dm's counters
Date: Wed, 28 Feb 2018 11:07:06 +0800
Message-ID: <20180228030718.19510-4-pkshih@realtek.com> (sfid-20180228_040813_742274_BE22DBBD)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex uses dm's counters to check the envoriment is nosiy or not. If it
is clean, btcoex set more time solts to WiFi so that it can transimt as
soon as possible. That will save time, and BT will have more time solts
after WiFi traffic is complete.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4f48b934ec01..438678c2d14a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -977,6 +977,38 @@ enum rtl_spec_ver {
 	RTL_SPEC_EXT_C2H = BIT(2),	/* extend FW C2H (e.g. TX REPORT) */
 };
 
+enum dm_info_query {
+	DM_INFO_FA_OFDM,
+	DM_INFO_FA_CCK,
+	DM_INFO_FA_TOTAL,
+	DM_INFO_CCA_OFDM,
+	DM_INFO_CCA_CCK,
+	DM_INFO_CCA_ALL,
+	DM_INFO_CRC32_OK_VHT,
+	DM_INFO_CRC32_OK_HT,
+	DM_INFO_CRC32_OK_LEGACY,
+	DM_INFO_CRC32_OK_CCK,
+	DM_INFO_CRC32_ERROR_VHT,
+	DM_INFO_CRC32_ERROR_HT,
+	DM_INFO_CRC32_ERROR_LEGACY,
+	DM_INFO_CRC32_ERROR_CCK,
+	DM_INFO_EDCCA_FLAG,
+	DM_INFO_OFDM_ENABLE,
+	DM_INFO_CCK_ENABLE,
+	DM_INFO_CRC32_OK_HT_AGG,
+	DM_INFO_CRC32_ERROR_HT_AGG,
+	DM_INFO_DBG_PORT_0,
+	DM_INFO_CURR_IGI,
+	DM_INFO_RSSI_MIN,
+	DM_INFO_RSSI_MAX,
+	DM_INFO_CLM_RATIO,
+	DM_INFO_NHM_RATIO,
+	DM_INFO_IQK_ALL,
+	DM_INFO_IQK_OK,
+	DM_INFO_IQK_NG,
+	DM_INFO_SIZE,
+};
+
 struct octet_string {
 	u8 *octet;
 	u16 length;
-- 
2.15.1
