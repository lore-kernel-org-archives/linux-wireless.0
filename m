Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:52506 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaICT5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:19 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so9116612wes.22
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/36] iwlwifi: mvm: use tdls indication from mac80211
Date: Wed,  3 Sep 2014 22:56:21 +0300
Message-Id: <1409774184-24665-33-git-send-email-egrumbach@gmail.com> (sfid-20140903_215755_368965_1C4825C5)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of checking whether a given station is the first to
be added on a client interface check for the new TDLS flag
and warn in the unexpected cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 960687b..ccfc256 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -252,10 +252,14 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	/* The first station added is the AP, the others are TDLS STAs */
-	if (vif->type == NL80211_IFTYPE_STATION &&
-	    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
-		mvmvif->ap_sta_id = sta_id;
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (!sta->tdls) {
+			WARN_ON(mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT);
+			mvmvif->ap_sta_id = sta_id;
+		} else {
+			WARN_ON(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT);
+		}
+	}
 
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[sta_id], sta);
 
-- 
1.9.1

