Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbaCAURB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:01 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 09/23] ath9k_htc: sync beacon slot code with ath9k
Date: Sat,  1 Mar 2014 21:15:52 +0100
Message-Id: <1393704966-13985-10-git-send-email-linux@rempel-privat.de> (sfid-20140301_211707_064474_103E4A32)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we will need it for common-beacon

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  8 ++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 19 +++++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 707c5b4..124dfed 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -407,9 +407,17 @@ static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 #define MIN_SWBA_RESPONSE     10 /* in TUs */
 
 struct htc_beacon {
+	enum {
+		OK,		/* no change needed */
+		UPDATE,		/* update pending */
+		COMMIT		/* beacon sent, commit change */
+	} updateslot;		/* slot time update fsm */
+
 	struct ieee80211_vif *bslot[ATH9K_HTC_MAX_BCN_VIF];
 	u32 bmisscnt;
 	u32 beaconq;
+	int slottime;
+	int slotupdate;
 };
 
 struct ath_btcoex {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 4b3b4dd..8a3bd5f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -520,6 +520,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
 		priv->beacon.bslot[i] = NULL;
+	priv->beacon.slottime = ATH9K_SLOT_TIME_9;
 
 	ath9k_cmn_init_channels_rates(common);
 	ath9k_cmn_init_crypto(ah);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b82a7c4..f46cd02 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1500,6 +1500,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	int slottime;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
@@ -1575,11 +1576,21 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-			ah->slottime = 9;
+			slottime = 9;
 		else
-			ah->slottime = 20;
-
-		ath9k_hw_init_global_settings(ah);
+			slottime = 20;
+		if (vif->type == NL80211_IFTYPE_AP) {
+			/*
+			 * Defer update, so that connected stations can adjust
+			 * their settings at the same time.
+			 * See beacon.c for more details
+			 */
+			priv->beacon.slottime = slottime;
+			priv->beacon.updateslot = UPDATE;
+		} else {
+			ah->slottime = slottime;
+			ath9k_hw_init_global_settings(ah);
+		}
 	}
 
 	if (changed & BSS_CHANGED_HT)
-- 
1.9.0

