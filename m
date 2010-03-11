Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0CKXXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 18:23:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, mb@bu3sch.de, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: fix setup for CAB queue
Date: Thu, 11 Mar 2010 18:23:49 -0500
Message-Id: <1268349829-3195-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
References: <1268349829-3195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

The beacon sent gating doesn't seem to work with any combination
of flags.  Thus, buffered frames tend to stay buffered forever,
using up tx descriptors.

Instead, use the DBA gating and hold transmission of the buffered
frames until 80% of the beacon interval has elapsed using the ready
time.  This fixes the following error in AP mode:

   ath5k phy0: no further txbuf available, dropping packet

Add a comment to acknowledge that this isn't the best solution.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |   22 +++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/qcu.c   |    5 +++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6cd5efc..8c2e633 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -540,7 +540,7 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Not used */
+	u32	tqi_ready_time; /* Time queue waits after an event */
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8a82c75..118c5c0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1487,7 +1487,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
-		return ret;
+		goto err;
+
 	if (sc->opmode == NL80211_IFTYPE_AP ||
 		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
@@ -1514,10 +1515,25 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
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
index eeebb9a..b7c5725 100644
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

