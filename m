Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102AbZEHUiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/11] iwlwifi: fix PS disable status race
Date: Fri,  8 May 2009 13:44:37 -0700
Message-Id: <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

iwlwifi internally needs to keep track of whether PS
is enabled in the firmware or not. To do this, it keeps
a bit in the status flags, called STATUS_POWER_PMI.

The code to set this bit looks as follows:

static int iwl_set_power(struct iwl_priv *priv, void *cmd)
{
	return iwl_send_cmd_pdu_async(priv, POWER_TABLE_CMD,
				      sizeof(struct iwl_powertable_cmd),
				      cmd, NULL);
}

int iwl_power_update_mode(...)
{
	[...]
	if (final_mode != IWL_POWER_MODE_CAM)
		set_bit(STATUS_POWER_PMI, &priv->status);

	iwl_update_power_cmd(priv, &cmd, final_mode);
	cmd.keep_alive_beacons = 0;

	if (final_mode == IWL_POWER_INDEX_5)
		cmd.flags |= IWL_POWER_FAST_PD;

	ret = iwl_set_power(priv, &cmd);

	if (final_mode == IWL_POWER_MODE_CAM)
		clear_bit(STATUS_POWER_PMI, &priv->status);
	else
		set_bit(STATUS_POWER_PMI, &priv->status);

	if (priv->cfg->ops->lib->update_chain_flags && update_chains)
		priv->cfg->ops->lib->update_chain_flags(priv);
	[...]
}

Now, this bit really needs to track what the _firmware_
thinks, not what the driver thinks. Therefore, there is
a race condition here -- the driver sets the bit before
it knows that the async command sent to the card in the
iwl_set_power function has been processed. As a result,
the call to update_chain_flags() may think that the card
has been woken up (PMI bit cleared) while in reality it
hasn't processed the async POWER_TABLE_CMD yet.

This leads to bugs -- any commands the update_chain_flags
function sends can get stuck and subsequent commands also
fail.

The fix is almost trivial: since there's no reason to send
an async command here (in fact, there almost never should
be since many mac80211 callbacks can sleep) just make the
function wait for the card to process the command and then
return and clear the PMI bit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 47c8945..c913069 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -106,9 +106,8 @@ static struct iwl_power_vec_entry range_2[IWL_POWER_MAX] = {
 /* set card power command */
 static int iwl_set_power(struct iwl_priv *priv, void *cmd)
 {
-	return iwl_send_cmd_pdu_async(priv, POWER_TABLE_CMD,
-				      sizeof(struct iwl_powertable_cmd),
-				      cmd, NULL);
+	return iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
+				sizeof(struct iwl_powertable_cmd), cmd);
 }
 /* decide the right power level according to association status
  * and battery status
-- 
1.5.6.3

