Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60506 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaKXOgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:20 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5881079wiw.7
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:19 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 50/75] iwlwifi: mvm: only save csa_vif in AP/GO mode
Date: Mon, 24 Nov 2014 16:34:26 +0200
Message-Id: <1416839691-28533-50-git-send-email-egrumbach@gmail.com> (sfid-20141124_153629_141348_9A545303)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 1f53f81..98bb846 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3110,17 +3110,25 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
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
1.9.1

