Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12585 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeIDLE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 17/26] staging: wilc1000: move tcp_ack_filter algo related variables to 'wilc_vif' struct
Date: Tue, 4 Sep 2018 12:09:33 +0530
Message-ID: <1536043182-19735-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084104_379918_6AB1A627)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variables and move them as part of wilc_vif struct.
Move all the parameters related to tcp_ack_filter algo to wilc_vif
struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  27 ++++++
 drivers/staging/wilc1000/wilc_wlan.c              | 107 +++++++++-------------
 drivers/staging/wilc1000/wilc_wlan.h              |   2 +-
 5 files changed, 77 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3f2fc9..b5d5b8e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2072,9 +2072,9 @@ static void handle_get_statistics(struct work_struct *work)
 
 	if (stats->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
 	    stats->link_speed != DEFAULT_LINK_SPEED)
-		wilc_enable_tcp_ack_filter(true);
+		wilc_enable_tcp_ack_filter(vif, true);
 	else if (stats->link_speed != DEFAULT_LINK_SPEED)
-		wilc_enable_tcp_ack_filter(false);
+		wilc_enable_tcp_ack_filter(vif, false);
 
 	/* free 'msg' for async command, for sync caller will free it */
 	if (msg->is_sync)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3418d2d..35a83d4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1125,9 +1125,9 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		if (stats.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
 		    stats.link_speed != DEFAULT_LINK_SPEED)
-			wilc_enable_tcp_ack_filter(true);
+			wilc_enable_tcp_ack_filter(vif, true);
 		else if (stats.link_speed != DEFAULT_LINK_SPEED)
-			wilc_enable_tcp_ack_filter(false);
+			wilc_enable_tcp_ack_filter(vif, false);
 	}
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index f20a2e3..09f619b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -104,6 +104,32 @@ struct frame_reg {
 	bool reg;
 };
 
+#define MAX_TCP_SESSION                25
+#define MAX_PENDING_ACKS               256
+
+struct ack_session_info {
+	u32 seq_num;
+	u32 bigger_ack_num;
+	u16 src_port;
+	u16 dst_port;
+	u16 status;
+};
+
+struct pending_acks_info {
+	u32 ack_num;
+	u32 session_index;
+	struct txq_entry_t  *txqe;
+};
+
+struct tcp_ack_filter {
+	struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
+	struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
+	u32 pending_base;
+	u32 tcp_session;
+	u32 pending_acks;
+	bool enabled;
+};
+
 struct wilc_vif {
 	u8 idx;
 	u8 iftype;
@@ -122,6 +148,7 @@ struct wilc_vif {
 	bool obtaining_ip;
 	struct timer_list periodic_rssi;
 	struct rf_info periodic_stat;
+	struct tcp_ack_filter ack_filter;
 };
 
 struct wilc {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d397c27..52402c3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -93,63 +93,46 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 	return 0;
 }
 
-struct ack_session_info;
-struct ack_session_info {
-	u32 seq_num;
-	u32 bigger_ack_num;
-	u16 src_port;
-	u16 dst_port;
-	u16 status;
-};
-
-struct pending_acks_info {
-	u32 ack_num;
-	u32 session_index;
-	struct txq_entry_t  *txqe;
-};
-
 #define NOT_TCP_ACK			(-1)
 
-#define MAX_TCP_SESSION		25
-#define MAX_PENDING_ACKS		256
-static struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
-static struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
-
-static u32 pending_base;
-static u32 tcp_session;
-static u32 pending_acks;
-
-static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
+static inline int add_tcp_session(struct wilc_vif *vif, u32 src_prt,
+				  u32 dst_prt, u32 seq)
 {
-	if (tcp_session < 2 * MAX_TCP_SESSION) {
-		ack_session_info[tcp_session].seq_num = seq;
-		ack_session_info[tcp_session].bigger_ack_num = 0;
-		ack_session_info[tcp_session].src_port = src_prt;
-		ack_session_info[tcp_session].dst_port = dst_prt;
-		tcp_session++;
+	struct tcp_ack_filter *f = &vif->ack_filter;
+
+	if (f->tcp_session < 2 * MAX_TCP_SESSION) {
+		f->ack_session_info[f->tcp_session].seq_num = seq;
+		f->ack_session_info[f->tcp_session].bigger_ack_num = 0;
+		f->ack_session_info[f->tcp_session].src_port = src_prt;
+		f->ack_session_info[f->tcp_session].dst_port = dst_prt;
+		f->tcp_session++;
 	}
 	return 0;
 }
 
-static inline int update_tcp_session(u32 index, u32 ack)
+static inline int update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
 {
+	struct tcp_ack_filter *f = &vif->ack_filter;
+
 	if (index < 2 * MAX_TCP_SESSION &&
-	    ack > ack_session_info[index].bigger_ack_num)
-		ack_session_info[index].bigger_ack_num = ack;
+	    ack > f->ack_session_info[index].bigger_ack_num)
+		f->ack_session_info[index].bigger_ack_num = ack;
 	return 0;
 }
 
-static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
+static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
+				      u32 session_index,
 				      struct txq_entry_t *txqe)
 {
-	u32 i = pending_base + pending_acks;
+	struct tcp_ack_filter *f = &vif->ack_filter;
+	u32 i = f->pending_base + f->pending_acks;
 
 	if (i < MAX_PENDING_ACKS) {
-		pending_acks_info[i].ack_num = ack;
-		pending_acks_info[i].txqe = txqe;
-		pending_acks_info[i].session_index = session_index;
+		f->pending_acks_info[i].ack_num = ack;
+		f->pending_acks_info[i].txqe = txqe;
+		f->pending_acks_info[i].session_index = session_index;
 		txqe->tcp_pending_ack_idx = i;
-		pending_acks++;
+		f->pending_acks++;
 	}
 	return 0;
 }
