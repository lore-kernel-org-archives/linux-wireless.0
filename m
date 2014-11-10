Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59365 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752359AbaKJJKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:36 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:07 +0200
Message-Id: <1415610621-27438-3-git-send-email-luca@coelho.fi> (sfid-20141110_101051_373148_8971D6C0)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 02/16] iwlwifi: mvm: only save csa_vif in AP/GO mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We only need the csa_vif in AP/GO modes, and assigning for other
interfaces may cause problems, because csa_vif is never cleared.  To
prevent this, only assign the value if the iftype is
NL80211_IFTYPE_AP.  Use a switch to do this, even though, for now,
only the AP interface type is handled, because soon other interface
types will be added as well.

Additionally, convert the WARN() in the error case when a
channel-switch is already running to WARN_ONCE().

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e45b9b9..8bb6f18 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2983,17 +2983,25 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	csa_vif = rcu_dereference_protected(mvm->csa_vif,
-					    lockdep_is_held(&mvm->mutex));
-	if (WARN(csa_vif && csa_vif->csa_active,
-		 "Another CSA is already in progress")) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
-	IWL_DEBUG_MAC80211(mvm, "CSA started to freq %d\n",
+	IWL_DEBUG_MAC80211(mvm, "pre CSA to freq %d\n",
 			   chsw->chandef.center_freq1);
-	rcu_assign_pointer(mvm->csa_vif, vif);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+		csa_vif =
+			rcu_dereference_protected(mvm->csa_vif,
+						  lockdep_is_held(&mvm->mutex));
+		if (WARN_ONCE(csa_vif && csa_vif->csa_active,
+			      "Another CSA is already in progress")) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
+		rcu_assign_pointer(mvm->csa_vif, vif);
+		break;
+	default:
+		break;
+	}
 
 	ret = 0;
 
-- 
2.1.1

