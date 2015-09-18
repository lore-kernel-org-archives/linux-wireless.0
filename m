Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43631 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbbIRNdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOkxV030872
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:12 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eqp-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:12 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 12/16] mwifiex: move usb specific data_sent update to usb.c
Date: Fri, 18 Sep 2015 06:32:14 -0700
Message-ID: <1442583138-2979-13-git-send-email-akarwar@marvell.com> (sfid-20150918_153326_882770_785EC02F)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch move data_sent flag update to usb.c file.
>From now all data_sent update cases only happened in specific file:
sdio.c, usb.c, pcie.c. Outside ot these files, it is only allowed
to check the value of data_ent.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |  5 -----
 drivers/net/wireless/mwifiex/sta_tx.c   |  5 -----
 drivers/net/wireless/mwifiex/txrx.c     | 13 -------------
 drivers/net/wireless/mwifiex/usb.c      |  7 ++++++-
 drivers/net/wireless/mwifiex/wmm.c      |  5 -----
 5 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index ce22cc8..46221c2 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -259,7 +259,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	}
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		adapter->data_sent = true;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
 						   skb_aggr, NULL);
 	} else {
@@ -300,16 +299,12 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR, "%s: host_to_card failed: %#x\n",
 			    __func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		return 0;
 	case -EINPROGRESS:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 7a4d5f4..877ad06 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -174,7 +174,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_type = priv->bss_type;
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		adapter->data_sent = true;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
 						   skb, NULL);
 	} else {
@@ -192,8 +191,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case -1:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		dev_kfree_skb_any(skb);
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: host_to_card failed: ret=%d\n",
@@ -208,8 +205,6 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		adapter->tx_lock_flag = true;
 		break;
 	default:
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 6ef030a..90f4915 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -115,7 +115,6 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			local_tx_pd = (struct txpd *)(head_ptr + hroom);
 		if (adapter->iface_type == MWIFIEX_USB) {
-			adapter->data_sent = true;
 			ret = adapter->if_ops.host_to_card(adapter,
 							   MWIFIEX_USB_EP_DATA,
 							   skb, NULL);
@@ -142,8 +141,6 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR,
 			    "mwifiex_write_data_async failed: 0x%X\n",
 			    ret);
@@ -151,8 +148,6 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
@@ -193,7 +188,6 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 	}
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		adapter->data_sent = true;
 		ret = adapter->if_ops.host_to_card(adapter,
 						   MWIFIEX_USB_EP_DATA,
 						   skb, NULL);
@@ -222,16 +216,12 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR,
 			    "mwifiex_write_data_async failed: 0x%X\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
@@ -306,9 +296,6 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	if (!priv)
 		goto done;
 
-	if (adapter->iface_type == MWIFIEX_USB)
-		adapter->data_sent = false;
-
 	mwifiex_set_trans_start(priv->netdev);
 	if (!status) {
 		priv->stats.tx_packets++;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index bc8619d..3f1713e 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -272,6 +272,7 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 		mwifiex_dbg(adapter, DATA,
 			    "%s: DATA\n", __func__);
 		atomic_dec(&card->tx_data_urb_pending);
+		adapter->data_sent = false;
 		mwifiex_write_data_complete(adapter, context->skb, 0,
 					    urb->status ? -1 : 0);
 	}
@@ -752,6 +753,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 
 	if (ep == card->tx_data_ep &&
 	    atomic_read(&card->tx_data_urb_pending) >= MWIFIEX_TX_DATA_URB) {
+		adapter->data_sent = true;
 		return -EBUSY;
 	}
 
@@ -788,6 +790,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 			atomic_dec(&card->tx_cmd_urb_pending);
 		} else {
 			atomic_dec(&card->tx_data_urb_pending);
+			adapter->data_sent = false;
 			if (card->tx_data_ix)
 				card->tx_data_ix--;
 			else
@@ -798,8 +801,10 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	} else {
 		if (ep == card->tx_data_ep &&
 		    atomic_read(&card->tx_data_urb_pending) ==
-							MWIFIEX_TX_DATA_URB)
+							MWIFIEX_TX_DATA_URB) {
+			adapter->data_sent = true;
 			return -ENOSR;
+		}
 	}
 
 	return -EINPROGRESS;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8a3f59e..4f303f3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1326,7 +1326,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 	if (adapter->iface_type == MWIFIEX_USB) {
-		adapter->data_sent = true;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
 						   skb, NULL);
 	} else {
@@ -1356,15 +1355,11 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 				       ra_list_flags);
 		break;
 	case -1:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type == MWIFIEX_USB)
-			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
-- 
1.8.1.4

