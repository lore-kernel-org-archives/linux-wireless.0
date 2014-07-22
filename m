Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65190 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaGVT1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:50 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1012212wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:49 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/20] iwlwifi: mvm: reset beacon filtering and BT Coex data upon FW restart
Date: Tue, 22 Jul 2014 22:26:50 +0300
Message-Id: <1406057211-31752-19-git-send-email-egrumbach@gmail.com> (sfid-20140722_212755_164412_E05859C9)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the firmware asserts, we restart the device and reset
the relevant data we hold in the driver. BT Coex data was
not reset and because of that, the driver wouldn't
reconfigure the firmware properly after firmware restart.
Same for beacon filtering. Fix that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 01af86a..634bb7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -668,6 +668,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	mvmvif->phy_ctxt = NULL;
+	memset(&mvmvif->bf_data, 0, sizeof(mvmvif->bf_data));
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -795,6 +796,12 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 	memset(mvm->sta_drained, 0, sizeof(mvm->sta_drained));
+	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
+	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
+	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
+	memset(&mvm->last_bt_ci_cmd_old, 0, sizeof(mvm->last_bt_ci_cmd_old));
+	memset(&mvm->bt_ack_kill_msk, 0, sizeof(mvm->bt_ack_kill_msk));
+	memset(&mvm->bt_cts_kill_msk, 0, sizeof(mvm->bt_cts_kill_msk));
 
 	ieee80211_wake_queues(mvm->hw);
 
-- 
1.8.3.2

