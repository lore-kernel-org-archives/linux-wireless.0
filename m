Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35143 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdGFOno (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:43:44 -0400
Received: by mail-pf0-f194.google.com with SMTP id q85so563811pfq.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:43:39 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 21/21] rsi: Rename mutex tx_rxlock to the tx_lock.
Date: Thu,  6 Jul 2017 20:07:24 +0530
Message-Id: <1499351844-2046-22-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164348_459899_D6E9ABC0)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We have now added separate lock for Rx. This lock is used to protect
tx path only

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 10 +++++-----
 drivers/net/wireless/rsi/rsi_91x_main.c |  2 +-
 drivers/net/wireless/rsi/rsi_main.h     |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 68f04a7..88a1a56 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -268,11 +268,11 @@ void rsi_core_qos_processor(struct rsi_common *common)
 			break;
 		}
 
-		mutex_lock(&common->tx_rxlock);
+		mutex_lock(&common->tx_lock);
 
 		status = adapter->check_hw_queue_status(adapter, q_num);
 		if ((status <= 0)) {
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->tx_lock);
 			break;
 		}
 
@@ -287,7 +287,7 @@ void rsi_core_qos_processor(struct rsi_common *common)
 		skb = rsi_core_dequeue_pkt(common, q_num);
 		if (skb == NULL) {
 			rsi_dbg(ERR_ZONE, "skb null\n");
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->tx_lock);
 			break;
 		}
 
@@ -297,14 +297,14 @@ void rsi_core_qos_processor(struct rsi_common *common)
 			status = rsi_send_data_pkt(common, skb);
 
 		if (status) {
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->tx_lock);
 			break;
 		}
 
 		common->tx_stats.total_tx_pkt_send[q_num]++;
 
 		tstamp_2 = jiffies;
-		mutex_unlock(&common->tx_rxlock);
+		mutex_unlock(&common->tx_lock);
 
 		if (time_after(tstamp_2, tstamp_1 + (300 * HZ) / 1000))
 			schedule();
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 939f568..bb0febb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -220,7 +220,7 @@ struct rsi_hw *rsi_91x_init(void)
 
 	rsi_init_event(&common->tx_thread.event);
 	mutex_init(&common->mutex);
-	mutex_init(&common->tx_rxlock);
+	mutex_init(&common->tx_lock);
 	mutex_init(&common->rx_lock);
 
 	if (rsi_create_kthread(common,
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 29bccb7..709f767 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -179,8 +179,8 @@ struct rsi_common {
 	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 1];
 	/* Mutex declaration */
 	struct mutex mutex;
-	/* Mutex used between tx/rx threads */
-	struct mutex tx_rxlock;
+	/* Mutex used for tx thread */
+	struct mutex tx_lock;
 	/* Mutex used for rx thread */
 	struct mutex rx_lock;
 	u8 endpoint;
-- 
2.7.4
