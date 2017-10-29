Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42336 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751381AbdJ2M2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:08 +0200
Message-Id: <20171029122816.8802-10-luca@coelho.fi> (sfid-20171029_132850_682338_D4C0BD7A)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 09/17] iwlwifi: fix multi queue notification for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently we return early from sync_rx_queues for a000 devices.
This may cause, in case of a non-empty reorder buffer, a warning
later on since the RX queue isn't getting the notification to
empty it.
A better approach would be to send the notification for the default
queue only.
Do this hard coded for now, until we will have the API to enable
multi queue for a000 devices.

Fixes: bc0294696456 ("iwlwifi: mvm: disable RX queue notification for a000 devices")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 0b3d275fe177..26caea62df9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4294,9 +4294,7 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* TODO - remove a000 disablement when we have RXQ config API */
-	if (!iwl_mvm_has_new_rx_api(mvm) ||
-	    mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000)
+	if (!iwl_mvm_has_new_rx_api(mvm))
 		return;
 
 	notif->cookie = mvm->queue_sync_cookie;
@@ -4305,6 +4303,13 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 		atomic_set(&mvm->queue_sync_counter,
 			   mvm->trans->num_rx_queues);
 
+	/* TODO - remove this when we have RXQ config API */
+	if (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000) {
+		qmask = BIT(0);
+		if (notif->sync)
+			atomic_set(&mvm->queue_sync_counter, 1);
+	}
+
 	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)notif, size);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to trigger RX queues sync (%d)\n", ret);
-- 
2.14.2
