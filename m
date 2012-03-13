Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35811 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751814Ab2CMCfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 01/15] mwifiex: rename long function names to shorter ones
Date: Mon, 12 Mar 2012 19:35:08 -0700
Message-Id: <1331606116-32745-2-git-send-email-bzhao@marvell.com> (sfid-20120313_033537_102667_38AACFB8)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

This saves some space and adds better readability.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   60 ++++++++++++--------------
 drivers/net/wireless/mwifiex/11n.h           |    9 ++--
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    6 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    5 +-
 drivers/net/wireless/mwifiex/main.h          |    6 +-
 drivers/net/wireless/mwifiex/wmm.c           |   10 ++---
 6 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 34bba52..aeb456d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -69,8 +69,8 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
  * table which matches the requested BA status.
  */
 static struct mwifiex_tx_ba_stream_tbl *
-mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
-				  enum mwifiex_ba_status ba_status)
+mwifiex_get_ba_status(struct mwifiex_private *priv,
+		      enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
@@ -107,12 +107,11 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 
 	tid = del_ba_param_set >> DELBA_TID_POS;
 	if (del_ba->del_result == BA_RESULT_SUCCESS) {
-		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
-				del_ba->peer_mac_addr, TYPE_DELBA_SENT,
-				INITIATOR_BIT(del_ba_param_set));
+		mwifiex_del_ba_tbl(priv, tid, del_ba->peer_mac_addr,
+				   TYPE_DELBA_SENT,
+				   INITIATOR_BIT(del_ba_param_set));
 
-		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
-						BA_STREAM_SETUP_INPROGRESS);
+		tx_ba_tbl = mwifiex_get_ba_status(priv, BA_SETUP_INPROGRESS);
 		if (tx_ba_tbl)
 			mwifiex_send_addba(priv, tx_ba_tbl->tid,
 					   tx_ba_tbl->ra);
@@ -120,18 +119,17 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		  * In case of failure, recreate the deleted stream in case
 		  * we initiated the ADDBA
 		  */
-		if (INITIATOR_BIT(del_ba_param_set)) {
-			mwifiex_11n_create_tx_ba_stream_tbl(priv,
-					del_ba->peer_mac_addr, tid,
-					BA_STREAM_SETUP_INPROGRESS);
-
-			tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
-					BA_STREAM_SETUP_INPROGRESS);
-			if (tx_ba_tbl)
-				mwifiex_11n_delete_ba_stream_tbl(priv,
-						tx_ba_tbl->tid, tx_ba_tbl->ra,
-						TYPE_DELBA_SENT, true);
-		}
+		if (!INITIATOR_BIT(del_ba_param_set))
+			return 0;
+
+		mwifiex_create_ba_tbl(priv, del_ba->peer_mac_addr, tid,
+				      BA_SETUP_INPROGRESS);
+
+		tx_ba_tbl = mwifiex_get_ba_status(priv, BA_SETUP_INPROGRESS);
+
+		if (tx_ba_tbl)
+			mwifiex_del_ba_tbl(priv, tx_ba_tbl->tid, tx_ba_tbl->ra,
+					   TYPE_DELBA_SENT, true);
 	}
 
 	return 0;
@@ -160,18 +158,17 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 		& IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
 	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
-		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid,
+		tx_ba_tbl = mwifiex_get_ba_tbl(priv, tid,
 						add_ba_rsp->peer_mac_addr);
 		if (tx_ba_tbl) {
 			dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
-			tx_ba_tbl->ba_status = BA_STREAM_SETUP_COMPLETE;
+			tx_ba_tbl->ba_status = BA_SETUP_COMPLETE;
 		} else {
 			dev_err(priv->adapter->dev, "BA stream not created\n");
 		}
 	} else {
-		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
-						add_ba_rsp->peer_mac_addr,
-						TYPE_DELBA_SENT, true);
+		mwifiex_del_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr,
+				   TYPE_DELBA_SENT, true);
 		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
 			priv->aggr_prio_tbl[tid].ampdu_ap =
 				BA_STREAM_NOT_ALLOWED;
@@ -544,8 +541,7 @@ void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
  * table which matches the given RA/TID pair.
  */
 struct mwifiex_tx_ba_stream_tbl *
-mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
-				 int tid, u8 *ra)
+mwifiex_get_ba_tbl(struct mwifiex_private *priv, int tid, u8 *ra)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
@@ -567,14 +563,13 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
  * This function creates an entry in Tx BA stream table for the
  * given RA/TID pair.
  */
