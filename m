Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801AbcHBMYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:24:50 -0400
From: Baole Ni <baolex.ni@intel.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	kvalo@codeaurora.org, linuxwifi@intel.com, m.chehab@samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com
Subject: [PATCH 0793/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:46:57 +0800
Message-Id: <20160802114657.2690-1-baolex.ni@intel.com> (sfid-20160802_142459_967715_E345E423)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 47e32cb..91ae5a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -393,14 +393,14 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8188E 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8188efw.bin");
 
-module_param_named(swenc, rtl88ee_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl88ee_mod_params.debug, int, 0444);
-module_param_named(ips, rtl88ee_mod_params.inactiveps, bool, 0444);
-module_param_named(swlps, rtl88ee_mod_params.swctrl_lps, bool, 0444);
-module_param_named(fwlps, rtl88ee_mod_params.fwctrl_lps, bool, 0444);
-module_param_named(msi, rtl88ee_mod_params.msi_support, bool, 0444);
+module_param_named(swenc, rtl88ee_mod_params.sw_crypto, bool, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(debug, rtl88ee_mod_params.debug, int, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(ips, rtl88ee_mod_params.inactiveps, bool, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(swlps, rtl88ee_mod_params.swctrl_lps, bool, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(fwlps, rtl88ee_mod_params.fwctrl_lps, bool, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(msi, rtl88ee_mod_params.msi_support, bool, S_IRUSR | S_IRGRP | S_IROTH);
 module_param_named(disable_watchdog, rtl88ee_mod_params.disable_watchdog,
-		   bool, 0444);
+		   bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
-- 
2.9.2

