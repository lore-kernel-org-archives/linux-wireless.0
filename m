Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934510AbcHBMYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:24:50 -0400
From: Baole Ni <baolex.ni@intel.com>
To: johannes@sipsolutions.net, kvalo@codeaurora.org,
	luciano.coelho@intel.com, linuxwifi@intel.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, a@unstable.cc, fw@strlen.de,
	Jes.Sorensen@redhat.com
Subject: [PATCH 0784/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:46:01 +0800
Message-Id: <20160802114601.2011-1-baolex.ni@intel.com> (sfid-20160802_142507_612640_12D09918)
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
 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4dd5adc..ad82480 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -42,23 +42,23 @@ MODULE_LICENSE("GPL");
 static u32 wmediumd_portid;
 
 static int radios = 2;
-module_param(radios, int, 0444);
+module_param(radios, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
 
 static int channels = 1;
-module_param(channels, int, 0444);
+module_param(channels, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(channels, "Number of concurrent channels");
 
 static bool paged_rx = false;
-module_param(paged_rx, bool, 0644);
+module_param(paged_rx, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(paged_rx, "Use paged SKBs for RX instead of linear ones");
 
 static bool rctbl = false;
-module_param(rctbl, bool, 0444);
+module_param(rctbl, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rctbl, "Handle rate control table");
 
 static bool support_p2p_device = true;
-module_param(support_p2p_device, bool, 0444);
+module_param(support_p2p_device, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(support_p2p_device, "Support P2P-Device interface type");
 
 /**
@@ -134,7 +134,7 @@ enum hwsim_regtest {
 
 /* Set to one of the HWSIM_REGTEST_* values above */
 static int regtest = HWSIM_REGTEST_DISABLED;
-module_param(regtest, int, 0444);
+module_param(regtest, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(regtest, "The type of regulatory test we want to run");
 
 static const char *hwsim_alpha2s[] = {
-- 
2.9.2

