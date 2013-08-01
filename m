Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3HANH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 09:07:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: make TU conversion macros available
Date: Thu,  1 Aug 2013 15:07:24 +0200
Message-Id: <1375362444-7630-1-git-send-email-johannes@sipsolutions.net> (sfid-20130801_150732_308148_78046B0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A few places in the code (mac80211 and iwlmvm) use the same
TU_TO_JIFFIES() macro and could use TU_TO_EXP_TIME() that
mac80211 has. Make these available to everyone and use them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 7 ++-----
 include/linux/ieee80211.h                     | 4 ++++
 net/mac80211/ieee80211_i.h                    | 3 ---
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index ad9bbca..9f10036 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -73,7 +73,6 @@
 #include "iwl-prph.h"
 
 /* A TimeUnit is 1024 microsecond */
-#define TU_TO_JIFFIES(_tu)	(usecs_to_jiffies((_tu) * 1024))
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
 /*
@@ -191,8 +190,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		iwl_mvm_te_clear_data(mvm, te_data);
 	} else if (le32_to_cpu(notif->action) & TE_NOTIF_HOST_EVENT_START) {
 		te_data->running = true;
-		te_data->end_jiffies = jiffies +
-			TU_TO_JIFFIES(te_data->duration);
+		te_data->end_jiffies = TU_TO_EXP_TIME(te_data->duration);
 
 		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
@@ -329,8 +327,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	if (te_data->running &&
-	    time_after(te_data->end_jiffies,
-		       jiffies + TU_TO_JIFFIES(min_duration))) {
+	    time_after(te_data->end_jiffies, TU_TO_EXP_TIME(min_duration))) {
 		IWL_DEBUG_TE(mvm, "We have enough time in the current TE: %u\n",
 			     jiffies_to_msecs(te_data->end_jiffies - jiffies));
 		return;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b3ce299..23a8877 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2288,4 +2288,8 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 	return !!(tim->virtual_map[index] & mask);
 }
 
+/* convert time units */
+#define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
+#define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
+
 #endif /* LINUX_IEEE80211_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d779383..49a8d98 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -53,9 +53,6 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
-#define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
-#define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
-
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
 
-- 
1.8.0

