Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:54985 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1JXJRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:25 -0400
Subject: [PATCH 5/9] ath6kl: move all credit distribution code to htc.c
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:20 +0300
Message-ID: <20111024091720.5004.3214.stgit@localhost6.localdomain6> (sfid-20111024_111730_558470_929A0104)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As htc is the only user there's no reason to keep it in main.c.

No functional changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |   10 -
 drivers/net/wireless/ath/ath6kl/core.h   |   10 -
 drivers/net/wireless/ath/ath6kl/htc.c    |  292 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/htc.h    |    3 
 drivers/net/wireless/ath/ath6kl/main.c   |  282 -----------------------------
 5 files changed, 295 insertions(+), 302 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index 4fb2ccf..a9fa057 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -78,16 +78,6 @@ struct ath6kl;
 enum htc_credit_dist_reason;
 struct ath6kl_htc_credit_info;
 
-int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct ath6kl_htc_credit_info *cred_info);
-void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_inf,
-			      struct list_head *epdist_list,
-			      enum htc_credit_dist_reason reason);
-void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_inf,
-			struct list_head *ep_list,
-			int tot_credits);
-void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_inf,
-			 struct htc_endpoint_credit_dist *ep_dist);
 struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
 int ath6kl_unavail_ev(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f8135a4..ae731e0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -545,16 +545,6 @@ static inline void *ath6kl_priv(struct net_device *dev)
 	return wdev_priv(dev->ieee80211_ptr);
 }
 
