Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbZAHSSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/11] iwl3945: kill hw_params.tx_ant_num
Date: Thu,  8 Jan 2009 10:19:52 -0800
Message-Id: <1231438802-10991-2-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191840_348969_306EBCD7)
In-Reply-To: <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes tx_ant_num for hw_params structure. It is not used.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 85a8790..502df73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2493,7 +2493,6 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL3945_BROADCAST_ID;
 
-	priv->hw_params.tx_ant_num = 2;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9b9d743..a092401 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -595,9 +595,6 @@ struct iwl_hw_params {
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
-
-	/* for 3945 */
-	u16 tx_ant_num;
 };
 
 
-- 
1.5.4.3

