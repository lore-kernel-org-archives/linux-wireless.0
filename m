Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:47361 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbeC1H17 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 03:27:59 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 8/9] rtlwifi: btcoex: Add struct members to replace global varaibles
Date: Wed, 28 Mar 2018 15:27:40 +0800
Message-ID: <20180328072741.23349-9-pkshih@realtek.com> (sfid-20180328_092847_537586_6C951EFC)
In-Reply-To: <20180328072741.23349-1-pkshih@realtek.com>
References: <20180328072741.23349-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Chip specific context plays as global variables that will not support
multiple devices simultaneously. This patch adds 'union' fields to hold
the variables, and next patch will remove all of them.

To use the declaration of fields in halbtcoutsrc.h, I move the including
order in header file halbt_precomp.h, and declare two struct terms for
chip specific header files.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  6 +++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 24 ++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 858318fd3d63..e21222b48c2c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -35,7 +35,6 @@
 #include "../ps.h"
 #include "../pci.h"
 
-#include "halbtcoutsrc.h"
 
 /* Interface type */
 #define RT_PCI_INTERFACE	1
@@ -43,6 +42,9 @@
 #define RT_SDIO_INTERFACE	3
 #define DEV_BUS_TYPE		RT_PCI_INTERFACE
 
+struct btc_coexist;
+struct wifi_only_cfg;
+
 #include "halbtc8192e2ant.h"
 #include "halbtc8723b1ant.h"
 #include "halbtc8723b2ant.h"
@@ -52,6 +54,8 @@
 #include "halbtc8822b2ant.h"
 #include "halbtc8822bwifionly.h"
 
+#include "halbtcoutsrc.h"
+
 #define GetDefaultAdapter(padapter)	padapter
 
 #define BIT0	0x00000001
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 9eae87d19120..46355ce32f1b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -693,6 +693,30 @@ struct btc_coexist {
 	enum btc_chip_interface	chip_interface;
 	struct btc_bt_link_info bt_link_info;
 
+	/* context for each chip */
+	union {
+		struct coex_dm_8192e_2ant coex_dm_8192e_2ant;
+		struct coex_dm_8723b_1ant coex_dm_8723b_1ant;
+		struct coex_dm_8723b_2ant coex_dm_8723b_2ant;
+		struct coex_dm_8821a_1ant coex_dm_8821a_1ant;
+		struct coex_dm_8821a_2ant coex_dm_8821a_2ant;
+		struct coex_dm_8822b_1ant coex_dm_8822b_1ant;
+		struct coex_dm_8822b_2ant coex_dm_8822b_2ant;
+	};
+	union {
+		struct coex_sta_8192e_2ant coex_sta_8192e_2ant;
+		struct coex_sta_8723b_1ant coex_sta_8723b_1ant;
+		struct coex_sta_8723b_2ant coex_sta_8723b_2ant;
+		struct coex_sta_8821a_1ant coex_sta_8821a_1ant;
+		struct coex_sta_8821a_2ant coex_sta_8821a_2ant;
+		struct coex_sta_8822b_1ant coex_sta_8822b_1ant;
+		struct coex_sta_8822b_2ant coex_sta_8822b_2ant;
+	};
+	union {
+		struct rfe_type_8822b_1ant rfe_type_8822b_1ant;
+		struct rfe_type_8822b_2ant rfe_type_8822b_2ant;
+	};
+
 	/* boolean variables to replace BT_AUTO_REPORT_ONLY_XXXXY_ZANT
 	 * configuration parameters
 	 */
-- 
2.15.1
