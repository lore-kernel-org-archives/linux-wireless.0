Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65042 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:39 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so3885892eek.39
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/62] iwlwifi: mvm: notify scan completed even if no fw_restart
Date: Mon,  3 Feb 2014 22:57:21 +0200
Message-Id: <1391461088-8082-15-git-send-email-egrumbach@gmail.com> (sfid-20140203_220011_371806_ADFB503B)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Notify scan completed if fw_restart flow isn't going to be run.
Otherwise, the scan will stay stack forever and mac80211 will
not be able to remove the interface.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c  |   43 +++++++++++++++++--------------
 drivers/net/wireless/iwlwifi/mvm/scan.c |    2 +-
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 734b022..fdadfe9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -714,6 +714,29 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 	iwl_abort_notification_waits(&mvm->notif_wait);
 
 	/*
+	 * This is a bit racy, but worst case we tell mac80211 about
+	 * a stopped/aborted scan when that was already done which
+	 * is not a problem. It is necessary to abort any os scan
+	 * here because mac80211 requires having the scan cleared
+	 * before restarting.
+	 * We'll reset the scan_status to NONE in restart cleanup in
+	 * the next start() call from mac80211. If restart isn't called
+	 * (no fw restart) scan status will stay busy.
+	 */
+	switch (mvm->scan_status) {
+	case IWL_MVM_SCAN_NONE:
+		break;
+	case IWL_MVM_SCAN_OS:
+		ieee80211_scan_completed(mvm->hw, true);
+		break;
+	case IWL_MVM_SCAN_SCHED:
+		/* Sched scan will be restarted by mac80211 in restart_hw. */
+		if (!mvm->restart_fw)
+			ieee80211_sched_scan_stopped(mvm->hw);
+		break;
+	}
+
+	/*
 	 * If we're restarting already, don't cycle restarts.
 	 * If INIT fw asserted, it will likely fail again.
 	 * If WoWLAN fw asserted, don't restart either, mac80211
@@ -744,26 +767,6 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR && mvm->restart_fw) {
-		/*
-		 * This is a bit racy, but worst case we tell mac80211 about
-		 * a stopped/aborted (sched) scan when that was already done
-		 * which is not a problem. It is necessary to abort any scan
-		 * here because mac80211 requires having the scan cleared
-		 * before restarting.
-		 * We'll reset the scan_status to NONE in restart cleanup in
-		 * the next start() call from mac80211.
-		 */
-		switch (mvm->scan_status) {
-		case IWL_MVM_SCAN_NONE:
-			break;
-		case IWL_MVM_SCAN_OS:
-			ieee80211_scan_completed(mvm->hw, true);
-			break;
-		case IWL_MVM_SCAN_SCHED:
-			/* Sched scan will be restarted by mac80211. */
-			break;
-		}
-
 		if (mvm->restart_fw > 0)
 			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 0e00079..6c5c173 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -487,7 +487,7 @@ void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, CMD_SYNC, 0, NULL);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send SCAN_ABORT_CMD: %d\n", ret);
-		/* mac80211's state will be cleaned in the fw_restart flow */
+		/* mac80211's state will be cleaned in the nic_restart flow */
 		goto out_remove_notif;
 	}
 
-- 
1.7.9.5

