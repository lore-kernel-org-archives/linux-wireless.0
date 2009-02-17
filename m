Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22021 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZBQKKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 05:10:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 02:10:22 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18842.35883.614389.684823@gargle.gargle.HOWL> (sfid-20090217_111028_008444_E1C86FA9)
Date: Tue, 17 Feb 2009 15:36:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/4] ath9k: Use beacon interval directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting up the CAB queue requires only the beacon interval,
remove the function ath_get_beaconconfig() which is redundant.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 84fd3ee..363bb2a 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -772,19 +772,6 @@ bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 /* Queue Management */
 /********************/
 
-static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
-				 struct ath_beacon_config *conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	/* fill in beacon config data */
-
-	conf->beacon_interval = hw->conf.beacon_int;
-	conf->listen_interval = 100;
-	conf->dtim_count = 1;
-	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
-}
-
 static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 					  struct ath_txq *txq)
 {
@@ -959,7 +946,6 @@ int ath_cabq_update(struct ath_softc *sc)
 {
 	struct ath9k_tx_queue_info qi;
 	int qnum = sc->beacon.cabq->axq_qnum;
-	struct ath_beacon_config conf;
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
 	/*
@@ -970,9 +956,8 @@ int ath_cabq_update(struct ath_softc *sc)
 	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
 		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
-	ath_get_beaconconfig(sc, ATH_IF_ID_ANY, &conf);
-	qi.tqi_readyTime =
-		(conf.beacon_interval * sc->config.cabqReadytime) / 100;
+	qi.tqi_readyTime = (sc->hw->conf.beacon_int *
+			    sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
 	return 0;
-- 
1.6.1

