Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:54929 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1JXJRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:17 -0400
Subject: [PATCH 4/9] ath6kl: rename struct htc_credit_state_info to
	ath6kl_htc_credit_info
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:12 +0300
Message-ID: <20111024091711.5004.88674.stgit@localhost6.localdomain6> (sfid-20111024_111721_138778_22B9AD85)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also rename cred_dist_cntxt to credit_info in struct htc_target.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |   10 +++++-----
 drivers/net/wireless/ath/ath6kl/core.h   |    4 ++--
 drivers/net/wireless/ath/ath6kl/debug.c  |   10 +++++-----
 drivers/net/wireless/ath/ath6kl/htc.c    |   31 +++++++++++++++---------------
 drivers/net/wireless/ath/ath6kl/htc.h    |   11 ++++++++---
 drivers/net/wireless/ath/ath6kl/main.c   |   17 +++++++++-------
 6 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index fd239ea..4fb2ccf 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -76,17 +76,17 @@ enum crypto_type {
 struct htc_endpoint_credit_dist;
 struct ath6kl;
 enum htc_credit_dist_reason;
-struct htc_credit_state_info;
+struct ath6kl_htc_credit_info;
 
 int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct htc_credit_state_info *cred_info);
-void ath6kl_credit_distribute(struct htc_credit_state_info *cred_inf,
+			     struct ath6kl_htc_credit_info *cred_info);
+void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_inf,
 			      struct list_head *epdist_list,
 			      enum htc_credit_dist_reason reason);
-void ath6kl_credit_init(struct htc_credit_state_info *cred_inf,
+void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_inf,
 			struct list_head *ep_list,
 			int tot_credits);
-void ath6kl_seek_credits(struct htc_credit_state_info *cred_inf,
+void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_inf,
 			 struct htc_endpoint_credit_dist *ep_dist);
 struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 31e5c7e..f8135a4 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -447,7 +447,7 @@ struct ath6kl {
 	u8 hiac_stream_active_pri;
 	u8 ep2ac_map[ENDPOINT_MAX];
 	enum htc_endpoint_id ctrl_ep;
-	struct htc_credit_state_info credit_state_info;
+	struct ath6kl_htc_credit_info credit_state_info;
 	u32 connect_ctrl_flags;
 	u32 user_key_ctrl;
 	u8 usr_bss_filter;
@@ -545,7 +545,7 @@ static inline void *ath6kl_priv(struct net_device *dev)
 	return wdev_priv(dev->ieee80211_ptr);
 }
 
-static inline void ath6kl_deposit_credit_to_ep(struct htc_credit_state_info
+static inline void ath6kl_deposit_credit_to_ep(struct ath6kl_htc_credit_info
 					       *cred_info,
 					       struct htc_endpoint_credit_dist
 					       *ep_dist, int credits)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index a6fda09..324fdb3 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -180,11 +180,11 @@ void dump_cred_dist_stats(struct htc_target *target)
 		dump_cred_dist(ep_list);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC, "ctxt:%p dist:%p\n",
-		   target->cred_dist_cntxt, NULL);
+		   target->credit_info, NULL);
 	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "credit distribution, total : %d, free : %d\n",
-		   target->cred_dist_cntxt->total_avail_credits,
-		   target->cred_dist_cntxt->cur_free_credits);
+		   target->credit_info->total_avail_credits,
+		   target->credit_info->cur_free_credits);
 }
 
 static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
@@ -554,10 +554,10 @@ static ssize_t read_file_credit_dist_stats(struct file *file,
 
 	len += scnprintf(buf + len, buf_len - len, "%25s%5d\n",
 			 "Total Avail Credits: ",
-			 target->cred_dist_cntxt->total_avail_credits);
+			 target->credit_info->total_avail_credits);
 	len += scnprintf(buf + len, buf_len - len, "%25s%5d\n",
 			 "Free credits :",
-			 target->cred_dist_cntxt->cur_free_credits);
+			 target->credit_info->cur_free_credits);
 
 	len += scnprintf(buf + len, buf_len - len,
 			 " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd"
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 4685a1b..24dfc02 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -103,11 +103,11 @@ static void htc_tx_comp_update(struct htc_target *target,
 	endpoint->cred_dist.txq_depth = get_queue_depth(&endpoint->txq);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx ctxt 0x%p dist 0x%p\n",
-		   target->cred_dist_cntxt, &target->cred_dist_list);
+		   target->credit_info, &target->cred_dist_list);
 
