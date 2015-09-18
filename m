Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21650 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbbIRNdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOkxX030872
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:17 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7er0-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:17 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 14/16] mwifiex: add usb tx data multi endpoints support
Date: Fri, 18 Sep 2015 06:32:16 -0700
Message-ID: <1442583138-2979-15-git-send-email-akarwar@marvell.com> (sfid-20150918_153324_774805_329C3372)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch add support for USB interface to TX data
with different endpoint. And previous TX information
are saved in new designed structure.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |   6 +-
 drivers/net/wireless/mwifiex/usb.c  | 124 ++++++++++++++++++++++++------------
 drivers/net/wireless/mwifiex/usb.h  |  13 ++--
 3 files changed, 97 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 278dc94..6c8f35f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -963,8 +963,10 @@ void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 		cardp = (struct usb_card_rec *)adapter->card;
 		p += sprintf(p, "tx_cmd_urb_pending = %d\n",
 			     atomic_read(&cardp->tx_cmd_urb_pending));
-		p += sprintf(p, "tx_data_urb_pending = %d\n",
-			     atomic_read(&cardp->tx_data_urb_pending));
+		p += sprintf(p, "tx_data_urb_pending_port_0 = %d\n",
+			     atomic_read(&cardp->port[0].tx_data_urb_pending));
+		p += sprintf(p, "tx_data_urb_pending_port_1 = %d\n",
+			     atomic_read(&cardp->port[1].tx_data_urb_pending));
 		p += sprintf(p, "rx_cmd_urb_pending = %d\n",
 			     atomic_read(&cardp->rx_cmd_urb_pending));
 		p += sprintf(p, "rx_data_urb_pending = %d\n",
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 5a70fe9..cc120d6 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -259,6 +259,8 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	struct urb_context *context = (struct urb_context *)(urb->context);
 	struct mwifiex_adapter *adapter = context->adapter;
 	struct usb_card_rec *card = adapter->card;
+	struct usb_tx_data_port *port;
+	int i;
 
 	mwifiex_dbg(adapter, INFO,
 		    "%s: status: %d\n", __func__, urb->status);
@@ -271,7 +273,13 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	} else {
 		mwifiex_dbg(adapter, DATA,
 			    "%s: DATA\n", __func__);
-		atomic_dec(&card->tx_data_urb_pending);
+		for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+			port = &card->port[i];
+			if (context->ep == port->tx_data_ep) {
+				atomic_dec(&port->tx_data_urb_pending);
+				break;
+			}
+		}
 		adapter->data_sent = false;
 		mwifiex_write_data_complete(adapter, context->skb, 0,
 					    urb->status ? -1 : 0);
@@ -323,7 +331,8 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 
 static void mwifiex_usb_free(struct usb_card_rec *card)
 {
-	int i;
+	struct usb_tx_data_port *port;
+	int i, j;
 
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
@@ -341,9 +350,12 @@ static void mwifiex_usb_free(struct usb_card_rec *card)
 		card->rx_data_list[i].urb = NULL;
 	}
 
-	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++) {
-		usb_free_urb(card->tx_data_list[i].urb);
-		card->tx_data_list[i].urb = NULL;
+	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+		port = &card->port[i];
+		for (j = 0; j < MWIFIEX_TX_DATA_URB; j++) {
+			usb_free_urb(port->tx_data_list[j].urb);
+			port->tx_data_list[j].urb = NULL;
+		}
 	}
 
 	usb_free_urb(card->tx_cmd.urb);
@@ -431,8 +443,18 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 			pr_debug("info: bulk OUT: max pkt size: %d, addr: %d\n",
 				 le16_to_cpu(epd->wMaxPacketSize),
 				 epd->bEndpointAddress);
