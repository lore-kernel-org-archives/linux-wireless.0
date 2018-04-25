Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54889 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDYCIf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:08:35 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 03/19] rtlwifi: add dmdef.h to share with driver and other modules
Date: Wed, 25 Apr 2018 10:08:04 +0800
Message-ID: <20180425020820.6141-4-pkshih@realtek.com> (sfid-20180425_040845_861968_573BC1FF)
In-Reply-To: <20180425020820.6141-1-pkshih@realtek.com>
References: <20180425020820.6141-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This header file is maintained by new module phydm, and share with
driver and other modules, such as halmac. This patch adds only one
enumeration, and more information will be added later.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/dmdef.h | 40 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h  |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/dmdef.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/dmdef.h b/drivers/net/wireless/realtek/rtlwifi/dmdef.h
new file mode 100644
index 000000000000..5560cd1f98ed
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/dmdef.h
@@ -0,0 +1,40 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef __RTL_DMINFO_H__
+#define __RTL_DMINFO_H__
+
+enum bb_path {
+	BB_PATH_A = 0x00000001,
+	BB_PATH_B = 0x00000002,
+	BB_PATH_C = 0x00000004,
+	BB_PATH_D = 0x00000008,
+
+	BB_PATH_AB = (BB_PATH_A | BB_PATH_B),
+	BB_PATH_AC = (BB_PATH_A | BB_PATH_C),
+	BB_PATH_AD = (BB_PATH_A | BB_PATH_D),
+	BB_PATH_BC = (BB_PATH_B | BB_PATH_C),
+	BB_PATH_BD = (BB_PATH_B | BB_PATH_D),
+	BB_PATH_CD = (BB_PATH_C | BB_PATH_D),
+
+	BB_PATH_ABC = (BB_PATH_A | BB_PATH_B | BB_PATH_C),
+	BB_PATH_ABD = (BB_PATH_A | BB_PATH_B | BB_PATH_D),
+	BB_PATH_ACD = (BB_PATH_A | BB_PATH_C | BB_PATH_D),
+	BB_PATH_BCD = (BB_PATH_B | BB_PATH_C | BB_PATH_D),
+
+	BB_PATH_ABCD = (BB_PATH_A | BB_PATH_B | BB_PATH_C | BB_PATH_D),
+};
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index c8542b87cc2b..c32985cfe48d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -35,6 +35,7 @@
 #include <linux/usb.h>
 #include <net/mac80211.h>
 #include <linux/completion.h>
+#include "dmdef.h"
 #include "debug.h"
 
 #define	MASKBYTE0				0xff
-- 
2.15.1
