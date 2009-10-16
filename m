Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZJPFT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:19:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/16] iwmc3200wifi: add BGN sdio device id
Date: Fri, 16 Oct 2009 13:18:45 +0800
Message-Id: <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add BGN SKU sdio device id.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/sdio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index 8b1de84..38026b7 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -493,8 +493,10 @@ static void iwm_sdio_remove(struct sdio_func *func)
 }
 
 static const struct sdio_device_id iwm_sdio_ids[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL,
-		      SDIO_DEVICE_ID_INTEL_IWMC3200WIFI) },
+	/* Global/AGN SKU */
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, 0x1403) },
+	/* BGN SKU */
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, 0x1408) },
 	{ /* end: all zeroes */	},
 };
 MODULE_DEVICE_TABLE(sdio, iwm_sdio_ids);
-- 
1.6.0.4

