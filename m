Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33109 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934397AbcHBMXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:23:06 -0400
From: Baole Ni <baolex.ni@intel.com>
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
	luciano.coelho@intel.com, linuxwifi@intel.com,
	kvalo@codeaurora.org, m.chehab@samsung.com, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, lars@metafoo.de
Subject: [PATCH 0777/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:45:24 +0800
Message-Id: <20160802114524.1513-1-baolex.ni@intel.com> (sfid-20160802_142412_936726_D3D1AAC6)
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
 drivers/net/wireless/intel/iwlwifi/dvm/power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.c b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
index 0ad557c..69f6bbd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
@@ -41,7 +41,7 @@
 #include "power.h"
 
 static bool force_cam = true;
-module_param(force_cam, bool, 0644);
+module_param(force_cam, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(force_cam, "force continuously aware mode (no power saving at all)");
 
 /*
-- 
2.9.2

