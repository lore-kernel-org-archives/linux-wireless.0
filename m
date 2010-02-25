Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0BYGMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/7] iwmc3200wifi: protect rx_tickets and rx_packets[] lists
Date: Thu, 25 Feb 2010 14:15:28 +0800
Message-Id: <1267078531-9817-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Protect rx_tickets and rx_packets[] lists with spinlocks to fix the
race condition for concurrent list operations. In iwmc3200wifi both
sdio_isr_worker and rx_worker workqueues can access the rx ticket
and packets lists at the same time under high rx load.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/debugfs.c |    4 ++++
 drivers/net/wireless/iwmc3200wifi/iwm.h     |    2 ++
 drivers/net/wireless/iwmc3200wifi/main.c    |    5 ++++-
 drivers/net/wireless/iwmc3200wifi/rx.c      |   24 ++++++++++++++++++++----
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 6ac5c8d..48930c1 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -280,6 +280,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 	if (!buf)
 		return -ENOMEM;
 
+	spin_lock(&iwm->ticket_lock);
 	list_for_each_entry(ticket, &iwm->rx_tickets, node) {
 		len += snprintf(buf + len, buf_len - len, "Ticket #%d\n",
 				ticket->ticket->id);
@@ -288,6 +289,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 		len += snprintf(buf + len, buf_len - len, "\tflags:  0x%x\n",
 				ticket->ticket->flags);
 	}
+	spin_unlock(&iwm->ticket_lock);
 
 	for (i = 0; i < IWM_RX_ID_HASH; i++) {
 		struct iwm_rx_packet *packet;
@@ -296,6 +298,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 		if (!list_empty(pkt_list)) {
 			len += snprintf(buf + len, buf_len - len,
 					"Packet hash #%d\n", i);
+			spin_lock(&iwm->packet_lock[i]);
 			list_for_each_entry(packet, pkt_list, node) {
 				len += snprintf(buf + len, buf_len - len,
 						"\tPacket id:     %d\n",
@@ -304,6 +307,7 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 						"\tPacket length: %lu\n",
 						packet->pkt_size);
 			}
+			spin_unlock(&iwm->packet_lock[i]);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 9ad5b3c..13266c3 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -269,7 +269,9 @@ struct iwm_priv {
 
 	struct sk_buff_head rx_list;
 	struct list_head rx_tickets;
+	spinlock_t ticket_lock;
 	struct list_head rx_packets[IWM_RX_ID_HASH];
+	spinlock_t packet_lock[IWM_RX_ID_HASH];
 	struct workqueue_struct *rx_wq;
 	struct work_struct rx_worker;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 9051960..3a3510a 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -276,8 +276,11 @@ int iwm_priv_init(struct iwm_priv *iwm)
 
 	skb_queue_head_init(&iwm->rx_list);
 	INIT_LIST_HEAD(&iwm->rx_tickets);
-	for (i = 0; i < IWM_RX_ID_HASH; i++)
+	spin_lock_init(&iwm->ticket_lock);
+	for (i = 0; i < IWM_RX_ID_HASH; i++) {
 		INIT_LIST_HEAD(&iwm->rx_packets[i]);
+		spin_lock_init(&iwm->packet_lock[i]);
+	}
 
 	INIT_WORK(&iwm->rx_worker, iwm_rx_worker);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 38d950b..c8a31be 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -344,10 +344,15 @@ static struct iwm_rx_packet *iwm_rx_packet_get(struct iwm_priv *iwm, u16 id)
 	u8 id_hash = IWM_RX_ID_GET_HASH(id);
 	struct iwm_rx_packet *packet;
 
+	spin_lock(&iwm->packet_lock[id_hash]);
 	list_for_each_entry(packet, &iwm->rx_packets[id_hash], node)
-		if (packet->id == id)
+		if (packet->id == id) {
+			list_del(&packet->node);
+			spin_unlock(&iwm->packet_lock[id_hash]);
 			return packet;
+		}
 
+	spin_unlock(&iwm->packet_lock[id_hash]);
 	return NULL;
 }
 
@@ -385,18 +390,22 @@ void iwm_rx_free(struct iwm_priv *iwm)
 	struct iwm_rx_packet *packet, *np;
 	int i;
 
+	spin_lock(&iwm->ticket_lock);
 	list_for_each_entry_safe(ticket, nt, &iwm->rx_tickets, node) {
 		list_del(&ticket->node);
 		iwm_rx_ticket_node_free(ticket);
 	}
+	spin_unlock(&iwm->ticket_lock);
 
 	for (i = 0; i < IWM_RX_ID_HASH; i++) {
+		spin_lock(&iwm->packet_lock[i]);
 		list_for_each_entry_safe(packet, np, &iwm->rx_packets[i],
 					 node) {
 			list_del(&packet->node);
 			kfree_skb(packet->skb);
 			kfree(packet);
 		}
+		spin_unlock(&iwm->packet_lock[i]);
 	}
 }
 
@@ -424,7 +433,9 @@ static int iwm_ntf_rx_ticket(struct iwm_priv *iwm, u8 *buf,
 				   ticket->action ==  IWM_RX_TICKET_RELEASE ?
 				   "RELEASE" : "DROP",
 				   ticket->id);
+			spin_lock(&iwm->ticket_lock);
 			list_add_tail(&ticket_node->node, &iwm->rx_tickets);
+			spin_unlock(&iwm->ticket_lock);
 
 			/*
 			 * We received an Rx ticket, most likely there's
@@ -457,6 +468,7 @@ static int iwm_ntf_rx_packet(struct iwm_priv *iwm, u8 *buf,
 	struct iwm_rx_packet *packet;
 	u16 id, buf_offset;
 	u32 packet_size;
+	u8 id_hash;
 
 	IWM_DBG_RX(iwm, DBG, "\n");
 
@@ -474,7 +486,10 @@ static int iwm_ntf_rx_packet(struct iwm_priv *iwm, u8 *buf,
 	if (IS_ERR(packet))
 		return PTR_ERR(packet);
 
-	list_add_tail(&packet->node, &iwm->rx_packets[IWM_RX_ID_GET_HASH(id)]);
+	id_hash = IWM_RX_ID_GET_HASH(id);
+	spin_lock(&iwm->packet_lock[id_hash]);
+	list_add_tail(&packet->node, &iwm->rx_packets[id_hash]);
+	spin_unlock(&iwm->packet_lock[id_hash]);
 
 	/* We might (unlikely) have received the packet _after_ the ticket */
 	queue_work(iwm->rx_wq, &iwm->rx_worker);
@@ -1664,6 +1679,7 @@ void iwm_rx_worker(struct work_struct *work)
 	 * We stop whenever a ticket is missing its packet, as we're
 	 * supposed to send the packets in order.
 	 */
+	spin_lock(&iwm->ticket_lock);
 	list_for_each_entry_safe(ticket, next, &iwm->rx_tickets, node) {
 		struct iwm_rx_packet *packet =
 			iwm_rx_packet_get(iwm, le16_to_cpu(ticket->ticket->id));
@@ -1672,12 +1688,12 @@ void iwm_rx_worker(struct work_struct *work)
 			IWM_DBG_RX(iwm, DBG, "Skip rx_work: Wait for ticket %d "
 				   "to be handled first\n",
 				   le16_to_cpu(ticket->ticket->id));
-			return;
+			break;
 		}
 
 		list_del(&ticket->node);
-		list_del(&packet->node);
 		iwm_rx_process_packet(iwm, packet, ticket);
 	}
+	spin_unlock(&iwm->ticket_lock);
 }
 
-- 
1.6.0.4

