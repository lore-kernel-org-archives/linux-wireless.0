Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbZLNWMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: remove extra error msg on sensitivity calibration
Date: Mon, 14 Dec 2009 14:12:21 -0800
Message-Id: <1260828741-22749-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828741-22749-1-git-send-email-reinette.chatre@intel.com>
References: <1260828741-22749-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Do not need to log error when fail the sensitivity command, driver will send
sensitivity write command to uCode after each sensitivity calibration if
station is associated with AP. It is a normal case when user unload the module
or shutdown the system while still associated with the AP, since uCode already
on the way down, it will not reply the sensitivity write request; report
error in this case will give misleading information, remove the error checking
here to provide a clean shutdown if no other error detected.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-calib.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 95a57b3..dc61906 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -414,7 +414,6 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
 static int iwl_sensitivity_write(struct iwl_priv *priv)
 {
-	int ret = 0;
 	struct iwl_sensitivity_cmd cmd ;
 	struct iwl_sensitivity_data *data = NULL;
 	struct iwl_host_cmd cmd_out = {
@@ -477,11 +476,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	ret = iwl_send_cmd(priv, &cmd_out);
-	if (ret)
-		IWL_ERR(priv, "SENSITIVITY_CMD failed\n");
-
-	return ret;
+	return iwl_send_cmd(priv, &cmd_out);
 }
 
 void iwl_init_sensitivity(struct iwl_priv *priv)
-- 
1.5.6.3

