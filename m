Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9616 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934696AbcHBMYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:24:50 -0400
From: Baole Ni <baolex.ni@intel.com>
To: kvalo@codeaurora.org, luciano.coelho@intel.com,
	linuxwifi@intel.com, m.chehab@samsung.com, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com, andreas@kemnade.info,
	chuansheng.liu@intel.com, baolex.ni@intel.com
Subject: [PATCH 0785/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:46:08 +0800
Message-Id: <20160802114608.2081-1-baolex.ni@intel.com> (sfid-20160802_142510_352377_478078A2)
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
 drivers/net/wireless/marvell/libertas/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index 8541cbe..b4fa7bd 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -36,11 +36,11 @@ const char lbs_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
 /* Module parameters */
 unsigned int lbs_debug;
 EXPORT_SYMBOL_GPL(lbs_debug);
-module_param_named(libertas_debug, lbs_debug, int, 0644);
+module_param_named(libertas_debug, lbs_debug, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 unsigned int lbs_disablemesh;
 EXPORT_SYMBOL_GPL(lbs_disablemesh);
-module_param_named(libertas_disablemesh, lbs_disablemesh, int, 0644);
+module_param_named(libertas_disablemesh, lbs_disablemesh, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 
 /*
-- 
2.9.2

