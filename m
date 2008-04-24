Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235AbYDXSzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/21] iwlwifi-5000: adjust antennas names in 5000 HW family
Date: Thu, 24 Apr 2008 11:55:31 -0700
Message-Id: <1209063338-6572-15-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210547_393514_5E5F4604)
In-Reply-To: <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
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
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch use new defines for antennas

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1a18ac1..8bccd90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -263,19 +263,15 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.tx_chains_num = 1;
 		priv->hw_params.rx_chains_num = 2;
 		/* FIXME: move to ANT_A, ANT_B, ANT_C enum */
-		priv->hw_params.valid_tx_ant = IWL_ANTENNA_MAIN;
-		priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN |
-						IWL_ANTENNA_AUX);
+		priv->hw_params.valid_tx_ant = ANT_A;
+		priv->hw_params.valid_rx_ant = ANT_AB;
 		break;
 	case CSR_HW_REV_TYPE_5300:
 	case CSR_HW_REV_TYPE_5350:
 		priv->hw_params.tx_chains_num = 3;
 		priv->hw_params.rx_chains_num = 3;
-		/* FIXME: move to ANT_A, ANT_B, ANT_C enum */
-		priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN |
-						IWL_ANTENNA_AUX | 0x04);
-		priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN |
-						IWL_ANTENNA_AUX | 0x04);
+		priv->hw_params.valid_tx_ant = ANT_ABC;
+		priv->hw_params.valid_rx_ant = ANT_ABC;
 		break;
 	}
 
-- 
1.5.3.4

