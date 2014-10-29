Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58091 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbaJ2Lv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:28 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so4345158wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:27 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/25] iwlwifi: mvm: flush queues without mutex held
Date: Wed, 29 Oct 2014 13:50:39 +0200
Message-Id: <1414583446-11032-18-git-send-email-egrumbach@gmail.com> (sfid-20141029_131322_054416_F4E62B1D)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For WMM-AC we may have to be changing QoS parameters while the
queues are being flushed. This is not relevant in the "drop"
case, but matters when we wait for the device to finish the
transmissions.

To allow this, do the actual waiting without holding the mutex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c087bf6..14be108 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2997,18 +2997,24 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
 
-	if (WARN_ON_ONCE(!mvmsta))
-		goto done;
+	if (WARN_ON_ONCE(!mvmsta)) {
+		mutex_unlock(&mvm->mutex);
+		return;
+	}
 
 	if (drop) {
 		if (iwl_mvm_flush_tx_path(mvm, mvmsta->tfd_queue_msk, true))
 			IWL_ERR(mvm, "flush request fail\n");
+		mutex_unlock(&mvm->mutex);
 	} else {
-		iwl_trans_wait_tx_queue_empty(mvm->trans,
-					      mvmsta->tfd_queue_msk);
+		u32 tfd_queue_msk = mvmsta->tfd_queue_msk;
+		mutex_unlock(&mvm->mutex);
+
+		/* this can take a while, and we may need/want other operations
+		 * to succeed while doing this, so do it without the mutex held
+		 */
+		iwl_trans_wait_tx_queue_empty(mvm->trans, tfd_queue_msk);
 	}
-done:
-	mutex_unlock(&mvm->mutex);
 }
 
 const struct ieee80211_ops iwl_mvm_hw_ops = {
-- 
1.9.1

