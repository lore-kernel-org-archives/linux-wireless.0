Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33104 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBV2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 17:28:03 -0400
Received: by mail-oi0-f67.google.com with SMTP id h4so13680842oib.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 14:28:02 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 1/9] rtlwifi: btcoex: add macros to check chip type
Date: Fri,  2 Jun 2017 16:27:40 -0500
Message-Id: <20170602212748.23857-2-Larry.Finger@lwfinger.net> (sfid-20170602_232806_600531_A751C00E)
In-Reply-To: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
References: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For some external functions that have hardware dependency, we need to
know the type of the hardware before invoking them.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 39b9a3309cfd..2ac989a4b2bb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -37,6 +37,28 @@
 
 #include "halbtcoutsrc.h"
 
+/* Interface type */
+#define RT_PCI_INTERFACE	1
+#define RT_USB_INTERFACE	2
+#define RT_SDIO_INTERFACE	3
+#define DEV_BUS_TYPE		RT_PCI_INTERFACE
+
+/* IC type */
+#define RTL_HW_TYPE(adapter)	(rtl_hal((struct rtl_priv *)adapter)->hw_type)
+
+#define IS_NEW_GENERATION_IC(adapter)		\
+			(RTL_HW_TYPE(adapter) >= HARDWARE_TYPE_RTL8192EE)
+#define IS_HARDWARE_TYPE_8812(adapter)		\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8812AE)
+#define IS_HARDWARE_TYPE_8821(adapter)		\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8821AE)
+#define IS_HARDWARE_TYPE_8723A(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8723AE)
+#define IS_HARDWARE_TYPE_8723B(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8723BE)
+#define IS_HARDWARE_TYPE_8192E(adapter)	\
+			(RTL_HW_TYPE(adapter) == HARDWARE_TYPE_RTL8192EE)
+
 #include "halbtc8192e2ant.h"
 #include "halbtc8723b1ant.h"
 #include "halbtc8723b2ant.h"
-- 
2.13.0
