Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50148 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbaKXOgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:39 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so12378134wgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 63/75] iwlwifi: mvm: protect session during CSA
Date: Mon, 24 Nov 2014 16:34:39 +0200
Message-Id: <1416839691-28533-63-git-send-email-egrumbach@gmail.com> (sfid-20141124_153811_179311_B52C9FBF)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When another vif is also running during a channel switch, we need to
use a session protection when we move to the new channel, so that we
don't miss the beacons.  Without this, sometimes the other vif
repeatedly gets time exactly when we should be hearing the beacons,
preventing channel switch from completing.  Adding a session
protection that lasts from the moment the channel changes until 2
TBTTs later, ensures that we will hear the beacons on the destination
channel.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a62014e..6214133 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2847,6 +2847,25 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	}
 
 	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
+		u32 duration = 2 * vif->bss_conf.beacon_int;
+
+		/* iwl_mvm_protect_session() reads directly from the
+		 * device (the system time), so make sure it is
+		 * available.
+		 */
+		ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_CSA);
+		if (ret)
+			goto out_remove_binding;
+
+		/* Protect the session to make sure we hear the first
+		 * beacon on the new channel.
+		 */
+		iwl_mvm_protect_session(mvm, vif, duration, duration,
+					vif->bss_conf.beacon_int / 2,
+					true);
+
+		iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_CSA);
+
 		iwl_mvm_update_quotas(mvm, NULL);
 	}
 
@@ -3256,6 +3275,8 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
 		if (ret)
 			goto out_unlock;
+
+		iwl_mvm_stop_session_protection(mvm, vif);
 	}
 
 	mvmvif->ps_disabled = false;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 99a2590..7c62f80 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -275,6 +275,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_NMI,
 	IWL_MVM_REF_TM_CMD,
 	IWL_MVM_REF_EXIT_WORK,
+	IWL_MVM_REF_PROTECT_CSA,
 
 	/* update debugfs.c when changing this */
 
-- 
1.9.1

