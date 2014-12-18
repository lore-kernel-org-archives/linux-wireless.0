Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55000 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaLRILV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 03:11:21 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so904410wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 00:11:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/5] iwlwifi: mvm: clear IN_HW_RESTART flag on stop()
Date: Thu, 18 Dec 2014 10:09:57 +0200
Message-Id: <1418890201-15177-1-git-send-email-egrumbach@gmail.com> (sfid-20141218_091125_056547_6208D33E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On stop(), we already cleared our internal state,
and the restart_complete() callback won't be
called, so simply clear the IN_HW_RESTART flag.

Keeping the flag might result in invalid state
on the next start(), preventing the driver starting
properly.

Additionally, don't take IWL_MVM_REF_UCODE_DOWN on stop()
if hw restart was requested, as the ref was already
taken in this case.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 31a5b3f..e880f9d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1004,8 +1004,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
 
-	/* disallow low power states when the FW is down */
-	iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+	/*
+	 * Disallow low power states when the FW is down by taking
+	 * the UCODE_DOWN ref. in case of ongoing hw restart the
+	 * ref is already taken, so don't take it again.
+	 */
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
 	/* async_handlers_wk is now blocked */
 
@@ -1023,6 +1028,12 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	/* the fw is stopped, the aux sta is dead: clean up driver state */
 	iwl_mvm_del_aux_sta(mvm);
 
+	/*
+	 * Clear IN_HW_RESTART flag when stopping the hw (as restart_complete()
+	 * won't be called in this case).
+	 */
+	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+
 	mvm->ucode_loaded = false;
 }
 
-- 
1.9.1

