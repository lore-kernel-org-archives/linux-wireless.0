Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44389 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756498AbaEILMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:51 +0300
Message-Id: <1399633911-12788-9-git-send-email-luca@coelho.fi> (sfid-20140509_131226_513239_D9A3CF6F)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 8/8] iwlwifi: mvm: Use beacon_get_template instead of beacon_get
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Call ieee80211_beacon_get_template instead of ieee80211_beacon_get and sync the
CSA counters with mac80211 after each beacon transmission.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 25901ad..9b73a85 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -997,7 +997,7 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 	WARN_ON(vif->type != NL80211_IFTYPE_AP &&
 		vif->type != NL80211_IFTYPE_ADHOC);
 
-	beacon = ieee80211_beacon_get(mvm->hw, vif);
+	beacon = ieee80211_beacon_get_template(mvm->hw, vif, NULL);
 	if (!beacon)
 		return -ENOMEM;
 
@@ -1250,6 +1250,7 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 
 	if (unlikely(mvm->csa_vif && mvm->csa_vif->csa_active)) {
 		if (!ieee80211_csa_is_complete(mvm->csa_vif)) {
+			ieee80211_csa_update_counter(mvm->csa_vif);
 			iwl_mvm_mac_ctxt_beacon_changed(mvm, mvm->csa_vif);
 		} else {
 			ieee80211_csa_finish(mvm->csa_vif);
-- 
2.0.0.rc0

