Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55849 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0KWS4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:56:20 -0500
Received: by eye27 with SMTP id 27so4871674eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:56:19 -0800 (PST)
Date: Tue, 23 Nov 2010 20:55:17 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 08/30] ath5k: Use new function to stop beacon queue
Message-ID: <20101123185517.GH4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Since we only use ath5k_hw_stop_tx_dma to stop the beacon
 queue, introduce a new function ath5k_hw_stop_beacon_queue so
 that we can use that instead and have better control. In the future
 we can add more beacon queue specific stuff there (maybe tweak
 beacon timers or something), for now just call ath5k_hw_stop_tx_dma.

 * Also since we don't call ath5k_hw_stop_rx/tx_dma from outside
 dma.c, make them static.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    3 +--
 drivers/net/wireless/ath/ath5k/base.c  |    4 ++--
 drivers/net/wireless/ath/ath5k/dma.c   |   24 ++++++++++++++++++++++--
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index b36d3a5..66359dc 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1166,11 +1166,10 @@ void ath5k_hw_set_clockrate(struct ath5k_hw *ah);
 
 /* DMA Related Functions */
 void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
-int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
 u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah);
 int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
 int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue);
-int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
+int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue);
 u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue,
 				u32 phys_addr);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index eea5879..9af7e46 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1922,7 +1922,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 * This should never fail since we check above that no frames
 	 * are still pending on the queue.
 	 */
-	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
+	if (unlikely(ath5k_hw_stop_beacon_queue(ah, sc->bhalq))) {
 		ATH5K_WARN(sc, "beacon queue %u didn't start/stop ?\n", sc->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
@@ -2091,7 +2091,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		} else
 			ath5k_beacon_update_timers(sc, -1);
 	} else {
-		ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
+		ath5k_hw_stop_beacon_queue(sc->ah, sc->bhalq);
 	}
 
 	ath5k_hw_set_imr(ah, sc->imask);
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 3fe634f..82541fe 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -58,7 +58,7 @@ void ath5k_hw_start_rx_dma(struct ath5k_hw *ah)
  *
  * @ah:	The &struct ath5k_hw
  */
-int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
+static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 {
 	unsigned int i;
 
@@ -188,7 +188,7 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
  * -EINVAL if queue number is out of range or inactive.
  *
  */
-int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
+static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
 	unsigned int i = 40;
 	u32 tx_queue, pending;
@@ -321,6 +321,26 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 }
 
 /**
+ * ath5k_hw_stop_beacon_queue - Stop beacon queue
+ *
+ * @ah The &struct ath5k_hw
+ * @queue The queue number
+ *
+ * Returns -EIO if queue didn't stop
+ */
+int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
+{
+	int ret;
+	ret = ath5k_hw_stop_tx_dma(ah, queue);
+	if (ret) {
+		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+				"beacon queue didn't stop !\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
  * ath5k_hw_get_txdp - Get TX Descriptor's address for a specific queue
  *
  * @ah: The &struct ath5k_hw
