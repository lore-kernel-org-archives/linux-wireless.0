Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:59627 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1JXJRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:08 -0400
Subject: [PATCH 3/9] ath6kl: rename struct htc_endpoint_credit_dist.htc_rsvd
	to htc_ep
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:04 +0300
Message-ID: <20111024091704.5004.34943.stgit@localhost6.localdomain6> (sfid-20111024_111711_276777_B8233836)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to use void pointer here.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    6 ++----
 drivers/net/wireless/ath/ath6kl/htc.c   |    4 ++--
 drivers/net/wireless/ath/ath6kl/htc.h   |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index e109f29..a6fda09 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -164,8 +164,7 @@ static void dump_cred_dist(struct htc_endpoint_credit_dist *ep_dist)
 	ath6kl_dbg(ATH6KL_DBG_ANY, " cred_to_dist   : %d\n",
 		   ep_dist->cred_to_dist);
 	ath6kl_dbg(ATH6KL_DBG_ANY, " txq_depth      : %d\n",
-		   get_queue_depth(&((struct htc_endpoint *)
-				     ep_dist->htc_rsvd)->txq));
+		   get_queue_depth(&ep_dist->htc_ep->txq));
 	ath6kl_dbg(ATH6KL_DBG_ANY,
 		   "----------------------------------\n");
 }
@@ -577,8 +576,7 @@ static ssize_t read_file_credit_dist_stats(struct file *file,
 		print_credit_info("%9d", cred_per_msg);
 		print_credit_info("%14d", cred_to_dist);
 		len += scnprintf(buf + len, buf_len - len, "%12d\n",
-				 get_queue_depth(&((struct htc_endpoint *)
-						 ep_list->htc_rsvd)->txq));
+				 get_queue_depth(&ep_list->htc_ep->txq));
 	}
 
 	if (len > buf_len)
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index b861fa1..4685a1b 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -619,7 +619,7 @@ static void htc_chk_ep_txq(struct htc_target *target)
 	 * are not modifying any state.
 	 */
 	list_for_each_entry(cred_dist, &target->cred_dist_list, list) {
-		endpoint = (struct htc_endpoint *)cred_dist->htc_rsvd;
+		endpoint = cred_dist->htc_ep;
 
 		spin_lock_bh(&target->tx_lock);
 		if (!list_empty(&endpoint->txq)) {
@@ -2119,7 +2119,7 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 	endpoint->len_max = max_msg_sz;
 	endpoint->ep_cb = conn_req->ep_cb;
 	endpoint->cred_dist.svc_id = conn_req->svc_id;
-	endpoint->cred_dist.htc_rsvd = endpoint;
+	endpoint->cred_dist.htc_ep = endpoint;
 	endpoint->cred_dist.endpoint = assigned_ep;
 	endpoint->cred_dist.cred_sz = target->tgt_cred_sz;
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 69d44e3..5db4294 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -393,7 +393,7 @@ struct htc_endpoint_credit_dist {
 	int cred_per_msg;
 
 	/* reserved for HTC use */
-	void *htc_rsvd;
+	struct htc_endpoint *htc_ep;
 
 	/*
 	 * current depth of TX queue , i.e. messages waiting for credits

