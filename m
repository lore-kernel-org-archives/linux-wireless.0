Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbbECTcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/42] iwlwifi: rs: cleanup last_txrate_idx
Date: Sun,  3 May 2015 22:31:14 +0300
Message-Id: <1430681513-7838-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213208_157265_CC10589F)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

last_txrate_idx isn't used anymore and can be dropped as this info
exists already somewhere else.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 10 +++-------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  2 --
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a9ad644..316c6e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -2133,7 +2133,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	}
 
 	/* current tx rate */
-	index = lq_sta->last_txrate_idx;
+	index = rate->index;
 
 	/* rates available for this association, and for modulation mode */
 	rate_mask = rs_get_supported_rates(lq_sta, rate);
@@ -2181,7 +2181,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		 * or search for a new one? */
 		rs_stay_in_table(lq_sta, false);
 
-		goto out;
+		return;
 	}
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
@@ -2400,9 +2400,6 @@ lq_update:
 			rs_set_stay_in_table(mvm, 0, lq_sta);
 		}
 	}
-
-out:
-	lq_sta->last_txrate_idx = index;
 }
 
 struct rs_init_rate_info {
@@ -2545,7 +2542,6 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rate = &tbl->rate;
 
 	rs_get_initial_rate(mvm, lq_sta, band, rate);
-	lq_sta->last_txrate_idx = rate->index;
 
 	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
 	if (rate->ant == ANT_A)
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index e4aa934..2a3da31 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -322,8 +322,6 @@ struct iwl_lq_sta {
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
 	u8 tx_agg_tid_en;
 
-	/* used to be in sta_info */
-	int last_txrate_idx;
 	/* last tx rate_n_flags */
 	u32 last_rate_n_flags;
 	/* packets destined for this STA are aggregated */
-- 
2.1.0

