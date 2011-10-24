Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37630 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1JXJRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:48 -0400
Subject: [PATCH 6/9] ath6kl: use ath6kl_credit prefix consistently
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:28 +0300
Message-ID: <20111024091728.5004.80955.stgit@localhost6.localdomain6> (sfid-20111024_111751_448244_C0515D04)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all credit functions used that prefix, fix that.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c  |   63 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath6kl/htc.h  |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c |    2 +
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 5cb0327..511eebd 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -23,10 +23,9 @@
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
 /* Functions for Tx credit handling */
-static void ath6kl_deposit_credit_to_ep(struct ath6kl_htc_credit_info
-					*cred_info,
-					struct htc_endpoint_credit_dist
-					*ep_dist, int credits)
+static void ath6kl_credit_deposit(struct ath6kl_htc_credit_info *cred_info,
+				  struct htc_endpoint_credit_dist *ep_dist,
+				  int credits)
 {
 	ep_dist->credits += credits;
 	ep_dist->cred_assngd += credits;
@@ -52,16 +51,16 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 		if (tot_credits > 4) {
 			if ((cur_ep_dist->svc_id == WMI_DATA_BK_SVC) ||
 			    (cur_ep_dist->svc_id == WMI_DATA_BE_SVC)) {
-				ath6kl_deposit_credit_to_ep(cred_info,
-						cur_ep_dist,
-						cur_ep_dist->cred_min);
+				ath6kl_credit_deposit(cred_info,
+						      cur_ep_dist,
+						      cur_ep_dist->cred_min);
 				cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
 			}
 		}
 
 		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC) {
-			ath6kl_deposit_credit_to_ep(cred_info, cur_ep_dist,
-						    cur_ep_dist->cred_min);
+			ath6kl_credit_deposit(cred_info, cur_ep_dist,
+					      cur_ep_dist->cred_min);
 			/*
 			 * Control service is always marked active, it
 			 * never goes inactive EVER.
@@ -113,8 +112,8 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 }
 
 /* initialize and setup credit distribution */
-int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct ath6kl_htc_credit_info *cred_info)
+int ath6kl_credit_setup(void *htc_handle,
+			struct ath6kl_htc_credit_info *cred_info)
 {
 	u16 servicepriority[5];
 
@@ -133,9 +132,9 @@ int ath6kl_setup_credit_dist(void *htc_handle,
 }
 
 /* reduce an ep's credits back to a set limit */
-static void ath6kl_reduce_credits(struct ath6kl_htc_credit_info *cred_info,
-				  struct htc_endpoint_credit_dist *ep_dist,
-				  int limit)
+static void ath6kl_credit_reduce(struct ath6kl_htc_credit_info *cred_info,
+				 struct htc_endpoint_credit_dist *ep_dist,
+				 int limit)
 {
 	int credits;
 
@@ -164,19 +163,19 @@ static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
 			cur_dist_list->cred_to_dist = 0;
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_assngd)
-				ath6kl_reduce_credits(cred_info,
+				ath6kl_credit_reduce(cred_info,
 						cur_dist_list,
 						cur_dist_list->cred_assngd);
 
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_norm)
-				ath6kl_reduce_credits(cred_info, cur_dist_list,
-						      cur_dist_list->cred_norm);
+				ath6kl_credit_reduce(cred_info, cur_dist_list,
+						     cur_dist_list->cred_norm);
 
 			if (!(cur_dist_list->dist_flags & HTC_EP_ACTIVE)) {
 				if (cur_dist_list->txq_depth == 0)
-					ath6kl_reduce_credits(cred_info,
-							      cur_dist_list, 0);
+					ath6kl_credit_reduce(cred_info,
+							     cur_dist_list, 0);
 			}
 		}
 	}
@@ -186,7 +185,7 @@ static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
  * HTC has an endpoint that needs credits, ep_dist is the endpoint in
  * question.
  */
-static void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
+static void ath6kl_credit_seek(struct ath6kl_htc_credit_info *cred_info,
 				struct htc_endpoint_credit_dist *ep_dist)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
