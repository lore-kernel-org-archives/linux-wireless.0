Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3186 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819AbcHBM5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:57:17 -0400
From: Baole Ni <baolex.ni@intel.com>
To: johannes@sipsolutions.net, davem@davemloft.net,
	kadlec@blackhole.kfki.hu, kaber@trash.net,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, aryabinin@virtuozzo.com
Subject: [PATCH 1133/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 20:19:16 +0800
Message-Id: <20160802121916.25651-1-baolex.ni@intel.com> (sfid-20160802_155641_422652_4E867152)
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
 net/rfkill/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 884027f..53bf4f9 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -114,7 +114,7 @@ static DEFINE_MUTEX(rfkill_global_mutex);
 static LIST_HEAD(rfkill_fds);	/* list of open fds of /dev/rfkill */
 
 static unsigned int rfkill_default_state = 1;
-module_param_named(default_state, rfkill_default_state, uint, 0444);
+module_param_named(default_state, rfkill_default_state, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(default_state,
 		 "Default initial state for all radio types, 0 = radio off");
 
-- 
2.9.2

