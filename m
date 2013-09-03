Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:51296 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3ICNKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 09:10:05 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent CE from looping indefinitely
Date: Tue, 3 Sep 2013 15:09:58 +0200
Message-ID: <1378213798-24769-1-git-send-email-michal.kazior@tieto.com> (sfid-20130903_151010_873263_5AB48E4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The double while() could end up running forever.
Inner while() would complete very fast. However
the completion processing could take enough time
for more completions to flow in. In that case the
outer while() would not terminate and run again,
and again. This could happen especially on a slow
host system.

This could lead to a system freeze during heavy
traffic. Note: this doesn't solve all known
starvation issues yet.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   57 ++++------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   26 ++--------
 drivers/net/wireless/ath/ath10k/pci.c |   84 +++++++++++++++------------------
 3 files changed, 52 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index afe5df4..924b29e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -742,11 +742,6 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	u32 ctrl_addr = ce_state->ctrl_addr;
-	void *transfer_context;
-	u32 buf;
-	unsigned int nbytes;
-	unsigned int id;
-	unsigned int flags;
 	int ret;
 
 	ret = ath10k_pci_wake(ar);
@@ -759,38 +754,15 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
 					  HOST_IS_COPY_COMPLETE_MASK);
 
-	if (ce_state->recv_cb) {
-		/*
-		 * Pop completed recv buffers and call the registered
-		 * recv callback for each
-		 */
-		while (ath10k_ce_completed_recv_next_nolock(ce_state,
-							    &transfer_context,
-							    &buf, &nbytes,
-							    &id, &flags) == 0) {
-			spin_unlock_bh(&ar_pci->ce_lock);
-			ce_state->recv_cb(ce_state, transfer_context, buf,
-					  nbytes, id, flags);
-			spin_lock_bh(&ar_pci->ce_lock);
-		}
-	}
+	spin_unlock_bh(&ar_pci->ce_lock);
 
-	if (ce_state->send_cb) {
-		/*
-		 * Pop completed send buffers and call the registered
-		 * send callback for each
-		 */
-		while (ath10k_ce_completed_send_next_nolock(ce_state,
-							    &transfer_context,
-							    &buf,
-							    &nbytes,
-							    &id) == 0) {
-			spin_unlock_bh(&ar_pci->ce_lock);
-			ce_state->send_cb(ce_state, transfer_context,
-					  buf, nbytes, id);
-			spin_lock_bh(&ar_pci->ce_lock);
-		}
-	}
+	if (ce_state->recv_cb)
+		ce_state->recv_cb(ce_state);
+
+	if (ce_state->send_cb)
+		ce_state->send_cb(ce_state);
+
+	spin_lock_bh(&ar_pci->ce_lock);
 
 	/*
 	 * Misc CE interrupts are not being handled, but still need
@@ -881,11 +853,7 @@ void ath10k_ce_disable_interrupts(struct ath10k *ar)
 }
 
 void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*send_cb)(struct ath10k_ce_pipe *ce_state,
-						void *transfer_context,
-						u32 buffer,
-						unsigned int nbytes,
-						unsigned int transfer_id),
+				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts)
 {
 	struct ath10k *ar = ce_state->ar;
@@ -898,12 +866,7 @@ void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
 }
 
 void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*recv_cb)(struct ath10k_ce_pipe *ce_state,
-						void *transfer_context,
-						u32 buffer,
-						unsigned int nbytes,
-						unsigned int transfer_id,
-						unsigned int flags))
+				void (*recv_cb)(struct ath10k_ce_pipe *))
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index cfef7d0..fb22361 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -116,17 +116,8 @@ struct ath10k_ce_pipe {
 
 	u32 ctrl_addr;
 
-	void (*send_cb) (struct ath10k_ce_pipe *ce_state,
-			 void *per_transfer_send_context,
-			 u32 buffer,
-			 unsigned int nbytes,
-			 unsigned int transfer_id);
-	void (*recv_cb) (struct ath10k_ce_pipe *ce_state,
-			 void *per_transfer_recv_context,
-			 u32 buffer,
-			 unsigned int nbytes,
-			 unsigned int transfer_id,
-			 unsigned int flags);
+	void (*send_cb)(struct ath10k_ce_pipe *);
+	void (*recv_cb)(struct ath10k_ce_pipe *);
 
 	unsigned int src_sz_max;
 	struct ath10k_ce_ring *src_ring;
@@ -181,11 +172,7 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   unsigned int flags);
 
 void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*send_cb)(struct ath10k_ce_pipe *ce_state,
-						void *transfer_context,
-						u32 buffer,
-						unsigned int nbytes,
-						unsigned int transfer_id),
+				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts);
 
 /* Append a simple buffer (address/length) to a sendlist. */