-			card->tx_data_ep = usb_endpoint_num(epd);
-			atomic_set(&card->tx_data_urb_pending, 0);
+			card->port[0].tx_data_ep = usb_endpoint_num(epd);
+			atomic_set(&card->port[0].tx_data_urb_pending, 0);
+		}
+		if (usb_endpoint_dir_out(epd) &&
+		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_DATA_CH2 &&
+		    usb_endpoint_xfer_bulk(epd)) {
+			pr_debug("info: bulk OUT chan2:\t"
+				 "max pkt size: %d, addr: %d\n",
+				 le16_to_cpu(epd->wMaxPacketSize),
+				 epd->bEndpointAddress);
+			card->port[1].tx_data_ep = usb_endpoint_num(epd);
+			atomic_set(&card->port[1].tx_data_urb_pending, 0);
 		}
 		if (usb_endpoint_dir_out(epd) &&
 		    usb_endpoint_num(epd) == MWIFIEX_USB_EP_CMD_EVENT &&
@@ -474,7 +496,8 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_card_rec *card = usb_get_intfdata(intf);
 	struct mwifiex_adapter *adapter;
-	int i;
+	struct usb_tx_data_port *port;
+	int i, j;
 
 	if (!card || !card->adapter) {
 		pr_err("%s: card or card->adapter is NULL\n", __func__);
@@ -505,9 +528,13 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 			if (card->rx_data_list[i].urb)
 				usb_kill_urb(card->rx_data_list[i].urb);
 
-	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++)
-		if (card->tx_data_list[i].urb)
-			usb_kill_urb(card->tx_data_list[i].urb);
+	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+		port = &card->port[i];
+		for (j = 0; j < MWIFIEX_TX_DATA_URB; j++) {
+			if (port->tx_data_list[j].urb)
+				usb_kill_urb(port->tx_data_list[j].urb);
+		}
+	}
 
 	if (card->tx_cmd.urb)
 		usb_kill_urb(card->tx_cmd.urb);
