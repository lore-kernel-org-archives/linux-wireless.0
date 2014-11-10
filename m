Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59384 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506AbaKJJKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:40 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:13 +0200
Message-Id: <1415610621-27438-9-git-send-email-luca@coelho.fi> (sfid-20141110_101052_041494_9D847317)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: mvm: use switching_chanctx argument instead of csa_active
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now that all CSA flows are using the switch_vif_chanctx op, we can
rely on the switching_chanctx boolean that is passed to the
__iwl_mvm_assign_vif_chanctx() and __iwl_mvm_unassign_vif_chanctx()
functions to decide whether the context switch flows need to be
executed.  In this way we make the chanctx switch flow more generic,
without having to rely on the csa_active flag being set.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 221f823..ddbdb78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2669,8 +2669,8 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
-		/* Unless it's a CSA flow we have nothing to do here */
-		if (vif->csa_active) {
+		/* only needed if we're switching chanctx (i.e. during CSA) */
+		if (switching_chanctx) {
 			mvmvif->ap_ibss_active = true;
 			break;
 		}
@@ -2720,7 +2720,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
-	if (vif->csa_active && vif->type == NL80211_IFTYPE_STATION) {
+	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
 		struct iwl_mvm_sta *mvmsta;
 
 		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
@@ -2779,7 +2779,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
-		if (!vif->csa_active || !mvmvif->ap_ibss_active)
+		if (!switching_chanctx || !mvmvif->ap_ibss_active)
 			goto out;
 
 		mvmvif->csa_countdown = false;
-- 
2.1.1

