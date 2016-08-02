Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750AbcHBMYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:24:50 -0400
From: Baole Ni <baolex.ni@intel.com>
To: akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org,
	linuxwifi@intel.com, m.chehab@samsung.com, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com
Subject: [PATCH 0790/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:46:41 +0800
Message-Id: <20160802114641.2489-1-baolex.ni@intel.com> (sfid-20160802_174357_012384_42E441B6)
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
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 8e08626..efeeee3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -27,7 +27,7 @@
 #include "cfg80211.h"
 
 static int disconnect_on_suspend;
-module_param(disconnect_on_suspend, int, 0644);
+module_param(disconnect_on_suspend, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 /*
  * Copies the multicast address list from device to driver.
-- 
2.9.2

