Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56069 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaIOFNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:40 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so3282120wgh.24
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:39 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/28] iwlwifi: mvm: move TDLS code to separate file
Date: Mon, 15 Sep 2014 08:12:56 +0300
Message-Id: <1410757980-2138-24-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_104292_B156551E)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The upcoming TDLS channel-switch functionality is big enough to warrant
a separate file. Move existing related functions to the new file.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile   |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  85 ----------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   5 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c     | 149 ++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 86 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tdls.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index a282359..2d7c3ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -3,7 +3,7 @@ iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
 iwlmvm-y += power.o coex.o coex_legacy.o
-iwlmvm-y += tt.o offloading.o
+iwlmvm-y += tt.o offloading.o tdls.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 56901f8..a3bb4a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1420,28 +1420,6 @@ static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 }
 #endif
 
-static void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
-{
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-	int i;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-		if (!sta || IS_ERR(sta) || !sta->tdls)
-			continue;
-
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-		ieee80211_tdls_oper_request(mvmsta->vif, sta->addr,
-				NL80211_TDLS_TEARDOWN,
-				WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED,
-				GFP_KERNEL);
-	}
-}
-
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -1970,48 +1948,6 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
-{
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-	int count = 0;
-	int i;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-		if (!sta || IS_ERR(sta) || !sta->tdls)
-			continue;
-
-		if (vif) {
-			mvmsta = iwl_mvm_sta_from_mac80211(sta);
-			if (mvmsta->vif != vif)
-				continue;
-		}
-
-		count++;
-	}
-
-	return count;
-}
-
-static void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm,
-				      struct ieee80211_vif *vif,
-				      bool sta_added)
-{
-	int tdls_sta_cnt = iwl_mvm_tdls_sta_count(mvm, vif);
-
-	/*
-	 * Disable ps when the first TDLS sta is added and re-enable it
-	 * when the last TDLS sta is removed
-	 */
-	if ((tdls_sta_cnt == 1 && sta_added) ||
-	    (tdls_sta_cnt == 0 && !sta_added))
-		iwl_mvm_power_update_mac(mvm);
-}
-
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2185,27 +2121,6 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PREPARE_TX);
 }
 
-static void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
-						  struct ieee80211_vif *vif)
-{
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	u32 duration = 2 * vif->bss_conf.dtim_period * vif->bss_conf.beacon_int;
-
-	/*
-	 * iwl_mvm_protect_session() reads directly from the device
-	 * (the system time), so make sure it is available.
-	 */
-	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_TDLS))
-		return;
-
-	mutex_lock(&mvm->mutex);
-	/* Protect the session to hear the TDLS setup response on the channel */
-	iwl_mvm_protect_session(mvm, vif, duration, duration, 100, true);
-	mutex_unlock(&mvm->mutex);
-
-	iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_TDLS);
-}
-
 static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					struct cfg80211_sched_scan_request *req,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 1fdebb8..6eb1f85 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1161,6 +1161,11 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 /* TDLS */
 int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm);
+void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			       bool sta_added);
+void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif);
 
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
new file mode 100644
index 0000000..66c82df
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -0,0 +1,149 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include "mvm.h"
+#include "time-event.h"
+
+void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
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
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		ieee80211_tdls_oper_request(mvmsta->vif, sta->addr,
+				NL80211_TDLS_TEARDOWN,
+				WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED,
+				GFP_KERNEL);
+	}
+}
+
+int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
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
+		if (vif) {
+			mvmsta = iwl_mvm_sta_from_mac80211(sta);
+			if (mvmsta->vif != vif)
+				continue;
+		}
+
+		count++;
+	}
+
+	return count;
+}
+
+void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			       bool sta_added)
+{
+	int tdls_sta_cnt = iwl_mvm_tdls_sta_count(mvm, vif);
+
+	/*
+	 * Disable ps when the first TDLS sta is added and re-enable it
+	 * when the last TDLS sta is removed
+	 */
+	if ((tdls_sta_cnt == 1 && sta_added) ||
+	    (tdls_sta_cnt == 0 && !sta_added))
+		iwl_mvm_power_update_mac(mvm);
+}
+
+void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	u32 duration = 2 * vif->bss_conf.dtim_period * vif->bss_conf.beacon_int;
+
+	/*
+	 * iwl_mvm_protect_session() reads directly from the device
+	 * (the system time), so make sure it is available.
+	 */
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_TDLS))
+		return;
+
+	mutex_lock(&mvm->mutex);
+	/* Protect the session to hear the TDLS setup response on the channel */
+	iwl_mvm_protect_session(mvm, vif, duration, duration, 100, true);
+	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_TDLS);
+}
-- 
1.9.1