@@ -619,7 +646,8 @@ static struct usb_driver mwifiex_usb_driver = {
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
 {
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
-	int i;
+	struct usb_tx_data_port *port;
+	int i, j;
 
 	card->tx_cmd.adapter = adapter;
 	card->tx_cmd.ep = card->tx_cmd_ep;
@@ -631,17 +659,21 @@ static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	card->tx_data_ix = 0;
-
-	for (i = 0; i < MWIFIEX_TX_DATA_URB; i++) {
-		card->tx_data_list[i].adapter = adapter;
-		card->tx_data_list[i].ep = card->tx_data_ep;
-
-		card->tx_data_list[i].urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!card->tx_data_list[i].urb) {
-			mwifiex_dbg(adapter, ERROR,
-				    "tx_data_list[] urb allocation failed\n");
-			return -ENOMEM;
+	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+		port = &card->port[i];
+		if (!port->tx_data_ep)
+			continue;
+		port->tx_data_ix = 0;
+		for (j = 0; j < MWIFIEX_TX_DATA_URB; j++) {
+			port->tx_data_list[j].adapter = adapter;
+			port->tx_data_list[j].ep = port->tx_data_ep;
+			port->tx_data_list[j].urb =
+					usb_alloc_urb(0, GFP_KERNEL);
+			if (!port->tx_data_list[j].urb) {
+				mwifiex_dbg(adapter, ERROR,
+					    "urb allocation failed\n");
+				return -ENOMEM;
+			}
 		}
 	}
 
@@ -736,9 +768,11 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 				    struct mwifiex_tx_param *tx_param)
 {
 	struct usb_card_rec *card = adapter->card;
-	struct urb_context *context;
+	struct urb_context *context = NULL;
+	struct usb_tx_data_port *port = NULL;
 	u8 *data = (u8 *)skb->data;
 	struct urb *tx_urb;
+	int idx;
 
 	if (adapter->is_suspended) {
 		mwifiex_dbg(adapter, ERROR,
@@ -751,20 +785,30 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		return -1;
 	}
 
-	if (ep == card->tx_data_ep &&
-	    atomic_read(&card->tx_data_urb_pending) >= MWIFIEX_TX_DATA_URB) {
-		adapter->data_sent = true;
-		return -EBUSY;
-	}
-
 	mwifiex_dbg(adapter, INFO, "%s: ep=%d\n", __func__, ep);
 
 	if (ep == card->tx_cmd_ep) {
 		context = &card->tx_cmd;
 	} else {
-		if (card->tx_data_ix >= MWIFIEX_TX_DATA_URB)
-			card->tx_data_ix = 0;
-		context = &card->tx_data_list[card->tx_data_ix++];
+		for (idx = 0; idx < MWIFIEX_TX_DATA_PORT; idx++) {
+			if (ep == card->port[idx].tx_data_ep) {
+				port = &card->port[idx];
+				if (atomic_read(&port->tx_data_urb_pending)
+				    >= MWIFIEX_TX_DATA_URB) {
+					adapter->data_sent = true;
+					return -EBUSY;
+				}
+				if (port->tx_data_ix >= MWIFIEX_TX_DATA_URB)
+					port->tx_data_ix = 0;
+				context =
+					&port->tx_data_list[port->tx_data_ix++];
+				break;
+			}
+		}
+		if (!port) {
+			mwifiex_dbg(adapter, ERROR, "Wrong usb tx data port\n");
+			return -1;
+		}
 	}
 
 	context->adapter = adapter;
@@ -781,7 +825,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	if (ep == card->tx_cmd_ep)
 		atomic_inc(&card->tx_cmd_urb_pending);
 	else
-		atomic_inc(&card->tx_data_urb_pending);
+		atomic_inc(&port->tx_data_urb_pending);
 
 	if (usb_submit_urb(tx_urb, GFP_ATOMIC)) {
 		mwifiex_dbg(adapter, ERROR,
@@ -789,18 +833,18 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		if (ep == card->tx_cmd_ep) {
 			atomic_dec(&card->tx_cmd_urb_pending);
 		} else {
-			atomic_dec(&card->tx_data_urb_pending);
+			atomic_dec(&port->tx_data_urb_pending);
 			adapter->data_sent = false;
-			if (card->tx_data_ix)
-				card->tx_data_ix--;
+			if (port->tx_data_ix)
+				port->tx_data_ix--;
 			else
-				card->tx_data_ix = MWIFIEX_TX_DATA_URB;
+				port->tx_data_ix = MWIFIEX_TX_DATA_URB;
 		}
 
 		return -1;
 	} else {
-		if (ep == card->tx_data_ep &&
-		    atomic_read(&card->tx_data_urb_pending) ==
+		if (ep != card->tx_cmd_ep &&
+		    atomic_read(&port->tx_data_urb_pending) ==
 							MWIFIEX_TX_DATA_URB) {
 			adapter->data_sent = true;
 			return -ENOSR;
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 6029a68..6339d87 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -38,6 +38,7 @@
 #define USB8XXX_FW_READY	2
 #define USB8XXX_FW_MAX_RETRY	3
 
+#define MWIFIEX_TX_DATA_PORT	2
 #define MWIFIEX_TX_DATA_URB	6
 #define MWIFIEX_RX_DATA_URB	6
 #define MWIFIEX_USB_TIMEOUT	100
@@ -61,6 +62,13 @@ struct urb_context {
 	u8 ep;
 };
 
+struct usb_tx_data_port {
+	u8 tx_data_ep;
+	atomic_t tx_data_urb_pending;
+	int tx_data_ix;
+	struct urb_context tx_data_list[MWIFIEX_TX_DATA_URB];
+};
+
 struct usb_card_rec {
 	struct mwifiex_adapter *adapter;
 	struct usb_device *udev;
@@ -72,14 +80,11 @@ struct usb_card_rec {
 	u8 usb_boot_state;
 	u8 rx_data_ep;
 	atomic_t rx_data_urb_pending;
-	u8 tx_data_ep;
 	u8 tx_cmd_ep;
-	atomic_t tx_data_urb_pending;
 	atomic_t tx_cmd_urb_pending;
 	int bulk_out_maxpktsize;
 	struct urb_context tx_cmd;
-	int tx_data_ix;
-	struct urb_context tx_data_list[MWIFIEX_TX_DATA_URB];
+	struct usb_tx_data_port port[MWIFIEX_TX_DATA_PORT];
 };
 
 struct fw_header {
-- 
1.8.1.4

