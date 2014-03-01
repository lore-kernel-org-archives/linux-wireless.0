Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55943 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAUQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:41 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 02/23] ath9k_htc: use common ath_beacon_config
Date: Sat,  1 Mar 2014 21:15:45 +0100
Message-Id: <1393704966-13985-3-git-send-email-linux@rempel-privat.de> (sfid-20140301_211645_423807_6FB476FA)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h            | 10 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 40 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  2 +-
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 3baf9ce..ed41db5 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -406,12 +406,9 @@ static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 #define DEFAULT_SWBA_RESPONSE 40 /* in TUs */
 #define MIN_SWBA_RESPONSE     10 /* in TUs */
 
-struct htc_beacon_config {
+struct htc_beacon {
 	struct ieee80211_vif *bslot[ATH9K_HTC_MAX_BCN_VIF];
-	u16 beacon_interval;
-	u16 dtim_period;
-	u16 bmiss_timeout;
-	u32 bmiss_cnt;
+	u32 bmisscnt;
 };
 
 struct ath_btcoex {
@@ -489,7 +486,8 @@ struct ath9k_htc_priv {
 	struct ath9k_hw_cal_data caldata;
 
 	spinlock_t beacon_lock;
-	struct htc_beacon_config cur_beacon_conf;
+	struct ath_beacon_config cur_beacon_conf;
+	struct htc_beacon beacon;
 
 	struct ath9k_htc_rx rx;
 	struct ath9k_htc_tx tx;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index a00ddb9..8929050 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -64,7 +64,7 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 
 
 static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
-					struct htc_beacon_config *bss_conf)
+					struct ath_beacon_config *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_beacon_state bs;
@@ -162,7 +162,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 }
 
 static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
-				       struct htc_beacon_config *bss_conf)
+				       struct ath_beacon_config *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	enum ath9k_int imask = 0;
@@ -211,13 +211,13 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
-	priv->cur_beacon_conf.bmiss_cnt = 0;
+	priv->beacon.bmisscnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
 
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
-					  struct htc_beacon_config *bss_conf)
+					  struct ath_beacon_config *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	enum ath9k_int imask = 0;
@@ -257,7 +257,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
-	priv->cur_beacon_conf.bmiss_cnt = 0;
+	priv->beacon.bmisscnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
@@ -279,7 +279,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 
 	spin_lock_bh(&priv->beacon_lock);
 
-	vif = priv->cur_beacon_conf.bslot[slot];
+	vif = priv->beacon.bslot[slot];
 
 	skb = ieee80211_get_buffered_bc(priv->hw, vif);
 
@@ -340,7 +340,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 
 	spin_lock_bh(&priv->beacon_lock);
 
-	vif = priv->cur_beacon_conf.bslot[slot];
+	vif = priv->beacon.bslot[slot];
 	avp = (struct ath9k_htc_vif *)vif->drv_priv;
 
 	if (unlikely(test_bit(OP_SCANNING, &priv->op_flags))) {
@@ -423,8 +423,8 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 	int slot;
 
 	if (swba->beacon_pending != 0) {
-		priv->cur_beacon_conf.bmiss_cnt++;
-		if (priv->cur_beacon_conf.bmiss_cnt > BSTUCK_THRESHOLD) {
+		priv->beacon.bmisscnt++;
+		if (priv->beacon.bmisscnt > BSTUCK_THRESHOLD) {
 			ath_dbg(common, BSTUCK, "Beacon stuck, HW reset\n");
 			ieee80211_queue_work(priv->hw,
 					     &priv->fatal_work);
@@ -432,16 +432,16 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 		return;
 	}
 
-	if (priv->cur_beacon_conf.bmiss_cnt) {
+	if (priv->beacon.bmisscnt) {
 		ath_dbg(common, BSTUCK,
 			"Resuming beacon xmit after %u misses\n",
-			priv->cur_beacon_conf.bmiss_cnt);
-		priv->cur_beacon_conf.bmiss_cnt = 0;
+			priv->beacon.bmisscnt);
+		priv->beacon.bmisscnt = 0;
 	}
 
 	slot = ath9k_htc_choose_bslot(priv, swba);
 	spin_lock_bh(&priv->beacon_lock);
-	if (priv->cur_beacon_conf.bslot[slot] == NULL) {
+	if (priv->beacon.bslot[slot] == NULL) {
 		spin_unlock_bh(&priv->beacon_lock);
 		return;
 	}
@@ -460,13 +460,13 @@ void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
 
 	spin_lock_bh(&priv->beacon_lock);
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++) {
-		if (priv->cur_beacon_conf.bslot[i] == NULL) {
+		if (priv->beacon.bslot[i] == NULL) {
 			avp->bslot = i;
 			break;
 		}
 	}
 
-	priv->cur_beacon_conf.bslot[avp->bslot] = vif;
+	priv->beacon.bslot[avp->bslot] = vif;
 	spin_unlock_bh(&priv->beacon_lock);
 
 	ath_dbg(common, CONFIG, "Added interface at beacon slot: %d\n",
@@ -480,7 +480,7 @@ void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
 	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *)vif->drv_priv;
 
 	spin_lock_bh(&priv->beacon_lock);
-	priv->cur_beacon_conf.bslot[avp->bslot] = NULL;
+	priv->beacon.bslot[avp->bslot] = NULL;
 	spin_unlock_bh(&priv->beacon_lock);
 
 	ath_dbg(common, CONFIG, "Removed interface at beacon slot: %d\n",
@@ -496,7 +496,7 @@ void ath9k_htc_set_tsfadjust(struct ath9k_htc_priv *priv,
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *)vif->drv_priv;
-	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &priv->cur_beacon_conf;
 	u64 tsfadjust;
 
 	if (avp->bslot == 0)
@@ -528,7 +528,7 @@ static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
 					  struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &priv->cur_beacon_conf;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	bool beacon_configured;
 
@@ -583,7 +583,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &priv->cur_beacon_conf;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *) vif->drv_priv;
 
@@ -619,7 +619,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &priv->cur_beacon_conf;
 
 	switch (priv->ah->opmode) {
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b22fb64..b8a0220 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -520,7 +520,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 		goto err_queues;
 
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
-		priv->cur_beacon_conf.bslot[i] = NULL;
+		priv->beacon.bslot[i] = NULL;
 
 	ath9k_cmn_init_channels_rates(common);
 	ath9k_cmn_init_crypto(ah);
-- 
1.9.0

