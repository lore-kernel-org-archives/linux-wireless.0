Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51316 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1JXJRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:00 -0400
Subject: [PATCH 2/9] ath6kl: use ath6kl prefix in credit functions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:16:55 +0300
Message-ID: <20111024091655.5004.5516.stgit@localhost6.localdomain6> (sfid-20111024_111703_795665_96BB6214)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to follow the common style in the driver. Also add braces to
fix a style issue.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |   20 +++++-----
 drivers/net/wireless/ath/ath6kl/htc.c    |   22 ++++++-----
 drivers/net/wireless/ath/ath6kl/init.c   |    2 +
 drivers/net/wireless/ath/ath6kl/main.c   |   60 +++++++++++++++---------------
 4 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index d2efa19..fd239ea 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -78,16 +78,16 @@ struct ath6kl;
 enum htc_credit_dist_reason;
 struct htc_credit_state_info;
 
-int ath6k_setup_credit_dist(void *htc_handle,
-			    struct htc_credit_state_info *cred_info);
-void ath6k_credit_distribute(struct htc_credit_state_info *cred_inf,
-			     struct list_head *epdist_list,
-			     enum htc_credit_dist_reason reason);
-void ath6k_credit_init(struct htc_credit_state_info *cred_inf,
-		       struct list_head *ep_list,
-		       int tot_credits);
-void ath6k_seek_credits(struct htc_credit_state_info *cred_inf,
-			struct htc_endpoint_credit_dist *ep_dist);
+int ath6kl_setup_credit_dist(void *htc_handle,
+			     struct htc_credit_state_info *cred_info);
+void ath6kl_credit_distribute(struct htc_credit_state_info *cred_inf,
+			      struct list_head *epdist_list,
+			      enum htc_credit_dist_reason reason);
+void ath6kl_credit_init(struct htc_credit_state_info *cred_inf,
+			struct list_head *ep_list,
+			int tot_credits);
+void ath6kl_seek_credits(struct htc_credit_state_info *cred_inf,
+			 struct htc_endpoint_credit_dist *ep_dist);
 struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
 int ath6kl_unavail_ev(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 3cd3ef5..b861fa1 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -105,7 +105,7 @@ static void htc_tx_comp_update(struct htc_target *target,
 	ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx ctxt 0x%p dist 0x%p\n",
 		   target->cred_dist_cntxt, &target->cred_dist_list);
 
-	ath6k_credit_distribute(target->cred_dist_cntxt,
+	ath6kl_credit_distribute(target->cred_dist_cntxt,
 				&target->cred_dist_list,
 				HTC_CREDIT_DIST_SEND_COMPLETE);
 
@@ -237,7 +237,7 @@ static int htc_check_credits(struct htc_target *target,
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
-		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
+		ath6kl_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
 
 		ep->cred_dist.seek_cred = 0;
 
@@ -260,7 +260,7 @@ static int htc_check_credits(struct htc_target *target,
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &ep->cred_dist);
 
-		ath6k_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
+		ath6kl_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
 
 		/* see if we were successful in getting more */
 		if (ep->cred_dist.credits < ep->cred_dist.cred_per_msg) {
@@ -842,9 +842,9 @@ void ath6kl_htc_indicate_activity_change(struct htc_target *target,
 			   "htc tx activity ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
-		ath6k_credit_distribute(target->cred_dist_cntxt,
-					&target->cred_dist_list,
-					HTC_CREDIT_DIST_ACTIVITY_CHANGE);
+		ath6kl_credit_distribute(target->cred_dist_cntxt,
+					 &target->cred_dist_list,
+					 HTC_CREDIT_DIST_ACTIVITY_CHANGE);
 	}
 
 	spin_unlock_bh(&target->tx_lock);
@@ -1272,9 +1272,9 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->cred_dist_cntxt, &target->cred_dist_list);
 
-		ath6k_credit_distribute(target->cred_dist_cntxt,
-					&target->cred_dist_list,
-					HTC_CREDIT_DIST_SEND_COMPLETE);
+		ath6kl_credit_distribute(target->cred_dist_cntxt,
+					 &target->cred_dist_list,
+					 HTC_CREDIT_DIST_SEND_COMPLETE);
 	}
 
 	spin_unlock_bh(&target->tx_lock);
@@ -2338,8 +2338,8 @@ int ath6kl_htc_start(struct htc_target *target)
 	}
 
 	/* NOTE: the first entry in the distribution list is ENDPOINT_0 */
-	ath6k_credit_init(target->cred_dist_cntxt, &target->cred_dist_list,
-			  target->tgt_creds);
+	ath6kl_credit_init(target->cred_dist_cntxt, &target->cred_dist_list,
+			   target->tgt_creds);
 
 	dump_cred_dist_stats(target);
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1700423..777ee2c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1516,7 +1516,7 @@ static int ath6kl_init(struct net_device *dev)
 	ath6kl_refill_amsdu_rxbufs(ar, ATH6KL_MAX_AMSDU_RX_BUFFERS);
 
 	/* setup credit distribution */
-	ath6k_setup_credit_dist(ar->htc_target, &ar->credit_state_info);
+	ath6kl_setup_credit_dist(ar->htc_target, &ar->credit_state_info);
 
 	ath6kl_cookie_init(ar);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index e693756..f35f763 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -623,9 +623,9 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
 }
 
 /* Functions for Tx credit handling */
