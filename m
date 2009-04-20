Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbZDTVbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/11] iwlcore: Fix stay in table function.
Date: Mon, 20 Apr 2009 14:37:02 -0700
Message-Id: <1240263424-8495-10-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233117_622404_0703DCEF)
In-Reply-To: <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Function rs_stay_in_table was flushing the rate scale table way to early. time_after
macro in expecting long value and was failing because we passing u32 value.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 98b6b37..3504279 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -52,7 +52,7 @@
 /* max allowed rate miss before sync LQ cmd */
 #define IWL_MISSED_RATE_MAX		15
 /* max time to accum history 2 seconds */
-#define IWL_RATE_SCALE_FLUSH_INTVL   (2*HZ)
+#define IWL_RATE_SCALE_FLUSH_INTVL   (3*HZ)
 
 static u8 rs_ht_to_legacy[] = {
 	IWL_RATE_6M_INDEX, IWL_RATE_6M_INDEX,
@@ -135,7 +135,7 @@ struct iwl_lq_sta {
 	u32 table_count;
 	u32 total_failed;	/* total failed frames, any/all rates */
 	u32 total_success;	/* total successful frames, any/all rates */
-	u32 flush_timer;	/* time staying in mode before new search */
+	u64 flush_timer;	/* time staying in mode before new search */
 
 	u8 action_counter;	/* # mode-switch actions tried */
 	u8 is_green;
@@ -1025,6 +1025,7 @@ static void rs_set_stay_in_table(struct iwl_priv *priv, u8 is_legacy,
 	lq_sta->table_count = 0;
 	lq_sta->total_failed = 0;
 	lq_sta->total_success = 0;
+	lq_sta->flush_timer = jiffies;
 }
 
 /*
@@ -1914,8 +1915,8 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
 		/* Elapsed time using current modulation mode */
 		if (lq_sta->flush_timer)
 			flush_interval_passed =
-			    time_after(jiffies,
-				       (unsigned long)(lq_sta->flush_timer +
+			time_after(jiffies,
+					(unsigned long)(lq_sta->flush_timer +
 					IWL_RATE_SCALE_FLUSH_INTVL));
 
 		/*
@@ -2249,6 +2250,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			update_lq = 1;
 			index = low;
 		}
+
 		break;
 	case 1:
 		/* Increase starting rate, update uCode's rate table */
@@ -2314,8 +2316,11 @@ lq_update:
 				     tbl->current_rate, index);
 			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
-		}
+		} else
+			done_search = 1;
+	}
 
+	if (done_search && !lq_sta->stay_in_tbl) {
 		/* If the "active" (non-search) mode was legacy,
 		 * and we've tried switching antennas,
 		 * but we haven't been able to try HT modes (not available),
@@ -2350,17 +2355,6 @@ lq_update:
 			lq_sta->action_counter = 0;
 			rs_set_stay_in_table(priv, 0, lq_sta);
 		}
-
-	/*
-	 * Else, don't search for a new modulation mode.
-	 * Put new timestamp in stay-in-modulation-mode flush timer if:
-	 * 1)  Not changing rates right now
-	 * 2)  Not just finishing up a search
-	 * 3)  flush timer is empty
-	 */
-	} else {
-		if ((!update_lq) && (!done_search) && (!lq_sta->flush_timer))
-			lq_sta->flush_timer = jiffies;
 	}
 
 out:
-- 
1.5.6.3

