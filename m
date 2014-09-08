Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42864 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaIHQ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:38 -0400
Received: by mail-wg0-f52.google.com with SMTP id x13so2182489wgg.11
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:56:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/12] iwlwifi: mvm: BT Coex - always initialize smps_mode
Date: Mon,  8 Sep 2014 19:56:14 +0300
Message-Id: <1410195377-10075-9-git-send-email-egrumbach@gmail.com> (sfid-20140908_185643_376803_DA31D5D0)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

smps_mode is used uninitialized in a debug statement in AP
mode, so always initialize it.

While at it, fix a typo.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 75178f3..ce71625 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -754,7 +754,8 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	struct iwl_bt_iterator_data *data = _data;
 	struct iwl_mvm *mvm = data->mvm;
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_smps_mode smps_mode;
+	/* default smps_mode is AUTOMATIC - only used for client modes */
+	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_AUTOMATIC;
 	u32 bt_activity_grading;
 	int ave_rssi;
 
@@ -762,8 +763,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		/* default smps_mode for BSS / P2P client is AUTOMATIC */
-		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		break;
 	case NL80211_IFTYPE_AP:
 		if (!mvmvif->ap_ibss_active)
@@ -795,7 +794,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
 		smps_mode = IEEE80211_SMPS_DYNAMIC;
 
-	/* relax SMPS contraints for next association */
+	/* relax SMPS constraints for next association */
 	if (!vif->bss_conf.assoc)
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
-- 
1.9.1

