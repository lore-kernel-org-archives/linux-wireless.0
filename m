Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbYDXSzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 12/21] iwlwifi-5000: update the CT-Kill value for 5000 series
Date: Thu, 24 Apr 2008 11:55:29 -0700
Message-Id: <1209063338-6572-13-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210543_993930_383E0A56)
In-Reply-To: <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch upadtes the CT-Kill value for 5000 series.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 545970b..7c42bbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -181,6 +181,21 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 						IWL_ANTENNA_AUX | 0x04);
 		break;
 	}
+
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_5100:
+	case CSR_HW_REV_TYPE_5300:
+		/* 5X00 wants in Celsius */
+		priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+		break;
+	case CSR_HW_REV_TYPE_5150:
+	case CSR_HW_REV_TYPE_5350:
+		/* 5X50 wants in Kelvin */
+		priv->hw_params.ct_kill_threshold =
+				CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+		break;
+	}
+
 	return 0;
 }
 static struct iwl_hcmd_ops iwl5000_hcmd = {
-- 
1.5.3.4

