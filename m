Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJFILv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:11:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/7] iwlwifi: fix ct kill configuration for 5350
Date: Mon,  6 Oct 2008 16:05:28 +0800
Message-Id: <1223280333-4383-3-git-send-email-yi.zhu@intel.com> (sfid-20081006_101202_786718_D51FAAE5)
In-Reply-To: <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes ct kill configuration for 5350.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ba92667..c1300fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -830,12 +830,12 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_5100:
 	case CSR_HW_REV_TYPE_5300:
-		/* 5X00 wants in Celsius */
+	case CSR_HW_REV_TYPE_5350:
+		/* 5X00 and 5350 wants in Celsius */
 		priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
 		break;
 	case CSR_HW_REV_TYPE_5150:
-	case CSR_HW_REV_TYPE_5350:
-		/* 5X50 wants in Kelvin */
+		/* 5150 wants in Kelvin */
 		priv->hw_params.ct_kill_threshold =
 				CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
 		break;
-- 
1.5.3.6

