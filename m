Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59423 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752459AbaKJJXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:50 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:15 +0200
Message-Id: <1415610621-27438-11-git-send-email-luca@coelho.fi> (sfid-20141110_102400_753417_46FE26B4)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: mvm: schedule CSA time event a bit before beacon 1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of using a hardcoded number of TUs before beacon 0 as the time
to start the absence and actual channel switch, calculate it in
relation to the beacon interval.  We use 10 TUs + beacon interval
before beacon 0 to target a bit before beacon 1.  This gives us enough
time to switch to the new channel before the AP/GO switches.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++++++++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 13 +++++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0ca6185..3fb2b49 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3062,14 +3062,18 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		break;
 	case NL80211_IFTYPE_STATION:
-		apply_time = chsw->timestamp +
-			(vif->bss_conf.beacon_int * chsw->count * 1024);
+		/* Schedule the time event to a bit before beacon 1,
+		 * to make sure we're in the new channel when the
+		 * GO/AP arrives.
+		 */
+		apply_time = chsw->device_timestamp +
+			((vif->bss_conf.beacon_int * (chsw->count - 1) -
+			  IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT) * 1024);
 
 		if (chsw->block_tx)
 			iwl_mvm_csa_client_absent(mvm, vif);
 
-		iwl_mvm_schedule_csa_period(mvm, vif,
-					    IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT,
+		iwl_mvm_schedule_csa_period(mvm, vif, vif->bss_conf.beacon_int,
 					    apply_time);
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6c4c255..3280698 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -87,12 +87,17 @@
 /* A TimeUnit is 1024 microsecond */
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
-/* These values represent the number of TUs before CSA "beacon 0" TBTT
- * when the CSA time-event needs to be scheduled to start.  They must
- * be big enough to ensure that we switch in time.
+/* For GO, this value represents the number of TUs before CSA "beacon
+ * 0" TBTT when the CSA time-event needs to be scheduled to start.  It
+ * must be big enough to ensure that we switch in time.
  */
 #define IWL_MVM_CHANNEL_SWITCH_TIME_GO		40
-#define IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT	110
+
+/* For client, this value represents the number of TUs before CSA
+ * "beacon 1" TBTT, instead.  This is because we don't know when the
+ * GO/AP will be in the new channel, so we switch early enough.
+ */
+#define IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT	10
 
 /*
  * This value (in TUs) is used to fine tune the CSA NoA end time which should
-- 
2.1.1

