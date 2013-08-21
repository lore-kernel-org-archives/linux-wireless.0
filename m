Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:57354 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3HUG5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:57:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/6] ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
Date: Wed, 21 Aug 2013 08:57:27 +0200
Message-ID: <1377068249-26025-5-git-send-email-michal.kazior@tieto.com> (sfid-20130821_085745_857955_F63950D9)
In-Reply-To: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new naming makes more sense.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   34 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |    6 +++---
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 80cc7fd..b740960 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -48,9 +48,9 @@ static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
 
 static void ath10k_pci_process_ce(struct ath10k *ar);
 static int ath10k_pci_post_rx(struct ath10k *ar);
-static int ath10k_pci_post_rx_pipe(struct hif_ce_pipe_info *pipe_info,
+static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					     int num);
-static void ath10k_pci_rx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info);
+static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
 static void ath10k_pci_device_reset(struct ath10k *ar);
 static int ath10k_pci_reset_target(struct ath10k *ar);
@@ -491,7 +491,7 @@ void ath10k_do_pci_sleep(struct ath10k *ar)
  * FIXME: Handle OOM properly.
  */
 static inline
-struct ath10k_pci_compl *get_free_compl(struct hif_ce_pipe_info *pipe_info)
+struct ath10k_pci_compl *get_free_compl(struct ath10k_pci_pipe *pipe_info)
 {
 	struct ath10k_pci_compl *compl = NULL;
 
@@ -517,7 +517,7 @@ static void ath10k_pci_ce_send_done(struct ce_state *ce_state,
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info =  &ar_pci->pipe_info[ce_state->id];
+	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
 	struct ath10k_pci_compl *compl;
 	bool process = false;
 
@@ -579,7 +579,7 @@ static void ath10k_pci_ce_recv_data(struct ce_state *ce_state,
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info =  &ar_pci->pipe_info[ce_state->id];
+	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
 	struct ath10k_pci_compl *compl;
 	struct sk_buff *skb;
 
@@ -623,7 +623,7 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(nbuf);
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info = &(ar_pci->pipe_info[pipe_id]);
+	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe_id]);
 	struct ce_state *ce_hdl = pipe_info->ce_hdl;
 	struct ce_sendlist sendlist;
 	unsigned int len;
@@ -668,7 +668,7 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info = &(ar_pci->pipe_info[pipe]);
+	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe]);
 	int ret;
 
 	spin_lock_bh(&pipe_info->pipe_lock);
@@ -764,7 +764,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ce_state *ce_diag = ar_pci->ce_diag;
 	const struct ce_attr *attr;
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	struct ath10k_pci_compl *compl;
 	int i, pipe_num, completions, disable_interrupts;
 
@@ -847,7 +847,7 @@ static void ath10k_pci_cleanup_ce(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_compl *compl, *tmp;
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	struct sk_buff *netbuf;
 	int pipe_num;
 
@@ -1044,7 +1044,7 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 						 &dl_is_polled);
 }
 
-static int ath10k_pci_post_rx_pipe(struct hif_ce_pipe_info *pipe_info,
+static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 				   int num)
 {
 	struct ath10k *ar = pipe_info->hif_ce_state;
@@ -1104,7 +1104,7 @@ err:
 static int ath10k_pci_post_rx(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	const struct ce_attr *attr;
 	int pipe_num, ret = 0;
 
@@ -1154,7 +1154,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_rx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info)
+static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 {
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
@@ -1186,7 +1186,7 @@ static void ath10k_pci_rx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info)
 	}
 }
 
-static void ath10k_pci_tx_pipe_cleanup(struct hif_ce_pipe_info *pipe_info)
+static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 {
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
@@ -1239,7 +1239,7 @@ static void ath10k_pci_buffer_cleanup(struct ath10k *ar)
 	int pipe_num;
 
 	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
-		struct hif_ce_pipe_info *pipe_info;
+		struct ath10k_pci_pipe *pipe_info;
 
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 		ath10k_pci_rx_pipe_cleanup(pipe_info);
@@ -1250,7 +1250,7 @@ static void ath10k_pci_buffer_cleanup(struct ath10k *ar)
 static void ath10k_pci_ce_deinit(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	int pipe_num;
 
 	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
@@ -1686,7 +1686,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 static int ath10k_pci_ce_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	const struct ce_attr *attr;
 	int pipe_num;
 
@@ -1902,7 +1902,7 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 
 static void ath10k_pci_ce_tasklet(unsigned long ptr)
 {
-	struct hif_ce_pipe_info *pipe = (struct hif_ce_pipe_info *)ptr;
+	struct ath10k_pci_pipe *pipe = (struct ath10k_pci_pipe *)ptr;
 	struct ath10k_pci *ar_pci = pipe->ar_pci;
 
 	ath10k_ce_per_engine_service(ar_pci->ar, pipe->pipe_num);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 64fcef5..de26311 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -53,7 +53,7 @@ struct ath10k_pci_compl {
 	struct list_head list;
 	enum ath10k_pci_compl_state state;
 	struct ce_state *ce_state;
-	struct hif_ce_pipe_info *pipe_info;
+	struct ath10k_pci_pipe *pipe_info;
 	void *transfer_context;
 	unsigned int nbytes;
 	unsigned int transfer_id;
@@ -160,7 +160,7 @@ enum ath10k_pci_features {
 };
 
 /* Per-pipe state. */
-struct hif_ce_pipe_info {
+struct ath10k_pci_pipe {
 	/* Handle of underlying Copy Engine */
 	struct ce_state *ce_hdl;
 
@@ -219,7 +219,7 @@ struct ath10k_pci {
 
 	bool compl_processing;
 
-	struct hif_ce_pipe_info pipe_info[CE_COUNT_MAX];
+	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
 	struct ath10k_hif_cb msg_callbacks_current;
 
-- 
1.7.9.5

