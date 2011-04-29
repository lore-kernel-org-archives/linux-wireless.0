Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50886 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1D2O32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 10:29:28 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 07:29:01 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k_hw: remove aggregation protection mode
Date: Fri, 29 Apr 2011 19:59:21 +0530
Message-ID: <1304087361-9465-1-git-send-email-mshajakhan@atheros.com> (sfid-20110429_162932_106999_CAF53933)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

when aggregation protection mode is enabled the hardware needs
to send RTS/CTS for each HT frame, but its disabled hence remove
the unused callbacks

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   10 ----------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   11 -----------
 drivers/net/wireless/ath/ath9k/ath9k.h      |    1 -
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h         |    2 --
 drivers/net/wireless/ath/ath9k/main.c       |    3 ---
 drivers/net/wireless/ath/ath9k/xmit.c       |    5 +----
 7 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index c338efb..7a332f1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -415,15 +415,6 @@ static void ar9002_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
 	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
 
-static void ar9002_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
-					   u32 burstDuration)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_ctl2 &= ~AR_BurstDur;
-	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
-}
-
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
 {
@@ -456,6 +447,5 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->set11n_aggr_middle = ar9002_hw_set11n_aggr_middle;
 	ops->set11n_aggr_last = ar9002_hw_set11n_aggr_last;
 	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
-	ops->set11n_burstduration = ar9002_hw_set11n_burstduration;
 	ops->set_clrdmask = ar9002_hw_set_clrdmask;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index c1264d6..be6adec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -484,16 +484,6 @@ static void ar9003_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
 	ads->ctl12 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
 
-static void ar9003_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
-					   u32 burstDuration)
-{
-	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
-
-	ads->ctl13 &= ~AR_BurstDur;
-	ads->ctl13 |= SM(burstDuration, AR_BurstDur);
-
-}
-
 void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains)
 {
 	struct ar9003_txc *ads = ds;
@@ -518,7 +508,6 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->set11n_aggr_middle = ar9003_hw_set11n_aggr_middle;
 	ops->set11n_aggr_last = ar9003_hw_set11n_aggr_last;
 	ops->clr11n_aggr = ar9003_hw_clr11n_aggr;
-	ops->set11n_burstduration = ar9003_hw_set11n_burstduration;
 	ops->set_clrdmask = ar9003_hw_set_clrdmask;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0312aa0..1bffd15 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -62,7 +62,6 @@ struct ath_node;
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
 
 struct ath_config {
-	u32 ath_aggr_prot;
 	u16 txpowlimit;
 	u8 cabqReadytime;
 };
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 9dd90a8..99f8334 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -116,12 +116,6 @@ static inline void ath9k_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
 	ath9k_hw_ops(ah)->clr11n_aggr(ah, ds);
 }
 
-static inline void ath9k_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
-						 u32 burstDuration)
-{
-	ath9k_hw_ops(ah)->set11n_burstduration(ah, ds, burstDuration);
-}
-
 static inline void ath9k_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
 {
 	ath9k_hw_ops(ah)->set_clrdmask(ah, ds, val);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 34ed1bd..b2248bb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -628,8 +628,6 @@ struct ath_hw_ops {
 				   u32 numDelims);
 	void (*set11n_aggr_last)(struct ath_hw *ah, void *ds);
 	void (*clr11n_aggr)(struct ath_hw *ah, void *ds);
-	void (*set11n_burstduration)(struct ath_hw *ah, void *ds,
-				     u32 burstDuration);
 	void (*set_clrdmask)(struct ath_hw *ah, void *ds, bool val);
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c3dbf26..d3a3c89 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2039,9 +2039,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		ath9k_config_bss(sc, vif);
 
-		/* Set aggregation protection mode parameters */
-		sc->config.ath_aggr_prot = 0;
-
 		ath_dbg(common, ATH_DBG_CONFIG, "BSSID: %pM aid: 0x%x\n",
 			common->curbssid, common->curaid);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7b91b2a..744779d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1663,8 +1663,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 		rix = rates[i].idx;
 		series[i].Tries = rates[i].count;
 
-		if ((sc->config.ath_aggr_prot && bf_isaggr(bf)) ||
-		    (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS)) {
+		    if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 			flags |= ATH9K_TXDESC_RTSENA;
 		} else if (rates[i].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
@@ -1733,8 +1732,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 				     !is_pspoll, ctsrate,
 				     0, series, 4, flags);
 
-	if (sc->config.ath_aggr_prot && flags)
-		ath9k_hw_set11n_burstduration(sc->sc_ah, bf->bf_desc, 8192);
 }
 
 static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
-- 
1.7.0.4

