Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47382 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3KXUG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:58 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so3020325wib.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/29] iwlwifi: mvm: refactor iwl_mvm_rs_rate_init
Date: Sun, 24 Nov 2013 22:06:23 +0200
Message-Id: <1385323606-3603-6-git-send-email-egrumbach@gmail.com> (sfid-20131124_210707_837060_9E05AEA4)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Refactor setting of VHT enabled rates in preparation of adding
some more logic there.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   49 +++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0a64089..e49bf44 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2242,6 +2242,33 @@ static int rs_vht_highest_rx_mcs_index(struct ieee80211_sta_vht_cap *vht_cap,
 	return -1;
 }
 
+static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
+				     struct ieee80211_sta_vht_cap *vht_cap,
+				     struct iwl_lq_sta *lq_sta)
+{
+	int i;
+	int highest_mcs = rs_vht_highest_rx_mcs_index(vht_cap, 1);
+
+	if (highest_mcs >= IWL_RATE_MCS_0_INDEX) {
+		for (i = IWL_RATE_MCS_0_INDEX; i <= highest_mcs; i++) {
+			if (i == IWL_RATE_9M_INDEX)
+				continue;
+
+			lq_sta->active_siso_rate |= BIT(i);
+		}
+	}
+
+	highest_mcs = rs_vht_highest_rx_mcs_index(vht_cap, 2);
+	if (highest_mcs >= IWL_RATE_MCS_0_INDEX) {
+		for (i = IWL_RATE_MCS_0_INDEX; i <= highest_mcs; i++) {
+			if (i == IWL_RATE_9M_INDEX)
+				continue;
+
+			lq_sta->active_mimo2_rate |= BIT(i);
+		}
+	}
+}
+
 /*
  * Called after adding a new station to initialize rate scaling
  */
@@ -2308,27 +2335,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 		lq_sta->is_vht = false;
 	} else {
-		int highest_mcs = rs_vht_highest_rx_mcs_index(vht_cap, 1);
-		if (highest_mcs >= IWL_RATE_MCS_0_INDEX) {
-			for (i = IWL_RATE_MCS_0_INDEX; i <= highest_mcs; i++) {
-				if (i == IWL_RATE_9M_INDEX)
-					continue;
-
-				lq_sta->active_siso_rate |= BIT(i);
-			}
-		}
-
-		highest_mcs = rs_vht_highest_rx_mcs_index(vht_cap, 2);
-		if (highest_mcs >= IWL_RATE_MCS_0_INDEX) {
-			for (i = IWL_RATE_MCS_0_INDEX; i <= highest_mcs; i++) {
-				if (i == IWL_RATE_9M_INDEX)
-					continue;
-
-				lq_sta->active_mimo2_rate |= BIT(i);
-			}
-		}
-
-		/* TODO: avoid MCS9 in 20Mhz which isn't valid for 11ac */
+		rs_vht_set_enabled_rates(sta, vht_cap, lq_sta);
 		lq_sta->is_vht = true;
 	}
 
-- 
1.7.9.5

