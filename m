Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:57301 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbeA2D1A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:27:00 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/10] rtlwifi: Add rate section and its related definition and comment
Date: Mon, 29 Jan 2018 11:26:36 +0800
Message-ID: <20180129032641.17841-6-pkshih@realtek.com> (sfid-20180129_042710_984721_33202622)
In-Reply-To: <20180129032641.17841-1-pkshih@realtek.com>
References: <20180129032641.17841-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add comments to make it to be easier to understand, and add compile time
assertions.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 3 +++
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c000c85a3ded..6db3389e2ced 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2647,6 +2647,9 @@ EXPORT_SYMBOL_GPL(rtl_global_var);
 static int __init rtl_core_module_init(void)
 {
 	BUILD_BUG_ON(TX_PWR_BY_RATE_NUM_RATE < TX_PWR_BY_RATE_NUM_SECTION);
+	BUILD_BUG_ON(MAX_RATE_SECTION_NUM != MAX_RATE_SECTION);
+	BUILD_BUG_ON(MAX_BASE_NUM_IN_PHY_REG_PG_24G != MAX_RATE_SECTION);
+	BUILD_BUG_ON(MAX_BASE_NUM_IN_PHY_REG_PG_5G != (MAX_RATE_SECTION - 1));
 
 	if (rtl_rate_control_register())
 		pr_err("rtl: Unable to register rtl_rc, use default RC !!\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 5b29502a2864..4de2ab1d5416 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -163,7 +163,7 @@ enum rtl8192c_h2c_cmd {
 #define MAX_TX_COUNT			4
 #define MAX_REGULATION_NUM		4
 #define MAX_RF_PATH_NUM			4
-#define MAX_RATE_SECTION_NUM		6
+#define MAX_RATE_SECTION_NUM		6	/* = MAX_RATE_SECTION */
 #define MAX_2_4G_BANDWIDTH_NUM		4
 #define MAX_5G_BANDWIDTH_NUM		4
 #define	MAX_RF_PATH			4
@@ -174,8 +174,8 @@ enum rtl8192c_h2c_cmd {
 #define TX_PWR_BY_RATE_NUM_RF		4
 #define TX_PWR_BY_RATE_NUM_SECTION	12
 #define TX_PWR_BY_RATE_NUM_RATE		84 /* >= TX_PWR_BY_RATE_NUM_SECTION */
-#define MAX_BASE_NUM_IN_PHY_REG_PG_24G  6
-#define MAX_BASE_NUM_IN_PHY_REG_PG_5G	5
+#define MAX_BASE_NUM_IN_PHY_REG_PG_24G	6  /* MAX_RATE_SECTION */
+#define MAX_BASE_NUM_IN_PHY_REG_PG_5G	5  /* MAX_RATE_SECTION -1 */
 
 #define BUFDESC_SEG_NUM		1 /* 0:2 seg, 1: 4 seg, 2: 8 seg */
 
@@ -271,6 +271,7 @@ enum rate_section {
 	HT_MCS8_MCS15,
 	VHT_1SSMCS0_1SSMCS9,
 	VHT_2SSMCS0_2SSMCS9,
+	MAX_RATE_SECTION,
 };
 
 enum intf_type {
-- 
2.15.1
