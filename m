Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55819 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab3JKVbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:31:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 08/10] ath9k: remove sc->config.cabqReadyTime
Date: Fri, 11 Oct 2013 23:30:59 +0200
Message-Id: <1381527061-43758-8-git-send-email-nbd@openwrt.org> (sfid-20131011_233116_627718_82D8FA25)
In-Reply-To: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
References: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not exposed as a configuration option anyway

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 1 -
 drivers/net/wireless/ath/ath9k/init.c  | 1 -
 drivers/net/wireless/ath/ath9k/mac.h   | 2 --
 drivers/net/wireless/ath/ath9k/xmit.c  | 9 +--------
 4 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83c0455..d03b85e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -64,7 +64,6 @@ struct ath_node;
 
 struct ath_config {
 	u16 txpowlimit;
-	u8 cabqReadytime;
 };
 
 /*************************/
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9c145fa..7df728f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -471,7 +471,6 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 
-	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
 	sc->tx.uapsdq = ath_txq_setup(sc, ATH9K_TX_QUEUE_UAPSD, 0);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index bfccace..e3eed81 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -603,8 +603,6 @@ enum ath9k_tx_queue_flags {
 #define ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS 0x00000001
 
 #define ATH9K_DECOMP_MASK_SIZE     128
-#define ATH9K_READY_TIME_LO_BOUND  50
-#define ATH9K_READY_TIME_HI_BOUND  96
 
 enum ath9k_pkt_type {
 	ATH9K_PKT_TYPE_NORMAL = 0,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 08ba590..47696d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1704,16 +1704,9 @@ int ath_cabq_update(struct ath_softc *sc)
 	int qnum = sc->beacon.cabq->axq_qnum;
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
-	/*
-	 * Ensure the readytime % is within the bounds.
-	 */
-	if (sc->config.cabqReadytime < ATH9K_READY_TIME_LO_BOUND)
-		sc->config.cabqReadytime = ATH9K_READY_TIME_LO_BOUND;
-	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
-		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
 	qi.tqi_readyTime = (cur_conf->beacon_interval *
-			    sc->config.cabqReadytime) / 100;
+			    ATH_CABQ_READY_TIME) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
 	return 0;
-- 
1.8.0.2

