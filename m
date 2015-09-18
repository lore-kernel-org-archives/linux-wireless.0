Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22134 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbbIRNdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOkxY030872
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:22 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7er8-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:22 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 16/16] mwifiex: complete usb tx data with multi endpoints
Date: Fri, 18 Sep 2015 06:32:18 -0700
Message-ID: <1442583138-2979-17-git-send-email-akarwar@marvell.com> (sfid-20150918_153331_614290_556312EA)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch do the work to TX data with specific USB
endpoint. At the same time, update data_sent flag
according to multi port status. And is_port_ready
API is added for BSS interface to check if current
used usb data endpoint is available or not.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c  |  2 +-
 drivers/net/wireless/mwifiex/main.h      |  1 +
 drivers/net/wireless/mwifiex/sta_event.c |  4 ++-
 drivers/net/wireless/mwifiex/sta_tx.c    |  6 +++-
 drivers/net/wireless/mwifiex/txrx.c      |  4 +--
 drivers/net/wireless/mwifiex/uap_event.c |  4 ++-
 drivers/net/wireless/mwifiex/usb.c       | 47 ++++++++++++++++++++++++++++----
 drivers/net/wireless/mwifiex/wmm.c       | 38 +++++++++++++++++++++++---
 8 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 46221c2..2c5ffa1 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -259,7 +259,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	}
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
 						   skb_aggr, NULL);
 	} else {
 		if (skb_src)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 47ab094..05e1e63 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -818,6 +818,7 @@ struct mwifiex_if_ops {
 	void (*submit_rem_rx_urbs)(struct mwifiex_adapter *adapter);
 	void (*deaggr_pkt)(struct mwifiex_adapter *, struct sk_buff *);
 	void (*multi_port_resync)(struct mwifiex_adapter *);
+	bool (*is_port_ready)(struct mwifiex_private *);
 };
 
 struct mwifiex_adapter {
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index c333b24..ff3ee9d 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -616,7 +616,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
 			if (mwifiex_check_last_packet_indication(priv)) {
-				if (adapter->data_sent) {
+				if (adapter->data_sent ||
+				    (adapter->if_ops.is_port_ready &&
+				     !adapter->if_ops.is_port_ready(priv))) {
 					adapter->ps_state = PS_STATE_AWAKE;
 					adapter->pm_wakeup_card_req = false;
 					adapter->pm_wakeup_fw_try = false;
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 877ad06..f6683ea 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -153,6 +153,10 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	if (adapter->data_sent)
 		return -1;
 
+	if (adapter->if_ops.is_port_ready &&
+	    !adapter->if_ops.is_port_ready(priv))
+		return -1;
+
 	skb = dev_alloc_skb(data_len);
 	if (!skb)
 		return -1;
@@ -174,7 +178,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_type = priv->bss_type;
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
 						   skb, NULL);
 	} else {
 		skb_push(skb, INTF_HEADER_LEN);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 90f4915..bf6182b 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -116,7 +116,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 			local_tx_pd = (struct txpd *)(head_ptr + hroom);
 		if (adapter->iface_type == MWIFIEX_USB) {
 			ret = adapter->if_ops.host_to_card(adapter,
-							   MWIFIEX_USB_EP_DATA,
+							   priv->usb_port,
 							   skb, NULL);
 		} else {
 			ret = adapter->if_ops.host_to_card(adapter,
@@ -189,7 +189,7 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 
 	if (adapter->iface_type == MWIFIEX_USB) {
 		ret = adapter->if_ops.host_to_card(adapter,
-						   MWIFIEX_USB_EP_DATA,
+						   priv->usb_port,
 						   skb, NULL);
 	} else {
 		ret = adapter->if_ops.host_to_card(adapter,
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 46c972a..078834c 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -269,7 +269,9 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
 			if (mwifiex_check_last_packet_indication(priv)) {
-				if (adapter->data_sent) {
+				if (adapter->data_sent ||
+				    (adapter->if_ops.is_port_ready &&
+				     !adapter->if_ops.is_port_ready(priv))) {
 					adapter->ps_state = PS_STATE_AWAKE;
 					adapter->pm_wakeup_card_req = false;
 					adapter->pm_wakeup_fw_try = false;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 0772da6..e43aff9 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -277,6 +277,7 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 			port = &card->port[i];
 			if (context->ep == port->tx_data_ep) {
 				atomic_dec(&port->tx_data_urb_pending);
+				port->block_status = false;
 				break;
 			}
 		}
@@ -816,6 +817,31 @@ static void mwifiex_usb_port_resync(struct mwifiex_adapter *adapter)
 	}
 }
 
+static bool mwifiex_usb_is_port_ready(struct mwifiex_private *priv)
+{
+	struct usb_card_rec *card = priv->adapter->card;
+	int idx;
+
+	for (idx = 0; idx < MWIFIEX_TX_DATA_PORT; idx++) {
+		if (priv->usb_port == card->port[idx].tx_data_ep)
+			return !card->port[idx].block_status;
+	}
+
+	return false;
+}
+
+static inline u8 mwifiex_usb_data_sent(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = adapter->card;
+	int i;
+
+	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++)
+		if (!card->port[i].block_status)
+			return false;
+
+	return true;
+}
+
 /* This function write a command/data packet to card. */
 static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 				    struct sk_buff *skb,
@@ -826,7 +852,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	struct usb_tx_data_port *port = NULL;
 	u8 *data = (u8 *)skb->data;
 	struct urb *tx_urb;
-	int idx;
+	int idx, ret;
 
 	if (adapter->is_suspended) {
 		mwifiex_dbg(adapter, ERROR,
@@ -849,8 +875,9 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 				port = &card->port[idx];
 				if (atomic_read(&port->tx_data_urb_pending)
 				    >= MWIFIEX_TX_DATA_URB) {
-					adapter->data_sent = true;
-					return -EBUSY;
+					port->block_status = true;
+					ret = -EBUSY;
+					goto done;
 				}
 				if (port->tx_data_ix >= MWIFIEX_TX_DATA_URB)
 					port->tx_data_ix = 0;
@@ -888,7 +915,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 			atomic_dec(&card->tx_cmd_urb_pending);
 		} else {
 			atomic_dec(&port->tx_data_urb_pending);
-			adapter->data_sent = false;
+			port->block_status = false;
 			if (port->tx_data_ix)
 				port->tx_data_ix--;
 			else
@@ -900,12 +927,19 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		if (ep != card->tx_cmd_ep &&
 		    atomic_read(&port->tx_data_urb_pending) ==
 							MWIFIEX_TX_DATA_URB) {
-			adapter->data_sent = true;
-			return -ENOSR;
+			port->block_status = true;
+			ret = -ENOSR;
+			goto done;
 		}
 	}
 
 	return -EINPROGRESS;
+
+done:
+	if (ep != card->tx_cmd_ep)
+		adapter->data_sent = mwifiex_usb_data_sent(adapter);
+
+	return ret;
 }
 
 /* This function register usb device and initialize parameter. */
@@ -1176,6 +1210,7 @@ static struct mwifiex_if_ops usb_ops = {
 	.host_to_card =		mwifiex_usb_host_to_card,
 	.submit_rem_rx_urbs =	mwifiex_usb_submit_rem_rx_urbs,
 	.multi_port_resync =	mwifiex_usb_port_resync,
+	.is_port_ready =	mwifiex_usb_is_port_ready,
 };
 
 /* This function initializes the USB driver module.
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 4f303f3..7bbdfe4 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -452,7 +452,21 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 
 int mwifiex_bypass_txlist_empty(struct mwifiex_adapter *adapter)
 {
-	return atomic_read(&adapter->bypass_tx_pending) ? false : true;
+	struct mwifiex_private *priv;
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (!priv)
+			continue;
+		if (adapter->if_ops.is_port_ready &&
+		    !adapter->if_ops.is_port_ready(priv))
+			continue;
+		if (!skb_queue_empty(&priv->bypass_txq))
+			return false;
+	}
+
+	return true;
 }
 
 /*
@@ -466,9 +480,14 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		priv = adapter->priv[i];
-		if (priv && !priv->port_open)
+		if (!priv)
+			continue;
+		if (!priv->port_open)
+			continue;
+		if (adapter->if_ops.is_port_ready &&
+		    !adapter->if_ops.is_port_ready(priv))
 			continue;
-		if (priv && atomic_read(&priv->wmm.tx_pkts_queued))
+		if (atomic_read(&priv->wmm.tx_pkts_queued))
 			return false;
 	}
 
@@ -1091,6 +1110,10 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 			    (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0))
 				continue;
 
+			if (adapter->if_ops.is_port_ready &&
+			    !adapter->if_ops.is_port_ready(priv_tmp))
+				continue;
+
 			/* iterate over the WMM queues of the BSS */
 			hqp = &priv_tmp->wmm.highest_queued_prio;
 			for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
@@ -1326,7 +1349,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
+		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
 						   skb, NULL);
 	} else {
 		tx_param.next_pkt_len =
@@ -1467,6 +1490,13 @@ void mwifiex_process_bypass_tx(struct mwifiex_adapter *adapter)
 	for (i = 0; i < adapter->priv_num; ++i) {
 		priv = adapter->priv[i];
 
+		if (!priv)
+			continue;
+
+		if (adapter->if_ops.is_port_ready &&
+		    !adapter->if_ops.is_port_ready(priv))
+			continue;
+
 		if (skb_queue_empty(&priv->bypass_txq))
 			continue;
 
-- 
1.8.1.4

