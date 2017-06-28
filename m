Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35922 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751776AbdF1UOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:12 +0300
Message-Id: <20170628201330.9432-14-luca@coelho.fi> (sfid-20170628_221455_035248_C66704E0)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 13/31] iwlwifi: mvm: simplify CHECK_MLME_TRIGGER macro
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There's no reason to pass mvm and trig as parameters to the macro,
since it will be expanded inside the function itself.  Also remove the
bogus buf parameter which doesn't exist and is not used.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 +++++++++--------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d04a88c6c593..b98978d6cb21 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4151,11 +4151,11 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					const struct ieee80211_event *event)
 {
-#define CHECK_MLME_TRIGGER(_mvm, _trig, _buf, _cnt, _fmt...)	\
+#define CHECK_MLME_TRIGGER(_cnt, _fmt...)			\
 	do {							\
-		if ((_cnt) && --(_cnt))				\
+		if ((trig_mlme->_cnt) && --(trig_mlme->_cnt))	\
 			break;					\
-		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _fmt);\
+		iwl_mvm_fw_dbg_collect_trig(mvm, trig, _fmt);	\
 	} while (0)
 
 	struct iwl_fw_dbg_trigger_tlv *trig;
@@ -4171,31 +4171,25 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 
 	if (event->u.mlme.data == ASSOC_EVENT) {
 		if (event->u.mlme.status == MLME_DENIED)
-			CHECK_MLME_TRIGGER(mvm, trig, buf,
-					   trig_mlme->stop_assoc_denied,
+			CHECK_MLME_TRIGGER(stop_assoc_denied,
 					   "DENIED ASSOC: reason %d",
 					    event->u.mlme.reason);
 		else if (event->u.mlme.status == MLME_TIMEOUT)
-			CHECK_MLME_TRIGGER(mvm, trig, buf,
-					   trig_mlme->stop_assoc_timeout,
+			CHECK_MLME_TRIGGER(stop_assoc_timeout,
 					   "ASSOC TIMEOUT");
 	} else if (event->u.mlme.data == AUTH_EVENT) {
 		if (event->u.mlme.status == MLME_DENIED)
-			CHECK_MLME_TRIGGER(mvm, trig, buf,
-					   trig_mlme->stop_auth_denied,
+			CHECK_MLME_TRIGGER(stop_auth_denied,
 					   "DENIED AUTH: reason %d",
 					   event->u.mlme.reason);
 		else if (event->u.mlme.status == MLME_TIMEOUT)
-			CHECK_MLME_TRIGGER(mvm, trig, buf,
-					   trig_mlme->stop_auth_timeout,
+			CHECK_MLME_TRIGGER(stop_auth_timeout,
 					   "AUTH TIMEOUT");
 	} else if (event->u.mlme.data == DEAUTH_RX_EVENT) {
-		CHECK_MLME_TRIGGER(mvm, trig, buf,
-				   trig_mlme->stop_rx_deauth,
+		CHECK_MLME_TRIGGER(stop_rx_deauth,
 				   "DEAUTH RX %d", event->u.mlme.reason);
 	} else if (event->u.mlme.data == DEAUTH_TX_EVENT) {
-		CHECK_MLME_TRIGGER(mvm, trig, buf,
-				   trig_mlme->stop_tx_deauth,
+		CHECK_MLME_TRIGGER(stop_tx_deauth,
 				   "DEAUTH TX %d", event->u.mlme.reason);
 	}
 #undef CHECK_MLME_TRIGGER
-- 
2.11.0
