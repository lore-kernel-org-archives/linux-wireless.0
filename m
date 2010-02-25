Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab0BYGMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:18 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/7] iwmc3200wifi: increase concatenated buffer
Date: Thu, 25 Feb 2010 14:15:29 +0800
Message-Id: <1267078531-9817-6-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-5-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase concatenated buffer from 8K to 32K to get better performance.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/hal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/hal.h b/drivers/net/wireless/iwmc3200wifi/hal.h
index e7bc416..c20936d 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.h
+++ b/drivers/net/wireless/iwmc3200wifi/hal.h
@@ -131,7 +131,7 @@ do {									  \
 #define IWM_MAX_WIFI_CMD_BUFF_SIZE	(IWM_SDIO_FW_MAX_CHUNK_SIZE - \
 					 IWM_MAX_WIFI_HEADERS_SIZE)
 
-#define IWM_HAL_CONCATENATE_BUF_SIZE	8192
+#define IWM_HAL_CONCATENATE_BUF_SIZE	(32 * 1024)
 
 struct iwm_wifi_cmd_buff {
 	u16 len;
-- 
1.6.0.4

