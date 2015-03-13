Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34849 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbbCMGij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:38:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2D6ZAV0006745
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:39 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t3pmg8hwn-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:39 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>
Subject: [PATCHv2 4/9] mwifiex: avoid queue_work while work is ongoing
Date: Fri, 13 Mar 2015 17:37:54 +0530
Message-ID: <1426248479-28451-5-git-send-email-patila@marvell.com> (sfid-20150313_073843_784492_624FFC9C)
In-Reply-To: <1426248479-28451-1-git-send-email-patila@marvell.com>
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Current code does not check whether main_work_queue or
rx_work_queue is running when preparing to do queue_work,
this code fix add check before calling queue_work, reducing
unnecessary queue_work switch.

This change instead sets more_task flag to ensure we run main_process
superloop once again.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Reviewed-by: Cathy Luo <cluo@marvell.com>
Reviewed-by: Amitkumar Karwar <akarwar@marvell.com>
Reviewed-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 38 +++++++++++++++++++++++++++++++------
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/pcie.c |  2 +-
 drivers/net/wireless/mwifiex/usb.c  |  4 ++--
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9c11eb8..d96d60a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -131,6 +131,34 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+void mwifiex_queue_main_work(struct mwifiex_adapter *adapter)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	if (adapter->mwifiex_processing) {
+		adapter->more_task_flag = true;
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+		queue_work(adapter->workqueue, &adapter->main_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mwifiex_queue_main_work);
+
+static void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	if (adapter->rx_processing) {
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+		queue_work(adapter->rx_workqueue, &adapter->rx_work);
+	}
+}
+
 static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 {
 	unsigned long flags;
@@ -154,7 +182,7 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 			if (adapter->if_ops.submit_rem_rx_urbs)
 				adapter->if_ops.submit_rem_rx_urbs(adapter);
 			adapter->delay_main_work = false;
-			queue_work(adapter->workqueue, &adapter->main_work);
+			mwifiex_queue_main_work(adapter);
 		}
 		mwifiex_handle_rx_packet(adapter, skb);
 	}
@@ -214,9 +242,7 @@ process_start:
 		if (atomic_read(&adapter->rx_pending) >= HIGH_RX_PENDING &&
 		    adapter->iface_type != MWIFIEX_USB) {
 			adapter->delay_main_work = true;
-			if (!adapter->rx_processing)
-				queue_work(adapter->rx_workqueue,
-					   &adapter->rx_work);
+			mwifiex_queue_rx_work(adapter);
 			break;
 		}
 
@@ -229,7 +255,7 @@ process_start:
 		}
 
 		if (adapter->rx_work_enabled && adapter->data_received)
-			queue_work(adapter->rx_workqueue, &adapter->rx_work);
+			mwifiex_queue_rx_work(adapter);
 
 		/* Need to wake up the card ? */
 		if ((adapter->ps_state == PS_STATE_SLEEP) &&
@@ -606,7 +632,7 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 	atomic_inc(&priv->adapter->tx_pending);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 
-	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
+	mwifiex_queue_main_work(priv->adapter);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d609d16..a319abe 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1424,6 +1424,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 
 void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
+void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index fc59c1d..b31c9a7 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2101,7 +2101,7 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 		goto exit;
 
 	mwifiex_interrupt_status(adapter);
-	queue_work(adapter->workqueue, &adapter->main_work);
+	mwifiex_queue_main_work(adapter);
 
 exit:
 	return IRQ_HANDLED;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 8beb38c..fd8027f 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -193,7 +193,7 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 		dev_dbg(adapter->dev, "info: recv_length=%d, status=%d\n",
 			recv_length, status);
 		if (status == -EINPROGRESS) {
-			queue_work(adapter->workqueue, &adapter->main_work);
+			mwifiex_queue_main_work(adapter);
 
 			/* urb for data_ep is re-submitted now;
 			 * urb for cmd_ep will be re-submitted in callback
@@ -262,7 +262,7 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 					    urb->status ? -1 : 0);
 	}
 
-	queue_work(adapter->workqueue, &adapter->main_work);
+	mwifiex_queue_main_work(adapter);
 
 	return;
 }
-- 
1.8.1.4

