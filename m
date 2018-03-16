Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750749AbeCPLvr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:32 +0200
Message-Id: <20180316115136.1234-2-luca@coelho.fi> (sfid-20180316_125159_594599_C336C27C)
In-Reply-To: <20180316115136.1234-1-luca@coelho.fi>
References: <20180316115136.1234-1-luca@coelho.fi>
Subject: [PATCH 1/5] iwlwifi: mvm: Increase session protection time after CS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

After switching to a new channel, driver schedules session protection
time event in order to hear the beacon on the new channel.
The duration of the protection is two beacon intervals.
However, since we start to switch slightly before beacon with count 1, in
case we don't hear (or AP doesn't transmit) the very first beacon on the
new channel the protection ends without hearing any beacon at all.
At this stage the switch is not complete, the queues are closed and the
interface doesn't have quota yet or TBTT events. As the result, we are
stuck forever waiting for iwl_mvm_post_channel_switch() to be called.

Fix this by increasing the protection time to be 3 beacon intervals and
in addition drop the connection if the time event ends before we got any
beacon.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 15 ++++++++-------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d09afb4acaeb..7152fdc00fb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3494,6 +3494,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		ret = 0;
 		goto out;
 	case NL80211_IFTYPE_STATION:
+		mvmvif->csa_bcn_pending = false;
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		/* always disable PS when a monitor interface is active */
@@ -3537,7 +3538,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	}
 
 	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
-		u32 duration = 2 * vif->bss_conf.beacon_int;
+		u32 duration = 3 * vif->bss_conf.beacon_int;
 
 		/* iwl_mvm_protect_session() reads directly from the
 		 * device (the system time), so make sure it is
@@ -3550,6 +3551,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		/* Protect the session to make sure we hear the first
 		 * beacon on the new channel.
 		 */
+		mvmvif->csa_bcn_pending = true;
 		iwl_mvm_protect_session(mvm, vif, duration, duration,
 					vif->bss_conf.beacon_int / 2,
 					true);
@@ -3988,6 +3990,7 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		struct iwl_mvm_sta *mvmsta;
 
+		mvmvif->csa_bcn_pending = false;
 		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
 							  mvmvif->ap_sta_id);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 89ff02d7c876..625b238a3f0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -438,6 +438,9 @@ struct iwl_mvm_vif {
 	bool csa_failed;
 	u16 csa_target_freq;
 
+	/* Indicates that we are waiting for a beacon on a new channel */
+	bool csa_bcn_pending;
+
 	/* TCP Checksum Offload */
 	netdev_features_t features;
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index acb217e666db..cd91bc44259c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
@@ -35,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -198,9 +195,13 @@ static bool iwl_mvm_te_check_disconnect(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					const char *errmsg)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return false;
-	if (vif->bss_conf.assoc && vif->bss_conf.dtim_period)
+
+	if (!mvmvif->csa_bcn_pending && vif->bss_conf.assoc &&
+	    vif->bss_conf.dtim_period)
 		return false;
 	if (errmsg)
 		IWL_ERR(mvm, "%s\n", errmsg);
@@ -344,7 +345,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
-				"No association and the time event is over already...");
+				"No beacon heard and the time event is over already...");
 			break;
 		default:
 			break;
-- 
2.16.2