@@ -162,6 +145,7 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
+	struct tcp_ack_filter *f = &vif->ack_filter;
 	const struct iphdr *ip_hdr_ptr;
 	const struct tcphdr *tcp_hdr_ptr;
 	u32 ihl, total_length, data_offset;
@@ -186,19 +170,19 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 		seq_no = ntohl(tcp_hdr_ptr->seq);
 		ack_no = ntohl(tcp_hdr_ptr->ack_seq);
-		for (i = 0; i < tcp_session; i++) {
-			u32 j = ack_session_info[i].seq_num;
+		for (i = 0; i < f->tcp_session; i++) {
+			u32 j = f->ack_session_info[i].seq_num;
 
 			if (i < 2 * MAX_TCP_SESSION &&
 			    j == seq_no) {
-				update_tcp_session(i, ack_no);
+				update_tcp_session(vif, i, ack_no);
 				break;
 			}
 		}
-		if (i == tcp_session)
-			add_tcp_session(0, 0, seq_no);
+		if (i == f->tcp_session)
+			add_tcp_session(vif, 0, 0, seq_no);
 
-		add_tcp_pending_ack(ack_no, i, tqe);
+		add_tcp_pending_ack(vif, ack_no, i, tqe);
 	}
 
 out:
@@ -209,29 +193,30 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
+	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = 0;
 	u32 dropped = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-	for (i = pending_base; i < (pending_base + pending_acks); i++) {
+	for (i = f->pending_base; i < (f->pending_base + f->pending_acks); i++) {
 		u32 session_index;
 		u32 bigger_ack_num;
 
 		if (i >= MAX_PENDING_ACKS)
 			break;
 
-		session_index = pending_acks_info[i].session_index;
+		session_index = f->pending_acks_info[i].session_index;
 
 		if (session_index >= 2 * MAX_TCP_SESSION)
 			break;
 
-		bigger_ack_num = ack_session_info[session_index].bigger_ack_num;
+		bigger_ack_num = f->ack_session_info[session_index].bigger_ack_num;
 
-		if (pending_acks_info[i].ack_num < bigger_ack_num) {
+		if (f->pending_acks_info[i].ack_num < bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
-			tqe = pending_acks_info[i].txqe;
+			tqe = f->pending_acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(wilc, tqe);
 				tqe->status = 1;
@@ -243,13 +228,13 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			}
 		}
 	}
-	pending_acks = 0;
-	tcp_session = 0;
+	f->pending_acks = 0;
+	f->tcp_session = 0;
 
-	if (pending_base == 0)
-		pending_base = MAX_TCP_SESSION;
+	if (f->pending_base == 0)
+		f->pending_base = MAX_TCP_SESSION;
 	else
-		pending_base = 0;
+		f->pending_base = 0;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
@@ -262,11 +247,9 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	return 1;
 }
 
-static bool enabled;
-
-void wilc_enable_tcp_ack_filter(bool value)
+void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
 {
-	enabled = value;
+	vif->ack_filter.enabled = value;
 }
 
 static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
@@ -324,7 +307,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->priv = priv;
 
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-	if (enabled)
+	if (vif->ack_filter.enabled)
 		tcp_process(dev, tqe);
 	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return wilc->txq_entries;
@@ -686,7 +669,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			tqe->tx_complete_func(tqe->priv, tqe->status);
 		if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
 		    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
-			pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
+			vif->ack_filter.pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
 		kfree(tqe);
 	} while (--entries);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 1f874d1..0fdffdd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -282,7 +282,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
 void wilc_chip_sleep_manually(struct wilc *wilc);
 
-void wilc_enable_tcp_ack_filter(bool value);
+void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value);
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
 netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
-- 
2.7.4
