Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39014 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbeAZHrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:11 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/10] rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only
Date: Fri, 26 Jan 2018 15:46:45 +0800
Message-ID: <20180126074645.27201-11-pkshih@realtek.com> (sfid-20180126_084719_479174_87F7DFBA)
In-Reply-To: <20180126074645.27201-1-pkshih@realtek.com>
References: <20180126074645.27201-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The wifi only btcoex is used to solo card (without BT), and it is also
useful to exclude the interference with BT to make debug easier.
There are only four ops for wifi only btcoex to initialze antenna and
switch the settings while band is changed.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        | 55 ++++++++++++++++++++++
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        | 25 ++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
new file mode 100644
index 000000000000..951b8c1e0153
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
@@ -0,0 +1,55 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016-2017  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ *****************************************************************************/
+#include "halbt_precomp.h"
+
+void ex_hal8822b_wifi_only_hw_config(struct wifi_only_cfg *wifionlycfg)
+{
+	/*BB control*/
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x4c, 0x01800000, 0x2);
+	/*SW control*/
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0xcb4, 0xff, 0x77);
+	/*antenna mux switch */
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x974, 0x300, 0x3);
+
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x1990, 0x300, 0x0);
+
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0xcbc, 0x80000, 0x0);
+	/*switch to WL side controller and gnt_wl gnt_bt debug signal */
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x70, 0xff000000, 0x0e);
+	/*gnt_wl=1 , gnt_bt=0*/
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x1704, 0xffffffff, 0x7700);
+	halwifionly_phy_set_bb_reg(wifionlycfg, 0x1700, 0xffffffff, 0xc00f0038);
+}
+
+void ex_hal8822b_wifi_only_scannotify(struct wifi_only_cfg *wifionlycfg,
+				      u8 is_5g)
+{
+	hal8822b_wifi_only_switch_antenna(wifionlycfg, is_5g);
+}
+
+void ex_hal8822b_wifi_only_switchbandnotify(struct wifi_only_cfg *wifionlycfg,
+					    u8 is_5g)
+{
+	hal8822b_wifi_only_switch_antenna(wifionlycfg, is_5g);
+}
+
+void hal8822b_wifi_only_switch_antenna(struct wifi_only_cfg *wifionlycfg,
+				       u8 is_5g)
+{
+	if (is_5g)
+		halwifionly_phy_set_bb_reg(wifionlycfg, 0xcbc, 0x300, 0x1);
+	else
+		halwifionly_phy_set_bb_reg(wifionlycfg, 0xcbc, 0x300, 0x2);
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
new file mode 100644
index 000000000000..6ec356542eea
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
@@ -0,0 +1,25 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016-2017  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ *****************************************************************************/
+#ifndef __INC_HAL8822BWIFIONLYHWCFG_H
+#define __INC_HAL8822BWIFIONLYHWCFG_H
+
+void ex_hal8822b_wifi_only_hw_config(struct wifi_only_cfg *wifionlycfg);
+void ex_hal8822b_wifi_only_scannotify(struct wifi_only_cfg *wifionlycfg,
+				      u8 is_5g);
+void ex_hal8822b_wifi_only_switchbandnotify(struct wifi_only_cfg *wifionlycfg,
+					    u8 is_5g);
+void hal8822b_wifi_only_switch_antenna(struct wifi_only_cfg *wifionlycfg,
+				       u8 is_5g);
+#endif
-- 
2.15.1
