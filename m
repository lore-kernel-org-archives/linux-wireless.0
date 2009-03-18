Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZCREq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/13] iwl3945: control rate decrease
Date: Tue, 17 Mar 2009 21:51:51 -0700
Message-Id: <1237351913-19202-12-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054710_995530_49885F6E)
In-Reply-To: <1237351913-19202-11-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-10-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Control the rate decrease. Do not decrease the rate fast.
Use success_ratio for rate scaling :)

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index f65c308..af6b9d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -124,7 +124,7 @@ static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
 #define IWL39_RATE_HIGH_TH          11520
 #define IWL_SUCCESS_UP_TH	   8960
 #define IWL_SUCCESS_DOWN_TH	  10880
-#define IWL_RATE_MIN_FAILURE_TH       8
+#define IWL_RATE_MIN_FAILURE_TH       6
 #define IWL_RATE_MIN_SUCCESS_TH       8
 #define IWL_RATE_DECREASE_TH       1920
 #define IWL_RATE_RETRY_TH	     15
@@ -488,7 +488,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
-	retries = info->status.rates[0].count - 1;
+	retries = info->status.rates[0].count;
 	/* Sanity Check for retries */
 	if (retries > IWL_RATE_RETRY_TH)
 		retries = IWL_RATE_RETRY_TH;
@@ -791,16 +791,15 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
 		IWL_DEBUG_RATE(priv, "decrease rate because of low success_ratio\n");
 		scale_action = -1;
-
 	/* No throughput measured yet for adjacent rates,
 	 * try increase */
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
 		   (high_tpt == IWL_INVALID_VALUE)) {
 
-		if (high != IWL_RATE_INVALID && window->success_counter >= IWL_RATE_INCREASE_TH)
+		if (high != IWL_RATE_INVALID && window->success_ratio >= IWL_RATE_INCREASE_TH)
 			scale_action = 1;
 		else if (low != IWL_RATE_INVALID)
-			scale_action = -1;
+			scale_action = 0;
 
 	/* Both adjacent throughputs are measured, but neither one has
 	 * better throughput; we're using the best rate, don't change
@@ -826,14 +825,14 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			else {
 				IWL_DEBUG_RATE(priv,
 				    "decrease rate because of high tpt\n");
-				scale_action = -1;
+				scale_action = 0;
 			}
 		} else if (low_tpt != IWL_INVALID_VALUE) {
 			if (low_tpt > current_tpt) {
 				IWL_DEBUG_RATE(priv,
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else if (window->success_counter >= IWL_RATE_INCREASE_TH) {
+			} else if (window->success_ratio >= IWL_RATE_INCREASE_TH) {
 				/* Lower rate has better
 				 * throughput,decrease rate */
 				scale_action = 1;
-- 
1.5.6.3

