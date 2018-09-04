Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53856 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeIDLEf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:35 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 19/26] staging: wilc1000: use short names to fix over 80 issue in tcp_process()
Date: Tue, 4 Sep 2018 12:09:35 +0530
Message-ID: <1536043182-19735-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084106_640052_76A13241)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use short variable names to avoid line over 80 chars checkpatch warning
in tcp_process().

struct pending_acks_info     --> struct pending_ack
int tcp_pending_ack_idx      --> int ack_idx
u32 pending_ack              --> u32 pending_ack_idx

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  6 ++---
 drivers/staging/wilc1000/wilc_wlan.c          | 34 +++++++++++++--------------
 drivers/staging/wilc1000/wilc_wlan.h          |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 09f619b..26b87c4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -115,7 +115,7 @@ struct ack_session_info {
 	u16 status;
 };
 
-struct pending_acks_info {
+struct pending_acks {
 	u32 ack_num;
 	u32 session_index;
 	struct txq_entry_t  *txqe;
@@ -123,10 +123,10 @@ struct pending_acks_info {
 
 struct tcp_ack_filter {
 	struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
-	struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
+	struct pending_acks pending_acks[MAX_PENDING_ACKS];
 	u32 pending_base;
 	u32 tcp_session;
-	u32 pending_acks;
+	u32 pending_acks_idx;
 	bool enabled;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 46db790..4c5a69e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -125,14 +125,14 @@ static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 				      struct txq_entry_t *txqe)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
-	u32 i = f->pending_base + f->pending_acks;
+	u32 i = f->pending_base + f->pending_acks_idx;
 
 	if (i < MAX_PENDING_ACKS) {
-		f->pending_acks_info[i].ack_num = ack;
-		f->pending_acks_info[i].txqe = txqe;
-		f->pending_acks_info[i].session_index = session_index;
-		txqe->tcp_pending_ack_idx = i;
-		f->pending_acks++;
+		f->pending_acks[i].ack_num = ack;
+		f->pending_acks[i].txqe = txqe;
+		f->pending_acks[i].session_index = session_index;
+		txqe->ack_idx = i;
+		f->pending_acks_idx++;
 	}
 	return 0;
 }
@@ -200,24 +200,24 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 	for (i = f->pending_base;
-	     i < (f->pending_base + f->pending_acks); i++) {
+	     i < (f->pending_base + f->pending_acks_idx); i++) {
 		u32 index;
 		u32 bigger_ack_num;
 
 		if (i >= MAX_PENDING_ACKS)
 			break;
 
-		index = f->pending_acks_info[i].session_index;
+		index = f->pending_acks[i].session_index;
 
 		if (index >= 2 * MAX_TCP_SESSION)
 			break;
 
 		bigger_ack_num = f->ack_session_info[index].bigger_ack_num;
 
-		if (f->pending_acks_info[i].ack_num < bigger_ack_num) {
+		if (f->pending_acks[i].ack_num < bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
-			tqe = f->pending_acks_info[i].txqe;
+			tqe = f->pending_acks[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(wilc, tqe);
 				tqe->status = 1;
@@ -229,7 +229,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			}
 		}
 	}
-	f->pending_acks = 0;
+	f->pending_acks_idx = 0;
 	f->tcp_session = 0;
 
 	if (f->pending_base == 0)
@@ -275,7 +275,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
-	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
+	tqe->ack_idx = NOT_TCP_ACK;
 
 	if (wilc_wlan_txq_add_to_head(vif, tqe)) {
 		kfree(tqe);
@@ -307,7 +307,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
 
-	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
+	tqe->ack_idx = NOT_TCP_ACK;
 	if (vif->ack_filter.enabled)
 		tcp_process(dev, tqe);
 	wilc_wlan_txq_add_to_tail(dev, tqe);
@@ -335,7 +335,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
-	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
+	tqe->ack_idx = NOT_TCP_ACK;
 	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return 1;
 }
@@ -668,9 +668,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		tqe->status = 1;
 		if (tqe->tx_complete_func)
 			tqe->tx_complete_func(tqe->priv, tqe->status);
-		if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
-		    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
-			vif->ack_filter.pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
+		if (tqe->ack_idx != NOT_TCP_ACK &&
+		    tqe->ack_idx < MAX_PENDING_ACKS)
+			vif->ack_filter.pending_acks[tqe->ack_idx].txqe = NULL;
 		kfree(tqe);
 	} while (--entries);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 0fdffdd..8c49c0c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -212,7 +212,7 @@
 struct txq_entry_t {
 	struct list_head list;
 	int type;
-	int tcp_pending_ack_idx;
+	int ack_idx;
 	u8 *buffer;
 	int buffer_size;
 	void *priv;
-- 
2.7.4
