Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab0FYWnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlagn: reduce severity of disconnected antennas warning
Date: Fri, 25 Jun 2010 15:43:00 -0700
Message-Id: <1277505781-25268-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This message is encountered regularly and we need to take a closer look at
the circumstances under which it is printed before presenting errors to
users.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 400eb31..eb052b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -843,10 +843,10 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 
 	if (active_chains != priv->hw_params.valid_rx_ant &&
 	    active_chains != priv->chain_noise_data.active_chains)
-		IWL_WARN(priv,
-			 "Detected that not all antennas are connected! "
-			 "Connected: %#x, valid: %#x.\n",
-			 active_chains, priv->hw_params.valid_rx_ant);
+		IWL_DEBUG_CALIB(priv,
+				"Detected that not all antennas are connected! "
+				"Connected: %#x, valid: %#x.\n",
+				active_chains, priv->hw_params.valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	priv->chain_noise_data.active_chains = active_chains;
-- 
1.7.0.4

