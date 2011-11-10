Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935504Ab1KJPtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 25/27] iwlwifi: fix rate-scaling algorithm for BT combo devices
Date: Thu, 10 Nov 2011 06:55:25 -0800
Message-Id: <1320936927-9078-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_164952_346218_8B16B748)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkataraman, Meenakshi <meenakshi.venkataraman@intel.com>

iwlwifi tries to avoid using antenna B in BT combo devices when BT
is active. A bug in the rate-scaling algorithm was causing the combo
device to never attempt MIMO rates. Fix the algorithm to
opportunistically try MIMO rates when BT traffic is low.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 66118ce..359c47a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1458,10 +1458,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2)
-			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
+			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
@@ -1636,10 +1634,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
 		if (tbl->action == IWL_SISO_SWITCH_ANTENNA2)
-			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+			tbl->action = IWL_SISO_SWITCH_MIMO2_AB;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
-- 
1.7.0.4

