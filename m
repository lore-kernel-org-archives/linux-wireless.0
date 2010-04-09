Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0DIUKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:10:05 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: work around bogus active chains detection
Date: Fri,  9 Apr 2010 13:10:02 -0700
Message-Id: <1270843802-30081-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current algorithm will sometimes "detect" that
more chains are enabled than are really present in
the device because, for unknown reasons, the ucode
sends up all-zeroes signal values.

The simplest way of solving this is to restrict the
active chains mask to the chains we know are really
present on the device.

This fixes a bug with some devices where, since sometimes
more chains are enabled than really present, the system would hang.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This patch is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-calib.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 845831a..64de42b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -807,6 +807,18 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		}
 	}
 
+	/*
+	 * The above algorithm sometimes fails when the ucode
+	 * reports 0 for all chains. It's not clear why that
+	 * happens to start with, but it is then causing trouble
+	 * because this can make us enable more chains than the
+	 * hardware really has.
+	 *
+	 * To be safe, simply mask out any chains that we know
+	 * are not on the device.
+	 */
+	active_chains &= priv->hw_params.valid_rx_ant;
+
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		/* loops on all the bits of
-- 
1.6.3.3

