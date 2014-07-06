Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56571 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaGFJhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:17 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so13686971wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/40] iwlwifi: mvm: disallow new TDLS stations when appropriate
Date: Sun,  6 Jul 2014 12:36:11 +0300
Message-Id: <1404639376-3792-35-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_325662_5B279842)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

HW/FW constraints dictate that TDLS should only be used when a single
phy ctx is active. We also support at most 4 TDLS peers. We don't
support TDLS on a P2P vif.

Unify and move a phy-ctx counting implementation from the power-mgmt code
in order to simplify implementation.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 30 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 26 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/power.c    | 22 +--------------------
 5 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 99329ed..b8e4e78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -86,6 +86,8 @@ enum {
 
 #define IWL_MVM_STATION_COUNT	16
 
+#define IWL_MVM_TDLS_STA_COUNT	4
+
 /* commands */
 enum {
 	MVM_ALIVE = 0x1,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5ed6fb3..57945fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1843,6 +1843,26 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm)
+{
+	struct ieee80211_sta *sta;
+	int count = 0;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (!sta || IS_ERR(sta) || !sta->tdls)
+			continue;
+
+		count++;
+	}
+
+	return count;
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -1881,6 +1901,16 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 			ret = -EINVAL;
 			goto out_unlock;
 		}
+
+		if (sta->tdls &&
+		    (vif->p2p ||
+		     iwl_mvm_tdls_sta_count(mvm) == IWL_MVM_TDLS_STA_COUNT ||
+		     iwl_mvm_phy_ctx_count(mvm) > 1)) {
+			IWL_DEBUG_MAC80211(mvm, "refusing TDLS sta\n");
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
 		ret = iwl_mvm_add_sta(mvm, vif, sta);
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7b308c4..c75b958 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -838,6 +838,7 @@ void iwl_mvm_phy_ctxt_ref(struct iwl_mvm *mvm,
 			  struct iwl_mvm_phy_ctxt *ctxt);
 void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm,
 			    struct iwl_mvm_phy_ctxt *ctxt);
+int iwl_mvm_phy_ctx_count(struct iwl_mvm *mvm);
 
 /* MAC (virtual interface) programming */
 int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 539f3a9..6cc243f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -261,3 +261,29 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
 
 	ctxt->ref--;
 }
+
+static void iwl_mvm_binding_iterator(void *_data, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	unsigned long *data = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!mvmvif->phy_ctxt)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_STATION ||
+	    vif->type == NL80211_IFTYPE_AP)
+		__set_bit(mvmvif->phy_ctxt->id, data);
+}
+
+int iwl_mvm_phy_ctx_count(struct iwl_mvm *mvm)
+{
+	unsigned long phy_ctxt_counter = 0;
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_binding_iterator,
+						   &phy_ctxt_counter);
+
+	return hweight8(phy_ctxt_counter);
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index c182a8b..3b582dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -246,30 +246,10 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
 }
 
-static void iwl_mvm_binding_iterator(void *_data, u8 *mac,
-				      struct ieee80211_vif *vif)
-{
-	unsigned long *data = _data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	if (!mvmvif->phy_ctxt)
-		return;
-
-	if (vif->type == NL80211_IFTYPE_STATION ||
-	    vif->type == NL80211_IFTYPE_AP)
-		__set_bit(mvmvif->phy_ctxt->id, data);
-}
-
 static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	unsigned long phy_ctxt_counter = 0;
-
-	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   iwl_mvm_binding_iterator,
-						   &phy_ctxt_counter);
 
 	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
 		    ETH_ALEN))
@@ -291,7 +271,7 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 	 * Avoid using uAPSD if client is in DCM -
 	 * low latency issue in Miracast
 	 */
-	if (hweight8(phy_ctxt_counter) >= 2)
+	if (iwl_mvm_phy_ctx_count(mvm) >= 2)
 		return false;
 
 	return true;
-- 
1.8.3.2

