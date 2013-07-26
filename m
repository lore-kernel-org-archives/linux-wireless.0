Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab3GZI3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 28/30] iwlwifi: mvm: Change beacon abort escape time value
Date: Fri, 26 Jul 2013 10:28:45 +0200
Message-Id: <1374827327-3464-29-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_069225_729514B3)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Set beacon abort escape timer values - 6 beacons in D0 state,
9 beacons in D3 and D0i3.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 3 ++-
 drivers/net/wireless/iwlwifi/mvm/power.c        | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 149347d..060e630 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -285,7 +285,8 @@ struct iwl_beacon_filter_cmd {
 #define IWL_BF_ESCAPE_TIMER_MAX 1024
 #define IWL_BF_ESCAPE_TIMER_MIN 0
 
-#define IWL_BA_ESCAPE_TIMER_DEFAULT 3
+#define IWL_BA_ESCAPE_TIMER_DEFAULT 6
+#define IWL_BA_ESCAPE_TIMER_D3 6
 #define IWL_BA_ESCAPE_TIMER_MAX 1024
 #define IWL_BA_ESCAPE_TIMER_MIN 0
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 30306a9..4e7c9f2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -123,6 +123,9 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 	if (!mvmvif->bf_enabled)
 		return 0;
 
+	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
+		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
+
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
 	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
 }
-- 
1.8.0

