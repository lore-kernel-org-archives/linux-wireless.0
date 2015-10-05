Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57209 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbbJEPBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:56 +0300
Message-Id: <1444055820-27506-25-git-send-email-luca@coelho.fi> (sfid-20151005_170155_185347_12A61479)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 25/29] iwlwifi: mvm: fix signedness warnings in ToF debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using an int* instead of u32* as the kstrtou32() output argument
obviously results in signedness warnings, change that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 5dc1686..398bef6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -511,7 +511,8 @@ static ssize_t iwl_dbgfs_tof_enable_write(struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
-	int value, ret = -EINVAL;
+	u32 value;
+	int ret = -EINVAL;
 	char *data;
 
 	mutex_lock(&mvm->mutex);
@@ -599,7 +600,8 @@ static ssize_t iwl_dbgfs_tof_responder_params_write(struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
-	int value, ret = 0;
+	u32 value;
+	int ret = 0;
 	char *data;
 
 	mutex_lock(&mvm->mutex);
@@ -822,7 +824,8 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
-	int value, ret = 0;
+	u32 value;
+	int ret = 0;
 	char *data;
 
 	mutex_lock(&mvm->mutex);
@@ -1023,7 +1026,8 @@ static ssize_t iwl_dbgfs_tof_range_req_ext_write(struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
-	int value, ret = 0;
+	u32 value;
+	int ret = 0;
 	char *data;
 
 	mutex_lock(&mvm->mutex);
@@ -1127,8 +1131,8 @@ static ssize_t iwl_dbgfs_tof_range_abort_write(struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = mvmvif->mvm;
-	int value, ret = 0;
-	int abort_id;
+	u32 value;
+	int abort_id, ret = 0;
 	char *data;
 
 	mutex_lock(&mvm->mutex);
-- 
2.5.3

