Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50751 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZHCTKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:10:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.31 resend] iwlagn: do not send key clear commands when rfkill enabled
Date: Mon,  3 Aug 2009 12:10:16 -0700
Message-Id: <1249326616-26279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Do all key clearing except sending sommands to device when rfkill
enabled. When rfkill enabled the interface is brought down and will
be brought back up correctly after rfkill is enabled again.

Same change is not needed for iwl3945 as it ignores return code when
sending key clearing command to device.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13742

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Frans Pop <elendil@planet.nl>
---
This patch also targeted 2.6.31 but did not make it there and from what I
can tell it is not queued for it either. Could you please send it to
2.6.31?

 drivers/net/wireless/iwlwifi/iwl-sta.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 2addf73..ffd5c61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -566,6 +566,8 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
+		      keyconf->keyidx);
 
 	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
 		IWL_ERR(priv, "index %d not used in uCode key table.\n",
@@ -573,6 +575,11 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 
 	priv->default_wep_key--;
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
 	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
@@ -853,6 +860,11 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled. \n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
 	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
-- 
1.5.6.3

