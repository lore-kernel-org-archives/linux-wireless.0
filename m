Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3477 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0AUEwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 23:52:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: fix setup for CAB queue
Date: Wed, 20 Jan 2010 23:51:04 -0500
Message-Id: <1264049464-12292-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
References: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon sent gating doesn't seem to work with any combination
of flags.  Thus, buffered frames tend to stay buffered forever,
using up tx descriptors.

Instead, use the DBA gating and hold transmission of the buffered
frames until 80% of the beacon interval has elapsed using the ready
time.  This fixes the following error in AP mode:

   ath5k phy0: no further txbuf available, dropping packet

Add a comment to acknowledge that this isn't the best solution.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |   22 +++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/qcu.c   |    5 +++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 66bcb50..ad4d446 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -535,7 +535,7 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Not used */
+	u32	tqi_ready_time; /* Time queue waits after an event */
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b501537..535a6af 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1516,7 +1516,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
-		return ret;
+		goto err;
+
 	if (sc->opmode == NL80211_IFTYPE_AP ||
 		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
@@ -1543,10 +1544,25 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 	if (ret) {
 		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
 			"hardware queue!\n", __func__);
-		return ret;
+		goto err;
 	}
+	ret = ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */
+	if (ret)
+		goto err;
 
-	return ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */;
+	/* reconfigure cabq with ready time to 80% of beacon_interval */
+	ret = ath5k_hw_get_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
+	if (ret)
+		goto err;
+
+	qi.tqi_ready_time = (sc->bintval * 80) / 100;
+	ret = ath5k_hw_set_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
+	if (ret)
+		goto err;
+
+	ret = ath5k_hw_reset_tx_queue(ah, AR5K_TX_QUEUE_ID_CAB);
+err:
+	return ret;
 }
 
 static void
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index abe36c0..9122a85 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -408,12 +408,13 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
+			/* XXX: use BCN_SENT_GT, if we can figure out how */
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
-			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
+			ath5k_hw_reg_write(ah, ((tq->tqi_ready_time -
 				(AR5K_TUNE_SW_BEACON_RESP -
 				AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
-- 
1.6.3.3


