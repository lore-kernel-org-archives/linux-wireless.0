Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59428 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752476AbaKJJXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:53 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:21 +0200
Message-Id: <1415610621-27438-17-git-send-email-luca@coelho.fi> (sfid-20141110_102401_971024_4551555D)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 16/16] iwlwifi: mvm: protect session during CSA
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
index 7c031ee..bdfb4b4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2720,6 +2720,25 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
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
 
@@ -3129,6 +3148,8 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
 		if (ret)
 			goto out_unlock;
+
+		iwl_mvm_stop_session_protection(mvm, vif);
 	}
 
 	mvmvif->ps_disabled = false;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 3280698..5efa8c3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -275,6 +275,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_NMI,
 	IWL_MVM_REF_TM_CMD,
 	IWL_MVM_REF_EXIT_WORK,
+	IWL_MVM_REF_PROTECT_CSA,
 
 	/* update debugfs.c when changing this */
 
-- 
2.1.1

