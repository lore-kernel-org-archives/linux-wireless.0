Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48773 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcCAC7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 21:59:21 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 5/8] ath9k: Allow platform override BTCoex pin
Date: Tue,  1 Mar 2016 10:58:32 +0800
Message-Id: <1456801115-16636-6-git-send-email-miaoqing@codeaurora.org> (sfid-20160301_035924_383950_79CF9E14)
In-Reply-To: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
References: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Add new platform data to allow override BTCoex default pin.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 45 +++++++++++++++++++++++++--------
 include/linux/ath9k_platform.h          |  4 +++
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 4737aa9..5a9ecf7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -15,6 +15,8 @@
  */
 
 #include <linux/export.h>
+#include <linux/types.h>
+#include <linux/ath9k_platform.h>
 #include "hw.h"
 
 enum ath_bt_mode {
@@ -90,6 +92,29 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 }
 EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
+static void ath9k_hw_btcoex_pin_init(struct ath_hw *ah, u8 wlanactive_gpio,
+				     u8 btactive_gpio, u8 btpriority_gpio)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	struct ath9k_platform_data *pdata = ah->dev->platform_data;
+
+	if (btcoex_hw->scheme != ATH_BTCOEX_CFG_2WIRE &&
+	    btcoex_hw->scheme != ATH_BTCOEX_CFG_3WIRE)
+		return;
+
+	/* bt priority GPIO will be ignored by 3 wire scheme */
+	if (pdata && (pdata->bt_active_pin || pdata->bt_priority_pin ||
+		      pdata->wlan_active_pin)) {
+		btcoex_hw->btactive_gpio = pdata->bt_active_pin;
+		btcoex_hw->wlanactive_gpio = pdata->wlan_active_pin;
+		btcoex_hw->btpriority_gpio = pdata->bt_priority_pin;
+	} else {
+		btcoex_hw->btactive_gpio = btactive_gpio;
+		btcoex_hw->wlanactive_gpio = wlanactive_gpio;
+		btcoex_hw->btpriority_gpio = btpriority_gpio;
+	}
+}
+
 void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -107,19 +132,19 @@ void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah)
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
 	} else if (AR_SREV_9300_20_OR_LATER(ah)) {
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
-		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
-		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
-		btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9300;
-	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
-		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9280;
-		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9280;
 
-		if (AR_SREV_9285(ah)) {
+		ath9k_hw_btcoex_pin_init(ah, ATH_WLANACTIVE_GPIO_9300,
+					 ATH_BTACTIVE_GPIO_9300,
+					 ATH_BTPRIORITY_GPIO_9300);
+	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
+		if (AR_SREV_9285(ah))
 			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
-			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9285;
-		} else {
+		else
 			btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
-		}
+
+		ath9k_hw_btcoex_pin_init(ah, ATH_WLANACTIVE_GPIO_9280,
+					 ATH_BTACTIVE_GPIO_9280,
+					 ATH_BTPRIORITY_GPIO_9285);
 	}
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_init_scheme);
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 33eb274..e66153d 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -31,6 +31,10 @@ struct ath9k_platform_data {
 	u32 gpio_mask;
 	u32 gpio_val;
 
+	u32 bt_active_pin;
+	u32 bt_priority_pin;
+	u32 wlan_active_pin;
+
 	bool endian_check;
 	bool is_clk_25mhz;
 	bool tx_gain_buffalo;
-- 
1.9.1