-void ath6k_credit_init(struct htc_credit_state_info *cred_info,
-		       struct list_head *ep_list,
-		       int tot_credits)
+void ath6kl_credit_init(struct htc_credit_state_info *cred_info,
+			struct list_head *ep_list,
+			int tot_credits)
 {
 	struct htc_endpoint_credit_dist *cur_ep_dist;
 	int count;
@@ -639,7 +639,7 @@ void ath6k_credit_init(struct htc_credit_state_info *cred_info,
 
 		cur_ep_dist->cred_min = cur_ep_dist->cred_per_msg;
 
-		if (tot_credits > 4)
+		if (tot_credits > 4) {
 			if ((cur_ep_dist->svc_id == WMI_DATA_BK_SVC) ||
 			    (cur_ep_dist->svc_id == WMI_DATA_BE_SVC)) {
 				ath6kl_deposit_credit_to_ep(cred_info,
@@ -647,6 +647,7 @@ void ath6k_credit_init(struct htc_credit_state_info *cred_info,
 						cur_ep_dist->cred_min);
 				cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
 			}
+		}
 
 		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC) {
 			ath6kl_deposit_credit_to_ep(cred_info, cur_ep_dist,
@@ -701,8 +702,8 @@ void ath6k_credit_init(struct htc_credit_state_info *cred_info,
 }
 
 /* initialize and setup credit distribution */
-int ath6k_setup_credit_dist(void *htc_handle,
-			    struct htc_credit_state_info *cred_info)
+int ath6kl_setup_credit_dist(void *htc_handle,
+			     struct htc_credit_state_info *cred_info)
 {
 	u16 servicepriority[5];
 
@@ -721,9 +722,9 @@ int ath6k_setup_credit_dist(void *htc_handle,
 }
 
 /* reduce an ep's credits back to a set limit */
-static void ath6k_reduce_credits(struct htc_credit_state_info *cred_info,
-				 struct htc_endpoint_credit_dist  *ep_dist,
-				 int limit)
+static void ath6kl_reduce_credits(struct htc_credit_state_info *cred_info,
+				  struct htc_endpoint_credit_dist *ep_dist,
+				  int limit)
 {
 	int credits;
 
@@ -737,8 +738,8 @@ static void ath6k_reduce_credits(struct htc_credit_state_info *cred_info,
 	cred_info->cur_free_credits += credits;
 }
 
-static void ath6k_credit_update(struct htc_credit_state_info *cred_info,
-				struct list_head *epdist_list)
+static void ath6kl_credit_update(struct htc_credit_state_info *cred_info,
+				 struct list_head *epdist_list)
 {
 	struct htc_endpoint_credit_dist *cur_dist_list;
 
@@ -752,19 +753,19 @@ static void ath6k_credit_update(struct htc_credit_state_info *cred_info,
 			cur_dist_list->cred_to_dist = 0;
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_assngd)
-				ath6k_reduce_credits(cred_info,
+				ath6kl_reduce_credits(cred_info,
 						cur_dist_list,
 						cur_dist_list->cred_assngd);
 
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_norm)
-				ath6k_reduce_credits(cred_info, cur_dist_list,
-						     cur_dist_list->cred_norm);
+				ath6kl_reduce_credits(cred_info, cur_dist_list,
+						      cur_dist_list->cred_norm);
 
 			if (!(cur_dist_list->dist_flags & HTC_EP_ACTIVE)) {
 				if (cur_dist_list->txq_depth == 0)
-					ath6k_reduce_credits(cred_info,
-							     cur_dist_list, 0);
+					ath6kl_reduce_credits(cred_info,
+							      cur_dist_list, 0);
 			}
 		}
 	}
@@ -774,8 +775,8 @@ static void ath6k_credit_update(struct htc_credit_state_info *cred_info,
  * HTC has an endpoint that needs credits, ep_dist is the endpoint in
  * question.
  */
-void ath6k_seek_credits(struct htc_credit_state_info *cred_info,
-			struct htc_endpoint_credit_dist *ep_dist)
+void ath6kl_seek_credits(struct htc_credit_state_info *cred_info,
+			 struct htc_endpoint_credit_dist *ep_dist)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
 	int credits = 0;
@@ -827,8 +828,8 @@ void ath6k_seek_credits(struct htc_credit_state_info *cred_info,
 			 * above it's minimum to fulfill our need try to
 			 * take away just enough to fulfill our need.
 			 */
-			ath6k_reduce_credits(cred_info, curdist_list,
-					curdist_list->cred_assngd - need);
+			ath6kl_reduce_credits(cred_info, curdist_list,
+					      curdist_list->cred_assngd - need);
 
 			if (cred_info->cur_free_credits >=
 			    ep_dist->seek_cred)
@@ -850,8 +851,8 @@ out:
 }
 
 /* redistribute credits based on activity change */
-static void ath6k_redistribute_credits(struct htc_credit_state_info *info,
-				       struct list_head *ep_dist_list)
+static void ath6kl_redistribute_credits(struct htc_credit_state_info *info,
+					struct list_head *ep_dist_list)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
 
@@ -866,10 +867,9 @@ static void ath6k_redistribute_credits(struct htc_credit_state_info *info,
 		if ((curdist_list->svc_id != WMI_CONTROL_SVC) &&
 		    !(curdist_list->dist_flags & HTC_EP_ACTIVE)) {
 			if (curdist_list->txq_depth == 0)
-				ath6k_reduce_credits(info,
-						curdist_list, 0);
+				ath6kl_reduce_credits(info, curdist_list, 0);
 			else
-				ath6k_reduce_credits(info,
+				ath6kl_reduce_credits(info,
 						curdist_list,
 						curdist_list->cred_min);
 		}
@@ -884,16 +884,16 @@ static void ath6k_redistribute_credits(struct htc_credit_state_info *info,
  * structures in prioritized order as defined by the call to the
  * htc_set_credit_dist() api.
  */
-void ath6k_credit_distribute(struct htc_credit_state_info *cred_info,
-			     struct list_head *ep_dist_list,
-			     enum htc_credit_dist_reason reason)
+void ath6kl_credit_distribute(struct htc_credit_state_info *cred_info,
+			      struct list_head *ep_dist_list,
+			      enum htc_credit_dist_reason reason)
 {
 	switch (reason) {
 	case HTC_CREDIT_DIST_SEND_COMPLETE:
-		ath6k_credit_update(cred_info, ep_dist_list);
+		ath6kl_credit_update(cred_info, ep_dist_list);
 		break;
 	case HTC_CREDIT_DIST_ACTIVITY_CHANGE:
-		ath6k_redistribute_credits(cred_info, ep_dist_list);
+		ath6kl_redistribute_credits(cred_info, ep_dist_list);
 		break;
 	default:
 		break;

