Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965623AbbD1MnY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/8] iwlwifi: mvm: Avoid signal based decisions if ave beacon RSSI is 0
Date: Tue, 28 Apr 2015 15:43:08 +0300
Message-Id: <1430224992-20327-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144327_983612_2CC3D4F7)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

If for some reason statistics notification received from the firmware
reports 0 in average beacon RSSI value, then skip it and avoid signal
based decisions.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 78ec7db..d6314dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -478,6 +478,11 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
+	if (sig == 0) {
+		IWL_DEBUG_RX(mvm, "RSSI is 0 - skip signal based decision\n");
+		return;
+	}
+
 	mvmvif->bf_data.ave_beacon_signal = sig;
 
 	/* BT Coex */
-- 
2.1.0

