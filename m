Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751691AbdJaJqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 05:46:11 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/3] mwifiex: cleanup tx_ba_stream_tbl_lock usage
Date: Tue, 31 Oct 2017 15:12:46 +0530
Message-ID: <1509442967-14149-3-git-send-email-gbhat@marvell.com> (sfid-20171031_104618_026012_06FA1F07)
In-Reply-To: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

Fix the incorrect usage of tx_ba_stream_tbl_lock spinlock:

1. We shouldn't access the fields of the elements returned by
mwifiex_get_ba_status() and mwifiex_get_ba_tbl(), after we have
released the spin lock. To fix this, aquire the spinlock before
calling these functions and release the lock only after
processing the correspnding element is complete.

2. Move tx_ba_stream_tbl_lock out of mwifiex_del_ba_tbl(), to
avoid recursive spinlock. Acquire the spinlock explicitly, before
calling mwifiex_del_ba_tbl().

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c         | 45 +++++++++++++---------
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  3 --
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 8772e39..38d7b48 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -77,24 +77,19 @@ int mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 
 /*
  * This function returns the pointer to an entry in BA Stream
- * table which matches the requested BA status.
+ * table which matches the requested BA status. The caller
+ * must hold tx_ba_stream_tbl_lock before calling this function.
  */
 static struct mwifiex_tx_ba_stream_tbl *
 mwifiex_get_ba_status(struct mwifiex_private *priv,
 		      enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if (tx_ba_tsr_tbl->ba_status == ba_status) {
-			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
-					       flags);
+		if (tx_ba_tsr_tbl->ba_status == ba_status)
 			return tx_ba_tsr_tbl;
-		}
 	}
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	return NULL;
 }
 
@@ -114,9 +109,11 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
 	struct host_cmd_ds_11n_delba *del_ba = &resp->params.del_ba;
 	uint16_t del_ba_param_set = le16_to_cpu(del_ba->del_ba_param_set);
+	unsigned long flags;
 
 	tid = del_ba_param_set >> DELBA_TID_POS;
 	if (del_ba->del_result == BA_RESULT_SUCCESS) {
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		mwifiex_del_ba_tbl(priv, tid, del_ba->peer_mac_addr,
 				   TYPE_DELBA_SENT,
 				   INITIATOR_BIT(del_ba_param_set));
@@ -125,6 +122,7 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		if (tx_ba_tbl)
 			mwifiex_send_addba(priv, tx_ba_tbl->tid,
 					   tx_ba_tbl->ra);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	} else { /*
 		  * In case of failure, recreate the deleted stream in case
 		  * we initiated the ADDBA
@@ -135,11 +133,13 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		mwifiex_create_ba_tbl(priv, del_ba->peer_mac_addr, tid,
 				      BA_SETUP_INPROGRESS);
 
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		tx_ba_tbl = mwifiex_get_ba_status(priv, BA_SETUP_INPROGRESS);
 
 		if (tx_ba_tbl)
 			mwifiex_del_ba_tbl(priv, tx_ba_tbl->tid, tx_ba_tbl->ra,
 					   TYPE_DELBA_SENT, true);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
 
 	return 0;
@@ -160,6 +160,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp = &resp->params.add_ba_rsp;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
 	struct mwifiex_ra_list_tbl *ra_list;
+	unsigned long flags;
 	u16 block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
 	add_ba_rsp->ssn = cpu_to_le16((le16_to_cpu(add_ba_rsp->ssn))
@@ -176,14 +177,17 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			ra_list->ba_status = BA_SETUP_NONE;
 			ra_list->amsdu_in_ampdu = false;
 		}
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		mwifiex_del_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr,
 				   TYPE_DELBA_SENT, true);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
 			priv->aggr_prio_tbl[tid].ampdu_ap =
 				BA_STREAM_NOT_ALLOWED;
 		return 0;
 	}
 
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	tx_ba_tbl = mwifiex_get_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr);
 	if (tx_ba_tbl) {
 		mwifiex_dbg(priv->adapter, EVENT, "info: BA stream complete\n");
@@ -201,6 +205,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	} else {
 		mwifiex_dbg(priv->adapter, ERROR, "BA stream not created\n");
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	return 0;
 }
@@ -501,24 +506,20 @@ void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 
 /*
  * This function returns the pointer to an entry in BA Stream
- * table which matches the given RA/TID pair.
+ * table which matches the given RA/TID pair. The caller must
+ * hold tx_ba_stream_tbl_lock before calling this function.
  */
 struct mwifiex_tx_ba_stream_tbl *
 mwifiex_get_ba_tbl(struct mwifiex_private *priv, int tid, u8 *ra)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		if (ether_addr_equal_unaligned(tx_ba_tsr_tbl->ra, ra) &&
-		    tx_ba_tsr_tbl->tid == tid) {
-			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
-					       flags);
+		    tx_ba_tsr_tbl->tid == tid)
 			return tx_ba_tsr_tbl;
-		}
 	}
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
 	return NULL;
 }
 
@@ -534,11 +535,15 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 	unsigned long flags;
 	int tid_down;
 
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	if (!mwifiex_get_ba_tbl(priv, tid, ra)) {
 		new_node = kzalloc(sizeof(struct mwifiex_tx_ba_stream_tbl),
 				   GFP_ATOMIC);
-		if (!new_node)
+		if (!new_node) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
 			return;
+		}
 
 		tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
 		ra_list = mwifiex_wmm_get_ralist_node(priv, tid_down, ra);
@@ -552,10 +557,9 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 		new_node->ba_status = ba_status;
 		memcpy(new_node->ra, ra, ETH_ALEN);
 
-		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		list_add_tail(&new_node->list, &priv->tx_ba_stream_tbl_ptr);
-		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 }
 
 /*
@@ -680,11 +684,14 @@ void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 		(struct host_cmd_ds_11n_delba *) del_ba;
 	uint16_t del_ba_param_set = le16_to_cpu(cmd_del_ba->del_ba_param_set);
 	int tid;
+	unsigned long flags;
 
 	tid = del_ba_param_set >> DELBA_TID_POS;
 
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	mwifiex_del_ba_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
 			   TYPE_DELBA_RECEIVE, INITIATOR_BIT(del_ba_param_set));
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 0149c4a..4631bc2 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -682,7 +682,6 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 cleanup_rx_reorder_tbl;
-	unsigned long flags;
 	int tid_down;
 
 	if (type == TYPE_DELBA_RECEIVE)
@@ -716,9 +715,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			ra_list->amsdu_in_ampdu = false;
 			ra_list->ba_status = BA_SETUP_NONE;
 		}
-		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, ptx_tbl);
-		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
 }
 
-- 
1.9.1
