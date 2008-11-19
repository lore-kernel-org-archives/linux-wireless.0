Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYKSXbz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: enable base band calibration in 5000 HW
Date: Wed, 19 Nov 2008 15:32:24 -0800
Message-Id: <1227137548-28718-4-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003212_985744_BA09FEB0)
In-Reply-To: <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds base band calibration support.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index aeb69ee..478c5c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -475,6 +475,9 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 	case IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD:
 		index = IWL_CALIB_TX_IQ_PERD;
 		break;
+	case IWL_PHY_CALIBRATE_BASE_BAND_CMD:
+		index = IWL_CALIB_BASE_BAND;
+		break;
 	default:
 		IWL_ERROR("Unknown calibration notification %d\n",
 			  hdr->op_code);
@@ -841,8 +844,9 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.calib_init_cfg =
 			BIT(IWL_CALIB_XTAL)		|
 			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 	|
-			BIT(IWL_CALIB_TX_IQ_PERD);
+			BIT(IWL_CALIB_TX_IQ) 		|
+			BIT(IWL_CALIB_TX_IQ_PERD)	|
+			BIT(IWL_CALIB_BASE_BAND);
 		break;
 	case CSR_HW_REV_TYPE_5150:
 		priv->hw_params.calib_init_cfg = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1b305d8..4da988e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -695,6 +695,7 @@ enum iwl_calib {
 	IWL_CALIB_LO,
 	IWL_CALIB_TX_IQ,
 	IWL_CALIB_TX_IQ_PERD,
+	IWL_CALIB_BASE_BAND,
 	IWL_CALIB_MAX
 };
 
-- 
1.5.4.3