-static inline void ath6kl_deposit_credit_to_ep(struct ath6kl_htc_credit_info
-					       *cred_info,
-					       struct htc_endpoint_credit_dist
-					       *ep_dist, int credits)
-{
-	ep_dist->credits += credits;
-	ep_dist->cred_assngd += credits;
-	cred_info->cur_free_credits -= credits;
-}
-
 static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
 					  u32 item_offset)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 24dfc02..5cb0327 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -22,6 +22,298 @@
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
+/* Functions for Tx credit handling */
+static void ath6kl_deposit_credit_to_ep(struct ath6kl_htc_credit_info
+					*cred_info,
+					struct htc_endpoint_credit_dist
+					*ep_dist, int credits)
+{
+	ep_dist->credits += credits;
+	ep_dist->cred_assngd += credits;
+	cred_info->cur_free_credits -= credits;
+}
+
+static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
+			       struct list_head *ep_list,
+			       int tot_credits)
+{
+	struct htc_endpoint_credit_dist *cur_ep_dist;
+	int count;
+
+	cred_info->cur_free_credits = tot_credits;
+	cred_info->total_avail_credits = tot_credits;
+
+	list_for_each_entry(cur_ep_dist, ep_list, list) {
+		if (cur_ep_dist->endpoint == ENDPOINT_0)
+			continue;
+
+		cur_ep_dist->cred_min = cur_ep_dist->cred_per_msg;
+
+		if (tot_credits > 4) {
+			if ((cur_ep_dist->svc_id == WMI_DATA_BK_SVC) ||
+			    (cur_ep_dist->svc_id == WMI_DATA_BE_SVC)) {
+				ath6kl_deposit_credit_to_ep(cred_info,
+						cur_ep_dist,
+						cur_ep_dist->cred_min);
+				cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
+			}
+		}
+
+		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC) {
+			ath6kl_deposit_credit_to_ep(cred_info, cur_ep_dist,
+						    cur_ep_dist->cred_min);
+			/*
+			 * Control service is always marked active, it
+			 * never goes inactive EVER.
+			 */
+			cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
+		} else if (cur_ep_dist->svc_id == WMI_DATA_BK_SVC)
+			/* this is the lowest priority data endpoint */
+			/* FIXME: this looks fishy, check */
+			cred_info->lowestpri_ep_dist = cur_ep_dist->list;
+
+		/*
+		 * Streams have to be created (explicit | implicit) for all
+		 * kinds of traffic. BE endpoints are also inactive in the
+		 * beginning. When BE traffic starts it creates implicit
+		 * streams that redistributes credits.
+		 *
+		 * Note: all other endpoints have minimums set but are
+		 * initially given NO credits. credits will be distributed
+		 * as traffic activity demands
+		 */
+	}
+
+	WARN_ON(cred_info->cur_free_credits <= 0);
+
+	list_for_each_entry(cur_ep_dist, ep_list, list) {
+		if (cur_ep_dist->endpoint == ENDPOINT_0)
+			continue;
+
+		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC)
+			cur_ep_dist->cred_norm = cur_ep_dist->cred_per_msg;
+		else {
+			/*
+			 * For the remaining data endpoints, we assume that
+			 * each cred_per_msg are the same. We use a simple
+			 * calculation here, we take the remaining credits
+			 * and determine how many max messages this can
+			 * cover and then set each endpoint's normal value
+			 * equal to 3/4 this amount.
+			 */
+			count = (cred_info->cur_free_credits /
+				 cur_ep_dist->cred_per_msg)
+				* cur_ep_dist->cred_per_msg;
+			count = (count * 3) >> 2;
+			count = max(count, cur_ep_dist->cred_per_msg);
+			cur_ep_dist->cred_norm = count;
+
+		}
+	}
+}
+
+/* initialize and setup credit distribution */
+int ath6kl_setup_credit_dist(void *htc_handle,
+			     struct ath6kl_htc_credit_info *cred_info)
+{
+	u16 servicepriority[5];
+
+	memset(cred_info, 0, sizeof(struct ath6kl_htc_credit_info));
+
+	servicepriority[0] = WMI_CONTROL_SVC;  /* highest */
+	servicepriority[1] = WMI_DATA_VO_SVC;
+	servicepriority[2] = WMI_DATA_VI_SVC;
+	servicepriority[3] = WMI_DATA_BE_SVC;
+	servicepriority[4] = WMI_DATA_BK_SVC; /* lowest */
+
+	/* set priority list */
+	ath6kl_htc_set_credit_dist(htc_handle, cred_info, servicepriority, 5);
+
+	return 0;
+}
+
+/* reduce an ep's credits back to a set limit */
+static void ath6kl_reduce_credits(struct ath6kl_htc_credit_info *cred_info,
+				  struct htc_endpoint_credit_dist *ep_dist,
+				  int limit)
+{
+	int credits;
+
+	ep_dist->cred_assngd = limit;
+
+	if (ep_dist->credits <= limit)
+		return;
+
+	credits = ep_dist->credits - limit;
+	ep_dist->credits -= credits;
+	cred_info->cur_free_credits += credits;
+}
+
+static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
+				 struct list_head *epdist_list)
+{
+	struct htc_endpoint_credit_dist *cur_dist_list;
+
+	list_for_each_entry(cur_dist_list, epdist_list, list) {
+		if (cur_dist_list->endpoint == ENDPOINT_0)
+			continue;
+
+		if (cur_dist_list->cred_to_dist > 0) {
+			cur_dist_list->credits +=
+					cur_dist_list->cred_to_dist;
+			cur_dist_list->cred_to_dist = 0;
+			if (cur_dist_list->credits >
+			    cur_dist_list->cred_assngd)
+				ath6kl_reduce_credits(cred_info,
+						cur_dist_list,
+						cur_dist_list->cred_assngd);
+
+			if (cur_dist_list->credits >
+			    cur_dist_list->cred_norm)
+				ath6kl_reduce_credits(cred_info, cur_dist_list,
+						      cur_dist_list->cred_norm);
+
+			if (!(cur_dist_list->dist_flags & HTC_EP_ACTIVE)) {
+				if (cur_dist_list->txq_depth == 0)
+					ath6kl_reduce_credits(cred_info,
+							      cur_dist_list, 0);
+			}
+		}
+	}
+}
+
+/*
+ * HTC has an endpoint that needs credits, ep_dist is the endpoint in
+ * question.
+ */
+static void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
+				struct htc_endpoint_credit_dist *ep_dist)
+{
+	struct htc_endpoint_credit_dist *curdist_list;
+	int credits = 0;
+	int need;
+
+	if (ep_dist->svc_id == WMI_CONTROL_SVC)
+		goto out;
+
+	if ((ep_dist->svc_id == WMI_DATA_VI_SVC) ||
+	    (ep_dist->svc_id == WMI_DATA_VO_SVC))
+		if ((ep_dist->cred_assngd >= ep_dist->cred_norm))
+			goto out;
+
+	/*
+	 * For all other services, we follow a simple algorithm of:
+	 *
+	 * 1. checking the free pool for credits
+	 * 2. checking lower priority endpoints for credits to take
+	 */
+
+	credits = min(cred_info->cur_free_credits, ep_dist->seek_cred);
+
+	if (credits >= ep_dist->seek_cred)
+		goto out;
+
+	/*
+	 * We don't have enough in the free pool, try taking away from
+	 * lower priority services The rule for taking away credits:
+	 *
+	 *   1. Only take from lower priority endpoints
+	 *   2. Only take what is allocated above the minimum (never
+	 *      starve an endpoint completely)
+	 *   3. Only take what you need.
+	 */
+
+	list_for_each_entry_reverse(curdist_list,
+				    &cred_info->lowestpri_ep_dist,
+				    list) {
+		if (curdist_list == ep_dist)
+			break;
+
+		need = ep_dist->seek_cred - cred_info->cur_free_credits;
+
+		if ((curdist_list->cred_assngd - need) >=
+		     curdist_list->cred_min) {
+			/*
+			 * The current one has been allocated more than
+			 * it's minimum and it has enough credits assigned
+			 * above it's minimum to fulfill our need try to
+			 * take away just enough to fulfill our need.
+			 */
+			ath6kl_reduce_credits(cred_info, curdist_list,
+					      curdist_list->cred_assngd - need);
+
+			if (cred_info->cur_free_credits >=
+			    ep_dist->seek_cred)
+				break;
+		}
+
+		if (curdist_list->endpoint == ENDPOINT_0)
+			break;
+	}
+
+	credits = min(cred_info->cur_free_credits, ep_dist->seek_cred);
+
+out:
+	/* did we find some credits? */
+	if (credits)
+		ath6kl_deposit_credit_to_ep(cred_info, ep_dist, credits);
+
+	ep_dist->seek_cred = 0;
+}
+
+/* redistribute credits based on activity change */
+static void ath6kl_redistribute_credits(struct ath6kl_htc_credit_info *info,
+					struct list_head *ep_dist_list)
+{
+	struct htc_endpoint_credit_dist *curdist_list;
+
+	list_for_each_entry(curdist_list, ep_dist_list, list) {
+		if (curdist_list->endpoint == ENDPOINT_0)
+			continue;
+
+		if ((curdist_list->svc_id == WMI_DATA_BK_SVC)  ||
+		    (curdist_list->svc_id == WMI_DATA_BE_SVC))
+			curdist_list->dist_flags |= HTC_EP_ACTIVE;
+
+		if ((curdist_list->svc_id != WMI_CONTROL_SVC) &&
+		    !(curdist_list->dist_flags & HTC_EP_ACTIVE)) {
+			if (curdist_list->txq_depth == 0)
+				ath6kl_reduce_credits(info, curdist_list, 0);
+			else
+				ath6kl_reduce_credits(info,
+						curdist_list,
+						curdist_list->cred_min);
+		}
+	}
+}
+
+/*
+ *
+ * This function is invoked whenever endpoints require credit
+ * distributions. A lock is held while this function is invoked, this
+ * function shall NOT block. The ep_dist_list is a list of distribution
+ * structures in prioritized order as defined by the call to the
+ * htc_set_credit_dist() api.
+ */
+static void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_info,
+				     struct list_head *ep_dist_list,
+			      enum htc_credit_dist_reason reason)
+{
+	switch (reason) {
+	case HTC_CREDIT_DIST_SEND_COMPLETE:
+		ath6kl_credit_update(cred_info, ep_dist_list);
+		break;
+	case HTC_CREDIT_DIST_ACTIVITY_CHANGE:
+		ath6kl_redistribute_credits(cred_info, ep_dist_list);
+		break;
+	default:
+		break;
+	}
+
+	WARN_ON(cred_info->cur_free_credits > cred_info->total_avail_credits);
+	WARN_ON(cred_info->cur_free_credits < 0);
+}
+
 static void ath6kl_htc_tx_buf_align(u8 **buf, unsigned long len)
 {
 	u8 *align_addr;
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 47a588c..c68e834 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -570,6 +570,9 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 				     u32 msg_look_ahead, int *n_pkts);
 
