Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZJPFU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:59 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/16] iwmc3200wifi: SDIO disable race fix
Date: Fri, 16 Oct 2009 13:18:54 +0800
Message-Id: <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

When calling sdio->bus_disable(), we are flushing the command lists before
disabling the sdio function. We can thus potentially get a command response
after having flushed the command list.
To avoid that race, we have to call iwm_reset() after disabling the sdio
function.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index 38026b7..cf86294 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -224,8 +224,6 @@ static int if_sdio_disable(struct iwm_priv *iwm)
 	struct iwm_sdio_priv *hw = iwm_to_if_sdio(iwm);
 	int ret;
 
-	iwm_reset(iwm);
-
 	sdio_claim_host(hw->func);
 	sdio_writeb(hw->func, 0, IWM_SDIO_INTR_ENABLE_ADDR, &ret);
 	if (ret < 0)
@@ -237,6 +235,8 @@ static int if_sdio_disable(struct iwm_priv *iwm)
 
 	iwm_sdio_rx_free(hw);
 
+	iwm_reset(iwm);
+
 	IWM_DBG_SDIO(iwm, INFO, "IWM SDIO disable\n");
 
 	return 0;
-- 
1.6.0.4

