Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYLBAba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 19:31:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: 5150 enable DC calibration
Date: Mon,  1 Dec 2008 16:32:19 -0800
Message-Id: <1228177942-25137-3-git-send-email-reinette.chatre@intel.com> (sfid-20081202_013135_934444_9765DE64)
In-Reply-To: <1228177942-25137-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch enables DC calibration for 5150

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8f92ab0..c1e7a42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -477,6 +477,9 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 	 * uCode. iwl_send_calib_results sends them in a row according to their
 	 * index. We sort them here */
 	switch (hdr->op_code) {
+	case IWL_PHY_CALIBRATE_DC_CMD:
+		index = IWL_CALIB_DC;
+		break;
 	case IWL_PHY_CALIBRATE_LO_CMD:
 		index = IWL_CALIB_LO;
 		break;
@@ -873,7 +876,9 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			BIT(IWL_CALIB_BASE_BAND);
 		break;
 	case CSR_HW_REV_TYPE_5150:
-		priv->hw_params.calib_init_cfg = 0;
+		priv->hw_params.calib_init_cfg =
+			BIT(IWL_CALIB_DC);
+
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cb6edfd..b2ce29c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -693,6 +693,7 @@ struct statistics_general_data {
  */
 enum iwl_calib {
 	IWL_CALIB_XTAL,
+	IWL_CALIB_DC,
 	IWL_CALIB_LO,
 	IWL_CALIB_TX_IQ,
 	IWL_CALIB_TX_IQ_PERD,
-- 
1.5.4.3

