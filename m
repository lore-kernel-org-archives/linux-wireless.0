Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16211 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934712AbcHBMWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:24 -0400
From: Baole Ni <baolex.ni@intel.com>
To: kvalo@codeaurora.org, bkenward@solarflare.com,
	linux-driver@qlogic.com, computersforpeace@gmail.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	zajec5@gmail.com, baijiaju1990@163.com, lars@metafoo.de,
	johannes.berg@intel.com, chuansheng.liu@intel.com,
	baolex.ni@intel.com
Subject: [PATCH 0770/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:44:42 +0800
Message-Id: <20160802114442.999-1-baolex.ni@intel.com> (sfid-20160802_175220_656917_3C66D191)
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
 drivers/net/wireless/broadcom/b43/main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 4ee5c58..cadd5bd 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -76,44 +76,44 @@ MODULE_FIRMWARE("b43/ucode5.fw");
 MODULE_FIRMWARE("b43/ucode9.fw");
 
 static int modparam_bad_frames_preempt;
-module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
+module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(bad_frames_preempt,
 		 "enable(1) / disable(0) Bad Frames Preemption");
 
 static char modparam_fwpostfix[16];
-module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
+module_param_string(fwpostfix, modparam_fwpostfix, 16, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the .fw files to load.");
 
 static int modparam_hwpctl;
-module_param_named(hwpctl, modparam_hwpctl, int, 0444);
+module_param_named(hwpctl, modparam_hwpctl, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
 
 static int modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static int modparam_hwtkip;
-module_param_named(hwtkip, modparam_hwtkip, int, 0444);
+module_param_named(hwtkip, modparam_hwtkip, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(hwtkip, "Enable hardware tkip.");
 
 static int modparam_qos = 1;
-module_param_named(qos, modparam_qos, int, 0444);
+module_param_named(qos, modparam_qos, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
 
 static int modparam_btcoex = 1;
-module_param_named(btcoex, modparam_btcoex, int, 0444);
+module_param_named(btcoex, modparam_btcoex, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistence (default on)");
 
 int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
-module_param_named(verbose, b43_modparam_verbose, int, 0644);
+module_param_named(verbose, b43_modparam_verbose, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
 
 static int b43_modparam_pio = 0;
-module_param_named(pio, b43_modparam_pio, int, 0644);
+module_param_named(pio, b43_modparam_pio, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
 static int modparam_allhwsupport = !IS_ENABLED(CONFIG_BRCMSMAC);
-module_param_named(allhwsupport, modparam_allhwsupport, int, 0444);
+module_param_named(allhwsupport, modparam_allhwsupport, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the brcmsmac driver)");
 
 #ifdef CONFIG_B43_BCMA
-- 
2.9.2

