Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:47692 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab3LBU74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:56 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so12713111wes.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/13] iwlwifi: mvm: rs: fix mapping from HT/VHT rates to legacy
Date: Mon,  2 Dec 2013 22:59:22 +0200
Message-Id: <1386017965-13641-10-git-send-email-egrumbach@gmail.com> (sfid-20131202_220013_097297_EBF2E75F)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The table rs_ht_to_legacy is used to get the next legacy rate
following the last HT or VHT rate in the LQ rates table.
The mapping wasn't correct as well as didn't include entries
for MCS8/9 which led to out of bounds access. This didn't
trigger a crash but led to legacy rate entries using 1Mbps
rate.
In 5Ghz this probably caused the Tx to fail completely given
that Tx attempt would have reached the legacy entries and 1Mbps
isn't valid.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 5c98d462..ef7126a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -56,19 +56,16 @@
 
 
 static u8 rs_ht_to_legacy[] = {
-	[IWL_RATE_1M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_2M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_5M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_11M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_6M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_9M_INDEX] = IWL_RATE_6M_INDEX,
-	[IWL_RATE_12M_INDEX] = IWL_RATE_9M_INDEX,
-	[IWL_RATE_18M_INDEX] = IWL_RATE_12M_INDEX,
-	[IWL_RATE_24M_INDEX] = IWL_RATE_18M_INDEX,
-	[IWL_RATE_36M_INDEX] = IWL_RATE_24M_INDEX,
-	[IWL_RATE_48M_INDEX] = IWL_RATE_36M_INDEX,
-	[IWL_RATE_54M_INDEX] = IWL_RATE_48M_INDEX,
-	[IWL_RATE_60M_INDEX] = IWL_RATE_54M_INDEX,
+	[IWL_RATE_MCS_0_INDEX] = IWL_RATE_6M_INDEX,
+	[IWL_RATE_MCS_1_INDEX] = IWL_RATE_9M_INDEX,
+	[IWL_RATE_MCS_2_INDEX] = IWL_RATE_12M_INDEX,
+	[IWL_RATE_MCS_3_INDEX] = IWL_RATE_18M_INDEX,
+	[IWL_RATE_MCS_4_INDEX] = IWL_RATE_24M_INDEX,
+	[IWL_RATE_MCS_5_INDEX] = IWL_RATE_36M_INDEX,
+	[IWL_RATE_MCS_6_INDEX] = IWL_RATE_48M_INDEX,
+	[IWL_RATE_MCS_7_INDEX] = IWL_RATE_54M_INDEX,
+	[IWL_RATE_MCS_8_INDEX] = IWL_RATE_54M_INDEX,
+	[IWL_RATE_MCS_9_INDEX] = IWL_RATE_54M_INDEX,
 };
 
 static const u8 ant_toggle_lookup[] = {
@@ -682,6 +679,8 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	 * are always supported (spec demand) */
 	if (!is_legacy(rate) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
+		WARN_ON_ONCE(scale_index < IWL_RATE_MCS_0_INDEX &&
+			     scale_index > IWL_RATE_MCS_9_INDEX);
 		scale_index = rs_ht_to_legacy[scale_index];
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			rate->type = LQ_LEGACY_A;
-- 
1.7.9.5

