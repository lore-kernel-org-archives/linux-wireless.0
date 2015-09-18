Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22861 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbIRNdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDORVm027010
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:19 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe8y-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:19 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 15/16] mwifiex: add usb multi endpoints resync support
Date: Fri, 18 Sep 2015 06:32:17 -0700
Message-ID: <1442583138-2979-16-git-send-email-akarwar@marvell.com> (sfid-20150918_153329_766961_6D3E90C8)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch add support for usb multi endpoints resync.
Once multi channel event is received from firmware,
update usb_mc_setp flag to block TX data until setup is over.
And available data endpoint will be attached to BSS interface.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c        | 54 +++++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/main.h        |  3 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 11 ++++++
 drivers/net/wireless/mwifiex/sta_event.c   |  5 +++
 drivers/net/wireless/mwifiex/usb.c         | 56 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/usb.h         |  2 ++
 6 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 6c8f35f..da88b4d 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -294,9 +294,15 @@ process_start:
 			/* We have tried to wakeup the card already */
 			if (adapter->pm_wakeup_fw_try)
 				break;
-			if (adapter->ps_state != PS_STATE_AWAKE ||
-			    adapter->tx_lock_flag)
+			if (adapter->ps_state != PS_STATE_AWAKE)
 				break;
+			if (adapter->tx_lock_flag) {
+				if (adapter->iface_type == MWIFIEX_USB) {
+					if (!adapter->usb_mc_setup)
+						break;
+				} else
+					break;
+			}
 
 			if ((!adapter->scan_chan_gap_enabled &&
 			     adapter->scan_processing) || adapter->data_sent ||
@@ -345,11 +351,18 @@ process_start:
 		 */
 		if ((adapter->ps_state == PS_STATE_SLEEP) ||
 		    (adapter->ps_state == PS_STATE_PRE_SLEEP) ||
-		    (adapter->ps_state == PS_STATE_SLEEP_CFM) ||
-		    adapter->tx_lock_flag){
+		    (adapter->ps_state == PS_STATE_SLEEP_CFM)) {
 			continue;
 		}
 
+		if (adapter->tx_lock_flag) {
+			if (adapter->iface_type == MWIFIEX_USB) {
+				if (!adapter->usb_mc_setup)
+					continue;
+			} else
+				continue;
+		}
+
 		if (!adapter->cmd_sent && !adapter->curr_cmd &&
 		    mwifiex_is_send_cmd_allowed
 		    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
@@ -359,6 +372,13 @@ process_start:
 			}
 		}
 
+		/** If USB Multi channel setup ongoing,
+		 *  wait for ready to tx data.
+		 */
+		if (adapter->iface_type == MWIFIEX_USB &&
+		    adapter->usb_mc_setup)
+			continue;
+
 		if ((adapter->scan_chan_gap_enabled ||
 		     !adapter->scan_processing) &&
 		    !adapter->data_sent &&
@@ -928,6 +948,32 @@ mwifiex_tx_timeout(struct net_device *dev)
 	}
 }
 
+void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = adapter->card;
+	struct mwifiex_private *priv;
+	u16 tx_buf_size;
+	int i, ret;
+
+	card->mc_resync_flag = true;
+	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+		if (atomic_read(&card->port[i].tx_data_urb_pending)) {
+			mwifiex_dbg(adapter, WARN, "pending data urb in sys\n");
+			return;
+		}
+	}
+
+	card->mc_resync_flag = false;
+	tx_buf_size = 0xffff;
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
+			       HostCmd_ACT_GEN_SET, 0, &tx_buf_size, false);
+	if (ret)
+		mwifiex_dbg(adapter, ERROR,
+			    "send reconfig tx buf size cmd err\n");
+}
+EXPORT_SYMBOL_GPL(mwifiex_multi_chan_resync);
+
 void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 {
 	void *p;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3e044b4..47ab094 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -817,6 +817,7 @@ struct mwifiex_if_ops {
 	void (*iface_work)(struct work_struct *work);
 	void (*submit_rem_rx_urbs)(struct mwifiex_adapter *adapter);
 	void (*deaggr_pkt)(struct mwifiex_adapter *, struct sk_buff *);
+	void (*multi_port_resync)(struct mwifiex_adapter *);
 };
 
 struct mwifiex_adapter {
@@ -992,6 +993,7 @@ struct mwifiex_adapter {
 	bool drcs_enabled;
 	u8 active_scan_triggered;
 	bool usb_mc_status;
+	bool usb_mc_setup;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
@@ -1567,6 +1569,7 @@ void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
 				    struct sk_buff *event);
 void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb);
+void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index a218c75..9ac7aa2 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1150,6 +1150,17 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_11n_addba_resp(priv, resp);
 		break;
 	case HostCmd_CMD_RECONFIGURE_TX_BUFF:
+		if (0xffff == (u16)le16_to_cpu(resp->params.tx_buf.buff_size)) {
+			if (adapter->iface_type == MWIFIEX_USB &&
+			    adapter->usb_mc_setup) {
+				if (adapter->if_ops.multi_port_resync)
+					adapter->if_ops.
+						multi_port_resync(adapter);
+				adapter->usb_mc_setup = false;
+				adapter->tx_lock_flag = false;
+			}
+			break;
+		}
 		adapter->tx_buf_size = (u16) le16_to_cpu(resp->params.
 							     tx_buf.buff_size);
 		adapter->tx_buf_size = (adapter->tx_buf_size
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 6792089..c333b24 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -381,6 +381,11 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 			       sizeof(struct mwifiex_ie_types_header));
 	}
 
