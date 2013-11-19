Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60489 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSUwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:24 -0500
Received: by mail-wi0-f179.google.com with SMTP id fb10so6111231wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/7] iwlwifi: mvm: don't WARN about unsuccessful time event
Date: Tue, 19 Nov 2013 22:52:05 +0200
Message-Id: <1384894326-24676-6-git-send-email-egrumbach@gmail.com> (sfid-20131119_215233_064524_6D75ED0C)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Time event notification can have a failure status even if
the time event was scheduled:
* in START notification, this can happen if the time event
  was scheduled later than the requested apply time.
* in STOP notification, this can happen if the time event
  is truncated.

Even if both happened, the offchannel packets sent during
the remain on channel are very likely to have been sent.
Hence, don't WARN when this happens, but rather print a
discrete line in the kernel log.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 33cf56f..95ce4b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -176,8 +176,11 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 	 * P2P Device discoveribility, while there are other higher priority
 	 * events in the system).
 	 */
-	if (WARN_ONCE(!le32_to_cpu(notif->status),
-		      "Failed to schedule time event\n")) {
+	if (!le32_to_cpu(notif->status)) {
+		bool start = le32_to_cpu(notif->action) &
+				TE_V2_NOTIF_HOST_EVENT_START;
+		IWL_WARN(mvm, "Time Event %s notification failure\n",
+			 start ? "start" : "end");
 		if (iwl_mvm_te_check_disconnect(mvm, te_data->vif, NULL)) {
 			iwl_mvm_te_clear_data(mvm, te_data);
 			return;
-- 
1.7.9.5

