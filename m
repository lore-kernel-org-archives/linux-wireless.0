Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52351 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbbBYLVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 06:21:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1PBIlTS006443
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:25 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1spfpbvyt2-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:24 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<szli@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/4] mwifiex: avoid queue_work while work is ongoing
Date: Wed, 25 Feb 2015 22:20:54 +0530
Message-ID: <1424883057-12102-2-git-send-email-patila@marvell.com> (sfid-20150225_122128_878623_AB6B2098)
In-Reply-To: <1424883057-12102-1-git-send-email-patila@marvell.com>
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

Current code does not check whether main_work_queue or
rx_work_queue is running when preparing to do queue_work,
this code fix add check before calling queue_work, reducing
unnecessary queue_work switch.

This change instead sets more_task flag to ensure we run main_process
superloop once again.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 38 +++++++++++++++++++++++++++++++------
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/pcie.c |  2 +-
 drivers/net/wireless/mwifiex/usb.c  |  4 ++--
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 74488ab..447eb6f 100644
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
index 16be45e..801a23b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1422,6 +1422,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 
 void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags);
+void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4b463c3..c0ff33e 100644
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
index 2238730..3adf1f6 100644
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

