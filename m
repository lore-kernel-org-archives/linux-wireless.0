Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:59939 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1JXJSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:18:04 -0400
Subject: [PATCH 8/9] ath6kl: add debug messages for credit handling
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:59 +0300
Message-ID: <20111024091759.5004.68796.stgit@localhost6.localdomain6> (sfid-20111024_111807_072155_98531DDA)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also take few from htc debug level which are more suitable for credit.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   33 +++++++++++-----------
 drivers/net/wireless/ath/ath6kl/debug.h |    2 +
 drivers/net/wireless/ath/ath6kl/htc.c   |   46 ++++++++++++++++---------------
 3 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 324fdb3..7bc2656 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -142,47 +142,46 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 
 static void dump_cred_dist(struct htc_endpoint_credit_dist *ep_dist)
 {
-	ath6kl_dbg(ATH6KL_DBG_ANY,
+	ath6kl_dbg(ATH6KL_DBG_CREDIT,
 		   "--- endpoint: %d  svc_id: 0x%X ---\n",
 		   ep_dist->endpoint, ep_dist->svc_id);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " dist_flags     : 0x%X\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " dist_flags     : 0x%X\n",
 		   ep_dist->dist_flags);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_norm      : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_norm      : %d\n",
 		   ep_dist->cred_norm);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_min       : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_min       : %d\n",
 		   ep_dist->cred_min);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " credits        : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " credits        : %d\n",
 		   ep_dist->credits);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_assngd    : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_assngd    : %d\n",
 		   ep_dist->cred_assngd);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " seek_cred      : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " seek_cred      : %d\n",
 		   ep_dist->seek_cred);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_sz        : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_sz        : %d\n",
 		   ep_dist->cred_sz);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_per_msg   : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_per_msg   : %d\n",
 		   ep_dist->cred_per_msg);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_to_dist   : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " cred_to_dist   : %d\n",
 		   ep_dist->cred_to_dist);
-	ath6kl_dbg(ATH6KL_DBG_ANY, " txq_depth      : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, " txq_depth      : %d\n",
 		   get_queue_depth(&ep_dist->htc_ep->txq));
-	ath6kl_dbg(ATH6KL_DBG_ANY,
+	ath6kl_dbg(ATH6KL_DBG_CREDIT,
 		   "----------------------------------\n");
 }
 
+/* FIXME: move to htc.c */
 void dump_cred_dist_stats(struct htc_target *target)
 {
 	struct htc_endpoint_credit_dist *ep_list;
 
-	if (!AR_DBG_LVL_CHECK(ATH6KL_DBG_TRC))
+	if (!AR_DBG_LVL_CHECK(ATH6KL_DBG_CREDIT))
 		return;
 
 	list_for_each_entry(ep_list, &target->cred_dist_list, list)
 		dump_cred_dist(ep_list);
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:%p dist:%p\n",
-		   target->credit_info, NULL);
-	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "credit distribution, total : %d, free : %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT,
+		   "credit distribution total %d free %d\n",
 		   target->credit_info->total_avail_credits,
 		   target->credit_info->cur_free_credits);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index afb747b..491485e 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -20,7 +20,7 @@
 #include "hif.h"
 
 enum ATH6K_DEBUG_MASK {
-	/* hole */
+	ATH6KL_DBG_CREDIT	= BIT(0),
 	/* hole */
 	ATH6KL_DBG_WLAN_TX      = BIT(2),     /* wlan tx */
 	ATH6KL_DBG_WLAN_RX      = BIT(3),     /* wlan rx */
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 511eebd..a971c2f 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -27,6 +27,9 @@ static void ath6kl_credit_deposit(struct ath6kl_htc_credit_info *cred_info,
 				  struct htc_endpoint_credit_dist *ep_dist,
 				  int credits)
 {
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, "credit deposit ep %d credits %d\n",
+		   ep_dist->endpoint, credits);
+
 	ep_dist->credits += credits;
 	ep_dist->cred_assngd += credits;
 	cred_info->cur_free_credits -= credits;
@@ -39,6 +42,8 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 	struct htc_endpoint_credit_dist *cur_ep_dist;
 	int count;
 
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, "credit init total %d\n", tot_credits);
+
 	cred_info->cur_free_credits = tot_credits;
 	cred_info->total_avail_credits = tot_credits;
 
