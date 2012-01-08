Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52791 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2AHMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 07:09:27 -0500
Received: by ggdk6 with SMTP id k6so1252815ggd.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 04:09:26 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Add NCI data exchange timer
Date: Sun,  8 Jan 2012 14:11:23 +0200
Message-Id: <1326024683-30313-1-git-send-email-ilane@ti.com> (sfid-20120108_130931_117888_4AF207D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add NCI data exchange timer to catch timeouts,
and call the data exchange callback with an error.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci_core.h |    3 +++
 net/nfc/nci/core.c         |   30 +++++++++++++++++++++++++++++-
 net/nfc/nci/data.c         |    4 ++++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index f4963ea..9154663 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -41,6 +41,7 @@ enum {
 	NCI_DISCOVERY,
 	NCI_POLL_ACTIVE,
 	NCI_DATA_EXCHANGE,
+	NCI_DATA_EXCHANGE_TO,
 };
 
 /* NCI timeouts */
@@ -49,6 +50,7 @@ enum {
 #define NCI_RF_DISC_TIMEOUT			5000
 #define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
+#define NCI_DATA_TIMEOUT			700
 
 struct nci_dev;
 
@@ -74,6 +76,7 @@ struct nci_dev {
 	atomic_t		credits_cnt;
 
 	struct timer_list	cmd_timer;
+	struct timer_list	data_timer;
 
 	struct workqueue_struct	*cmd_wq;
 	struct work_struct	cmd_work;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7650139..c30f36f 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -286,6 +286,7 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
 		del_timer_sync(&ndev->cmd_timer);
+		del_timer_sync(&ndev->data_timer);
 		mutex_unlock(&ndev->req_lock);
 		return 0;
 	}
@@ -331,6 +332,15 @@ static void nci_cmd_timer(unsigned long arg)
 	queue_work(ndev->cmd_wq, &ndev->cmd_work);
 }
 
+/* NCI data exchange timer function */
+static void nci_data_timer(unsigned long arg)
+{
+	struct nci_dev *ndev = (void *) arg;
+
+	set_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
+	queue_work(ndev->rx_wq, &ndev->rx_work);
+}
+
 static int nci_dev_up(struct nfc_dev *nfc_dev)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
@@ -454,8 +464,10 @@ static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
 		return -EINVAL;
 	}
 
-	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
+		pr_err("unable to exchange data, already in progress\n");
 		return -EBUSY;
+	}
 
 	/* store cb and context to be used on receiving data */
 	ndev->data_exchange_cb = cb;
@@ -473,6 +485,8 @@ static struct nfc_ops nci_nfc_ops = {
 	.dev_down = nci_dev_down,
 	.start_poll = nci_start_poll,
 	.stop_poll = nci_stop_poll,
+	.dep_link_up = NULL,
+	.dep_link_down = NULL,
 	.activate_target = nci_activate_target,
 	.deactivate_target = nci_deactivate_target,
 	.data_exchange = nci_data_exchange,
@@ -585,6 +599,8 @@ int nci_register_device(struct nci_dev *ndev)
 
 	setup_timer(&ndev->cmd_timer, nci_cmd_timer,
 			(unsigned long) ndev);
+	setup_timer(&ndev->data_timer, nci_data_timer,
+			(unsigned long) ndev);
 
 	mutex_init(&ndev->req_lock);
 
@@ -722,6 +738,9 @@ static void nci_tx_work(struct work_struct *work)
 			 nci_plen(skb->data));
 
 		nci_send_frame(skb);
+
+		mod_timer(&ndev->data_timer,
+			jiffies + msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	}
 }
 
@@ -753,6 +772,15 @@ static void nci_rx_work(struct work_struct *work)
 			break;
 		}
 	}
+
+	/* check if a data exchange timout has occurred */
+	if (test_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags)) {
+		/* complete the data exchange transaction, if exists */
+		if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+			nci_data_exchange_complete(ndev, NULL, -ETIMEDOUT);
+
+		clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
+	}
 }
 
 /* ----- NCI TX CMD worker thread ----- */
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index e5756b3..7880ae9 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -44,6 +44,10 @@ void nci_data_exchange_complete(struct nci_dev *ndev,
 
 	pr_debug("len %d, err %d\n", skb ? skb->len : 0, err);
 
+	/* data exchange is complete, stop the data timer */
+	del_timer_sync(&ndev->data_timer);
+	clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
+
 	if (cb) {
 		ndev->data_exchange_cb = NULL;
 		ndev->data_exchange_cb_context = 0;
-- 
1.7.0.4

