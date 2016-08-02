Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934613AbcHBM0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:26:39 -0400
From: Baole Ni <baolex.ni@intel.com>
To: jussi.kivilinna@iki.fi, kvalo@codeaurora.org, linuxwifi@intel.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com
Subject: [PATCH 0802/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:47:58 +0800
Message-Id: <20160802114758.3433-1-baolex.ni@intel.com> (sfid-20160802_173604_025701_F629E2CE)
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
 drivers/net/wireless/rndis_wlan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 569918c..f6317d7 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -46,43 +46,43 @@
 
 /* NOTE: All these are settings for Broadcom chipset */
 static char modparam_country[4] = "EU";
-module_param_string(country, modparam_country, 4, 0444);
+module_param_string(country, modparam_country, 4, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(country, "Country code (ISO 3166-1 alpha-2), default: EU");
 
 static int modparam_frameburst = 1;
-module_param_named(frameburst, modparam_frameburst, int, 0444);
+module_param_named(frameburst, modparam_frameburst, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(frameburst, "enable frame bursting (default: on)");
 
 static int modparam_afterburner = 0;
-module_param_named(afterburner, modparam_afterburner, int, 0444);
+module_param_named(afterburner, modparam_afterburner, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(afterburner,
 	"enable afterburner aka '125 High Speed Mode' (default: off)");
 
 static int modparam_power_save = 0;
-module_param_named(power_save, modparam_power_save, int, 0444);
+module_param_named(power_save, modparam_power_save, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(power_save,
 	"set power save mode: 0=off, 1=on, 2=fast (default: off)");
 
 static int modparam_power_output = 3;
-module_param_named(power_output, modparam_power_output, int, 0444);
+module_param_named(power_output, modparam_power_output, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(power_output,
 	"set power output: 0=25%, 1=50%, 2=75%, 3=100% (default: 100%)");
 
 static int modparam_roamtrigger = -70;
-module_param_named(roamtrigger, modparam_roamtrigger, int, 0444);
+module_param_named(roamtrigger, modparam_roamtrigger, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(roamtrigger,
 	"set roaming dBm trigger: -80=optimize for distance, "
 				"-60=bandwidth (default: -70)");
 
 static int modparam_roamdelta = 1;
-module_param_named(roamdelta, modparam_roamdelta, int, 0444);
+module_param_named(roamdelta, modparam_roamdelta, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(roamdelta,
 	"set roaming tendency: 0=aggressive, 1=moderate, "
 				"2=conservative (default: moderate)");
 
 static int modparam_workaround_interval;
 module_param_named(workaround_interval, modparam_workaround_interval,
-							int, 0444);
+							int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(workaround_interval,
 	"set stall workaround interval in msecs (0=disabled) (default: 0)");
 
-- 
2.9.2

