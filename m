Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934776AbcHBMWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:54 -0400
From: Baole Ni <baolex.ni@intel.com>
To: stas.yakovlev@gmail.com, kvalo@codeaurora.org,
	bkenward@solarflare.com, linux-driver@qlogic.com,
	computersforpeace@gmail.com, m.chehab@samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, lars@metafoo.de, johannes.berg@intel.com
Subject: [PATCH 0775/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:45:12 +0800
Message-Id: <20160802114512.1368-1-baolex.ni@intel.com> (sfid-20160802_142455_359003_7D398F89)
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
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 38 ++++++++++++++--------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5adb7ce..f02759e 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11993,68 +11993,68 @@ static void __exit ipw_exit(void)
 	pci_unregister_driver(&ipw_driver);
 }
 
-module_param(disable, int, 0444);
+module_param(disable, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 
-module_param(associate, int, 0444);
+module_param(associate, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(associate, "auto associate when scanning (default off)");
 
-module_param(auto_create, int, 0444);
+module_param(auto_create, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(auto_create, "auto create adhoc network (default on)");
 
-module_param_named(led, led_support, int, 0444);
+module_param_named(led, led_support, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(led, "enable led control on some systems (default 1 on)");
 
-module_param(debug, int, 0444);
+module_param(debug, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug, "debug output mask");
 
-module_param_named(channel, default_channel, int, 0444);
+module_param_named(channel, default_channel, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(channel, "channel to limit associate to (default 0 [ANY])");
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
-module_param(rtap_iface, int, 0444);
+module_param(rtap_iface, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtap_iface, "create the rtap interface (1 - create, default 0)");
 #endif
 
 #ifdef CONFIG_IPW2200_QOS
-module_param(qos_enable, int, 0444);
+module_param(qos_enable, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(qos_enable, "enable all QoS functionalitis");
 
-module_param(qos_burst_enable, int, 0444);
+module_param(qos_burst_enable, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(qos_burst_enable, "enable QoS burst mode");
 
-module_param(qos_no_ack_mask, int, 0444);
+module_param(qos_no_ack_mask, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(qos_no_ack_mask, "mask Tx_Queue to no ack");
 
-module_param(burst_duration_CCK, int, 0444);
+module_param(burst_duration_CCK, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(burst_duration_CCK, "set CCK burst value");
 
-module_param(burst_duration_OFDM, int, 0444);
+module_param(burst_duration_OFDM, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(burst_duration_OFDM, "set OFDM burst value");
 #endif				/* CONFIG_IPW2200_QOS */
 
 #ifdef CONFIG_IPW2200_MONITOR
-module_param_named(mode, network_mode, int, 0444);
+module_param_named(mode, network_mode, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mode, "network mode (0=BSS,1=IBSS,2=Monitor)");
 #else
-module_param_named(mode, network_mode, int, 0444);
+module_param_named(mode, network_mode, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mode, "network mode (0=BSS,1=IBSS)");
 #endif
 
-module_param(bt_coexist, int, 0444);
+module_param(bt_coexist, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(bt_coexist, "enable bluetooth coexistence (default off)");
 
-module_param(hwcrypto, int, 0444);
+module_param(hwcrypto, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(hwcrypto, "enable hardware crypto (default off)");
 
-module_param(cmdlog, int, 0444);
+module_param(cmdlog, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cmdlog,
 		 "allocate a ring buffer for logging firmware commands");
 
-module_param(roaming, int, 0444);
+module_param(roaming, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(roaming, "enable roaming support (default on)");
 
-module_param(antenna, int, 0444);
+module_param(antenna, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(antenna, "select antenna 1=Main, 3=Aux, default 0 [both], 2=slow_diversity (choose the one with lower background noise)");
 
 module_exit(ipw_exit);
-- 
2.9.2

