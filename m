Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3822 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198AbZJaUYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 16:24:18 -0400
Date: Sat, 31 Oct 2009 16:21:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: ath5k AP issues
Message-ID: <20091031202156.GA29825@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910291431.48388.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2009 at 02:31:46PM +0100, Michael Buesch wrote:
> Ok, to sum up some discussion from IRC:
> 
> The initial packets that fail are not pings, but ARPs. Which are broadcast
> frames.  The access point simply fails to notify the station via DTIM for the
> pending multicast frames, so it stays in PS. Unicast and the corresponding
> TIM bitmap works properly, which also explains why it works once we got a
> successful ARP (and it didn't expire, yet).

I don't think this fixes everything (I'm still seeing some mishandled
PS-poll frames) but this seemed to help pinging the PS client from the AP
side.

[Although we agreed beacon-sent-gated without a ready time component
is the right way to go on the queue configuration, it seems badly
broken in practice unless I'm missing some enable bit somewhere.  So
this is what ath9k does.]

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1c90d6b..6c167c2 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -541,7 +541,7 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Not used */
+	u32	tqi_ready_time; /* Time queue waits after an event */
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c6ab53..01b6fc3 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1488,7 +1488,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
-		return ret;
+		goto err;
+
 	if (sc->opmode == NL80211_IFTYPE_AP ||
 		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
@@ -1515,10 +1516,28 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
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
+	qi.tqi_aifs = 0;
+	qi.tqi_cw_min = 0;
+	qi.tqi_cw_max = 0;
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
index eeebb9a..31a4241 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -409,11 +409,11 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 		case AR5K_TX_QUEUE_CAB:
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
Bob Copeland %% www.bobcopeland.com

