Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56600 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752785AbcFJMkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:40:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 10 Jun 2016 15:39:54 +0300
Message-Id: <1465562397-1402-2-git-send-email-luca@coelho.fi> (sfid-20160610_144015_816893_FFDD4B2E)
In-Reply-To: <1465562397-1402-1-git-send-email-luca@coelho.fi>
References: <1465562195.29614.5.camel@coelho.fi>
 <1465562397-1402-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/5] iwlwifi: mvm: fix RCU splat in TKIP's update_key
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The commit below mistakenly changed an rcu_dereference_check
to a rcu_dereference_protected which introduced the
following RCU warning:

[ INFO: suspicious RCU usage. ]
 4.6.0-rc7-next-20160513-dbg-00004-g8de8b92-dirty #655 Not tainted
 -------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h:1069 suspicious rcu_dereference_protected() usage!
 Call Trace:
  [<ffffffff8106b836>] lockdep_rcu_suspicious+0xf7/0x100
  [<ffffffffa03b2321>] iwl_mvm_get_key_sta.part.0+0x5d/0x80 [iwlmvm]
  [<ffffffffa03b4acb>] iwl_mvm_update_tkip_key+0xd3/0x162 [iwlmvm]
  [<ffffffffa03a2b60>] iwl_mvm_mac_update_tkip_key+0x17/0x19 [iwlmvm]
  [<ffffffffa0329646>] ieee80211_tkip_decrypt_data+0x22c/0x24b [mac80211]
  [<ffffffffa0318bb1>] ieee80211_crypto_tkip_decrypt+0xc5/0x110 [mac80211]
  [<ffffffffa033102e>] ieee80211_rx_handlers+0x9bb/0x1fe1 [mac80211]

Fixes: 13303c0fb148 ("iwlwifi: mvm: use helpers to get iwl_mvm_sta")
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fea4d3437..0454bfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1852,12 +1852,18 @@ static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
 	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 		u8 sta_id = mvmvif->ap_sta_id;
 
+		sta = rcu_dereference_check(mvm->fw_id_to_mac_id[sta_id],
+					    lockdep_is_held(&mvm->mutex));
+
 		/*
 		 * It is possible that the 'sta' parameter is NULL,
 		 * for example when a GTK is removed - the sta_id will then
 		 * be the AP ID, and no station was passed by mac80211.
 		 */
-		return iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+		if (IS_ERR_OR_NULL(sta))
+			return NULL;
+
+		return iwl_mvm_sta_from_mac80211(sta);
 	}
 
 	return NULL;
-- 
2.8.1

