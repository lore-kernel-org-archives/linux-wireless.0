Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45768 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249AbbIUVB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:59:00 +0300
Message-Id: <1442869141-31637-20-git-send-email-luca@coelho.fi> (sfid-20150921_230131_817287_57BEFCD9)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 20/21] iwlwifi: mvm: configure wowlan configuration only if connected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Recent fw version added assert to make sure wowlan configuration
is configured only when a station is connected.

Change the driver behavior to pass this configuration only
if we indeed have ap station id (i.e. connected).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 0092286..62eefab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1146,12 +1146,17 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	/* make sure we have no running tx while configuring the seqno */
 	synchronize_net();
 
-	iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd, &d0i3_iter_data);
-	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
-				   sizeof(wowlan_config_cmd),
-				   &wowlan_config_cmd);
-	if (ret)
-		return ret;
+	/* configure wowlan configuration only if needed */
+	if (mvm->d0i3_ap_sta_id != IWL_MVM_STATION_COUNT) {
+		iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd,
+					&d0i3_iter_data);
+
+		ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
+					   sizeof(wowlan_config_cmd),
+					   &wowlan_config_cmd);
+		if (ret)
+			return ret;
+	}
 
 	return iwl_mvm_send_cmd_pdu(mvm, D3_CONFIG_CMD,
 				    flags | CMD_MAKE_TRANS_IDLE,
-- 
2.5.1

