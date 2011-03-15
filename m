Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab1COMwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 08:52:41 -0400
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1300189917.5596.10.camel@jlt3.sipsolutions.net>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
	 <1299831238.5082.185.camel@wwguy-huron>
	 <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
	 <1300063647.24333.7.camel@wwguy-ubuntu>
	 <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
	 <1300189917.5596.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 13:52:30 +0100
Message-ID: <1300193550.5596.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 12:51 +0100, Johannes Berg wrote:
> On Mon, 2011-03-14 at 11:16 -0700, Daniel Halperin wrote:
> 
> > BUT, it looks like when we set up aggregation, we set the scheduler to
> > ALWAYS use the default maximum of 64 frames for both these parameters
> > [2] when configuring the agg queue. This is probably why the scheduler
> > is willing to send long batches and have many outstanding frames.  I
> > bet that the fix is to make these parameters match the ones that come
> > down from mac80211.  If I get time later, I will see if I can fix
> > this.
> 
> Yeah, you're absolutely right, the window size and frame limit should
> both match the information about the aggregation session, and be limited
> to what we and the peer would like to see.
> 
> The bad thing is that we set up the queue when we get
> IEEE80211_AMPDU_TX_START, but we only know the window size when we get
> IEEE80211_AMPDU_TX_OPERATIONAL. However, I think we can change this
> since the first TX to the queue will only happen after _OPERATIONAL. We
> just need to refactor iwlagn_tx_agg_start() into the parts that can
> fail, and the parts that don't.

On top of the previous patch, does this work? Note that I haven't tested
it at all yet, sorry.

johannes

---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   47 +++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 
 4 files changed, 39 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-03-15 13:22:04.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-03-15 13:50:34.000000000 +0100
@@ -222,13 +222,8 @@ void iwlagn_tx_queue_set_status(struct i
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-				 int tx_fifo, int sta_id, int tid, u16 ssn_idx)
+static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id, int tid)
 {
-	unsigned long flags;
-	u16 ra_tid;
-	int ret;
-
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
 		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
@@ -240,12 +235,33 @@ static int iwlagn_txq_agg_enable(struct
 		return -EINVAL;
 	}
 
-	ra_tid = BUILD_RAxTID(sta_id, tid);
-
 	/* Modify device's station table to Tx this TID */
-	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-	if (ret)
-		return ret;
+	return iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
+}
+
+void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
+				struct ieee80211_sta *sta,
+				int tid, int frame_limit)
+{
+	int sta_id, tx_fifo, txq_id, ssn_idx;
+	u16 ra_tid;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+
+	sta_id = iwl_sta_id(sta);
+	if (WARN_ON(sta_id == IWL_INVALID_STATION))
+		return;
+	if (WARN_ON(tid >= MAX_TID_COUNT))
+		return;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
+	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
+	txq_id = tid_data->agg.txq_id;
+	tx_fifo = tid_data->agg.tx_fifo;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -271,10 +287,10 @@ static int iwlagn_txq_agg_enable(struct
 	iwl_write_targ_mem(priv, priv->scd_base_addr +
 			IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
-			((SCD_WIN_SIZE <<
+			((frame_limit <<
 			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
 			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((SCD_FRAME_LIMIT <<
+			((frame_limit <<
 			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
@@ -284,8 +300,6 @@ static int iwlagn_txq_agg_enable(struct
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
 }
 
 static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
@@ -1034,10 +1048,11 @@ int iwlagn_tx_agg_start(struct iwl_priv
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
+	tid_data->agg.tx_fifo = tx_fifo;
 	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	ret = iwlagn_txq_agg_enable(priv, txq_id, tx_fifo, sta_id, tid, *ssn);
+	ret = iwlagn_txq_agg_enable(priv, txq_id, sta_id, tid);
 	if (ret)
 		return ret;
 
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-15 13:21:53.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-15 13:47:49.000000000 +0100
@@ -3344,6 +3344,10 @@ int iwlagn_mac_ampdu_action(struct ieee8
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
+
+		iwlagn_txq_agg_queue_setup(priv, sta, tid, buf_size);
+
 		/*
 		 * If the limit is 0, then it wasn't initialised yet,
 		 * use the default. We can do that since we take the
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-03-15 13:50:03.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-03-15 13:50:24.000000000 +0100
@@ -202,6 +202,9 @@ int iwlagn_tx_agg_start(struct iwl_priv
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
+void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
+				struct ieee80211_sta *sta,
+				int tid, int frame_limit);
 int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h	2011-03-15 13:48:12.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h	2011-03-15 13:48:22.000000000 +0100
@@ -417,6 +417,7 @@ struct iwl_ht_agg {
 #define IWL_EMPTYING_HW_QUEUE_ADDBA 2
 #define IWL_EMPTYING_HW_QUEUE_DELBA 3
 	u8 state;
+	u8 tx_fifo;
 };
 
 


