Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47228 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaGFJhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so5365721wib.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:17 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/40] iwlwifi: mvm: protect TDLS discovery session
Date: Sun,  6 Jul 2014 12:36:12 +0300
Message-Id: <1404639376-3792-36-git-send-email-egrumbach@gmail.com> (sfid-20140706_115956_248591_D067B0D2)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Use the new mac80211 callback to protect a TDLS discovery session so we
can hear the discovery-response packet.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 57945fe..1acad83 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2017,6 +2017,18 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
+						  struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	u32 duration = 2 * vif->bss_conf.dtim_period * vif->bss_conf.beacon_int;
+
+	mutex_lock(&mvm->mutex);
+	/* Protect the session to hear the TDLS setup response on the channel */
+	iwl_mvm_protect_session(mvm, vif, duration, duration, 100);
+	mutex_unlock(&mvm->mutex);
+}
+
 static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					struct cfg80211_sched_scan_request *req,
@@ -2781,6 +2793,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.sta_rc_update = iwl_mvm_sta_rc_update,
 	.conf_tx = iwl_mvm_mac_conf_tx,
 	.mgd_prepare_tx = iwl_mvm_mac_mgd_prepare_tx,
+	.mgd_protect_tdls_discover = iwl_mvm_mac_mgd_protect_tdls_discover,
 	.flush = iwl_mvm_mac_flush,
 	.sched_scan_start = iwl_mvm_mac_sched_scan_start,
 	.sched_scan_stop = iwl_mvm_mac_sched_scan_stop,
-- 
1.8.3.2

