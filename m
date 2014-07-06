Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:41173 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaGFJhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:10 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so3094671wes.8
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/40] iwlwifi: mvm: Use beacon_get_template instead of beacon_get
Date: Sun,  6 Jul 2014 12:36:07 +0300
Message-Id: <1404639376-3792-31-git-send-email-egrumbach@gmail.com> (sfid-20140706_115952_534493_9E118D3F)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Call ieee80211_beacon_get_template instead of ieee80211_beacon_get and sync the
CSA counters with mac80211 after each beacon transmission.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 549817d..6d09472 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -969,7 +969,7 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 	WARN_ON(vif->type != NL80211_IFTYPE_AP &&
 		vif->type != NL80211_IFTYPE_ADHOC);
 
-	beacon = ieee80211_beacon_get(mvm->hw, vif);
+	beacon = ieee80211_beacon_get_template(mvm->hw, vif, NULL);
 	if (!beacon)
 		return -ENOMEM;
 
@@ -1233,6 +1233,7 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 
 	if (unlikely(mvm->csa_vif && mvm->csa_vif->csa_active)) {
 		if (!ieee80211_csa_is_complete(mvm->csa_vif)) {
+			ieee80211_csa_update_counter(mvm->csa_vif);
 			iwl_mvm_mac_ctxt_beacon_changed(mvm, mvm->csa_vif);
 		} else {
 			ieee80211_csa_finish(mvm->csa_vif);
-- 
1.8.3.2

