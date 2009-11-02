Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1035 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZKBTqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 14:46:13 -0500
Date: Mon, 2 Nov 2009 14:43:49 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath5k AP issues
Message-ID: <20091102194349.GA7709@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de> <20091031202156.GA29825@hash.localnet> <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com> <20091101131652.GA30381@hash.localnet> <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 01, 2009 at 03:41:49PM +0200, Nick Kossifidis wrote:
> So beacon-sent gated option doesn't work ?
> Did you try also AR5K_DCU_MISC_ARBLOCK_IGNORE ?
> 
> Also according to docs Beacon frames should use queue 9 and CAB should
> use queue 8 (don't know why but docs say that these are the
> appropriate DCUs), beacon-gated triggering might only work if we use
> DCU 9 for beacons (now we are using queue 7 for beacons and queue 6
> for cab).

So the results of that testing aren't so good; I still couldn't get it
to work.  See the following patch if you want to play with it.  Eventually
TXDESC interrupt should fire and you would see:

cabq: enqueued xxxxx
cabq: processed xxxxx

But that only happens with DBA gating, with BCN_SENT_GT I never see
'processed.'  Anything else to try?

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1c90d6b..fb80b53 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -504,10 +504,10 @@ enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_DATA_MIN	= 0, /*IEEE80211_TX_QUEUE_DATA0*/
 	AR5K_TX_QUEUE_ID_DATA_MAX	= 4, /*IEEE80211_TX_QUEUE_DATA4*/
 	AR5K_TX_QUEUE_ID_DATA_SVP	= 5, /*IEEE80211_TX_QUEUE_SVP - Spectralink Voice Protocol*/
-	AR5K_TX_QUEUE_ID_CAB		= 6, /*IEEE80211_TX_QUEUE_AFTER_BEACON*/
-	AR5K_TX_QUEUE_ID_BEACON		= 7, /*IEEE80211_TX_QUEUE_BEACON*/
-	AR5K_TX_QUEUE_ID_UAPSD		= 8,
-	AR5K_TX_QUEUE_ID_XR_DATA	= 9,
+	AR5K_TX_QUEUE_ID_UAPSD		= 6,
+	AR5K_TX_QUEUE_ID_XR_DATA	= 7,
+	AR5K_TX_QUEUE_ID_CAB		= 8, /*IEEE80211_TX_QUEUE_AFTER_BEACON*/
+	AR5K_TX_QUEUE_ID_BEACON		= 9, /*IEEE80211_TX_QUEUE_BEACON*/
 };
 
 /*
@@ -541,7 +541,7 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Not used */
+	u32	tqi_ready_time; /* Time queue waits after an event */
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c6ab53..1287ded 100644
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
@@ -1939,6 +1958,10 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		}
 
 		skb = bf->skb;
+
+		if (txq == sc->cabq)
+			printk(KERN_DEBUG "cabq processed %p\n", skb);
+
 		info = IEEE80211_SKB_CB(skb);
 		bf->skb = NULL;
 
@@ -2146,6 +2169,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
 	skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
 	while (skb) {
+		printk(KERN_DEBUG "cabq enqueued %p\n", skb);
 		ath5k_tx_queue(sc->hw, skb, sc->cabq);
 		skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
 	}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index eeebb9a..592ee45 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -408,21 +408,29 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
+#if 1
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
+#else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
+				AR5K_QCU_MISC_CBREXP_DIS |
+				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
-			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
+			ath5k_hw_reg_write(ah, ((tq->tqi_ready_time -
 				(AR5K_TUNE_SW_BEACON_RESP -
 				AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
 				AR5K_QCU_RDYTIMECFG_ENABLE,
 				AR5K_QUEUE_RDYTIMECFG(queue));
+#endif
 
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
-				AR5K_DCU_MISC_ARBLOCK_CTL_S));
+				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
+				AR5K_DCU_MISC_ARBLOCK_IGNORE);
 			break;
 
 		case AR5K_TX_QUEUE_UAPSD:

-- 
Bob Copeland %% www.bobcopeland.com

