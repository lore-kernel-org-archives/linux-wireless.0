Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab1COLwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 07:52:15 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
	 <1299831238.5082.185.camel@wwguy-huron>
	 <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
	 <1300063647.24333.7.camel@wwguy-ubuntu>
	 <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 12:51:57 +0100
Message-ID: <1300189917.5596.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-14 at 11:16 -0700, Daniel Halperin wrote:

> BUT, it looks like when we set up aggregation, we set the scheduler to
> ALWAYS use the default maximum of 64 frames for both these parameters
> [2] when configuring the agg queue. This is probably why the scheduler
> is willing to send long batches and have many outstanding frames.  I
> bet that the fix is to make these parameters match the ones that come
> down from mac80211.  If I get time later, I will see if I can fix
> this.

Yeah, you're absolutely right, the window size and frame limit should
both match the information about the aggregation session, and be limited
to what we and the peer would like to see.

The bad thing is that we set up the queue when we get
IEEE80211_AMPDU_TX_START, but we only know the window size when we get
IEEE80211_AMPDU_TX_OPERATIONAL. However, I think we can change this
since the first TX to the queue will only happen after _OPERATIONAL. We
just need to refactor iwlagn_tx_agg_start() into the parts that can
fail, and the parts that don't.

Before that though, I suggest the patch below.

johannes

---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 +++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 -----
 7 files changed, 7 insertions(+), 31 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-1000.c	2011-03-15 12:33:56.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c	2011-03-15 12:34:00.000000000 +0100
@@ -179,8 +179,6 @@ static struct iwl_lib_ops iwl1000_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c	2011-03-15 12:33:56.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c	2011-03-15 12:34:02.000000000 +0100
@@ -259,8 +259,6 @@ static struct iwl_lib_ops iwl2000_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c	2011-03-15 12:33:56.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c	2011-03-15 12:34:05.000000000 +0100
@@ -348,8 +348,6 @@ static struct iwl_lib_ops iwl5000_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -416,8 +414,6 @@ static struct iwl_lib_ops iwl5150_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c	2011-03-15 12:33:56.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c	2011-03-15 12:34:08.000000000 +0100
@@ -288,8 +288,6 @@ static struct iwl_lib_ops iwl6000_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
@@ -357,8 +355,6 @@ static struct iwl_lib_ops iwl6030_lib =
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-03-15 12:32:58.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-03-15 12:33:39.000000000 +0100
@@ -222,8 +222,8 @@ void iwlagn_tx_queue_set_status(struct i
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-			  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+				 int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
 	u16 ra_tid;
@@ -288,8 +288,8 @@ int iwlagn_txq_agg_enable(struct iwl_pri
 	return 0;
 }
 
-int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-			   u16 ssn_idx, u8 tx_fifo)
+static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
@@ -1037,8 +1037,7 @@ int iwlagn_tx_agg_start(struct iwl_priv
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
-						  sta_id, tid, *ssn);
+	ret = iwlagn_txq_agg_enable(priv, txq_id, tx_fifo, sta_id, tid, *ssn);
 	if (ret)
 		return ret;
 
@@ -1125,8 +1124,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
-						   tx_fifo_id);
+	iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -1155,8 +1153,7 @@ int iwlagn_txq_check_empty(struct iwl_pr
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
-							     ssn, tx_fifo);
+			iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-03-15 12:32:43.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-03-15 12:33:42.000000000 +0100
@@ -133,10 +133,6 @@ void iwlagn_txq_update_byte_cnt_tbl(stru
 				    u16 byte_cnt);
 void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 				   struct iwl_tx_queue *txq);
-int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-			  int tx_fifo, int sta_id, int tid, u16 ssn_idx);
-int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-			   u16 ssn_idx, u8 tx_fifo);
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
--- a/drivers/net/wireless/iwlwifi/iwl-core.h	2011-03-15 12:32:32.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h	2011-03-15 12:32:39.000000000 +0100
@@ -171,11 +171,6 @@ struct iwl_lib_ops {
 			     struct iwl_tx_queue *txq);
 	int (*txq_init)(struct iwl_priv *priv,
 			struct iwl_tx_queue *txq);
-	/* aggregations */
-	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
-			      int sta_id, int tid, u16 ssn_idx);
-	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id, u16 ssn_idx,
-			       u8 tx_fifo);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* setup deferred work */


