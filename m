Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65353 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:53 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so9028579wgg.20
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/36] iwlwifi: mvm: add function to update only ps
Date: Wed,  3 Sep 2014 22:56:04 +0300
Message-Id: <1409774184-24665-16-git-send-email-egrumbach@gmail.com> (sfid-20140903_215658_209506_A2B14CEC)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a new iwl_mvm_power_update_ps() function that allows only ps to be
updated according to changes in the vifs.  This allows us to disable
ps only without affecting the pm values of the vifs (and to avoid
sending unnecessary MAC_PM_POWER_TABLE commands to the firmware).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  1 +
 drivers/net/wireless/iwlwifi/mvm/power.c | 52 ++++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 08cb26d..108ef16 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -983,6 +983,7 @@ int rs_pretty_print_rate(char *buf, const u32 rate);
 /* power management */
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm);
+int iwl_mvm_power_update_ps(struct iwl_mvm *mvm);
 int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 char *buf, int bufsz);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 42aaf57..18f887aa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -857,13 +857,50 @@ static int iwl_mvm_power_set_ps(struct iwl_mvm *mvm,
 	return 0;
 }
 
-int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
+static int iwl_mvm_power_set_ba(struct iwl_mvm *mvm,
+				struct iwl_power_vifs *vifs)
 {
 	struct iwl_mvm_vif *mvmvif;
+	bool ba_enable;
+
+	if (!vifs->bf_vif)
+		return 0;
+
+	mvmvif = iwl_mvm_vif_from_mac80211(vifs->bf_vif);
+
+	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
+		      !vifs->bf_vif->bss_conf.ps ||
+		      iwl_mvm_vif_low_latency(mvmvif));
+
+	return iwl_mvm_update_beacon_abort(mvm, vifs->bf_vif, ba_enable);
+}
+
+int iwl_mvm_power_update_ps(struct iwl_mvm *mvm)
+{
+	struct iwl_power_vifs vifs = {
+		.mvm = mvm,
+	};
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* get vifs info */
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_power_get_vifs_iterator, &vifs);
+
+	ret = iwl_mvm_power_set_ps(mvm, &vifs);
+	if (ret)
+		return ret;
+
+	return iwl_mvm_power_set_ba(mvm, &vifs);
+}
+
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
+{
 	struct iwl_power_vifs vifs = {
 		.mvm = mvm,
 	};
-	bool ba_enable;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -891,16 +928,7 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 			return ret;
 	}
 
-	if (!vifs.bf_vif)
-		return 0;
-
-	mvmvif = iwl_mvm_vif_from_mac80211(vifs.bf_vif);
-
-	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
-		      !vifs.bf_vif->bss_conf.ps ||
-		      iwl_mvm_vif_low_latency(mvmvif));
-
-	return iwl_mvm_update_beacon_abort(mvm, vifs.bf_vif, ba_enable);
+	return iwl_mvm_power_set_ba(mvm, &vifs);
 }
 
 int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
-- 
1.9.1