+int ath6kl_setup_credit_dist(void *htc_handle,
+			     struct ath6kl_htc_credit_info *cred_info);
+
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
 				    enum htc_endpoint_id eid, u16 tag)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bc9ec6c..8d9a8f3 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -622,288 +622,6 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl *ar, u16 aid, u8 *mac_addr,
 	netif_wake_queue(ar->net_dev);
 }
 
-/* Functions for Tx credit handling */
-void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
-			struct list_head *ep_list,
-			int tot_credits)
-{
-	struct htc_endpoint_credit_dist *cur_ep_dist;
-	int count;
-
-	cred_info->cur_free_credits = tot_credits;
-	cred_info->total_avail_credits = tot_credits;
-
-	list_for_each_entry(cur_ep_dist, ep_list, list) {
-		if (cur_ep_dist->endpoint == ENDPOINT_0)
-			continue;
-
-		cur_ep_dist->cred_min = cur_ep_dist->cred_per_msg;
-
-		if (tot_credits > 4) {
-			if ((cur_ep_dist->svc_id == WMI_DATA_BK_SVC) ||
-			    (cur_ep_dist->svc_id == WMI_DATA_BE_SVC)) {
-				ath6kl_deposit_credit_to_ep(cred_info,
-						cur_ep_dist,
-						cur_ep_dist->cred_min);
-				cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
-			}
-		}
-
-		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC) {
-			ath6kl_deposit_credit_to_ep(cred_info, cur_ep_dist,
-						    cur_ep_dist->cred_min);
-			/*
-			 * Control service is always marked active, it
-			 * never goes inactive EVER.
-			 */
-			cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
-		} else if (cur_ep_dist->svc_id == WMI_DATA_BK_SVC)
-			/* this is the lowest priority data endpoint */
-			/* FIXME: this looks fishy, check */
-			cred_info->lowestpri_ep_dist = cur_ep_dist->list;
-
-		/*
-		 * Streams have to be created (explicit | implicit) for all
-		 * kinds of traffic. BE endpoints are also inactive in the
-		 * beginning. When BE traffic starts it creates implicit
-		 * streams that redistributes credits.
-		 *
-		 * Note: all other endpoints have minimums set but are
-		 * initially given NO credits. credits will be distributed
-		 * as traffic activity demands
-		 */
-	}
-
-	WARN_ON(cred_info->cur_free_credits <= 0);
-
-	list_for_each_entry(cur_ep_dist, ep_list, list) {
-		if (cur_ep_dist->endpoint == ENDPOINT_0)
-			continue;
-
-		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC)
-			cur_ep_dist->cred_norm = cur_ep_dist->cred_per_msg;
-		else {
-			/*
-			 * For the remaining data endpoints, we assume that
-			 * each cred_per_msg are the same. We use a simple
-			 * calculation here, we take the remaining credits
-			 * and determine how many max messages this can
-			 * cover and then set each endpoint's normal value
-			 * equal to 3/4 this amount.
-			 */
-			count = (cred_info->cur_free_credits /
-				 cur_ep_dist->cred_per_msg)
-				* cur_ep_dist->cred_per_msg;
-			count = (count * 3) >> 2;
-			count = max(count, cur_ep_dist->cred_per_msg);
-			cur_ep_dist->cred_norm = count;
-
-		}
-	}
-}
-
-/* initialize and setup credit distribution */
-int ath6kl_setup_credit_dist(void *htc_handle,
-			     struct ath6kl_htc_credit_info *cred_info)
-{
-	u16 servicepriority[5];
-
-	memset(cred_info, 0, sizeof(struct ath6kl_htc_credit_info));
-
-	servicepriority[0] = WMI_CONTROL_SVC;  /* highest */
-	servicepriority[1] = WMI_DATA_VO_SVC;
-	servicepriority[2] = WMI_DATA_VI_SVC;
-	servicepriority[3] = WMI_DATA_BE_SVC;
-	servicepriority[4] = WMI_DATA_BK_SVC; /* lowest */
-
-	/* set priority list */
-	ath6kl_htc_set_credit_dist(htc_handle, cred_info, servicepriority, 5);
-
-	return 0;
-}
-
-/* reduce an ep's credits back to a set limit */
-static void ath6kl_reduce_credits(struct ath6kl_htc_credit_info *cred_info,
-				  struct htc_endpoint_credit_dist *ep_dist,
-				  int limit)
-{
-	int credits;
-
-	ep_dist->cred_assngd = limit;
-
-	if (ep_dist->credits <= limit)
-		return;
-
-	credits = ep_dist->credits - limit;
-	ep_dist->credits -= credits;
-	cred_info->cur_free_credits += credits;
-}
-
-static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
-				 struct list_head *epdist_list)
-{
-	struct htc_endpoint_credit_dist *cur_dist_list;
-
-	list_for_each_entry(cur_dist_list, epdist_list, list) {
-		if (cur_dist_list->endpoint == ENDPOINT_0)
-			continue;
-
-		if (cur_dist_list->cred_to_dist > 0) {
-			cur_dist_list->credits +=
-					cur_dist_list->cred_to_dist;
-			cur_dist_list->cred_to_dist = 0;
-			if (cur_dist_list->credits >
-			    cur_dist_list->cred_assngd)
-				ath6kl_reduce_credits(cred_info,
-						cur_dist_list,
-						cur_dist_list->cred_assngd);
-
-			if (cur_dist_list->credits >
-			    cur_dist_list->cred_norm)
-				ath6kl_reduce_credits(cred_info, cur_dist_list,
-						      cur_dist_list->cred_norm);
-
-			if (!(cur_dist_list->dist_flags & HTC_EP_ACTIVE)) {
-				if (cur_dist_list->txq_depth == 0)
-					ath6kl_reduce_credits(cred_info,
-							      cur_dist_list, 0);
-			}
-		}
-	}
-}
-
-/*
- * HTC has an endpoint that needs credits, ep_dist is the endpoint in
- * question.
- */
-void ath6kl_seek_credits(struct ath6kl_htc_credit_info *cred_info,
-			 struct htc_endpoint_credit_dist *ep_dist)
-{
-	struct htc_endpoint_credit_dist *curdist_list;
-	int credits = 0;
-	int need;
-
-	if (ep_dist->svc_id == WMI_CONTROL_SVC)
-		goto out;
-
-	if ((ep_dist->svc_id == WMI_DATA_VI_SVC) ||
-	    (ep_dist->svc_id == WMI_DATA_VO_SVC))
-		if ((ep_dist->cred_assngd >= ep_dist->cred_norm))
-			goto out;
-
-	/*
-	 * For all other services, we follow a simple algorithm of:
-	 *
-	 * 1. checking the free pool for credits
-	 * 2. checking lower priority endpoints for credits to take
-	 */
-
-	credits = min(cred_info->cur_free_credits, ep_dist->seek_cred);
-
-	if (credits >= ep_dist->seek_cred)
-		goto out;
-
-	/*
-	 * We don't have enough in the free pool, try taking away from
-	 * lower priority services The rule for taking away credits:
-	 *
-	 *   1. Only take from lower priority endpoints
-	 *   2. Only take what is allocated above the minimum (never
-	 *      starve an endpoint completely)
-	 *   3. Only take what you need.
-	 */
-
-	list_for_each_entry_reverse(curdist_list,
-				    &cred_info->lowestpri_ep_dist,
-				    list) {
-		if (curdist_list == ep_dist)
-			break;
-
-		need = ep_dist->seek_cred - cred_info->cur_free_credits;
-
-		if ((curdist_list->cred_assngd - need) >=
-		     curdist_list->cred_min) {
-			/*
-			 * The current one has been allocated more than
-			 * it's minimum and it has enough credits assigned
-			 * above it's minimum to fulfill our need try to
-			 * take away just enough to fulfill our need.
-			 */
-			ath6kl_reduce_credits(cred_info, curdist_list,
-					      curdist_list->cred_assngd - need);
-
-			if (cred_info->cur_free_credits >=
-			    ep_dist->seek_cred)
-				break;
-		}
-
-		if (curdist_list->endpoint == ENDPOINT_0)
-			break;
-	}
-
-	credits = min(cred_info->cur_free_credits, ep_dist->seek_cred);
-
-out:
-	/* did we find some credits? */
-	if (credits)
-		ath6kl_deposit_credit_to_ep(cred_info, ep_dist, credits);
-
-	ep_dist->seek_cred = 0;
-}
-
-/* redistribute credits based on activity change */
-static void ath6kl_redistribute_credits(struct ath6kl_htc_credit_info *info,
-					struct list_head *ep_dist_list)
-{
-	struct htc_endpoint_credit_dist *curdist_list;
-
-	list_for_each_entry(curdist_list, ep_dist_list, list) {
-		if (curdist_list->endpoint == ENDPOINT_0)
-			continue;
-
-		if ((curdist_list->svc_id == WMI_DATA_BK_SVC)  ||
-		    (curdist_list->svc_id == WMI_DATA_BE_SVC))
-			curdist_list->dist_flags |= HTC_EP_ACTIVE;
-
-		if ((curdist_list->svc_id != WMI_CONTROL_SVC) &&
-		    !(curdist_list->dist_flags & HTC_EP_ACTIVE)) {
-			if (curdist_list->txq_depth == 0)
-				ath6kl_reduce_credits(info, curdist_list, 0);
-			else
-				ath6kl_reduce_credits(info,
-						curdist_list,
-						curdist_list->cred_min);
-		}
-	}
-}
-
-/*
- *
- * This function is invoked whenever endpoints require credit
- * distributions. A lock is held while this function is invoked, this
- * function shall NOT block. The ep_dist_list is a list of distribution
- * structures in prioritized order as defined by the call to the
- * htc_set_credit_dist() api.
- */
-void ath6kl_credit_distribute(struct ath6kl_htc_credit_info *cred_info,
-			      struct list_head *ep_dist_list,
-			      enum htc_credit_dist_reason reason)
-{
-	switch (reason) {
-	case HTC_CREDIT_DIST_SEND_COMPLETE:
-		ath6kl_credit_update(cred_info, ep_dist_list);
-		break;
-	case HTC_CREDIT_DIST_ACTIVITY_CHANGE:
-		ath6kl_redistribute_credits(cred_info, ep_dist_list);
-		break;
-	default:
-		break;
-	}
-
-	WARN_ON(cred_info->cur_free_credits > cred_info->total_avail_credits);
-	WARN_ON(cred_info->cur_free_credits < 0);
-}
-
 void disconnect_timer_handler(unsigned long ptr)
 {
 	struct net_device *dev = (struct net_device *)ptr;