@@ -108,6 +113,15 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 			cur_ep_dist->cred_norm = count;
 
 		}
+
+		ath6kl_dbg(ATH6KL_DBG_CREDIT,
+			   "credit ep %d svc_id %d credits %d per_msg %d norm %d min %d\n",
+			   cur_ep_dist->endpoint,
+			   cur_ep_dist->svc_id,
+			   cur_ep_dist->credits,
+			   cur_ep_dist->cred_per_msg,
+			   cur_ep_dist->cred_norm,
+			   cur_ep_dist->cred_min);
 	}
 }
 
@@ -138,6 +152,9 @@ static void ath6kl_credit_reduce(struct ath6kl_htc_credit_info *cred_info,
 {
 	int credits;
 
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, "credit reduce ep %d limit %d\n",
+		   ep_dist->endpoint, limit);
+
 	ep_dist->cred_assngd = limit;
 
 	if (ep_dist->credits <= limit)
@@ -515,7 +532,7 @@ static int htc_check_credits(struct htc_target *target,
 	*req_cred = (len > target->tgt_cred_sz) ?
 		     DIV_ROUND_UP(len, target->tgt_cred_sz) : 1;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds required %d got %d\n",
+	ath6kl_dbg(ATH6KL_DBG_CREDIT, "credit check need %d got %d\n",
 		   *req_cred, ep->cred_dist.credits);
 
 	if (ep->cred_dist.credits < *req_cred) {
@@ -525,16 +542,13 @@ static int htc_check_credits(struct htc_target *target,
 		/* Seek more credits */
 		ep->cred_dist.seek_cred = *req_cred - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->credit_info, &ep->cred_dist);
-
 		ath6kl_credit_seek(target->credit_info, &ep->cred_dist);
 
 		ep->cred_dist.seek_cred = 0;
 
 		if (ep->cred_dist.credits < *req_cred) {
-			ath6kl_dbg(ATH6KL_DBG_HTC,
-				   "htc creds not enough credits for ep %d\n",
+			ath6kl_dbg(ATH6KL_DBG_CREDIT,
+				   "credit not found for ep %d\n",
 				   eid);
 			return -EINVAL;
 		}
@@ -548,9 +562,6 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.seek_cred =
 		ep->cred_dist.cred_per_msg - ep->cred_dist.credits;
 
-		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->credit_info, &ep->cred_dist);
-
 		ath6kl_credit_seek(target->credit_info, &ep->cred_dist);
 
 		/* see if we were successful in getting more */
@@ -558,7 +569,8 @@ static int htc_check_credits(struct htc_target *target,
 			/* tell the target we need credits ASAP! */
 			*flags |= HTC_FLAGS_NEED_CREDIT_UPDATE;
 			ep->ep_st.cred_low_indicate += 1;
-			ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds host needs credits\n");
+			ath6kl_dbg(ATH6KL_DBG_CREDIT,
+				   "credit we need credits asap\n");
 		}
 	}
 
@@ -1495,9 +1507,6 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 	int tot_credits = 0, i;
 	bool dist = false;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc creds report entries %d\n", n_entries);
-
 	spin_lock_bh(&target->tx_lock);
 
 	for (i = 0; i < n_entries; i++, rpt++) {
@@ -1509,8 +1518,8 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 
 		endpoint = &target->endpoint[rpt->eid];
 
-		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "htc creds report ep %d credits %d\n",
+		ath6kl_dbg(ATH6KL_DBG_CREDIT,
+			   "credit report ep %d credits %d\n",
 			   rpt->eid, rpt->credits);
 
 		endpoint->ep_st.tx_cred_rpt += 1;
@@ -1551,18 +1560,11 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		tot_credits += rpt->credits;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc creds report tot_credits %d\n",
-		   tot_credits);
-
 	if (dist) {
 		/*
 		 * This was a credit return based on a completed send
 		 * operations note, this is done with the lock held
 		 */
-		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->credit_info, &target->cred_dist_list);
-
 		ath6kl_credit_distribute(target->credit_info,
 					 &target->cred_dist_list,
 					 HTC_CREDIT_DIST_SEND_COMPLETE);

