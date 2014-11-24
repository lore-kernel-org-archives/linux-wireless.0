Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53124 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaKXOg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:29 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12497779wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 56/75] iwlwifi: mvm: use switching_chanctx argument instead of csa_active
Date: Mon, 24 Nov 2014 16:34:32 +0200
Message-Id: <1416839691-28533-56-git-send-email-egrumbach@gmail.com> (sfid-20141124_153843_093186_24CFC50B)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index b536590..fdeaab3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2796,8 +2796,8 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
-		/* Unless it's a CSA flow we have nothing to do here */
-		if (vif->csa_active) {
+		/* only needed if we're switching chanctx (i.e. during CSA) */
+		if (switching_chanctx) {
 			mvmvif->ap_ibss_active = true;
 			break;
 		}
@@ -2847,7 +2847,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
-	if (vif->csa_active && vif->type == NL80211_IFTYPE_STATION) {
+	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
 		struct iwl_mvm_sta *mvmsta;
 
 		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
@@ -2906,7 +2906,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
-		if (!vif->csa_active || !mvmvif->ap_ibss_active)
+		if (!switching_chanctx || !mvmvif->ap_ibss_active)
 			goto out;
 
 		mvmvif->csa_countdown = false;
-- 
1.9.1

