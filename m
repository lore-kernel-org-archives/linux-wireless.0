Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18762 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754665Ab0LGCIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:08:30 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0129327707
	for <linux-wireless@vger.kernel.org>; Tue,  7 Dec 2010 11:08:29 +0900 (JST)
Subject: [PATCH] ath5k: Use capabilities information for the number of TX
	queues
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 07 Dec 2010 11:08:12 +0900
Message-ID: <20101207020812.17506.40803.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One thing I missed in my WME series: Older hardware does not have enough
hardware queues to support WME. In this case we just set up one data queue. Use
the capability information to decide how many queues to set up.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--

resend, seems like it got lost somewhere in a queue ;)
---
 drivers/net/wireless/ath/ath5k/base.c |   65 ++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/qcu.c  |    4 +-
 2 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 380ff2f..3a09e72 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2799,33 +2799,46 @@ ath5k_init(struct ieee80211_hw *hw)
 		goto err_bhal;
 	}
 
-	/* This order matches mac80211's queue priority, so we can
-	 * directly use the mac80211 queue number without any mapping */
-	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VO);
-	if (IS_ERR(txq)) {
-		ATH5K_ERR(sc, "can't setup xmit queue\n");
-		ret = PTR_ERR(txq);
-		goto err_queues;
-	}
-	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VI);
-	if (IS_ERR(txq)) {
-		ATH5K_ERR(sc, "can't setup xmit queue\n");
-		ret = PTR_ERR(txq);
-		goto err_queues;
-	}
-	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
-	if (IS_ERR(txq)) {
-		ATH5K_ERR(sc, "can't setup xmit queue\n");
-		ret = PTR_ERR(txq);
-		goto err_queues;
-	}
-	txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
-	if (IS_ERR(txq)) {
-		ATH5K_ERR(sc, "can't setup xmit queue\n");
-		ret = PTR_ERR(txq);
-		goto err_queues;
+	/* 5211 and 5212 usually support 10 queues but we better rely on the
+	 * capability information */
+	if (ah->ah_capabilities.cap_queues.q_tx_num >= 6) {
+		/* This order matches mac80211's queue priority, so we can
+		* directly use the mac80211 queue number without any mapping */
+		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VO);
+		if (IS_ERR(txq)) {
+			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ret = PTR_ERR(txq);
+			goto err_queues;
+		}
+		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VI);
+		if (IS_ERR(txq)) {
+			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ret = PTR_ERR(txq);
+			goto err_queues;
+		}
+		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
+		if (IS_ERR(txq)) {
+			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ret = PTR_ERR(txq);
+			goto err_queues;
+		}
+		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
+		if (IS_ERR(txq)) {
+			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ret = PTR_ERR(txq);
+			goto err_queues;
+		}
+		hw->queues = 4;
+	} else {
+		/* older hardware (5210) can only support one data queue */
+		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
+		if (IS_ERR(txq)) {
+			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ret = PTR_ERR(txq);
+			goto err_queues;
+		}
+		hw->queues = 1;
 	}
-	hw->queues = 4;
 
 	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
 	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 1849eee..2c9c9e7 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -152,8 +152,8 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	/*
 	 * Get queue by type
 	 */
-	/*5210 only has 2 queues*/
-	if (ah->ah_version == AR5K_AR5210) {
+	/* 5210 only has 2 queues */
+	if (ah->ah_capabilities.cap_queues.q_tx_num == 2) {
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
 			queue = AR5K_TX_QUEUE_ID_NOQCU_DATA;

