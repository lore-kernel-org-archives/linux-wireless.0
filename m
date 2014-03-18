Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64608 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaCROqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:43 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so5439635eei.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/35] iwlwifi: mvm: fix theoretical NULL ptr dereference
Date: Tue, 18 Mar 2014 16:45:36 +0200
Message-Id: <1395153939-23897-32-git-send-email-egrumbach@gmail.com> (sfid-20140318_154700_361142_8C037B72)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

mvmsta could have been NULL / ERR.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index f64e972..9b59e1d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -312,6 +312,11 @@ static ssize_t iwl_dbgfs_reduced_txp_write(struct ieee80211_vif *vif,
 	mutex_lock(&mvm->mutex);
 
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
+	if (IS_ERR_OR_NULL(mvmsta)) {
+		mutex_unlock(&mvm->mutex);
+		return -ENOTCONN;
+	}
+
 	mvmsta->bt_reduced_txpower_dbg = false;
 	ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
 					  reduced_tx_power);
-- 
1.8.3.2

