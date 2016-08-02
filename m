Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934710AbcHBMWX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:23 -0400
From: Baole Ni <baolex.ni@intel.com>
To: kvalo@qca.qualcomm.com, linux-wimax@intel.com,
	bkenward@solarflare.com, linux-driver@qlogic.com,
	computersforpeace@gmail.com, m.chehab@samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com,
	daniel@iogearbox.net, pabeni@redhat.com
Subject: [PATCH 0763/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:43:57 +0800
Message-Id: <20160802114357.529-1-baolex.ni@intel.com> (sfid-20160802_175143_796822_C9DD726D)
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
 drivers/net/wireless/ath/ath10k/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 49af624..9e42274 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -36,11 +36,11 @@ static bool uart_print;
 static bool skip_otp;
 static bool rawmode;
 
-module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
-module_param_named(cryptmode, ath10k_cryptmode_param, uint, 0644);
-module_param(uart_print, bool, 0644);
-module_param(skip_otp, bool, 0644);
-module_param(rawmode, bool, 0644);
+module_param_named(debug_mask, ath10k_debug_mask, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param_named(cryptmode, ath10k_cryptmode_param, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(uart_print, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(skip_otp, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rawmode, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
-- 
2.9.2

