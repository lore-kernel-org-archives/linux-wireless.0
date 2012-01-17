Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2AQKBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 05:01:30 -0500
Received: by yhnn56 with SMTP id n56so1573650yhn.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 02:01:30 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v2] NFC: Add NCI data exchange timer
Date: Tue, 17 Jan 2012 12:03:50 +0200
Message-Id: <1326794630-11151-1-git-send-email-ilane@ti.com> (sfid-20120117_110134_936485_F2E7A0AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add NCI data exchange timer to catch timeouts,
and call the data exchange callback with an error.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
v2: remove 2 unrelated changes (Thanks Samuel)

 include/net/nfc/nci_core.h |    3 +++
 net/nfc/nci/core.c         |   24 ++++++++++++++++++++++++
 net/nfc/nci/data.c         |    4 ++++
 3 files changed, 31 insertions(+), 0 deletions(-)

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
index 7650139..815d28a 100644
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
@@ -585,6 +595,8 @@ int nci_register_device(struct nci_dev *ndev)
 
 	setup_timer(&ndev->cmd_timer, nci_cmd_timer,
 			(unsigned long) ndev);
+	setup_timer(&ndev->data_timer, nci_data_timer,
+			(unsigned long) ndev);
 
 	mutex_init(&ndev->req_lock);
 
@@ -722,6 +734,9 @@ static void nci_tx_work(struct work_struct *work)
 			 nci_plen(skb->data));
 
 		nci_send_frame(skb);
+
+		mod_timer(&ndev->data_timer,
+			jiffies + msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	}
 }
 
@@ -753,6 +768,15 @@ static void nci_rx_work(struct work_struct *work)
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

