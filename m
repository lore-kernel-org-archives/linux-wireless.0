Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbDBGlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/31] iwlwifi: mvm: remove time-event start/end failure warning
Date: Thu,  2 Apr 2015 09:40:54 +0300
Message-Id: <1427956879-11725-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084140_139813_DAAB0CEE)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This warning is misleading. In many cases, for example P2P ROC time
events, this will happen if the time event is aborted, for example
due to a higher priority time event. This is entirely normal and not
worth warning about.

In other cases, where we actually do act upon this, for example when
trying to connect and this fails, we should instead warn as part of
the disconnect operation.

Change the code to do that, i.e. make the warning a debug message,
and make it more prominent (an error) when we actually disconnect
because of it.

This also fixes confusion in the logs - the warning was mistaken for
something that needed investigation, while in most cases it's just
expected behaviour that occasionally some lower-priority time events
would not complete fully.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 98c8d70..a32f612 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -252,11 +252,16 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 	 * events in the system).
 	 */
 	if (!le32_to_cpu(notif->status)) {
-		bool start = le32_to_cpu(notif->action) &
-				TE_V2_NOTIF_HOST_EVENT_START;
-		IWL_WARN(mvm, "Time Event %s notification failure\n",
-			 start ? "start" : "end");
-		if (iwl_mvm_te_check_disconnect(mvm, te_data->vif, NULL)) {
+		const char *msg;
+
+		if (notif->action & cpu_to_le32(TE_V2_NOTIF_HOST_EVENT_START))
+			msg = "Time Event start notification failure";
+		else
+			msg = "Time Event end notification failure";
+
+		IWL_DEBUG_TE(mvm, "%s\n", msg);
+
+		if (iwl_mvm_te_check_disconnect(mvm, te_data->vif, msg)) {
 			iwl_mvm_te_clear_data(mvm, te_data);
 			return;
 		}
-- 
1.9.1