-	ath6kl_credit_distribute(target->cred_dist_cntxt,
-				&target->cred_dist_list,
-				HTC_CREDIT_DIST_SEND_COMPLETE);
+	ath6kl_credit_distribute(target->credit_info,
+				 &target->cred_dist_list,
+				 HTC_CREDIT_DIST_SEND_COMPLETE);
 
 	spin_unlock_bh(&target->tx_lock);
 }
@@ -235,9 +235,9 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.seek_cred = *req_cred - ep->cred_dist.credits;
 
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->cred_dist_cntxt, &ep->cred_dist);
+			   target->credit_info, &ep->cred_dist);
 
-		ath6kl_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
+		ath6kl_seek_credits(target->credit_info, &ep->cred_dist);
 
 		ep->cred_dist.seek_cred = 0;
 
@@ -258,9 +258,9 @@ static int htc_check_credits(struct htc_target *target,
 		ep->cred_dist.cred_per_msg - ep->cred_dist.credits;
 
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->cred_dist_cntxt, &ep->cred_dist);
+			   target->credit_info, &ep->cred_dist);
 
-		ath6kl_seek_credits(target->cred_dist_cntxt, &ep->cred_dist);
+		ath6kl_seek_credits(target->credit_info, &ep->cred_dist);
 
 		/* see if we were successful in getting more */
 		if (ep->cred_dist.credits < ep->cred_dist.cred_per_msg) {
@@ -698,13 +698,13 @@ static int htc_setup_tx_complete(struct htc_target *target)
 }
 
 void ath6kl_htc_set_credit_dist(struct htc_target *target,
-				struct htc_credit_state_info *cred_dist_cntxt,
+				struct ath6kl_htc_credit_info *credit_info,
 				u16 srvc_pri_order[], int list_len)
 {
 	struct htc_endpoint *endpoint;
 	int i, ep;
 
-	target->cred_dist_cntxt = cred_dist_cntxt;
+	target->credit_info = credit_info;
 
 	list_add_tail(&target->endpoint[ENDPOINT_0].cred_dist.list,
 		      &target->cred_dist_list);
@@ -840,9 +840,9 @@ void ath6kl_htc_indicate_activity_change(struct htc_target *target,
 
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "htc tx activity ctxt 0x%p dist 0x%p\n",
-			   target->cred_dist_cntxt, &target->cred_dist_list);
+			   target->credit_info, &target->cred_dist_list);
 
-		ath6kl_credit_distribute(target->cred_dist_cntxt,
+		ath6kl_credit_distribute(target->credit_info,
 					 &target->cred_dist_list,
 					 HTC_CREDIT_DIST_ACTIVITY_CHANGE);
 	}
@@ -1270,9 +1270,9 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 		 * operations note, this is done with the lock held
 		 */
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc creds ctxt 0x%p dist 0x%p\n",
-			   target->cred_dist_cntxt, &target->cred_dist_list);
+			   target->credit_info, &target->cred_dist_list);
 
-		ath6kl_credit_distribute(target->cred_dist_cntxt,
+		ath6kl_credit_distribute(target->credit_info,
 					 &target->cred_dist_list,
 					 HTC_CREDIT_DIST_SEND_COMPLETE);
 	}
@@ -2176,6 +2176,7 @@ static void reset_ep_state(struct htc_target *target)
 	}
 
 	/* reset distribution list */
+	/* FIXME: free existing entries */
 	INIT_LIST_HEAD(&target->cred_dist_list);
 }
 
@@ -2338,7 +2339,7 @@ int ath6kl_htc_start(struct htc_target *target)
 	}
 
 	/* NOTE: the first entry in the distribution list is ENDPOINT_0 */