@@ -239,8 +238,8 @@ static void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
 			 * above it's minimum to fulfill our need try to
 			 * take away just enough to fulfill our need.
 			 */
-			ath6kl_reduce_credits(cred_info, curdist_list,
-					      curdist_list->cred_assngd - need);
+			ath6kl_credit_reduce(cred_info, curdist_list,
+					     curdist_list->cred_assngd - need);
 
 			if (cred_info->cur_free_credits >=
 			    ep_dist->seek_cred)
@@ -256,14 +255,14 @@ static void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
 out:
 	/* did we find some credits? */
 	if (credits)
-		ath6kl_deposit_credit_to_ep(cred_info, ep_dist, credits);
+		ath6kl_credit_deposit(cred_info, ep_dist, credits);
 
 	ep_dist->seek_cred = 0;
 }
 
 /* redistribute credits based on activity change */
-static void ath6kl_redistribute_credits(struct ath6kl_htc_credit_info *info,
-					struct list_head *ep_dist_list)
+static void ath6kl_credit_redistribute(struct ath6kl_htc_credit_info *info,
+				       struct list_head *ep_dist_list)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
 
@@ -278,11 +277,11 @@ static void ath6kl_redistribute_credits(struct ath6kl_htc_credit_info *info,
 		if ((curdist_list->svc_id != WMI_CONTROL_SVC) &&
 		    !(curdist_list->dist_flags & HTC_EP_ACTIVE)) {
 			if (curdist_list->txq_depth == 0)
-				ath6kl_reduce_credits(info, curdist_list, 0);
+				ath6kl_credit_reduce(info, curdist_list, 0);
 			else
-				ath6kl_reduce_credits(info,
-						curdist_list,
-						curdist_list->cred_min);
+				ath6kl_credit_reduce(info,
+						     curdist_list,
+						     curdist_list->cred_min);
 		}
 	}
 }
@@ -304,7 +303,7 @@ static void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_info,
 		ath6kl_credit_update(cred_info, ep_dist_list);
 		break;
 	case HTC_CREDIT_DIST_ACTIVITY_CHANGE:
-		ath6kl_redistribute_credits(cred_info, ep_dist_list);
+		ath6kl_credit_redistribute(cred_info, ep_dist_list);
 		break;
 	default:
 		break;
@@ -529,7 +528,7 @@ static int htc_check_credits(struct htc_target *target,
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->credit_info, &ep->cred_dist);
 
-		ath6kl_seek_credits(target->credit_info, &ep->cred_dist);
+		ath6kl_credit_seek(target->credit_info, &ep->cred_dist);
 
 		ep->cred_dist.seek_cred = 0;
 
@@ -552,7 +551,7 @@ static int htc_check_credits(struct htc_target *target,
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
 			   target->credit_info, &ep->cred_dist);
 
-		ath6kl_seek_credits(target->credit_info, &ep->cred_dist);
+		ath6kl_credit_seek(target->credit_info, &ep->cred_dist);
 
 		/* see if we were successful in getting more */
 		if (ep->cred_dist.credits < ep->cred_dist.cred_per_msg) {
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index c68e834..57672e1 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -570,8 +570,8 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 				     u32 msg_look_ahead, int *n_pkts);
 
-int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct ath6kl_htc_credit_info *cred_info);
+int ath6kl_credit_setup(void *htc_handle,
+			struct ath6kl_htc_credit_info *cred_info);
 
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 777ee2c..d161862 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1516,7 +1516,7 @@ static int ath6kl_init(struct net_device *dev)
 	ath6kl_refill_amsdu_rxbufs(ar, ATH6KL_MAX_AMSDU_RX_BUFFERS);
 
 	/* setup credit distribution */
-	ath6kl_setup_credit_dist(ar->htc_target, &ar->credit_state_info);
+	ath6kl_credit_setup(ar->htc_target, &ar->credit_state_info);
 
 	ath6kl_cookie_init(ar);
 

