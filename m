Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54790 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbcGDMiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 08:38:05 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH v2 5/6] ath9k: Remove some #defined constants to decrease verbosity
Date: Mon,  4 Jul 2016 14:37:24 +0200
Message-Id: <1467635845-32653-5-git-send-email-benjamin@sipsolutions.net> (sfid-20160704_143814_302971_26836E26)
In-Reply-To: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
References: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

The removed ATH9K_SLOT_TIME_X constants simply map the value in microseconds
to the same integer. These constants were not used consistently, so fix the
inconsistency issue by replacing all occurances with the integer equivalent.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c         | 2 +-
 drivers/net/wireless/ath/ath9k/dynack.c         | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c             | 2 +-
 drivers/net/wireless/ath/ath9k/init.c           | 2 +-
 drivers/net/wireless/ath/ath9k/mac.h            | 4 ----
 drivers/net/wireless/ath/ath9k/main.c           | 7 ++++---
 8 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 800c96b..d8b4971 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -50,7 +50,7 @@ static void ath9k_beaconq_config(struct ath_softc *sc)
 		txq = sc->tx.txq_map[IEEE80211_AC_BE];
 		ath9k_hw_get_txq_props(ah, txq->axq_qnum, &qi_be);
 		qi.tqi_aifs = qi_be.tqi_aifs;
-		if (ah->slottime == ATH9K_SLOT_TIME_20)
+		if (ah->slottime == 20)
 			qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
 		else
 			qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index d2ff0fc..7334c9b0 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -280,7 +280,7 @@ EXPORT_SYMBOL(ath_dynack_sample_ack_ts);
 void ath_dynack_node_init(struct ath_hw *ah, struct ath_node *an)
 {
 	/* ackto = slottime + sifs + air delay */
-	u32 ackto = ATH9K_SLOT_TIME_9 + 16 + 64;
+	u32 ackto = 9 + 16 + 64;
 	struct ath_dynack *da = &ah->dynack;
 
 	an->ackto = ackto;
@@ -315,7 +315,7 @@ EXPORT_SYMBOL(ath_dynack_node_deinit);
 void ath_dynack_reset(struct ath_hw *ah)
 {
 	/* ackto = slottime + sifs + air delay */
-	u32 ackto = ATH9K_SLOT_TIME_9 + 16 + 64;
+	u32 ackto = 9 + 16 + 64;
 	struct ath_dynack *da = &ah->dynack;
 
 	da->lto = jiffies;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e6bcb4c..2c0e4d2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -45,7 +45,7 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 		 * Long slot time  : 2x cwmin
 		 * Short slot time : 4x cwmin
 		 */
-		if (ah->slottime == ATH9K_SLOT_TIME_20)
+		if (ah->slottime == 20)
 			qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
 		else
 			qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c148c6c..b65c1b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -678,7 +678,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
 		priv->beacon.bslot[i] = NULL;
-	priv->beacon.slottime = ATH9K_SLOT_TIME_9;
+	priv->beacon.slottime = 9;
 
 	ath9k_cmn_init_channels_rates(common);
 	ath9k_cmn_init_crypto(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1c27e2d..f091599 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -454,7 +454,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	if (AR_SREV_9100(ah))
 		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
 
-	ah->slottime = ATH9K_SLOT_TIME_9;
+	ah->slottime = 9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 	ah->htc_reset_init = true;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2ee8624..89654d5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -372,7 +372,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
-	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
+	sc->beacon.slottime = 9;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
 		sc->beacon.bslot[i] = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7fbf7f9..3bab014 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -65,10 +65,6 @@
 #define INIT_SSH_RETRY  32
 #define INIT_SLG_RETRY  32
 
-#define ATH9K_SLOT_TIME_6 6
-#define ATH9K_SLOT_TIME_9 9
-#define ATH9K_SLOT_TIME_20 20
-
 #define ATH9K_TXERR_XRETRY         0x01
 #define ATH9K_TXERR_FILT           0x02
 #define ATH9K_TXERR_FIFO           0x04
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f2ebc85..820df45 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -926,7 +926,7 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 	}
 
 	if (!vif->bss_conf.use_short_slot)
-		iter_data->slottime = ATH9K_SLOT_TIME_20;
+		iter_data->slottime = 20;
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -999,7 +999,7 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	eth_broadcast_addr(iter_data->mask);
-	iter_data->slottime = ATH9K_SLOT_TIME_9;
+	iter_data->slottime = 9;
 
 	list_for_each_entry(avp, &ctx->vifs, list)
 		ath9k_vif_iter(iter_data, avp->vif->addr, avp->vif);
@@ -1061,7 +1061,7 @@ static void ath9k_set_offchannel_state(struct ath_softc *sc)
 	ah->opmode = vif->type;
 	ah->imask &= ~ATH9K_INT_SWBA;
 	ah->imask &= ~ATH9K_INT_TSFOOR;
-	ah->slottime = ATH9K_SLOT_TIME_9;
+	ah->slottime = 9;
 
 	ath_hw_setbssidmask(common);
 	ath9k_hw_setopmode(ah);
@@ -1788,6 +1788,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			slottime = 9;
 		else
 			slottime = 20;
+
 		if (vif->type == NL80211_IFTYPE_AP) {
 			/*
 			 * Defer update, so that connected stations can adjust
-- 
2.8.1

