Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbcCBH6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:58:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/43] iwlwifi: mvm: Disable beacon storing in  D3 when WOWLAN configured
Date: Wed,  2 Mar 2016 09:56:36 +0200
Message-Id: <1456905404-14435-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_711494_9D97A04F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently when entering D3 with WOWLAN configured, we enable in the
configuration flags beacon storing, and do not disable beacon
filtering, and do not wake up from a magic packet.

Having both enabled is wrong (should not have both enabled),
and causes problems in the RX queues in the FW, causing
the FW not to recognize the magic packet when it comes.

Disable beacon storing in wowlan configuration.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 5214482..cf5e634 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -856,8 +856,7 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 	wowlan_config_cmd->is_11n_connection =
 					ap_sta->ht_cap.ht_supported;
 	wowlan_config_cmd->flags = ENABLE_L3_FILTERING |
-		ENABLE_NBNS_FILTERING | ENABLE_DHCP_FILTERING |
-		ENABLE_STORE_BEACON;
+		ENABLE_NBNS_FILTERING | ENABLE_DHCP_FILTERING;
 
 	/* Query the last used seqno and set it */
 	ret = iwl_mvm_get_last_nonqos_seq(mvm, vif);
-- 
2.5.0

