Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3CDOA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>
Subject: [PATCH 06/11] iwlwifi: mvm: Set valid TX antennas value before calib request
Date: Mon,  4 Mar 2013 15:00:46 +0100
Message-Id: <1362405651-26456-6-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150115_377415_3C16DBDE)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

We must set the valid TX antennas number in the ucode before
sending the phy_cfg_cmd and request for calibrations.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index d3d959d..e6d51a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -446,6 +446,11 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	ret = iwl_nvm_check_version(mvm->nvm_data, mvm->trans);
 	WARN_ON(ret);
 
+	/* Send TX valid antennas before triggering calibrations */
+	ret = iwl_send_tx_ant_cfg(mvm, mvm->nvm_data->valid_tx_ant);
+	if (ret)
+		goto error;
+
 	/* Override the calibrations from TLV and the const of fw */
 	iwl_set_default_calib_trigger(mvm);
 
-- 
1.8.0

