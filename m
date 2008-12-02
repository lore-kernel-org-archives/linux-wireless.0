Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYLBAbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 19:31:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: 5150 enable LO, TXIQ and BB calibrations
Date: Mon,  1 Dec 2008 16:32:22 -0800
Message-Id: <1228177942-25137-6-git-send-email-reinette.chatre@intel.com> (sfid-20081202_013137_350084_0CABBFEF)
In-Reply-To: <1228177942-25137-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-2-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-3-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-4-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch enables LO, TXIQ, and BB calibrations for 5150

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 488b580..b6c57cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -888,7 +888,10 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		break;
 	case CSR_HW_REV_TYPE_5150:
 		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_DC);
+			BIT(IWL_CALIB_DC)		|
+			BIT(IWL_CALIB_LO)		|
+			BIT(IWL_CALIB_TX_IQ) 		|
+			BIT(IWL_CALIB_BASE_BAND);
 
 		break;
 	}
-- 
1.5.4.3

