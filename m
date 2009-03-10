Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZCJVaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: HT performance improvement changes
Date: Tue, 10 Mar 2009 14:35:10 -0700
Message-Id: <1236720912-6502-5-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223020_956690_677018E8)
In-Reply-To: <1236720912-6502-4-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-3-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

During rate scaling, checking for 0 retry count before decrement
the count by 1, this can avoid the retry count to become 255 (0xff),
which will cause the rate to drop faster than what we expect during good
condition (receive 0 retry packet). also change the algorithm to make
the rate not drop faster than what we like.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a6f4c74..0929f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -801,7 +801,10 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	retries = info->status.rates[0].count - 1;
+	if (info->flags & IEEE80211_TX_STAT_AMPDU)
+		retries = 0;
+	else
+		retries = info->status.rates[0].count - 1;
 
 	if (retries > 15)
 		retries = 15;
@@ -1897,7 +1900,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH)
 			scale_action = 1;
 		else if (low != IWL_RATE_INVALID)
-			scale_action = -1;
+			scale_action = 0;
 	}
 
 	/* Both adjacent throughputs are measured, but neither one has better
@@ -1918,9 +1921,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 					sr >= IWL_RATE_INCREASE_TH) {
 				scale_action = 1;
 			} else {
-				IWL_DEBUG_RATE(priv,
-				    "decrease rate because of high tpt\n");
-				scale_action = -1;
+				scale_action = 0;
 			}
 
 		/* Lower adjacent rate's throughput is measured */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 345806d..ab59acc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -231,7 +231,7 @@ enum {
 #define IWL_RS_GOOD_RATIO		12800	/* 100% */
 #define IWL_RATE_SCALE_SWITCH		10880	/*  85% */
 #define IWL_RATE_HIGH_TH		10880	/*  85% */
-#define IWL_RATE_INCREASE_TH            8960	/*  70% */
+#define IWL_RATE_INCREASE_TH		6400	/*  50% */
 #define IWL_RATE_DECREASE_TH		1920	/*  15% */
 
 /* possible actions when in legacy mode */
-- 
1.5.6.3

