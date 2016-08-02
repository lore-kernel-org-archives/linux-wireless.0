Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934740AbcHBMWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:22:33 -0400
From: Baole Ni <baolex.ni@intel.com>
To: kvalo@codeaurora.org, bkenward@solarflare.com,
	linux-driver@qlogic.com, computersforpeace@gmail.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, lars@metafoo.de,
	johannes.berg@intel.com
Subject: [PATCH 0771/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:44:50 +0800
Message-Id: <20160802114450.1072-1-baolex.ni@intel.com> (sfid-20160802_174547_447816_179C02AF)
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
 drivers/net/wireless/broadcom/b43/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/sysfs.c b/drivers/net/wireless/broadcom/b43/sysfs.c
index 3190493..5b664ff 100644
--- a/drivers/net/wireless/broadcom/b43/sysfs.c
+++ b/drivers/net/wireless/broadcom/b43/sysfs.c
@@ -135,7 +135,7 @@ static ssize_t b43_attr_interfmode_store(struct device *dev,
 	return err ? err : count;
 }
 
-static DEVICE_ATTR(interference, 0644,
+static DEVICE_ATTR(interference, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
 		   b43_attr_interfmode_show, b43_attr_interfmode_store);
 
 int b43_sysfs_register(struct b43_wldev *wldev)
-- 
2.9.2

