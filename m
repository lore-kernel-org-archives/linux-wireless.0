Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0AVWXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/17] iwlwifi: enable DC calibration
Date: Fri, 22 Jan 2010 14:22:47 -0800
Message-Id: <1264198978-5915-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

For 6X50 DC calibration needs to be initialized
else uCode will run an endless loop.
Enbale DC calibration in hw config.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b191c63..f89ef4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -158,11 +158,25 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
 	priv->hw_params.sens = &iwl6000_sensitivity;
-	priv->hw_params.calib_init_cfg =
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_6x50:
+		priv->hw_params.calib_init_cfg =
 			BIT(IWL_CALIB_XTAL)		|
+			BIT(IWL_CALIB_DC)		|
 			BIT(IWL_CALIB_LO)		|
 			BIT(IWL_CALIB_TX_IQ) 		|
 			BIT(IWL_CALIB_BASE_BAND);
+
+		break;
+	default:
+		priv->hw_params.calib_init_cfg =
+			BIT(IWL_CALIB_XTAL)		|
+			BIT(IWL_CALIB_LO)		|
+			BIT(IWL_CALIB_TX_IQ) 		|
+			BIT(IWL_CALIB_BASE_BAND);
+		break;
+	}
+
 	return 0;
 }
 
-- 
1.6.3.3

