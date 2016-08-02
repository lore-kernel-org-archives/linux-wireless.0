Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544AbcHBMWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:49 -0400
From: Baole Ni <baolex.ni@intel.com>
To: stas.yakovlev@gmail.com, kvalo@codeaurora.org,
	bkenward@solarflare.com, linux-driver@qlogic.com,
	computersforpeace@gmail.com, m.chehab@samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, lars@metafoo.de, johannes.berg@intel.com
Subject: [PATCH 0774/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:45:07 +0800
Message-Id: <20160802114507.1297-1-baolex.ni@intel.com> (sfid-20160802_174437_062646_83357CD3)
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
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index bfa542c..e94e000 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -197,11 +197,11 @@ static struct ipw2100_fw ipw2100_firmware;
 #endif
 
 #include <linux/moduleparam.h>
-module_param(debug, int, 0444);
-module_param_named(mode, network_mode, int, 0444);
-module_param(channel, int, 0444);
-module_param(associate, int, 0444);
-module_param(disable, int, 0444);
+module_param(debug, int, S_IRUSR | S_IRGRP | S_IROTH);
+module_param_named(mode, network_mode, int, S_IRUSR | S_IRGRP | S_IROTH);
+module_param(channel, int, S_IRUSR | S_IRGRP | S_IROTH);
+module_param(associate, int, S_IRUSR | S_IRGRP | S_IROTH);
+module_param(disable, int, S_IRUSR | S_IRGRP | S_IROTH);
 
 MODULE_PARM_DESC(debug, "debug level");
 MODULE_PARM_DESC(mode, "network mode (0=BSS,1=IBSS,2=Monitor)");
-- 
2.9.2

