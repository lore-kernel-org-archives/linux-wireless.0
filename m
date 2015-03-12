Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbbCLGxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/7] mac80211: ask for ECSA IE to be considered for beacon parse CRC
Date: Thu, 12 Mar 2015 08:53:29 +0200
Message-Id: <1426143210-25635-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075352_227010_4D5D1405)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a beacon from the AP contains only the ECSA IE, and not a CSA IE
as well, this ECSA IE is not considered for calculating the CRC and
the beacon might be dropped as not being interesting. This is clearly
wrong, it should be handled and the channel switch should be executed.

Fix this by including the ECSA IE ID in the bitmap of interesting IEs.

Reported-by: Gil Tribush <gil.tribush@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6205206..ff03961 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3207,7 +3207,8 @@ static const u64 care_about_ies =
 	(1ULL << WLAN_EID_CHANNEL_SWITCH) |
 	(1ULL << WLAN_EID_PWR_CONSTRAINT) |
 	(1ULL << WLAN_EID_HT_CAPABILITY) |
-	(1ULL << WLAN_EID_HT_OPERATION);
+	(1ULL << WLAN_EID_HT_OPERATION) |
+	(1ULL << WLAN_EID_EXT_CHANSWITCH_ANN);
 
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len,
-- 
1.9.1

