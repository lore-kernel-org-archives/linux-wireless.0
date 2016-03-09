Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628AbcCIRqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:16 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/21] iwlwifi: mvm: ROC: cleanup time event info on FW failure
Date: Wed,  9 Mar 2016 19:45:40 +0200
Message-Id: <1457545550-30677-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185950_654605_70045C49)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently when the FW sends start/stop aux roc time event
notification with an error status, the driver returns an
error value, but does not remove the time event, and does
not notify the stack above that the time event is over.

This causes problems that the stack above assumes we are still
in the middle of a time event, and therefore can block different
events, such as scanning.

On FW failure notification, cleanup the time event parameters and
notify the stack above that the time event is over.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 924dd6a..2c12789 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -371,20 +371,13 @@ static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 
 	iwl_mvm_te_check_trigger(mvm, notif, te_data);
 
-	if (!le32_to_cpu(notif->status)) {
-		IWL_DEBUG_TE(mvm,
-			     "ERROR: Aux ROC Time Event %s notification failure\n",
-			     (le32_to_cpu(notif->action) &
-			      TE_V2_NOTIF_HOST_EVENT_START) ? "start" : "end");
-		return -EINVAL;
-	}
-
 	IWL_DEBUG_TE(mvm,
-		     "Aux ROC time event notification  - UID = 0x%x action %d\n",
+		     "Aux ROC time event notification  - UID = 0x%x action %d (error = %d)\n",
 		     le32_to_cpu(notif->unique_id),
-		     le32_to_cpu(notif->action));
+		     le32_to_cpu(notif->action), le32_to_cpu(notif->status));
 
-	if (le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_END) {
+	if (!le32_to_cpu(notif->status) ||
+	    le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_END) {
 		/* End TE, notify mac80211 */
 		ieee80211_remain_on_channel_expired(mvm->hw);
 		iwl_mvm_roc_finished(mvm); /* flush aux queue */
-- 
2.5.0

