Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14533 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaBHAat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 22/30] mwifiex: provision for holding and restoring packets during TDLS setup
Date: Fri, 7 Feb 2014 16:30:35 -0800
Message-ID: <1391819442-21239-3-git-send-email-bzhao@marvell.com> (sfid-20140208_020009_624072_96C46EA0)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While TDLS link is being setup, few packets from this station to
peer station may be buffered at AP. It may happen that once TDLS
link is setup, packets sent from station to peer on direct link
get delivered before traffic from AP arrives at peer station.
This results into packet reordering issue at peer station.

To avoid this, we hold data packets destined to TDLS peer during
TDLS setup. These packets are moved to temperory TDLS TX queue.
Upon successful TDLS setup, they are moved to RA list created for
this peer. Upon failure, packets are moved back to AP's RA list
for that particular TID.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |  1 +
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/tdls.c | 94 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c  |  4 ++
 4 files changed, 100 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index dead659..9dc8059 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -452,6 +452,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 		INIT_LIST_HEAD(&priv->sta_list);
+		skb_queue_head_init(&priv->tdls_txq);
 
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
 		spin_lock_init(&priv->rx_reorder_tbl_lock);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fe26ff3..138929e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -530,6 +530,7 @@ struct mwifiex_private {
 	u8 del_list_idx;
 	bool hs2_enabled;
 	struct station_parameters *sta_params;
+	struct sk_buff_head tdls_txq;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index f37862b..3198739 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -24,6 +24,96 @@
 #define TDLS_RESP_FIX_LEN     8
 #define TDLS_CONFIRM_FIX_LEN  6
 
+static void
+mwifiex_restore_tdls_packets(struct mwifiex_private *priv, u8 *mac, u8 status)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	struct list_head *tid_list;
+	struct sk_buff *skb, *tmp;
+	struct mwifiex_txinfo *tx_info;
+	unsigned long flags;
+	u32 tid;
+	u8 tid_down;
+
+	dev_dbg(priv->adapter->dev, "%s: %pM\n", __func__, mac);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp) {
+		if (!ether_addr_equal(mac, skb->data))
+			continue;
+
+		__skb_unlink(skb, &priv->tdls_txq);
+		tx_info = MWIFIEX_SKB_TXCB(skb);
+		tid = skb->priority;
+		tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
+
+		if (status == TDLS_SETUP_COMPLETE) {
+			ra_list = mwifiex_wmm_get_queue_raptr(priv, tid, mac);
+			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
+		} else {
+			tid_list = &priv->wmm.tid_tbl_ptr[tid_down].ra_list;
+			if (!list_empty(tid_list))
+				ra_list = list_first_entry(tid_list,
+					      struct mwifiex_ra_list_tbl, list);
+			else
+				ra_list = NULL;
+			tx_info->flags &= ~MWIFIEX_BUF_FLAG_TDLS_PKT;
+		}
+
+		if (!ra_list) {
+			mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+			continue;
+		}
+
+		skb_queue_tail(&ra_list->skb_head, skb);
+
+		ra_list->ba_pkt_count++;
+		ra_list->total_pkt_count++;
+
+		if (atomic_read(&priv->wmm.highest_queued_prio) <
+						       tos_to_tid_inv[tid_down])
+			atomic_set(&priv->wmm.highest_queued_prio,
+				   tos_to_tid_inv[tid_down]);
+
+		atomic_inc(&priv->wmm.tx_pkts_queued);
+	}
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+	return;
+}
+
+static void mwifiex_hold_tdls_packets(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	struct list_head *ra_list_head;
+	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+	int i;
+
+	dev_dbg(priv->adapter->dev, "%s: %pM\n", __func__, mac);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	for (i = 0; i < MAX_NUM_TID; i++) {
+		if (!list_empty(&priv->wmm.tid_tbl_ptr[i].ra_list)) {
+			ra_list_head = &priv->wmm.tid_tbl_ptr[i].ra_list;
+			list_for_each_entry(ra_list, ra_list_head, list) {
+				skb_queue_walk_safe(&ra_list->skb_head, skb,
+						    tmp) {
+					if (!ether_addr_equal(mac, skb->data))
+						continue;
+					__skb_unlink(skb, &ra_list->skb_head);
+					atomic_dec(&priv->wmm.tx_pkts_queued);
+					ra_list->total_pkt_count--;
+					skb_queue_tail(&priv->tdls_txq, skb);
+				}
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+	return;
+}
+
 /* This function appends rate TLV to scan config command. */
 static int
 mwifiex_tdls_append_rates_ie(struct mwifiex_private *priv,
@@ -584,6 +674,7 @@ mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
 		return -ENOMEM;
 
 	sta_ptr->tdls_status = TDLS_SETUP_INPROGRESS;
+	mwifiex_hold_tdls_packets(priv, peer);
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_CREATE_LINK;
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
@@ -612,6 +703,7 @@ mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
 		mwifiex_del_sta_entry(priv, peer);
 	}
 
+	mwifiex_restore_tdls_packets(priv, peer, TDLS_LINK_TEARDOWN);
 	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
 	tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
@@ -655,6 +747,7 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, u8 *peer)
 		}
 
 		memset(sta_ptr->rx_seq, 0xff, sizeof(sta_ptr->rx_seq));
+		mwifiex_restore_tdls_packets(priv, peer, TDLS_SETUP_COMPLETE);
 	} else {
 		dev_dbg(priv->adapter->dev,
 			"tdls: enable link %pM failed\n", peer);
@@ -667,6 +760,7 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, u8 *peer)
 					       flags);
 			mwifiex_del_sta_entry(priv, peer);
 		}
+		mwifiex_restore_tdls_packets(priv, peer, TDLS_LINK_TEARDOWN);
 
 		return -1;
 	}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 557d363..e9f7628 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -533,6 +533,7 @@ void
 mwifiex_clean_txrx(struct mwifiex_private *priv)
 {
 	unsigned long flags;
+	struct sk_buff *skb, *tmp;
 
 	mwifiex_11n_cleanup_reorder_tbl(priv);
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
@@ -549,6 +550,9 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	if (priv->adapter->if_ops.clean_pcie_ring)
 		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+
+	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp)
+		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
 }
 
 /*
-- 
1.8.2.3

