Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37977 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1BHAKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 19:10:44 -0500
Received: by ywo7 with SMTP id 7so1713433ywo.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 16:10:44 -0800 (PST)
Subject: [PATCH] ath9k: Remove redundant beacon_interval
From: Steve Brown <sbrown@cortland.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Mohammed Shafi <shafi.ath9k@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 17:10:39 -0700
Message-ID: <1297123839.16189.36.camel@nm.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable appears in both ath_softc and ath_beacon_config.
The struct ath_beacon_config is embedded in ath_softc. The redundant
variable was added by commit id 57c4d7b4c4986037be51476b8e3025d5ba18d8b8.

Signed-off-by: Steve Brown <sbrown@cortland.com>
Reviewed-by: Mohammed Shafi <shafi.ath9k@gmail.com>

---

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9272278..dbf0aa5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -371,7 +371,7 @@ struct ath_vif {
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 struct ath_beacon_config {
-	u16 beacon_interval;
+	int beacon_interval;
 	u16 listen_interval;
 	u16 dtim_period;
 	u16 bmiss_timeout;
@@ -633,8 +633,6 @@ struct ath_softc {
 	struct ath9k_hw_cal_data caldata;
 	int last_rssi;
 
-	int beacon_interval;
-
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
 	spinlock_t nodes_lock;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 87ba44c..1f6f899 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -226,6 +226,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ath_vif *avp;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	__le64 tstamp;
 
 	avp = (void *)vif->drv_priv;
@@ -282,7 +283,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 		u64 tsfadjust;
 		int intval;
 
-		intval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+		intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
 		/*
 		 * Calculate the TSF offset for this beacon slot, i.e., the
@@ -346,6 +347,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 void ath_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
@@ -393,7 +395,7 @@ void ath_beacon_tasklet(unsigned long data)
 	 * on the tsf to safeguard against missing an swba.
 	 */
 
-	intval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+	intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4ed43b2..ded225d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1886,6 +1886,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
@@ -1944,7 +1945,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		sc->beacon_interval = bss_conf->beacon_int;
+		cur_conf->beacon_interval = bss_conf->beacon_int;
 		/*
 		 * In case of AP mode, the HW TSF has to be reset
 		 * when the beacon interval changes.
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9f4e755..bc614ac 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1055,6 +1055,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 int ath_cabq_update(struct ath_softc *sc)
 {
 	struct ath9k_tx_queue_info qi;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	int qnum = sc->beacon.cabq->axq_qnum;
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
@@ -1066,7 +1067,7 @@ int ath_cabq_update(struct ath_softc *sc)
 	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
 		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
-	qi.tqi_readyTime = (sc->beacon_interval *
+	qi.tqi_readyTime = (cur_conf->beacon_interval *
 			    sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 