@@ -228,12 +215,7 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       u32 buffer);
 
 void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*recv_cb)(struct ath10k_ce_pipe *ce_state,
-						void *transfer_context,
-						u32 buffer,
-						unsigned int nbytes,
-						unsigned int transfer_id,
-						unsigned int flags));
+				void (*recv_cb)(struct ath10k_ce_pipe *));
 
 /* recv flags */
 /* Data is byte-swapped */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 622901d..d3c5d47 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -612,19 +612,20 @@ exit:
 }
 
 /* Called by lower (CE) layer when a send to Target completes. */
-static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state,
-				    void *transfer_context,
-				    u32 ce_data,
-				    unsigned int nbytes,
-				    unsigned int transfer_id)
+static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
 	struct ath10k_pci_compl *compl;
-	bool process = false;
+	void *transfer_context;
+	u32 ce_data;
+	unsigned int nbytes;
+	unsigned int transfer_id;
 
-	do {
+	while (ath10k_ce_completed_send_next(ce_state, &transfer_context,
+					     &ce_data, &nbytes,
+					     &transfer_id) == 0) {
 		/*
 		 * For the send completion of an item in sendlist, just
 		 * increment num_sends_allowed. The upper layer callback will
@@ -655,38 +656,28 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state,
 		spin_lock_bh(&ar_pci->compl_lock);
 		list_add_tail(&compl->list, &ar_pci->compl_process);
 		spin_unlock_bh(&ar_pci->compl_lock);
-
-		process = true;
-	} while (ath10k_ce_completed_send_next(ce_state,
-							   &transfer_context,
-							   &ce_data, &nbytes,
-							   &transfer_id) == 0);
-
-	/*
-	 * If only some of the items within a sendlist have completed,
-	 * don't invoke completion processing until the entire sendlist
-	 * has been sent.
-	 */
-	if (!process)
-		return;
+	}
 
 	ath10k_pci_process_ce(ar);
 }
 
 /* Called by lower (CE) layer when data is received from the Target. */
-static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state,
-				    void *transfer_context, u32 ce_data,
-				    unsigned int nbytes,
-				    unsigned int transfer_id,
-				    unsigned int flags)
+static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
 	struct ath10k_pci_compl *compl;
 	struct sk_buff *skb;
+	void *transfer_context;
+	u32 ce_data;
+	unsigned int nbytes;
+	unsigned int transfer_id;
+	unsigned int flags;
 
-	do {
+	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
+					     &ce_data, &nbytes, &transfer_id,
+					     &flags) == 0) {
 		compl = get_free_compl(pipe_info);
 		if (!compl)
 			break;
@@ -709,12 +700,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state,
 		spin_lock_bh(&ar_pci->compl_lock);
 		list_add_tail(&compl->list, &ar_pci->compl_process);
 		spin_unlock_bh(&ar_pci->compl_lock);
-
-	} while (ath10k_ce_completed_recv_next(ce_state,
-							   &transfer_context,
-							   &ce_data, &nbytes,
-							   &transfer_id,
-							   &flags) == 0);
+	}
 
 	ath10k_pci_process_ce(ar);
 }
@@ -1490,13 +1476,16 @@ err_dma:
 	return ret;
 }
 
-static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state,
-				     void *transfer_context,
-				     u32 data,
-				     unsigned int nbytes,
-				     unsigned int transfer_id)
+static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state)
 {
-	struct bmi_xfer *xfer = transfer_context;
+	struct bmi_xfer *xfer;
+	u32 ce_data;
+	unsigned int nbytes;
+	unsigned int transfer_id;
+
+	if (ath10k_ce_completed_send_next(ce_state, (void **)&xfer, &ce_data,
+					  &nbytes, &transfer_id))
+		return;
 
 	if (xfer->wait_for_resp)
 		return;
@@ -1504,14 +1493,17 @@ static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state,
 	complete(&xfer->done);
 }
 
-static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state,
-				     void *transfer_context,
-				     u32 data,
-				     unsigned int nbytes,
-				     unsigned int transfer_id,
-				     unsigned int flags)
+static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 {
-	struct bmi_xfer *xfer = transfer_context;
+	struct bmi_xfer *xfer;
+	u32 ce_data;
+	unsigned int nbytes;
+	unsigned int transfer_id;
+	unsigned int flags;
+
+	if (ath10k_ce_completed_recv_next(ce_state, (void **)&xfer, &ce_data,
+					  &nbytes, &transfer_id, &flags))
+		return;
 
 	if (!xfer->wait_for_resp) {
 		ath10k_warn("unexpected: BMI data received; ignoring\n");
-- 
1.7.9.5

