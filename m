Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57110 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbbJEOhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:41 +0300
Message-Id: <1444055820-27506-10-git-send-email-luca@coelho.fi> (sfid-20151005_163728_459918_76AE6C28)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 10/29] iwlwifi: mvm: ToF - fill bssid of responder configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

The command needs to have the AP interfaces BSSID (which corresponds
to its address).

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tof.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.c b/drivers/net/wireless/iwlwifi/mvm/tof.c
index 7ae0bd8..4007f1d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tof.c
@@ -185,6 +185,7 @@ int iwl_mvm_tof_responder_cmd(struct iwl_mvm *mvm,
 	}
 
 	cmd->sta_id = mvmvif->bcast_sta.sta_id;
+	memcpy(cmd->bssid, vif->addr, ETH_ALEN);
 	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
 						    IWL_ALWAYS_LONG_GROUP, 0),
 				    0, sizeof(*cmd), cmd);
-- 
2.5.3