+	if (adapter->iface_type == MWIFIEX_USB) {
+		adapter->tx_lock_flag = true;
+		adapter->usb_mc_setup = true;
+		mwifiex_multi_chan_resync(adapter);
+	}
 }
 
 void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index cc120d6..0772da6 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -285,6 +285,9 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 					    urb->status ? -1 : 0);
 	}
 
+	if (card->mc_resync_flag)
+		mwifiex_multi_chan_resync(adapter);
+
 	mwifiex_queue_main_work(adapter);
 
 	return;
@@ -664,6 +667,10 @@ static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
 		if (!port->tx_data_ep)
 			continue;
 		port->tx_data_ix = 0;
+		if (port->tx_data_ep == MWIFIEX_USB_EP_DATA)
+			port->block_status = false;
+		else
+			port->block_status = true;
 		for (j = 0; j < MWIFIEX_TX_DATA_URB; j++) {
 			port->tx_data_list[j].adapter = adapter;
 			port->tx_data_list[j].ep = port->tx_data_ep;
@@ -762,6 +769,53 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 	return ret;
 }
 
+static void mwifiex_usb_port_resync(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = adapter->card;
+	u8 active_port = MWIFIEX_USB_EP_DATA;
+	struct mwifiex_private *priv = NULL;
+	int i;
+
+	if (adapter->usb_mc_status) {
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (!priv)
+				continue;
+			if ((priv->bss_role == MWIFIEX_BSS_ROLE_UAP &&
+			     !priv->bss_started) ||
+			    (priv->bss_role == MWIFIEX_BSS_ROLE_STA &&
+			     !priv->media_connected))
+				priv->usb_port = MWIFIEX_USB_EP_DATA;
+		}
+		for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++)
+			card->port[i].block_status = false;
+	} else {
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (!priv)
+				continue;
+			if ((priv->bss_role == MWIFIEX_BSS_ROLE_UAP &&
+			     priv->bss_started) ||
+			    (priv->bss_role == MWIFIEX_BSS_ROLE_STA &&
+			     priv->media_connected)) {
+				active_port = priv->usb_port;
+				break;
+			}
+		}
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (priv)
+				priv->usb_port = active_port;
+		}
+		for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
+			if (active_port == card->port[i].tx_data_ep)
+				card->port[i].block_status = false;
+			else
+				card->port[i].block_status = true;
+		}
+	}
+}
+
 /* This function write a command/data packet to card. */
 static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 				    struct sk_buff *skb,
@@ -890,6 +944,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->usb_mc_status = false;
+	adapter->usb_mc_setup = false;
 
 	return 0;
 }
@@ -1120,6 +1175,7 @@ static struct mwifiex_if_ops usb_ops = {
 	.event_complete =	mwifiex_usb_cmd_event_complete,
 	.host_to_card =		mwifiex_usb_host_to_card,
 	.submit_rem_rx_urbs =	mwifiex_usb_submit_rem_rx_urbs,
+	.multi_port_resync =	mwifiex_usb_port_resync,
 };
 
 /* This function initializes the USB driver module.
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 6339d87..b4e9246 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -64,6 +64,7 @@ struct urb_context {
 
 struct usb_tx_data_port {
 	u8 tx_data_ep;
+	u8 block_status;
 	atomic_t tx_data_urb_pending;
 	int tx_data_ix;
 	struct urb_context tx_data_list[MWIFIEX_TX_DATA_URB];
@@ -84,6 +85,7 @@ struct usb_card_rec {
 	atomic_t tx_cmd_urb_pending;
 	int bulk_out_maxpktsize;
 	struct urb_context tx_cmd;
+	u8 mc_resync_flag;
 	struct usb_tx_data_port port[MWIFIEX_TX_DATA_PORT];
 };
 
-- 
1.8.1.4

