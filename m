Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab0FNSY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: print warning about disconnected antennas
Date: Mon, 14 Jun 2010 11:24:52 -0700
Message-Id: <1276539892-12471-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we detect that not all antennas are
properly connected, we simply disable the
associated chains, but never notify the
user at all. Print out a warning so it is
obvious that happened and we know where
to start looking for related issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-calib.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 7e82277..22fa947 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -846,6 +846,13 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		}
 	}
 
+	if (active_chains != priv->hw_params.valid_rx_ant &&
+	    active_chains != priv->chain_noise_data.active_chains)
+		IWL_WARN(priv,
+			 "Detected that not all antennas are connected! "
+			 "Connected: %#x, valid: %#x.\n",
+			 active_chains, priv->hw_params.valid_rx_ant);
+
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	priv->chain_noise_data.active_chains = active_chains;
 	IWL_DEBUG_CALIB(priv, "active_chains (bitwise) = 0x%x\n",
-- 
1.7.0.4