-void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
-					 u8 *ra, int tid,
-					 enum mwifiex_ba_status ba_status)
+void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
+			   enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *new_node;
 	unsigned long flags;
 
-	if (!mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ra)) {
+	if (!mwifiex_get_ba_tbl(priv, tid, ra)) {
 		new_node = kzalloc(sizeof(struct mwifiex_tx_ba_stream_tbl),
 				   GFP_ATOMIC);
 		if (!new_node) {
@@ -668,9 +663,8 @@ void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 
 	tid = del_ba_param_set >> DELBA_TID_POS;
 
-	mwifiex_11n_delete_ba_stream_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
-					 TYPE_DELBA_RECEIVE,
-					 INITIATOR_BIT(del_ba_param_set));
+	mwifiex_del_ba_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
+			   TYPE_DELBA_RECEIVE, INITIATOR_BIT(del_ba_param_set));
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 90b421e..139aa6e 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -46,13 +46,12 @@ void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 					     struct mwifiex_tx_ba_stream_tbl
 					     *tx_tbl);
 void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv);
-struct mwifiex_tx_ba_stream_tbl *mwifiex_11n_get_tx_ba_stream_tbl(struct
+struct mwifiex_tx_ba_stream_tbl *mwifiex_get_ba_tbl(struct
 							     mwifiex_private
 							     *priv, int tid,
 							     u8 *ra);
-void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv, u8 *ra,
-				       int tid,
-				       enum mwifiex_ba_status ba_status);
+void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
+			   enum mwifiex_ba_status ba_status);
 int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac);
 int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		       int initiator);
@@ -154,7 +153,7 @@ mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
 
-	tx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ptr->ra);
+	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
 	if (tx_tbl && IS_BASTREAM_SETUP(tx_tbl))
 		return true;
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 681d3f2..ad41fab 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -480,8 +480,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
  * The TID/TA are taken from del BA event body.
  */
 void
-mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
-				u8 *peer_mac, u8 type, int initiator)
+mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
+		   u8 type, int initiator)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
@@ -506,7 +506,7 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 		}
 		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, rx_reor_tbl_ptr);
 	} else {
-		ptx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, peer_mac);
+		ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
 			dev_dbg(priv->adapter->dev,
 					"event: TID, RA not found in table\n");
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 033c8ad..f1bffeb 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -41,9 +41,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
 			       u16 seqNum,
 			       u16 tid, u8 *ta,
 			       u8 pkttype, void *payload);
-void mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int Tid,
-				     u8 *PeerMACAddr, u8 type,
-				     int initiator);
+void mwifiex_del_ba_tbl(struct mwifiex_private *priv, int Tid,
+			u8 *PeerMACAddr, u8 type, int initiator);
 void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 				   struct host_cmd_ds_11n_batimeout *event);
 int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6dc1166..58748b1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -462,9 +462,9 @@ struct mwifiex_private {
 };
 
 enum mwifiex_ba_status {
-	BA_STREAM_NOT_SETUP = 0,
-	BA_STREAM_SETUP_INPROGRESS,
-	BA_STREAM_SETUP_COMPLETE
+	BA_SETUP_NONE = 0,
+	BA_SETUP_INPROGRESS,
+	BA_SETUP_COMPLETE
 };
 
 struct mwifiex_tx_ba_stream_tbl {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 75f79ef..5757ebd 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1218,15 +1218,13 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	} else {
 		if (mwifiex_is_ampdu_allowed(priv, tid)) {
 			if (mwifiex_space_avail_for_new_ba_stream(adapter)) {
-				mwifiex_11n_create_tx_ba_stream_tbl(priv,
-						ptr->ra, tid,
-						BA_STREAM_SETUP_INPROGRESS);
+				mwifiex_create_ba_tbl(priv, ptr->ra, tid,
+						      BA_SETUP_INPROGRESS);
 				mwifiex_send_addba(priv, tid, ptr->ra);
 			} else if (mwifiex_find_stream_to_delete
 				   (priv, tid, &tid_del, ra)) {
-				mwifiex_11n_create_tx_ba_stream_tbl(priv,
-						ptr->ra, tid,
-						BA_STREAM_SETUP_INPROGRESS);
+				mwifiex_create_ba_tbl(priv, ptr->ra, tid,
+						      BA_SETUP_INPROGRESS);
 				mwifiex_send_delba(priv, tid_del, ra, 1);
 			}
 		}
-- 
1.7.0.2

