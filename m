Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59784 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0ENFsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 01:48:30 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 22:48:30 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19436.58440.277148.994193@gargle.gargle.HOWL>
Date: Fri, 14 May 2010 11:18:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath9k_htc: Initialize beacon/CAB queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch initializes the beacon and CAB HW queues
when the driver is loaded.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    4 +++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   14 ++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   28 ++++++++++++++++++------
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 2dd9ad3..47255c8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -392,6 +392,9 @@ struct ath9k_htc_priv {
 	int led_off_duration;
 	int led_on_cnt;
 	int led_off_cnt;
+
+	int beaconq;
+	int cabq;
 	int hwq_map[ATH9K_WME_AC_VO+1];
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
@@ -428,6 +431,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
 			 enum ath9k_tx_queue_subtype qtype);
+int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
 int get_hw_qnum(u16 queue, int *hwq_map);
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index dc01507..7ec2c2e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -420,6 +420,20 @@ static int ath9k_init_queues(struct ath9k_htc_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(priv->hwq_map); i++)
 		priv->hwq_map[i] = -1;
 
+	priv->beaconq = ath9k_hw_beaconq_setup(priv->ah);
+	if (priv->beaconq == -1) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup BEACON xmit queue\n");
+		goto err;
+	}
+
+	priv->cabq = ath9k_htc_cabq_setup(priv);
+	if (priv->cabq == -1) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to setup CAB xmit queue\n");
+		goto err;
+	}
+
 	if (!ath9k_htc_txq_setup(priv, ATH9K_WME_AC_BE)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for BE traffic\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2a0585d..15e716a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -20,6 +20,16 @@
 /* TX */
 /******/
 
+#define ATH9K_HTC_INIT_TXQ(subtype) do {			\
+		qi.tqi_subtype = subtype;			\
+		qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;		\
+		qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;		\
+		qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;		\
+		qi.tqi_physCompBuf = 0;				\
+		qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE |	\
+			TXQ_FLAG_TXDESCINT_ENABLE;		\
+	} while (0)
+
 int get_hw_qnum(u16 queue, int *hwq_map)
 {
 	switch (queue) {
@@ -297,13 +307,7 @@ bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
 	int qnum;
 
 	memset(&qi, 0, sizeof(qi));
-
-	qi.tqi_subtype = subtype;
-	qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;
-	qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
-	qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;
-	qi.tqi_physCompBuf = 0;
-	qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE | TXQ_FLAG_TXDESCINT_ENABLE;
+	ATH9K_HTC_INIT_TXQ(subtype);
 
 	qnum = ath9k_hw_setuptxqueue(priv->ah, ATH9K_TX_QUEUE_DATA, &qi);
 	if (qnum == -1)
@@ -321,6 +325,16 @@ bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
 	return true;
 }
 
+int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv)
+{
+	struct ath9k_tx_queue_info qi;
+
+	memset(&qi, 0, sizeof(qi));
+	ATH9K_HTC_INIT_TXQ(0);
+
+	return ath9k_hw_setuptxqueue(priv->ah, ATH9K_TX_QUEUE_CAB, &qi);
+}
+
 /******/
 /* RX */
 /******/
-- 
1.7.1

