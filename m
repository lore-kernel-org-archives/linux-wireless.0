Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39000 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbeAZHrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:06 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/10] rtlwifi: Extend tx_power_by_rate_offset size for newer IC
Date: Fri, 26 Jan 2018 15:46:39 +0800
Message-ID: <20180126074645.27201-5-pkshih@realtek.com> (sfid-20180126_084724_652205_E7EB847C)
In-Reply-To: <20180126074645.27201-1-pkshih@realtek.com>
References: <20180126074645.27201-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In older design, the TX power is grouped into rate section (smaller array
size), but new design groups them into rate (larger array size). Thus,
we extend the size for both cases, and add compile time assertion.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 92f99a303920..c000c85a3ded 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2646,6 +2646,8 @@ EXPORT_SYMBOL_GPL(rtl_global_var);
 
 static int __init rtl_core_module_init(void)
 {
+	BUILD_BUG_ON(TX_PWR_BY_RATE_NUM_RATE < TX_PWR_BY_RATE_NUM_SECTION);
+
 	if (rtl_rate_control_register())
 		pr_err("rtl: Unable to register rtl_rc, use default RC !!\n");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index be45420f34d3..5b29502a2864 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -173,6 +173,7 @@ enum rtl8192c_h2c_cmd {
 #define TX_PWR_BY_RATE_NUM_BAND		2
 #define TX_PWR_BY_RATE_NUM_RF		4
 #define TX_PWR_BY_RATE_NUM_SECTION	12
+#define TX_PWR_BY_RATE_NUM_RATE		84 /* >= TX_PWR_BY_RATE_NUM_SECTION */
 #define MAX_BASE_NUM_IN_PHY_REG_PG_24G  6
 #define MAX_BASE_NUM_IN_PHY_REG_PG_5G	5
 
@@ -1285,7 +1286,7 @@ struct rtl_phy {
 	u32 tx_power_by_rate_offset[TX_PWR_BY_RATE_NUM_BAND]
 				   [TX_PWR_BY_RATE_NUM_RF]
 				   [TX_PWR_BY_RATE_NUM_RF]
-				   [TX_PWR_BY_RATE_NUM_SECTION];
+				   [TX_PWR_BY_RATE_NUM_RATE];
 	u8 txpwr_by_rate_base_24g[TX_PWR_BY_RATE_NUM_RF]
 				 [TX_PWR_BY_RATE_NUM_RF]
 				 [MAX_BASE_NUM_IN_PHY_REG_PG_24G];
-- 
2.15.1