-	ath6kl_credit_init(target->cred_dist_cntxt, &target->cred_dist_list,
+	ath6kl_credit_init(target->credit_info, &target->cred_dist_list,
 			   target->tgt_creds);
 
 	dump_cred_dist_stats(target);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 5db4294..47a588c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -414,9 +414,11 @@ enum htc_credit_dist_reason {
 	HTC_CREDIT_DIST_SEEK_CREDITS,
 };
 
-struct htc_credit_state_info {
+struct ath6kl_htc_credit_info {
 	int total_avail_credits;
 	int cur_free_credits;
+
+	/* list of lowest priority endpoints */
 	struct list_head lowestpri_ep_dist;
 };
 
@@ -508,10 +510,13 @@ struct ath6kl_device;
 /* our HTC target state */
 struct htc_target {
 	struct htc_endpoint endpoint[ENDPOINT_MAX];
+
+	/* contains struct htc_endpoint_credit_dist */
 	struct list_head cred_dist_list;
+
 	struct list_head free_ctrl_txbuf;
 	struct list_head free_ctrl_rxbuf;
-	struct htc_credit_state_info *cred_dist_cntxt;
+	struct ath6kl_htc_credit_info *credit_info;
 	int tgt_creds;
 	unsigned int tgt_cred_sz;
 	spinlock_t htc_lock;
@@ -542,7 +547,7 @@ struct htc_target {
 
 void *ath6kl_htc_create(struct ath6kl *ar);
 void ath6kl_htc_set_credit_dist(struct htc_target *target,
-				struct htc_credit_state_info *cred_info,
+				struct ath6kl_htc_credit_info *cred_info,
 				u16 svc_pri_order[], int len);
 int ath6kl_htc_wait_target(struct htc_target *target);
 int ath6kl_htc_start(struct htc_target *target);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f35f763..bc9ec6c 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -623,7 +623,7 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
 }
 
 /* Functions for Tx credit handling */
-void ath6kl_credit_init(struct htc_credit_state_info *cred_info,
+void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 			struct list_head *ep_list,
 			int tot_credits)
 {
@@ -659,6 +659,7 @@ void ath6kl_credit_init(struct htc_credit_state_info *cred_info,
 			cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
 		} else if (cur_ep_dist->svc_id == WMI_DATA_BK_SVC)
 			/* this is the lowest priority data endpoint */
+			/* FIXME: this looks fishy, check */
 			cred_info->lowestpri_ep_dist = cur_ep_dist->list;
 
 		/*
@@ -703,11 +704,11 @@ void ath6kl_credit_init(struct htc_credit_state_info *cred_info,
 
 /* initialize and setup credit distribution */
 int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct htc_credit_state_info *cred_info)
+			     struct ath6kl_htc_credit_info *cred_info)
 {
 	u16 servicepriority[5];
 
-	memset(cred_info, 0, sizeof(struct htc_credit_state_info));
+	memset(cred_info, 0, sizeof(struct ath6kl_htc_credit_info));
 
 	servicepriority[0] = WMI_CONTROL_SVC;  /* highest */
 	servicepriority[1] = WMI_DATA_VO_SVC;
@@ -722,7 +723,7 @@ int ath6kl_setup_credit_dist(void *htc_handle,
 }
 
 /* reduce an ep's credits back to a set limit */
-static void ath6kl_reduce_credits(struct htc_credit_state_info *cred_info,
+static void ath6kl_reduce_credits(struct ath6kl_htc_credit_info *cred_info,
 				  struct htc_endpoint_credit_dist *ep_dist,
 				  int limit)
 {
@@ -738,7 +739,7 @@ static void ath6kl_reduce_credits(struct htc_credit_state_info *cred_info,
 	cred_info->cur_free_credits += credits;
 }
 
-static void ath6kl_credit_update(struct htc_credit_state_info *cred_info,
+static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
 				 struct list_head *epdist_list)
 {
 	struct htc_endpoint_credit_dist *cur_dist_list;
@@ -775,7 +776,7 @@ static void ath6kl_credit_update(struct htc_credit_state_info *cred_info,
  * HTC has an endpoint that needs credits, ep_dist is the endpoint in
  * question.
  */
-void ath6kl_seek_credits(struct htc_credit_state_info *cred_info,
+void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
 			 struct htc_endpoint_credit_dist *ep_dist)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
@@ -851,7 +852,7 @@ out:
 }
 
 /* redistribute credits based on activity change */
-static void ath6kl_redistribute_credits(struct htc_credit_state_info *info,
+static void ath6kl_redistribute_credits(struct ath6kl_htc_credit_info *info,
 					struct list_head *ep_dist_list)
 {
 	struct htc_endpoint_credit_dist *curdist_list;
@@ -884,7 +885,7 @@ static void ath6kl_redistribute_credits(struct htc_credit_state_info *info,
  * structures in prioritized order as defined by the call to the
  * htc_set_credit_dist() api.
  */
-void ath6kl_credit_distribute(struct htc_credit_state_info *cred_info,
+void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_info,
 			      struct list_head *ep_dist_list,
 			      enum htc_credit_dist_reason reason)
 {

